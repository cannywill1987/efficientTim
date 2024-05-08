import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/beans/ResourceDeliveryInfoBean.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/r.dart';

import 'CheckContainer.dart';

/**
 * PC端右上角的gridview卡片容器
 */
class PCStatisticRightTopContainer extends StatefulWidget {
  List<ResourceDeliveryInfoBean> list;
  OnTapListener? onTapListener;

  PCStatisticRightTopContainer({required this.list, this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCStatisticRightTopContainerState();
  }
}

class PCStatisticRightTopContainerState
    extends State<PCStatisticRightTopContainer> {
  int currentSelected = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getPCRightTopContainer();
  }

  /**
   * PC端右上角容器
   */
  Widget getPCRightTopContainer() {
    return Card(
      elevation: 0,
      child: Container(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: getPCRightTopItem(0, model: this.widget.list[0]),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: getPCRightTopItem(1, model: this.widget.list[1]),
              ),
            ],
          )),
          SizedBox(height: 5),
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: getPCRightTopItem(2, model: this.widget.list[2]),
              ),
              SizedBox(
                width: 5,
              ),
              // Expanded(
              // child: getPCRightTopItem(3, model: this.widget.list[3]),
              // ),
            ],
          )),
        ],
      )),
    );
  }

  void initModelListState() {
    this.widget.list.forEach((element) {
      element.isChecked = false;
    });
  }

  /**
   * 右上角容器的每个item
   */
  Widget getPCRightTopItem(int index, {ResourceDeliveryInfoBean? model}) {
    bool isSelected = model?.isChecked ?? false;
    bool isArrowUp = model?.extendParamsMap?['isArrowUp'] ?? false;
    String content = model?.resourceContent ?? "";
    String value = model?.extendParamsMap?['value'].toString() ?? "";
    String unit = model?.extendParamsMap?['unit'].toString() ?? "";
    String percentGrowth = model?.extendParamsMap?['percentGrowth'] ?? '';
    String resourceTitle = model?.resourceTitle ?? "";
    Widget iconSelected = model?.extendParamsMap?["resourceIconWidgetChecked"] ?? "";
    Widget iconUnselected = model?.extendParamsMap?["resourceIconWidgetUnChecked"] ?? "";

    return TextButton(
        style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          initModelListState();
          this.currentSelected = index;
          setState(() {
            this.widget.list[this.currentSelected].isChecked = true;
            if(this.widget.onTapListener != null) {
              this.widget.onTapListener!({
                "index": index,
                "data": this.widget.list[this.currentSelected]
              });
            }
          });
        },
        child: Card(
            elevation: isSelected == true ? 5 : 2,
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xfff5f4f9)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    image: isSelected == true
                        ? new DecorationImage(
                            image: AssetImage(R.assetsImgBgPicItem),
                            fit: BoxFit.cover,
                          )
                        : null,
                    // new DecorationImage(image: Image.asset(R.assetsImgBgPicItem),),
                    color: isSelected ? Color(0x00f5f4f9) : Color(0x08e085f7),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected == true
                              ? Color(0x22000000)
                              : Color(0x02000000),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: CheckContainer(
                              width: 15,
                              height: 15,
                              checkWidget: iconSelected,
                              uncheckWidget: iconUnselected,
                              checked: isSelected,
                            )),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        left: 60,
                        child: Text(
                          resourceTitle,
                          style: TextStyle(
                              fontSize: 14,
                              color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                              fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        right: 20,
                        top: 20,
                        child: Wrap(alignment: WrapAlignment.end, children: [
                          isArrowUp
                              ? Icon(Icons.arrow_drop_up,
                                  color: Colors.red, size: 20)
                              : Icon(Icons.arrow_drop_down,
                                  color: Colors.green, size: 20),
                          Text(
                            percentGrowth ?? '',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ])),
                    Positioned(
                        bottom: 20,
                        left: 20,
                        child: Wrap(
                          direction: Axis.vertical,
                          children: [
                            Wrap(
                              verticalDirection: VerticalDirection.down,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              alignment: WrapAlignment.end,
                              children: [
                                Text(
                                  value ?? '',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(width: 5,),
                                Text(unit ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            Text(
                              content ?? '',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected == true ? Color(0xff808080): Color(0xffa0a0a0),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ))
                  ],
                ))));
  }
}
