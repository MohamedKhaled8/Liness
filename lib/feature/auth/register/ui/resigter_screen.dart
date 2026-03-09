import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/function/vibration_method.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/auth/register/logic/cubit/register_cubit.dart';
import 'package:liness/feature/auth/login/widgets/checkbox_and_remmember_me.dart';
import 'package:liness/feature/auth/login/widgets/header_auth_screen_widget.dart';
import 'package:liness/feature/auth/register/widgets/custom_reigster_field_widget.dart';
import 'package:liness/feature/auth/register/widgets/custom_button_manger_register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = context.read<RegisterCubit>();

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
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsManger.mainColor,
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        padding: EdgeInsets.all(20.sp),
                        margin: EdgeInsets.all(5.sp),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const RegisterFieldWidget(),
                            CheckBoxAndRemmemberMeWidget(
                              text: AppLocalizations.of(context)!
                                  .translate('Do you have an account?'),
                              onTap: () {
                                context.pushReplacementNamed(
                                  Routes.loginScreen,
                                );
                              },
                            ),
                            verticalSpace(1),
                            CustomButtonMangeRegisterWidget(
                              text: AppLocalizations.of(context)!
                                  .translate('Register'),
                              onTap: () {
                                handleTapVibration(() {
                                  cubit.register(context);
                                });
                              },
                              onTapp: () {
                                handleTapVibration(() {
                                  context
                                      .pushReplacementNamed(Routes.loginScreen);
                                });
                              },
                              subText: AppLocalizations.of(context)!
                                  .translate('Log In'),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(5),
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
