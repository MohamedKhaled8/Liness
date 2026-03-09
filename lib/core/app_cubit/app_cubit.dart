import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/localization/model/languages_event_type.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppStateInitial()) {
    setCurrentTheme();
    appLanguageFunc(LanguageEventEnums.InitialLanguage);
  }

  static const String themeKey = 'theme_mode';

  Offset initialPosition = const Offset(250, 0);
  Offset switchPosition = const Offset(350, 350);
  Offset containerPosition = const Offset(350, 350);
  Offset finalPosition = const Offset(350, 350);

  late bool isLigthTheme;

  bool isDarkMode() {
    final themeString = getIt<CacheHelper>().getDataString(key: themeKey);
    return themeString == 'dark';
  }

  // void toggleTheme() {
  //   final newTheme = isDarkMode() ? 'light' : 'dark';
  //   getIt<CacheHelper>().saveData(key: themeKey, value: newTheme);
  //   emit(AppStateChangeTheme()); // إصدار حالة جديدة لتحديث الواجهة
  // }

  ThemeMode loadThemeMode() {
    final themeString = getIt<CacheHelper>().getDataString(key: themeKey);
    if (themeString == 'light') {
      return ThemeMode.light;
    } else if (themeString == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  void setCurrentTheme() {
    isLigthTheme = loadThemeMode() == ThemeMode.light;
  }

  void toggleTheme() {
    final currentTheme = getIt<CacheHelper>().getDataString(key: themeKey);
    final newTheme = currentTheme == 'light' ? 'dark' : 'light';

    // Save the new theme first
    getIt<CacheHelper>().saveData(key: themeKey, value: newTheme);

    // Update the local state
    isLigthTheme = newTheme == 'light';

    // Emit the state change to trigger UI updates
    emit(AppStateChangeTheme());
  }

  void setTheme(ThemeMode themeMode) {
    final themeString = themeMode.toString().split('.').last;

    // Save the theme first
    getIt<CacheHelper>().saveData(key: themeKey, value: themeString);

    // Update the local state
    isLigthTheme = themeMode == ThemeMode.light;

    // Emit the state change to trigger UI updates
    emit(AppStateChangeTheme());
  }

  void initializePositions(Size size) {
    initialPosition = Offset(size.width * .9, 0);

    /// check if theme is dark or light
    if (loadThemeMode() == ThemeMode.light) {
      // Light theme-specific logic
      containerPosition = Offset(size.width * .9, size.height * .4);
      finalPosition = Offset(
        size.width * .9,
        size.height * .5 - size.width * .1,
      );
    } else {
      // Dark theme-specific logic
      containerPosition = Offset(size.width * .8, size.height * .45);
      finalPosition = Offset(
        size.width * .8,
        size.height * .55 - size.width * .1,
      );
    }
  }

  /// Localization logic

  Locale currentLocale = Locale(
    getIt<CacheHelper>().getDataString(key: 'lang') ?? 'ar',
  );

  String groubLang = 'language';
  void appLanguageFunc([
    LanguageEventEnums eventType = LanguageEventEnums.InitialLanguage,
  ]) {
    switch (eventType) {
      case LanguageEventEnums.InitialLanguage:
        String? lang = getIt<CacheHelper>().getDataString(key: 'lang');
        if (lang != null) {
          currentLocale = Locale(lang);
        } else {
          // استخدام لغة النظام
          currentLocale = ui.window.locale;
          // حفظ اللغة الحالية في التخزين لاستخدامها لاحقًا
          getIt<CacheHelper>().saveData(
            key: 'lang',
            value: currentLocale.languageCode,
          );
        }

        emit(AppStateChangeLanguage(languageCode: currentLocale.languageCode));
        break;

      case LanguageEventEnums.EnglishLanguage:
        getIt<CacheHelper>().saveData(key: 'lang', value: 'en');
        currentLocale = const Locale('en');
        emit(const AppStateChangeLanguage(languageCode: 'en'));
        break;

      case LanguageEventEnums.ArabicLanguage:
        getIt<CacheHelper>().saveData(key: 'lang', value: 'ar');
        currentLocale = const Locale('ar');
        emit(const AppStateChangeLanguage(languageCode: 'ar'));
        break;
    }
  }

  String getLocalizedText(String arabicText, String englishText) {
    bool isArabic = currentLocale.languageCode == 'ar';
    return isArabic ? arabicText : englishText;
  }

  void changeLanguage(String languageCode) {
    if (languageCode == 'en') {
      appLanguageFunc(LanguageEventEnums.EnglishLanguage);
    } else {
      appLanguageFunc(LanguageEventEnums.ArabicLanguage);
    }
  }
}
