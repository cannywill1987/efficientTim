import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * mission设置页面的tag
 */
class TagsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapDeleteTagListener;
  OnTapListener? onTapAddTagListener;
  List<FolderModel> datas = [];
  Widget? child;
  TagsGridViewWidget(
      {this.onTapAddTagListener,
      this.onTapDeleteTagListener,
        this.child,
      required this.datas});

  @override
  State<StatefulWidget> createState() {
    return _TagsGridViewWidgetState();
  }
}

class _TagsGridViewWidgetState extends State<TagsGridViewWidget> {
  @override
  void onCreate() {}

  @override
  void initState() {
  }

  @override
  void didUpdateWidget(TagsGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: Utility.isHandsetBySize() ? (MediaQuery.of(context).size.width - 30) : 250,
          child: Wrap(
            spacing: 2, //主轴上子控件的间距
            runSpacing: 5, //交叉轴上子控件之间的间距
            children: getItems(),
          ),
        ),
        if(this.widget.child != null)
        Spacer(),
        if(this.widget.child != null)
        this.widget.child!
      ],
    );
  }

  /**
   * 每个tag items
   */
  getItems() {
    List<Widget> list = [];
    for (int index = 0; index < this.widget.datas.length; index++) {
      FolderModel folderModel = this.widget.datas[index];
      list.add(GestureDetector(
        onTap: () {
          if (this.widget.onTapDeleteTagListener != null) {
            this.widget.onTapDeleteTagListener!(this.widget.datas[index]);
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
                color: Color(folderModel.color - 0xa0000000),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  folderModel.title ?? "",
                  style: TextStyle(
                      color: Color(
                        folderModel.color,
                      ),
                      fontSize: 13),
                ),
                SizedBox(
                  width: 3,
                ),
                GestureDetector(
                    onTap: () {
                      if (this.widget.onTapDeleteTagListener != null) {
                        this.widget.onTapDeleteTagListener!(folderModel);
                      }
                    },
                    child: Icon(Icons.close_sharp,
                        size: 14, color: Color(folderModel.color)))
              ],
            )),
      ));
    }
    list.add(getButton());
    return list;
  }

  Widget getButton() {
    Color color = Color(0xff909090);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: ThemeManager.getInstance().getTextColor(defaultColor: color)),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: GestureDetector(
            onTap: () {
              if (this.widget.onTapAddTagListener != null) {
                this.widget.onTapAddTagListener!(null);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: ThemeManager.getInstance().getIconColor(defaultColor: color)),
                SizedBox(
                  width: 3,
                ),
                Text(
                  getI18NKey().tag,
                  style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: color), fontSize: 11),
                ),
              ],
            )));
  }
}
