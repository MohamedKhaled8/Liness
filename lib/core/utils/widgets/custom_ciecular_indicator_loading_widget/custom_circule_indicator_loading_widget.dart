import 'package:flutter/material.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return Center(
      child: CircularProgressIndicator(
        color: isDarkMode ? ColorsManger.red : ColorsManger.primaryColor,
      ),
    );
  }
}
