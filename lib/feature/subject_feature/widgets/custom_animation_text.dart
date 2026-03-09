import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/subject_feature/logic/cubit/subject_cubit.dart';

class CustomAnimationText extends StatelessWidget {
  const CustomAnimationText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SubjectCubit>();

    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          AppLocalizations.of(context)!.translate('Hello Mohamed'),
          textStyle: StylesManager.textStyle18Bold(context),
          speed: const Duration(milliseconds: 70),
        ),
        TypewriterAnimatedText(
          AppLocalizations.of(context)!
              .translate('Choose from the courses \n what is useful to you'),
          textStyle: StylesManager.textStyle18None,
          textAlign: TextAlign.center,
          speed: const Duration(milliseconds: 70),
        ),
      ],
      totalRepeatCount: 1,
      onFinished: () {
        cubit.toggleShowOriginalText();
      },
    );
  }
}
