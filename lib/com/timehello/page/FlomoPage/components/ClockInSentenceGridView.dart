import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../components/IconWidget.dart';
import '../../../config/ColorsConfig.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/Utility.dart';

class ClockInSentenceGridView extends StatefulWidget {
  List<ResourceDeliveryInfoBean> list;
  Function onSubmit;
  ClockInSentenceGridView({required this.list,required this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClockInSentenceGridViewState();
  }
}

class ClockInSentenceGridViewState extends State<ClockInSentenceGridView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(
      // physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //设置横向间距
        crossAxisSpacing: 10,
        //设置主轴间距
        mainAxisSpacing: 10, childAspectRatio: 3, maxCrossAxisExtent: 250,
      ),
      scrollDirection: Axis.vertical,
      itemCount: this.widget.list.length,
      itemBuilder: (context, index) {
        return getItem(this.widget.list[index]);
      },
    );
  }

  Widget getItem(ResourceDeliveryInfoBean bean) {
    return InkWell(
      onTap: () {
        this.widget.onSubmit.call(bean);
      },
      child: Container(
        decoration: BoxDecoration(
            color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Color(0xfff9f9f9)), borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                  color: ThemeManager.getInstance().getCardBackgroundColor(), borderRadius: BorderRadius.circular(40)),
              child: IconWidget(
                icon: bean.extendParamsMap?['codePoint'] ??Icons.sports_martial_arts.codePoint,
                iconSize: 28,
                color: ThemeManager.getInstance().getDefautThemeColor().value,
              )
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(bean.deliveryName ?? "",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                  decorationStyle: TextDecorationStyle.solid,
                                  // decorationColor: Utility.getTextColorByPriority(this.widget.priorityEnum),
                                  decorationThickness: 3,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                  )),
                          SizedBox(
                            width: Utility.isHandsetBySize() ? 1 : 3,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.watch,
                          //   color: ColorsConfig.darkRed,
                          //   size: Utility.isHandsetBySize() ? 10 : 12,
                          // ),
                          // SizedBox(width: 2),
                          Text(
                            bean.extendParamsMap?['time'] ?? "",
                            style: TextStyle(
                                fontSize: Utility.isHandsetBySize() ? 10 : 12,
                                color: Color(0xff999999)),
                          )
                        ],
                      )
                    ]),
                flex: 3),
            DeviceInfoManagement.isMoible() == false
                ? SizedBox(
                    width: 15,
                  )
                : SizedBox(
                    width: 0,
                  )
          ],
        ),
      ),
    );
  }
}
