class Part {
  String name;
  String category;
  double price;
  String imageUrl;
  String? buyUrl;
  Map<String, dynamic> attributes;

  Part({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.buyUrl,
    this.attributes = const {},
  });
  @override
  String toString() {
    return "name: ${name}, category: ${category}, price: ${price}, attributes: ${attributes}";
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> attrs = Map<String, dynamic>.from(map)
      ..removeWhere((key, value) => 
        ['name', 'category', 'price', 'imageUrl', 'buy_url'].contains(key));

    return Part(
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] is String) 
          ? double.tryParse(map['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0
          : (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      buyUrl: map['buy_url'],
      attributes: attrs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'buy_url': buyUrl,
      ...attributes,
    };
  }
}