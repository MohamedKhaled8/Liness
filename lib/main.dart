import 'dart:ui';

import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:liness/core/Router/app_router.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/helper/main_methods/main_method.dart';
import 'package:liness/liness_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ////
  setupGetIt();
  ////
  ConnectivityService.startConnectionNotifier(
    connectedToastMessage: "Connected!",
    disconnectedToastMessage: "No Internet Connection.",
    showToasts: true, // Show toast notifications for connectivity changes
  );
  ////
  await getIt<CacheHelper>().init();
  ////
  // Initialize InAppWebView platform with error handling
  try {
    await InAppWebViewPlatform.instance;
  } catch (e) {
    debugPrint('InAppWebView initialization error: $e');
  }
  ////
  final onboarding = getIt<CacheHelper>().getData(key: "onboarding") ?? false;
  ////
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  ////
  bool isDebugModeEnabled = await ManinMethods.checkDebugMode();
  ////
  await ManinMethods.checkForUpdate();

  // await ManinMethods.checkDeviceSecurity();
  runApp(BlocProvider(
    create: (context) => getIt<AppCubit>(),
    child: Liness(appRouter: AppRouter(), onboarding: onboarding),
  ));
}

// class CrashTestPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Crashlytics Test')),
//       body: Center(
//         child:ElevatedButton(
//   onPressed: () {
//     try {
//       // كود فيه خطأ فعلي
//       throw Exception("🔥 حدث خطأ فعلي في زر الاختبار - Crash test");
//     } catch (error, stack) {
//       FirebaseCrashlytics.instance.recordError(
//         error,
//         stack,
//         reason: '📍 Crash test button - تم الضغط على زر الكراش',
//         fatal: true,
//       );
//     }
//   },
//   child: Text("تجربة Crash حقيقي برسالة"),
// )

//       ),
//     );
//   }
// }
