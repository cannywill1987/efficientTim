import 'package:json_annotation/json_annotation.dart';

//此处与类名一致，由指令自动生成代码
part 'MongoDbObjectInstallation.g.dart';


@JsonSerializable()
class MongoDbObjectInstallation{
  String? deviceType = "android";
  String? installationId;
  String? timeZone;
  String? deviceToken;

  MongoDbObjectInstallation(){
    timeZone = "";
  }

  //此处与类名一致，由指令自动生成代码
  factory MongoDbObjectInstallation.fromJson(Map<String, dynamic> json) =>
      _$MongoDbObjectInstallationFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbObjectInstallationToJson(this);



}
