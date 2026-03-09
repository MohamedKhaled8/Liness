import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

class ManinMethods {
  //متنساش تترجم الله يكرمك مش ناقصه رفض

  static Future<bool> checkDebugMode() async {
    const platform =
        MethodChannel('com.liness.linessEducationsApp/developer_settings');
    try {
      final isEnabled =
          await platform.invokeMethod<bool>('isDeveloperModeEnabled');
      return isEnabled ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // بدء تحديث مرن مع فرض الإكمال
        await _forceFlexibleUpdate();
      }
    } catch (e) {
      // يمكن إضافة معالجة الأخطاء هنا
    }
  }

  static Future<void> _forceFlexibleUpdate() async {
    bool updateCompleted = false;

    while (!updateCompleted) {
      try {
        // بدء التحديث المرن
        await InAppUpdate.startFlexibleUpdate();
        // تطبيق التحديث بمجرد اكتماله
        await InAppUpdate.completeFlexibleUpdate();
        updateCompleted = true; // إذا تم تطبيق التحديث بنجاح
        // ignore: empty_catches
      } catch (e) {}
    }
  }
}
