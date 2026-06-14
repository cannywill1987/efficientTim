import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:time_hello/com/timehello/beans/PriceProductModel.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../config/Params.dart';
import '../util/SubscriptionAndPriceManager.dart';
import 'FeatureListWidget.dart';
import 'RecommendationCards.dart';
import 'ReviewCards.dart';

/**
 * 文件类型：组件
 * 文件作用：展示高级会员购买页，包含权益说明、商品价格选择和恢复购买入口。
 * 主要职责：从 SubscriptionAndPriceManager 读取当前平台可购买商品，并把用户选中的商品交给外层执行购买。
 */
class PremiumUpgradeWidget extends StatefulWidget {
  final Function onClickPurchageCallback;

  PremiumUpgradeWidget({required this.onClickPurchageCallback});

  @override
  State<StatefulWidget> createState() {
    return PremiumUpgradeWidgetState();
  }
}

class PremiumUpgradeWidgetState extends State<PremiumUpgradeWidget> {
  static const String _logTag = 'PREMIUM_UPGRADE';
  final PageController _pageController = PageController();

  PriceProductModel? priceProductModelAnnual;
  PriceProductModel? priceProductModelMonthly;
  PriceProductModel? vipProduct;
  PriceProductModel? selectedProduct;

  List<PriceProductModel> priceProductModelList = [];
  bool _hasRequestedProductRefresh = false;
  double padding = 4;
  double horizontalPadding = 16;
  double marginItem = 30;
  int curIndex = 0;
  String? _lastProductLogSignature;

  /// 功能：输出高级会员弹窗的 UI 层日志。
  /// 说明：购买链路可能还没进入 MethodChannel，先在 UI 层记录商品列表和点击事件，方便排查 Unknown Error 卡在哪一步。
  void _logPremium(String event, String message,
      {Object? error, StackTrace? stackTrace}) {
    final String now = _logTimestamp();
    debugPrint('[$now][$_logTag][$event] $message');
    if (error != null) {
      debugPrint('[$now][$_logTag][$event] error=$error');
    }
    if (stackTrace != null) {
      debugPrint('[$now][$_logTag][$event] stackTrace=$stackTrace');
    }
  }

  /// 功能：生成统一日志时间前缀，格式固定为 MMDD HH:mm:ss，方便按时间段搜索。
  String _logTimestamp() {
    final DateTime now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(now.month)}${two(now.day)} ${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
  }

