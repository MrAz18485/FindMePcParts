import 'package:findmepcparts/routes/builder/part.dart';

class Build {
  String? id; // Firestore document id
  String name;
  List<Part> parts;
  bool isExpanded;

  Build({
    this.id,
    required this.name,
    required this.parts,
    this.isExpanded = false,
  });

  factory Build.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Build(
      id: documentId,
      name: map['name'] ?? '',
      parts: (map['parts'] as List<dynamic>? ?? [])
          .map((partMap) => Part.fromMap(partMap as Map<String, dynamic>))
          .toList(),
      isExpanded: map['isExpanded'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parts': parts.map((part) => part.toMap()).toList(),
      'isExpanded': isExpanded,
    };
  }
}