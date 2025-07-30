/**
 * StartTimeMissionModel - 开始时间任务模型
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'StartTimeMissionModel.g.dart';

@JsonSerializable()
class StartTimeMissionModel extends MongoDbObject {
  String? title = ''; //标题

  String? time_format = ''; //时间格式

  String? device_id; //设备Id

  int? start_time; //默认空是0 isFinished = false 计划到期日 isFinished = true 实际到期日

  int? finish_time;

  bool? isFinished = false;

  String? uid; //用户ID

  String? background_url; //背景url

  String? message;

  // 构造函数
  StartTimeMissionModel({
    this.title,
    this.time_format,
    this.background_url,
    this.device_id,
    this.start_time,
    this.isFinished,
    this.uid,
    this.message,
  });

  //此处与类名一致，由指令自动生成代码
  factory StartTimeMissionModel.fromJson(Map<String, dynamic> json) =>
      _$StartTimeMissionModelFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$StartTimeMissionModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
