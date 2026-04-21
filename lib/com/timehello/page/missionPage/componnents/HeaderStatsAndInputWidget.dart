import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_hello/com/timehello/common/AdaptiveForm/FormFactor.dart';
import 'package:time_hello/com/timehello/components/CheckContainer.dart';
import 'package:time_hello/com/timehello/components/MissionIcon.dart';
import 'package:time_hello/com/timehello/components/TomatoInputNumber.dart';
import 'package:time_hello/com/timehello/components/unified/UnifiedDesktopShell.dart';
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
  bool shouldSliver = true;
  bool useUnifiedStyle = false;
  HeaderStatsAndInputWidget(
      {Key? key,
      List? datas,
      this.onTapUpListener,
      this.shouldSliver = true,
      this.shouldShowFolderIcons = true,
      this.useUnifiedStyle = false,
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

  List<int> _parseHourMinute(String? value) {
    if (TextUtil.isEmpty(value)) {
      return [0, 0];
    }
    List<String> parts = (value ?? "").split(':');
    int hour = 0;
    int minute = 0;
    if (parts.isNotEmpty) {
      hour = int.tryParse(parts[0]) ?? 0;
    }
    if (parts.length > 1) {
      minute = int.tryParse(parts[1]) ?? 0;
    }
    return [hour, minute];
  }

  String _formatHeroDuration(String? value) {
    final List<int> result = _parseHourMinute(value);
    return "${result[0]}h ${result[1].toString().padLeft(2, '0')}m";
  }

  double _parsePercentValue(String? value) {
    if (TextUtil.isEmpty(value)) {
      return 0;
    }
    return ((double.tryParse((value ?? "").replaceAll('%', '')) ?? 0) / 100)
        .clamp(0, 1)
        .toDouble();
  }

  double _getTaskProgress() {
    int finished = widget.folderTimeModel?.numMissionFinished ?? 0;
    int pending = widget.folderTimeModel?.numMissionToFinished ?? 0;
    int total = finished + pending;
    if (total <= 0) {
      return 0;
    }
    return finished / total;
  }

  double _getPomodoroProgress() {
    int finished = widget.folderTimeModel?.numTomatoesFinished ?? 0;
    int pending = widget.folderTimeModel?.numTomatoesUnfinished ?? 0;
    int total = finished + pending;
    if (total <= 0) {
      return 0;
    }
    return finished / total;
  }

  double _getFocusProgress() {
    int preview = widget.folderTimeModel?.previewTime ?? 0;
    int finished = widget.folderTimeModel?.finishedTime ?? 0;
    int total = preview + finished;
    if (total <= 0) {
      return 0;
    }
    return finished / total;
  }

  Widget _buildUnifiedHeroOverview() {
    final Color titleColor = ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF3A2417), defaultDarkColor: Colors.white);
    final Color accentColor = const Color(0xFFC98261);
    final String headline = widget.folderModel?.title ?? getI18NKey().today;
    final int finished = widget.folderTimeModel?.numMissionFinished ?? 0;
    final int pending = widget.folderTimeModel?.numMissionToFinished ?? 0;
    final int total = finished + pending;
    return UnifiedDesktopCard(
      margin: EdgeInsets.fromLTRB(
          CONSTANTS.missionPageMargin, 8, CONSTANTS.missionPageMargin, 0),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      borderRadius: BorderRadius.circular(30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 980;
          final Widget left = Expanded(
            flex: compact ? 0 : 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 34 : 50,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    height: 0.96,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _formatHeroDuration(
                      widget.folderTimeModel?.previewTimeString),
                  style: TextStyle(
                    fontSize: compact ? 40 : 58,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    height: 0.92,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "剩余",
                  style: TextStyle(
                    fontSize: compact ? 28 : 34,
                    fontWeight: FontWeight.w300,
                    color: accentColor.withValues(alpha: 0.92),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  total > 0
                      ? "$finished/$total ${getI18NKey().missionNums}"
                      : "${widget.folderTimeModel?.numMissionToFinished ?? 0}${getI18NKey().unitMissions}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: titleColor.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          );
          final String focusTimeDisplay = Utility.formatTimestamp(
              widget.folderTimeModel?.finishedTime ?? 0);
          final Widget right = Wrap(
            spacing: 18,
            runSpacing: 18,
            alignment: WrapAlignment.end,
            children: [
              UnifiedMetricRing(
                value: focusTimeDisplay,
                label: getI18NKey().timefocused,
                subtitle: "($focusTimeDisplay)",
                progress: _getFocusProgress(),
                color: const Color(0xFFF0B788),
              ),
              UnifiedMetricRing(
                value: total > 0 ? "$finished/$total" : "0/0",
                label: getI18NKey().missionNums,
                subtitle: total > 0 ? "($finished/$total)" : "(0/0)",
                progress: _getTaskProgress(),
                color: const Color(0xFF9EDDC9),
              ),
              Builder(builder: (context) {
                final int finished =
                    widget.folderTimeModel?.numTomatoesFinished ?? 0;
                final int pending =
                    widget.folderTimeModel?.numTomatoesUnfinished ?? 0;
                final int total = finished + pending;
                final String value = total > 0 ? "$finished/$total" : "0/0";
                return UnifiedMetricRing(
                  value: value,
                  label: getI18NKey().tomatoNums,
                  subtitle: "($value)",
                  progress: _getPomodoroProgress(),
                  color: const Color(0xFFD7B8F8),
                );
              }),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                left,
                const SizedBox(height: 20),
                right,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              left,
              const SizedBox(width: 18),
              Expanded(flex: 4, child: right),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUnifiedInputCard() {
    final Widget? detailPanel = widget.childAfterInputWidget;
    return UnifiedDesktopCard(
      margin: EdgeInsets.fromLTRB(
          CONSTANTS.missionPageMargin, 14, CONSTANTS.missionPageMargin, 0),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      borderRadius: BorderRadius.circular(26),
      backgroundColor: const Color(0xFFFFFCF8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderInputWidget(
            shouldShowFolderIcons: this.widget.shouldShowFolderIcons,
            folderModel: this.widget.folderModel ?? FolderModel(),
            key: HeaderInputStateGlobalKey,
            onChangeListener: this.widget.onChangeListener,
            text: this.widget.text,
            onDesktopSubmitListener: this.widget.onDesktopSubmitListener,
            onSubmitListener: this.widget.onSubmitListener,
            useUnifiedStyle: true,
          ),
          if (detailPanel != null)
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Container(
                    height: 1,
                    color: const Color(0xFFF0E2D3),
                  ),
                  const SizedBox(height: 14),
                  detailPanel,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUnifiedDesktopContent() {
    return Column(
      children: [
        _buildUnifiedHeroOverview(),
        _buildUnifiedInputCard(),
      ],
    );
  }

  BoxDecoration _buildStatsCardDecoration() {
    if (widget.useUnifiedStyle) {
      return buildUnifiedDesktopCardDecoration();
    }
    return BoxDecoration(
      color: ThemeManager.getInstance()
          .getCardBackgroundColor(defaultColor: Colors.white),
      border: Border.all(
        width: 1.0,
        color: ThemeManager.getInstance()
            .getCardBackgroundColor(defaultColor: Color(0xfff0f0f0)),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    );
  }

  resetData() {
    HeaderInputStateGlobalKey.currentState?.resetData();
  }

  unfocus() {
    HeaderInputStateGlobalKey.currentState?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    //声明一个自变量，用来存储传递过来的参数
    if (widget.useUnifiedStyle) {
      return widget.shouldSliver
          ? SliverToBoxAdapter(child: _buildUnifiedDesktopContent())
          : _buildUnifiedDesktopContent();
    }
    if (this.widget.shouldSliver) {
      return getSliverList();
    } else {
      return getUnsliverList();
    }
  }

  Widget getUnsliverList() {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: _buildStatsCardDecoration(),
            margin: Utility.isHandsetBySize()
                ? EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 10,
                    CONSTANTS.missionPageMargin, 0)
                : EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 0,
                    CONSTANTS.missionPageMargin, 0),
            height: 100,
            child: Row(
              children: <Widget>[
                if (this.widget.folderModel?.tag == 5)
                  Expanded(
                    key: ValueKey('Expanded33212'),
                    child: HeaderItemWidget(
                      key: ValueKey('HeaderItemWidget32'),
                      shouldShowMins: false,
                      title: getI18NKey().complete_ratio,
                      value: this
                              .widget
                              .folderTimeModel
                              ?.objectivePercentString
                              .toString() ??
                          "",
                    ),
                    flex: 1,
                  ),
                if (this.widget.folderModel?.tag != 5)
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
                          "",
                    ),
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
                        "",
                  ),
                  flex: 1,
                ),
                if (this.widget.folderModel?.tag != 5)
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
                          "",
                    ),
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
                        "",
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            key: ValueKey('Container1322'),
            margin: EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 10,
                CONSTANTS.missionPageMargin, 0),
            padding: widget.useUnifiedStyle
                ? const EdgeInsets.all(10)
                : EdgeInsets.zero,
            decoration: widget.useUnifiedStyle
                ? buildUnifiedDesktopCardDecoration(
                    boxShadow: const [],
                  )
                : null,
            child: HeaderInputWidget(
              shouldShowFolderIcons: this.widget.shouldShowFolderIcons,
              folderModel: this.widget.folderModel ?? FolderModel(),
              key: HeaderInputStateGlobalKey,
              onChangeListener: this.widget.onChangeListener,
              text: this.widget.text,
              onDesktopSubmitListener: this.widget.onDesktopSubmitListener,
              onSubmitListener: this.widget.onSubmitListener,
              useUnifiedStyle: widget.useUnifiedStyle,
            ),
          ),
          this.widget.childAfterInputWidget == null
              ? SizedBox.shrink()
              : this.widget.childAfterInputWidget!,
        ],
      ),
    );
  }

  SliverList getSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return Container(
              decoration: _buildStatsCardDecoration(),
              margin: Utility.isHandsetBySize()
                  ? EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 10,
                      CONSTANTS.missionPageMargin, 0)
                  : EdgeInsets.fromLTRB(CONSTANTS.missionPageMargin, 0,
                      CONSTANTS.missionPageMargin, 0),
              height: 100,
              child: Row(
                children: <Widget>[
                  if (this.widget.folderModel?.tag == 5)
                    Expanded(
                      key: ValueKey('Expanded3321212'),
                      child: HeaderItemWidget(
                        key: ValueKey('HeaderItemWidget12332'),
                        shouldShowMins: false,
                        title: getI18NKey().complete_ratio,
                        value: this
                                .widget
                                .folderTimeModel
                                ?.objectivePercentString
                                .toString() ??
                            "",
                      ),
                      flex: 1,
                    ),
                  if (this.widget.folderModel?.tag != 5)
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
                  if (this.widget.folderModel?.tag != 5)
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
              padding: widget.useUnifiedStyle
                  ? const EdgeInsets.all(10)
                  : EdgeInsets.zero,
              decoration: widget.useUnifiedStyle
                  ? buildUnifiedDesktopCardDecoration(
                      boxShadow: const [],
                    )
                  : null,
              child: HeaderInputWidget(
                  shouldShowFolderIcons: this.widget.shouldShowFolderIcons,
                  folderModel: this.widget.folderModel ?? FolderModel(),
                  key: HeaderInputStateGlobalKey,
                  onChangeListener: this.widget.onChangeListener,
                  text: this.widget.text,
                  onDesktopSubmitListener: this.widget.onDesktopSubmitListener,
                  onSubmitListener: this.widget.onSubmitListener,
                  useUnifiedStyle: widget.useUnifiedStyle));
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
  bool useUnifiedStyle = false;

  HeaderInputWidget(
      {Key? key,
      this.shouldShowFolderIcons = true,
      this.useUnifiedStyle = false,
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
    borderSide:
        BorderSide(color: ThemeManager.getInstance().getInputBorderColor()),
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
      color: widget.useUnifiedStyle
          ? Colors.transparent
          : ThemeManager.getInstance().getInputThemeColor(),
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
              if (_value?.length == 1) {
                AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
                  "sceneType": "missionpage",
                  "eventType": "missionpage_add_task_input",
                  "description": "添加任务输入框",
                });
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
                color: ThemeManager.getInstance()
                    .getTextColor(defaultColor: Color(0xff404040)),
                fontWeight: FontWeight.w500),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              isDense: widget.useUnifiedStyle,
              contentPadding: EdgeInsets.only(
                  left: 60,
                  right: 75,
                  top: widget.useUnifiedStyle ? 8 : 0,
                  bottom: widget.useUnifiedStyle ? 8 : 0),
              counterStyle: TextStyle(color: Colors.transparent, fontSize: 0),
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
                    !(Utility.isHandsetBySize() == false &&
                            this.widget.shouldShowFolderIcons == true)
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
                    defaultColor: widget.useUnifiedStyle
                        ? const Color(0xFFC58B67)
                        : Color(0xffd5d5d5),
                    defaultDarkColor:
                        TextUtil.isEmpty(this.inputController?.text)
                            ? Color(0xff575757)
                            : Colors.white),
              ),
              // prefixIconColor: Color(0xffd5d5d5),
              border: _outlineInputBorder,
              prefixIconColor: ThemeManager.getInstance().getIconColor(
                  defaultColor: widget.useUnifiedStyle
                      ? const Color(0xFFC58B67)
                      : Color(0xffd5d5d5)),
              floatingLabelStyle: TextStyle(
                  color: widget.useUnifiedStyle
                      ? const Color(0xFFB69179).withValues(alpha: 0.96)
                      : ThemeManager.getInstance().getIconColor(),
                  fontSize: widget.useUnifiedStyle ? 13 : 14,
                  fontWeight: widget.useUnifiedStyle ? FontWeight.w600 : null),
              labelStyle: TextStyle(
                  color: widget.useUnifiedStyle
                      ? const Color(0xFFB69179).withValues(alpha: 0.88)
                      : ThemeManager.getInstance().getInputPlaceholderColor(
                          defaultColor: Color(0xffd5d5d5),
                          defaultDarkColor:
                              TextUtil.isEmpty(this.inputController?.text)
                                  ? Color(0xff575757)
                                  : Colors.white),
                  fontSize: widget.useUnifiedStyle ? 13 : 14,
                  fontWeight: widget.useUnifiedStyle ? FontWeight.w600 : null),
              //边框，一般下面的几个边框一起设置
              //keyboardType: TextInputType.number, //键盘类型
              //obscureText: true,//密码模式
              //背景颜色，必须结合filled: true,才有效
              hoverColor: ThemeManager.getInstance().getCardBackgroundColor(
                defaultColor: Colors.white,
              ),
              focusColor: ThemeManager.getInstance().getInputThemeColor(
                  defaultColor: widget.useUnifiedStyle
                      ? const Color(0xFFFFF8F2)
                      : Colors.white,
                  defaultDarkColor:
                      ThemeManager.getInstance().getBackgroundColor()),
              //右边距是为了放置番茄计数器
              fillColor: ThemeManager.getInstance().getInputThemeColor(
                  defaultColor: widget.useUnifiedStyle
                      ? const Color(0xFFFFF8F2)
                      : Colors.white),
              focusedBorder: widget.useUnifiedStyle
                  ? OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Color(0xFFE6D8C9)),
                    )
                  : _outlineInputBorder,
              enabledBorder: widget.useUnifiedStyle
                  ? OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Color(0xFFE6D8C9)),
                    )
                  : _outlineInputBorder,
              disabledBorder: widget.useUnifiedStyle
                  ? OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Color(0xFFE6D8C9)),
                    )
                  : _outlineInputBorder,
              focusedErrorBorder: widget.useUnifiedStyle
                  ? OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Color(0xFFE6D8C9)),
                    )
                  : _outlineInputBorder,
              errorBorder: widget.useUnifiedStyle
                  ? OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Color(0xFFE6D8C9)),
                    )
                  : _outlineInputBorder,
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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

class UnifiedMetricRing extends StatelessWidget {
  final String value;
  final String label;
  final String subtitle;
  final double progress;
  final Color color;

  const UnifiedMetricRing({
    super.key,
    required this.value,
    required this.label,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  Color get _ringTrackColor => color.withValues(alpha: 0.12);
  Color get _ringGlowColor => color.withValues(alpha: 0.20);
  Color get _ringShadowColor => color.withValues(alpha: 0.16);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 142,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 118,
            height: 118,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.98),
                  const Color(0xFFFFF8F0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _ringGlowColor,
                  blurRadius: 28,
                  spreadRadius: 6,
                ),
                BoxShadow(
                  color: _ringShadowColor,
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.92),
                  blurRadius: 16,
                  offset: const Offset(-5, -5),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFFBF7),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.92),
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.95),
                        blurRadius: 12,
                        offset: const Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: _ringShadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress <= 0 ? 0.02 : progress,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      backgroundColor: _ringTrackColor,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFFEFC),
                        Color(0xFFFFF5E9),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.96),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.95),
                        blurRadius: 10,
                        offset: const Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: _ringShadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F221B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A3426),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF846757),
            ),
          ),
        ],
      ),
    );
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
