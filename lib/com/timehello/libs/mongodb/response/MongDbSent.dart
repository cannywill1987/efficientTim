import 'package:json_annotation/json_annotation.dart';


//此处与类名一致，由指令自动生成代码
part 'MongDbSent.g.dart';


@JsonSerializable()
class MongDbSent{
  int? smsId;

  MongDbSent();

  //此处与类名一致，由指令自动生成代码
  factory MongDbSent.fromJson(Map<String, dynamic> json) =>
      _$MongDbSentFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongDbSentToJson(this);



}