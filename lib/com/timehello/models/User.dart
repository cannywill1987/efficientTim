import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbUser.dart';

part 'User.g.dart';

@JsonSerializable()
class User extends MongoDbUser {
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  int? age;
  int? gender;
  String? nickname;

  User();


}