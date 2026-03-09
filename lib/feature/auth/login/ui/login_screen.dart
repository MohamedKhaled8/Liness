import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/function/dialoge_error.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:screen_go/functions/screen_type_value_func.dart';
import 'package:liness/core/utils/function/vibration_method.dart';
import 'package:liness/feature/auth/login/widgets/login_widget.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/auth/login/logic/cubit/login_cubit.dart';
import 'package:liness/feature/auth/login/widgets/header_auth_screen_widget.dart';
import 'package:liness/feature/auth/login/widgets/button_login_and_create_account_widgetd.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LogInSuccess) {
            showMessage(context, state.message, isError: false);
          } else if (state is LogInFailed) {}
        },
        builder: (context, state) {
          var cubit = context.read<LoginCubit>();
          bool isPasswordVisible = state is LoginPasswordVisibilityToggled
              ? state.isPasswordVisible
              : false;

          return Scaffold(
            body: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManger.mainColor,
                    ColorsManger.primaryColor,
                  ],
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeaderAuthScreenWidget(),
                      SizedBox(
                        height: stv(
                            context: context,
                            mobile: 10.h,
                            tablet: 10.h,
                            desktop: 0.h),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorsManger.mainColor,
                            borderRadius: BorderRadius.circular(15.sp)),
                        padding: EdgeInsets.all(20.sp),
                        margin: EdgeInsets.all(5.sp),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AuthLoginWidget(
                              isPasswordVisible: isPasswordVisible,
                              onPasswordVisibilityToggle: () {
                                cubit.togglePasswordVisibility();
                              },
                            ),
                            // verticalSpace(1),
                            // CheckBoxAndRemmemberMeWidget(
                            //   text: AppLocalizations.of(context)!
                            //       .translate("Forgot Password ?"),
                            //   onTap: () {},
                            // ),
                            verticalSpace(10),
                            ButtonMangeAuthAccountWidget(
                              text: AppLocalizations.of(context)!
                                  .translate("Log In"),
                              onTap: () {
                                handleTapVibration(() {
                                  cubit.signIn(context); // استدعاء تسجيل الدخول
                                });
                              },
                              onTapp: () {
                                handleTapVibration(() {
                                  context.pushReplacementNamed(Routes
                                      .registerScreen); // الانتقال إلى شاشة التسجيل
                                });
                              },
                              subText: AppLocalizations.of(context)!
                                  .translate("Create Account"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
