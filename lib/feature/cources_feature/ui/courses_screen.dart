import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/cources_feature/logic/cubit/courses_cubit.dart';
import 'package:liness/feature/cources_feature/widgets/course_slider_in_card.dart';
import 'package:liness/feature/cources_feature/widgets/teacher_statistic_widget.dart';
import 'package:liness/feature/cources_feature/widgets/header_course_screen_widget.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesCubit = context.read<CoursesCubit>();
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocBuilder<CoursesCubit, CoursesState>(
            builder: (context, state) {
              if (state is CoursesLoadingState) {
                return const Center(
                  child: LoadingIndicator(),
                );
              }

              // Check if teacher courses exist
              bool isTeacherCourses = coursesCubit.allCourses != null &&
                  coursesCubit.allCourses?.teacherExp != null;

              // Ensure courses are available
              if ((coursesCubit.allCourses != null) &&
                  coursesCubit.allCourses!.coursesOrSessions.isNotEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: verticalSpace(5)),
                    const SliverToBoxAdapter(
                      child: HeadrerCourseScreenWidget(),
                    ),
                    if (isTeacherCourses) ...[
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TeacherStatisticsWidget(
                              number:
                                  '${coursesCubit.allCourses!.teacherStudentsCount ?? 0}k',
                              discription: AppLocalizations.of(context)!
                                  .translate("Total Students"),
                              image: ImageAssetsManger.studentsIcon,
                            ),
                            TeacherStatisticsWidget(
                              number:
                                  coursesCubit.allCourses!.teacherExp != null
                                      ? coursesCubit.allCourses!.teacherExp
                                          .toString()
                                      : AppLocalizations.of(context)!
                                          .translate("N/A"),
                              discription: AppLocalizations.of(context)!
                                  .translate("Years in Experience"),
                              image: ImageAssetsManger.teacherExperience,
                            ),
                          ],
                        ),
                      ),
                    ],
                    SliverPadding(
                      padding: EdgeInsets.only(
                        right: 24.sp,
                        left: 24.sp,
                        top: isTeacherCourses ? 9.sp : 18.sp,
                        bottom: isTeacherCourses ? 0 : 36.sp,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: stv(
                                context: context,
                                mobile: 18.sp,
                                tablet: 18.sp,
                                desktop: 6.sp),
                            mainAxisSpacing: 18.sp,
                            crossAxisCount: stv(
                              context: context,
                              mobile: 1,
                              tablet: 2,
                              desktop: 3,
                            ),
                            mainAxisExtent: stv(
                                context: context,
                                mobile: otv(
                                    context: context,
                                    portrait: 74.sp,
                                    landscape: 95.sp),
                                tablet: otv(
                                  context: context,
                                  portrait: 70.sp,
                                  landscape: 75.sp,
                                ),
                                desktop: otv(
                                    context: context,
                                    portrait: 62.sp,
                                    landscape: 65.sp))

                            // childAspectRatio: _calculateAspectRatio(context),
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return CourseSlideInCard(
                              screenWidth: MediaQuery.of(context).size.width,
                              colorsList: const [], // يمكن تخصيص الألوان هنا
                              courseModel: coursesCubit
                                  .allCourses!.coursesOrSessions[index],
                              index: index, // تمرير الفهرس
                            );
                          },
                          childCount:
                              coursesCubit.allCourses!.coursesOrSessions.length,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: AppImageHelper(
                    path: ImageAssetsManger.emptyCourse,
                    width: 75.w,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
