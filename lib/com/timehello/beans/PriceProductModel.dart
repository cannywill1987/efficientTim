// ios的定价模型
class PriceProductModel {
  final String title;
  final String description;
  final String price;
  final String identifier;

  PriceProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.identifier,
  });

  // 将JSON数据转换为Product对象
  factory PriceProductModel.fromJson(Map<String, dynamic> json) {
    return PriceProductModel(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      identifier: json['identifier'] as String,
    );
  }

  // 将Product对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'identifier': identifier,
    };
  }

  @override
  String toString() {
    return 'Product(title: $title, description: $description, price: $price, identifier: $identifier)';
  }
}