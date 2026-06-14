# HttpManager HTTP请求管理器使用说明

## 概述

`HttpManager` 是一个基于 `Dio` 的单例模式 HTTP 请求管理器，提供了统一的网络请求接口，支持 GET、POST、流式请求、文件上传等功能。它自动处理认证头、语言头、错误提示、请求缓存等常见需求。

## 功能特性

- ✅ 单例模式，全局统一管理
- ✅ 支持 GET、POST 请求
- ✅ 支持流式请求（Stream Request）
- ✅ 支持文件上传（uploadFile、uploadImage）
- ✅ 支持文件内容获取（doGetFileContentRequest）
- ✅ 支持请求缓存（isCachableOn）
- ✅ 支持观察者模式（Observer）
- ✅ 支持请求取消（cancel）
- ✅ 自动添加认证头（USER-TOKEN）
- ✅ 自动添加语言和地区头（LANGUAGE、Accept-Language、COUNTRY-CODE）
- ✅ 支持自定义超时设置
- ✅ 支持错误提示（Toast）
- ✅ 支持请求回调
- ✅ 支持 Gzip 压缩
- ✅ 非生产环境自动记录请求耗时

## 获取实例

`HttpManager` 采用单例模式，通过 `getInstance()` 方法获取唯一实例：

```dart
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';

// 获取 HttpManager 实例
HttpManager httpManager = HttpManager.getInstance();
```

## 基本使用

### 1. GET 请求

```dart
// 基本 GET 请求
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {
    'userId': '123',
    'type': 'detail',
  },
);

// 检查请求结果
if (result.success) {
  // 处理成功响应
  print('请求成功: ${result.data}');
} else {
  // 处理失败响应
  print('请求失败: ${result.message}');
}
```

### 2. POST 请求

```dart
// 基本 POST 请求
BaseBean result = await HttpManager.getInstance().doPostRequest(
  '/api/user/login',
  params: {
    'username': 'user@example.com',
    'password': 'password123',
  },
);

// 检查请求结果
if (result.success) {
  // 处理成功响应
  print('登录成功: ${result.data}');
} else {
  // 处理失败响应
  print('登录失败: ${result.message}');
}
```

### 3. 流式请求（Stream Request）

流式请求适用于需要实时接收服务器推送数据的场景：

```dart
// 流式请求
String result = await HttpManager.getInstance().doStreamRequest(
  '/api/stream/data',
  params: {
    'streamId': '12345',
  },
  callback: (String res, String scene, int requestStatus) {
    // requestStatus: 0-未开始, 1-请求中, 2-请求成功, 3-请求失败
    if (requestStatus == 1) {
      print('正在接收数据: $res');
    } else if (requestStatus == 2) {
      print('接收完成: $res');
    } else if (requestStatus == 3) {
      print('接收失败: $res');
    }
  },
);
```

### 4. 文件上传

#### 上传文件（uploadFile）

```dart
import 'dart:io';

// 上传文件
File file = File('/path/to/file.pdf');
BaseBean result = await HttpManager.getInstance().uploadFile(
  file: file,
  url: '/api/upload/file',
  key: 'file', // 可选，文件字段名
);

if (result.success) {
  print('文件上传成功: ${result.data}');
} else {
  print('文件上传失败: ${result.message}');
}
```

#### 上传图片（uploadImage）

```dart
import 'dart:io';

// 上传图片
File imageFile = File('/path/to/image.jpg');
BaseBean result = await HttpManager.getInstance().uploadImage(
  file: imageFile,
  url: '/api/upload/image',
  key: 'image', // 可选，图片字段名
);

if (result.success) {
  print('图片上传成功: ${result.data}');
} else {
  print('图片上传失败: ${result.message}');
}
```

### 5. 获取文件内容

```dart
// 获取文件内容
BaseBean result = await HttpManager.getInstance().doGetFileContentRequest(
  '/api/file/content',
  params: {
    'fileId': '12345',
  },
);

if (result.success) {
  // result.data 包含文件内容
  print('文件内容: ${result.data}');
}
```

## 高级功能

### 1. 使用回调函数