  @override
  Widget build(BuildContext context) {
    _refreshProductList();
    return ColoredBox(
      color: ThemeManager.getInstance().curThemeDataDark.colorScheme.surface,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: this.marginItem),
                        SectionTitle(title: getI18NKey().features_privileges),
                        _buildFeatureTable(),
                        SizedBox(height: this.marginItem),
                        SectionTitle(title: getI18NKey().features_components),
                        FeatureListWidget(),
                        SizedBox(height: this.marginItem),
                        SectionTitle(
                            title: getI18NKey().official_recommendations),
                        RecommendationCards(),
                        SizedBox(height: this.marginItem),
                        SectionTitle(title: getI18NKey().user_reviews),
                        ReviewCards(),
                        SizedBox(height: this.marginItem),
                        _buildRestorePurchaseButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(context)
        ],
      ),
    );
  }

  /**
   * 功能：刷新当前可展示的购买商品。
   * 说明：按实际拉到的年订阅、月订阅和一次性解锁商品组装列表，避免某个商品缺失时强制展开空值崩溃。
   */
  void _refreshProductList() {
    priceProductModelAnnual = DeviceInfoManagement.isMacOs()
        ? SubscriptionAndPriceManager.getInstance().getProductByCandidateIds(
            candidateIds: [
              SubscriptionAndPriceManager.priceAnnual,
            ],
          )
        : SubscriptionAndPriceManager.getInstance().getProductByCandidateIds(
            candidateIds: [
              SubscriptionAndPriceManager.priceAnnualMobile,
            ],
          );
    priceProductModelMonthly = DeviceInfoManagement.isMacOs()
        ? SubscriptionAndPriceManager.getInstance().getProductByCandidateIds(
            candidateIds: [
              SubscriptionAndPriceManager.priceMonthly,
            ],
          )
        : SubscriptionAndPriceManager.getInstance().getProductByCandidateIds(
            candidateIds: [
              SubscriptionAndPriceManager.priceMonthlyMobile,
            ],
          );
    vipProduct =
        SubscriptionAndPriceManager.getInstance().getProductByCandidateIds(
      candidateIds: [
        SubscriptionAndPriceManager.mangaHelloVipLifetime,
        SubscriptionAndPriceManager.mangaHelloVip,
      ],
    );

    priceProductModelList = [
      if (priceProductModelAnnual != null) priceProductModelAnnual!,
      if (priceProductModelMonthly != null) priceProductModelMonthly!,
      if (vipProduct != null) vipProduct!,
    ];
    final List<String> identifiers =
        priceProductModelList.map((item) => item.identifier).toList();
    final String signature =
        'count=${priceProductModelList.length}, identifiers=$identifiers';
    if (_lastProductLogSignature != signature) {
      _lastProductLogSignature = signature;
      _logPremium(
        'product-ui-refresh',
        'isMac=${DeviceInfoManagement.isMacOs()}, $signature, trials=${priceProductModelList.map((item) => '${item.identifier}:${item.introductoryOfferPaymentMode}/${item.introductoryOfferPeriodValue}${item.introductoryOfferPeriodUnit}x${item.introductoryOfferPeriodCount}').toList()}',
      );
    }
    if (priceProductModelList.isEmpty) {
      selectedProduct = null;
      _logPremium(
        'product-ui-empty',
        'showUnknownError=true, annual=${priceProductModelAnnual?.identifier}, monthly=${priceProductModelMonthly?.identifier}, vip=${vipProduct?.identifier}',
      );
      _requestProductRefreshIfNeeded();
      return;
    }
    if (curIndex >= priceProductModelList.length) {
      curIndex = 0;
    }
    selectedProduct = priceProductModelList[curIndex];
  }

  /// 功能：商品为空时主动刷新一次 StoreKit 商品列表。
  /// 说明：如果单例初始化早于日志或 StoreKit 返回较慢，UI 层会先显示 Unknown Error；这里补一次刷新并触发重绘。
  Future<void> _requestProductRefreshIfNeeded() async {
    if (_hasRequestedProductRefresh) {
      return;
    }
    _hasRequestedProductRefresh = true;
    _logPremium(
      'product-ui-refresh-request',
      'reason=empty-product-list',
    );
    try {
      final List<PriceProductModel> products =
          await SubscriptionAndPriceManager.getInstance()
              .refreshProducts(source: 'PremiumUpgradeWidget.empty');
      _logPremium(
        'product-ui-refresh-result',
        'count=${products.length}, identifiers=${products.map((e) => e.identifier).toList()}',
      );
      if (mounted) {
        setState(() {});
      }
    } catch (e, stackTrace) {
      _logPremium(
        'product-ui-refresh-error',
        'reason=refreshProductsException',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Text getPriceAnnualInnerWidget(PriceProductModel priceProductModel) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text:
            '${priceProductModel.currencySymbol}${priceProductModel.price} / ${getI18NKey().year}',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      TextSpan(
        text:
            '(${getI18NKey().equivalent_per_month(priceProductModel.currencySymbol, Utility.formatToTwoDecimalPlaces(priceProductModel.price / 12))})',
        style: TextStyle(
          fontSize: 12,
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]));
  }

  Text getPriceMonthlyInnerWidget(PriceProductModel priceProductModel) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text:
            '${priceProductModel.currencySymbol}${priceProductModel.price} / ${getI18NKey().month}',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      TextSpan(
        text:
            '(${getI18NKey().equivalent_per_day(priceProductModel.currencySymbol, Utility.formatToTwoDecimalPlaces(priceProductModel.price / 30))})',
        style: TextStyle(
          fontSize: 12,
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]));
  }

  Widget _buildRestorePurchaseButton() {
    return OutlinedButton(
      onPressed: () {
        _logPremium('restore-ui-tap', 'source=PremiumUpgradeWidget');
        SubscriptionAndPriceManager.getInstance().restorePurchases();
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.orange, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      ),
      child: Text(
        getI18NKey().restore_purchase,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildPriceList() {
    // return InkWell(
    //   onTap: () {
    //     setState(() {
    //       priceProductModel = priceProductModelList?[0];
    //     });
    //   },
    //   child: Container(
    //     margin: EdgeInsets.all(8),
    //     padding: EdgeInsets.all(8),
    //     decoration: BoxDecoration(
    //       color: priceProductModel == priceProductModelList?[0]
    //           ? Colors.orange
    //           : Colors.grey,
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     child: getPriceInnerWidget( priceProductModelList![0]),
    //   ),
    // );
    if (priceProductModelList.isEmpty) {
      return Container(
        height: 40,
        alignment: Alignment.center,
        child: Text(
          getI18NKey().unknown_error,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Container(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: priceProductModelList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                this.curIndex = index;
                selectedProduct = priceProductModelList[index];
              });
              _logPremium(
                'product-ui-select',
                'index=$index, identifier=${selectedProduct?.identifier}, price=${selectedProduct?.price}, currency=${selectedProduct?.currencySymbol}',
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 4),
              // border width 设置成 1的金色
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      curIndex == index ? ColorsConfig.colorGold : Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildPriceItemInnerWidget(priceProductModelList[index]),
            ),
          );
        },
      ),
    );
  }

  /**
   * 功能：根据商品类型展示价格文案。
   * 说明：年/月订阅保留原来的折算文案，永久 VIP 商品展示为单次解锁价格。
   */
  Widget _buildPriceItemInnerWidget(PriceProductModel priceProductModel) {
    if (priceProductModel.identifier ==
            SubscriptionAndPriceManager.priceAnnual ||
        priceProductModel.identifier ==
            SubscriptionAndPriceManager.priceAnnualMobile) {
      return getPriceAnnualInnerWidget(priceProductModel);
    }
    if (priceProductModel.identifier ==
            SubscriptionAndPriceManager.priceMonthly ||
        priceProductModel.identifier ==
            SubscriptionAndPriceManager.priceMonthlyMobile) {
      return getPriceMonthlyInnerWidget(priceProductModel);
    }
    return _buildOneTimePurchasePriceWidget(priceProductModel);
  }

  /// 功能：展示一次性买断商品的完整价格文案。
  /// 说明：一次性购买没有订阅周期和试用期，需要明确标注“永久解锁/无自动续订”，避免用户误以为也是订阅价格。
  Widget _buildOneTimePurchasePriceWidget(PriceProductModel priceProductModel) {
    final bool isZh = _isZhLocale(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isZh ? '永久解锁' : 'Lifetime Access',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2),
          Text(
            isZh
                ? '${priceProductModel.currencySymbol}${priceProductModel.price} 一次性买断'
                : '${priceProductModel.currencySymbol}${priceProductModel.price} one-time',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 2),
          Text(
            isZh ? '不自动续订' : 'No auto-renewal',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xffb0b0b0),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能：根据选中商品生成购买按钮文案。
  /// 说明：试用期来自 StoreKit introductory offer；一次性购买或未配置免费试用时显示普通升级文案，避免继续写死 7 天。
  String _buildPurchaseButtonText(BuildContext context) {
    final PriceProductModel? product = selectedProduct;
    if (product == null) {
      return getI18NKey().upgrade_now;
    }
    if (_isOneTimePurchaseProduct(product)) {
      return _isZhLocale(context) ? '一次性买断永久解锁' : 'Buy Lifetime Access';
    }
    if (product.hasFreeTrial) {
      final int value = product.introductoryOfferTotalPeriodValue;
      final String unit =
          _buildTrialUnitText(product.introductoryOfferPeriodUnit, value);
      if (_isZhLocale(context)) {
        return '免费试用 $value$unit';
      }
      return 'Start Free Trial for $value $unit';
    }
    return getI18NKey().upgrade_now;
  }

  /// 功能：生成购买按钮下方的补充说明。
  /// 说明：订阅商品展示试用和续订说明；一次性买断展示无自动续订，降低用户对扣费方式的疑虑。
  String _buildPurchaseNoticeText(BuildContext context) {
    final PriceProductModel? product = selectedProduct;
    if (_isOneTimePurchaseProduct(product)) {
      if (_isZhLocale(context)) {
        return '一次性购买，永久解锁当前高级功能，不会自动续订。升级即表示您同意《${getI18NKey().eula}》和《${getI18NKey().privacy_policy}》。';
      }
      return 'One-time purchase for lifetime access. No subscription or auto-renewal. By upgrading, you agree to the ${getI18NKey().eula}, ${getI18NKey().privacy_policy}.';
    }
    return getI18NKey().auto_renew_after_trial;
  }

  /// 功能：判断商品是否为一次性买断。
  /// 说明：一次性买断 SKU 已迁移为非消耗型产品，此处兼容新/老商品 ID。
  bool _isOneTimePurchaseProduct(PriceProductModel? product) {
    if (product == null) {
      return false;
    }
    final String identifier = product.identifier;
    return identifier == SubscriptionAndPriceManager.mangaHelloVip ||
        identifier == SubscriptionAndPriceManager.mangaHelloVipLifetime;
  }

  /// 功能：判断当前界面是否使用中文文案。
  /// 说明：不依赖新增国际化字段，避免只为一处文案触发全量生成文件改动。
  bool _isZhLocale(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'zh';
  }

  /// 功能：把 StoreKit 的试用周期单位转成当前按钮可读的文案。
  /// 说明：英文需要根据数量处理单复数，中文直接使用固定单位即可。
  String _buildTrialUnitText(String periodUnit, int value) {
    final bool isZh = _isZhLocale(context);
    if (isZh) {
      switch (periodUnit) {
        case 'day':
          return '天';
        case 'week':
          return '周';
        case 'month':
          return '个月';
        case 'year':
          return '年';
        default:
          return '';
      }
    }
    switch (periodUnit) {
      case 'day':
        return value == 1 ? 'Day' : 'Days';
      case 'week':
        return value == 1 ? 'Week' : 'Weeks';
      case 'month':
        return value == 1 ? 'Month' : 'Months';
      case 'year':
        return value == 1 ? 'Year' : 'Years';
      default:
        return 'Days';
    }
  }

  Widget _buildHeaderSection() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              color: Color(0xFF3E3E3E),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.black,
                  child: index == 0
                      ? GuideWidget(
                          imagePath: R.assetsImgBgGuideBuy,
                          title: getI18NKey().enjoy_10x_expansion,
                          desc: getI18NKey().create_more_achieve_more,
                        )
                      : index == 1
                          ? GuideWidget(
                              imagePath: 'assets/images/feature_1.png',
                              title: getI18NKey().advanced_reminders,
                              desc: getI18NKey().never_forget_important,
                            )
                          : index == 2
                              ? GuideWidget(
                                  imagePath: 'assets/images/feature_2.png',
                                  title: getI18NKey().data_analysis,
                                  desc: getI18NKey().detailed_analysis_reports,
                                )
                              : GuideWidget(
                                  imagePath: 'assets/images/feature_3.png',
                                  title: getI18NKey().custom_themes,
                                  desc: getI18NKey().customize_appearance,
                                ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeatureTable() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Color(0xFF3E3E3E), width: 1.0),
      ),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
        },
        children: [
          _buildHeaderTableRow(getI18NKey().benefits, getI18NKey().normal_user,
              getI18NKey().premium_user),
          _buildTableRow(getI18NKey().calendar_view, getI18NKey().basic,
              getI18NKey().monthweekday),
          _buildTableRow(getI18NKey().time_slots, '-', '✓'),
          _buildTableRow(getI18NKey().persistent_reminders, '-', '✓'),
          _buildTableRow(getI18NKey().link_wechat, '-', '✓'),
          _buildTableRow(
              getI18NKey().widgets, getI18NKey().basic, getI18NKey().unlimited),
          _buildTableRow(getI18NKey().appearance_themes, getI18NKey().basic,
              getI18NKey().unlimited),
          _buildTableRow(getI18NKey().data_statistics, getI18NKey().basic,
              getI18NKey().unlimited),
        ],
      ),
    );
  }

  TableRow _buildHeaderTableRow(
      String feature, String normalUser, String premiumUser) {
    return TableRow(
      decoration: BoxDecoration(color: Color(0xFF2D2D2D)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(feature,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(normalUser, style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(premiumUser,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ),
      ],
    );
  }

  TableRow _buildTableRow(
      String feature, String normalUser, String premiumUser) {
    return TableRow(
      decoration: BoxDecoration(color: Color(0xFF222222)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(feature,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(normalUser, style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(premiumUser, style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildPriceList(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: selectedProduct == null
                ? null
                : () {
                    _logPremium(
                      'purchase-ui-tap',
                      'identifier=${selectedProduct?.identifier}, price=${selectedProduct?.price}, currency=${selectedProduct?.currencySymbol}, hasFreeTrial=${selectedProduct?.hasFreeTrial}, trial=${selectedProduct?.introductoryOfferPeriodValue}${selectedProduct?.introductoryOfferPeriodUnit}x${selectedProduct?.introductoryOfferPeriodCount}',
                    );
                    this.widget.onClickPurchageCallback.call(selectedProduct);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              textStyle: TextStyle(fontSize: 20),
            ),
            child: Text(
              _buildPurchaseButtonText(context),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          ParsedText(
            text: _buildPurchaseNoticeText(context),
            parse: <MatchText>[
              MatchText(
                  pattern: getI18NKey().eula, //匹配规则
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                  onTap: (url) {
                    Utility.openExternalWebView(url: Utility.getEULAUrl());
                  }),
              MatchText(
                  pattern: getI18NKey().privacy_policy, //匹配规则
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                  onTap: (url) {
                    Utility.openExternalWebView(
                        url: Utility.getPrivacyProtocolUrl());
                  }),
              MatchText(
                  pattern: getI18NKey().terms_of_use, //匹配规则
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                  onTap: (url) {
                    Utility.openExternalWebView(url: Urls.ratingGuide);
                  }),
            ],
            style: TextStyle(
              color: Color(0xff878787),
              fontSize: 15,
              decoration: TextDecoration.none,
            ),
          )
          // Text(
          //   getI18NKey().auto_renew_after_trial,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 14, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}

class GuideWidget extends StatelessWidget {
  final BorderRadius borderRadius = BorderRadius.circular(16.0);
  final String imagePath;
  final String title;
  final String desc;

  GuideWidget({
    required this.imagePath,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Container(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          color: Colors.black,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
