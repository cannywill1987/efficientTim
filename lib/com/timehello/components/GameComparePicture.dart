import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import '../beans/GameAnswerJsonBean.dart';
import 'WrongWidget.dart';

class GameComparePicture extends StatefulWidget {
  String picRefUrl;
  String picUrl;
  List<GameAnswerJsonBean> listGameAnswerJsonBean;
  Function onResultCallback;
  Function errorCallback;
  bool isEnabled = false;
  GameComparePicture(
      {Key? key,
        required this.isEnabled,
        required this.onResultCallback,
        required this.errorCallback,
      required this.listGameAnswerJsonBean,
      required this.picRefUrl,
      required this.picUrl})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GameComparePictureState();
  }
}

class _GameComparePictureState extends State<GameComparePicture> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color(0xff404040)),
              color: Color(0xff404040),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GameComparePictureItem(
                  isEnabled: this.widget.isEnabled,
                    correctCallback: (numCorrect, total) { //正确回调
                      this.widget.onResultCallback(numCorrect, total);
                      setState(() {});
                    },
                    listGameAnswerJsonBean: this.widget.listGameAnswerJsonBean,
                     errorCallback: () {
                      this.widget.errorCallback();
                     },
                    url: this.widget.picRefUrl),
                Container(
                  width: 2,
                  height: 2,
                  color: Color(0xff404040),
                ),
                GameComparePictureItem(
                  isEnabled: this.widget.isEnabled,
                  correctCallback: (numCorrect, total) { //正确回调
                    this.widget.onResultCallback(numCorrect, total);
                    setState(() {});
                  },
                  listGameAnswerJsonBean: this.widget.listGameAnswerJsonBean,
                  errorCallback: () {
                    this.widget.errorCallback();
                  },
                    url: this.widget.picUrl, )
              ],
            ))
      ],
    );
  }
}

class GameComparePictureItem extends StatefulWidget {
  // GameAnswerJsonBean gameAnswerJsonBean;
  String url;
  List<GameAnswerJsonBean> listGameAnswerJsonBean;
  Function correctCallback;
  Function errorCallback;
  bool isEnabled = false;
  GameComparePictureItem(
      {required this.isEnabled,
        required this.correctCallback,
        required this.errorCallback,
      required this.listGameAnswerJsonBean,
      required this.url});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GameComparePictureItemState();
  }
}

class _GameComparePictureItemState extends State<GameComparePictureItem> {
  double curX = -1;
  double curY = -1;
  bool isWrongWidgetVisible = false;

  Map getNumCorrect() {
    int countCorrect = 0;
    for (int i = 0; i < this.widget.listGameAnswerJsonBean.length; i++) {
      GameAnswerJsonBean bean = this.widget.listGameAnswerJsonBean[i];
      if(bean.isChecked == true) {
        countCorrect ++;
      } else {

      }
    }
    return {"numCorrect": countCorrect, "total": this.widget.listGameAnswerJsonBean};
  }

  List<Widget> getListJsonWidget() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.listGameAnswerJsonBean.length; i++) {
      GameAnswerJsonBean bean = this.widget.listGameAnswerJsonBean[i];
      if (bean.mode == "circle") {
        list.add(Positioned(
            top: (bean.offsetYHere! - bean.radiusHere!),
            left: (bean.offsetXHere! - bean.radiusHere!),
            child: GestureDetector(
                onTap: () {
                  if(this.widget.isEnabled == false) return;
                  if (bean.isChecked == true) return;
                  bean.isChecked = true;
                  this.widget.correctCallback(getNumCorrect()["numCorrect"], getNumCorrect()["total"].length);
                },
                child: Container(
                  width: (bean.radiusHere ?? 20) * 2,
                  height: (bean.radiusHere ?? 20) * 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(bean.radiusHere ?? 20)),
                      border: Border.all(
                          width: 2,
                          color: bean.isChecked == true
                              ? Colors.red
                              : Colors.transparent)),
                ))));
      } else {
        list.add(Positioned(
            top: (bean.offsetYHere!),
            left: (bean.offsetXHere!),
            child: GestureDetector(
                onTap: () {
                  if(this.widget.isEnabled == false) return;
                  if (bean.isChecked == true) return;
                  bean.isChecked = true;
                  this.widget.correctCallback(getNumCorrect()["numCorrect"], getNumCorrect()["total"].length);
                },
                child: Container(
                  width: bean.widthGuideHere,
                  height: bean.heightGuideHere,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(2)),
                      border: Border.all(
                          width: 2,
                          color: bean.isChecked == true
                              ? Colors.red
                              : Colors.transparent)),
                ))));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        GestureDetector(
            onTapUp: (TapUpDetails detail) {
              if(this.widget.isEnabled == false) return;
              this.curX = detail.localPosition.dx;
              this.curY = detail.localPosition.dy;
              this.isWrongWidgetVisible = true;
              this.widget.errorCallback();
              setState(() {

              });
              print(
                  "dx: ${detail.localPosition.dx}, dy: ${detail.localPosition.dy} ");
            },
            child: Container(
              child: (this.widget.listGameAnswerJsonBean != null && this.widget.listGameAnswerJsonBean.length > 0) ? WidgetManager.getCachedNetworkImage(
                  isLoading: false,
                  radius: 0,
                  width: this.widget.listGameAnswerJsonBean[0].widthWidgetHere ?? 0,
                  height:
                      this.widget.listGameAnswerJsonBean[0].heightWidgetHere ?? 0,
                  url: this.widget.url): SizedBox.shrink(),
            )),
        ...getListJsonWidget(),
        WrongWidget(
          left: curX,
          top: curY,
          sizeIcon: 20,
          isWrongWidgetVisible: this.isWrongWidgetVisible,
          callbackStateChange: (bool isCorrect) {
            this.isWrongWidgetVisible = isCorrect;
          },
        )
      ],
    );
  }
}
