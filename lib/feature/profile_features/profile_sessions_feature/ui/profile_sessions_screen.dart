import 'package:flutter/material.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/profile_features/widgets/animation_profile_record_widget.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/model/api/recorde_model.dart';
import 'package:liness/core/utils/config/space.dart';

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
        backgroundColor: ChangeTranslateAndTheme.isDarkMode(context)
            ? const Color(0xFF0F0F1E)
            : const Color(0xFFF8F9FA),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Container(
                  padding: EdgeInsets.all(6.sp),
                  decoration: BoxDecoration(
                    color: ChangeTranslateAndTheme.isDarkMode(context)
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18.sp,
                    color: ChangeTranslateAndTheme.isDarkMode(context)
                        ? ColorsManger.white
                        : ColorsManger.black,
                  ),
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.translate('My Sessions'),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ChangeTranslateAndTheme.isDarkMode(context)
                      ? ColorsManger.white
                      : ColorsManger.black,
                ),
              ),
              floating: true,
              pinned: true,
            ),
            sessionsInfoList.isNotEmpty
                ? SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.sp,
                      vertical: 8.sp,
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
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300.sp,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 0,
                        mainAxisExtent: 45.sp,
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          verticalSpace(20),
                          AppImageHelper(
                            height: 34.sp,
                            path: ImageAssetsManger.errornet,
                          ),
                          verticalSpace(2),
                          Text(
                            AppLocalizations.of(context)!.translate('N/A'),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 30.sp,
              child: FloatingActionButton.small(
                heroTag: 'sessions_fab_up',
                backgroundColor: ColorsManger.primaryColor,
                onPressed: scrollToTop,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton.small(
                heroTag: 'sessions_fab_down',
                backgroundColor: ColorsManger.red,
                onPressed: scrollToBottom,
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
