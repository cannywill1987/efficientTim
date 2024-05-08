import 'package:flutter/material.dart';

import '../../../../../r.dart';
import '../../../beans/GameAnswerJsonBean.dart';
import '../../../beans/GameComparePictureBean.dart';
import '../../../config/ENUMS.dart';
import '../../../interface/OnTapListener.dart';
import '../../../util/Utility.dart';
import '../../../util/WidgetManager.dart';
import 'SingleCharTextWidget.dart';

class CustomNumsMissionGridviewWidget extends StatefulWidget {
  List<GameComparePictureBean> datas = [];
  OnTapListener? onTapListener;
  double? itemWidth;

  CustomNumsMissionGridviewWidget(
      {this.itemWidth = 50,
      required OnTapListener onTapListener,
      required List<GameComparePictureBean> datas}) {
    this.onTapListener = onTapListener;
    this.datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomNumsMissionGridviewWidgetState();
  }
}

class CustomNumsMissionGridviewWidgetState
    extends State<CustomNumsMissionGridviewWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return GridView.count(
    //   //屏蔽GridView内部滚动；
    //   physics: new NeverScrollableScrollPhysics(),
    //   crossAxisCount: 5,
    //   shrinkWrap:true,
    //   padding: EdgeInsets.all(5.0),
    //   children: [getItem(0)],
    // );

    return GridView.builder(
      itemCount: this.widget.datas.length,
      physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return getItem(index + 1, this.widget.datas[index]);
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //单个子Widget的水平最大宽度
          maxCrossAxisExtent: 40, //水平单个子Widget之间间距
          mainAxisSpacing: 20.0, //垂直单个子Widget之间间距
          crossAxisSpacing: 10.0),
    );
  }

  Widget getItem(int index, GameComparePictureBean bean) {
    Color color = Utility.getRandomColor();
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: GestureDetector(onTap: () {
          if(this.widget.onTapListener != null) {
            this.widget.onTapListener!(bean);
          }
        }, child:Container(
          width: this.widget.itemWidth ?? 100,
          height: this.widget.itemWidth ?? 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(this.widget.itemWidth ?? 100)),
            border: Border.all(width: 2, color: color),
          ),
          alignment: Alignment.center,
          // width: this.widget.itemWidth,
          // height: this.widget.itemWidth,
          child: Text(
            index.toString(),
          ),
        ) ));
  }
}
