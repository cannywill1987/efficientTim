# OSS 上传方法

## 目标

这份文档用于统一说明当前项目里“文件上传 / 图片上传 / OSS 直传”的实现方式，避免以后再次出现以下问题：

- 不知道该调 `uploadOss` 还是 `uploadOSSFile`
- 误以为公共上传方法在 `Utility.dart`
- 只改前端，不知道后端接口返回结构
- 图片上传和任意文件上传混用
- 需要直传阿里云 OSS 时，不知道该走哪套封装

## 必看参考

- 接口常量：
  - [Params.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/config/Params.dart)
- 公共 HTTP 上传入口：
  - [HttpManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart)
- 上传前文件处理：
  - [Utility.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/Utility.dart)
- 阿里云直传封装：
  - [AliyunStoreManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/AliyunStoreManager.dart)
- 典型调用示例：
  - [LoginAvatarWidget.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/LoginAvatarWidget.dart)
- Egg 后台上传接口：
  - [Common.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/controller/commons/Common.js)

## 一、当前项目里有哪些上传接口

接口常量定义在 [Params.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/config/Params.dart)：

```dart
static String uploadOss = '/api/common/uploadOss'; // 上传图片
static String uploadOSSFile = '/api/common/uploadOSSFile'; // 上传文件
static String uploadOssJSON = "/api/common/uploadOssJSON"; // 上传 json 到阿里云
```

### 1. `uploadOss`

用途：

- 上传图片
- 后台会顺手生成多种尺寸

Egg 接口位置：

- [Common.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/controller/commons/Common.js)

返回结构重点：

```json
{
  "data": {
    "originImage": "原图",
    "bigImage": "大图",
    "smallImage": "小图"
  }
}
```

适合场景：

- 头像上传
- 需要缩略图 / 原图同时保留的图片类业务

### 2. `uploadOSSFile`

用途：

- 上传任意文件
- 由后台返回一个最终可访问的 OSS 文件 URL

Egg 接口位置：

- [Common.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/controller/commons/Common.js)

返回结构重点：

```json
{
  "data": "http://oss.timerbell.com/xxx"
}
```

适合场景：

- 音频
- 文档
- 压缩包
- 需要拿一个最终文件地址继续保存到业务表里的场景

### 3. `uploadOssJSON`

用途：

- 直接把 JSON 字符串上传到 OSS

适合场景：

- 配置文件
- 导出 JSON
- 结构化文本缓存

## 二、Flutter 侧真正的公共上传入口在哪里

### 结论

真正的公共上传方法不在 `Utility.dart`。  
当前项目里最通用的上传入口在 [HttpManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart)：

- `uploadFile(...)`
- `uploadImage(...)`

### 1. 通用文件上传

```dart
Future<BaseBean> uploadFile({
  String? key,
  required File file,
  required String url,
})
```

特点：

- 会处理 `file:/` 路径兼容
- 会带上：
  - `USER-TOKEN`
  - `LANGUAGE`
- 适合调用：
  - `Apis.uploadOSSFile`

推荐用途：

- 上传任意文件
- 上传需要用户登录态的文件接口

### 2. 图片上传

```dart
Future<BaseBean> uploadImage({
  String? key,
  required File file,
  required String url,
})
```

特点：

- 用 `FormData` 上传图片
- 常见调用目标：
  - `Apis.uploadOss`

典型例子见：

- [LoginAvatarWidget.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/LoginAvatarWidget.dart)

## 三、Utility.dart 在上传链路里负责什么

`Utility.dart` 不是最终上传入口，但它负责很多“上传前处理”。

当前常用方法包括：

### 1. 选图

```dart
static Future<File?> pickImage()
```

用途：

- 从相册中选择一张图片

### 2. 裁剪图片

```dart
static Future<File?> cropImage(File? imageFile)
```

用途：

- 对头像、封面图等上传前进行裁剪

### 3. 多图选择 / XFile 列表

相关方法：

- `pickMultiImageWithXFileList()`
- `pickImageWithXFileList()`
- `compressXFileList(...)`

所以更准确地说：

- `Utility.dart` 负责“选文件 / 选图 / 裁剪 / 压缩”
- `HttpManager.dart` 负责“真正调用上传接口”

