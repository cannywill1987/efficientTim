class SKProduct {
  final String title;
  final String description;
  final String price;
  final String identifier;

  SKProduct({
    required this.title,
    required this.description,
    required this.price,
    required this.identifier,
  });

  // 从 JSON 转换为 SKProduct 对象
  factory SKProduct.fromJson(Map<String, dynamic> json) {
    return SKProduct(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      identifier: json['identifier'] as String,
    );
  }

  // 将 SKProduct 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'identifier': identifier,
    };
  }
}