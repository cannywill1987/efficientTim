/**
 * 文件类型：组件
 * 文件作用：时间轴页面顶部的清单标签筛选条。
 * 主要职责：横向展示清单标签、维护当前选中项，并提供新增清单入口。
 */
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class TimeLineTagsGridViewWidget extends StatefulWidget {
  final OnTapListener? onTapDeleteTagListener;
  final OnTapListener? onTapAddTagListener;
  final OnTapListener? onTapSelectedListener;
  final List<FolderModel> datas;

  const TimeLineTagsGridViewWidget(
      {this.onTapAddTagListener,
      this.onTapDeleteTagListener,
      this.onTapSelectedListener,
      required this.datas,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimeLineTagsGridViewWidgetState();
  }
}

class _TimeLineTagsGridViewWidgetState
    extends State<TimeLineTagsGridViewWidget> {
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(TimeLineTagsGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = getItems();
    return Container(
      height: Utility.isHandsetBySize() ? 38 : 42,
      padding: EdgeInsets.only(
        left: Utility.isHandsetBySize() ? 8 : 14,
        right: Utility.isHandsetBySize() ? 8 : 14,
        top: 6,
        bottom: 6,
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return list[index];
          }),
    );
    // return Row(
    //   mainAxisSize: MainAxisSize.max,
    //   children: [
    //     Container(
    //       // color: Colors.white,
    //       // width: Utility.isHandsetBySize() ? (MediaQuery.of(context).size.width - 30) : 250,
    //       child: Wrap(
    //         spacing: 2, //主轴上子控件的间距
    //         runSpacing: 5, //交叉轴上子控件之间的间距
    //         children: getItems(),
    //       ),
    //     )
    //   ],
    // );
  }

  /**
   * 功能：构建所有标签 chip。
   * 说明：标签使用业务色作为强调色，选中态通过边框和更深背景表达，保证快速扫视。
   */
  getItems() {
    List<Widget> list = [];
    for (int index = 0; index < this.widget.datas.length; index++) {
      FolderModel folderModel = this.widget.datas[index];
      final bool isSelected = this.curIndex == index;
      final Color tagColor = Color(folderModel.color);
      final bool isDark = _isDarkMode(context);
      list.add(GestureDetector(
        onTap: () {
          this.curIndex = index;
          if (this.widget.onTapSelectedListener != null) {
            this.widget.onTapSelectedListener!(this.widget.datas[index]);
          }
          setState(() {});
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
            decoration: BoxDecoration(
                border: Border.all(
                  width: isSelected ? 1 : 0.8,
                  color: isSelected
                      ? tagColor
                      : (isDark
                          ? const Color(0xff303849)
                          : tagColor.withValues(alpha: 0.18)),
                ),
                color: tagColor.withValues(alpha: isSelected ? 0.18 : 0.10),
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  folderModel.title ?? "",
                  style: TextStyle(
                      color: tagColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 11),
                ),
                // SizedBox(
                //   width: 3,
                // ),
                // GestureDetector(
                //     onTap: () {
                //       if (this.widget.onTapDeleteTagListener != null) {
                //         this.widget.onTapDeleteTagListener!(folderModel);
                //       }
                //     },
                //     child: Icon(Icons.close_sharp,
                //         size: 14, color: Color(folderModel.color)))
              ],
            )),
      ));
    }
    list.add(getButton());
    return list;
  }

  /**
   * 功能：构建新增清单按钮。
   */
  Widget getButton() {
    final bool isDark = _isDarkMode(context);
    Color color = isDark ? const Color(0xffa5afc2) : Color(0xff737986);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
        decoration: BoxDecoration(
            color: isDark ? const Color(0xff171d28) : Colors.white,
            border: Border.all(width: 1, color: color.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.all(Radius.circular(18))),
        child: GestureDetector(
            onTap: () {
              if (this.widget.onTapAddTagListener != null) {
                this.widget.onTapAddTagListener!(null);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: color),
                SizedBox(
                  width: 3,
                ),
                Text(
                  getI18NKey().add_listing,
                  style: TextStyle(color: color, fontSize: 11),
                ),
              ],
            )));
  }

  /**
   * 功能：读取当前主题模式，保证标签栏亮色和暗色都有清晰对比。
   */
  bool _isDarkMode(BuildContext context) {
    return ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
  }
}
