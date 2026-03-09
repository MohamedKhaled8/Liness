import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/widgets/custom_shimmer/shimmer_loading.dart';
import 'package:liness/feature/home/widgets/teacher/loaded_teacher_widget.dart';

class HomeTeacherCardView extends StatelessWidget {
  const HomeTeacherCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const ShimmerLoadingHome();
        } else if (state is TeachersLoadedState ||
            context.read<HomeCubit>().teachers.isNotEmpty) {
          return const LoadedTeacherWidget();
        }

        return const AppImageHelper(path: ImageAssetsManger.errornet);
      },
    );
  }
}
