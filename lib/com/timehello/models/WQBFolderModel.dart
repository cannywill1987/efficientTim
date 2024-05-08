/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'WQBFolderModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class WQBFolderModel extends MongoDbObject{
  String? originalFolderId; // 从courseModel引用进来需要这个id
  String? courseModelId; // 课程id
  int? order_index;
  String? title = ''; //标题
  String? description; //描述
  String? device_id; //设备id 用于没用登录时的搜索
  int? number;
  String? uid;
  String? noteUrl; //笔记url
  String? timelineNoteObjectId; //笔记objectId
  int? numberNoteWords; //笔记字数
  int? update_time;
  int? create_time;
  int? tag; //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来
  int color = 0;
  int? tagColor;
  int? icon = 0; //左侧图标
  // bool hasTag = false; //是否有标签
  String? tagName; //标签名称
  int? type; //用于展示 不用于存储 2-今天 明天 即将到来 所有 等 3-创建清单
  int? iconType = 0; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他 9 所有
  List? otherUids = []; //用于私有模式别的用户加入
  List? otherUserInfo = []; //用于私有模式别的用户加入
  bool? isOtherUserEditable = false; //isSharring = 1 时才用上 因为这时otherUids也是可以共同编辑 WQBFolderModel的状态的
  int? isSharing = 0; //0 未分享中 1 之后分享中 - 1 免费开放 需要id 2 私有 - 需要搜索 3 销售（只针对国内）
  // BmobUser author;
  WQBFolderModel();

  factory WQBFolderModel.fromJson(Map<String, dynamic> json) => _$WQBFolderModelFromJson(json);
  Map<String, dynamic> toJson() => _$WQBFolderModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}