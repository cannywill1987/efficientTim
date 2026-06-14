/**
 * 文件类型：数据模型
 * 文件作用：承接 StoreKit 返回的商品信息，供会员购买弹窗展示价格和商品标识。
 * 主要职责：兼容订阅商品、一次性购买商品和订阅试用期字段，避免商品字段差异导致解析失败。
 */
class PriceProductModel {
  final String title;
  final String description;
  final double price;
  final String priceLocaleIdentifier;
  final String identifier;
  final bool isFamilyShareable;
  final String currencySymbol;
  final int periodValue;
  final String periodUnit; // "day" "week" "month" "year"
  final String introductoryOfferPaymentMode;
  final int introductoryOfferPeriodValue;
  final String introductoryOfferPeriodUnit;
  final int introductoryOfferPeriodCount;

  PriceProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.priceLocaleIdentifier,
    required this.identifier,
    required this.isFamilyShareable,
    required this.currencySymbol,
    required this.periodValue,
    required this.periodUnit,
    required this.introductoryOfferPaymentMode,
    required this.introductoryOfferPeriodValue,
    required this.introductoryOfferPeriodUnit,
    required this.introductoryOfferPeriodCount,
  });

  /// 功能：判断当前商品是否包含免费试用期。
  /// 说明：StoreKit 只会给订阅商品返回 introductory offer，一次性购买默认没有试用期。
  bool get hasFreeTrial =>
      introductoryOfferPaymentMode == 'freeTrial' &&
      introductoryOfferPeriodValue > 0 &&
      introductoryOfferPeriodUnit.isNotEmpty;

  /// 功能：返回试用期折算后的展示数量。
  /// 说明：部分 StoreKit 优惠会带 periodCount，这里统一折算，保证 2 周期优惠也能正确展示。
  int get introductoryOfferTotalPeriodValue =>
      introductoryOfferPeriodValue *
      (introductoryOfferPeriodCount > 0 ? introductoryOfferPeriodCount : 1);

  static int getTimeStampByPeriodUnitAndValue(
      String periodUnit, String periodValue) {
    int timeStamp = 0;
    switch (periodUnit) {
      case "day":
        timeStamp = 60 * 60 * 24 * int.parse(periodValue) * 1000;
        break;
      case "week":
        timeStamp = 60 * 60 * 24 * 7 * int.parse(periodValue) * 1000;
        break;
      case "month":
        timeStamp = 60 * 60 * 24 * 30 * int.parse(periodValue) * 1000;
        break;
      case "year":
        timeStamp = 60 * 60 * 24 * 365 * int.parse(periodValue) * 1000;
        break;
    }
    return timeStamp;
  }

  /**
   * 功能：从 StoreKit 商品 JSON 创建商品模型。
   * 说明：一次性购买没有 subscription/introductoryOffer，因此原生不会返回周期和试用字段；这里给默认值，避免商品列表解析失败后 UI 显示 Unknown Error。
   */
  factory PriceProductModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawPrice = json['price'];
    return PriceProductModel(
      title: json['title']?.toString() ?? "",
      description: json['description']?.toString() ?? "",
      price: rawPrice is num ? rawPrice.toDouble() : 0.0,
      priceLocaleIdentifier: json['priceLocaleidentifier']?.toString() ?? "",
      identifier: json['identifier']?.toString() ?? "",
      isFamilyShareable: json['isFamilyShareable'] == true,
      currencySymbol: json['currencySymbol']?.toString() ?? "",
      periodValue: json['periodValue'] is int ? json['periodValue'] as int : 0,
      periodUnit: json['periodUnit']?.toString() ?? "",
      introductoryOfferPaymentMode:
          json['introductoryOfferPaymentMode']?.toString() ?? "",
      introductoryOfferPeriodValue: json['introductoryOfferPeriodValue'] is int
          ? json['introductoryOfferPeriodValue'] as int
          : 0,
      introductoryOfferPeriodUnit:
          json['introductoryOfferPeriodUnit']?.toString() ?? "",
      introductoryOfferPeriodCount: json['introductoryOfferPeriodCount'] is int
          ? json['introductoryOfferPeriodCount'] as int
          : 0,
    );
  }

  // 将对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'priceLocaleidentifier': priceLocaleIdentifier,
      'identifier': identifier,
      'isFamilyShareable': isFamilyShareable,
      'currencySymbol': currencySymbol,
      'periodValue': periodValue,
      'periodUnit': periodUnit,
      'introductoryOfferPaymentMode': introductoryOfferPaymentMode,
      'introductoryOfferPeriodValue': introductoryOfferPeriodValue,
      'introductoryOfferPeriodUnit': introductoryOfferPeriodUnit,
      'introductoryOfferPeriodCount': introductoryOfferPeriodCount,
    };
  }

  @override
  String toString() {
    return 'PriceProductModel(title: $title, description: $description, price: $price, priceLocaleIdentifier: $priceLocaleIdentifier, identifier: $identifier, isFamilyShareable: $isFamilyShareable, currencySymbol: $currencySymbol, introductoryOfferPaymentMode: $introductoryOfferPaymentMode, introductoryOfferPeriodValue: $introductoryOfferPeriodValue, introductoryOfferPeriodUnit: $introductoryOfferPeriodUnit, introductoryOfferPeriodCount: $introductoryOfferPeriodCount)';
  }
}
