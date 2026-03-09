import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/feature/on_boarding_screen_feature/widgets/page_view_items.dart';
import 'package:liness/feature/on_boarding_screen_feature/logic/cubit/on_barding_cubit.dart';

class BodyOnBoardingScreen extends StatelessWidget {
  const BodyOnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      onPageChanged: (index) => context
          .read<OnBoardingCubit>()
          .isLastPageChange(index, context: context),
      controller: context.read<OnBoardingCubit>().pageController,
      itemCount: context.read<OnBoardingCubit>().items.length,
      itemBuilder: (context, index) {
        return PageViewItems(
          items: context.read<OnBoardingCubit>().items,
          index: index,
        );
      },
    );
  }
}
