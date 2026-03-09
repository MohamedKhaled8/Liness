import 'dart:io';
import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/function/vibration_method.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class CourseAndSessionWidget extends StatelessWidget {
  final CourseAndSessionCardModel courseAndSessionModel;
  final double textPadding;
  final double? techaerNameSize;

  const CourseAndSessionWidget({
    super.key,
    required this.courseAndSessionModel,
    this.textPadding = 0,
    this.techaerNameSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isDesktop =
            Platform.isWindows || Platform.isMacOS || Platform.isLinux;

        return InkWell(
          onTap: () {
            handleTapVibration(() {
              if (courseAndSessionModel.isCourseType) {
                context.pushNamed(
                  Routes.sessionsScreen,
                  arguments: courseAndSessionModel.id,
                );
              } else {
                context.pushNamed(
                  Routes.sessionScreen,
                  arguments: courseAndSessionModel.id,
                );
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.all(otv(
                context: context,
                portrait: 8.0.sp,
                landscape: stv(
                    context: context,
                    mobile: 20.0.sp,
                    tablet: 8.0.sp,
                    desktop: 8.0.sp))),
            child: Container(
              decoration: BoxDecoration(
                color: ColorsManger.white,
                borderRadius: BorderRadius.circular(15.sp),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    color: ColorsManger.black.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.sp),
                      topRight: Radius.circular(14.sp),
                    ),
                    child: AppImageHelper(
                      height: stv(
                              context: context,
                              mobile: otv(
                                  context: context,
                                  portrait: 25.h,
                                  landscape: 90.h),
                              tablet: otv(
                                  context: context,
                                  portrait: 19.h,
                                  landscape: 40.h),
                              desktop: 35.h)
                          .toDouble(),
                      width: double.infinity,
                      path: courseAndSessionModel.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: otv(
                              context: context,
                              portrait: 2.8.h,
                              landscape: stv(
                                  context: context,
                                  mobile: 5.8.h,
                                  tablet: 5.8.h,
                                  desktop: 3.8.h)),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 11.sp,
                                vertical: 4.sp,
                              ),
                              backgroundColor: ColorsManger.mainBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11.sp),
                              ),
                            ),
                            child: Text(
                              courseAndSessionModel.isCourseType
                                  ? courseAndSessionModel.subject
                                  : courseAndSessionModel.teacherName,
                              style: StylesManager
                                  .textStyle13BlackW500FontFamile
                                  .copyWith(
                                color: ColorsManger.white,
                                fontSize: stv(
                                    context: context,
                                    mobile: 16.sp,
                                    tablet: 15.sp,
                                    desktop: 12.sp),
                              ),
                            ),
                          ),
                        ),
                        verticalSpace(1.5),
                        Text(
                          courseAndSessionModel.isCourseType
                              ? courseAndSessionModel.courseName
                              : courseAndSessionModel.sessionName,
                          textDirection: TextDirection.rtl,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: StylesManager.textStyle15BlackW700FontFamile
                              .copyWith(
                            fontSize: stv(
                                context: context,
                                mobile: 16.sp,
                                tablet: 15.sp,
                                desktop: 12.sp),
                          ),
                        ),
                        Divider(
                          color: isDesktop
                              ? ColorsManger.black
                              : ColorsManger.black.withOpacity(.2),
                          thickness: .05.h,
                          indent: 12.sp,
                          endIndent: 12.sp,
                        ),
                        if (courseAndSessionModel.isCourseType) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.ltr,
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: ColorsManger.mainBlue,
                                ),
                                horizintalSpace(1.5),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: stv(
                                            context: context,
                                            mobile: 0.sp,
                                            tablet: 12.sp,
                                            desktop: 0.sp)
                                        .toDouble(),
                                  ),
                                  child: Text(
                                    courseAndSessionModel.teacherName,
                                    style: StylesManager
                                        .textStyle15BlackW700FontFamile
                                        .copyWith(
                                      fontSize: techaerNameSize ??
                                          stv(
                                              context: context,
                                              mobile: 16.sp,
                                              tablet: 16.sp,
                                              desktop: 12.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: stv(
                                      context: context,
                                      mobile: 12.sp,
                                      tablet: 17.sp,
                                      desktop: 10.sp)
                                  .toDouble(),
                            ),
                            child: SizedBox(
                              height: otv(
                                  context: context,
                                  portrait: 4.5.h,
                                  landscape: stv(
                                      context: context,
                                      mobile: 12.h,
                                      tablet: 5.h,
                                      desktop: 5.h)),
                              width: stv(
                                      context: context,
                                      mobile: otv(
                                          context: context,
                                          portrait: 55.w,
                                          landscape: 40.w),
                                      tablet: 50.sp,
                                      desktop: 50.sp)
                                  .toDouble(),
                              child: TextButton(
                                onPressed: () {
                                  handleTapVibration(() {
                                    if (courseAndSessionModel.isCourseType) {
                                      context.pushNamed(
                                        Routes.sessionsScreen,
                                        arguments: courseAndSessionModel.id,
                                      );
                                    } else {
                                      context.pushNamed(
                                        Routes.sessionScreen,
                                        arguments: courseAndSessionModel.id,
                                      );
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 14.sp),
                                  backgroundColor: ColorsManger.mainBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.sp),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("Go to session"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: stv(
                                        context: context,
                                        mobile: 18.sp,
                                        tablet: 16.sp,
                                        desktop: 14.sp),
                                    fontFamily: StylesManager.fontFamile,
                                    color: ColorsManger.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
