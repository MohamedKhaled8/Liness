import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';

class StudentStatesCountWidget extends StatelessWidget {
  final Color color;
  final int count;
  final String title;
  final String image;
  final VoidCallback onTap;
  const StudentStatesCountWidget({
    super.key,
    required this.color,
    required this.count,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: stv(
            context: context,
            mobile: otv(context: context, portrait: 15.h, landscape: 35.h),
            tablet: otv(context: context, portrait: 15.h, landscape: 30.h),
            desktop: 25.h),
        width: 90.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ////
            AppImageHelper(
                path: image,
                width: stv(
                    context: context,
                    mobile: 35.w,
                    tablet: 35.w,
                    desktop: 20.w)),
            ////
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count.toString(),
                  style: StylesManager.textStyle17(context)
                      .copyWith(color: Colors.white),
                ),
                verticalSpace(1),
                Text(
                  title,
                  style: StylesManager.textStyle17(context)
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            ////
          ],
        ),
      ),
    );
  }
}
