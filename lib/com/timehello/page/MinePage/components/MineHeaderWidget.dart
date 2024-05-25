import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/ChatGptPage.dart';
import 'package:time_hello/com/timehello/page/CoursePage/CoursePage.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../components/CheckContainer.dart';
import '../../../util/LoginManager.dart';

class MineHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max, children: getListItems(context)));
  }

  List<Widget> getListItems(BuildContext context) {
    List<Widget> listVertical = [];
    List<Widget> listHorizontal = [];
    Row? row = null;

    for (int i = 0;
        i < CONSTANTS.getMinePageHeaderRessourceData().length;
        i++) {
      // 创建新的row
      listVertical.add(
        getItem(context, model: CONSTANTS.getMinePageHeaderRessourceData()[i]),
      );
    }
    return listVertical;
  }

  // List<Widget> getListItems(BuildContext context) {
  //   List<Widget> listVertical = [];
  //   List<Widget> listHorizontal = [];
  //   Row? row = null;
  //
  //   for (int i = 0;
  //       i < CONSTANTS.getMinePageHeaderRessourceData().length;
  //       i++) {
  //     if (i % 2 == 1) {
  //       listHorizontal.add(Expanded(
  //         child: getItem(context,
  //             model: CONSTANTS.getMinePageHeaderRessourceData()[i]),
  //       ));
  //       listVertical
  //           .add(Row(mainAxisSize: MainAxisSize.max, children: listHorizontal));
  //     } else if (i % 2 == 0) {
  //       // 创建新的row
  //       listHorizontal.add(Expanded(
  //         child: getItem(context,
  //             model: CONSTANTS.getMinePageHeaderRessourceData()[i]),
  //       ));
  //       if(i == CONSTANTS.getMinePageHeaderRessourceData().length - 1) { //如果是最后一个则需要直接加上去
  //         listVertical
  //             .add(Row(mainAxisSize: MainAxisSize.max, children: listHorizontal));
  //       }
  //     }
  //   }
  //       return listVertical;
  // }

  /**
   * 右上角容器的每个item
   */
  Widget getItem(BuildContext context,
      {required ResourceDeliveryInfoBean model}) {
    return InkWell(
      onTap: () {
        if (model.deliveryName == 'chatGPT') {
          if (LoginManager.isLogin() == false) {
            Utility.showToastMsg(msg: getI18NKey().loginFirst);
            LoginManager.getInstance()
                .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
            return null;
          }
          Utility.pushNavigator(context, ChatGptPage());
        } else if (model.deliveryName == 'training') {
          if (LoginManager.isLogin() == false) {
            Utility.showToastMsg(msg: getI18NKey().loginFirst);
            LoginManager.getInstance()
                .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
            return null;
          }
          Utility.pushNavigator(context, CoursePage());
        }
      },
      child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Color(0xfff5f4f9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Container(
              padding: EdgeInsets.only(left: 10),
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0x08e085f7),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  model.extendParamsMap!['icon'],
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.resourceTitle ?? "",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff404040),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        child: Wrap(
                          children: [
                            Text(
                              model.resourceContent ?? "",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff909090),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }
}
