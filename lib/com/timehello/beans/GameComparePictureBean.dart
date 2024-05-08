import 'package:json_annotation/json_annotation.dart';

import '../util/ScreenUtil.dart';
import '../util/Utility.dart';
import 'GameAnswerJsonBean.dart';

part 'GameComparePictureBean.g.dart';

@JsonSerializable(nullable: false)
class GameComparePictureBeanList {
  List<GameComparePictureBean> list;

  GameComparePictureBeanList({required this.list});

  factory GameComparePictureBeanList.fromJson(Map<String, dynamic> json) => _$GameComparePictureBeanListFromJson(json);
  Map<String, dynamic> toJson() => _$GameComparePictureBeanListToJson(this);
}

@JsonSerializable(nullable: false)
class GameComparePictureBean {
  @JsonKey(name: '_id')
  String id;
  List<GameAnswerJsonBean>? answerJson;
  String pic1_ref;
  String pic2;

  static parseData(GameComparePictureBean bean, { double? screenWidth,  double? screenHeight}) {
    if (bean == null) {
      return;
    }
    // double screenWidth = 0, screenHeight = 0;
    if (screenWidth == 0 || screenWidth == null) {
      screenWidth =  ScreenUtil.getScreenW(Utility.getGlobalContext());
    }
    if (screenHeight == 0 || screenWidth == null) {
      screenHeight = ScreenUtil.getScreenH(Utility.getGlobalContext());
    }
    bean.answerJson?.forEach((GameAnswerJsonBean element) {
      element = GameAnswerJsonBean.parseData(bean: element,screenHeight: screenHeight ?? ScreenUtil.getScreenH(Utility.getGlobalContext()), screenWidth: screenWidth ?? ScreenUtil.getScreenW(Utility.getGlobalContext()));
    });
  }

  GameComparePictureBean(this.id, this.answerJson, this.pic1_ref, this.pic2);

  factory GameComparePictureBean.fromJson(Map<String, dynamic> json) => _$GameComparePictureBeanFromJson(json);
  Map<String, dynamic> toJson() => _$GameComparePictureBeanToJson(this);
}