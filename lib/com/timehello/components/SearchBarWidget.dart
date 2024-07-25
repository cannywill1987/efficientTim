import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/interface/OnSubmitListener.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../models/FolderModel.dart';
import '../models/SheetDataModel.dart';
import '../util/ThemeManager.dart';

/**
 * missionPage
 * timelinePage用得上
 */
class SearchBarWidget extends StatefulWidget {
  OnSubmitListener? onSubmitListener;
  OnDesktopSubmitListener? onDesktopSubmitListener;
  Function? onChangeListener;
  Function? onClickResetListener;

  // String text;
  FolderModel? folderModel;
  double? width;
  double? paddingTop;
  String? defaultValue;
  Widget? lastWidget;
  SearchBarWidget({
    Key? key,
    this.defaultValue,
    this.lastWidget,
    this.width,
    this.paddingTop,
    this.onDesktopSubmitListener,
    this.onClickResetListener,
    this.onChangeListener,
    this.onSubmitListener,
    this.folderModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchBarWidgetState(curFolderModel: this.folderModel);
  }
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController inputController = TextEditingController();
  FocusNode _contentFocusNode = FocusNode();
  int numTomatoes = 0;
  FolderModel? curFolderModel;
  List<SheetDataModel> listSheetDataModel = [];
  List<FolderModel> listFolderModels = [];
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.circular(300),
    borderSide: BorderSide(
      color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xfff6f7f2)),
    ),
  );

  SearchBarWidgetState({this.curFolderModel});

  @override
  void didUpdateWidget(SearchBarWidget oldWidget) {
    this.curFolderModel = this.widget.folderModel;
  }

  @override
  void initState() {
    inputController.text = this.widget.defaultValue ?? "";
  }

  resetData() {
    inputController.text = '';
    _contentFocusNode.unfocus();
    setState(() {});
    if (this.widget?.onChangeListener != null) {
      this.widget?.onChangeListener!("");
    }
  }

  unfocus() {
    _contentFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 35,
      constraints:
          BoxConstraints(maxWidth: this.widget.width ?? double.infinity),
      margin:
          EdgeInsets.only(top: this.widget.paddingTop ?? 0, left: 5, right: 5),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Focus(
                onKey: (FocusNode node, RawKeyEvent event) {
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  // maxLength: 255,
                  textAlign: TextAlign.center,
                  focusNode: _contentFocusNode,
                  controller: inputController,
                  onChanged: (text) {
                    if (this.widget.onChangeListener != null) {
                      this.widget.onChangeListener!(text);
                    }
                  },
                  // onSubmitted: (String value) {
                  //   if (this.widget.onSubmitListener != null) {
                  //     this.widget.onSubmitListener(
                  //         {"inputContent": value, "folderModel": curFolderModel});
                  //   }
                  //
                  //   print(value);
                  // },
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      decorationColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Color(0xffd5d5d5)),
                      color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                      fontWeight: FontWeight.w500),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 20,
                        height: 20,
                        child: IconButton(
                            onPressed: () {
                              if (this.widget.onClickResetListener != null) {
                                this.widget.onClickResetListener!();
                              }
                              resetData();
                            },
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ),
                            iconSize: 20),
                      ),
                      contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                      counterStyle:
                          TextStyle(color: Colors.transparent, fontSize: 0),
                      //右边距是为了放置番茄计数器
                      fillColor: ThemeManager.getInstance().getInputDecorationColor(defaultColor: Color(0xffe0e0e0)),
                      //背景颜色，必须结合filled: true,才有效
                      // hoverColor: Colors.white,
                      // focusColor: Colors.white,
                      filled: true,
                      //重点，必须设置为true，fillColor才有效
                      // border: OutlineInputBorder(),
                      // prefixIcon: Icon(
                      //   Icons.search,
                      //   color: Color(0xffd5d5d5),
                      // ),
                      prefixIconColor: Color(0xffd5d5d5),
                      floatingLabelStyle:
                          TextStyle(color: Color(0xffff0000), fontSize: 14),
                      border: _outlineInputBorder,
                      //边框，一般下面的几个边框一起设置
                      //keyboardType: TextInputType.number, //键盘类型
                      //obscureText: true,//密码模式
                      focusedBorder: _outlineInputBorder,
                      enabledBorder: _outlineInputBorder,
                      disabledBorder: _outlineInputBorder,
                      focusedErrorBorder: _outlineInputBorder,
                      errorBorder: _outlineInputBorder,
                      // labelStyle:
                      //     TextStyle(color: Color(0x00000000), fontSize: 14),
                      // labelText: getI18NKey().search,
                      hintStyle: TextStyle(fontSize: 13),
                      hintText: getI18NKey().search),
                )),
          ),
          if(this.widget.lastWidget != null) SizedBox(width: 5),
            if(this.widget.lastWidget != null) this.widget.lastWidget!,
          // Align(
          //   alignment: Alignment(1, -0),
          //   child: ,
          // )
        ],
      ),
    );
  }
}
