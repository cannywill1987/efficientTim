import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_hello/com/timehello/common/AdaptiveForm/FormFactor.dart';
import 'package:time_hello/com/timehello/components/CheckContainer.dart';
import 'package:time_hello/com/timehello/components/MissionIcon.dart';
import 'package:time_hello/com/timehello/components/TomatoInputNumber.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnSubmitListener.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/Params.dart';
import '../../../models/EventFn.dart';
import '../../../models/FolderModel.dart';
import '../../../models/SheetDataModel.dart';
import '../../../util/AnalyticsEventsManager.dart';

class HeaderStatsAndInputWidget extends StatefulWidget {
  List _datas = [];
  OnTapListener? onTapListener;
  Function? onChangeListener;
  HeaderStatsAndInputWidgetState? menuSilverListState;
  Function? onTapUpListener;
  Function? onTapDownListener;
  OnSubmitListener? onSubmitListener;
  OnDesktopSubmitListener? onDesktopSubmitListener;
  FolderTimeModel? folderTimeModel;
  FolderModel? folderModel;
  String? text; //text是默认值 目前没用
  Widget? childAfterInputWidget; //在输入框后面的widget
  bool shouldShowFolderIcons = true;
  HeaderStatsAndInputWidget(
      {Key? key,
      List? datas,
      this.onTapUpListener,
        this.shouldShowFolderIcons = true,
      this.onTapDownListener,
      this.onChangeListener,
      this.childAfterInputWidget,
      FolderModel? folderModel,
      OnTapListener? onTapListener,
      FolderTimeModel? folderTimeModel,
      String? text,
      OnDesktopSubmitListener? onDesktopSubmitListener,
      OnSubmitListener? onSubmitListener})
      : super(key: key) {
    this.folderModel = folderModel;
    this.onSubmitListener = onSubmitListener;
    this.onDesktopSubmitListener = onDesktopSubmitListener;
    this.onTapListener = onTapListener;
    this.datas = datas ?? [];
    this.text = text;
    this.folderTimeModel = folderTimeModel ?? new FolderTimeModel();
  }

  set datas(List datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new HeaderStatsAndInputWidgetState();
  }
}

class HeaderStatsAndInputWidgetState extends State<HeaderStatsAndInputWidget> {
  GlobalKey<HeaderInputState> HeaderInputStateGlobalKey = GlobalKey();

  resetData() {
    HeaderInputStateGlobalKey.currentState?.resetData();
  }

  unfocus() {
    HeaderInputStateGlobalKey.currentState?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    //声明一个自变量，用来存储传递过来的参数

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return Container(
              decoration: new BoxDecoration(
                color: ThemeManager.getInstance()
                    .getCardBackgroundColor(defaultColor: Colors.white),
                border:
                    new Border.all(width: 1.0, color: ThemeManager.getInstance()
                        .getCardBackgroundColor(defaultColor: Color(0xfff0f0f0))),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0)),
              ),
              margin: Utility.isHandsetBySize()
                  ? EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 10,
                      CONSTANTS.missionPageMargin, 0)
                  : EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 0,
                      CONSTANTS.missionPageMargin, 0),
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                    key: ValueKey('Expanded332'),
                    child: HeaderItemWidget(
                        key: ValueKey('HeaderItemWidget32'),
                        shouldShowMins: true,
                        title: getI18NKey().previewTime,
                        value: this
                                .widget
                                .folderTimeModel
                                ?.previewTimeString
                                .toString() ??
                            ""),
                    flex: 1,
                  ),
                  Expanded(
                    key: ValueKey('Expanded132'),
                    child: HeaderItemWidget(
                        key: ValueKey('HeaderItemWidget132'),
                        shouldShowMins: false,
                        title: getI18NKey().missionToBeComplete,
                        value: this
                                .widget
                                .folderTimeModel
                                ?.numMissionToFinished
                                .toString() ??
                            ""),
                    flex: 1,
                  ),
                  Expanded(
                    key: ValueKey('Expanded1322'),
                    child: HeaderItemWidget(
                        key: ValueKey('HeaderItemWidget1322'),
                        shouldShowMins: true,
                        title: getI18NKey().timefocused,
                        value: this
                                .widget
                                .folderTimeModel
                                ?.finishedTimeString
                                .toString() ??
                            ""),
                    flex: 1,
                  ),
                  Expanded(
                    key: ValueKey('Expanded13223'),
                    child: HeaderItemWidget(
                        key: ValueKey('HeaderItemWidget1324'),
                        shouldShowMins: false,
                        title: getI18NKey().missioncompleted,
                        value: this
                                .widget
                                .folderTimeModel
                                ?.numMissionFinished
                                .toString() ??
                            ""),
                    flex: 1,
                  ),
                ],
              ));
          // return
          //   MenuSilverListItem(onTapListener: this.widget.onTapListener,index:index);
        } else if (index == 1) {
          //第二个位置是输入框
          return Container(
              key: ValueKey('Container1322'),
              margin: EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 10,
                  CONSTANTS.missionPageMargin, 0),
              child: HeaderInputWidget(
                  shouldShowFolderIcons: this.widget.shouldShowFolderIcons,
                  folderModel: this.widget.folderModel ?? FolderModel(),
                  key: HeaderInputStateGlobalKey,
                  onChangeListener: this.widget.onChangeListener,
                  text: this.widget.text,
                  onDesktopSubmitListener: this.widget.onDesktopSubmitListener,
                  onSubmitListener: this.widget.onSubmitListener));
        } else if (index == 2) {
          //第三个组件是用来放bottombar
          return this.widget.childAfterInputWidget == null
              ? SizedBox.shrink()
              : this.widget.childAfterInputWidget;
        } else {
          return null;
        }
      }, childCount: 3),
    );
  }
}

