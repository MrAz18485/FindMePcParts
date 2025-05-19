class Part {
  String name;
  String category;
  double price;
  String imageUrl;
  String? buyUrl;

  Part({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.buyUrl,
  });

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] is String) 
          ? double.tryParse(map['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0
          : (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      buyUrl: map['buy_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'buy_url': buyUrl,
    };
  }
}