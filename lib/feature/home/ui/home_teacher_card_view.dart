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
        var cubit = context.read<HomeCubit>();

        // 1. Data comes first! (No flicker)
        if (cubit.teachers.isNotEmpty) {
          return const LoadedTeacherWidget();
        }
        
        // 2. Loading state
        if (state is HomeLoadingState || state is HomeInitial) {
          return const ShimmerLoadingHome();
        }

        // 3. Error state
        return const AppImageHelper(path: ImageAssetsManger.errornet);
      },
    );
  }
}
