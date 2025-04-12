class Build {
  String buildname;
  List<String> components;
  Build({required this.buildname, required this.components});
}

class Part {
  String partname;
  String partcategory;
  Part({required this.partname, required this.partcategory});
}