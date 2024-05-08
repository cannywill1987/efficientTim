import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';
import '../util/LoginManager.dart';
import '../util/Utility.dart';
import 'ConsumeMoneyButtonWidget.dart';
import 'DownloadListwidget.dart';
import 'MoneyHandlerWidget.dart';

class PCTopMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCTopWidgetState();
  }
}

class PCTopWidgetState extends State<PCTopMenuWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Utility.popupDesktopRightNavigator(context);
      },
      child: Container(
        height: 50,
        color: ThemeManager.getInstance()
            .getNavigationBarColor(defaultColor: Colors.white),
        padding: EdgeInsets.only(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            LoginManager.getInstance().getUserBean().totalFocusTimeRanking !=
                        null &&
                    LoginManager.getInstance()
                            .getUserBean()
                            .totalFocusTimeRanking! >=
                        0
                ? Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(
                        getI18NKey().my_ranking(LoginManager.getInstance()
                            .getUserBean()
                            .totalFocusTimeRanking
                            .toString()),
                        style: TextStyle(
                            color: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Color(0xffa0a0a0)),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        getI18NKey().total_focus_time +
                            Utility.formatHourAndMin(LoginManager.getInstance()
                                    ?.getUserBean()
                                    ?.totalFocusTime ??
                                0),
                        style: TextStyle(
                            color: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Color(0xffa0a0a0)),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : SizedBox.shrink(),
            Expanded(
              child: Container(),
            ),
            DownloadListwidget(
              shouldShowWinAndAndroid: !(Utility.isIOS() || Utility.isMacOS()),
            ),
            SizedBox(
              width: 10,
            ),
            MoneyHandlerWidget(
              pageFrom: PageFromEnum.MinePage,
            ),
            SizedBox(
              width: 5,
            ),
            ConsumeMoneyButtonWidget(
              onTapListener: (obj) {},
            ),
            if(ABTestSetting.isOpenAiOn == true)
            InkWell(
              onTap: () {
                if(ABTestSetting.isOpenAiOn == true)
                Utility.openRightSideDesktopNavigator(
                    context, 'ChatGptPage', {});
              },
              child: Utility.getSVGPicture(R.assetsImgIcRightPanel,
                  size: 20, color: ThemeManager.getInstance().getDefautThemeColor()),
            ),
          ],
        ),
      ),
    );
  }
}