## 四、推荐调用方式

### 场景 1：上传头像 / 图片

推荐链路：

1. `Utility.pickImage()`
2. `Utility.cropImage(...)`
3. `HttpManager.getInstance().uploadImage(...)`
4. 使用返回的 `smallImage` / `originImage`

参考：

- [LoginAvatarWidget.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/LoginAvatarWidget.dart)

示例：

```dart
File? file = await Utility.pickImage();
File? fileCropped = await Utility.cropImage(file);
if (fileCropped == null) return;

BaseBean baseBean = await HttpManager.getInstance().uploadImage(
  key: 'key',
  file: fileCropped,
  url: Apis.uploadOss,
);

final String? avatarUrl = baseBean.data['smallImage'];
```

### 场景 2：上传任意文件

推荐链路：

1. 拿到 `File`
2. `HttpManager.getInstance().uploadFile(...)`
3. 使用返回的文件 URL

示例：

```dart
BaseBean baseBean = await HttpManager.getInstance().uploadFile(
  key: 'record',
  file: file,
  url: Apis.uploadOSSFile,
);

final String? fileUrl = baseBean.data;
```

### 场景 3：客户端直接上传到阿里云 OSS

如果需求不是走后端 `/api/common/uploadOss` / `/api/common/uploadOSSFile`，而是客户端直接拿 STS 临时凭证上传，则走：

- [AliyunStoreManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/AliyunStoreManager.dart)

关键方法：

- `uploadFile(...)`
- `uploadFileByFilePath(...)`
- `setString(...)`

它内部会先调用：

- `Apis.getOssToken`

拿到 STS 临时凭证，再通过 `flutter_oss_aliyun` 上传。

适合场景：

- 超大文件
- 需要直传 OSS，减少业务服务器中转
- 已经明确要走阿里云 STS 上传链路

## 五、接口选择建议

### 优先级建议

#### 1. 普通图片上传

优先用：

- `Apis.uploadOss`
- `HttpManager.uploadImage(...)`

原因：

- 后台已有缩略图处理
- 现有项目已有成熟示例

#### 2. 普通文件上传

优先用：

- `Apis.uploadOSSFile`
- `HttpManager.uploadFile(...)`

原因：

- 调用简单
- 返回单个最终 URL

#### 3. 必须走 OSS 直传

才用：

- `AliyunStoreManager`

原因：

- 这条链路更重
- 依赖 STS token
- 更适合明确的大文件 / 直传需求

## 六、已知注意点

### 1. 不要再去 `Utility.dart` 里找“最终上传方法”

它主要负责：

- 选图
- 裁剪
- 压缩

真正调用上传接口的是：

- `HttpManager`

### 2. 图片上传和文件上传不要混用

- 图片类业务优先 `uploadOss`
- 任意文件优先 `uploadOSSFile`

### 3. 需要登录态时优先确认接口是否校验 token

当前代码里：

- `uploadFile()` 会在请求前设置 `USER-TOKEN`
- `uploadImage()` 当前实现里 header 设置位置比较靠后，后续如果遇到需要强校验登录态的图片上传接口，要先确认是否需要顺手修正这段实现

这不是说它现在一定不能用，而是：

- 当前头像上传链路是能跑的
- 但以后如果把 `uploadImage()` 复用到强鉴权接口，要先重新确认

## 七、以后做上传功能的固定流程

1. 先判断是“图片上传”还是“任意文件上传”
2. 先看 [Params.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/config/Params.dart) 里是否已有现成接口常量
3. 先看 [HttpManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart) 是否已有可复用公共方法
4. 如果是图片，先看 [Utility.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/Utility.dart) 是否已有选图 / 裁剪 / 压缩能力
5. 如果必须直传 OSS，再看 [AliyunStoreManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/AliyunStoreManager.dart)

## 八、强制提醒

以后出现以下需求时，先读本文档：

- “帮我做图片上传”
- “帮我做文件上传”
- “帮我接 OSS”
- “帮我上传头像 / 音频 / 文档 / 压缩包”
- “帮我找公共上传方法”

不要从零写一套上传实现，优先复用现有链路。
