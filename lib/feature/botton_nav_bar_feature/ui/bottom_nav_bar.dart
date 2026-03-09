import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:liness/core/utils/function/get_finction+and_labuls.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/botton_nav_bar_feature/logic/cubit/bottom_navigation_bar_cubit.dart';
import 'package:liness/core/utils/widgets/mouse_tracker_wrapper.dart';

class ButtomNavigationBar extends StatelessWidget {
  const ButtomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
      builder: (context, state) {
        var cubit = context.read<BottomNavigationBarCubit>();
        int selectedIndex =
            state is BottomNavigationBarUpdated ? state.index : 0;

        return Scaffold(
          extendBody: true,
          body: SafeNavigationWrapper(
            currentIndex: selectedIndex,
            screens: cubit.screen,
            onIndexChanged: (index) {
              cubit.setSelectIndex(index);
            },
            child: PopScope(
              canPop: false,
              child: cubit.screen[selectedIndex],
            ),
          ),
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.ltr,
            child: MouseTrackerWrapper(
              child: CurvedNavigationBar(
                height: stv(
                    context: context,
                    mobile: 30.sp,
                    tablet: 25.sp,
                    desktop: 21.sp),
                color: isDarkMode ? ColorsManger.white : ColorsManger.mainColor,
                buttonBackgroundColor:
                    isDarkMode ? ColorsManger.white : ColorsManger.mainBlue,
                backgroundColor: ColorsManger.transparent,
                index: selectedIndex,
                animationDuration: const Duration(milliseconds: 300),
                items: List.generate(
                  5,
                  (index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getIcon(index),
                            color: isDarkMode
                                ? selectedIndex == index
                                    ? ColorsManger.mainBlue
                                    : ColorsManger.mainBlue
                                : selectedIndex == index
                                    ? ColorsManger.white
                                    : ColorsManger.white,
                            size: stv(
                                context: context,
                                mobile: 20.sp,
                                tablet: 16.5.sp,
                                desktop: 12.sp),
                          ),
                          Text(
                            getLabel(index, context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: stv(
                                  context: context,
                                  mobile: 12.sp,
                                  tablet: 8.sp,
                                  desktop: 7.sp),
                              color: isDarkMode
                                  ? ColorsManger.mainBlue
                                  : ColorsManger.white,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: (index) {
                  cubit.setSelectIndex(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
