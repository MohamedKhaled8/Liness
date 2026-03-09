import 'views/package_info_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/course_and_session_widget.dart';
import 'package:liness/feature/package_features/package_data_feature/logic/cubit/package_data_cubit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class PackageDataScreen extends StatelessWidget {
  const PackageDataScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          final isDark = ChangeTranslateAndTheme.isDarkMode(context);
          final bgColor = isDark ? const Color(0xFF000000) : Colors.white;

          return Scaffold(
            backgroundColor: bgColor,
            body: BlocBuilder<PackageDataCubit, PackageDataState>(
              builder: (context, state) {
                final packageDataCubit = context.read<PackageDataCubit>();

                if (packageDataCubit.packageDataModel != null) {
                  return Stack(
                    children: [
                      AnimationLimiter(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            // 1. Header with soft gradient
                            SliverToBoxAdapter(
                              child: Stack(
                                children: [
                                  AppImageHelper(
                                    height: 40.h,
                                    width: double.infinity,
                                    path:
                                        packageDataCubit.packageDataModel!.img,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: const [0, 0.4, 1.0],
                                          colors: [
                                            Colors.black.withOpacity(0.6),
                                            Colors.transparent,
                                            bgColor,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 2. Main Content
                            SliverToBoxAdapter(
                              child: AnimationConfiguration.synchronized(
                                duration: const Duration(milliseconds: 600),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Container(
                                      color: bgColor,
                                      child: const Column(
                                        children: [
                                          PackageInfoView(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 3. Grid representation of sessions
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.sp, vertical: 2.h),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 18.sp,
                                  crossAxisSpacing: 18.sp,
                                  crossAxisCount: stv(
                                    context: context,
                                    mobile: 1,
                                    tablet: 2,
                                    desktop: 3,
                                  ),
                                  childAspectRatio: stv(
                                    context: context,
                                    mobile: otv(
                                      context: context,
                                      portrait: 3.75.sp,
                                      landscape: 4.1.sp,
                                    ),
                                    tablet: otv(
                                        context: context,
                                        portrait: 2.40.sp,
                                        landscape: 2.65.sp),
                                    desktop: otv(
                                        context: context,
                                        portrait: 2.9.sp,
                                        landscape: 2.sp),
                                  ),
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      columnCount: stv(
                                        context: context,
                                        mobile: 1,
                                        tablet: 2,
                                        desktop: 3,
                                      ),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: EdgeInsets.all(2.0.sp),
                                            child: CourseAndSessionWidget(
                                              textPadding: 13.sp,
                                              courseAndSessionModel:
                                                  packageDataCubit
                                                      .packageDataModel!
                                                      .sessionsList[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: packageDataCubit
                                      .packageDataModel!.sessionsList.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 4. Simple Back Button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: ChangeTranslateAndTheme.isArabic ? null : 15.sp,
                        right: ChangeTranslateAndTheme.isArabic ? 15.sp : null,
                        child: IconButton(
                          icon: Icon(
                            ChangeTranslateAndTheme.isArabic
                                ? Icons.arrow_forward
                                : Icons.arrow_back,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: LoadingIndicator());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
