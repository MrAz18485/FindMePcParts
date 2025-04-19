import "package:findmepcparts/routes/builder/part.dart";

class Build {
  String name;
  List<Part> parts;
  bool isExpanded;

  Build({required this.name, required this.parts, this.isExpanded = false});
}