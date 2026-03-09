import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liness/core/Router/app_router.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/app_cubit/app_state.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/theme/Theme_data.dart';
import 'package:liness/core/utils/widgets/advanced_theme_transition.dart';
import 'package:screen_go/screen_go.dart';

class Liness extends StatelessWidget {
  final AppRouter appRouter;
  final bool onboarding;

  const Liness({Key? key, required this.appRouter, this.onboarding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenGo(
      materialApp: true,
      builder: (context, deviceInfo) {
        return BlocBuilder<AppCubit, AppState>(
          buildWhen: (previous, current) =>
              current is AppStateChangeTheme ||
              current is AppStateChangeLanguage,
          builder: (context, state) {
            final appCubit = context.read<AppCubit>();

            return Directionality(
              textDirection: appCubit.currentLocale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: AdvancedThemeTransition(
                duration: const Duration(milliseconds: 1000),
                transitionType: TransitionType.ripple,
                child: MaterialApp(
                  locale: appCubit.currentLocale,
                  title: AppLocalizations.of(context)?.translate('Liness') ??
                      "Liness",
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (var local in supportedLocales) {
                      if (deviceLocale != null) {
                        if (deviceLocale.languageCode == local.languageCode) {
                          return deviceLocale;
                        }
                      }
                    }
                    return supportedLocales.first;
                  },
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: appCubit.loadThemeMode(),
                  initialRoute: Routes.splashScreen,
                  onGenerateRoute: appRouter.generateRoute,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
