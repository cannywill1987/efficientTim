/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/beans/UserInfoBean.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'FolderModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class FolderModel extends MongoDbObject {
  String? originalFolderId; // 从courseModel引用进来需要这个id
  String? courseModelId; // 课程id
  int? layoutType = 0; //布局类型 0 列表 1 group分组 2 时间线
  int? order_index;
  String? title = ''; //标题
  String? description; //描述
  String? device_id; //设备id 用于没用登录时的搜索
  int? number;
  String? uid;
  Map<String, dynamic>? _userInfo; // 管理员信息 用于私有模式别的用户加入
  @JsonKey(ignore: true)
  UserInfoBean? userInfoBean; // 管理员信息 用于私有模式别的用户加入
  String? noteUrl; //笔记url
  String? timelineNoteObjectId; //笔记objectId
  int? numberNoteWords; //笔记字数
  int? start_time; //todo 开始时间
  int?
      end_time; //设置的预期完成时间 默认空是0 isFinished = false 计划到期日 isFinished = true 实际到期日
  int? update_time;
  int? create_time;
  int? tag; //1-表示各种图案circle mission;2-表示的是 tag; 3-代表文件夹;null-今天 明天 即将到来 4-过滤器 5-目标模块
  int color = 0;
  int? tagColor;
  int? icon = 0; //左侧图标
  // bool hasTag = false; //是否有标签
  String? tagName; //标签名称
  int? type; //用于展示 不用于存储 2-今天 明天 即将到来等 3-创建清单
  int? iconType =
      0; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他 9 现在做 Do it now 12 待定任务 13 碎片清单 14 苹果安卓日历 15 苹果提醒
  List<String>? groupModelObjectIdOrderList = []; //用于groumodel objectId的排序
  String? folderTeamWorkId; // 群id 用于添加文件夹共享
  String? introText; // 群id 用于添加文件夹共享
  String? groupChatPassword; // 群密码

  // List? adminUids = []; //管理员
  // List? _adminUserInfo = []; //用于私有模式别的用户加入 {"uid": LoginManager.getInstance().userBean.uid, "avatar": LoginManager.getInstance().userBean.avatar, "username": LoginManager.getInstance().userBean.username, "numTomatoesFcoused":0,"numTasksDone": 0, "totalDurationFocus": 0, "onlineStatus": 0}
  // @JsonKey(ignore: true)
  // List<UserInfoBean>? adminUserInfoBean = []; //用于私有模式别的用户加入

  List? otherUids = []; //用于私有模式别的用户加入
  List? _otherUserInfo = []; //用于私有模式别的用户加入 {"uid": LoginManager.getInstance().userBean.uid, "avatar": LoginManager.getInstance().userBean.avatar, "username": LoginManager.getInstance().userBean.username, "numTomatoesFcoused":0,"numTasksDone": 0, "totalDurationFocus": 0, "onlineStatus": 0}
  @JsonKey(ignore: true)
  List<UserInfoBean>? otherUserInfoBean = []; //用于私有模式别的用户加入
  bool? isOtherUserEditable =
      false; //isSharring = 1 时才用上 因为这时otherUids也是可以共同编辑 folderModel的状态的
  int? isSharing = 0;  //0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
  int? folderStatus = 0; //0 未归档 1 归档
  int? cryptoVersion = -1; // -1代表没有设置加密 0代表设置了加密版本
  // bool? isFoldedForFolder = false; //是否折叠 如果tag是3
  List<String>? folderModelObjectIdOrderList =
      []; //当folderModel代表文件夹时 用于folderModel objectId的排序
  int? filterType = 0; // 0 - 没有过滤 1 - 过滤
  Map<String, dynamic>? _filterConditionMap; //{priority: [0, 1, 2, 3], keyword: '', missionType: 1, startTime: 0, endTime:  1000, listingId: [string, string, string]}
  @JsonKey(ignore: true)
  FilterConditionBean? _filterConditionMapBean; //{value: 1, unit: 0-days 1-hours 2-minutes,priority: [0, 1, 2, 3], keyword: '', missionType: 1, startTime: 0, endTime:  1000, listingId: [string, string, string]}
  @JsonKey(ignore: true)
  OnlineStatusEnum? onlineStatusEnum;


  @JsonKey(ignore: true)
  set filterConditionMapBean(FilterConditionBean? value) {
    _filterConditionMapBean = value;
    if(value != null)
    _filterConditionMap = value?.toJson();
  }

  @JsonKey(ignore: true)
  FilterConditionBean? get filterConditionMapBean {
    if (_filterConditionMapBean == null) {
      _filterConditionMapBean = FilterConditionBean.fromJson(_filterConditionMap ?? {});
    }
    return _filterConditionMapBean;
  }

  set userInfo(Map<String, dynamic>? value) {
    _userInfo = value;
    userInfoBean = UserInfoBean.fromJson(value ?? {});
    userInfoBean?.onlineStatusEnum =
        OnlineStatusEnum.values[userInfoBean?.onlineStatus ?? 0];
  }

  Map<String, dynamic>? get userInfo {
    return _userInfo;
  }

  // set adminUserInfo(List? value) {
  //   _adminUserInfo = value;
  //   adminUserInfoBean = [];
  //   _adminUserInfo?.forEach((element) {
  //     UserInfoBean userInfoBean = UserInfoBean.fromJson(element);
  //     userInfoBean.onlineStatusEnum = OnlineStatusEnum.values[userInfoBean.onlineStatus ?? 0];
  //     adminUserInfoBean?.add(userInfoBean);
  //   });
  //   // adminUserInfoBean = value;
  // }
  //
  // List? get adminUserInfo {
  //   return _adminUserInfo;
  // }

  //{priority: [0, 1, 2, 3], keyword: '', missionType: 1, startTime: 0, endTime:  1000, listingId: [string, string, string]}
  set filterConditionMap(Map<String, dynamic>? value) {
    if(value != null) {
      _filterConditionMap = value;
      _filterConditionMapBean = FilterConditionBean.fromJson(value ?? {});
    }
  }

  Map<String, dynamic>? get filterConditionMap {
    return _filterConditionMap;
  }

  set otherUserInfo(List? value) {
    _otherUserInfo = value;
    otherUserInfoBean = [];
    _otherUserInfo?.forEach((element) {
      UserInfoBean userInfoBean = UserInfoBean.fromJson(element);
      userInfoBean.onlineStatusEnum = OnlineStatusEnum.values[userInfoBean.onlineStatus ?? 0];
      otherUserInfoBean?.add(userInfoBean);
    });
    // otherUserInfoBean = value;
  }

  List? get otherUserInfo {
    return _otherUserInfo;
  }

  @JsonKey(ignore: true)
  bool? _isFoldedForFolderCached = false; //是否折叠 如果tag是3

  @JsonKey(ignore: true)
  set isFoldedForFolderCached(bool value) {
    if (!TextUtil.isEmpty(this.objectId)) {
      SharePreferenceUtil.getSyncInstance()
          .setBool(key: this.objectId ?? "", val: value);
    }
    _isFoldedForFolderCached = value;
  }

  @JsonKey(ignore: true)
  bool get isFoldedForFolderCached {
    if (TextUtil.isEmpty(this.objectId)) {
      return false;
    }
    _isFoldedForFolderCached = SharePreferenceUtil.getSyncInstance()
        .getBool(key: this.objectId ?? "", defaultVal: false);
    return _isFoldedForFolderCached ?? false;
  }

  // BmobUser author;
  FolderModel();

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FolderModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

// Person({this.firstName, this.lastName, this.dateOfBirth});
// factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
// Map<String, dynamic> toJson() => _$PersonToJson(this);
}

// {priority: [0, 1, 2, 3], keyword: '', missionType: 1, startTime: 0, endTime:  1000, listingId: [string, string, string]}
@JsonSerializable(nullable: false)
class FilterConditionBean {
  List<int>? priority; // 0, 1, 2, 3
  String? keyword;
  int? missionType;
  int? startTime;
  int? endTime;
  int? dateType; // 1-今天 2 明天 3 本周 4 自定义(n天前) 5 自定义(时间段) 0 无
  int? value;
  int? valueBefore; //
  int? valueAfter;
  int? unit; // 0-days 1-hours 2-minutes
  List<String>? listingId;
  FilterConditionBean({
     this.priority,
     this.keyword,
     this.missionType,
     this.startTime,
    this.valueBefore,
    this.valueAfter,
     this.endTime,
     this.listingId,
    this.unit,
    this.value,
  });


  factory FilterConditionBean.fromJson(Map<String, dynamic> json) {
    return _$FilterConditionBeanFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FilterConditionBeanToJson(this);
  }

}