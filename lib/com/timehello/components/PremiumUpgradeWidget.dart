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

class PremiumUpgradeWidget extends StatefulWidget {
  Function onClickPurchageCallback;

  PremiumUpgradeWidget({required this.onClickPurchageCallback});

  @override
  State<StatefulWidget> createState() {
    return PremiumUpgradeWidgetState();
  }
}

class PremiumUpgradeWidgetState extends State<PremiumUpgradeWidget> {
  final PageController _pageController = PageController();

  PriceProductModel? priceProductModelAnnual;
  PriceProductModel? priceProductModelMonthly;
  PriceProductModel? oneTimePurchaseProduct;

  List<PriceProductModel> priceProductModelList = [];
  double padding = 4;
  double horizontalPadding = 16;
  double marginItem = 30;
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    try {
      priceProductModelAnnual = DeviceInfoManagement.isMacOs() ? SubscriptionAndPriceManager.getInstance().getProduct(
          identifier: SubscriptionAndPriceManager.priceAnnual) :  SubscriptionAndPriceManager.getInstance().getProduct(
          identifier: SubscriptionAndPriceManager.priceAnnualMobile);
      priceProductModelMonthly = DeviceInfoManagement.isMacOs() ? SubscriptionAndPriceManager.getInstance().getProduct(
          identifier: SubscriptionAndPriceManager.priceMonthly) : SubscriptionAndPriceManager.getInstance().getProduct(
          identifier: SubscriptionAndPriceManager.priceMonthlyMobile);

      oneTimePurchaseProduct = DeviceInfoManagement.isMacOs() ? SubscriptionAndPriceManager.getInstance().getProduct(
          identifier: SubscriptionAndPriceManager.oneTimePurchase) : SubscriptionAndPriceManager.getInstance().getProduct(
          identifier: SubscriptionAndPriceManager.oneTimePurchaseMobile);
      priceProductModelList =
      [priceProductModelAnnual!, priceProductModelMonthly!, oneTimePurchaseProduct!];
    } catch (e) {
      print(e);
    }
    return ColoredBox(
      color: ThemeManager.getInstance().curThemeDataDark.colorScheme.background,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                        SectionTitle(title: getI18NKey().official_recommendations),
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


  Text getPriceAnnualInnerWidget(PriceProductModel priceProductModel) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '${priceProductModel?.currencySymbol ?? ""}${priceProductModel?.price ?? getI18NKey().unknown_error} / ${getI18NKey().year}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      TextSpan(
        text: '(${getI18NKey().equivalent_per_month(priceProductModel?.currencySymbol ??"", Utility.formatToTwoDecimalPlaces((priceProductModel?.price ?? 0) / 12))})',
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
        text: '${priceProductModel?.currencySymbol ?? ""}${priceProductModel?.price ?? getI18NKey().unknown_error} / ${getI18NKey().month}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
      TextSpan(
        text: '(${getI18NKey().equivalent_per_day(priceProductModel?.currencySymbol ?? "", Utility.formatToTwoDecimalPlaces((priceProductModel?.price ?? 0) / 30))})',
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
        SubscriptionAndPriceManager.getInstance().restoreSubscriptionPurchases();
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
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: priceProductModelList?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                this.curIndex = index;
                priceProductModelAnnual = priceProductModelList?[index];
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 4),
              // border width 设置成 1的金色
              decoration: BoxDecoration(
                border: Border.all(
                  color: curIndex == index
                      ? ColorsConfig.colorGold
                      : Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: index == 0? getPriceAnnualInnerWidget( priceProductModelList![index]) : getPriceMonthlyInnerWidget(priceProductModelList![index]),
            ),
          );
        },
      ),
    );
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
          _buildHeaderTableRow(
              getI18NKey().benefits,
              getI18NKey().normal_user,
              getI18NKey().premium_user),
          _buildTableRow(
              getI18NKey().calendar_view, getI18NKey().basic, getI18NKey().monthweekday),
          _buildTableRow(getI18NKey().time_slots, '-', '✓'),
          _buildTableRow(getI18NKey().persistent_reminders, '-', '✓'),
          _buildTableRow(getI18NKey().link_wechat, '-', '✓'),
          _buildTableRow(getI18NKey().widgets, getI18NKey().basic, getI18NKey().unlimited),
          _buildTableRow(getI18NKey().appearance_themes, getI18NKey().basic, getI18NKey().unlimited),
          _buildTableRow(getI18NKey().data_statistics, getI18NKey().basic, getI18NKey().unlimited),
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
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.orange)),
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
            onPressed: () {
              this.widget.onClickPurchageCallback.call(this.priceProductModelAnnual);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              textStyle: TextStyle(fontSize: 20),
            ),
            child: Text(
              getI18NKey().start_free_trial,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          ParsedText(
            text: getI18NKey().auto_renew_after_trial,
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
                    Utility.openExternalWebView(url: Utility.getPrivacyProtocolUrl());
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

