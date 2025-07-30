import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';

import '../../../r.dart';
import '../config/Params.dart';
import '../util/DeviceInfoManagement.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';
import 'NewVerstionWidget.dart';

class DownloadListwidget extends StatelessWidget {
  double space = 10;

  bool shouldShowWinAndAndroid;

  DownloadListwidget({required this.shouldShowWinAndAndroid});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if (DeviceInfoManagement.getLanguage() == "zh") {
                    DialogManagement.getInstance().showCopyTextDialog(context,
                        title: "Mac",
                        okCallBack: (text) {
                          Utility.popNavigator(context);
                          Utility.showToastMsg(msg: getI18NKey().copy_success);
                          Utility.copyToClipboard(getI18NKey().tomatoClock);
                        },
                        cancelCallBack: () {
                          Utility.popNavigator(context);
                        },
                        content: getI18NKey()
                            .please_seaarch_on_app_store(getI18NKey().tomatoClock));
                  } else {
                    DialogManagement.getInstance().showCopyTextDialog(context,
                        title: "Mac",
                        okCallBack: (text) {
                          Utility.popNavigator(context);
                          Utility.showToastMsg(msg: getI18NKey().copy_success);
                          Utility.copyToClipboard(getI18NKey().app_name);
                        },
                        cancelCallBack: () {
                          Utility.popNavigator(context);
                        },
                        content: getI18NKey()
                            .please_seaarch_on_app_store(getI18NKey().app_name));
                  }
                },
                child:
                NewVerstionWidget(
                    currentVersion: Params.curVersion,
                newVersion: Params.curLatestVersionMAC,
                shouldShowRedDotParam: DeviceInfoManagement.isMacOs(),
                child: Utility.getSVGPicture(R.assetsImgIcMac, size: 28, color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff404040), defaultDarkColor: Colors.white))),
              ),
              SizedBox(
                width: space,
              ),
              InkWell(
                onTap: () {
                  DialogManagement.getInstance().showCopyTextDialog(context,
                      title: "Iphone",
                      okCallBack: (text) {
                        Utility.popNavigator(context);
                        Utility.showToastMsg(msg: getI18NKey().copy_success);
                        Utility.copyToClipboard(getI18NKey().app_name);
                      },
                      cancelCallBack: () {
                        Utility.popNavigator(context);
                      },
                      content: getI18NKey()
                          .please_seaarch_on_app_store(getI18NKey().app_name));
                },
                child: NewVerstionWidget(currentVersion: Params.curVersion,
                    newVersion: Params.curLatestVersionIOS,shouldShowRedDotParam: DeviceInfoManagement.isIOS(),
                    child: Utility.getSVGPicture(R.assetsImgIOS, size: 20, color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff404040), defaultDarkColor: Colors.white))),
              ),
              if(shouldShowWinAndAndroid)
              SizedBox(
                width: space,
              ),
              if(shouldShowWinAndAndroid)
              InkWell(
                onTap: () {
                  DialogManagement.getInstance().showCopyTextDialog(context,
                      title: "Windows",
                      okCallBack: (text) {
                        Utility.popNavigator(context);
                        Utility.showToastMsg(msg: getI18NKey().copy_success);

                        Utility.copyToClipboard("https://oss.timerbell.com/app/timerbell.exe");
                        // Utility.copyToClipboard("https://timehello.oss-cn-hongkong.aliyuncs.com/app/%E6%97%B6%E9%97%B4%E7%AE%A1%E7%90%86%E5%B1%80ToDo.exe");
                      },
                      cancelCallBack: () {
                        Utility.popNavigator(context);
                      },
                      content:
                          "https://oss.timerbell.com/app/timerbell.exe");
                },
                child: NewVerstionWidget(currentVersion: Params.curVersion,
                    newVersion: Params.curLatestVersionWin,shouldShowRedDotParam: DeviceInfoManagement.isWindows(),
                    child: Utility.getSVGPicture(R.assetsImgIcWindow, size: 20)),
              ),
              if(shouldShowWinAndAndroid)
              SizedBox(
                width: space,
              ),
              if(shouldShowWinAndAndroid)
              InkWell(
                onTap: () {
                  DialogManagement.getInstance().showCopyTextDialog(context,
                      title: "Android",
                      okCallBack: (text) {
                        Utility.popNavigator(context);
                        Utility.showToastMsg(msg: getI18NKey().copy_success);
                        Utility.copyToClipboard(getI18NKey().app_name);
                      },
                      cancelCallBack: () {
                        Utility.popNavigator(context);
                      },
                      content: getI18NKey()
                          .please_seaarch_on_app_store(getI18NKey().app_name));
                },
                child: NewVerstionWidget(currentVersion: Params.curVersion,
                    newVersion: Params.curLatestVersionAndroid,shouldShowRedDotParam: DeviceInfoManagement.isAndroid(),
                    child: Utility.getSVGPicture(R.assetsImgIcAndroid, size: 30)),
              ),
              SizedBox(
                width: space,
              ),
              InkWell(
                onTap: () {
                  DialogManagement.getInstance().showCopyTextDialog(context,
                      title: "web",
                      okCallBack: (text) {
                        Utility.popNavigator(context);
                        Utility.showToastMsg(msg: getI18NKey().copy_success);
                        Utility.copyToClipboard("https://www.timerbell.com");
                      },
                      cancelCallBack: () {
                        Utility.popNavigator(context);
                      },
                      content: getI18NKey().web_desc);
                },
                child: DeviceInfoManagement.isMacOs() ? Utility.getSVGPicture(R.assetsImgIcSafari, size: 20) : Utility.getSVGPicture(R.assetsImgIcChrome, size: 20
              )
              ),
              if(Utility.isChina())
              SizedBox(
                width: space,
              ),
              if(Utility.isChina())
              InkWell(
                  onTap: () async {
                    // showCupertinoDialog(context: context, builder: builder)
                    // showTextAnswerDialog(context: context, keyword: keyword)
                    DialogManagement.getInstance().showCustomIconTitleAndDescDialog(
                        Utility.getGlobalContext(),
                        btnConfirm: getI18NKey().copy,
                        title: getI18NKey()
                            .join_us,
                        desc:  getI18NKey().copy_qq,

                        iconWidget: Utility.getSVGPicture(R.assetsImgIcQq, size: 40),

                        okCallback: (bool isCheck) async {
                          if (Localizations.localeOf(Utility.getGlobalContext()).languageCode !=
                              "zh") {
                            Utility.openExternalWebView(url: Urls.facebook);
                          } else {
                            Utility.copyToClipboard("563144208", shouldShowToast: false);
                            Utility.showToastMsg(
                                context: context, msg: getI18NKey().copy_qq_success);
                          }
                        });

                  },
                  child:Utility.getSVGPicture(R.assetsImgIcQq, size: 20)
              )
            ],
          ),
        ),
        Positioned(bottom: 0, right: 0, child: Text(getI18NKey().version_num(Params.curVersion), style: TextStyle(fontSize: 8, color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.grey),)))
      ],
    );
  }
}
