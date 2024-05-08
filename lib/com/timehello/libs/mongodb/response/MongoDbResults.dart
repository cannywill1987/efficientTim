import 'package:json_annotation/json_annotation.dart';


//此处与类名一致，由指令自动生成代码
part 'MongoDbResults.g.dart';


@JsonSerializable()
class MongoDbResults{
  List<dynamic>? results;
  int? count;

  MongoDbResults();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbResults.fromJson(Map<String, dynamic> json) =>
      _$MongoDbResultsFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbResultsToJson(this);



}