import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';

import 'WQBFolderModel.dart';

class WQBFolderModelWithExtraData{
  WQBFolderModel folderModel;
  FolderTimeModel folderTimeModel; //用于完成时间
  bool isHover = false; //是否滑动到某个清单上，滑动到清单上样式增加个 "更多"icon
  WQBFolderModelWithExtraData({required this.folderModel, required this.folderTimeModel, this.isHover = false});

// Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}