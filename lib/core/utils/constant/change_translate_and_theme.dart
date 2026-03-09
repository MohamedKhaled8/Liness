import 'package:flutter/material.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';

class ChangeTranslateAndTheme {
  static bool get isArabic => getIt<CacheHelper>().getDataString(key: 'lang') == 'ar';
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
