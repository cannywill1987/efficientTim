import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/ResourceDeliveryInfoBean.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

import '../../../config/CONSTANTS.dart';
import '../../../util/Utility.dart';


class ButtonListWidget extends StatefulWidget {
  List<ResourceDeliveryInfoBean> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex;
  bool shouldShowPopupWhenPC = false;

  ButtonListWidget(
      {this.initIndex: 0,
        this.shouldShowPopupWhenPC: false,
      required this.list,
      required this.onTapListener,
      this.width: 80}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ButtonListWidgetState();
  }
}

class ButtonListWidgetState extends State<ButtonListWidget> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (Utility.isHandsetBySize() == false) {
      if (this.widget.shouldShowPopupWhenPC == true) {
        return getPopupMenu();
      } else {
      return Row(children: getList(this.widget.list));
      }
    } else {
      return getPopupMenu();
    }
  }

  Container getPopupMenu() {
    return Container(
        margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
        child: PopupMenuButton<String>(
          position: PopupMenuPosition.over,
          tooltip: '',
          padding: EdgeInsets.all(0.0),
          child: Container(
            height: Utility.isHandsetBySize()? 28 : 35,
            padding: EdgeInsets.symmetric(horizontal: Utility.isHandsetBySize()? 5 : 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 1,
                ),
                Text(this.getCurModel()?.resourceTitle ?? '', style: TextStyle(fontSize: Utility.isHandsetBySize()? 12: 16, color: Colors.red),)
              ],
            ),
          ),
          onSelected: (String val) {},
          itemBuilder: (context) {
            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
            return getPopupMenuList();
          },
        ));
  }

  List<PopupMenuEntry<String>> getPopupMenuList() {
    List<PopupMenuEntry<String>> list = [];

    for (int i = 0; i < this.widget.list.length; i++) {
      ResourceDeliveryInfoBean model = this.widget.list[i];
      list.add(
        PopupMenuItem<String>(
          value: model.deliveryName,
          child: Text(model.resourceTitle ?? "", style: TextStyle(fontSize: 13)),
          onTap: (){
            this.initModelListState();
              model.isChecked = true;
            this.widget.onTapListener({"data": model, "index": i});
            setState((){});
          },
        ),
      );
    }
    return list;
  }

  @override
  void initState() {
    if (this.widget.initIndex != null) {
      for (int i = 0; i < this.widget.list.length; i++) {
        ResourceDeliveryInfoBean model = this.widget.list[i];
        if (this.widget.initIndex == i) {
          model.isChecked = true;
        } else {
          model.isChecked = false;
        }
      }
    }
  }

  ResourceDeliveryInfoBean? getCurModel() {
    for (int i = 0; i < this.widget.list.length; i++) {
      ResourceDeliveryInfoBean model = this.widget.list[i];
      if (model?.isChecked == true) {
        return model;
      }
    }
    return null;
  }

  List<Widget> getList(List<ResourceDeliveryInfoBean> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(SizedBox(width: 10));
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  Widget getCheckButton(ResourceDeliveryInfoBean model, int index) {
    if (model.isChecked == true) {
      return Container(
          width: this.widget.width,
          height: 40,
          decoration: BoxDecoration(
              color: Color(0xff7171ed),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              new Text(
                model.resourceTitle ?? '',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ));
    } else {
      return Container(
          width: this.widget.width,
          height: 40,
          decoration: BoxDecoration(
              color: Color(0xfff5f4f9),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: TextButton(
              style: StylesConfig.transparentTextButtonStyle,
              onPressed: () {
                this.initModelListState();
                setState(() {
                  model.isChecked = true;
                  this.widget.onTapListener({"data": model, "index": index});
                });
              },
              child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    new Text(
                      model.resourceTitle ?? '',
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(color: Color(0xff404040), fontSize: 15),
                    )
                  ])));
    }
  }

  void initModelListState() {
    this.widget.list.forEach((element) {
      element.isChecked = false;
    });
  }
}
