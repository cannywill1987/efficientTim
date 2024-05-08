import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';

class FolderModelWithExtraData{
  late FolderModel folderModel;
  late FolderTimeModel folderTimeModel; //用于完成时间
  bool isHover = false; //是否滑动到某个清单上，滑动到清单上样式增加个 "更多"icon
  bool isEditingTitle = false; // 是否正在编辑标题 不保存到服务器
  bool isOthers = false; // 是否是文件夹 且 其他文件夹
  List<FolderModelWithExtraData>? listFolderModelWithExtraData; // 如果folderModel是文件夹 folderModel.tag = 3，这个字段就有值
  FolderModelWithExtraData({this.listFolderModelWithExtraData,  FolderModel? folderModel,  FolderTimeModel? folderTimeModel, this.isHover = false}) {
    if(folderModel != null) {
      this.folderModel = folderModel;
    } else {
      this.folderModel = FolderModel();
    }
    if(folderTimeModel != null) {
      this.folderTimeModel = folderTimeModel;
    } else {
      this.folderTimeModel = FolderTimeModel();
    }
  }

  // 是否是文件夹 且 其他文件夹
  // isOthers() {
  //   if(isEditingTitle) {
  //     return false;
  //   }
  //   return folderModel.objectId == null ? true : false;
  // }


// Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}