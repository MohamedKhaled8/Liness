import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';

class CustomIconAuthSocial extends StatelessWidget {
  final String image;
  final Function()? onPressed;
  const CustomIconAuthSocial({
    Key? key,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
        width: 15.w,
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode ? ColorsManger.white : ColorsManger.black),
            shape: BoxShape.circle),
        child: AppImageHelper(
          path: image,
          height: 10.h,
        ));
  }
}
