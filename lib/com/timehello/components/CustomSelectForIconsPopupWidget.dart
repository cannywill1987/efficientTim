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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          constraints: const BoxConstraints(minHeight: 28),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              if (this.model?.checkIcon != null)
                this.model?.checkIcon ?? SizedBox.shrink(),
              const SizedBox(
                width: 6,
              ),
              Text(
                this.model?.title ?? getI18NKey().unselected,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ThemeManager.getInstance().getTextColor(
                      defaultColor: const Color(0xFF8B6A55),
                      defaultDarkColor: Colors.white70),
                ),
              ),
              InkWell(
                onTap: () {
                  // folderModelForFolder = null;
                  // updateUI();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.all(1),
                  child: Icon(
                    Icons.close,
                    size: 13,
                    color: ThemeManager.getInstance().getIconColor(
                        defaultColor: const Color(0xFFB69179),
                        defaultDarkColor: Colors.white70),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: ThemeManager.getInstance().getIconColor(
                    defaultColor: const Color(0xFFB69179),
                    defaultDarkColor: Colors.white70),
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
