import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import '../../../r.dart';
import '../config/ENUMS.dart';

class EditItemWidget extends StatefulWidget {
  String text;
  bool isEnable;
  EditModeEnum? editModeEnum;
  EditItemWidget({this.isEnable = false, required this.text, this.editModeEnum}) {
    if(editModeEnum == null) {
      editModeEnum = EditModeEnum.edit;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditItemWidgetState(text: this.text,editModeEnum: this.editModeEnum!);
  }
}

class EditItemWidgetState extends State<EditItemWidget> {
  String text;
  EditModeEnum editModeEnum;


  EditItemWidgetState({required this.text, required this.editModeEnum});


  @override
  void didUpdateWidget(EditItemWidget oldWidget) {
    this.text = this.widget.text;
    this.editModeEnum = this.editModeEnum;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (editModeEnum == EditModeEnum.normal) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getTextWidget(),
          Row(mainAxisSize: MainAxisSize.min, children: [Utility.getSVGPicture(R.assetsImgIcEdit, size: 16), Text("【${getI18NKey().edit}】", style: TextStyle(fontSize: 12, color: Colors.blue),)],)
        ],
      );
  }

  Text getTextWidget() {
    return Text(
          this.widget.text,
          style: TextStyle(color: this.widget.isEnable == true? Colors.white : Color(0xff404040), fontSize: 14),
        );
  }
}
