class PcBuild {
  final String title;
  final String rating;
  final double price;
  final String imageUrl;
  final String description;

  PcBuild({
    required this.title,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'rating': rating,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory PcBuild.fromMap(Map<String, dynamic> map) {
    return PcBuild(
      title: map['title'] ?? '',
      rating: map['rating'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }
} 