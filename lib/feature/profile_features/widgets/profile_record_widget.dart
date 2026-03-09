import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:liness/core/utils/function/vibration_method.dart';
import '../main_profile_feature/data/model/api/recorde_model.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import '../profile_sessions_feature/helper/constants/profile_constants.dart';

class ProfileRecordWidget extends StatelessWidget {
  final ProfileRecordModel recordModel;
  final int index;

  const ProfileRecordWidget({
    super.key,
    required this.index,
    required this.recordModel,
  });

  @override
  Widget build(BuildContext context) {
    var isArabic = ChangeTranslateAndTheme.isArabic;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.0.sp),
      margin: EdgeInsets.symmetric(
          vertical: 1.0.h,
          horizontal:
              stv(context: context, mobile: 2.w, tablet: 2.w, desktop: 2.w)),
      decoration: BoxDecoration(
        color: ColorsManger.white,
        borderRadius: BorderRadius.circular(12.0.sp),
        border: Border(
          left: BorderSide(
            color: pcBorderColors[index % pcBorderColors.length],
            width: stv(
                context: context, mobile: 1.3.w, tablet: 1.3.w, desktop: .5.w),
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0.sp),
                child: AppImageHelper(
                  path: recordModel.img,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  height: stv(
                      context: context,
                      mobile: 200.h,
                      tablet: 50.h,
                      desktop: 50.h),
                ),
              ),
            ),
            verticalSpace(2),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: ColorsManger.black,
                ),
                horizintalSpace(3),
                Text(
                  recordModel.date,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManger.black,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 3.0.h,
                  width: 3.0.w,
                  decoration: const BoxDecoration(
                    color: ColorsManger.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            verticalSpace(2),
            Align(
              alignment:
                  isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                textAlign: TextAlign.center,
                recordModel.name,
                maxLines: 2, // السماح للنص بأن يظهر في سطرين كحد أقصى
                softWrap: true, // السماح للنص بالانتقال إلى السطر التالي
                style: TextStyle(
                  fontSize: stv(
                    context: context,
                    mobile: 17.0.sp,
                    tablet: 17.0.sp,
                    desktop: 15.0.sp,
                  ),
                  color: Colors.black,
                  overflow: TextOverflow
                      .ellipsis, // إظهار ثلاث نقاط إذا كان النص طويلًا
                ),
              ),
            ),
            verticalSpace(1),
            if (recordModel.grade.isNotEmpty) ...[
              Text(
                recordModel.grade,
                style: TextStyle(
                    fontSize: 18.0.sp,
                    color: ColorsManger.black,
                    overflow: TextOverflow.ellipsis),
              ),
              verticalSpace(2),
            ],
            Center(
              child: ElevatedButton(
                onPressed: () {
                  handleTapVibration(() {
                    if (recordModel.grade.isNotEmpty) {
                      context.pushNamed(
                        Routes.examScreen,
                        arguments: [null, recordModel.id],
                      );
                    } else {
                      context.pushNamed(
                        Routes.sessionScreen,
                        arguments: recordModel.id,
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.mainBlue,
                ),
                child: recordModel.grade.isNotEmpty
                    ? Text(
                        AppLocalizations.of(context)!.translate('Go to Exam'),
                        style: TextStyle(
                            color: ColorsManger.white, fontSize: 18.sp),
                      )
                    : Text(
                        AppLocalizations.of(context)!
                            .translate('Go to Session'),
                        style: TextStyle(
                            color: ColorsManger.white, fontSize: 18.sp),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