```dart
// GET 请求带回调
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {'userId': '123'},
  callback: (BaseBean baseBean, String scene, bool isFromCache) {
    // baseBean: 响应数据
    // scene: 请求场景标识
    // isFromCache: 是否来自缓存
    if (isFromCache) {
      print('数据来自缓存');
    } else {
      print('数据来自网络');
    }
    print('场景: $scene, 响应: ${baseBean.data}');
  },
);
```

### 2. 启用缓存

```dart
// 启用缓存的 GET 请求
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {'userId': '123'},
  isCachableOn: true, // 启用缓存
  callback: (BaseBean baseBean, String scene, bool isFromCache) {
    if (isFromCache) {
      print('使用缓存数据');
    }
  },
);
```

### 3. 自定义超时时间

```dart
// 自定义连接和接收超时时间（单位：毫秒）
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {'userId': '123'},
  CONNECT_TIMEOUT: 10000,  // 连接超时 10 秒
  RECEIVE_TIMEOUT: 30000,  // 接收超时 30 秒
);
```

### 4. 控制错误提示

```dart
// 禁用自动错误提示
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {'userId': '123'},
  shouldShowErrorToast: false, // 不显示错误 Toast
  context: context, // 可选，用于显示 Toast
);

// 手动处理错误
if (!result.success) {
  // 自定义错误处理逻辑
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('错误'),
      content: Text(result.message ?? '请求失败'),
    ),
  );
}
```

### 5. 使用观察者模式

```dart
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';

// 创建观察者
class MyObserver extends Observer {
  @override
  void update(Observable o, dynamic arg) {
    // 处理响应数据
    print('收到响应: $arg');
  }
}

// 使用观察者
MyObserver observer = MyObserver();
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {'userId': '123'},
  observer: observer,
);
```

### 6. 取消请求

```dart
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';

// 创建观察者
MyObserver observer = MyObserver();

// 发起请求
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  params: {'userId': '123'},
  observer: observer,
);

// 取消请求
HttpManager.getInstance().cancel(observer);
```

### 7. 指定请求场景（Scene）

```dart
// 使用场景标识，便于日志追踪和统计
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/user/info',
  scene: 'USER_INFO_PAGE', // 场景标识
  params: {'userId': '123'},
);
```

### 8. 使用外部服务器

```dart
// 请求外部服务器（非本地服务器）
BaseBean result = await HttpManager.getInstance().doGetRequest(
  'https://api.example.com/data',
  isLocalServer: false, // 标识为外部服务器
  params: {'key': 'value'},
);
```

## 完整示例

### 示例 1：用户登录

```dart
Future<void> login(String username, String password) async {
  BaseBean result = await HttpManager.getInstance().doPostRequest(
    '/api/user/login',
    params: {
      'username': username,
      'password': password,
    },
    context: context,
    shouldShowErrorToast: true, // 显示错误提示
    callback: (BaseBean baseBean, String scene, bool isFromCache) {
      if (baseBean.success) {
        // 登录成功，保存用户信息
        print('登录成功: ${baseBean.data}');
      } else {
        // 登录失败
        print('登录失败: ${baseBean.message}');
      }
    },
  );
  
  if (result.success) {
    // 处理登录成功逻辑
    Navigator.pushReplacementNamed(context, '/home');
  }
}
```

### 示例 2：分页加载数据

```dart
Future<void> loadUserList(int page, int pageSize) async {
  BaseBean result = await HttpManager.getInstance().doGetRequest(
    '/api/user/list',
    params: {
      'page': page,
      'pageSize': pageSize,
    },
    scene: 'USER_LIST_PAGE',
    isCachableOn: true, // 启用缓存
    CONNECT_TIMEOUT: 15000,
    RECEIVE_TIMEOUT: 20000,
    callback: (BaseBean baseBean, String scene, bool isFromCache) {
      if (isFromCache) {
        print('使用缓存数据');
      }
      if (baseBean.success) {
        List<dynamic> userList = baseBean.data;
        // 更新 UI
        setState(() {
          users.addAll(userList);
        });
      }
    },
  );
}
```

### 示例 3：实时数据流

