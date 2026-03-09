import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/home/widgets/session/loaded_session_resent_widget.dart';
import 'package:liness/feature/home/widgets/session/custom_simmer_session_recent_widget.dart';

class HomeTeacherRecentSessionView extends StatelessWidget {
  final List<Color> colorsList;

  const HomeTeacherRecentSessionView({
    Key? key,
    required this.colorsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return CustomShimmerSessionRecentWidget(screenWidth: screenWidth);
        } else if (state is HomeErrorState) {
          return const AppImageHelper(path: ImageAssetsManger.errornet);
        } else if (state is SessionResentLoadedState ||
            context.read<HomeCubit>().recentSessions.isNotEmpty) {
          return LoadedSessionResentWidget(
            screenWidth: screenWidth,
            colorsList: colorsList,
          );
        }
        return const AppImageHelper(path: ImageAssetsManger.errornet ,);
      },
    );
  }
}
