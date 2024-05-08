import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * mission设置页面的tag
 */
class TimeLineTagsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapDeleteTagListener;
  OnTapListener? onTapAddTagListener;
  OnTapListener? onTapSelectedListener;
  List<FolderModel> datas = [];

  TimeLineTagsGridViewWidget(
      {this.onTapAddTagListener,
      this.onTapDeleteTagListener,
        this.onTapSelectedListener,
      required this.datas});

  @override
  State<StatefulWidget> createState() {
    return _TimeLineTagsGridViewWidgetState();
  }
}

class _TimeLineTagsGridViewWidgetState extends State<TimeLineTagsGridViewWidget> {
  int curIndex = 0;
  @override
  void onCreate() {}

  @override
  void initState() {
  }

  @override
  void didUpdateWidget(TimeLineTagsGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    List<Widget> list = getItems();
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 26,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return list[index];
          }
      ),
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
   * 每个tag items
   */
  getItems() {
    List<Widget> list = [];
    for (int index = 0; index < this.widget.datas.length; index++) {
      FolderModel folderModel = this.widget.datas[index];
      list.add(GestureDetector(
        onTap: () {
          this.curIndex = index;
          if (this.widget.onTapSelectedListener != null) {
            this.widget.onTapSelectedListener!(this.widget.datas[index]);
          }
          setState(() {

          });
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
                border: this.curIndex ==  index ? Border.all(width: 1, color: Color(folderModel.color)) : null,
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

  Widget getButton() {
    Color color = Color(0xff909090);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
                  getI18NKey().add_listing,
                  style: TextStyle(color: color, fontSize: 11),
                ),
              ],
            )));
  }
}
