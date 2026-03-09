import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/subject_feature/logic/cubit/subject_cubit.dart';
import 'package:liness/feature/subject_feature/data/repository/subject_repository.dart';
import 'package:liness/feature/subject_feature/widgets/custom_loaded_subject_courses_widget.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: BlocProvider(
        create: (context) => SubjectCubit(
          subjectRepository: getIt<SubjectRepository>(),
        )..getSubjects(context: context),
        child: Scaffold(
          body: BlocConsumer<SubjectCubit, SubjectState>(
            listener: (context, state) async {
              // var cubit = context.read<SubjectCubit>();
            },
            builder: (context, state) {
              if (state is SubjectLoading) {
                return const Center(
                  child: LoadingIndicator(),
                );
              } else if (state is SubjectLoaded) {
                return CustomLoadedSubjectCoursesWidget(
                  state: state,
                );
              } else if (state is SubjectInitial || state is SubjectError) {
                return const Center(
                    child: AppImageHelper(path: ImageAssetsManger.errornet));
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
      ),
    );
  }
}
