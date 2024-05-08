import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../CreditCardManagementPage/components/TitleAndSubtitleWidget.dart';

class Guide4Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: 500,
      height: 500,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: TitleAndSubtitleWidget(
              title: getI18NKey().habit_clockin,
              subtitle: getI18NKey().todo_list_desc,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 300,
              height: 300,
              child:DeviceInfoManagement.isWEB() ? null :  Lottie.asset(
                R.assetsImgIcGuideLottie1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
