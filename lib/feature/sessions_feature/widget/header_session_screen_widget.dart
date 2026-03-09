import 'package:liness/core/Router/export_routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class HeaderSessionsScreenWidget extends StatelessWidget {
  const HeaderSessionsScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sessionsCubit = context.read<SessionsCubit>();
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    final isArabic = ChangeTranslateAndTheme.isArabic;
    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManger.gray.withOpacity(0.5)),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: isDarkMode ? ColorsManger.white : ColorsManger.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    sessionsCubit.sessionsOfCourcesList.first.teacherName,
                    textAlign: TextAlign.center,
                    textStyle: StylesManager.textStyle16FontFamile.copyWith(
                      color: isDarkMode
                          ? ColorsManger.white
                          : ColorsManger.mainBlue,
                      fontSize: stv(
                              context: context,
                              mobile: 22,
                              tablet: 50,
                              desktop: 52)
                          .toDouble(),
                      fontFamily: "ProtestGuerrilla-Regular",
                    ),
                    speed: const Duration(milliseconds: 55),
                  ),
                ],
                totalRepeatCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
