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

class CustomFolderModelSelectForFoldersPopupWidget extends StatefulWidget {
  Function onSelected;

  // List<CheckButtonStateModel> list;
  Widget child;

  CustomFolderModelSelectForFoldersPopupWidget(
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
    return CustomFolderModelSelectForFoldersPopupWidgetState();
  }
}

class CustomFolderModelSelectForFoldersPopupWidgetState
    extends State<CustomFolderModelSelectForFoldersPopupWidget> {
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

  Container getPopupMenu() {
    return Container(
      key: ValueKey('Container5'),
      margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
      child: PopupMenuButton<String>(
        key: ValueKey('PopupMenuButton5'),
        tooltip: '',
        padding: EdgeInsets.all(0.0),
        child: this.widget.child,
        // onSelected: (String val) {
        //   this.onSelected.call(getModelByKey(val).color);
        // },
        itemBuilder: (context) {
          return getPopupMenuItem();
        },
      ),
    );
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

  PopupMenuEntry<String> getAddPopupMenuItem() {
    return PopupMenuItem<String>(
      onTap: () {
        Future.delayed(Duration(milliseconds: 200), () {
          DialogManagement.getInstance().showAsyncCustomDialog(context,
              cancelCallback: () {
                DialogManagement.getInstance().hideDialog(context);
              },
              okCallback: () async {
            if(TextUtil.isEmpty(createFolderTitle)){
              Utility.showToast(msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().folder_name));
              return;
            }
                FolderModel folderModel = FolderModel();
                folderModel.tag = 3; //1-normal 2-tag 3-circle
                folderModel.title = createFolderTitle;
                MongoDbSaved? res = await MongoApisManager.getInstance()
                    .insertFolderModel(folderModel: folderModel);
                if(res != null){
                  DialogManagement.getInstance().hideDialog(context);
                  requestData();
                } else {
                  Utility.showToast(msg: getI18NKey().request_fail);
                }
              },
              title: getI18NKey().create_folder_desc,
              okText: getI18NKey().create,
              cancelText: getI18NKey().cancel,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    child: TextField(
                      // controller: _confirmPasswordController,
                      // obscureText: !this.checkedPassword2,
                      textAlign: TextAlign.center,
                      maxLength: 30,
                      // keyboardType: TextInputType.number,
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ThemeManager.getInstance().getInputDecorationColor(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: getI18NKey().please_input_xxx_name(getI18NKey().folder_name),
                        hintStyle: TextStyle(
                            color: ThemeManager.getInstance().getInputPlaceholderColor(),
                            fontSize: 12),
                      ),
                      onChanged: (value) {
                        createFolderTitle = value;
                      },
                    ),
                  ),
                ],
              ));
          // if (this.onTapCreateTagListener != null) {
        });
      },
      key: ValueKey("create"),
      value: 18761.toString(),
      child: Wrap(
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
            getI18NKey().create_xxx(getI18NKey().folder),
            style: TextStyle(
                fontSize: 15,
                color: ThemeManager.getInstance()
                    .getTextColor(defaultColor: Colors.black),
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> getPopupMenuItem() {
    List<PopupMenuEntry<String>> list = [];
    this.list?.forEach((SheetDataModel data) {
      list.add(PopupMenuItem<String>(
        onTap: () {
          Future.delayed(Duration(milliseconds: 200), () {
            // if (this.widget.onSelected != null) {
            // setCheck(this.list ?? [], data.index ?? 0);
            // this._sheetDataModelCur = data;
            // this.onTapListener!(data);
            this
                .widget
                .onSelected
                .call(this._listFolderModel?[data.index ?? 0]);
            // Navigator.of(context).pop();
            // }
          });
        },
        key: ValueKey(data.index.toString()),
        value: data.index.toString(),
        child: Container(
            height: 60,
            padding: new EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Utility.getSVGPicture(R.assetsImgIcFolder, size: 20),
                    SizedBox(
                      width: 5,
                    ),
                    CustomTextField(
                      isEditing: data.isAdding ?? false,
                      isEditable: data.isAdding ?? false,
                      style: TextStyle(
                          fontSize: 15,
                          color: ThemeManager.getInstance()
                              .getTextColor(defaultColor: Colors.black),
                          fontWeight: FontWeight.w500),
                      text: data.title ?? "",
                      onEnterListener: (String) {},
                    )
                  ],
                ),
              ],
            )),
      ));
    });
    list.add(getAddPopupMenuItem());
    return list;
  }

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
