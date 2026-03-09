import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/function/content_support.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/screen_go.dart';

class DebugWarningPage extends StatelessWidget {
  const DebugWarningPage({super.key});

  Future<void> _openDeveloperSettings() async {
    const platform = MethodChannel('com.liness.linessEducationsApp/developer_settings');
    try {
      await platform.invokeMethod('openDeveloperSettings');
    } catch (e) {
      debugPrint('Failed to open developer settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ChangeTranslateAndTheme.isArabic;
    return ScreenGo(
      materialApp: true,
      builder: (context, deviceInfo) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: ColorsManger.mainColor,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 45.sp,
                        color: ColorsManger.orange,
                      ),
                      verticalSpace(3),
                      Text(
                        isArabic ? "تم اكتشاف وضع التصحيح" : "Debug Mode Detected",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManger.white,
                        ),
                      ),
                      verticalSpace(3),
                      Text(
                        isArabic
                            ? "ليس المقصود من هذا التطبيق أن يعمل في وضع التصحيح. يرجى إيقاف تشغيل خيارات المطور (تصحيح أخطاء USB) وإعادة تشغيل التطبيق للحصول على تجربة أفضل وأكثر أمانًا."
                            : "This application is not intended to run in Debug Mode. Please turn off Developer Options (USB Debugging) and restart the app for a better and more secure experience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp, color: ColorsManger.white),
                      ),
                      verticalSpace(3),
                      ElevatedButton.icon(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        icon: const Icon(Icons.exit_to_app, color: ColorsManger.white),
                        label: Text(
                          isArabic ? "الخروج من التطبيق" : "Exit App",
                          style: const TextStyle(color: ColorsManger.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.5.h),
                          textStyle: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                      verticalSpace(3),
                      ElevatedButton.icon(
                        onPressed: _openDeveloperSettings,
                        icon: const Icon(Icons.settings, color: ColorsManger.white),
                        label: Text(
                          isArabic ? "انتقل إلى إعدادات المطور" : "Go to Developer Settings",
                          style: const TextStyle(color: ColorsManger.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManger.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                          textStyle: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                      verticalSpace(3),
                      Text(
                        isArabic ? "لماذا هذا التقييد؟" : 'Why this restriction?',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManger.white,
                        ),
                      ),
                      verticalSpace(3),
                      Text(
                        isArabic
                            ? "قد يؤدي تشغيل التطبيق في وضع التصحيح إلى كشف معلومات حساسة أو التسبب في سلوك غير متوقع. وهذا يضمن تجربة مستخدم آمنة ومستقرة."
                            : "Running the app in Debug Mode might expose sensitive information or cause unexpected behavior. This ensures a secure and stable user experience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp, color: ColorsManger.white),
                      ),
                      verticalSpace(3),
                      ElevatedButton.icon(
                        onPressed: () {
                          contactSupport("+201026331866");
                        },
                        icon: const Icon(Icons.chat, color: ColorsManger.white),
                        label: Text(
                          isArabic ? "التواصل مع الدعم الفني" : "Contact Technical Support",
                          style: TextStyle(color: ColorsManger.white, fontSize: 18.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManger.green,
                          padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
