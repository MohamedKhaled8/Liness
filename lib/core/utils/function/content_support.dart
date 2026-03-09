import 'package:url_launcher/url_launcher.dart';

Future<void> contactSupport(String phoneNumber) async {
  final whatsappUrl = "https://wa.me/$phoneNumber";

  try {
    // التحقق من إمكانية فتح الرابط
    // ignore: deprecated_member_use
    if (await canLaunch(whatsappUrl)) {
      // ignore: deprecated_member_use
      await launch(whatsappUrl); // فتح الرابط
    } else {
      throw 'Cannot open WhatsApp';
    }
  // ignore: empty_catches
  } catch (e) {
  }
}