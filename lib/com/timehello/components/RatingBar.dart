import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

class RatingBar extends StatefulWidget {
  int curNumber = 0;
  int number = 3;
  double size = 17;

  RatingBar({this.size = 15, this.curNumber = 0, this.number = 3});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RatingBarState();
  }
}

class RatingBarState extends State<RatingBar> {
  // List<Widget>? listCheckImage;
  int curState = 0;

  @override
  void initState() {
    // listCheckImage = [
    //   CheckImage(
    //     checkIcon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked,
    //         size: this.widget.size),
    //     uncheckIcon: Icon(
    //       Icons.watch,
    //       color: ColorsConfig.darkRed,
    //     ),
    //   ),
    //   CheckImage(
    //     checkIcon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: this.widget.size),
    //     uncheckIcon: Icon(
    //       Icons.watch,
    //       color: ColorsConfig.darkRed,
    //     ),
    //   ),
    //   CheckImage(
    //     checkIcon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: this.widget.size),
    //     uncheckIcon: Icon(
    //       Icons.watch,
    //       color: ColorsConfig.darkRed,
    //     ),
    //   ),
    //   CheckImage(
    //     checkIcon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: this.widget.size),
    //     uncheckIcon: Icon(
    //       Icons.watch,
    //       color: ColorsConfig.darkRed,
    //     ),
    //   ),
    //   CheckImage(
    //     checkIcon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: this.widget.size),
    //     uncheckIcon: Icon(
    //       Icons.watch,
    //       color: ColorsConfig.darkRed,
    //     ),
    //   ),
    // ];
  }

  List<Widget> getCheckImageByNumber() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.number; i++) {
      list.add(
        CheckImage(
          checkIcon:
              Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: this.widget.size),
          uncheckIcon: Icon(
            Icons.watch,
            color: ColorsConfig.darkRed,
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //获取星星
    // if (listCheckImage.length <= 5) {
    //   listCheckImage = this.getCheckImageByNumber();
    //   List<Widget> arr = <Widget>[];
    //   for (int i = 0; i < listCheckImage.length; i++) {
    //     CheckImage item = listCheckImage[i];
    //     if (i < curState) {
    //       item.setChecked(true);
    //     } else {
    //       item.setChecked(false);
    //     }
    //   }
    //   return Container(
    //     constraints: BoxConstraints.expand(width: double.infinity, height: 16),
    //     child: Wrap(
    //       children: arr,
    //     ),
    //   );
    // } else {
    return Container(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Image.asset(R.assetsImgIcLogoRed, width: this.widget.size, height: this.widget.size,),
          // Utility.getSVGPicture(R.assetsImgIcLogoRed, size: this.widget.size),
          SizedBox(width: 1),
          Text(this.widget.curNumber.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: this.widget.size,
                  color: ColorsConfig.red)),
          SizedBox(width: 1),
          Text("/",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: this.widget.size,
                  color: ColorsConfig.red)),
          SizedBox(width: 1),
          Image.asset(R.assetsImgIcLogoOrange, width: this.widget.size, height: this.widget.size,),
          // Utility.getSVGPicture(R.assetsImgIcLogoOrange, size: this.widget.size),
          SizedBox(width: 1),
          Text(this.widget.number.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: this.widget.size,
                  color: ColorsConfig.darkRedUnselected)),
        ],
      ),
    );
    // }
  }
}
