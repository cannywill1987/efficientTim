### 1.国际化方法

国际化词条的唯一源头放在 `lib/l10n/*.arb`。

生成结果会输出到 `lib/generated`，这里是产物层，不应该作为首选编辑入口。

业务代码里统一通过 [Utility.dart](/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/lib/com/timehello/util/Utility.dart) 的 `getI18NKey().xxx` 取文案，不要在页面组件里混用 `S.of(context)` 和 `getI18NKey()` 两套写法。

标准做法：

1. 先在 `lib/l10n/intl_en.arb`、`lib/l10n/intl_zh_CN.arb`、`lib/l10n/intl_zh_Hans_CN.arb` 补 key。
2. 再生成 `lib/generated/*`。
3. 最后在业务代码里通过 `getI18NKey().xxx` 使用。

这次踩坑记录：

- 误把新增国际化 key 直接补进了 `lib/generated`，没有先回写 `lib/l10n/*.arb`。
- 误在部分组件里直接使用了 `S.of(context)`，没有遵循项目里统一的 `getI18NKey().xxx` 入口。

后续规则：

- 新增或修改国际化时，先改 `lib/l10n/*.arb`，再同步生成代码。
- 如果为了紧急修复临时动过 `lib/generated`，也必须同一轮回写到 `lib/l10n/*.arb`，避免后续生成把词条冲掉。
- 如果国际化目标是 `thirdPartyPackages/AppAIPlugin` 这类 WebView/TS 组件，文案源头仍然放在 `lib/l10n/*.arb`。Flutter 外层用 `getI18NKey(context).xxx` 取值后，通过组件参数或 `setLanguage` 消息传给 Web 组件；不要在 TS 组件里重新硬编码中文，也不要维护第二套业务翻译源。

### 2.URL 与现有常量复用

项目里已经沉淀过的 H5 页面地址、接口地址、跳转地址，优先从 `Params`、`Urls`、`Apis` 这类集中配置里取，不要在业务组件里重新手写路径片段。

标准做法：

1. 先搜索是否已有现成常量，例如 `Urls.mgmHomeUrl`、`Urls.xxx`、`Params.xxx`。
2. 基础路径命中后，只在调用点补当前业务需要的 query 参数，例如 `lang`、`qd`、`cy`、`token`、`uid`。
3. 如果确实缺常量，先补到统一配置，再在业务页引用，避免多处散落硬编码。

这次踩坑记录：

- 邀请好友入口最开始手写成了 `${Params.mUrl}/mgm/home?...`，没有优先复用现成的 `Urls.mgmHomeUrl`。
- 这样做会让页面路径来源分散，后续如果 `mgm` 路由前缀调整，容易漏改。

后续规则：

- 看到完整 URL 时，先确认“基础地址是否已有常量”，再决定是否拼接。
- 页面入口统一复用已有 URL 常量，业务参数只追加，不重复定义基础路径。

### 3.语音转文字能力

录音转文字、AppAIPlugin 语音输入、语音创建任务、录音文件识别这类需求，先看：

- [语音转文字能力.md](/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/docs/知识库/语音转文字能力.md)

这次踩坑记录：

- 百炼转写结果里同时有整句文本和 `words/tokens/characters` 字级明细，不能递归拼接所有 `text` 字段，否则会出现整句后面追加“你/好/首/先”逐字换行的问题。
- AppAIPlugin 是 Web GUI，录音 UI 应该内联在输入区，真正录音交给 Flutter 宿主侧工具类，不要弹 Flutter 录音页面。
- 百炼录音文件识别需要可访问的音频 URL，本地录音文件必须先上传 OSS，并显式传 `DocType.audio` 和真实音频扩展名。
- 新增录音文案必须先写 `lib/l10n/*.arb`，再生成 `lib/generated/*`，否则 macOS 编译会报 `getter isn't defined`。

后续规则：

- 遇到语音转文字，按“本地录音 → OSS 音频 URL → 百炼异步转写 → 下载 transcription_url → 提取整句文本 → 回填业务方法”的链路实现。
- 提取百炼结果时优先 `transcripts[].text`，其次 `sentences[].text`，兜底时跳过 `words/tokens/characters`。
- AppAIPlugin 侧只做 UI 和消息发送，Flutter 侧统一管理录音、上传和转写。

### 4.BaseWidget 多端页面设计

新建页面、弹窗、工具面板、右侧抽屉或改造旧页面时，先看：

- [BaseWidget多端页面设计.md](/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/docs/知识库/BaseWidget多端页面设计.md)

这次踩坑记录：

- 改页面时容易只按当前 PC 视口做布局，忘记 Mobile 端是否需要 AppBar、SafeArea、单列滚动和触摸尺寸。
- 也容易把手机页面逻辑直接搬到 PC，导致桌面端出现不该有的 AppBar、全屏 push、错误 Navigator 或右侧面板被销毁。
- `BaseWidget` 本身已经提供 `baseMobileBuild`、`baseTabletBuild`、`baseDesktoptBuild` 和 `baseBuild` 的分发机制，不应该把整页差异都散落成 `Utility.isHandsetBySize()` 判断。

后续规则：

- 新页面必须同时说明 Mobile 和 PC 的承载方式：Mobile 是页面 push/全屏/单列，PC 是主内容区/内部详情区/右侧面板/弹窗。
- 大布局差异优先重写 `baseMobileBuild` 和 `baseDesktoptBuild`；`baseBuild` 只放共享结构或兜底内容。
- 跨端打开和关闭优先复用 `Utility.openPagePCAndMobile`、`Utility.popupPagePCAndMobile`；桌面主内容区切页用 `Utility.pushDesktopMainContainerNavigator`，内容区内部跳页用 `Utility.pushDesktopNavigator`。
- PC 端不要默认显示手机 AppBar；手机端不要忘记 SafeArea、键盘遮挡、触摸目标和滚动边界。
- 提交前至少按“Mobile + PC”两端自检一次，避免只在一个设备形态下看起来正常。


### 3.MongoDB Flutter 模型必须保留生成入口

Flutter 里的 Mongo 模型如果继承 `MongoDbObject` 并使用 `@JsonSerializable()`，必须按 `FolderModel` 的模式保留 `part 'Xxx.g.dart';`，否则后续 `build_runner` 无法生成对应的 `*.g.dart`，也容易出现模型能写但不能稳定序列化的问题。

标准做法：

1. 在模型文件顶部 import 后写 `part 'Xxx.g.dart';`，文件名必须和当前模型文件一致。
2. `factory Xxx.fromJson(Map<String, dynamic> json) => _$XxxFromJson(json);`
3. `Map<String, dynamic> toJson() => _$XxxToJson(this);`
4. `getParams()` 统一返回 `toJson()`，保证 Mongo 保存和更新复用同一套字段。
5. 新增字段后运行 `flutter pub run build_runner build --delete-conflicting-outputs` 重新生成产物。

这次踩坑记录：

- 新增 `LinkItCategoryModel` 时漏掉生成链路，虽然手写解析能临时跑，但不符合项目最终需要生成代码的模型规范。
- `LinkItThoughtModel` 新增分类字段后，生成产物没有同步补字段，后续如果切回生成式解析会丢分类。

后续规则：

- 参考 [FolderModel.dart](/Users/linzhibin/Desktop/code/LinkIt/lib/com/timehello/models/FolderModel.dart)，不要为了绕过生成失败删掉 `part`。
- 如果 `build_runner` 因本地依赖或 pub cache 失败，先记录真实失败原因；必要时可以临时补一个 generated-style 的 `*.g.dart`，但必须说明它需要在依赖修好后重新生成覆盖。
