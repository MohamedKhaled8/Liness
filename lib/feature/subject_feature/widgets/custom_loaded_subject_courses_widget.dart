import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/feature/subject_feature/logic/cubit/subject_cubit.dart';
import 'package:liness/feature/subject_feature/widgets/custom_subject_items.dart';
import 'package:liness/feature/subject_feature/widgets/custom_header_subject_widget.dart';
import 'package:liness/feature/subject_feature/widgets/custom_animation_text_subject_widget.dart';

class CustomLoadedSubjectCoursesWidget extends StatelessWidget {
  final SubjectLoaded state;
  const CustomLoadedSubjectCoursesWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const CustomHeaderSubjectWidget(),
              verticalSpace(5),
              const CustomAnimationTextSubjectWidget(),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: verticalSpace(5),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SubjectItem(
                  subject: state.subjects[index],
                  index: index,
                );
              },
              childCount: state.subjects.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: verticalSpace(5),
        ),
      ],
    );
  }
}
