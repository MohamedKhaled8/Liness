import 'package:liness/core/Router/export_routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class HeadrerCourseScreenWidget extends StatelessWidget {
  const HeadrerCourseScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = ChangeTranslateAndTheme.isArabic;
    final isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    // Initialize
    final coursesCubit = context.read<CoursesCubit>();
    bool isTeacherCourses = coursesCubit.allCourses != null &&
        coursesCubit.allCourses?.teacherExp != null;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(15.0.sp),
          child: Directionality(
            textDirection: isArabic ? TextDirection.ltr : TextDirection.ltr,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManger.gray.withOpacity(0.5)),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color:
                          isDarkMode ? ColorsManger.white : ColorsManger.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.sp),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          AppLocalizations.of(context)!
                              .translate('choose course'),
                          textAlign: TextAlign.center,
                          textStyle:
                              StylesManager.textStyle16v3FontFamile.copyWith(
                            fontSize: stv(
                                context: context,
                                mobile: 18.sp,
                                tablet: 18.sp,
                                desktop: 17.sp),
                            fontFamily: "ProtestGuerrilla-Regular",
                          ),
                          speed: const Duration(milliseconds: 55),
                        ),
                        if (isTeacherCourses) ...[
                          TypewriterAnimatedText(
                            coursesCubit.allCourses!.coursesOrSessions.first
                                .teacherName,
                            textAlign: TextAlign.center,
                            textStyle:
                                StylesManager.textStyle18Bold(context).copyWith(
                              fontFamily: StylesManager.fontFamile,
                              fontSize: stv(
                                  context: context,
                                  mobile: 16.3.sp,
                                  tablet: 16.3.sp,
                                  desktop: 17.sp),
                            ),
                            speed: const Duration(milliseconds: 55),
                          ),
                        ],
                      ],
                      totalRepeatCount: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