```dart
Future<void> subscribeToDataStream(String streamId) async {
  String result = await HttpManager.getInstance().doStreamRequest(
    '/api/stream/subscribe',
    params: {'streamId': streamId},
    scene: 'DATA_STREAM',
    callback: (String res, String scene, int requestStatus) {
      switch (requestStatus) {
        case 0:
          print('请求未开始');
          break;
        case 1:
          // 正在接收数据，实时更新 UI
          print('接收数据: $res');
          updateUI(res);
          break;
        case 2:
          // 请求成功
          print('接收完成: $res');
          break;
        case 3:
          // 请求失败
          print('接收失败: $res');
          showError(res);
          break;
      }
    },
  );
}
```

### 示例 4：文件上传带进度

```dart
Future<void> uploadUserAvatar(File imageFile) async {
  BaseBean result = await HttpManager.getInstance().uploadImage(
    file: imageFile,
    url: '/api/user/avatar',
    key: 'avatar',
  );
  
  if (result.success) {
    // 上传成功，更新用户头像
    String avatarUrl = result.data['avatarUrl'];
    setState(() {
      userAvatar = avatarUrl;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('头像上传成功')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('头像上传失败: ${result.message}')),
    );
  }
}
```

## 参数说明

### doGetRequest / doPostRequest 参数

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `url` | `dynamic` | ✅ | - | 请求 URL，可以是相对路径或完整 URL |
| `scene` | `String?` | ❌ | `null` | 请求场景标识，用于日志和统计 |
| `params` | `Map<String, dynamic>` | ❌ | `{}` | 请求参数 |
| `isLocalServer` | `bool` | ❌ | `true` | 是否为本地服务器 |
| `context` | `BuildContext?` | ❌ | `null` | 用于显示 Toast 的上下文 |
| `observer` | `Observer?` | ❌ | `null` | 观察者对象，用于接收响应 |
| `isCachableOn` | `bool` | ❌ | `false` | 是否启用缓存 |
| `CONNECT_TIMEOUT` | `int?` | ❌ | `Params.CONNECT_TIMEOUT` | 连接超时时间（毫秒） |
| `RECEIVE_TIMEOUT` | `int?` | ❌ | `Params.RECEIVE_TIMEOUT` | 接收超时时间（毫秒） |
| `shouldShowErrorToast` | `bool` | ❌ | `true` | 是否显示错误 Toast |
| `callback` | `OnHttpResponseListener?` | ❌ | `null` | 响应回调函数 |

### doStreamRequest 参数

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `url` | `dynamic` | ✅ | - | 请求 URL |
| `scene` | `String?` | ❌ | `null` | 请求场景标识 |
| `params` | `Map<String, dynamic>` | ❌ | `{}` | 请求参数 |
| `isLocalServer` | `bool` | ❌ | `true` | 是否为本地服务器 |
| `context` | `BuildContext?` | ❌ | `null` | 用于显示 Toast 的上下文 |
| `observer` | `Observer?` | ❌ | `null` | 观察者对象 |
| `isCachableOn` | `bool` | ❌ | `false` | 是否启用缓存 |
| `CONNECT_TIMEOUT` | `int?` | ❌ | `Params.CONNECT_TIMEOUT` | 连接超时时间（毫秒） |
| `RECEIVE_TIMEOUT` | `int?` | ❌ | `Params.RECEIVE_TIMEOUT` | 接收超时时间（毫秒） |
| `shouldShowErrorToast` | `bool` | ❌ | `true` | 是否显示错误 Toast |
| `callback` | `OnStreamResponseListener?` | ❌ | `null` | 流式响应回调函数 |

### uploadFile / uploadImage 参数

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `file` | `File` | ✅ | - | 要上传的文件 |
| `url` | `String` | ✅ | - | 上传接口 URL |
| `key` | `String?` | ❌ | `null` | 文件字段名 |

## 响应数据结构

所有请求方法（除流式请求）都返回 `BaseBean` 对象：

```dart
class BaseBean {
  final bool success;      // 请求是否成功
  String? code;            // 响应代码
  String? message;         // 响应消息
  dynamic? data;          // 响应数据
  int? sysTime;           // 服务器时间
}
```

### 响应处理示例

```dart
BaseBean result = await HttpManager.getInstance().doGetRequest('/api/data');

// 检查请求是否成功
if (result.success) {
  // 处理成功情况
  if (result.data != null) {
    // 使用响应数据
    print('数据: ${result.data}');
  }
} else {
  // 处理失败情况
  print('错误代码: ${result.code}');
  print('错误消息: ${result.message}');
}
```

