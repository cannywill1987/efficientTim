import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../config/CONSTANTS.dart';
import '../models/CheckButtonStateModel.dart';

class CustomPopupWidget extends StatelessWidget {
  final Function onSelected;
  final List<CheckButtonStateModel> list;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final bool useSoftPopupStyle;
  final double popupWidth;

  CustomPopupWidget(
      {required this.onSelected,
      required this.list,
      required this.child,
      this.margin,
      this.useSoftPopupStyle = false,
      this.popupWidth = 180});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getPopupMenu();
  }

  Container getPopupMenu() {
    return Container(
      key: ValueKey('Container5'),
      margin: margin ?? EdgeInsets.only(right: CONSTANTS.missionPageMargin),
      child: PopupMenuButton<String>(
        key: ValueKey('PopupMenuButton5'),
        tooltip: '',
        padding: EdgeInsets.all(0.0),
        offset: useSoftPopupStyle ? const Offset(0, 8) : Offset.zero,
        color: ThemeManager.getInstance()
            .getBackgroundColor(defaultColor: Colors.white),
        elevation: useSoftPopupStyle ? 18 : 8,
        constraints: useSoftPopupStyle
            ? BoxConstraints.tightFor(width: popupWidth)
            : null,
        shape: useSoftPopupStyle
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
            : null,
        child: this.child,
        // onSelected: (String val) {
        //   this.onSelected.call(getModelByKey(val).color);
        // },
        itemBuilder: (context) {
          return getPopupMenuItem();
        },
      ),
    );
  }

  CheckButtonStateModel getModelByKey(String key) {
    CheckButtonStateModel? model;
    this.list.forEach((element) {
      if (element.code == key) {
        model = element;
      }
    });
    return model!;
  }

  List<PopupMenuEntry<String>> getPopupMenuItem() {
    List<PopupMenuEntry<String>> list = [];
    this.list.forEach((CheckButtonStateModel element) {
      list.add(PopupMenuItem<String>(
        height: useSoftPopupStyle ? 58 : kMinInteractiveDimension,
        padding: useSoftPopupStyle ? EdgeInsets.zero : null,
        onTap: () {
          Future.delayed(Duration(milliseconds: 200), () {
            this.onSelected.call(element);
          });
        },
        key: ValueKey(element.title),
        value: element.code,
        child: useSoftPopupStyle
            ? getSoftPopupMenuItem(element)
            : Container(
                child: element.checkIcon == null
                    ? getTitleText(element)
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          element.checkIcon!,
                          SizedBox(
                            width: 6,
                          ),
                          if (element.content != null &&
                              element.content!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                getTitleText(element),
                                Text(
                                  element.content ?? "",
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xffc0c0c0)),
                                ),
                              ],
                            ),
                          if (!(element.content != null &&
                              element.content!.isNotEmpty))
                            getTitleText(element),
                          Spacer()
                        ],
                      ),
              ),
      ));
    });
    return list;
  }

  Widget getSoftPopupMenuItem(CheckButtonStateModel element) {
    final Color textColor = ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF2D211A), defaultDarkColor: Colors.white);
    return SizedBox(
      width: popupWidth,
      child: Padding(
        // 右上角任务菜单使用固定内边距，避免 hover 时出现横向抖动。
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E7),
                borderRadius: BorderRadius.circular(9),
              ),
              child: SizedBox(
                width: 15,
                height: 15,
                child: element.checkIcon ?? const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                element.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.2,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text getTitleText(CheckButtonStateModel element) {
    return Text(
      element.title ?? "",
      style: TextStyle(
          fontSize: 12,
          color: ThemeManager.getInstance()
              .getTextColor(defaultColor: Color(element.color ?? 0xff404040))),
    );
  }
}
