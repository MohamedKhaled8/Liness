import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/function/luncher_url.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';

class CustomTeachersCardWidget extends StatelessWidget {
  final double widthImage;
  final TeacherCardModel teacherCardModel;
  final BoxFit? imageFit;
  const CustomTeachersCardWidget({
    Key? key,
    required this.widthImage,
    required this.teacherCardModel,
    this.imageFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isArabic = ChangeTranslateAndTheme.isArabic;
    return InkWell(
      onTap: () async {
        ////
        context.pushNamed(
          Routes.coursesScreen,
          arguments: [teacherCardModel.id, null],
        );
        ////
      },
      child: Container(
        margin: EdgeInsets.all(2.w),
        width: widthImage,
        decoration: BoxDecoration(
          color: ColorsManger.white,
          borderRadius: BorderRadius.circular(10.sp),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(10.sp),
                  topEnd: Radius.circular(10.sp),
                ),
                child: AppImageHelper(
                  width: double.infinity,
                  fit: imageFit ?? BoxFit.cover,
                  path: teacherCardModel.image,
                ),
              ),
            ),
            verticalSpace(.5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate("Teacher")}: ${teacherCardModel.nameTeacher}",
                        style: TextStyle(
                            color: ColorsManger.black, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      verticalSpace(.3),
                      Text(
                        "${AppLocalizations.of(context)!.translate("Subject")}: ${teacherCardModel.job}",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      verticalSpace(1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (teacherCardModel.facebookLink != null &&
                              teacherCardModel.facebookLink!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: InkWell(
                                  onTap: () {
                                    launchURL(teacherCardModel.facebookLink!);
                                  },
                                  child: AppImageHelper(
                                    path: ImageAssetsManger.facebook,
                                    width: 24.sp,
                                    height: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          if (teacherCardModel.youtubeLink != null &&
                              teacherCardModel.youtubeLink!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: InkWell(
                                  onTap: () {
                                    launchURL(teacherCardModel.youtubeLink!);
                                  },
                                  child: AppImageHelper(
                                    path: ImageAssetsManger.youtube,
                                    width: 24.sp,
                                    height: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          if (teacherCardModel.instagramLink != null &&
                              teacherCardModel.instagramLink!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: InkWell(
                                  onTap: () {
                                    launchURL(teacherCardModel.instagramLink!);
                                  },
                                  child: AppImageHelper(
                                    path: ImageAssetsManger.youtube,
                                    width: 24.sp,
                                    height: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
