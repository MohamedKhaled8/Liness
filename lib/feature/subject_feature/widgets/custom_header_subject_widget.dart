import 'package:flutter/material.dart';
import 'package:liness/core/utils/theme/wave_cliper.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';

class CustomHeaderSubjectWidget extends StatelessWidget {
  const CustomHeaderSubjectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: const WaveClipper(),
            child: Container(
              color: ColorsManger.mainBlue,
              height: 18.h,
            ),
          ),
        ),
        ClipPath(
          clipper: const WaveClipper(),
          child: Container(
            color: ColorsManger.mainBlue,
            height: 17.h,
          ),
        ),
        Positioned(
          top: -7.h,
          right: 4.0.w,
          child: SizedBox(
            width: 50.w,
            height: 35.h,
            child: const AppImageHelper(
              path: ImageAssetsManger.subjecttwo,
            ),
          ),
        ),
      ],
    );
  }
}
