import 'package:flutter/material.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/profile_features/widgets/animation_profile_record_widget.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/model/api/recorde_model.dart';

class ProfileSessionsScreen extends StatelessWidget {
  final List<ProfileRecordModel> sessionsInfoList;

  const ProfileSessionsScreen({
    super.key,
    required this.sessionsInfoList,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    void scrollToTop() {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    void scrollToBottom() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            constraints.maxWidth < 600
                ? 1
                : constraints.maxWidth < 1024
                    ? 2
                    : 3;
            constraints.maxWidth < 600
                ? 3.42
                : constraints.maxWidth < 1024
                    ? 2.21
                    : 1.85;

            return CustomScrollView(
              controller: scrollController, // Add ScrollController here
              slivers: [
                SliverAppBar(
                  backgroundColor: ColorsManger.transparent,
                  leading: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: ChangeTranslateAndTheme.isDarkMode(context)
                          ? ColorsManger.white
                          : ColorsManger.black,
                    ),
                  ),
                  title: Text(
                      AppLocalizations.of(context)!.translate('My Sessions')),
                  floating: false,
                  pinned: false,
                ),
                sessionsInfoList.isNotEmpty
                    ? SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: stv(
                              context: context,
                              mobile: 14.sp,
                              tablet: 14.sp,
                              desktop: 10.sp),
                          vertical: 9.sp,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return AnimatedProfileRecordWidget(
                                index: index,
                                recordModel: sessionsInfoList[index],
                              );
                            },
                            childCount: sessionsInfoList.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 18.sp,
                            mainAxisExtent: stv(
                                context: context,
                                mobile: otv(
                                    context: context,
                                    portrait: 88.sp,
                                    landscape: 100.sp),
                                tablet: otv(
                                    context: context,
                                    portrait: 88.sp,
                                    landscape: 81.sp),
                                desktop: 78.sp),
                            crossAxisCount: stv(
                              context: context,
                              mobile: 1,
                              tablet: 2,
                              desktop: 3,
                            ),
                            childAspectRatio: stv(
                              context: context,
                              mobile: 4.25.sp,
                              tablet: 3.sp,
                              desktop: 2.sp,
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: AppImageHelper(
                            height: 65.h,
                            path: ImageAssetsManger.errornet,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 0.h,
              left: 7.w,
              child: FloatingActionButton(
                heroTag: 'sessions_fab_up',
                backgroundColor: ColorsManger.primaryColor,
                onPressed: scrollToTop, // Scroll to top on button press
                child: const Icon(
                  Icons.arrow_upward,
                ),
              ),
            ),
            Positioned(
              bottom: 0.h,
              right: 0.w,
              child: FloatingActionButton(
                heroTag: 'sessions_fab_down',
                backgroundColor: ColorsManger.red,
                onPressed: scrollToBottom, // Scroll to bottom on button press
                child: const Icon(
                  Icons.arrow_downward,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
