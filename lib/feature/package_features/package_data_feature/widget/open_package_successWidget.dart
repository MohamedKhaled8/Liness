import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class OpendPackageSuccessWidget extends StatelessWidget {
  const OpendPackageSuccessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(8.0.sp),
      decoration: BoxDecoration(
        color: ColorsManger.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManger.green, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: ColorsManger.green,
            size: 28.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "${AppLocalizations.of(context)!.translate('The package has been opened successfully')} 🎉",
                    textStyle: StylesManager.textStyle18Bold(context)
                        .copyWith(
                      fontFamily: StylesManager.fontFamile,
                      fontSize: 16.sp,
                      color: ColorsManger.green,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                onFinished: () {
                  // Add any action after animation
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
