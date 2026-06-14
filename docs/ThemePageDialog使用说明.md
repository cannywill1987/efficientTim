# ThemePage 对话框使用说明

## 概述

在 `DialogManagement.dart` 中新增了 `showThemePageDialog` 方法，用于弹出主题设置页面对话框。

## 功能特性

- 弹出式主题设置对话框
- 包含完成按钮和取消按钮
- 支持国际化（中文：完成，英文：Done）
- 响应式设计，支持移动端和桌面端
- 主题色自适应

## 使用方法

### 基本用法

```dart
import 'package:time_hello/com/timehello/util/DialogManagement.dart';

// 显示主题设置对话框
DialogManagement.getInstance().showThemePageDialog(
  context,
  onDoneCallback: () {
    // 处理完成按钮点击事件
    print('主题设置完成');
    // 可以添加其他逻辑，比如保存设置、刷新UI等
  },
);
```

### 使用静态方法

```dart
// 使用演示方法
DialogManagement.demonstrateThemePageDialog(context);
```

## 参数说明

- `context`: BuildContext，必需的上下文参数
- `onDoneCallback`: Function?，可选的完成按钮回调函数

## 国际化支持

对话框中的按钮文本支持多语言：

- 中文：完成、取消
- 英文：Done、Cancel
- 其他语言：根据系统语言自动切换

## 样式特性

- 圆角设计（16px）
- 阴影效果
- 主题色自适应
- 响应式布局
- 移动端和桌面端不同的边距设置

## 注意事项

1. 确保 `ThemePage` 组件已正确导入
2. 对话框会自动处理关闭逻辑
3. 完成按钮点击后会先执行回调函数，然后关闭对话框
4. 支持点击外部区域关闭对话框

## 示例代码

```dart
// 在按钮点击事件中使用
ElevatedButton(
  onPressed: () {
    DialogManagement.getInstance().showThemePageDialog(
      context,
      onDoneCallback: () {
        // 主题设置完成后的处理逻辑
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('主题设置已保存')),
        );
      },
    );
  },
  child: Text('打开主题设置'),
)
```
