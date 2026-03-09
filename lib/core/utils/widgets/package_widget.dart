import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/package_features/all_packages_feature/models/package_model.dart';

class PackageWidget extends StatelessWidget {
  final double widthImage;
  final double heightImage;
  final PackageModel packageModel;
  final BoxFit? imageFit;
  const PackageWidget({
    Key? key,
    required this.widthImage,
    required this.heightImage,
    required this.packageModel,
    this.imageFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ////
    var isArabic = ChangeTranslateAndTheme.isArabic;
    ////
    return InkWell(
      onTap: () async {
        ////
        context.pushNamed(
          Routes.packageDataScreen,
          arguments: packageModel.id,
        );
        ////
      },
      child: Container(
        margin: EdgeInsets.all(1.w),
        width: widthImage,
        decoration: BoxDecoration(
          color: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                  path: packageModel.img,
                ),
              ),
            ),
            verticalSpace(.5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ////
                        Flexible(
                          child: Text(
                            packageModel.name,
                            style: TextStyle(
                              color: ColorsManger.black,
                              fontSize: 16.sp,
                              fontFamily: StylesManager.fontFamile,
                            ),
                            softWrap: true,
                            maxLines: null, // السماح بعدد غير محدود من الأسطر
                            textAlign:
                                TextAlign.center, // تنسيق النص في المنتصف
                            overflow: TextOverflow
                                .visible, // السماح بظهور النص بالكامل
                          ),
                        ),
                        ////
                        // if (!packageModel.isOpned) ...[
                        //   Directionality(
                        //     textDirection: TextDirection.rtl,
                        //     child: Text(
                        //       "${packageModel.price} جنيه",
                        //       style: TextStyle(
                        //         color: ColorsManger.black,
                        //         fontSize: 19.sp,
                        //         fontFamily: StylesManager.fontFamile,
                        //       ),
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //   ),
                        // ]
                        ////
                      ],
                    ),
                    verticalSpace(.3),
                    Text(
                      packageModel.des,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.5.sp,
                        fontFamily: StylesManager.fontFamile,
                      ),
                      softWrap: true,
                      maxLines: null, 
                      textAlign: TextAlign.center, 
                      overflow:
                          TextOverflow.visible, 
                    ),
                    verticalSpace(1),
                    ////
                    // MainButtonWidget(
                    //   height: 4.h,
                    //   width: 26.w,
                    //   title: AppLocalizations.of(context)!.translate("Buy"),
                    //   onTap: () {},
                    // ),
                    // ////
                    // verticalSpace(1),
                    // ////
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
