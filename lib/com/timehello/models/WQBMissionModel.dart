/**
 * 每个folderModel下有多个missionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import 'RepetiveWeekDay.dart';

part 'WQBMissionModel.g.dart';

@JsonSerializable()
class WQBMissionModel extends MongoDbObject {
  int? indexSearchingStart = -1; //不存储 用于搜索

  int state = 0; // 0 新卡 1 记忆中 2 已记住

  int? indexSearchingEnd = -1; //不存储 用于搜索

  String? background_url; //背景url

  String? title;

  //博客内容
  String? folder_id; //folderModel的ObjectId

  String? flomo_object_id; //folderModel的ObjectId //得到重复周期

  int type = 0; // 0 错题本 1 便签 2 记忆卡片 3 备忘录

  double masterScore = 1; //掌握

  int? update_time; //更新时间

  // 概念模糊 some confused ideas  code:confused
  // 审题错误 Examination error  code:examination
  // 思路错误 Wrong thinking   code:wrong_thinking
  // 运算错误 Arithmetic error   code:arithmetic_error
  // 粗心大意 Carelessness   code:carelessness
  List? causeAnalysis = []; //原因分析 {code:, weight: 0 1 2} code

  int wqbTypeKnowledgePoint = 0; //知识点错题本的三种格式 0 图片 1 录音 2 纯文本 3 富文本

  String wqbKnowledgeContent = ""; //知识点错题本 如果是富文本就是Url

  String wqbKnowledgeRichContentUrl = ""; //知识点错题本 如果是富文本就是Url

  List wqbKnowledgeRecordUrls =
      []; //录音列表，单条 map 支持 url、duration、localUrl、fileSize、recordText 等字段

  List<String>? wqbKnowledgeSmallUrls = []; // 数组用于存储图片url

  List<String>? wqbKnowledgeBigUrls = []; // 数组用于存储图片url

  List<String>? wqbKnowledgeOriginUrls = []; // 数组用于存储原始图片url

  int wqbTypeWrongQuestion = 0; //错题的三种格式 0 图片 1 录音 2 纯文本 3 富文本

  String wqbWrongQuestionContent = ""; //错题 如果是富文本就是Url

  String wqbWrongQuestionRichContentUrl = ""; //错题 如果是富文本就是Url

  List wqbWrongQuestionRecordUrls =
      []; //录音列表，单条 map 支持 url、duration、localUrl、fileSize、recordText 等字段

  List<String>? wqbWrongQuestionSmallUrls = []; // 数组用于存储图片url

  List<String>? wqbWrongQuestionBigUrls = []; // 数组用于存储图片url

  List<String>? wqbWrongQuestionOriginUrls = []; // 数组用于存储原始图片url

  int wqbTypeAnswer = 0; //正解的三种格式 0 图片 1 录音 2 纯文本 3 富文本

  List wqbAnswerRecordUrls =
      []; //录音列表，单条 map 支持 url、duration、localUrl、fileSize、recordText 等字段

  List<String>? wqbAnswerSmallUrls = []; // 数组用于存储图片url

  List<String>? wqbAnswerBigUrls = []; // 数组用于存储图片url

  List<String>? wqbAnswerOriginUrls = []; // 数组用于存储原始图片url

  String wqbAnswerContent = ""; //正解内容 如果是富文本就是Url

  String wqbAnswerRichContentUrl = ""; //知识点错题本 如果是富文本就是Url

  String content = ""; //

  String? device_id; //设备Id

  List? tagNames = []; //通过逗号,分割 但是如果folderModel是tags好像 {name: "", color: 0xff}

  String? tagIds; //通过逗号,分割

  bool? isFinished = false;

  int? color = 0xffff8800; // foldermodel的颜色

  int? order_index; //顺序 便签用得上 用来设置第几个组件的

  int? status; //0 新卡 1 记忆中 2 已记住

  int? priorityStatus; //3 无优先级  2 低优先级 1 中优先级 0 高优先级

  String? uid;

  // BmobUser author;
  // BmobGeoPoint addr;
  // BmobDate time;
  // BmobFile pic;
  WQBMissionModel();

  //此处与类名一致，由指令自动生成代码
  factory WQBMissionModel.fromJson(Map<String, dynamic> json) =>
      _$WQBMissionModelFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$WQBMissionModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
