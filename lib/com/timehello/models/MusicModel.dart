//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

part 'MusicModel.g.dart';

@JsonSerializable()
class MusicModel {
  String? title;
  String? url;
  bool? isChecked;
  String? localPath;
  MusicModel({this.title = '', this.url = '', this.isChecked, this.localPath = ''});


  @override
  String toString() {
    return 'MusicModel{title: $title, url: $url, localPath: $localPath,isChecked: $isChecked}';
  }

//反序列化
  factory MusicModel.fromJson(Map<String, dynamic> json) => _$MusicModelFromJson(json);
//序列化
  Map<String, dynamic> toJson() => _$MusicModelToJson(this);
}