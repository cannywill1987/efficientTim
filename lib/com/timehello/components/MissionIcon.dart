import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';

class MissionIcon extends StatelessWidget {
  FolderModel? folderModel;
  double? iconSize;
  MissionIcon({Key? key, this.folderModel, iconSize: 10}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (folderModel != null) {
      return Icon(
          (folderModel?.tag == 0 ||
              folderModel?.tag == false ||
              folderModel?.tag == null)
              ? Icons.task //今天
              : folderModel?.tag == 1
              ? IconData(folderModel?.icon ?? 0,
              fontFamily: 'MaterialIcons') //任务folder
              : Icons?.local_offer, //标签
          color: (folderModel?.tag == 0 ||
              folderModel?.tag == false ||
              folderModel?.tag == null)
              ? Colors.pink //todo 这个是干啥 应该是默认颜色吧
              : Color(folderModel?.color ?? 0xffff8800),
          size: iconSize);
    } else {
      return Icon(Icons.task, size: iconSize,);
    }
  }

}