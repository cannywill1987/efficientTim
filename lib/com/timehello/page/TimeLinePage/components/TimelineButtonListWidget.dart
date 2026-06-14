/**
 * 文件类型：组件
 * 文件作用：时间轴页面底部的类型切换器。
 * 主要职责：展示全部、事件、笔记、日记和理财筛选项，并把当前选中项回传给页面。
 */
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class TimelineButtonListWidget extends StatefulWidget {
  final List<CheckButtonStateModel> list;
  final OnTapListener onTapListener;
  final double? width;
  final int? initIndex;
  final bool shouldShowPopupWhenPC;

  TimelineButtonListWidget(
      {this.initIndex = 0,
      this.shouldShowPopupWhenPC = false,
      required this.list,
      required this.onTapListener,
      this.width = 80});

  @override
  State<StatefulWidget> createState() {
    return TimelineButtonListWidgetState(
        list: this.list, curIndex: this.initIndex ?? 0);
  }
}

class TimelineButtonListWidgetState extends State<TimelineButtonListWidget> {
  int curIndex = 0;
  List<CheckButtonStateModel> list;

  TimelineButtonListWidgetState({required this.curIndex, required this.list});

  @override
  Widget build(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          isDark ? const Color(0xff394156) : Color(0xff7171ed),
                      width: 1),
                  color: ThemeManager.getInstance()
                      .getCardBackgroundColor(defaultColor: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.24 : 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ]),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getList(this.list)))
        ]);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < this.list.length; i++) {
      CheckButtonStateModel model = this.list[i];
      if (this.curIndex == i) {
        model.isCheck = true;
      } else {
        model.isCheck = false;
      }
    }
  }

  CheckButtonStateModel? getCurModel() {
    for (int i = 0; i < this.list.length; i++) {
      CheckButtonStateModel model = this.list[i];
      if (model.isCheck) {
        return model;
      }
    }
    return null;
  }

  /**
   * 功能：生成底部筛选按钮列表。
   */
  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(SizedBox(width: 10));
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  /**
   * 功能：构建单个筛选按钮，并在点击后同步选中态。
   */
  Widget getCheckButton(CheckButtonStateModel model, int index) {
    final bool isDark = _isDarkMode(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        height: 40,
        decoration: model.isCheck == true
            ? BoxDecoration(
                color: Color(0xff7171ed),
                borderRadius: BorderRadius.all(Radius.circular(20)))
            : BoxDecoration(
                color: isDark
                    ? const Color(0xff202635)
                    : ThemeManager.getInstance().getCardBackgroundColor(
                        defaultColor: Color(0xfff5f4f9)),
                borderRadius: BorderRadius.all(Radius.circular(20))),
        child: GestureDetector(
          onTap: () {
            this.initModelListState();
            setState(() {
              if (model.isCheck == false) {
                this.widget.onTapListener({"data": model, "index": index});
              }
              model.isCheck = true;
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              new Text(
                model.title ?? '',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: model.isCheck == true
                    ? TextStyle(color: Colors.white, fontSize: 15)
                    : TextStyle(
                        color: ThemeManager.getInstance().getTextColor(
                            defaultColor: Color(0xff404040),
                            defaultDarkColor: const Color(0xffd8deea)),
                        fontSize: 15),
              )
            ],
          ),
        ));
  }

  /**
   * 功能：清空所有按钮选中态，再由点击项重新设置选中。
   */
  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }

  /**
   * 功能：读取当前主题模式，让悬浮切换器和页面主题保持一致。
   */
  bool _isDarkMode(BuildContext context) {
    return ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
  }
}
