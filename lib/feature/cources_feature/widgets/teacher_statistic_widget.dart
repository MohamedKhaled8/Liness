import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';

class TeacherStatisticsWidget extends StatelessWidget {
  final String number;
  final String discription;
  final String image;
  const TeacherStatisticsWidget({
    super.key,
    required this.number,
    required this.discription,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(17.sp),
          child: AppImageHelper(
            height: 12.h,
            width: 12.w,
            path: image,
          ),
        ),
        ////
        horizintalSpace(1.5),
        ////
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                ////
                TypewriterAnimatedText(
                  "$number+",
                  // textAlign: TextAlign.center,
                  textStyle: StylesManager.textStyle18Bold(context).copyWith(
                    fontFamily: "ProtestGuerrilla-Regular",
                    fontSize: 17.sp,
                  ),
                  speed: const Duration(milliseconds: 265),
                ),
                ////
              ],
              totalRepeatCount: 1,
            ),
            ////
            Text(
              discription,
              // textAlign: TextAlign.center,
              style: StylesManager.textStyle18Bold(context).copyWith(
                fontFamily: "ProtestGuerrilla-Regular",
                fontSize: 14.3.sp,
              ),
            ),
            ////
          ],
        ),
      ],
    );
  }
}
