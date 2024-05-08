/**
 * 每个folderModel下有多个CourseModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import 'RepetiveWeekDay.dart';

part 'CourseModel.g.dart';

@JsonSerializable()
class CourseModel extends MongoDbObject{
  String? id; //唯一id 用来针对性的搜索
  String? title; // 标题
  String? tagName; // 标签
  String? code; // code 搜索码， 可以用来标识 方便搜索查找

  String? folderTitle; //文件夹标题

  String? authorIntro; // 作者简介
  String? courseIntro; // 课程简介
  String? courseDetailPlan; // 课程详细训练计划 oss url
  String? backgroundUrl; //背景url
  List<String>? imageSmallUrls = []; // 数组用于存储图片url
  List<String>? imageBigUrls = []; // 数组用于存储图片url
  List<String>? imageOriginUrls = []; // 数组用于存储原始图片url
  String? countryCode = '';
  String? languageCode = '';
  int? type; // 类型 - 1 免费开放 需要id 2 私有 - 需要搜索 3 销售（只针对国内）
  bool? isEditable = false; //type = 2 私有情况时 对方是否可编辑
  String? password; // 密码 - 为2私有才需要密码
  double? price; // 价格 - 100

  String? courseFid; // 课程对应的fid
  String? uid; // 作者Uid
  String? authorAvatar; // 作者头像
  String? authorName; // 作者姓名

  int? verifiedtatus = 0; // 0 未审核 1 审核中 2 审核通过 3 审核拒绝
  int? created_at = -1; // 创建时间戳
  int? updated_at = -1; // 更新时间戳
  List? otherUids = []; //用于私有模式别的用户加入
  List? otherUserInfo = []; //用于私有模式别的用户加入

  CourseModel({
     this.id,
     this.title,
    this.tagName,
    this.folderTitle,
     this.authorIntro,
     this.courseIntro,
      this.languageCode,
     this.courseDetailPlan,
     this.imageSmallUrls,
     this.imageBigUrls,
     this.imageOriginUrls,
     this.type,
    this.password,
     this.price,
     this.courseFid,
     this.uid,
     this.authorAvatar,
     this.authorName,
     this.created_at,
     this.updated_at,
  });


  //此处与类名一致，由指令自动生成代码
  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}