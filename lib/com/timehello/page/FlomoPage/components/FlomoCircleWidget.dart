import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/FlomoCreatePage.dart';

import '../../../util/DialogManagement.dart';
import '../../../util/LoginManager.dart';
import '../../../util/Utility.dart';
import 'ClockInSentenceDialog.dart';


class FlomoCircleWidget extends StatelessWidget {
  OnTapListener? onTapListener;
  Color color;

  FlomoCircleWidget({this.onTapListener, this.color = Colors.purple});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (this.onTapListener != null) {
    //   return GestureDetector(
    //     onTap: () {
    //       if (this.onTapListener != null) {
    //         this.onTapListener!(null);
    //       }
    //     },
    //     child: getWidget(),
    //   );
    // } else {
    return getWidget(context);
    // }
  }

  Widget getWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        if (LoginManager.isLogin() == false) {
          Utility.showToast(msg: getI18NKey().loginFirst);
          LoginManager.getInstance()
              .doAliSdkSecVerifyLogin(Utility.getGlobalContext());
          return null;
        }
        DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(context,
            child: ClockInSentenceDialog(onSubmitted: () {}));
        // Utility.pushNavigator(context, FlomoCreatePage());
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(30)),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
    );
  }
}
