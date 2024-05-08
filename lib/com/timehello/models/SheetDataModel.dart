//此处与类名一致，由指令自动生成代码
import 'package:flutter/cupertino.dart';

/**
 * 用于下拉框的Model
 */
class SheetDataModel {
  int? index;

  //标题
  String? title;

  //描述
  String? desc;

  String? scene;

  int color = 0;
  //角标
  Widget? icon;

  dynamic? data;

  bool? isAdding = false;

  bool? isChecked = false;

  SheetDataModel({this.scene, this.isAdding = false, @required this.index, @required this.title, this.desc: "", @required this.icon, @required this.data, this.isChecked});
}
