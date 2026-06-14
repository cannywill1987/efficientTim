# ThemeManager 暗黑模式使用方法

## 适用范围

这份文档用于约束 Flutter 客户端里和主题、暗黑模式、亮色模式相关的实现方式，避免页面一部分跟随主题、一部分写死颜色，最后出现桌面端页面在暗黑模式下不可读的问题。

当前项目里主题统一入口是：

- [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/ThemeManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/ThemeManager.dart)

## 必看参考

- 主题管理器：
  - [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/ThemeManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/ThemeManager.dart)
- 持久化 key：
  - [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/config/Params.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/config/Params.dart)
- 本期已完成的桌面端参考：
  - [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart)
  - [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillCardWidget.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillCardWidget.dart)
  - [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillcommunity/SkillCommunityHomePage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillcommunity/SkillCommunityHomePage.dart)
  - [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillcommunity/SkillCommunityPostDetailPage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillcommunity/SkillCommunityPostDetailPage.dart)

## 默认规则

### 1. 不要直接假设页面永远是亮色

凡是以下场景，默认都要做暗黑和亮色两套颜色：

- 页面背景
- 卡片背景
- 文本主色 / 次色
- 输入框背景和边框
- 弹窗背景
- 分页、筛选、tab、按钮的边框与禁用态

如果只改按钮颜色，不改容器和文字颜色，暗黑模式下通常会出现：

- 深背景上深文字
- 浅卡片上浅文字
- 边框几乎看不见

### 2. 优先从 ThemeManager 判断当前模式

推荐写法：

```dart
final bool isDark = ThemeManager.getInstance().getThemeMode().isDark ||
    Theme.of(context).brightness == Brightness.dark;
```

这样做的原因：

- 先和项目已有 `ThemeManager` 保持一致
- 同时兼容 Flutter 当前上下文里的 `Theme.of(context)`
- 减少桌面端局部页面和全局主题状态不一致时的误判

### 3. 复杂页面优先抽“局部调色板”

如果页面组件很多，不要每个颜色都散在页面里。优先做：

- `bool isDark`
- 局部 palette / helper
- 或页面级别统一颜色方法

这样后续继续改分页、弹窗、tab 时，不会反复满文件找 `Color(...)`。

### 4. 功能色可以保留，但表面色必须随主题切换

像这些可以保持业务色：

- 蓝色主按钮
- 分类 icon 色
- 成功绿 / 警告橙 / 风险红

但这些必须随主题切换：

- page background
- card background
- panel border
- title color
- secondary text color
- input fill color
- disabled color

### 5. 输入框必须一起处理 hint / text / border / fill

输入框如果只改 `fillColor`，通常还是会有问题。
至少一起看：

- `fillColor`
- `hintStyle`
- `style`
- `enabledBorder`
- `focusedBorder`

## ThemeManager 当前可直接复用的方法

- `ThemeManager.getInstance().getThemeMode()`
- `ThemeManager.getInstance().setThemeMode(...)`
- `ThemeManager.getInstance().getTextStyle(...)`
- `ThemeManager.getInstance().getInputBorderColor(...)`
- `ThemeManager.getInstance().getInputPlaceholderColor(...)`
- `ThemeManager.getInstance().getInputThemeColor(...)`
- `ThemeManager.getInstance().getInputDecorationTheme(...)`

其中最常用的是：

- 判断是否暗黑：`getThemeMode().isDark`
- 获取输入框相关颜色：`getInputBorderColor / getInputPlaceholderColor / getInputThemeColor`

## 推荐实现模式

### 简单页面

```dart
final bool isDark = ThemeManager.getInstance().getThemeMode().isDark ||
    Theme.of(context).brightness == Brightness.dark;

final Color pageBg = isDark ? const Color(0xFF0F131B) : const Color(0xFFF4F5F9);
final Color cardBg = isDark ? const Color(0xFF171C26) : Colors.white;
final Color titleColor = isDark ? const Color(0xFFF5F7FB) : const Color(0xFF202533);
final Color subColor = isDark ? const Color(0xFF9AA4B8) : const Color(0xFF7A8192);
```

### 复杂桌面页

适用于 Skills / 社区这种有：

- 顶部导航
- 大卡片
- 弹窗
- Grid
- 输入框
- 分页

推荐做法：

1. 页面入口先统一 `isDark`
2. 核心大组件内部自己再用同一判断
3. 卡片、弹窗、分页按钮都统一走这一套颜色体系

## 本期实现经验

### Skills 首页

在以下位置已经按主题切换处理过：

- 页面背景渐变
- 顶部导航
- 搜索框 / 排序框
- 空状态卡片
- 分类卡片
- Skill 卡片
- Skill 详情弹窗
- 安装方式 tab
- 命令块 / 复制按钮
- 分页按钮

### 社区首页

在以下位置已经按主题切换处理过：

- 页面背景渐变
- 顶部导航
- Hero 区
- 帖子列表卡片
- 右侧侧栏卡片
- 发帖弹窗输入框

### 帖子详情页

在以下位置已经按主题切换处理过：

- 页面背景渐变
- 顶部返回栏
- 主贴卡片
- 回复输入卡片
- 回复列表卡片
- 右侧概览卡片
- 加载中卡片

## 最容易犯错的点

- 只改 Scaffold 背景，不改卡片与文本
- 弹窗背景变暗了，但按钮和文字没切换
- 输入框背景变暗了，但输入文字还是深色
- 分页按钮禁用态在暗黑模式下不可见
- 只在一个页面做暗黑，详情页和弹窗忘了同步

## 完成后最少验证

至少要验证：

- 亮色模式下文字和背景对比正常
- 暗黑模式下文字和背景对比正常
- 弹窗、输入框、分页、按钮都可读
- 顶部导航、Hero、Grid 卡片在两种模式都无明显穿帮

推荐命令：

```bash
flutter analyze lib/com/timehello/page/skillhub/SkillHubSection.dart
flutter analyze lib/com/timehello/components/skillhub/SkillCardWidget.dart
flutter analyze lib/com/timehello/page/skillcommunity/SkillCommunityHomePage.dart
flutter analyze lib/com/timehello/page/skillcommunity/SkillCommunityPostDetailPage.dart
```
