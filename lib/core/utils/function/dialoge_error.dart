import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

Future<void> showMessage(
  BuildContext context,
  String message, {
  bool isError = true,
  VoidCallback? onConfirmTapped,
}) async {
  try {
    // Set the orientation to portrait
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // ignore: empty_catches
  } catch (e) {}

  try {
    await QuickAlert.show(
      context: context,
      type: isError ? QuickAlertType.error : QuickAlertType.success,
      title: isError
          ? ChangeTranslateAndTheme.isArabic
              ? "خطأ"
              : "Error"
          : null,
      confirmBtnColor: isError ? Colors.red : Colors.green,
      onConfirmBtnTap: onConfirmTapped,
      text: message,
    );
  } finally {
    try {
      // Reset the orientation to all
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // ignore: empty_catches
    } catch (e) {}
  }
}
