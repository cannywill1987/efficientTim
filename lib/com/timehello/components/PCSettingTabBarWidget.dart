import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/Params.dart';
import '../models/EventFn.dart';

class PCSettingTabBarWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener? onTapListener;

  PCSettingTabBarWidget({required this.list, this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCSettingTabBarWidgetState(list: this.list);
  }
}

class PCSettingTabBarWidgetState extends State<PCSettingTabBarWidget> {
  List<CheckButtonStateModel>? list;

  PCSettingTabBarWidgetState({this.list});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_GLOBAL_THEME) {
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(alignment: Alignment.center,height: 120, decoration: BoxDecoration(color: ThemeManager.getInstance().getNavigationBarColor(defaultColor: Colors.white)), child:ListView(scrollDirection: Axis.horizontal,children:getList(this.list ?? [])));
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(SizedBox(
        width: 40,
        height: 120,
      ));
      listTmp.add(getCheckButton(element, list.indexOf(element)));
      listTmp.add(SizedBox(
        width: 40,
        height: 120,
      ));
      listTmp.add(Container(
        height: 80,
        width: 1,
        color: ThemeManager.getInstance().getLineColor(defaultColor: ColorsConfig.dividerLine),
      ));
    });
    return listTmp;
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    return TextButton(
      style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          this.initModelListState();
          setState(() {
            model.isCheck = true;
            if(this.widget.onTapListener != null) {
              this.widget.onTapListener!({"data": model, "index": index});
            }
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment:  Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0,
                          color: (model?.isCheck ?? true)
                              ? ThemeManager.getInstance().getDefautThemeColor()
                              : Color(0xffa0a0a0)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Align(
                    child: (model?.isCheck ?? true) ? model.checkIcon : model.uncheckIcon,)
              ],
            ),
            SizedBox(height: 5,),
            new Text(
              model.title ?? '',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                  color: (model?.isCheck ?? true)
                      ? Color(
                      ThemeManager.getInstance().getDefautThemeColorInt())
                      : Color(0xffa0a0a0),
                  fontSize: 15),
            )
          ],
        ));

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

  void initModelListState() {
    this.list?.forEach((element) {
      element.isCheck = false;
    });
  }
}
