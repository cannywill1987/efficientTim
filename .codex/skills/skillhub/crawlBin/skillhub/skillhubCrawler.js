'use strict';

const fs = require('fs');
const path = require('path');
const axios = require('axios');
const cheerio = require('cheerio');
const mongoose = require('mongoose');

// 当前脚本位于 egg/crawlBin/skillhub/，回到项目根目录只需要两层。
const loadEnvLocal = require('../../lib/loadEnvLocal');
const connectionConfig = require('../../config/connectionConfig');
const sources = require('./sources');
const {
  normalizeSkillItem,
  mergePreferNonEmpty,
  slugify,
} = require('./skillhubNormalize');

loadEnvLocal();

const logDir = path.join(__dirname, '..', 'logs');
const logFile = path.join(
  logDir,
  `skillhub_crawl_${new Date().toISOString().replace(/[:.]/g, '-')}.log`
);

const requestConfig = {
  timeout: 30000,
  headers: {
    'User-Agent': 'Mozilla/5.0 SkillHubCrawler/1.0',
    Accept: 'text/html,application/xhtml+xml,application/json',
  },
};

// 首页本身只是前端壳，真实技能数据来自 bundle 中引用的 skills.*.json。
const BUNDLE_PATTERN = /https?:\/\/[^"' )]+skill-hub\.[^"' )]+\.js\?max_age=\d+/;
const JSON_PATTERN = /https?:\/\/[^"' )]+\/skills\.[^"' )]+\.json\?max_age=\d+/;

const skillSchema = new mongoose.Schema(
  {
    name: String,
    slug: String,
    description: String,
    icon: String,
    repoUrl: String,
    downloadUrl: String,
    tags: [ String ],
    source: String,
    sourceId: String,
    homepage: String,
    readmeSummary: String,
    installHints: mongoose.Schema.Types.Mixed,
    status: String,
    crawlVersion: String,
    createdAt: Number,
    updatedAt: Number,
    lastCrawledAt: Number,
  },
  {
    versionKey: false,
    collection: 'skill_items',
  }
);
skillSchema.index({ slug: 1, source: 1 }, { unique: true });

const SkillItemModel =
  mongoose.models.SkillItemModel ||
  mongoose.model('SkillItemModel', skillSchema);

function ensureLogDir() {
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }
}

function writeLog(message) {
  ensureLogDir();
  const line = `[${new Date().toISOString()}] ${message}\n`;
  fs.appendFileSync(logFile, line);
  console.log(message);
}

function repoToDownloadUrl(repoUrl = '') {
  if (!repoUrl.includes('github.com/')) return '';
  return `${repoUrl.replace(/\/$/, '')}/archive/refs/heads/main.zip`;
}

async function resolveTencentSkillJsonUrl(source) {
  const pageResponse = await axios.get(source.url, requestConfig);
  const bundleMatch = pageResponse.data.match(BUNDLE_PATTERN);
  if (!bundleMatch) {
    throw new Error('Unable to resolve skill-hub bundle URL');
  }

  const bundleResponse = await axios.get(bundleMatch[0], requestConfig);
  const jsonMatch = bundleResponse.data.match(JSON_PATTERN);
  if (!jsonMatch) {
    throw new Error('Unable to resolve skills JSON URL');
  }
  return jsonMatch[0];
}

async function fetchSource(source) {
  if (source.type === 'tencent-skillhub') {
    // 当前爬虫明确只实现腾讯 SkillHub 这一条数据源。
    const jsonUrl = await resolveTencentSkillJsonUrl(source);
    writeLog(`Resolved Tencent SkillHub JSON: ${jsonUrl}`);
    const jsonResponse = await axios.get(jsonUrl, requestConfig);
    const payload = jsonResponse.data || {};
    const featuredSet = new Set(payload.featured || []);
    const categoryMap = payload.categories || {};
    const list = Array.isArray(payload.skills) ? payload.skills : [];

    return list.map(item => {
      const tags = Array.isArray(item.tags) ? item.tags : [];
      // 按站点 categories 反推中文分类，方便桌面端直接展示。
      const categories = Object.keys(categoryMap).filter(categoryName => {
        const categoryTags = Array.isArray(categoryMap[categoryName])
          ? categoryMap[categoryName]
          : [];
        return tags.some(tag => categoryTags.includes(tag));
      });
      const downloadUrl = (source.downloadUrlTemplate || '')
        .replace('{slug}', item.slug || '');
      return normalizeSkillItem({
        id: item.slug,
        source: source.source,
        sourceId: item.slug,
        name: item.name,
        slug: item.slug,
        description: item.description_zh || item.description,
        icon: item.icon || '',
        repoUrl: item.homepage || '',
        downloadUrl,
        tags: [ ...tags, ...categories, ...(featuredSet.has(item.slug) ? [ 'featured' ] : []) ],
        homepage: item.homepage || source.homepage,
        owner: item.owner || '',
        downloads: item.downloads || 0,
        stars: item.stars || 0,
        installs: item.installs || 0,
        score: item.score || 0,
        readmeSummary: item.description_zh || item.description,
        installHints: {
          sourceSite: source.url,
          featured: featuredSet.has(item.slug),
          version: item.version || '',
        },
        // 站点字段是 updated_at，这里统一成我们自己的 updatedAt。
        updatedAt: Number(item.updated_at || Date.now()),
      });
    });
  }
  return [];
}

async function upsertSkill(skill) {
  const existing = await SkillItemModel.findOne({
    slug: skill.slug,
    source: skill.source,
  }).lean();
  const payload = existing ? mergePreferNonEmpty(existing, skill) : skill;
  // 用 slug + source 做稳定 upsert，保证重复抓取不会插入重复记录。
  await SkillItemModel.findOneAndUpdate(
    { slug: payload.slug, source: payload.source },
    { $set: payload },
    { upsert: true, new: true }
  );
}

async function markInactive(activeKeys) {
  const all = await SkillItemModel.find({}, { slug: 1, source: 1 }).lean();
  const inactiveKeys = all
    .map(item => `${item.slug}::${item.source}`)
    .filter(key => !activeKeys.has(key));
  if (inactiveKeys.length === 0) return 0;
  const conditions = inactiveKeys.map(key => {
    const [ slug, source ] = key.split('::');
    return { slug, source };
  });
  const result = await SkillItemModel.updateMany(
    { $or: conditions },
    {
      $set: {
        status: 'inactive',
        updatedAt: Date.now(),
      },
    }
  );
  return result.modifiedCount || 0;
}

async function main() {
  await mongoose.connect(connectionConfig.mongoose.url, connectionConfig.mongoose.options);
  writeLog(`SkillHub crawler started. Sources=${sources.length}`);

  const activeKeys = new Set();
  let success = 0;
  let failed = 0;
  const failureReasons = [];

  for (const source of sources) {
    try {
      const skills = await fetchSource(source);
      for (const skill of skills) {
        await upsertSkill(skill);
        activeKeys.add(`${skill.slug}::${skill.source}`);
        success += 1;
      }
      writeLog(`OK ${source.id} -> ${skills.length} skills`);
    } catch (error) {
      failed += 1;
      failureReasons.push(`${source.id}: ${error.message}`);
      writeLog(`FAIL ${source.id}: ${error.message}`);
    }
  }

  const inactiveCount = await markInactive(activeKeys);
  writeLog(
    `Summary total=${sources.length} success=${success} failed=${failed} inactive=${inactiveCount}`
  );
  if (failureReasons.length > 0) {
    writeLog(`Failures: ${failureReasons.join(' | ')}`);
  }
  await mongoose.disconnect();
}

if (require.main === module) {
  main()
    .then(() => process.exit(0))
    .catch(error => {
      writeLog(`Crawler crashed: ${error.stack || error.message}`);
      process.exit(1);
    });
}

module.exports = {
  main,
};
