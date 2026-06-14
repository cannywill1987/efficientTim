# BaseWidget 多端页面设计

这份文档用于约束 Flutter 页面、弹窗、工具面板在 Mobile 和 PC 两端的设计方式。新建页面或改造旧页面时，先确认它在手机端和桌面端分别应该如何承载，不要只按当前调试设备写一套 UI。

## 核心入口

项目里的多端页面基础能力主要来自：

- `lib/com/timehello/components/BaseWidget.dart`
- `lib/com/timehello/components/ResponsiveLayout.dart`
- `lib/com/timehello/util/Utility.dart`

`BaseWidget` 负责统一页面壳、AppBar、SafeArea 和响应式 body。`ResponsiveLayout` 根据当前尺寸分发 Mobile、Tablet、Desktop。`Utility` 提供跨端打开、关闭和桌面路由方法。

标准页面结构：

```dart
class DemoPage extends BaseWidget {
  const DemoPage({super.key});

  @override
  State<StatefulWidget> getState() => _DemoPageState();
}

class _DemoPageState extends BaseWidgetState<DemoPage> {
  @override
  Widget baseBuild(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget? baseMobileBuild(BuildContext context) {
    return _buildMobile(context);
  }

  @override
  Widget? baseDesktoptBuild(BuildContext context) {
    return _buildDesktop(context);
  }
}
```

## 响应式分发规则

`BaseWidgetState.build()` 会把页面交给 `ResponsiveLayout`，实际分发规则是：

- Mobile：优先 `baseMobileBuild(context)`，为空则回退 `baseBuild(context)`。
- Tablet：优先 `baseTabletBuild(context)`，为空再尝试 `baseDesktoptBuild(context)`，仍为空才回退 `baseBuild(context)`。
- Desktop：优先 `baseDesktoptBuild(context)`，为空则回退 `baseBuild(context)`。

建议：

- `baseBuild` 放共享内容、空态或最小可复用结构。
- 手机端差异明显时重写 `baseMobileBuild`。
- PC 端差异明显时重写 `baseDesktoptBuild`。
- 平板没有独立设计时，可以自然复用 PC 或共享结构。
- 不要在一个 `baseBuild` 里堆满 `Utility.isHandsetBySize()` 分支；少量局部差异可以判断，整体布局差异应该交给 `baseMobileBuild` 和 `baseDesktoptBuild`。

## Mobile 设计规则

Mobile 页面默认是单屏纵向体验，要优先考虑手势、键盘、安全区和返回栈。

- 默认允许使用 AppBar，`isAppBarVisible = true` 只在手机端生效。
- 默认保留 SafeArea，`shouldShowSafeArea = true` 时只在手机端包裹安全区。
- 内容优先纵向堆叠，避免 PC 多列布局被强行压缩。
- 按钮、输入框、列表项要适合触摸，不能照搬 PC 的紧密工具栏。
- 弹窗类功能在手机端优先全屏或页面 push，避免小窗里继续嵌套复杂表单。
- 关闭页面优先走跨端方法，避免直接操作错误 Navigator。

## PC 设计规则

PC 页面默认是工作台体验，要优先考虑侧栏、右侧面板、多列信息密度和窗口尺寸变化。

- PC 默认不显示手机 AppBar，除非明确设置 `forceAppBarVisible = true`。
- PC 默认不需要手机 SafeArea，不要为了桌面端额外留出顶部安全区。
- 适合使用左右分栏、右侧抽屉、浮层、桌面弹窗或主内容区路由。
- 工具类、AI 面板、设置详情这类页面，优先参考项目已有 PC 右侧面板或桌面弹窗样式。
- 桌面端切页不要直接 `Navigator.push` 到手机页面栈，优先使用 `Env` 路由数据和 `Utility` 封装。
- 需要响应窗口尺寸变化时，使用 `didOnSizeChangeWidget(screenType, obj)` 做轻量刷新，不要在里面无节制发网络请求。

## AppBar 与 SafeArea

`BaseWidgetState` 提供了以下字段：

