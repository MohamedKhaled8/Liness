import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/auth/login/logic/cubit/login_cubit.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/widgets/custom_form_field/custom_text_form_field.dart';

class AuthLoginWidget extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const AuthLoginWidget({
    Key? key,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isArabic = ChangeTranslateAndTheme.isArabic;
    var cubit = context.watch<LoginCubit>();

    return AutofillGroup(
      child: Column(
        children: [
          Form(
            key: cubit.key,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: cubit.emialCont,
                  obscureText: false,
                  onChanged: (value) {
                    cubit.validateEmail(value, context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate("Please enter a valid email");
                    }
                    return null;
                  },
                  isNumber: false,
                  iconData:
                      isArabic ? Iconsax.direct_left : Iconsax.direct_right,
                  labelText: AppLocalizations.of(context)!.translate("E-mail"),
                  isSuffixIcon: false,
                  expands: false,
                  autofillHints: const [AutofillHints.email],
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginEmailValidated &&
                        state.emailError != null) {
                      return Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Text(
                          state.emailError!,
                          style: TextStyle(
                              color: ColorsManger.red, fontSize: 14.sp),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                verticalSpace(2),
                CustomTextFormField(
                  isSuffixIcon: true,
                  onPressed: onPasswordVisibilityToggle,
                  controller: cubit.passwordCont,
                  iconData: Iconsax.password_check,
                  labelText:
                      AppLocalizations.of(context)!.translate("Password"),
                  suffixIcon:
                      isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                  expands: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate("Please enter a valid password");
                    }
                    return null;
                  },
                  isNumber: false,
                  obscureText: !isPasswordVisible,
                  autofillHints: const [AutofillHints.password],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
