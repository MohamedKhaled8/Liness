import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class DivierWidget extends StatelessWidget {
  const DivierWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final dark = EHelperFunction.isDarkMode(context);
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(
          color: isDarkMode ? ColorsManger.white : ColorsManger.black,
          // color: dark ? ColorsManger.darkGray : ColorsManger.grey,
          thickness: 0.5,
          indent: 2.w,
          endIndent: 2.w,
        )),
        Text(
          "Or Sign With",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
            child: Divider(
          color: isDarkMode ? ColorsManger.white : ColorsManger.black,

          // color: dark ? ColorsManger.darkGray : ColorsManger.grey,
          thickness: 0.5,
          indent: 2.w,
          endIndent: 2.w,
        )),
      ],
    );
  }
}
