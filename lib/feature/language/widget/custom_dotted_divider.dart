import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class CustomDottedDivider extends StatelessWidget {
  const CustomDottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const dashWidth = 5.0;
        final dashCount =
            (constraints.constrainWidth() / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: .1.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color:
                        isDarkMode ? ColorsManger.white : ColorsManger.black),
              ),
            );
          }),
        );
      },
    );
  }
}
