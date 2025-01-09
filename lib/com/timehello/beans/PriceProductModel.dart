class PriceProductModel {
  final String title;
  final String description;
  final double price;
  final String priceLocaleIdentifier;
  final String identifier;
  final bool isFamilyShareable;
  final String currencySymbol;

  PriceProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.priceLocaleIdentifier,
    required this.identifier,
    required this.isFamilyShareable,
    required this.currencySymbol,
  });

  // 从 JSON 数据创建对象
  factory PriceProductModel.fromJson(Map<String, dynamic> json) {
    return PriceProductModel(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      priceLocaleIdentifier: json['priceLocaleidentifier'] as String,
      identifier: json['identifier'] as String,
      isFamilyShareable: json['isFamilyShareable'] as bool,
      currencySymbol: json['currencySymbol'] as String,
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
    };
  }

  @override
  String toString() {
    return 'PriceProductModel(title: $title, description: $description, price: $price, priceLocaleIdentifier: $priceLocaleIdentifier, identifier: $identifier, isFamilyShareable: $isFamilyShareable, currencySymbol: $currencySymbol)';
  }
}