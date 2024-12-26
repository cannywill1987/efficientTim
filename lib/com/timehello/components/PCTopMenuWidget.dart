import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/EVENTNAME.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';
import '../page/TestPage/Test9Page.dart';
import '../util/FirebaseStoreManager.dart';
import '../util/LocaleProvider.dart';
import '../util/LoginManager.dart';
import '../util/Utility.dart';
import 'ConsumeMoneyButtonWidget.dart';
import 'CustomIconButton.dart';
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
            SizedBox(width: 10,),
            CustomIconButton(
              onPressed: () {
                DialogManagement.getInstance()?.showAISearchBarMenuWithoutText(context: context, );
              },
              icon: Utility.getSVGPicture(R.assetsImgIcEfficiency, size: 13),
              title: getI18NKey().super_tool,
            ),
            Spacer(),
            if (!Utility.isProductEnv())
              InkWell(
                onTap: () async {
                  CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                },
                child: Text("支付测试"),
              ),
            if (!Utility.isProductEnv())
            SizedBox(width: 10,),
            if (!Utility.isProductEnv())
              InkWell(
                onTap: () async {
                  CounterMethodChannelManager.getInstance().requestEventReminderAccess();
                  // CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                },
                child: Text("获取权限"),
              ),
            if (!Utility.isProductEnv())
              SizedBox(width: 10,),
            if (!Utility.isProductEnv())
              InkWell(
                onTap: () async {
                  CounterMethodChannelManager.getInstance().fetchCalendarEvents(startDate: 1701940406000, endDate: 1765098806000);
                  // CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                },
                child: Text("获取事件"),
              ),
            if (!Utility.isProductEnv())
              SizedBox(width: 10,),
            if (!Utility.isProductEnv())
              InkWell(
                onTap: () async {
                  CounterMethodChannelManager.getInstance().fetchReminderReminders(startDate: 1701940406000, endDate: 1765098806000);
                  // CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                },
                child: Text("获取提醒"),
              ),
            if (!Utility.isProductEnv())
              SizedBox(width: 10,),
            if (!Utility.isProductEnv())
              SizedBox(
                width: 30,
              ),
            if (!Utility.isProductEnv())
              SizedBox(width: 10,),
            if (!Utility.isProductEnv())
              InkWell(
                onTap: () {
                  DialogManagement.getInstance().showPCCustomDialog(
                      context: context,
                      widget: PremiumUpgradePage());
                  // FirebaseStoreManager.getInstance().getString();
                  // DialogManagement.showRatingDialog(context, scene: EVENTNAME.MainContainerWidget);

                  // CounterMethodChannelManager.getInstance().scheduleShutdown(delaySeconds: 1000);
                  // DialogManagement.getInstance().showSearchFriendGroupWidget();
                },
                child: Text("测试2"),
              ),
            // Expanded(
            //   child: Container(),
            // ),
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
            InkWell(
              onTap: () {
                ScreenLockManager.getInstance().showPasword();
                // if(ABTestSetting.isOpenAiOn == true)
                //   Utility.openRightSideDesktopNavigator(
                //       context, 'ChatGptPage', {});
              },
              child: Utility.getSVGPicture(R.assetsImgIcUnlockscreen, size: 18
                  // , color: ThemeManager.getInstance().getDefautThemeColor()
                  ),
            ),
            SizedBox(
              width: 10,
            ),
            if (ABTestSetting.isOpenAiOn == true)
              InkWell(
                onTap: () {
                  if (ABTestSetting.isOpenAiOn == true)
                    Utility.openRightSideDesktopNavigator(
                        context, 'ChatGptPage', {});
                },
                child: Utility.getSVGPicture(R.assetsImgIcRightPanel,
                    size: 26,
                    color: ThemeManager.getInstance().getDefautThemeColor()),
              ),
          ],
        ),
      ),
    );
  }
}
