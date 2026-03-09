import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/package_features/all_packages_feature/logic/cubit/packages_cubit.dart';
import 'package:liness/feature/package_features/all_packages_feature/widgets/pakage_slider_in_card.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        body: Stack(
          children: [
            // stackبص عليها  المفروض يتشال وحد الانديكيتور هناك برضه في
            // Add your existing content here
            BlocBuilder<PackagesCubit, PackagesState>(
              builder: (context, state) {
                if (state is PackagesLoadingState) {
                  return const Center(
                    child: LoadingIndicator(),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: verticalSpace(8)),
                    SliverToBoxAdapter(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            AppLocalizations.of(context)!
                                .translate('choose course'),
                            textAlign: TextAlign.center,
                            textStyle:
                                StylesManager.textStyle16v3FontFamile.copyWith(
                              fontFamily: "ProtestGuerrilla-Regular",
                            ),
                            speed: const Duration(milliseconds: 55),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                    ),
                    if (context
                        .read<PackagesCubit>()
                        .packagesModelList
                        .isNotEmpty) ...{
                      SliverPadding(
                        padding: EdgeInsets.only(
                          right: stv(
                              context: context,
                              mobile: otv(
                                  context: context,
                                  portrait: 22.sp,
                                  landscape: 50.sp),
                              tablet: 22.sp,
                              desktop: 22.sp),
                          left: stv(
                              context: context,
                              mobile: otv(
                                  context: context,
                                  portrait: 22.sp,
                                  landscape: 50.sp),
                              tablet: 22.sp,
                              desktop: 22.sp),
                          top: 18.sp,
                          bottom: 40.sp,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 18.sp,
                            mainAxisExtent: stv(
                                context: context,
                                mobile: otv(
                                    context: context,
                                    portrait: 40.h,
                                    landscape: 95.h),
                                tablet: otv(
                                    context: context,
                                    portrait: 40.h,
                                    landscape: 60.h),
                                desktop: 70.h),
                            crossAxisCount: stv(
                              context: context,
                              mobile: 1,
                              tablet: 2,
                              desktop: 3,
                            ),
                            childAspectRatio: stv(
                              context: context,
                              mobile: 4.6.sp,
                              tablet: 4.sp,
                              desktop: 4.sp,
                            ),
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PackageSlideInCard(
                                index: index,
                                packageModel: context
                                    .read<PackagesCubit>()
                                    .packagesModelList[index],
                              );
                            },
                            childCount: context
                                .read<PackagesCubit>()
                                .packagesModelList
                                .length,
                          ),
                        ),
                      ),
                    } else ...{
                      const SliverToBoxAdapter(
                        child: Center(
                          child: AppImageHelper(
                            path: ImageAssetsManger.empty,
                          ),
                        ),
                      ),
                    }
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
