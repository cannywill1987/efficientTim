import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/GameManager.dart';

import '../../../config/ENUMS.dart';
import '../../../models/SquareModel.dart';
import 'SingleCharTextWidget.dart';

class RandomContainerWidget extends StatefulWidget {
  late List<SquareModel> list;
  late double width;
  late double height;
  Function onComplete;
  RandomContainerWidget({
    required double width,
    required double height,
    required List<SquareModel> list,
    required this.onComplete,
  }) {
    this.width = width;
    this.height = height;
    this.list = list;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RandomContainerWidgetState();
  }
}


class _RandomContainerWidgetState extends State<RandomContainerWidget> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(maxHeight: this.widget.height, maxWidth: this.widget.width),
      width: this.widget.width,
      height: this.widget.height,
      child: Stack(
        children: getRandomWidget(),
      ),
    );
  }

  List<Widget> getRandomWidget() {
    List<Widget> listWidget = [];
    for (SquareModel squareModel in this.widget.list) {
      listWidget.add(Positioned(
          left: squareModel.posX,
          top: squareModel.posY,
          child: SingleCharTextWidget(
              onCheckListener: (bool isCheck) {
                GameItemStatusEnum gameItemStatusEnum = GameManager.isSquareModelCorrect(list: this.widget.list, squareModel: squareModel);
                if(gameItemStatusEnum == GameItemStatusEnum.correct) {
                  squareModel.isChecked = true;
                  setState(() {

                  });
                } else if (gameItemStatusEnum == GameItemStatusEnum.complete) {
                  squareModel.isChecked = true;
                  setState(() {

                  });
                    this.widget.onComplete();
                } else { //点击错误

                }
              },
              text: squareModel.val,
              isEnable: false,
              itemWidth: squareModel.width,
              isChecked: squareModel.isChecked,
              gameDotPositionEnum:GameDotPositionEnum.random.index,
              itemHeight: squareModel.height)));
    }
    return listWidget;
  }
}
