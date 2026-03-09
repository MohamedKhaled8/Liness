import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/function/get_subject_image.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/subject_feature/data/model/subject_model.dart';
import 'package:liness/core/utils/widgets/custom_shimmer/custom_simmer_widget.dart';

class SubjectItem extends StatelessWidget {
  final SubjectModel subject;
  final int index;
  final bool isLoading;

  const SubjectItem({
    Key? key,
    required this.subject,
    required this.index,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    String subjectImage = GetSubjectImage().getSubjectImage(subject);

    return GestureDetector(
      onTap: () async {
        if (!isLoading) {
          context.pushNamed(
            Routes.coursesScreen,
            arguments: [
              null,
              subject.id,
            ],
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 5.h,
          right: stv(context: context, mobile: 2.w, tablet: 2.w, desktop: 5.w),
          left: stv(context: context, mobile: 2.w, tablet: 2.w, desktop: 5.w),
        ),
        child: SizedBox(
          height: stv(
            context: context,
            mobile: otv(context: context, portrait: 20.h, landscape: 55.h),
            tablet: otv(context: context, portrait: 20.h, landscape: 40.h),
            desktop: otv(context: context, portrait: 40.h, landscape: 55.h),
          ),
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: SizedBox(
                  height: stv(
                      context: context,
                      mobile: 50.h,
                      tablet: otv(
                          context: context, portrait: 20.h, landscape: 40.h),
                      desktop: 55.h),
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: isLoading
                            ? CustomShimmerWidget(
                                width: double.infinity,
                                height: 20.h,
                              )
                            : AppImageHelper(
                                path: subjectImage,
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
              if (!isLoading) ...[
                Positioned(
                  top: -3.h,
                  right: 20.sp,
                  child: Container(
                    height: 10.h,
                    width: 20.w,
                    decoration: const BoxDecoration(
                      color: ColorsManger.green,
                      shape: BoxShape.circle,
                    ),
                    child: Hero(
                      tag: 'subject_image_${subject.id}',
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(subject.img),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6.h,
                  left: 10.w,
                  child: Text(
                    context
                        .read<AppCubit>()
                        .getLocalizedText(subject.nameAr, subject.nameEn),
                    style: TextStyle(
                      color: ColorsManger.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  top: stv(
                    context: context,
                    mobile:
                        otv(context: context, portrait: 11.h, landscape: 20.h),
                    tablet:
                        otv(context: context, portrait: 11.h, landscape: 20.h),
                    desktop:
                        otv(context: context, portrait: 15.h, landscape: 25.h),
                  ),
                  left: 10.w,
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                        'Learn and grow daily success\nfollows steady steps'),
                    style: StylesManager.textStyle18W500.copyWith(
                      fontSize: 18.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('View Course'),
                      style: TextStyle(
                        color: ColorsManger.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
