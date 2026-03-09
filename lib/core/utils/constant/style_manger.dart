import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

abstract class StylesManager {
  StylesManager._();
  static bool isDarkMode(BuildContext context) {
    return ChangeTranslateAndTheme.isDarkMode(context);
  }

  static String fontFamile = "Almarai";

  static TextStyle textStyle22 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle textStyle17(BuildContext context) => TextStyle(
      fontSize: 17.sp,
      color: isDarkMode(context) ? ColorsManger.white : ColorsManger.black);

  static TextStyle textStyle18Bold(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        color: isDarkMode(context) ? ColorsManger.white : ColorsManger.black,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyle16v3FontFamile = TextStyle(
    fontFamily: StylesManager.fontFamile,
    fontSize: 16.3.sp,
  );

  static TextStyle textStyle18None = TextStyle(
    fontSize: 18.sp,
  );

  static TextStyle textStyle16Gray(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        color: isDarkMode(context) ? ColorsManger.white : ColorsManger.gray,
      );

  static TextStyle textStyle16None = TextStyle(
    fontSize: 16.sp,
  );

  static TextStyle textStyle17White =
      TextStyle(color: ColorsManger.white, fontSize: 17.sp);
  static TextStyle textStyle14White = TextStyle(
    fontSize: 14.sp,
    color: ColorsManger.white,
  );

  static TextStyle textStyle20White = TextStyle(
    fontSize: 19.sp,
    color: ColorsManger.white,
  );

  static TextStyle textStyle17FontFamile = TextStyle(
    fontFamily: StylesManager.fontFamile,
    fontSize: 17.sp,
  );

  static TextStyle textStyle16FontFamile = TextStyle(
      fontFamily: StylesManager.fontFamile,
      fontSize: 16.sp,
      color: ColorsManger.white);

  static TextStyle textStyle16GrayNone =
      TextStyle(fontSize: 16.sp, color: ColorsManger.gray);

  static TextStyle textStyle15BlackW700FontFamile = TextStyle(
    color: ColorsManger.black,
    fontWeight: FontWeight.w700,
    fontFamily: StylesManager.fontFamile,
    fontSize: 15.sp,
    overflow: TextOverflow.ellipsis,
  );
  static TextStyle textStyle14V5BlackW500FontFamile = TextStyle(
    color: ColorsManger.black,
    fontWeight: FontWeight.w500,
    fontFamily: StylesManager.fontFamile,
    overflow: TextOverflow.ellipsis,
    fontSize: 14.5.sp,
  );
  static TextStyle textStyle13BlackW500FontFamile = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13.sp,
    fontFamily: StylesManager.fontFamile,
    color: const Color.fromARGB(255, 234, 137, 243),
  );
  static TextStyle textStyle18W500 = TextStyle(
    color: Colors.white,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
}
