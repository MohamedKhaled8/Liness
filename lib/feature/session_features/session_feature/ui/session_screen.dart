import 'dart:ui';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';
import 'package:liness/feature/session_features/session_feature/_logic/cubits/session_cubit.dart';
import 'package:liness/feature/session_features/session_feature/_logic/states/session_state.dart';
import 'package:liness/feature/session_features/session_feature/ui/views/session_info_view.dart';
import 'package:liness/feature/session_features/session_feature/ui/views/teacher_info_view.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    final sesionCubit = context.read<SessionCubit>();

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          final isDark = ChangeTranslateAndTheme.isDarkMode(context);
          // Use Pure Black for Dark Mode to avoid the blue tint issues
          final bgColor = isDark ? const Color(0xFF000000) : Colors.white;

          return Scaffold(
            backgroundColor: bgColor,
            body: BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                if (state is SessionLoadingState) {
                  return const Center(child: LoadingIndicator());
                }

                if (sesionCubit.sessionModel != null) {
                  final sessionModel = sesionCubit.sessionModel!;
                  return Stack(
                    children: [
                      CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // 1. Header with soft gradient
                          SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                AppImageHelper(
                                  height: 40.h,
                                  width: double.infinity,
                                  path: sessionModel.sessionImage,
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

                          // 2. Main Content (No overlaps to avoid coordinate issues)
                          SliverToBoxAdapter(
                            child: Container(
                              color: bgColor,
                              child: Column(
                                children: [
                                  SessionInfoView(sessionModel: sessionModel),
                                  verticalSpace(2),
                                  TeacherInfoView(
                                      teacherModel: sessionModel.teacherModel),
                                  verticalSpace(5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 3. Simple Back Button
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
                  return const Center(
                      child: AppImageHelper(path: ImageAssetsManger.errornet));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
