import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/auth/register/logic/cubit/register_cubit.dart';
import 'package:liness/core/utils/widgets/custom_buttons/custom_button_local.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class CustomButtonMangeRegisterWidget extends StatelessWidget {
  final String text;
  final String subText;
  final void Function()? onTap;
  final void Function()? onTapp;

  const CustomButtonMangeRegisterWidget({
    Key? key,
    required this.text,
    required this.subText,
    this.onTap,
    this.onTapp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    return Column(
      children: [
        BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            bool isLoading = state is RegisterLoading;

            return ButtonLocal(
              colorButtom: ColorsManger.mainBlue,
              width: 300.w,
              isBorder: false,
              onTap: onTap,
              height: stv(
                  context: context,
                  mobile: otv(context: context, portrait: 6.h, landscape: 12.h),
                  tablet: otv(context: context, portrait: 6.h, landscape: 12.h),
                  desktop: 9.h),
              colorText: isDarkMode ? ColorsManger.white : ColorsManger.white,
              size: 17.sp,
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    const LoadingIndicator(),
                    SizedBox(width: 10.w),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: ColorsManger.white,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        verticalSpace(2),
        ButtonLocal(
          colorButtom: ColorsManger.black,
          width: 300.w,
          isBorder: true,
          border: Border.all(color: ColorsManger.mainBlue),
          onTap: onTapp,
          height: stv(
              context: context,
              mobile: otv(context: context, portrait: 6.h, landscape: 12.h),
              tablet: otv(context: context, portrait: 6.h, landscape: 12.h),
              desktop: 9.h),
          colorText: isDarkMode ? ColorsManger.white : ColorsManger.pink,
          size: 17.sp,
          borderRadius: BorderRadius.circular(10),
          child: Text(
            subText,
            style: TextStyle(
              color: ColorsManger.white,
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
