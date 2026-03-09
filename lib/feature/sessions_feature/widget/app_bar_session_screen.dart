import 'package:liness/core/Router/export_routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class AppBarSessionScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManger.transparent,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 24,
          color: ChangeTranslateAndTheme.isDarkMode(context)
              ? ColorsManger.white
              : ColorsManger.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state is SessionsLoadingState) {
            return const LoadingIndicator();
          }

          // تأكد من أن القائمة غير فارغة
          final sessionsList = context.read<SessionsCubit>().sessionsOfCourcesList;
          final teacherName = sessionsList.isNotEmpty
              ? sessionsList.first.teacherName
              : 'No Sessions Available';

          return Directionality(
            textDirection: ChangeTranslateAndTheme.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  teacherName,
                  textAlign: TextAlign.center,
                  textStyle: StylesManager.textStyle16FontFamile.copyWith(
                    color: ChangeTranslateAndTheme.isDarkMode(context)
                        ? ColorsManger.white
                        : ColorsManger.mainBlue,
                    fontSize: stv(
                            context: context,
                            mobile: 22,
                            tablet: 40,
                            desktop: 50)
                        .toDouble(),
                    fontFamily: "ProtestGuerrilla-Regular",
                  ),
                  speed: const Duration(milliseconds: 55),
                ),
              ],
              totalRepeatCount: 1,
              isRepeatingAnimation: false,
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