## 自动添加的请求头

`HttpManager` 会自动为所有请求添加以下请求头：

- `USER-TOKEN`: 用户认证令牌（从 `LoginManager` 获取）
- `LANGUAGE`: 设备语言（从 `DeviceInfoManagement` 获取）
- `Accept-Language`: 接受的语言（从 `DeviceInfoManagement` 获取）
- `COUNTRY-CODE`: 国家代码（从 `DeviceInfoManagement` 获取）
- `accept-encoding`: `gzip, deflate`（支持 Gzip 压缩）

## 注意事项

1. **单例模式**：`HttpManager` 是单例，使用 `getInstance()` 获取实例，不要直接创建对象。

2. **URL 格式**：
   - 如果 URL 以 `http` 开头，将直接使用该 URL
   - 否则会自动拼接 `Params.mBaseUrl`

3. **iOS 文件路径**：上传文件时，如果文件路径包含 `file:/` 前缀，会自动处理（iOS 特殊处理）。

4. **缓存机制**：
   - 缓存功能需要 `Params.isHttpCacheOn` 为 `true` 才会生效
   - 缓存键由 URL + 参数组成

5. **错误处理**：
   - 默认会显示错误 Toast
   - 可以通过 `shouldShowErrorToast: false` 禁用自动提示
   - 建议在回调函数中处理业务逻辑

6. **超时设置**：
   - 默认超时时间在 `Params` 中配置
   - 可以通过参数自定义每个请求的超时时间

7. **观察者模式**：
   - 使用观察者时，记得在适当时机调用 `cancel()` 取消请求
   - 页面销毁时建议取消未完成的请求

8. **流式请求**：
   - 流式请求的回调会在数据接收过程中多次调用
   - `requestStatus` 参数表示请求状态：0-未开始，1-请求中，2-请求成功，3-请求失败

9. **性能监控**：
   - 非生产环境会自动记录请求耗时
   - 可以通过日志查看每个请求的执行时间

## 故障排除

### 请求超时

```dart
// 增加超时时间
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/data',
  CONNECT_TIMEOUT: 60000,  // 60 秒
  RECEIVE_TIMEOUT: 60000,  // 60 秒
);
```

### 请求失败但无错误提示

```dart
// 确保传入 context 参数
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/data',
  context: context, // 必须传入 context 才能显示 Toast
  shouldShowErrorToast: true,
);
```

### 文件上传失败

```dart
// 检查文件是否存在
File file = File('/path/to/file');
if (await file.exists()) {
  BaseBean result = await HttpManager.getInstance().uploadFile(
    file: file,
    url: '/api/upload',
  );
} else {
  print('文件不存在');
}
```

### 缓存不生效

```dart
// 确保 Params.isHttpCacheOn 为 true
// 并且 isCachableOn 参数为 true
BaseBean result = await HttpManager.getInstance().doGetRequest(
  '/api/data',
  isCachableOn: true, // 必须设置为 true
);
```

## 最佳实践

1. **统一错误处理**：建议在应用层面统一处理错误，而不是在每个请求中单独处理。

2. **使用场景标识**：为每个请求设置有意义的 `scene` 参数，便于日志追踪和问题排查。

3. **合理使用缓存**：对于不经常变化的数据，启用缓存可以提高性能。

4. **及时取消请求**：页面销毁时记得取消未完成的请求，避免内存泄漏。

5. **超时时间设置**：根据实际业务需求设置合理的超时时间，避免用户等待过久。

6. **流式请求处理**：流式请求的回调会在数据接收过程中多次调用，注意处理中间状态。

## 相关类说明

- `HttpTask`: 实际执行 HTTP 请求的任务类
- `BaseBean`: 统一的响应数据结构
- `Observer`: 观察者接口，用于接收响应通知
- `Observable`: 可观察对象基类
- `Params`: 全局配置参数

## 更新日志

### v1.0.0
- 初始版本
- 支持 GET、POST 请求
- 支持流式请求
- 支持文件上传
- 支持请求缓存
- 支持观察者模式
- 自动添加认证和语言头

