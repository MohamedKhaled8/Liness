import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/auth/register/logic/cubit/register_cubit.dart';
import 'package:liness/feature/auth/register/widgets/custom_drob_down_widget.dart';
import 'package:liness/core/utils/widgets/custom_form_field/custom_text_form_field.dart';

class RegisterFieldWidget extends StatelessWidget {
  const RegisterFieldWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.watch<RegisterCubit>();
    var isArabic = ChangeTranslateAndTheme.isArabic;

    return Column(
      children: [
        Form(
          key: cubit.formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: cubit.nameCont,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate("Please enter a valid Name");
                  }
                  return null;
                },
                isNumber: false,
                iconData: isArabic ? Iconsax.direct_left : Iconsax.direct_right,
                labelText: AppLocalizations.of(context)!.translate("Name"),
                isSuffixIcon: false,
                expands: false,
              ),
              verticalSpace(2),
              CustomTextFormField(
                controller: cubit.emialCont,
                onChanged: (value) {
                  cubit.validateEmail(
                      value, context); // التحقق من البريد الإلكتروني مباشرة
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                obscureText: false,
                iconData: Icons.email_outlined,
                labelText: "E-mail",
                isSuffixIcon: false,
                isNumber: false,
                expands: false,
              ),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterEmailValidated &&
                      state.emailError != null) {
                    return Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(
                        state.emailError!,
                        style:
                            TextStyle(color: ColorsManger.red, fontSize: 14.sp),
                      ),
                    );
                  }
                  // إذا لم يكن هناك خطأ
                  return const SizedBox.shrink();
                },
              ),
              verticalSpace(2),
              CustomTextFormField(
                controller: cubit.phoneCont,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate("Please enter a valid Phone");
                  }
                  return null;
                },
                isNumber: true,
                iconData: isArabic ? Iconsax.call_received : Iconsax.call,
                labelText:
                    AppLocalizations.of(context)!.translate("Phone Number"),
                isSuffixIcon: false,
                expands: false,
              ),
              verticalSpace(2),
              CustomTextFormField(
                isSuffixIcon: true,
                onPressed: () {},
                controller: cubit.parentNumberCont,
                iconData: isArabic ? Iconsax.call_received : Iconsax.call,
                labelText:
                    AppLocalizations.of(context)!.translate("Parent number"),
                suffixIcon: null,
                expands: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate("Please enter a valid Parent number");
                  }
                  return null;
                },
                isNumber: true,
                obscureText: false,
              ),
              verticalSpace(2),
              CustomDrobDownWidgets(
                value: isArabic ? cubit.selectedYearArabic : cubit.selectedYear,
                labelText: isArabic
                    ? AppLocalizations.of(context)!.translate("Academic year")
                    : AppLocalizations.of(context)!.translate("Select Year"),
                choosedOptions:
                    isArabic ? cubit.yearOptionsArabic : cubit.yearOptions,
                onChanged: (String? newValue) {
                  cubit.setSelectedYear(newValue!);
                },
                icon: Iconsax.calendar,
              ),
              verticalSpace(2),
              CustomDrobDownWidgets(
                value: isArabic
                    ? cubit.selectedGovernorateArabic
                    : cubit.selectedGovernorate,
                labelText: AppLocalizations.of(context)!
                    .translate("Select Governorate"),
                choosedOptions: isArabic
                    ? cubit.governorateOptionsArabic
                    : cubit.governorateOptions,
                onChanged: (String? newValue) {
                  if (isArabic) {
                    cubit.setSelectedGovernorate(newValue!);
                  } else {
                    cubit.setSelectedGovernorate(newValue!);
                  }
                },
                icon: isArabic ? Iconsax.flag_24 : Iconsax.flag,
              ),
              verticalSpace(2),
              CustomTextFormField(
                isSuffixIcon: true,
                onPressed: () {
                  cubit.togglePasswordVisibility();
                },
                controller: cubit.passwordCont,
                iconData: Iconsax.password_check,
                labelText: AppLocalizations.of(context)!.translate("Password"),
                suffixIcon:
                    cubit.isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                expands: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate("Please enter a valid password");
                  }
                  return null;
                },
                isNumber: false,
                obscureText: !cubit.isPasswordVisible,
              ),
              verticalSpace(2),
            ],
          ),
        ),
      ],
    );
  }
}
