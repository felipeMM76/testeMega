import 'dart:ui';
import 'package:flutter/material.dart';

final ThemeData appTheme = new ThemeData(
  fontFamily: 'Intelo',
  primaryColor: AppColors.colorPrimary,
  primaryColorDark: AppColors.colorPrimary,
  canvasColor: AppColors.colorPrimary,
  backgroundColor: Colors.white);

class AppColors {
  static var colorPrimary = const Color(0xFF2e8fd5);
  static var colorSecondary = const Color(0xFFabce45);
  static var myWhite = const Color(0xFFf8f8f8);
  static var myBlack = const Color(0xFF303030);
}
