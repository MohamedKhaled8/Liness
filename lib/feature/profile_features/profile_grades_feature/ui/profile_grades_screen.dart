import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/profile_record_widget.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/functions/orientation_type_value.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/profile_features/profile_grades_feature/logic/cubit/profile_grades_cubit.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class ProfileGradesScreen extends StatelessWidget {
  const ProfileGradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    ////
    final profileGradesCubit = context.read<ProfileGradesCubit>();
    ////

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        body: BlocBuilder<ProfileGradesCubit, ProfileGradesState>(
          builder: (context, state) {
            if (state is ProfileGradesLoadingState) {
              return const Center(child: LoadingIndicator());
            }

            return CustomScrollView(
              controller: context.read<ProfileGradesCubit>().scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: ColorsManger.transparent,
                  leading: IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkMode
                            ? ColorsManger.white
                            : ColorsManger.black,
                      )),
                  title:
                      Text(AppLocalizations.of(context)!.translate('Grades')),
                  floating: false,
                  pinned: false,
                ),
                profileGradesCubit.profileRecordListModel.isNotEmpty
                    ? SliverPadding(
                        padding: EdgeInsets.only(
                          right: 14.sp,
                          left: 14.sp,
                          top: 9.sp,
                          bottom: 9.sp,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 18.sp,
                            mainAxisExtent: stv(
                                context: context,
                                mobile: 92.sp,
                                tablet: otv(
                                    context: context,
                                    portrait: 92.sp,
                                    landscape: 85.sp),
                                desktop: 80.sp),
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
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ProfileRecordWidget(
                                index: index,
                                recordModel: profileGradesCubit
                                    .profileRecordListModel[index],
                              );
                            },
                            childCount: profileGradesCubit
                                .profileRecordListModel.length,
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
                heroTag: 'grades_fab_up',
                backgroundColor: ColorsManger.primaryColor,
                onPressed: context
                    .read<ProfileGradesCubit>()
                    .scrollToTop, // Scroll to top on button press
                child: const Icon(
                  Icons.arrow_upward,
                ),
              ),
            ),
            Positioned(
              bottom: 0.h,
              right: 0.w,
              child: FloatingActionButton(
                heroTag: 'grades_fab_down',
                backgroundColor: ColorsManger.red,
                onPressed: context
                    .read<ProfileGradesCubit>()
                    .scrollToBottom, // Scroll to bottom on button press
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
