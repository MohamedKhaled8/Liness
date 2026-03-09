import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/language/widget/custom_dotted_divider.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/language/widget/custom_langiage_selection_row.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ColorsManger.transparent,
          title:
              Text(AppLocalizations.of(context)!.translate("Select Language")),
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDarkMode ? ColorsManger.white : ColorsManger.black,
              )),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0.sp),
            child: Column(
              children: [
                CustomLanguageSelectionRow(
                  flag: '🇸🇦',
                  languageName:
                      AppLocalizations.of(context)!.translate('Arabic'),
                  value: getIt<CacheHelper>().getDataString(key: 'lang') == 'ar'
                      ? "language"
                      : '',
                  groupValue: context.read<AppCubit>().groubLang,
                  onChanged: (value) {
                    context.read<AppCubit>().changeLanguage('ar');
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: const CustomDottedDivider(),
                ),
                CustomLanguageSelectionRow(
                  flag: '🇬🇧',
                  languageName:
                      AppLocalizations.of(context)!.translate('English'),
                  value: getIt<CacheHelper>().getDataString(key: 'lang') == 'en'
                      ? 'language'
                      : '',
                  groupValue: context.read<AppCubit>().groubLang,
                  onChanged: (value) {
                    context.read<AppCubit>().changeLanguage('en');
                  },
                ),
              ],
            )),
      ),
    );
  }
}
