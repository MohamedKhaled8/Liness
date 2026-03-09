import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:liness/core/utils/function/get_finction+and_labuls.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/botton_nav_bar_feature/logic/cubit/bottom_navigation_bar_cubit.dart';

class CustommButtonVanigationBarWidget extends StatelessWidget {
  const CustommButtonVanigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
      builder: (context, state) {
        var cubit = context.read<BottomNavigationBarCubit>();
        int selectedIndex =
            state is BottomNavigationBarUpdated ? state.index : 0;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          margin: EdgeInsets.only(
            bottom: 2.h,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17.sp),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor:
                    isDarkMode ? ColorsManger.white : ColorsManger.mainColor,
                indicatorColor: ColorsManger.mainBlue,
                // ignore: deprecated_member_use
                labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                  (states) {
                    // ignore: deprecated_member_use
                    if (states.contains(MaterialState.selected)) {
                      return TextStyle(
                          color: isDarkMode
                              ? ColorsManger.black
                              : ColorsManger.white,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold);
                    }
                    return const TextStyle(color: ColorsManger.gray);
                  },
                ),
              ),
              child: NavigationBar(
                elevation: 0,
                selectedIndex: selectedIndex,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                height: stv(
                    context: context,
                    mobile: 34.sp,
                    tablet: 30.sp,
                    desktop: 30.sp),
                onDestinationSelected: (index) => cubit.setSelectIndex(index),
                destinations: List.generate(
                  5,
                  (index) {
                    return NavigationDestination(
                      icon: Icon(
                        getIcon(index),
                        color: selectedIndex == index
                            ? isDarkMode
                                ? ColorsManger.white
                                : ColorsManger.white
                            : ColorsManger.mainBlue,
                      ),
                      label: getLabel(index, context),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
