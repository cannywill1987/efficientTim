import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnSubmitListener.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/BarModel.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'dart:math' as math;

import 'package:time_hello/com/timehello/models/StatsModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class HeaderStatsWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  Function? onChangeListener;
  HeaderStatsWidgetState? menuSilverListState;
  OnSubmitListener? onSubmitListener;
  // FolderTimeModel folderTimeModel;
  String? text;
  BarModelList? datas;
  List<StatsModel>? listStatsModel = [];
  List<StatsModel>? listStatsModelFinished = [];
  HeaderStatsWidget(
      {Key? key,
        BarModelList? datas,
        this.listStatsModelFinished,
        this.listStatsModel,
        this.onChangeListener,
      OnTapListener? onTapListener,
      // FolderTimeModel folderTimeModel,
        String? text,
      OnSubmitListener? onSubmitListener})
      : super(key: key) {
    this.onSubmitListener = onSubmitListener;

    this.onTapListener = onTapListener;
    this.datas = datas;
    this.text = text;
    // this.folderTimeModel = folderTimeModel ?? new FolderTimeModel();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new HeaderStatsWidgetState();
  }
}

class HeaderStatsWidgetState extends State<HeaderStatsWidget> {
  bool showAvg = false;
  int maxYVal = 10;
  int base = 1;
  String unit = ''; //单位
  double totalY = 0.0;
  List<String> xList = [];
  GlobalKey<HeaderInputState> HeaderInputStateGlobalKey = GlobalKey();


  @override
  void didUpdateWidget(HeaderStatsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    maxYVal = 10;
    base = 1;
    unit = ''; //单位
    totalY = 0.0;
    xList = [];
  }

  resetData() {
    HeaderInputStateGlobalKey.currentState?.resetData();
  }

  @override
  Widget build(BuildContext context) {
    int totalTime = Utility.getTotalTime(listBarModel: this.widget.datas?.listBarModel ?? {});
    return Container(
        decoration: new BoxDecoration(
          border:
          new Border.all(width: 1.0, color: new Color(SharePreferenceUtil.getSyncInstance().getCommonColor() - 0x40000000)),
          borderRadius:
          const BorderRadius.all(const Radius.circular(8.0)),
        ),
        margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
        height: 100,
        child: Row(
          children: <Widget>[
            Expanded(
              child: HeaderItemWidget(title: getI18NKey().wholeComepleteTime, value: totalTime.toString()),
              flex: 1,
            ),
            Expanded(
              child: HeaderItemWidget(title: getI18NKey().tomatoNums, value: this.widget.datas?.listStatsModel?.length?.toString() ?? ""),
              flex: 1,
            ),
            Expanded(
              child: HeaderItemWidget(title: getI18NKey().missionNums, value: this.widget.listStatsModelFinished?.length.toString() ?? ""),
              flex: 1,
            ),
          ],
        ));
  }
}

class HeaderInputWidget extends StatefulWidget {
  OnSubmitListener? onSubmitListener;
  Function? onChangeListener;
  String? text;
  HeaderInputWidget({Key? key, this.onChangeListener, this.onSubmitListener, this.text}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HeaderInputState();
  }
}

class HeaderInputState extends State<HeaderInputWidget> {
  TextEditingController inputController = TextEditingController();
  FocusNode _contentFocusNode = FocusNode();


  @override
  void didUpdateWidget(HeaderInputWidget oldWidget) {
  }

  resetData() {
    inputController.text = '';
    _contentFocusNode.unfocus();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    inputController.text = this.widget.text ?? "";
    // FocusNode focusNode = FocusNode();
    // FocusScope.of(context).requestFocus(focusNode);
    // inputController.addListener(() {
    //   String code = inputController.text;
    //   print(code + "");
    //
    // });
    // TODO: implement build
    return Container(
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: TextField(
                focusNode: _contentFocusNode,
                controller: inputController,
                onChanged: (text) {
                  inputController.clear();
                  if(this.widget.onChangeListener != null) {
                    this.widget.onChangeListener!(text);
                  }
                  print(text);
                },
                onSubmitted: (value) {
                  if (this.widget.onSubmitListener != null) {
                    this.widget.onSubmitListener!(value);
                  }
                  print(value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(0.0),
                    prefixIcon: Icon(Icons.add),
                    labelText: getI18NKey().addMissions2,
                    helperText: ''),
              ))
        ],
      ),
    );
  }
}

class HeaderItemWidget extends StatefulWidget {
  String? title;
  String? value;
  OnTapListener? onTapListener;
  HeaderItemWidgetState? menuSilverListState;

  HeaderItemWidget(
      {Key? key,
      List? datas,
      OnTapListener? onTapListener,
      String? title,
      String? value})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this.title = title;
    this.value = value;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new HeaderItemWidgetState();
  }
}

class HeaderItemWidgetState extends State<HeaderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              this.widget.value ?? "",
              style: TextStyle(color: ColorsConfig.red, fontSize: 20),
            ),
            Text(
              this.widget.title ?? "",
              style: TextStyle(color: ColorsConfig.gray_a7, fontSize: 12),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
