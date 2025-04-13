class Build {
  String buildname;
  List<String> partsstring;
  List<Part> parts;
  Build({required this.buildname, required this.partsstring, required this.parts });
}

class Part {
  String partname;
  String partcategory;
  int partprice;
  Part({required this.partname, required this.partcategory, this.partprice = 0});
}