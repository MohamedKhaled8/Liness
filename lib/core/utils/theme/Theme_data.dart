import 'package:flutter/material.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: ColorsManger.white,
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManger.white,
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      iconTheme: IconThemeData(color: ColorsManger.white),
    ),
    primaryColor: ColorsManger.primaryColor,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorsManger.scaffolColor,
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      backgroundColor: ColorsManger.mainBlue,
      iconTheme: IconThemeData(color: ColorsManger.black),
    ),
    primaryColor: ColorsManger.primaryColor,
  );
}
