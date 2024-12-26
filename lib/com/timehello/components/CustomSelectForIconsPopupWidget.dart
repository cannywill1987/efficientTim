import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomTextField.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';
import '../common/database/apis/MongoApisManager.dart';
import '../config/CONSTANTS.dart';
import '../config/ENUMS.dart';
import '../interface/OnCallbackListener.dart';
import '../models/CheckButtonStateModel.dart';
import '../models/ColorsModel.dart';
import '../models/FolderModel.dart';
import '../models/SheetDataModel.dart';
import '../page/WrongQuestionBookPage/components/WQBSelectCircleDialogUtil.dart';
import '../page/createFolderPage/CreateFolderPage.dart';
import '../util/Utility.dart';
import 'CustomPopupWidget.dart';

class CustomSelectForIconsPopupWidget extends StatefulWidget {
  Function onSelected;
  List<CheckButtonStateModel> datas;
  int defaultIndex = 0 ;

  // List<CheckButtonStateModel> list;
  // Widget child;

  CustomSelectForIconsPopupWidget(
      {required this.onSelected, required this.datas, required this.defaultIndex});

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //
  // }

  Text getTitleText(CheckButtonStateModel element) {
    return Text(
      element.title ?? "",
      style: TextStyle(fontSize: 12, color: Color(element.color ?? 0xff404040)),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomSelectForIconsPopupWidgetState(model: datas[this.defaultIndex]);
  }
}

class CustomSelectForIconsPopupWidgetState
    extends State<CustomSelectForIconsPopupWidget> {
  CheckButtonStateModel? model;

  CustomSelectForIconsPopupWidgetState({this.model});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPopupWidget(
      onSelected: (CheckButtonStateModel model) {
        this.model = model;
        this.widget.onSelected.call({"data": model, "index": this.widget.datas.indexOf(model)});
        setState(() {

        });
      },
      list: this.widget.datas,
      child: Container(
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 24,
          decoration: BoxDecoration(
              color: ThemeManager.getInstance().getDefautThemeColor(),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              if (this.model?.checkIcon != null)
                this.model?.checkIcon ?? SizedBox.shrink(),
              SizedBox(
                width: 4,
              ),
              // if(this.model?.title != null) {
              Text(
                this.model?.title ?? getI18NKey().unselected,
                style: TextStyle(fontSize: 12),
              ),
              // },
              //半透明圆形 里面有个inkwell x关闭按钮 点击会清空folderModelForFolder
              InkWell(
                onTap: () {
                  // folderModelForFolder = null;
                  // updateUI();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Color(0x33ffffff),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              // 向右的白色三角箭头
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 20,
              )
            ],
          )),
    );
    // return getPopupMenu();
  }

  @override
  void initState() {
    super.initState();
  }

// Container getPopupMenu() {
//   return Container(
//     key: ValueKey('Container5'),
//     margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
//     child: PopupMenuButton<String>(
//       key: ValueKey('PopupMenuButton5'),
//       tooltip: '',
//       padding: EdgeInsets.all(0.0),
//       child: this.widget.child,
//       // onSelected: (String val) {
//       //   this.onSelected.call(getModelByKey(val).color);
//       // },
//       itemBuilder: (context) {
//         return getPopupMenuItem();
//       },
//     ),
//   );
// }
}
