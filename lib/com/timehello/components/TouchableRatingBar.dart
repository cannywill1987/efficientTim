import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';

class RatingBar extends StatefulWidget {
  int number = 3;

  RatingBar({this.number = 3});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RatingBarState();
  }
}

class RatingBarState extends State<RatingBar> {


  List<Widget> listCheckImage = [
    CheckImage(checkIcon: Icon(Icons.watch, color: ColorsConfig.darkRed,),uncheckIcon:Icon(Icons.watch, color: ColorsConfig.darkRed,),),
    CheckImage(checkIcon: Icon(Icons.watch, color: ColorsConfig.darkRed,),uncheckIcon:Icon(Icons.watch, color: ColorsConfig.darkRed,),),
    CheckImage(checkIcon: Icon(Icons.watch, color: ColorsConfig.darkRed,),uncheckIcon:Icon(Icons.watch, color: ColorsConfig.darkRed,),),
    CheckImage(checkIcon: Icon(Icons.watch, color: ColorsConfig.darkRed,),uncheckIcon:Icon(Icons.watch, color: ColorsConfig.darkRed,),),
    CheckImage(checkIcon: Icon(Icons.watch, color: ColorsConfig.darkRed,),uncheckIcon:Icon(Icons.watch, color: ColorsConfig.darkRed,),),
  ];
  int curState = 0;

  List<Widget> getCheckImageByNumber() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.number; i++) {
      list.add(CheckImage(checkIcon: Icon(Icons.watch, color: ColorsConfig.darkRed,),uncheckIcon:Icon(Icons.watch, color: ColorsConfig.darkRed,),),);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    listCheckImage = this.getCheckImageByNumber();
    List<Widget> arr = <Widget>[];
    for(int i = 0; i < listCheckImage.length; i++) {
      CheckImage item = listCheckImage![i] as CheckImage;
      if (i < curState) {
        item.setChecked(true);
      } else {
        item.setChecked(false);
      }
      arr.add(Expanded(
          child: GestureDetector(
              onTap: () {
                setState(() {
                  curState = i + 1;
                });
              },
              onHorizontalDragStart: (e) {
                setState(() {
                  curState = i + 1;
                });
                print('result is $i');
              },
              onHorizontalDragUpdate: (e) {
                curState = i + 1;
              },
              child: item),
          flex: 1));
    }
    return Container(
      width: 100,
      height: 20,
      child: Row(
        children: arr,
      ),
    );
  }
}
