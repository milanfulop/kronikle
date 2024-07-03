import 'dart:ui';

Size parseSize(String sizeString) {
  String cleanedString = sizeString.replaceAll("Size(", "").replaceAll(")", "");

  List<String> parts = cleanedString.split(", ");
  double width = double.parse(parts[0]);
  double height = double.parse(parts[1]);

  return Size(width, height);
}
