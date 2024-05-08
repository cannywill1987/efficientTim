import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../beans/ResourceDeliveryInfoBean.dart';

class CustomMarquee extends StatefulWidget {
  double height;
  double paddingHor = 10;
  double paddingTop = 10;
  // String text;
  ResourceDeliveryInfoBean? bean;

  CustomMarquee({Key? key, this.bean, this.height: 20, this.paddingHor: 10, this.paddingTop: 10}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomMarqueeState();
  }
}

class CustomMarqueeState extends State<CustomMarquee> {
  bool hasExecuted = false;
  bool shouldShowMarquee = true;
  GlobalKey MarqueeeKey = GlobalKey();
  TextStyle style = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff8c6b1d));
  bool useMarquee = false;
  Widget? myWidget;
  int version = 1;
  @override
  void initState() {
    style = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff8c6b1d));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      double? width = MarqueeeKey.currentContext?.size?.width ?? 0;
      String text = this.widget.bean?.resourceContent ?? '';
      Size textSize = Utility.getTextSize(text, style);
      try {
        if (textSize.width > width) {
          useMarquee = true;
        }
      } catch(e) {
        useMarquee = true;
      }

      bool shouldOnlyShowFirstTime =
          this.widget.bean?.extendParamsMap?['shouldOnlyShowFirstTime'] ?? false;

      version = this.widget.bean?.extendParamsMap?['version'] ?? 1;
      String key = "shouldOnlyShowFirstTime" +
          (this.widget.bean?.deliveryName?.toString() ?? "") +
          version.toString();
      shouldShowMarquee = SharePreferenceUtil.getSyncInstance().getBool(
          key: key,
          defaultVal: true);
      if (hasExecuted == false && shouldOnlyShowFirstTime == true) {
        SharePreferenceUtil.getSyncInstance().setBool(
            key: "shouldOnlyShowFirstTime" +
                (this.widget.bean?.deliveryName?.toString() ?? "") +
                version.toString(),
            val: false);
      }
      if (shouldShowMarquee == true) {
        myWidget = null;
      }

      hasExecuted = true;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(myWidget == null) {
      version = this.widget.bean?.extendParamsMap?['version'] ?? 1;
      String key = "shouldOnlyShowFirstTime" +
          (this.widget.bean?.deliveryName?.toString() ?? "") +
          version.toString();
      shouldShowMarquee = SharePreferenceUtil.getSyncInstance().getBool(
          key: key,
          defaultVal: true);
      if (TextUtil.isEmpty(this.widget.bean?.resourceContent) == false &&
          shouldShowMarquee == true) {
        return myWidget = Container(
            key: MarqueeeKey,
            margin: EdgeInsets.only(left: this.widget.paddingHor, right: this.widget.paddingHor, top: this.widget.paddingTop),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xffffb400),),
            width: double.infinity,
            padding: EdgeInsets.only(left: useMarquee == false ? 10 : 0),
            height: 30,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                child: useMarquee == false
                    ? Text(
                  this.widget.bean?.resourceContent ?? '',
                  maxLines:1,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )
                    : Marquee(
                  text: this.widget.bean?.resourceContent ?? '',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 30,
                  // numberOfRounds: 1,
                  velocity: 20.0,
                ),
              ),
              IconButton(
                  onPressed: () {
                    myWidget = null;
                    String key = "shouldOnlyShowFirstTime" +
                        (this.widget.bean?.deliveryName?.toString() ?? "") +
                        version.toString();
                    SharePreferenceUtil.getSyncInstance().setBool(
                        key: key,
                        val: false);
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15,
                  ))
            ]));
      } else {
        return myWidget = SizedBox.shrink();
      }
    } else {
      return myWidget!;
    }
  }
}
