import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';

/**
 * MissionPage头部时间
 */
part 'FolderTimeModel.g.dart';
@JsonSerializable()
class FolderTimeModel extends MongoDbObject{
  String previewTimeString = ''; //预计时间 hh:mm
  int? numMissionToFinished; //待完成任务
  int? previewTime; //预计时间
  int? finishedTime; //已完成时间
  String finishedTimeString = ''; //已完成时间 hh:mm
  int? numMissionFinished; //已完成任务
  int? numMissionDelayed = 0; //已完成任务
  int? numTomatoesUnfinished = 0;
  int? numTomatoesFinished = 0;
  FolderTimeModel({this.numTomatoesUnfinished, this.numMissionDelayed, this.numTomatoesFinished, this.finishedTimeString = '', this.previewTimeString = '', this.previewTime, this.numMissionToFinished, this.finishedTime,
      this.numMissionFinished});

  factory FolderTimeModel.fromJson(Map<String, dynamic> json) => _$FolderTimeModelFromJson(json);
  Map<String, dynamic> toJson() => _$FolderTimeModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Map getParams() {
  //   // TODO: implement getParams
  //   return toJson();
  // }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}