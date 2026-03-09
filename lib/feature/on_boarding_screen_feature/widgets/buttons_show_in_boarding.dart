import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/widgets/custom_buttons/custom_button_local.dart';
import 'package:liness/feature/on_boarding_screen_feature/logic/cubit/on_barding_cubit.dart';
import 'package:liness/feature/on_boarding_screen_feature/widgets/custom_steps_container.dart';

class ButtonsShowOnBarding extends StatelessWidget {
  const ButtonsShowOnBarding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // var cubit = context.read<OnBoardingCubit>();
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    return BlocBuilder<OnBoardingCubit, OnBardingState>(
      builder: (context, state) {
        return Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.sp),
                topRight: Radius.circular(15.sp)),
            color: isDarkMode
                ? const Color.fromARGB(255, 0, 41, 63)
                : ColorsManger.mainColor,
          ),
          child: context.read<OnBoardingCubit>().isLastPage
              ? ButtonLocal(
                  onTap: () {
                    context
                        .read<OnBoardingCubit>()
                        .saveSectionOnBarding(context);
                  },
                  colorButtom: ColorsManger.primaryColor,
                  height: stv(
                      context: context,
                      mobile: 6.h,
                      tablet: 6.h,
                      desktop: 10.h),
                  width: 85.w,
                  colorText: ColorsManger.white,
                  size: 17.sp,
                  borderRadius: BorderRadius.circular(10.sp),
                  isBorder: false,
                  child: Text(
                    AppLocalizations.of(context)!.translate('Get Start'),
                    style: TextStyle(
                      color: ColorsManger.white,
                      fontSize: 18.sp,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<OnBoardingCubit>()
                            .jumpToPackage(context: context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('Skip'),
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: isDarkMode
                                ? ColorsManger.white
                                : ColorsManger.primaryColor),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SmoothPageIndicator(
                        controller:
                            context.read<OnBoardingCubit>().pageController,
                        count: context.read<OnBoardingCubit>().items.length,
                        onDotClicked: (index) {
                          context.read<OnBoardingCubit>().animateToPage(index);
                        },
                        effect: WormEffect(
                          dotHeight: 1.5.h,
                          dotWidth: 3.w,
                          activeDotColor: ColorsManger.primaryColor,
                          spacing: 5.0,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                    StepsContainer(
                      page: context.read<OnBoardingCubit>().currentIndex,
                      list: context.read<OnBoardingCubit>().items,
                      controller:
                          context.read<OnBoardingCubit>().pageController,
                      showAnimatedContainerCallBack: (value) {
                        // cubit.nextToPage(context);
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }
}
