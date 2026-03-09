import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class TeacherResentSessionWidgets extends StatelessWidget {
  final double widthImage;
  final double heightImage;
  final String image;
  final String imageTeacher;
  final String nameCource;
  final int index;
  final List<Color> colorsList;

  const TeacherResentSessionWidgets({
    Key? key,
    required this.widthImage,
    required this.heightImage,
    required this.image,
    required this.imageTeacher,
    required this.nameCource,
    required this.index,
    required this.colorsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    final colors = colorsList.isEmpty
        ? [
            ColorsManger.primaryColor,
            isDarkMode
                ? const Color.fromARGB(255, 110, 72, 192)
                // ignore: deprecated_member_use
                : ColorsManger.black.withOpacity(0.2),
            ColorsManger.gray,
            ColorsManger.red,
            ColorsManger.orange,
            ColorsManger.pink,
            ColorsManger.green,
            ColorsManger.yellow,
          ]
        : colorsList;

    Color containerColor = colors[index % colors.length];

    String courseDisplayText = nameCource.replaceAll(RegExp(r'[()]'), '');

    if (courseDisplayText.length > 48) {
      int mid = courseDisplayText.length ~/ 2;
      courseDisplayText =
          '${courseDisplayText.substring(0, mid)}\n${courseDisplayText.substring(mid)}';
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: stv(
            context: context,
            mobile: otv(context: context, portrait: 1.w, landscape: 10.w),
            tablet: otv(context: context, portrait: 1.w, landscape: 10.w),
            desktop: 15.w),
        vertical: stv(
            context: context,
            mobile: otv(context: context, portrait: 5.h, landscape: 15.h),
            tablet: otv(context: context, portrait: 5.h, landscape: 15.h),
            desktop: 10.h),
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      height: stv(
          context: context,
          mobile: null,
          tablet: null,
          desktop: MediaQuery.of(context).size.height * 0.3),
      decoration: BoxDecoration(
        color: ColorsManger.white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: isDarkMode
                ? containerColor.withOpacity(0.8)
                : Colors.black.withOpacity(0.3),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0.sp, // تحديد الموقع الأيسر
            top: 0.sp,
            bottom: 0.sp,
            child: Image.asset(
              ImageAssetsManger.sshapp2,
              fit: BoxFit.cover,
            ),
          ),
          // الصورة في الركن الأيمن
          Positioned(
            right: 0.sp, // تحديد الموقع الأيمن
            top: 0.sp,
            bottom: 0.sp,
            child: Image.asset(
              ImageAssetsManger.sshapp2,
              width: MediaQuery.of(context).size.width * 0.5, // عرض الصورة
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpace(12),
              Flexible(
                child: Text(
                  courseDisplayText,
                  style: TextStyle(
                    fontSize: 16.5.sp,
                    color: ColorsManger.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              verticalSpace(1),
              Flexible(
                child: Text(
                  imageTeacher,
                  style: TextStyle(
                    fontSize: 16.5.sp,
                    color: ColorsManger.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap:
                      true, // يسمح بتقسيم النص على أسطر متعددة إذا لزم الأمر
                  overflow: TextOverflow
                      .ellipsis, // تقليص النص بإضافة النقاط الثلاثة في حال كان طويلًا جدًا
                  maxLines: 2, // يمكنك ضبط الحد الأقصى لعدد الأسطر حسب الحاجة
                ),
              ),
            ],
          ),
          Positioned(
            top: -heightImage / 2,
            child: Container(
              width: stv(
                  context: context,
                  mobile:
                      otv(context: context, portrait: 46.sp, landscape: 43.sp),
                  tablet: 47.sp,
                  desktop: 42.sp),
              height: stv(
                  context: context,
                  mobile:
                      otv(context: context, portrait: 46.sp, landscape: 43.sp),
                  tablet: 47.sp,
                  desktop: 42.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.sp),
                border: Border.all(
                  color: containerColor,
                  width: 5,
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.sp),
                  child: AppImageHelper(
                    path: image,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
