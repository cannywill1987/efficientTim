import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/WQBFolderModel.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import 'WQBTitle.dart';

/**
 * mission设置页面的tag
 */
class WQBTagsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapDeleteTagListener;
  OnTapListener? onTapAddTagListener;
  OnTapListener? onTapSelectedListener;

  // List<WQBFolderModel> datas = [];
  WQBMissionModel wqbMissionModel;

  WQBTagsGridViewWidget({
    this.onTapAddTagListener,
    required this.wqbMissionModel,
    this.onTapDeleteTagListener,
    this.onTapSelectedListener,
  });

  @override
  State<StatefulWidget> createState() {
    return _WQBTagsGridViewWidgetState();
  }
}

class _WQBTagsGridViewWidgetState extends State<WQBTagsGridViewWidget> {
  int curIndex = 0;

  @override
  void onCreate() {}

  @override
  void initState() {}

  @override
  void didUpdateWidget(WQBTagsGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    List<Widget> list = getItems();
    // WQBTitle(title: "题目来源"),
    return Column(
      // spacing: 3,
      // runSpacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleContainerWidget(
          title: getI18NKey().tag,
        ),
        Container(
            width: double.infinity,
            height: 2,
            color: ColorsConfig.borderLineColor),
        SizedBox(height: 5,),
        Wrap(
          spacing: 3,
          runSpacing: 5,
          children: [...list],)
      ],
    );
  }

  /**
   * 每个tag items
   */
  getItems() {
    List<Widget> list = [];
    for (int index = 0;
        index < (this.widget.wqbMissionModel.tagNames?.length ?? 0);
        index++) {
      Map map = this.widget.wqbMissionModel.tagNames?[index];
      list.add(GestureDetector(
        onTap: () {
          // this.curIndex = index;
          // if (this.widget.onTapSelectedListener != null) {
          //   this.widget.onTapSelectedListener!(this.widget.wqbMissionModel[index]);
          // }
          // setState(() {});
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
                border: this.curIndex == index
                    ? Border.all(width: 1, color: Color(map['color']))
                    : null,
                color: Color(map['color'] - 0xa0000000),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  map['title'] ?? "",
                  style: TextStyle(
                      color: Color(
                        map['color'],
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
