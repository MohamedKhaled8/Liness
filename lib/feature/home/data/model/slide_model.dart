import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/auth/login/logic/cubit/login_cubit.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class SlideModel {
 final IconData? icon;
  final String title;
  final void Function(BuildContext)? onTap;

  SlideModel({
     this.icon,
    required this.title,
    this.onTap,
  });
}

List<SlideModel> createSlideMenuItems(BuildContext context) {
  bool isUserLoggedIn = gLoginUserModel != null;
  return [
    SlideModel(
      icon: Iconsax.home,
      title: AppLocalizations.of(context)!.translate('Home'),
      onTap: (BuildContext context) {
        context.pushNamed(Routes.bottomNavigationBarScreen);
      },
    ),
    SlideModel(
      icon: Icons.person,
      title: AppLocalizations.of(context)!.translate('Profile'),
      onTap: (BuildContext context) {
        context.pushNamed(Routes.profileScreen);
      },
    ),
    SlideModel(
      icon: Iconsax.language_circle,
      title: AppLocalizations.of(context)!.translate('Language'),
      onTap: (BuildContext context) {
        context.pushNamed(Routes.languageScreen);
      },
    ),
    SlideModel(
      icon: isUserLoggedIn ? Iconsax.logout : Iconsax.login,
      title: isUserLoggedIn
          ? AppLocalizations.of(context)!.translate('LogOut')
          : AppLocalizations.of(context)!.translate('Login'),
      onTap: (BuildContext context) {
        if (isUserLoggedIn) {
          context.read<LoginCubit>().logOut(context);
        } else {
          context.pushNamed(Routes.loginScreen);
        }
      },
    ),
    SlideModel(
      title: ChangeTranslateAndTheme.isDarkMode(context)
          ? AppLocalizations.of(context)!.translate('Light Mode')
          : AppLocalizations.of(context)!.translate('Dark Mode'),
      onTap: (context) {
        // لن نستخدم onTap هنا لأننا سنستخدم Switch بدلاً من ذلك
      },
    ),
    SlideModel(
      icon: Iconsax.info_circle,
      title: AppLocalizations.of(context)!.translate('Info'),
      onTap: (BuildContext context) {
        context.pushNamed(Routes.infoScreen);
      },
    ),
  ];
}
