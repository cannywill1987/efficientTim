# ShareWidget 通用分享组件使用说明

## 概述

`ShareWidget` 是一个基于 `share_plus` 插件的通用分享组件，支持分享到各种社交平台和应用，包括 Facebook、Twitter、WhatsApp、Telegram、邮件、短信等。

## 功能特性

- ✅ 支持系统原生分享
- ✅ 支持分享到社交平台（Facebook、Twitter、WhatsApp、Telegram）
- ✅ 支持邮件和短信分享
- ✅ 支持复制链接到剪贴板
- ✅ 支持分享文本、链接、图片和文件
- ✅ 支持自定义分享按钮样式
- ✅ 支持国际化
- ✅ 支持成功/失败回调

## 安装依赖

项目已经配置了 `share_plus` 依赖：

```yaml
dependencies:
  share_plus: ^7.2.1
```

## 基本使用

### 1. 简单分享

```dart
import 'package:time_hello/com/timehello/components/ShareWidget.dart';

ShareWidget(
  title: '分享标题',
  content: '这是要分享的内容',
  url: 'https://example.com',
  onShareSuccess: () {
    print('分享成功');
  },
  onShareError: (error) {
    print('分享失败: $error');
  },
)
```

### 2. 在AppBar中使用

```dart
AppBar(
  title: Text('页面标题'),
  actions: [
    ShareWidget(
      title: '分享这个页面',
      content: '这是一个很棒的应用！',
      url: 'https://example.com',
    ),
  ],
)
```

### 3. 自定义分享按钮

```dart
ShareWidget(
  title: '自定义分享',
  content: '分享内容',
  url: 'https://example.com',
  customShareButton: ElevatedButton.icon(
    onPressed: null, // ShareWidget会处理点击事件
    icon: Icon(Icons.share),
    label: Text('分享到社交平台'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  ),
)
```

### 4. 隐藏默认按钮

```dart
ShareWidget(
  title: '手动分享',
  content: '分享内容',
  url: 'https://example.com',
  showShareButton: false, // 隐藏默认按钮
)
```

## 使用ShareService

`ShareService` 提供了静态方法，可以直接调用分享功能：

### 分享文本

```dart
import 'package:time_hello/com/timehello/components/ShareWidget.dart';

await ShareService.shareText(
  text: '要分享的文本内容',
  subject: '分享主题',
);
```

### 分享链接

```dart
await ShareService.shareUrl(
  url: 'https://example.com',
  title: '分享标题',
  description: '分享描述',
);
```

### 分享图片

```dart
await ShareService.shareImage(
  imagePath: '/path/to/image.jpg',
  text: '分享的图片',
  subject: '图片分享',
);
```

### 分享多个文件

```dart
await ShareService.shareFiles(
  filePaths: [
    '/path/to/file1.pdf',
    '/path/to/file2.jpg',
    '/path/to/file3.txt',
  ],
  text: '分享多个文件',
  subject: '文件分享',
);
```

## 支持的社交平台

### Facebook
- 分享链接到Facebook
- 自动生成分享预览

### Twitter
- 分享文本到Twitter
- 支持话题标签

### WhatsApp
- 分享文本到WhatsApp
- 支持链接预览

### Telegram
- 分享链接和文本到Telegram
- 自动生成预览

### 邮件
- 通过邮件应用分享
- 支持主题和正文

### 短信
- 通过短信应用分享
- 支持文本内容

## 国际化支持

组件支持多语言，需要在国际化文件中添加以下键值：

```json
{
  "share": "分享",
  "shareTo": "分享到",
  "systemShare": "系统分享",
  "copyLink": "复制链接",
  "email": "邮件",
  "sms": "短信",
  "copiedToClipboard": "已复制到剪贴板",
  "cancel": "取消"
}
```

## 实际应用示例

### 在漫画详情页面中使用

```dart
// 在MangaDetailHeader中添加分享按钮
ElevatedButton.icon(
  onPressed: () => _showShareDialog(),
  icon: Icon(Icons.share, color: Colors.white),
  label: Text(getI18NKey().share),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
  ),
),

// 分享对话框
void _showShareDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(getI18NKey().share),
        content: SizedBox(
          width: double.maxFinite,
          child: ShareWidget(
            title: manga.title,
            content: '作者: ${manga.author}\n章节: ${manga.numchapters}\n评分: ${manga.score}',
            url: manga.link,
            imagePath: manga.picUrl,
            onShareSuccess: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('分享成功')),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(getI18NKey().cancel),
          ),
        ],
      );
    },
  );
}
```

## 注意事项

1. **权限要求**：某些平台可能需要相应的权限配置
2. **URL编码**：组件会自动处理URL编码
3. **错误处理**：建议实现 `onShareError` 回调来处理分享失败的情况
4. **平台兼容性**：不同平台的支持程度可能不同
5. **网络连接**：某些分享功能需要网络连接

## 故障排除

### 分享失败
- 检查网络连接
- 确认目标应用已安装
- 检查URL格式是否正确

### 图片分享问题
- 确认图片路径存在
- 检查文件权限
- 确认图片格式支持

### 国际化问题
- 确认国际化文件已正确配置
- 检查键值是否正确

## 更新日志

### v1.0.0
- 初始版本
- 支持基本分享功能
- 支持社交平台分享
- 支持国际化 