import 'package:cloud_firestore/cloud_firestore.dart';

class PcBuild {
  final String uid;
  final String title;
  final double rating;
  final int ratingCount;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> ratedBy;
  final DateTime createdAt;

  PcBuild({
    required this.uid,
    required this.title,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.ratedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'rating': rating,
      'ratingCount': ratingCount,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'ratedBy': ratedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PcBuild.fromMap(Map<String, dynamic> map) {
    // Handle rating conversion
    double ratingValue = 0.0;
    int ratingCountValue = 0;

    if (map['rating'] != null) {
      if (map['rating'] is String) {
        // Parse string format like "★ 4.6 (17 reviews)"
        final ratingStr = map['rating'] as String;
        final ratingMatch = RegExp(r'★\s*(\d+\.?\d*)\s*\((\d+)\s*reviews?\)').firstMatch(ratingStr);
        if (ratingMatch != null) {
          ratingValue = double.parse(ratingMatch.group(1)!);
          ratingCountValue = int.parse(ratingMatch.group(2)!);
        }
      } else if (map['rating'] is num) {
        ratingValue = (map['rating'] as num).toDouble();
        ratingCountValue = map['ratingCount'] ?? 0;
      }
    }

    return PcBuild(
      uid: map['uid'] ?? "",
      title: map['title'] ?? '',
      rating: ratingValue,
      ratingCount: ratingCountValue,
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      ratedBy: List<String>.from(map['ratedBy'] ?? []),
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  String get formattedRating {
    if (ratingCount == 0) return '★ 0.0 (0 reviews)';
    return '★ ${rating.toStringAsFixed(1)} ($ratingCount reviews)';
  }

  bool hasUserRated(String userId) {
    return ratedBy.contains(userId);
  }
} 