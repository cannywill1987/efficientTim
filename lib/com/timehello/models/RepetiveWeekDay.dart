//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbUser.dart';

part 'RepetiveWeekDay.g.dart';


@JsonSerializable()
class RepetiveWeekDay extends MongoDbObject{

  bool? isRepetiveMonday = false; //按周重复才有用
  bool? isRepetiveTuesday = false;
  bool? isRepetiveWednesday = false;
  bool? isRepetiveThursday = false;
  bool? isRepetiveFriday = false;
  bool? isRepetiveSaturday = false;
  bool? isRepetiveSunday = false;
  MongoDbUser? author;
  // BmobGeoPoint addr;
  // BmobDate time;
  // BmobFile pic;
  RepetiveWeekDay();

  //此处与类名一致，由指令自动生成代码
  factory RepetiveWeekDay.fromJson(Map<String, dynamic> json) =>
      _$RepetiveWeekDayFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$RepetiveWeekDayToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


}