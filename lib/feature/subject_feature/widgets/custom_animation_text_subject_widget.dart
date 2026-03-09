import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

////أرجه هنا تاني
class CustomAnimationTextSubjectWidget extends StatelessWidget {
  const CustomAnimationTextSubjectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          '🤔 ${AppLocalizations.of(context)!.translate('What do you want to learn?')}',
          textStyle: StylesManager.textStyle18Bold(context),
          speed: const Duration(milliseconds: 50),
        ),
        ScaleAnimatedText(
          '🌟 ${AppLocalizations.of(context)!.translate('Explore New Topics!')}',
          textStyle: TextStyle(
            color: isDarkMode ? ColorsManger.white : ColorsManger.pink,
            fontSize: 20.0.sp,
            fontWeight: FontWeight.bold,
          ),
          duration: const Duration(seconds: 2),
        ),
        ColorizeAnimatedText(
          '💡 ${AppLocalizations.of(context)!.translate('Discover Your Passion!')}',
          textStyle: StylesManager.textStyle18Bold(context).copyWith(
            fontSize: 20.sp,
          ),
          colors: [
            isDarkMode ? ColorsManger.white : ColorsManger.pink,
            ColorsManger.red,
            ColorsManger.orange,
            ColorsManger.green,
            ColorsManger.primaryColor
          ],
          textAlign: TextAlign.center,
          speed: const Duration(milliseconds: 100),
        ),
      ],
      totalRepeatCount: 1,
      pause: const Duration(milliseconds: 500),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}
