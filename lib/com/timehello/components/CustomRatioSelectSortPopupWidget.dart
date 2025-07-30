import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
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

class CustomRatioSelectSortPopupWidget extends StatefulWidget {
  Function onSelected;

  // List<CheckButtonStateModel> list;
  Widget child;

  CustomRatioSelectSortPopupWidget(
      {required this.onSelected, required this.child});

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
    return CustomRatioSelectSortPopupWidgetState();
  }
}

class CustomRatioSelectSortPopupWidgetState
    extends State<CustomRatioSelectSortPopupWidget> {
  OnTapListener? onTapListener;
  OnTapCreateTagListener? onTapCreateTagListener;
  List<FolderModel>? _listFolderModel;
  List<SheetDataModel>? list;
  bool isAdding = false;
  String createFolderTitle = "";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getPopupMenu();
  }

  @override
  void initState() {
    super.initState();
    this.requestData();
  }

  void requestData() async {
    List<FolderModel> list = await MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithFolderTag();
    List<SheetDataModel> listSheetDataModel =
        Utility.getSheetDataModelFromFolderModel(
            list, Icons.fiber_manual_record);
    this._listFolderModel = list;
    if (mounted)
      setState(() {
        this.list = listSheetDataModel;
      });
  }

  Widget getPopupMenu() {
    CustomPopupWidget customPopupWidget = CustomPopupWidget(
      child: getCreateTagWidget(),
       onSelected: (v) {

       }, list: CONSTANTS.getRatioPopup(),
    );

    return customPopupWidget;
  }

  // CheckButtonStateModel getModelByKey(String key) {
  //   CheckButtonStateModel? model;
  //   this._listFolderModel.forEach((element) {
  //     if (element.code == key) {
  //       model = element;
  //     }
  //   });
  //   return model!;
  // }


  getCreateTagWidget() {
    List<Widget> list = [];
    // List<SheetDataModel> listModels = this.list ?? [];
    list.add(InkWell(
      onTap: () {
        if (this.onTapCreateTagListener != null) {
          FolderModel folderModel = FolderModel();
          folderModel.tag = 1; //1-normal 2-tag 3-circle
          Utility.pushNavigator(
              context,
              new CreateFolderPage(
                pageEnum: PageModeEnum.create,
                pageNavShowEnum: PageNavShowEnum.show,
                folderModel: folderModel,
              ), callback: (res) {
            requestData();
          });
          this.onTapCreateTagListener!(null);
        }
      },
      child: Container(
          height: 60,
          padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.add,
                    size: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    getI18NKey().createMission,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          )),
    ));
    return Column(
      children: list,
    );
  }
}
