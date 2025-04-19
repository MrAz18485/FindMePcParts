import 'package:flutter/material.dart';

class AppPaddings {
  static const double parentMargin = 16.0;
  static const double regularMargin = 8.0;

  static get regularParentPadding => const EdgeInsets.all(parentMargin);
  static get regularPadding => const EdgeInsets.all(regularMargin);
  
  static const screen = EdgeInsets.symmetric(horizontal: 24, vertical: 20);
  static const content = EdgeInsets.all(16);
  static const listTile = EdgeInsets.symmetric(horizontal: 16);
}