import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../util/Utility.dart';

class CheckButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  String unit = getI18NKey().min_en;
  bool isMultiSelected = false;

  CheckButtonListWidget(
      {required this.list,
      required this.onTapListener,
      unit,
      this.isMultiSelected: false}) {
    this.unit = unit ?? getI18NKey().min_en;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CheckButtonListWidgetState(list: list);
  }
}

class CheckButtonListWidgetState extends State<CheckButtonListWidget> {
  List<CheckButtonStateModel> list = [];

  CheckButtonListWidgetState({required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getList(this.list)));
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    if (model.isCheck == true) {
      return TextButton(
          style: StylesConfig.transparentTextButtonStyle,
          onPressed: () {
            if (this.widget.isMultiSelected == false) {
            } else {
              setState(() {
                model.isCheck = !(model.isCheck ?? false);
                this.widget.onTapListener({"data": getCheckModelList()});
              });
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff7171ed),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Wrap(
                children: [
                  new Text(
                    model.title ?? '',
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  model.title != getI18NKey().no_time_limit
                      ? SizedBox(
                          width: 2,
                        )
                      : SizedBox.shrink(),
                  model.title != getI18NKey().no_time_limit
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            this.widget.unit,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                      : SizedBox.shrink()
                ],
              )));
    } else {
      return TextButton(
          style: StylesConfig.transparentTextButtonStyle,
          onPressed: () {
            if (this.widget.isMultiSelected == false) {
              this.initModelListState();
              setState(() {
                model.isCheck = true;
                this.widget.onTapListener({"data": model, "index": index});
              });
            } else {
              setState(() {
                model.isCheck = !(model.isCheck ?? false);

                this.widget.onTapListener({"data": getCheckModelList()});
              });
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  color: ThemeManager.getInstance()
                      .getBackgroundColor(defaultColor: Colors.white),
                  border: Border.all(color: Color(0xff7171ed), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Wrap(
                children: [
                  new Text(
                    model.title ?? '',
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultColor: Color(0xff404040)),
                        fontSize: 15),
                  ),
                  model.title != getI18NKey().no_time_limit
                      ? SizedBox(
                          width: 2,
                        )
                      : SizedBox.shrink(),
                  model.title != getI18NKey().no_time_limit
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            this.widget.unit,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 14,
                                color: ThemeManager.getInstance().getTextColor(
                                    defaultColor: Color(0xff404040)),
                                fontWeight: FontWeight.bold),
                          ))
                      : SizedBox.shrink()
                ],
              )));

      // return TextButton(
      //     style: StylesConfig.transparentTextButtonStyle,
      //     onPressed: () {
      //       this.initModelListState();
      //       setState(() {
      //         model.isCheck = true;
      //         this.widget.onTapListener({"data": model, "index": index});
      //       });
      //     },
      //     child: Container(
      //         decoration: BoxDecoration(
      //             color: Color(0xfff5f4f9),
      //             borderRadius: BorderRadius.all(Radius.circular(20))),
      //         padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      //         child:
      //             Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: [
      //           new Text(
      //             model.title ?? '',
      //             maxLines: 1,
      //             softWrap: false,
      //             style: TextStyle(color: Color(0xff404040), fontSize: 15),
      //           ),
      //           model.title != getI18NKey().no_time_limit ? SizedBox(
      //             width: 2,
      //           ) : SizedBox.shrink(),
      //               model.title != getI18NKey().no_time_limit ?Padding(
      //               padding: EdgeInsets.only(bottom: 2),
      //               child: Text(
      //                 this.widget.unit,
      //                 textAlign: TextAlign.end,
      //                 style: TextStyle(
      //                     color: Color(0xff404040),
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.bold),
      //               )) : SizedBox.shrink(),
      //           // SizedBox(
      //           //   width: 5,
      //           // )
      //         ])));
    }

    // return CheckContainer(
    //     uncheckWidget:
    //          Container(
    //           color:Colors.red,
    //       padding: EdgeInsets.only(top: 5, bottom:5, left: 10, right: 10),
    //       child: new Text(model.title ?? '', maxLines: 1, softWrap: false)),
    //     checkWidget:  Container(
    //           color:Colors.red,
    //           padding: EdgeInsets.only(top: 5, bottom:5, left: 10, right: 10),
    //           child: new Text(model.title ?? '', maxLines: 1, softWrap: false),
    //         ));
  }

  List<CheckButtonStateModel> getCheckModelList() {
    List<CheckButtonStateModel> list = [];
    this.list.forEach((element) {
      if (element.isCheck == true) {
        list.add(element);
      }
    });
    return list;
  }

  void initModelListState() {
    this.widget.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