class HeaderInputWidget extends StatefulWidget {
  OnSubmitListener? onSubmitListener;
  OnDesktopSubmitListener? onDesktopSubmitListener;
  Function? onChangeListener;
  String? text;
  FolderModel? folderModel;
  Function? onTapUpListener;
  Function? onTapDownListener;
  bool shouldShowFolderIcons = true;

  HeaderInputWidget(
      {Key? key,
      this.shouldShowFolderIcons = true,
      this.onDesktopSubmitListener,
      this.onTapUpListener,
      this.onTapDownListener,
      this.onChangeListener,
      this.onSubmitListener,
      this.folderModel,
      this.text})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HeaderInputState(curFolderModel: this.folderModel);
  }
}

class HeaderInputState extends State<HeaderInputWidget> {
  TextEditingController? inputController = TextEditingController();
  FocusNode? _contentFocusNode = FocusNode();
  int? numTomatoes = 0;
  FolderModel? curFolderModel;
  String? _value;
  List<SheetDataModel>? listSheetDataModel = [];
  List<FolderModel>? listFolderModels = [];
  GlobalKey<TomatoInputNumberState> inputNumberGlobalKey = GlobalKey();
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide: BorderSide(
      color: ThemeManager.getInstance().getInputBorderColor()
    ),
  );
  Function incrementFunc = Utility.throttle((state) {
    state.inputNumberGlobalKey.currentState!.increment();
  }, Duration(milliseconds: 500));
  Function decrementFunc = Utility.throttle((state) {
    state.inputNumberGlobalKey.currentState!.decrement();
  }, Duration(milliseconds: 500));

  // OutlineInputBorder? _outlineInputBorder = OutlineInputBorder(
  //   gapPadding: 0,
  //   borderSide: BorderSide(
  //     color: Colors.white,
  //   ),
  // );

  HeaderInputState({this.curFolderModel});

  @override
  void didUpdateWidget(HeaderInputWidget oldWidget) {
    this.curFolderModel = this.widget.folderModel;
  }

  @override
  void initState() {
    inputController?.text = this.widget.text ?? "";
    requestData();
  }

  resetData() {
    inputController?.text = '';
    _contentFocusNode?.unfocus();
    setState(() {});
  }

  unfocus() {
    _contentFocusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // inputController?.text = this.widget.text ?? "";
    // FocusNode focusNode = FocusNode();
    // FocusScope.of(context).requestFocus(focusNode);
    // inputController.addListener(() {
    //   String code = inputController.text;
    //   print(code + "");
    //
    // });
    // TODO: implement build
    return Container(
      color: ThemeManager.getInstance().getInputThemeColor(),
      child: Focus(
          key: ValueKey('Focus11322'),
          onKey: (FocusNode node, RawKeyEvent event) {
            //新版本textfield已经支持 Textfield onSubmitted的enter方法
            if (event.data.physicalKey == PhysicalKeyboardKey.arrowUp) {
              if (this.widget.onTapUpListener != null) {
                this.widget.onTapUpListener!();
              }
              if (inputNumberGlobalKey.currentState != null)
                incrementFunc(this);
            } else if (event.data.physicalKey ==
                PhysicalKeyboardKey.arrowDown) {
              if (this.widget.onTapDownListener != null) {
                this.widget.onTapDownListener!();
              }
              if (inputNumberGlobalKey.currentState != null)
                decrementFunc(this);
            }
            return KeyEventResult.ignored;
          },
          child: TextField(
            key: ValueKey('TextField4'),
            focusNode: _contentFocusNode,
            controller: inputController,
            onChanged: (text) {
              // inputController.clear();
              _value = text;
              if(_value?.length == 1) {
                AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "missionpage","eventType": "missionpage_add_task_input","description": "添加任务输入框",});
              }
              if (this.widget.onChangeListener != null)
                this.widget.onChangeListener!(text, numTomatoes);
              print(text);
            },
            onSubmitted: (String value) {
              if (this.widget.onSubmitListener != null) {
                this.widget.onSubmitListener!({
                  "inputContent": value,
                  "folderModel": curFolderModel,
                  "numTomatoes": this.numTomatoes
                });
              }

              print(value);
            },
            style: TextStyle(
                fontFamily: 'Montserrat',
                decorationColor: Colors.lightGreen,
                color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                fontWeight: FontWeight.w500),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 60, right: 75, top: 0, bottom: 0),
              counterStyle:
                  TextStyle(color: Colors.transparent, fontSize: 0),
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
              suffixIcon: Row(
                  key: ValueKey('Row4'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      key: ValueKey('SizedBox111322'),
                      width: 8,
                    ),
                    TomatoInputNumber(
                      key: inputNumberGlobalKey,
                      onValueChangeListener: (num, duration) {
                        this.numTomatoes = num;
                        eventBus.fire(EventFn(
                            Params.ACTION_UPDATE_VALUE_PER_DAY,
                            {"numTomatoes": this.numTomatoes}));
                      },
                    ),
                    Utility.isHandsetBySize()
                        ? SizedBox(
                      key: ValueKey('Sizedbox12'),
                      width: 3,
                    )
                        : SizedBox(
                      key: ValueKey('Positioned21'),
                      width: 15,
                    ),
                    Utility.isHandsetBySize()
                        ? SizedBox(
                      key: ValueKey('Positioned22'),
                      width: 0,
                    )
                        : Container(
                      key: ValueKey('container7'),
                      width: 1,
                      height: 25,
                      color: ColorsConfig.dividerLine,
                    ),
                    !(Utility.isHandsetBySize() == false && this.widget.shouldShowFolderIcons == true)
                        ? SizedBox.shrink()
                        : Container(
                        key: ValueKey('container6'),
                        margin: EdgeInsets.only(right: 0, left: 5),
                        child: PopupMenuButton<String>(
                          tooltip: '',
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            key: ValueKey('container11'),
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: ThemeManager.getInstance().getColor(
                                    defaultColor: Colors.white,
                                    defaultDarkColor:
                                    ThemeManager.getInstance()
                                        .getBackgroundColor()),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8))),
                            child: MissionIcon(
                              key: ValueKey('container4'),
                              folderModel: curFolderModel,
                              iconSize: 12,
                            ),
                          ),
                          onSelected: (String indexParam) {
                            int index = int.parse(indexParam);
                            if (index == -1) {
                              this.curFolderModel = null;
                            } else {
                              this.curFolderModel =
                              listFolderModels?[index];
                            }
                            setState(() {});
                          },
                          itemBuilder: (context) {
                            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                            return getPopupMenuList();
                          },
                        )),
                    Utility.isHandsetBySize()
                        ? SizedBox(
                      key: ValueKey('SizedBox41'),
                      width: 0,
                    )
                        : SizedBox(
                      key: ValueKey('SizedBox42'),
                      width: 0,
                    ),
                    Utility.isHandsetBySize()
                        ? SizedBox(
                      key: ValueKey('SizedBox414'),
                      width: 0,
                    )
                        : Icon(
                      key: ValueKey('Icon41'),
                      Icons.navigate_next,
                      color: Color(0xff9a9a9a),
                    )
                  ]),
              prefixIcon: Icon(
                Icons.add,
                color: ThemeManager.getInstance().getInputPlaceholderColor(
                    defaultColor: Color(0xffd5d5d5),
                    defaultDarkColor:
                        TextUtil.isEmpty(this.inputController?.text)
                            ? Color(0xff575757)
                            : Colors.white),
              ),
              // prefixIconColor: Color(0xffd5d5d5),
              border: _outlineInputBorder,
              prefixIconColor: ThemeManager.getInstance()
                  .getIconColor(defaultColor: Color(0xffd5d5d5)),
              floatingLabelStyle: TextStyle(
                  color: ThemeManager.getInstance()
                      .getIconColor(),
                  fontSize: 14),
              labelStyle: TextStyle(
                  color: ThemeManager.getInstance()
                      .getInputPlaceholderColor(
                          defaultColor: Color(0xffd5d5d5),
                          defaultDarkColor:
                              TextUtil.isEmpty(this.inputController?.text)
                                  ? Color(0xff575757)
                                  : Colors.white),
                  fontSize: 14),
              //边框，一般下面的几个边框一起设置
              //keyboardType: TextInputType.number, //键盘类型
              //obscureText: true,//密码模式
              //背景颜色，必须结合filled: true,才有效
              hoverColor: ThemeManager.getInstance().getCardBackgroundColor(
                  defaultColor: Colors.white,
                  ),
              focusColor: ThemeManager.getInstance().getInputThemeColor(
                  defaultColor: Colors.white,
                  defaultDarkColor:
                      ThemeManager.getInstance().getBackgroundColor()),
              //右边距是为了放置番茄计数器
              fillColor: ThemeManager.getInstance()
                  .getInputThemeColor(defaultColor: Colors.white),
              focusedBorder: _outlineInputBorder,
              enabledBorder: _outlineInputBorder,
              disabledBorder: _outlineInputBorder,
              focusedErrorBorder: _outlineInputBorder,
              errorBorder: _outlineInputBorder,
              // labelStyle:
              //     TextStyle(color: Color(0x00000000), fontSize: 14),
              // labelText: getI18NKey().search,

              labelText: Utility.isHandsetBySize()
                  ? getI18NKey().addMissions2
                  : curFolderModel == null
                      ? getI18NKey().missionPageInputHolder
                      : getI18NKey().header_input_placeholder_with_title(
                          curFolderModel?.title ?? ""),
            ),
            // decoration: InputDecoration(
            //     counterStyle: TextStyle(color: Colors.black),
            //     contentPadding: EdgeInsets.only(left: 60, right: 75),
            //     //右边距是为了放置番茄计数器
            //     fillColor: Colors.white,
            //     //背景颜色，必须结合filled: true,才有效
            //     hoverColor: Colors.white,
            //     focusColor: Colors.white,
            //     filled: true,
            //     //重点，必须设置为true，fillColor才有效
            //     // border: OutlineInputBorder(),
            //     prefixIcon: Icon(
            //       Icons.add,
            //       color: Color(0xffd5d5d5),
            //     ),
            //     prefixIconColor: Color(0xffd5d5d5),
            //     floatingLabelStyle:
            //         TextStyle(color: Color(0xffff0000), fontSize: 14),
            //     labelStyle:
            //         TextStyle(color: Color(0xffd5d5d5), fontSize: 14),
            //     // border: _outlineInputBorder,
            //     // //边框，一般下面的几个边框一起设置
            //     // //keyboardType: TextInputType.number, //键盘类型
            //     // //obscureText: true,//密码模式
            //     // focusedBorder: _outlineInputBorder,
            //     // enabledBorder: _outlineInputBorder,
            //     // disabledBorder: _outlineInputBorder,
            //     // focusedErrorBorder: _outlineInputBorder,
            //     // errorBorder: _outlineInputBorder,
            //     labelText: Utility.isHandsetBySize()
            //         ? getI18NKey().addMissions2
            //         : curFolderModel == null
            //             ? getI18NKey().missionPageInputHolder
            //             : getI18NKey().header_input_placeholder_with_title(
            //                 curFolderModel?.title ?? ""),
            //     helperText: ''),
          )),
    );
  }

  List<PopupMenuEntry<String>> getPopupMenuList() {
    List<PopupMenuEntry<String>> list = [];
    int index = 0;
    list.add(PopupMenuItem<String>(
      value: (-1).toString(),
      child: Wrap(
        key: ValueKey('Wrap41'),
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            key: ValueKey('SizedBox13'),
            width: 5,
          ),
          Icon(
            key: ValueKey('Icon14'),
            Icons.task,
            size: 15,
          ),
          SizedBox(
            key: ValueKey('Icon15'),
            width: 5,
          ),
          Text(
            key: ValueKey('Text14'),
            getI18NKey().task ?? '',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),
          )
        ],
      ),
    ));

    for (SheetDataModel sheetDataModel in (listSheetDataModel ?? [])) {
      list.add(PopupMenuItem<String>(
        key: ValueKey('PopupMenuItem114'),
        value: sheetDataModel.index.toString(),
        child: Wrap(
          children: [
            SizedBox(
              key: ValueKey('SizedBox114'),
              width: 5,
            ),
            sheetDataModel.icon ?? SizedBox.shrink(),
            SizedBox(
              key: ValueKey('SizedBox111'),
              width: 5,
            ),
            Text(
              key: ValueKey('Text32'),
              sheetDataModel.title ?? '',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ));
      index++;
    }
    return list;
  }

  void requestData() async {
    List<FolderModel> list = await MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithCircle();
    List<SheetDataModel> listSheetDataModel =
        Utility.getSheetDataModelFromFolderModel(
            list, Icons.fiber_manual_record);
    setState(() {
      this.listFolderModels = list;
      this.listSheetDataModel = listSheetDataModel;
    });
  }
}

/**
 * 头部的每个item
 */
class HeaderItemWidget extends StatefulWidget {
  String? title;
  String? value;
  bool shouldShowMins;
  OnTapListener? onTapListener;
  HeaderItemWidgetState? menuSilverListState;

  HeaderItemWidget(
      {Key? key,
      List? datas,
      OnTapListener? onTapListener,
      this.shouldShowMins = false,
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
    bool shouldShowMins = this.widget.shouldShowMins;
    double titleFontSize = Utility.isHandsetBySize() ? 10 : 12;
    double redFontSize = Utility.isHandsetBySize() ? 16 : 20;
    double extensionFontSize = Utility.isHandsetBySize() ? 8 : 11;

    List<Widget> listWidget = [];
    if (shouldShowMins == true) {
      if (TextUtil.isEmpty(this.widget.value) == false) {
        String hour = this.widget.value?.split(':')[0] ?? "";
        String min = this.widget.value?.split(':')[1] ?? "";
        listWidget.addAll([
          Text(
            hour,
            style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize),
          ),
          SizedBox(
            width: 1,
          ),
          this.widget.shouldShowMins
              ? Text(
                  getI18NKey().hour,
                  style: TextStyle(
                      color: ThemeManager.getInstance()
                          .getTextColor(defaultColor: ColorsConfig.gray_a7),
                      fontSize: extensionFontSize),
                )
              : SizedBox.shrink(),
          SizedBox(
            width: 1,
          ),
          Text(
            min,
            style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize),
          ),
          SizedBox(
            width: 1,
          ),
          this.widget.shouldShowMins
              ? Text(
                  getI18NKey().mins2,
                  style: TextStyle(
                      color: ThemeManager.getInstance()
                          .getTextColor(defaultColor: ColorsConfig.gray_a7),
                      fontSize: extensionFontSize),
                )
              : SizedBox.shrink(),
        ]);
      }
    } else {
      listWidget.add(
        Text(
          this.widget.value ?? '',
          style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize),
        ),
      );
    }
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              children: [...listWidget],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              this.widget.title ?? "",
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: ColorsConfig.gray_a7),
                  fontSize: titleFontSize),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
