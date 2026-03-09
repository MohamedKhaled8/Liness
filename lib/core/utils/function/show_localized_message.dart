import 'package:flutter/widgets.dart';
import 'package:liness/core/utils/function/dialoge_error.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

Future<void> showLocalizedMessage(
  BuildContext context,
  String msgAr,
  String msgEn, {
  bool isError = true,
  VoidCallback? onTap,
}) async {
  final message = ChangeTranslateAndTheme.isArabic ? msgAr : msgEn;
  await showMessage(
    context,
    message,
    isError: isError,
    onConfirmTapped: onTap,
  );
}