- `isAppBarVisible`：手机端是否显示 AppBar，默认 `true`。
- `forceAppBarVisible`：强制 Mobile 和 PC 都显示 AppBar，默认 `false`。
- `leftNavChildren`：AppBar 左侧控件。
- `centerNavChild`：AppBar 中间控件。
- `rightNavChildren`：AppBar 右侧控件。
- `isNavBackBtnVisible`：是否显示默认返回按钮。
- `shouldShowSafeArea`：手机端是否包裹 SafeArea，默认 `true`。

规则：

- 只有手机端需要普通导航栏时，保留 `isAppBarVisible` 即可。
- PC 上确实需要顶部栏时，再考虑 `forceAppBarVisible`。
- 沉浸式、全屏画布、录音弹窗这类页面，要明确评估 `shouldShowSafeArea`，不要让内容被系统区域或桌面窗口边缘遮挡。

## 跨端打开与关闭

页面入口优先复用 `Utility` 里的跨端方法：

- `Utility.openPagePCAndMobile(context, child: page)`：Mobile 直接 push，PC 打开桌面自定义弹窗。
- `Utility.popupPagePCAndMobile(context)`：Mobile pop，PC 关闭桌面弹窗。
- `Utility.pushDesktopMainContainerNavigator(context, page, data)`：PC 主内容区切页，包含左侧菜单结构。
- `Utility.pushDesktopNavigator(context, page, data)`：PC 内容区内部跳页，不切主菜单。
- `Utility.popupDesktopRightNavigator(context)`：关闭 PC 右侧面板，AI 面板场景会隐藏而不是销毁，避免中断流式回复。

规则：

- 跨端页面不要在业务按钮里硬写一套手机 push、一套 PC dialog，先看 `Utility` 是否已有封装。
- PC 主页面跳转用 `routerMainContainerData`，内部详情切换用 `routerData`。
- AI、设置详情、任务详情这类右侧区域，不要误用普通手机页面栈。

## 生命周期与尺寸变化

`BaseWidgetState` 中常用生命周期：

- `onCreate()`：创建时初始化状态。
- `componentDidMount()`：首帧后执行，适合依赖 context 或布局完成后的逻辑。
- `onDes()`：销毁时释放资源。
- `didOnSizeChangeWidget(screenType, obj)`：设备类型或尺寸变化时回调。

规则：

- 初始化数据优先放 `onCreate` 或 `componentDidMount`。
- 订阅、计时器、录音、流式请求等资源必须在 `onDes` 清理。
- 尺寸变化只做布局相关刷新；如果确实要触发查询，需要加缓存、去重或防抖。

## 常见错误

- 只实现 `baseBuild`，导致 PC 复杂布局在手机端被挤压，或手机列表在 PC 端显得过空。
- 在 PC 页面里强行显示手机 AppBar，造成桌面顶部重复导航。
- 在手机端关闭 PC 弹窗方法，或在 PC 端直接 `Navigator.pop`，导致关闭没反应或路由栈错乱。
- 大量散落 `Utility.isHandsetBySize()`，页面结构难维护。
- 新增页面只看 PC 截图，没有检查 Mobile 的 SafeArea、键盘遮挡、按钮尺寸和滚动。
- 新增桌面页面只 push 了 Flutter Navigator，没有同步桌面 `Env` 路由状态，导致菜单高亮和页面状态不一致。

## 提交前检查清单

- Mobile 和 PC 是否都有明确设计，不是单端顺手完成。
- 是否按 `baseMobileBuild` / `baseDesktoptBuild` 拆分了大布局差异。
- AppBar 是否只在需要的端显示。
- SafeArea 是否符合手机端真实使用。
- PC 是否使用了正确的主内容区、内部详情区或右侧面板承载方式。
- 打开和关闭是否优先复用了 `Utility.openPagePCAndMobile` / `Utility.popupPagePCAndMobile`。
- 页面尺寸变化后是否不会重查大量数据、不会丢失用户输入、不会中断进行中的任务。
