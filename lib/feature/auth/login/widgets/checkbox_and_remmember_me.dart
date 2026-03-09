import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class CheckBoxAndRemmemberMeWidget extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const CheckBoxAndRemmemberMeWidget({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isArabic = ChangeTranslateAndTheme.isArabic;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment:
          isArabic ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onTap,
          child: Text(
            text,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              color: isDarkMode ? ColorsManger.white : ColorsManger.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
