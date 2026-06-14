# PLAN Skill 参考稿

## 目的
`generate-plan-doc` 是一个专门用于生成规划文档的 Codex skill。它只负责根据仓库中的 `docs/PLAN_TEMPLATE.md` 产出完整的实施计划,不负责写代码、不负责自动落盘。

## 对应的全局 skill
- 名称: `generate-plan-doc`
- 安装位置: `$CODEX_HOME/skills/generate-plan-doc`
- 结构:

```text
generate-plan-doc/
├── SKILL.md
└── agents/
    └── openai.yaml
```

## 触发场景
- 用户要求“生成开发计划”“输出实施规划”“按模板写计划”
- 仓库中存在 `docs/PLAN_TEMPLATE.md` 或等价模板
- 需要输出可直接交给工程师或代理实现的中文规划文档

## 输入要求
- 功能目标
- 当前仓库或项目上下文
- 已知约束与关键决策
- 如需落盘,默认建议路径为 `docs/<branch>/规划-*.md`

## 输出约束
- 优先读取 `docs/PLAN_TEMPLATE.md`
- 先探索仓库和相关文件,再提问
- 输出使用中文
- 规划必须完整、决策闭环、可以直接实施
- 不越界到代码实现和文件修改

## 推荐触发语句

```text
使用 $generate-plan-doc 根据当前仓库的 PLAN_TEMPLATE.md 帮我生成这个功能的实施规划。
```

```text
请按 docs/PLAN_TEMPLATE.md 输出一份完整中文开发计划, 并结合当前代码库现状补全实现细节。
```

## 生成步骤
1. 读取 `docs/PLAN_TEMPLATE.md`
2. 查找当前分支名、相关代码和现有模式
3. 识别关键约束和未决策项
4. 在必要时提问,补齐高影响偏好
5. 输出完整规划文档

## 示例
输入:

```text
请为当前仓库新增 AI Skill Hub 桌面端功能输出一份实施计划, 参考 docs/PLAN_TEMPLATE.md。
```

输出应包含:
- 功能描述
- 用户故事
- 问题陈述与解决方案
- 上下文引用
- 实施计划与分步任务
- 测试策略、验证命令、验收标准

## 维护建议
- 如果 `docs/PLAN_TEMPLATE.md` 有更新,同步检查全局 skill 和本参考稿
- 如果不同仓库使用不同模板,优先以当前仓库模板为准
