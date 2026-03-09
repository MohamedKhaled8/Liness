import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/on_boarding_screen_feature/data/model/on_barding_model.dart';
import 'package:liness/feature/on_boarding_screen_feature/logic/cubit/on_barding_cubit.dart';

class StepsContainer extends StatelessWidget {
  const StepsContainer({
    Key? key,
    required this.page,
    required this.list,
    required this.controller,
    required this.showAnimatedContainerCallBack,
  }) : super(key: key);

  final int page;
  final List<OnBardingItemModel> list;
  final PageController controller;
  final Function showAnimatedContainerCallBack;

  @override
  Widget build(BuildContext context) {
    // var cubit = context.watch<OnBoardingCubit>();
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return SizedBox(
      width: 4.5 * 10.0,
      height: 4.5 * 10.0,
      child: Stack(
        children: [
          SizedBox(
            width: 4.5 * 10.0,
            height: 4.5 * 10.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isDarkMode ? ColorsManger.white : ColorsManger.primaryColor),
              value: context.read<OnBoardingCubit>().progress,
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                context.read<OnBoardingCubit>().nextToPage(context);
              },
              child: Container(
                width: 3.5 * 10.0,
                height: 3.5 * 10.0,
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(100.0.sp)),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: ColorsManger.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
