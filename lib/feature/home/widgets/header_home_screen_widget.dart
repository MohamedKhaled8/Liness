import 'package:liness/core/utils/config/space.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class HaderHomeScreenWidget extends StatefulWidget {
  final GlobalKey<SideMenuState> sideMenuKey;

  const HaderHomeScreenWidget({
    super.key,
    required this.sideMenuKey,
  });

  @override
  State<HaderHomeScreenWidget> createState() => _HaderHomeScreenWidgetState();
}

class _HaderHomeScreenWidgetState extends State<HaderHomeScreenWidget> {
  bool _showBothTexts = false;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (widget.sideMenuKey.currentState!.isOpened) {
                          widget.sideMenuKey.currentState!.closeSideMenu();
                          context.read<HomeCubit>().activeIndex = 0;
                        } else {
                          widget.sideMenuKey.currentState!.openSideMenu();
                        }
                      },
                      child: Container(
                        height: 10.h,
                        width: 10.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsManger.gray,
                        ),
                        child: const Icon(
                          Icons.list,
                          color: ColorsManger.white,
                        ),
                      ),
                    ),
                    horizintalSpace(2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _showBothTexts
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello ${gLoginUserModel?.name ?? AppLocalizations.of(context)!.translate('Guest')}',
                                      style: TextStyle(fontSize: 16.sp),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('Welcome to Liness.'),
                                      style:
                                          StylesManager.textStyle16Gray(context)
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDarkMode
                                                      ? const Color.fromARGB(
                                                          255, 75, 192, 255)
                                                      : ColorsManger.mainColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'Hello ${gLoginUserModel?.name ?? AppLocalizations.of(context)!.translate('Guest')}',
                                      textStyle: TextStyle(fontSize: 16.sp),
                                      speed: const Duration(milliseconds: 150),
                                    ),
                                    TypewriterAnimatedText(
                                      AppLocalizations.of(context)!
                                          .translate('Welcome to Liness.'),
                                      textStyle:
                                          StylesManager.textStyle16Gray(context)
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDarkMode
                                                      ? const Color.fromARGB(
                                                          255, 19, 146, 214)
                                                      : ColorsManger.mainColor),
                                      speed: const Duration(milliseconds: 150),
                                    ),
                                  ],
                                  isRepeatingAnimation: false,
                                  onFinished: () {
                                    setState(() {
                                      _showBothTexts = true;
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                    horizintalSpace(2),
                    AppImageHelper(
                      path: ImageAssetsManger.handwave,
                      height: 5.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AppImageHelper(
              path:
                  "assets/images/png/ic_launcher.png", // Add your image path here
              height: 13.h,
              width: 13.w,
            ),
          ),
        ],
      ),
    );
  }
}
