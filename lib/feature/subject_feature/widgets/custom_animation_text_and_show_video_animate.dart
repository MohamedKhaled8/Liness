import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class CustomAnimationTextAndShowVideoAnimate extends StatelessWidget {
  const CustomAnimationTextAndShowVideoAnimate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppImageHelper(
          path: ImageAssetsManger.courses,
          height: 25.h,
        ),
        Text(AppLocalizations.of(context)!.translate('Choose a Subject'),
            style: StylesManager.textStyle18Bold(context)),
        Text(
          AppLocalizations.of(context)!.translate(
              'Discover the joy of learning and enjoy\n a day full of achievement and excellence!'),
          textAlign: TextAlign.center,
          style: StylesManager.textStyle16None,
        ),
      ],
    );
  }
}
