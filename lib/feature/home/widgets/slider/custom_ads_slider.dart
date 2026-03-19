import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/home/widgets/slider/custom_image_loaded_widget.dart';
import 'package:liness/feature/home/widgets/slider/custom_simmer_image_loaded.dart';

class CardAdsSlider extends StatelessWidget {
  const CardAdsSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      var cubit = context.read<HomeCubit>();

      // 1. Data first
      if (cubit.images.isNotEmpty) {
        return CustomImageLoadedWidget(
          images: cubit.images,
        );
      }

      // 2. Loading state
      if (state is HomeLoadingState || state is HomeInitial) {
        return const CustomShimmerImageWidget();
      }

      // 3. Error state
      return const AppImageHelper(path: ImageAssetsManger.errornet);
    });
  }
}
