import 'package:json_annotation/json_annotation.dart';

part 'GameRankingBean.g.dart';

@JsonSerializable(nullable: false)
class GameRankingBean {
  @JsonKey(name: '_id')
  String? id;
  String? gameCode;
  String? username;
  String? avatar;
  String? gameTitle;
  String? gameTitleEn;
  int? time;
  double? val1;
  double? val2;
  double? val3;
  double? val4;
  double? score;
  String? deviceId;
  GameRankingBean({this.id, this.score, this.gameCode, this.username, this.avatar,
      this.gameTitle, this.gameTitleEn, this.time, this.deviceId, this.val1, this.val2, this.val3, this.val4});

  factory GameRankingBean.fromJson(Map<String, dynamic> json) => _$GameRankingBeanFromJson(json);
  Map<String, dynamic> toJson() => _$GameRankingBeanToJson(this);
}