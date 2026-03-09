import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/feature/home/data/model/slide_model.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/feature/home/widgets/contact_support.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/feature/home/ui/home_teacher_card_view.dart';
import 'package:liness/feature/home/widgets/custom_title_card.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/home/ui/views/packages_slider_view.dart';
import 'package:liness/feature/home/widgets/slider/custom_ads_slider.dart';
import 'package:liness/feature/home/widgets/header_home_screen_widget.dart';
import 'package:liness/feature/home/widgets/slider/custom_slide_menu_list.dart';
import 'package:liness/feature/home/ui/home_teacher_recent_session_card_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
    bool isArabic = getIt<CacheHelper>().getDataString(key: 'lang') == 'ar';
    List<SlideModel> slideMenuItems = createSlideMenuItems(context);

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;

          return SideMenu(
            key: sideMenuKey,
            type: isTablet
                ? SideMenuType.slideNRotate
                : SideMenuType.shrikNRotate,
            inverse: isArabic,
            background: const Color.fromARGB(255, 27, 159, 230),
            menu: SlideMenuList(slideMenuItems: slideMenuItems),
            onChange: (state) {
              if (!state && !isTablet) {
                context.read<HomeCubit>().activeIndex = 0;
              }
            },
            child: Scaffold(
              drawer: isTablet
                  ? null
                  : Drawer(
                      child: SlideMenuList(slideMenuItems: slideMenuItems)),
              body: Stack(
                children: [
                  /// المحتوى الرئيسي
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(child: verticalSpace(2)),
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  /// header
                                  HaderHomeScreenWidget(
                                      sideMenuKey: sideMenuKey),

                                  verticalSpace(2),

                                  /// slider
                                  const CardAdsSlider(),

                                  verticalSpace(2),

                                  /// title card
                                  TitleCards(
                                    title: AppLocalizations.of(context)!
                                        .translate('Explore All Courses'),
                                    subTitle: AppLocalizations.of(context)!
                                        .translate('Our Teachers'),
                                  ),
                                  verticalSpace(.5),

                                  /// teacher card
                                  const HomeTeacherCardView(),

                                  verticalSpace(1),

                                  /// title card5
                                  TitleCards(
                                    title: AppLocalizations.of(context)!
                                        .translate('Packages'),
                                    subTitle: AppLocalizations.of(context)!
                                        .translate('Our Packages'),
                                  ),

                                  verticalSpace(1),

                                  //// PackagesSlider
                                  PackagesSliderView(
                                    packageModelList: context
                                        .read<HomeCubit>()
                                        .packagesModelList,
                                  ),

                                  verticalSpace(1),

                                  /// title card
                                  TitleCards(
                                    title: AppLocalizations.of(context)!
                                        .translate('Recent Sessions'),
                                    subTitle: AppLocalizations.of(context)!
                                        .translate('Our Teachers'),
                                  ),

                                  verticalSpace(2),

                                  /// recent session
                                  const HomeTeacherRecentSessionView(
                                      colorsList: []),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const ContactSupport(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
