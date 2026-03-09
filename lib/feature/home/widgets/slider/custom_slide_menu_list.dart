import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/feature/home/data/model/slide_model.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/widgets/custom_theme_toggle.dart';

class SlideMenuList extends StatelessWidget {
  final List<SlideModel> slideMenuItems;

  const SlideMenuList({Key? key, required this.slideMenuItems})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 159, 230),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 1.h,
                      horizontal: 1.5.w,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25.sp,
                          backgroundImage: const AssetImage(
                            ImageAssetsManger.noPhoto,
                          ),
                        ),
                        verticalSpace(1),
                        Text(
                          gLoginUserModel?.email ?? "Email is Empty",
                          style: StylesManager.textStyle16FontFamile.copyWith(
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "User Code: ${gLoginUserModel?.code ?? "Code is Empty"}",
                          style: StylesManager.textStyle16FontFamile.copyWith(
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: .2.h,
                      horizontal: 1.5.w,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: ColorsManger.white,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Text(
                            AppLocalizations.of(context)!.translate('Browser'),
                            style: StylesManager.textStyle20White.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: ColorsManger.white,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(.5),
                  ...slideMenuItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    SlideModel item = entry.value;

                    if (item.title ==
                            AppLocalizations.of(
                              context,
                            )!.translate('Dark Mode') ||
                        item.title ==
                            AppLocalizations.of(
                              context,
                            )!.translate('Light Mode')) {
                      return BlocBuilder<AppCubit, AppState>(
                        builder: (context, state) {
                          final appCubit = context.read<AppCubit>();
                          final isDarkMode = appCubit.isDarkMode();

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                            decoration: BoxDecoration(
                              color: cubit.activeIndex == index
                                  ? ColorsManger.mainColor
                                  : ColorsManger.transparent,
                              borderRadius: BorderRadius.circular(15.sp),
                              border: Border.all(
                                color: cubit.activeIndex == index
                                    ? Colors.lightBlue
                                    : Colors.transparent,
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 1.5.w,
                            ),
                            child: InkWell(
                              onTap: () {
                                appCubit.toggleTheme();
                              },
                              borderRadius: BorderRadius.circular(15.sp),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: ListTile(
                                  key: ValueKey(isDarkMode),
                                  leading: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      key: ValueKey(isDarkMode),
                                      isDarkMode
                                          ? Icons.nightlight_round
                                          : Icons.wb_sunny,
                                      color: ColorsManger.white,
                                    ),
                                  ),
                                  title: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    child: Text(
                                      key: ValueKey(isDarkMode),
                                      item.title,
                                      style: const TextStyle(
                                        color: ColorsManger.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  trailing: CustomThemeToggle(
                                    width: 50,
                                    height: 25,
                                    activeColor: ColorsManger.mainBlue,
                                    inactiveColor: ColorsManger.white
                                        .withOpacity(0.3),
                                    thumbColor: Colors.white,
                                    animationDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return InkWell(
                      onTap: () {
                        if (item.onTap != null) {
                          item.onTap!(context);
                        }
                        cubit.changeIndexClicked(index);
                      },
                      borderRadius: BorderRadius.circular(15.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cubit.activeIndex == index
                              ? ColorsManger.mainColor
                              : ColorsManger.transparent,
                          borderRadius: BorderRadius.circular(15.sp),
                          border: Border.all(
                            color: cubit.activeIndex == index
                                ? Colors.lightBlue
                                : Colors.transparent,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 1.5.w,
                        ),
                        child: ListTile(
                          leading: Icon(item.icon, color: ColorsManger.white),
                          title: Text(
                            item.title,
                            style: const TextStyle(color: ColorsManger.white),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
