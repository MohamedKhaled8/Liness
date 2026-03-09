import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class AppBarProfileScreenWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return AppBar(
      backgroundColor: ColorsManger.transparent,
      leading: IconButton(
        color: isDarkMode ? ColorsManger.white : ColorsManger.black,
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      elevation: 0.0,
      title: Text(
        AppLocalizations.of(context)!.translate('Profile'),
        style: TextStyle(
          color: isDarkMode ? ColorsManger.white : ColorsManger.black,
        ),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: IconButton(
                onPressed: () {
                  context.pushNamedAndRemoveUntil(Routes.loginScreen,
                      predicate: (context) => false);
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: isDarkMode ? ColorsManger.red : ColorsManger.black,
                ))),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
