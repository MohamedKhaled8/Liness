import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/functions/orientation_type_value.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/sessions_feature/logic/cubit/sessions_cubit.dart';
import 'package:liness/feature/sessions_feature/widget/app_bar_session_screen.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/course_and_session_widget.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        appBar: const AppBarSessionScreen(),
        body: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            if (state is SessionsLoadingState) {
              return const Center(
                child: LoadingIndicator(),
              );
            }

            final sessionsCubit = context.read<SessionsCubit>();

            if (sessionsCubit.sessionsOfCourcesList.isNotEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.sp, vertical: 1.h),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              portrait: 3.60.sp,
                              landscape: 4.sp),
                          tablet: otv(
                              context: context,
                              portrait: 2.32.sp,
                              landscape: 2.70.sp),
                          desktop: otv(
                              context: context,
                              portrait: 2.8.sp,
                              landscape: 1.95.sp),
                        ),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return CourseAndSessionWidget(
                            courseAndSessionModel:
                                sessionsCubit.sessionsOfCourcesList[index],
                          );
                        },
                        childCount: sessionsCubit.sessionsOfCourcesList.length,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: AppImageHelper(
                  path: ImageAssetsManger.errornet,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
