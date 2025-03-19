import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../config/CONSTANTS.dart';

/**
 * 自定义头部GridView
 */
class CustomHeaderGridView extends StatelessWidget {
  List<ResourceDeliveryInfoBean>? list;
  Function onTap;
  CustomHeaderGridView({Key? key, required this.onTap}) {
    list = CONSTANTS.getFolderModelHeaderGridViewList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
        childAspectRatio: Utility.isHandsetBySize() ? 8 / 2: 6 / 2,
        crossAxisCount: 3,
        // 设置每行显示的数量
        shrinkWrap: true,
        // 设置为true，使GridView的高度自适应子项的高度
        physics: NeverScrollableScrollPhysics(),
        // 设置为NeverScrollableScrollPhysics，禁用GridView的滚动
        children: getList());
  }

  List<Widget> getList() {
    List<Widget> list = [];
    this.list?.forEach((element) {
      list.add(getItem(element));
    });
    return list;
  }

  Widget getItem(ResourceDeliveryInfoBean bean) {
    return InkWell(onTap: () {
      if(this.onTap != null) {
        this.onTap(bean);
      }
    },child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 8),
      // decoration: BoxDecoration(),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: bean.deliveryName == 'CountDownListViewPage' ? 8: 0.0),
            child: Utility.getSVGPicture(bean.resourceIconUrl ?? "", size:  20),
          ),
          SizedBox(width: 5,),
          Text(
            bean.resourceTitle ?? "",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: ThemeManager.getInstance().getTextColor(defaultColor: Color(bean.extendParamsMap!['color'] ?? 0xffff8800)),
                fontWeight: FontWeight.w500,
                fontSize: 14),
          )
        ],
      ),
    ),);
  }
}
