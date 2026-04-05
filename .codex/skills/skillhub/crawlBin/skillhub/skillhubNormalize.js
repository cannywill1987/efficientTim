'use strict';

// 把各种来源里的 name / repoName / id 统一压成适合目录名和查询的 slug。
function slugify(input) {
  const normalized = String(input || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-+/g, '-');
  return normalized || 'skill-item';
}

// 标准化时统一采用“新值非空优先，否则沿用旧值”的策略。
function nonEmpty(next, prev = '') {
  return String(next || '').trim() || String(prev || '').trim();
}

// 标签去重并清洗空值，避免前台出现重复 tag。
function uniqueTags(tags = []) {
  return Array.from(
    new Set(
      tags
        .map(item => String(item || '').trim())
        .filter(Boolean)
    )
  );
}

// 把原始抓取结果映射成 skill_items 的统一结构。
function normalizeSkillItem(raw = {}) {
  const now = Date.now();
  const repoUrl = nonEmpty(raw.repoUrl);
  const source = nonEmpty(raw.source, 'community');
  const name = nonEmpty(raw.name, raw.repoName || raw.id || raw.sourceId);
  const slug = slugify(raw.slug || raw.repoName || raw.name || raw.id || raw.sourceId);
  const tags = uniqueTags([ ...(raw.tags || []), source ]);

  return {
    name,
    slug,
    description: nonEmpty(raw.description),
    icon: nonEmpty(raw.icon),
    repoUrl,
    downloadUrl: nonEmpty(raw.downloadUrl),
    tags,
    source,
    sourceId: nonEmpty(raw.sourceId, raw.id || slug),
    homepage: nonEmpty(raw.homepage, repoUrl),
    owner: nonEmpty(raw.owner),
    downloads: Number(raw.downloads || 0),
    stars: Number(raw.stars || 0),
    installs: Number(raw.installs || 0),
    score: Number(raw.score || 0),
    readmeSummary: nonEmpty(raw.readmeSummary, raw.description),
    installHints: raw.installHints || {},
    // 新抓到的记录默认标 active；失效数据由 crawler 统一回收成 inactive。
    status: nonEmpty(raw.status, 'active'),
    crawlVersion: nonEmpty(raw.crawlVersion, 'v1'),
    createdAt: Number(raw.createdAt || now),
    updatedAt: Number(raw.updatedAt || now),
    lastCrawledAt: Number(raw.lastCrawledAt || now),
  };
}

function mergePreferNonEmpty(previous = {}, next = {}) {
  // 重复抓取时优先保留非空的新值，避免把旧的高质量字段刷成空。
  return {
    ...previous,
    ...next,
    name: nonEmpty(next.name, previous.name),
    description: nonEmpty(next.description, previous.description),
    icon: nonEmpty(next.icon, previous.icon),
    repoUrl: nonEmpty(next.repoUrl, previous.repoUrl),
    downloadUrl: nonEmpty(next.downloadUrl, previous.downloadUrl),
    homepage: nonEmpty(next.homepage, previous.homepage),
    owner: nonEmpty(next.owner, previous.owner),
    downloads: Number(next.downloads || previous.downloads || 0),
    stars: Number(next.stars || previous.stars || 0),
    installs: Number(next.installs || previous.installs || 0),
    score: Number(next.score || previous.score || 0),
    readmeSummary: nonEmpty(next.readmeSummary, previous.readmeSummary),
    tags: uniqueTags([ ...(previous.tags || []), ...(next.tags || []) ]),
    updatedAt: Number(next.updatedAt || Date.now()),
    lastCrawledAt: Number(next.lastCrawledAt || Date.now()),
  };
}

module.exports = {
  slugify,
  normalizeSkillItem,
  mergePreferNonEmpty,
};
