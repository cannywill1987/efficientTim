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

  TagsGridViewWidget(
      {this.onTapAddTagListener,
      this.onTapDeleteTagListener,
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
        )
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
      list.add(InkWell(
        onTap: () {
          if (this.widget.onTapDeleteTagListener != null) {
            this.widget.onTapDeleteTagListener!(this.widget.datas[index]);
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            margin: EdgeInsets.only(right: 5),
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
                  width: 1,
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
    Color color = ThemeManager.getInstance().getColor(defaultColor: Color(0xff909090));
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: color),
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
                Icon(Icons.add, size: 14, color: color),
                SizedBox(
                  width: 3,
                ),
                Text(
                  getI18NKey().add_tag,
                  style: TextStyle(color: color, fontSize: 11),
                ),
              ],
            )));
  }
}
