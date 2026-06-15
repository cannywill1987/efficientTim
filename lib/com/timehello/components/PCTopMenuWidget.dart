/// 文件类型：桌面端顶部工具栏组件。
/// 文件作用：渲染桌面顶部统计、订阅、邀请好友和 AI Helper 等快捷入口。
/// 主要职责：聚合登录、会员、主题与导航状态，并统一处理顶部栏入口点击行为。
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/components/unified/UnifiedDesktopShell.dart';

import '../../../r.dart';
import '../beans/BaseBean.dart';
import '../beans/PriceProductModel.dart';
import '../util/LoginManager.dart';
import '../util/SubscriptionAndPriceManager.dart';
import '../util/Utility.dart';
import 'ConsumeMoneyButtonWidget.dart';
import 'CustomIconButton.dart';
import 'DownloadListwidget.dart';
import 'MembershipBanner.dart';
import 'MoneyHandlerWidget.dart';
import 'PremiumUpgradeWidget.dart';

class PCTopMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCTopWidgetState();
  }
}

class PCTopWidgetState extends State<PCTopMenuWidget> {
  /// 邀请好友 H5 只支持固定的语言枚举，这里把 Flutter Locale 映射成 Web 端识别的 `lang`。
  /// 中文需要区分简体，其他语种直接按语言码透传；未命中时回退英文，避免入口漏参。
  String _getInviteWebLang(BuildContext context) {
    final Locale locale = Params.local ?? Localizations.localeOf(context);
    final String languageCode = locale.languageCode.toLowerCase();
    final String countryCode = (locale.countryCode ?? '').toUpperCase();

    if (languageCode == 'zh') {
      return countryCode == 'CN' ? 'zh-CN' : 'en';
    }
    if (languageCode == 'ja') {
      return 'ja';
    }
    if (languageCode == 'de') {
      return 'de';
    }
    if (languageCode == 'en') {
      return 'en';
    }
    return 'en';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Selector<Env, bool>(
        selector: (_, env) => env.isVip,
        builder: (_, settingModel, __) {
          return GestureDetector(
            onTap: () {
              Utility.popupDesktopRightNavigator(context);
            },
            child: UnifiedDesktopCard(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),

                    LoginManager.getInstance()
                                    .getUserBean()
                                    .totalFocusTimeRanking !=
                                null &&
                            LoginManager.getInstance()
                                    .getUserBean()
                                    .totalFocusTimeRanking! >=
                                0
                        ? Wrap(
                            direction: Axis.vertical,
                            children: [
                              Text(
                                getI18NKey().my_ranking(
                                    LoginManager.getInstance()
                                        .getUserBean()
                                        .totalFocusTimeRanking
                                        .toString()),
                                style: TextStyle(
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                            defaultColor: Color(0xffa0a0a0)),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getI18NKey().total_focus_time +
                                    Utility.formatHourAndMin(
                                        LoginManager.getInstance()
                                                .getUserBean()
                                                .totalFocusTime ??
                                            0),
                                style: TextStyle(
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                            defaultColor: Color(0xffa0a0a0)),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 10,
                    ),
                    CustomIconButton(
                      onPressed: () {
                        DialogManagement.getInstance()
                            .showAISearchBarMenuWithoutText(
                          context: context,
                        );
                      },
                      icon: Utility.getSVGPicture(R.assetsImgIcEfficiency,
                          size: 13),
                      title: getI18NKey().super_tool,
                    ),
                    Spacer(),
                    if (!Utility.isProductEnv())
                      InkWell(
                        onTap: () async {
                          context.read<Env>().isVip = true;
                          // BaseBean baseBean = await CounterMethodChannelManager.getInstance().getReceipt();
                          // String ticket = baseBean.data["res"];
                          // print("baseBean: $baseBean");
                          // if(ticket == null || ticket.isEmpty) {
                          //   return;
                          // }
                          // HttpManager.getInstance().doPostRequest(Apis.getReceipt, params: {"receiptString": ticket, "isSandbox": true}, context: context, callback: (BaseBean response, String scene, bool isFromCache) {
                          //   print("receipt String response: $response");
                          //   if(response.success == true) {
                          //     Map map = Utility.getLatestExpireDateOfReceipt(
                          //         response.data['latest_receipt_info'], [PriceManager
                          //         .priceMonthly, PriceManager.priceAnnual]);
                          //     String original_transaction_id = map['originalTransactionId'];
                          //     int latestExpireDate = map['latestExpireDate'];
                          //     String productId = map['productId'];
                          //     print("latestExpireDate: $latestExpireDate");
                          //     PriceManager.getInstance().addPurchasedProductToUserModel(
                          //         context: context,
                          //         receipt: ticket,
                          //         identifier: productId,
                          //         list: [],
                          //         expireDateMillis: latestExpireDate,
                          //         orignalTransactionId: original_transaction_id,
                          //         callback: (BaseBean baseBean) {
                          //           print("addPurchasedProductToUserModel: $baseBean");
                          //         });
                          //   }
                          // Utility.getLatestExpireDateOfReceipt(response.data['receipt']['in_app']);
                          // });
                          // CounterMethodChannelManager.getInstance().IAPManagerFetchProducts(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                        },
                        child: Text("支付测试"),
                      ),
                    if (!Utility.isProductEnv())
                      SizedBox(
                        width: 10,
                      ),
                    if (!Utility.isProductEnv())
                      InkWell(
                        onTap: () async {
                          CounterMethodChannelManager.getInstance()
                              .requestEventReminderAccess();
                          // CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                        },
                        child: Text("获取权限"),
                      ),
                    if (!Utility.isProductEnv())
                      SizedBox(
                        width: 10,
                      ),
                    if (!Utility.isProductEnv())
                      InkWell(
                        onTap: () async {
                          CounterMethodChannelManager.getInstance()
                              .fetchCalendarEvents(
                                  startDate: 1701940406000,
                                  endDate: 1765098806000);
                          // CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                        },
                        child: Text("获取事件"),
                      ),
                    if (!Utility.isProductEnv())
                      SizedBox(
                        width: 10,
                      ),
                    if (!Utility.isProductEnv())
                      InkWell(
                        onTap: () async {
                          CounterMethodChannelManager.getInstance()
                              .fetchReminderReminders(
                                  startDate: 1701940406000,
                                  endDate: 1765098806000);
                          // CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: ["com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"]);
                        },
                        child: Text("获取提醒"),
                      ),
                    if (!Utility.isProductEnv())
                      SizedBox(
                        width: 10,
                      ),
                    if (!Utility.isProductEnv())
                      SizedBox(
                        width: 30,
                      ),
                    _buildInviteFriendEntry(context),
                    SizedBox(
                      width: 10,
                    ),
                    if (LoginManager.getInstance().isLogin2() &&
                        LoginManager.getInstance()
                                .isVIP(shouldShowDialog: false) ==
                            false)
                      MembershipBanner(
                        sizeEnum: SizeEnum.small,
                        onTapCallback: () {
                          LoginManager.getInstance()
                              .openSubscriptionDialog(context);
                        },
                      ),
                    if (!Utility.isProductEnv())
                      SizedBox(
                        width: 10,
                      ),
                    if (!Utility.isProductEnv())
                      InkWell(
                        onTap: () {
                          DialogManagement.getInstance().showPCCustomDialog(
                              context: context,
                              widget: PremiumUpgradeWidget(
                                onClickPurchageCallback:
                                    (PriceProductModel model) {
                                  SubscriptionAndPriceManager.getInstance()
                                      .purchase(
                                          identifier: model.identifier,
                                          callback: (BaseBean bean) {
                                            if (bean.code == 0) {
                                              DialogManagement.getInstance()
                                                  .showPCCustomDialog(
                                                      context: context,
                                                      widget: Text("购买成功"));
                                            } else {
                                              DialogManagement.getInstance()
                                                  .showPCCustomDialog(
                                                      context: context,
                                                      widget: Text("购买失败"));
                                            }
                                          });
                                },
                              ));
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
                      shouldShowWinAndAndroid:
                          // Windows 桌面端跟随 macOS 新 UI，顶部栏不再展示旧版 Windows 更新入口。
                          !(Utility.isIOS() ||
                              Utility.isMacOS() ||
                              Utility.isWindows()),
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
                      child: Utility.getSVGPicture(R.assetsImgIcUnlockscreen,
                          size: 18
                          // , color: ThemeManager.getInstance().getDefautThemeColor()
                          ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    _buildAIHelperEntry(context),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// 顶部工具栏 AI Helper 入口：用明确文案替代单独图标，避免用户不知道右上角按钮作用。
  Widget _buildAIHelperEntry(BuildContext context) {
    final Color accentColor = ThemeManager.getInstance().getDefautThemeColor();
    final Color textColor = ThemeManager.getInstance().getTextColor(
      defaultColor: const Color(0xFF5F6F27),
      defaultDarkColor: Colors.white,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Utility.openRightSideDesktopNavigator(context, 'ChatGptPage', {});
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.42),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Utility.getSVGPicture(
              R.assetsImgIcAiHelper,
              size: 15,
              color: accentColor,
            ),
            const SizedBox(width: 5),
            Text(
              getI18NKey().ai_helper,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 顶部工具栏邀请入口：打开右侧 WebView 面板，复用 Web 端邀请好友页面。
  Widget _buildInviteFriendEntry(BuildContext context) {
    final String inviteLang = _getInviteWebLang(context);
    final String inviteUrl = Utility.getTokenUrl(
      url: '${Urls.mgmHomeUrl}?qd=timehello_app&cy=mgm&lang=$inviteLang',
    );
    final Color accentColor = ThemeManager.getInstance().getDefautThemeColor();
    final Color textColor = ThemeManager.getInstance().getTextColor(
      defaultColor: const Color(0xFF7A4A28),
      defaultDarkColor: Colors.white,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Utility.openDesktopWebviewPanel(
          context,
          url: inviteUrl,
          title: getI18NKey().invite_friends,
          width: 438,
        );
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.42),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              size: 15,
              color: accentColor,
            ),
            const SizedBox(width: 5),
            Text(
              getI18NKey().invite_friends,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
