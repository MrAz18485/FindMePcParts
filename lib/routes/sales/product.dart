class Product {
  String productName;
  double percent;
  double price;
  String imageURL;
  List<String> property;
  String saleURL;
  double oldPrice;

  // Constructor
  Product({
    required this.productName,
    required this.percent,
    required this.price,
    required this.imageURL,
    required this.property,
    required this.saleURL,
    required this.oldPrice
  });

  // Firestore'dan gelen veriyi Product modeline dönüştürme
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      oldPrice: data['oldprice'],
      productName: data['title'] ?? '',  // 'title' Firestore'dan gelen key
      percent: (data['discountratio'] ?? 0).toDouble(),
      price: (data['price'] ?? 0).toDouble(),
      imageURL: data['imagelink'] ?? '',  // 'image_url' Firestore'dan gelen key
      property: List<String>.from(data['features'] ?? []),  // 'features' Firestore'dan gelen key
      saleURL: data['url'] ?? '',  // 'url' Firestore'dan gelen key
    );
  }

}