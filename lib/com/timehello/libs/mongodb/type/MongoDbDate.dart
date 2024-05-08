import 'package:json_annotation/json_annotation.dart';

//此处与类名一致，由指令自动生成代码
part 'MongoDbDate.g.dart';

@JsonSerializable()
class MongoDbDate {
  String? iso;
  @JsonKey(name: '__type')
  String? type = "Date";

  MongoDbDate();


  void setDate(DateTime dateTime){
    this.iso = dateTime.toString();
  }

  //此处与类名一致，由指令自动生成代码
  factory MongoDbDate.fromJson(Map<String, dynamic> json) =>
      _$MongoDbDateFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbDateToJson(this);


}
