'use strict';

module.exports = app => {
  const mongoose = app.mongoose;
  const { Schema } = mongoose;

  // 模型名保持 SkillItemModel，兼容 EggJS 当前通用 Mongo 路由；
  // 真实 collection 显式绑定到 skill_items。
  const SkillItemSchema = new Schema(
    {
      name: { type: String, default: '' },
      slug: { type: String, default: '', index: true },
      description: { type: String, default: '' },
      icon: { type: String, default: '' },
      repoUrl: { type: String, default: '' },
      downloadUrl: { type: String, default: '' },
      tags: { type: [ String ], default: [] },
      source: { type: String, default: '', index: true },
      sourceId: { type: String, default: '' },
      homepage: { type: String, default: '' },
      owner: { type: String, default: '' },
      downloads: { type: Number, default: 0 },
      stars: { type: Number, default: 0 },
      installs: { type: Number, default: 0 },
      score: { type: Number, default: 0 },
      readmeSummary: { type: String, default: '' },
      installHints: { type: Schema.Types.Mixed, default: {} },
      status: { type: String, default: 'active', index: true },
      crawlVersion: { type: String, default: 'v1' },
      createdAt: { type: Number, default: 0 },
      updatedAt: { type: Number, default: 0, index: true },
      lastCrawledAt: { type: Number, default: 0 },
    },
    {
      versionKey: false,
      collection: 'skill_items',
    }
  );

  SkillItemSchema.index({ slug: 1, source: 1 }, { unique: true });
  // Flutter 默认按 active + updatedAt 拉列表，因此补对应索引。
  SkillItemSchema.index({ status: 1, updatedAt: -1 });
  SkillItemSchema.index({ tags: 1 });

  return mongoose.model('SkillItemModel', SkillItemSchema);
};
