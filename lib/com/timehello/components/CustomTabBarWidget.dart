import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../models/CheckButtonStateModel.dart';
import 'CheckContainer.dart';

/**
 * 文件类型：通用组件
 * 文件作用：用于在页面内展示一组单选 Tab，并把选中项回调给业务页面。
 * 主要职责：维护本组件的选中态、同步父组件传入的 checkIndex，并提供旧版下划线样式与新版统一胶囊样式。
 */
typedef OnCheckedListener = void Function(int obj, CheckButtonStateModel data);

class CustomTabBarWidget extends StatefulWidget {
  final List<CheckButtonStateModel> list;
  final OnCheckedListener onCheckedListener;
  final int? checkIndex;
  final double fontSize;
  final bool isAutoTrigger;
  final bool useUnifiedStyle;
  final Color? checkedTextColor;
  final Color? uncheckedTextColor;
  final Color? checkedIndicatorColor;
  final Color? uncheckedIndicatorColor;
  CustomTabBarWidget(
      {Key? key,
      required this.fontSize,
      required this.list,
      required this.onCheckedListener,
      this.isAutoTrigger = false,
      this.useUnifiedStyle = false,
      this.checkedTextColor,
      this.uncheckedTextColor,
      this.checkedIndicatorColor,
      this.uncheckedIndicatorColor,
      this.checkIndex = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomTabBarWidgetState(
        list: this.list,
        onCheckedListener: this.onCheckedListener,
        checkIndex: this.checkIndex);
  }
}

class CustomTabBarWidgetState extends State<CustomTabBarWidget> {
  OnCheckedListener onCheckedListener;
  int? checkIndex = 0;
  List<CheckButtonStateModel> list;
  // List<CheckModel> list = CONSTANTS.getTomatoesTabbar();

  CustomTabBarWidgetState(
      {required this.list,
      required this.onCheckedListener,
      required this.checkIndex}) {
    // setChecked(this.checkIndex ?? 0);
  }

  initState() {
    super.initState();
    setChecked(checkIndex ?? 0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (this.widget.isAutoTrigger == true && mounted == true) {
        this.onCheckedListener(checkIndex ?? 0, this.list[checkIndex ?? 0]);
      }
    });
    // AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "missionpage","eventType": "missionpage_calendar_date","description": "日期",});
  }

  @override
  void didUpdateWidget(CustomTabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isEqual(list1: oldWidget.list, list2: this.widget.list) == false) {
      this.list = this.widget.list;
      setChecked(this.widget.checkIndex ?? 0);
      return;
    }
    if (oldWidget.checkIndex != this.widget.checkIndex) {
      // 父页面可能在注册/找回密码返回后主动切换 Tab，这里必须同步内部状态，否则 UI 会看起来点了没反应。
      setChecked(this.widget.checkIndex ?? 0);
    }
  }

  //比较title
  bool isEqual(
      {List<CheckButtonStateModel> list1 = const [],
      List<CheckButtonStateModel> list2 = const []}) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].title != list2[i].title) {
        return false;
      }
    }
    return true;
  }

  resetList() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }

  /// 功能：切换当前选中的 Tab，并保护外部传入的 index 不越界。
  /// 说明：登录页等场景会根据地区或子页返回值动态设置 index，兜底后可避免异常中断点击反馈。
  void setChecked(int index) {
    if (this.list.isEmpty) {
      return;
    }
    final int safeIndex = index.clamp(0, this.list.length - 1).toInt();
    if (safeIndex == 0) {
      // AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "missionpage","eventType": "missionpage_calendar_date","description": "日期",});
    } else if (safeIndex == 1) {
      // AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "missionpage","eventType": "missionpage_time_period","description": "时间段",});
    }
    this.resetList();
    this.list[safeIndex].isCheck = true;
    this.checkIndex = safeIndex;
    setState(() {});
    // this.widget.list.forEach((element) {
    //   if (element.index == index) {
    //     element.isChecked = true;
    //   } else {
    //     element.isChecked = false;
    //   }
    // });
    // print(list);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  void updateUI() {
    setState(() {
      // list = list;
    });
  }

  List<Widget> getTabBarWidgets() {
    List<Widget> listWidget = [];
    for (int i = 0; i < this.list.length; i++) {
      CheckButtonStateModel model = this.list[i];
      if (widget.useUnifiedStyle) {
        listWidget.add(Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () async {
              this.onCheckedListener(i, model);
              this.setChecked(i);
              this.updateUI();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: model.isCheck == true
                    ? ThemeManager.getInstance().getCardBackgroundColor(
                        defaultColor: const Color(0xFFFFEFDD))
                    : ThemeManager.getInstance().getCardBackgroundColor(
                        defaultColor: const Color(0xFFFFFBF4)),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: model.isCheck == true
                      ? const Color(0xFFD9C2A6)
                      : const Color(0xFFECDDCA),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                model.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: model.isCheck == true
                      ? this.widget.fontSize
                      : this.widget.fontSize - 1,
                  fontWeight:
                      model.isCheck == true ? FontWeight.w700 : FontWeight.w500,
                  color: ThemeManager.getInstance().getTextColor(
                      defaultColor: model.isCheck == true
                          ? const Color(0xFF4A3224)
                          : const Color(0xFF8B7767)),
                ),
              ),
            ),
          ),
        ));
        continue;
      }
      listWidget.add(Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: CheckContainer(
          // data: model,
          isNeedUpdateUI: false,
          checked: model.isCheck,
          onCheckedListener: (index, data) async {
            this.onCheckedListener(i, model);
            this.setChecked(i);
            this.updateUI();
          },
          checkWidget: Column(
            children: [
              Text(
                model.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: this.widget.fontSize,
                    color: ThemeManager.getInstance().getTextColor(
                        defaultColor: widget.checkedTextColor ??
                            ColorsConfig.tabbarChecked)),
              ),
              Container(
                width: 20,
                height: 2,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.checkedIndicatorColor ??
                        ThemeManager.getInstance().getDefautThemeColor()),
              )
            ],
          ),
          uncheckWidget: Column(
            children: [
              Text(
                model.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: this.widget.fontSize - 2,
                    color: ThemeManager.getInstance().getTextColor(
                        defaultColor: widget.uncheckedTextColor ??
                            ColorsConfig.tabbarUnchecked,
                        defaultDarkColor: Color(0xff999999))),
              ),
              Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.uncheckedIndicatorColor ??
                        (ThemeManager.getInstance().isDark()
                            ? null
                            : Colors.white)),
              )
            ],
          ),
        ),
      ));
    }
    return listWidget;
  }

  Widget build(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: getTabBarWidgets(),
        ),
      );
    }
    return Row(
      children: getTabBarWidgets(),
    );
    // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }
}
