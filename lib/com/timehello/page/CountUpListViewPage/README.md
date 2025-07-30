# 纪念日功能 (CountUpListViewPage)

## 功能概述

纪念日功能允许用户创建从指定开始时间开始的纪念日任务，用于记录某个重要事件或纪念日已经持续了多长时间。

## 主要组件

### 1. 模型 (Models)
- `StartTimeMissionModel`: 纪念日任务的数据模型
- `Countup`: 简单的纪念日模型

### 2. 页面组件 (Pages)
- `CountUpListViewPage`: 纪念日列表页面
- `CreateStartTimePage`: 创建纪念日页面

### 3. 列表组件 (List Components)
- `CountUpListView`: 纪念日列表视图
- `CountupItem`: 单个纪念日项目
- `CountUpTextWidget`: 纪念日文本显示组件

## 功能特性

### 创建纪念日
- 用户可以创建新的纪念日任务
- 设置任务标题和描述
- 选择开始时间
- 支持编辑和删除现有任务

### 纪念日显示
- 实时显示从开始时间到当前时间的持续时间
- 格式：天:时:分:秒
- 支持多语言显示

### 任务管理
- 完成任务功能
- 编辑任务信息
- 删除任务
- 侧滑操作支持

## 使用方法

### 1. 导航到纪念日页面
```dart
Utility.openPagePCAndMobile(context, child: CountUpListViewPage(pageFromEnum: PageFromEnum.Normal));
```

### 2. 创建新的纪念日任务
```dart
Utility.openPagePCAndMobile(context, child: CreateStartTimePage());
```

### 3. 编辑现有任务
```dart
Utility.openPagePCAndMobile(context, child: CreateStartTimePage(missionModel: existingModel));
```

## 数据库操作

### 查询任务
```dart
await MongoApisManager.getInstance().queryWhereEqual_StartTimeMissionModel();
```

### 创建任务
```dart
await MongoApisManager.getInstance().insertStartTimeMissionModel(missionModel: model);
```

### 更新任务
```dart
await MongoApisManager.getInstance().update_StartTimeMissionModel(missionModel: model);
```

### 删除任务
```dart
await MongoApisManager.getInstance().delete_StartTimeMissionModel(currentObjectId: objectId);
```

### 完成任务
```dart
await MongoApisManager.getInstance().finishStartTimeMissionModel(missionModel: model);
```

## 多语言支持

纪念日功能支持以下多语言显示：
- 中文：`{day}天 {hour}:{mins}:{secs}`
- 英文：`{day} days {hour}:{mins}:{secs}`
- 日文：`{day}日 {hour}:{mins}:{secs}`
- 韩文：`{day}일 {hour}:{mins}:{secs}`
- 德文：`{day} Tage {hour}:{mins}:{secs}`
- 法文：`{day} jours {hour}:{mins}:{secs}`

## 与倒计时的区别

| 特性 | 倒计时 (CountDown) | 纪念日 (CountUp) |
|------|-------------------|------------------|
| 时间计算 | 目标时间 - 当前时间 | 当前时间 - 开始时间 |
| 用途 | 等待某个时间点 | 记录持续时间 |
| 状态显示 | 倒计时/已结束 | 纪念日/未开始 |
| 模型字段 | `end_time` | `start_time` |

## 注意事项

1. 纪念日任务需要设置有效的开始时间
2. 任务完成后会停止计时
3. 支持重复任务设置
4. 与倒计时功能完全独立，可以同时使用 