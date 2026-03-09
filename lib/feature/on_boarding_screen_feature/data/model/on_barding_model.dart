import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class OnBardingItemModel {
  final String image;
  final String title;
  final String description;
  OnBardingItemModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBardingItemModel> getOnBardingItems() {
  bool isArabic = ChangeTranslateAndTheme.isArabic;

  return [
    OnBardingItemModel(
      image: ImageAssetsManger.onboardingone,
      title: isArabic ? "مرحبا" : "Welcome",
      description: isArabic
          ? "منصة خطوط للتسجيل المسبق لتسهيل الاختبارات عبر الإنترنت."
          : "Lines pre-registration platform for easy online testing.",
    ),
    OnBardingItemModel(
      image: ImageAssetsManger.onboardingtwo,
      title: isArabic ? "أهلاً بك" : "Welcome",
      description: isArabic
          ? "أدوات مستمرة وتحديث محتوى تعليمي مباشرة."
          : "Continuing tools and updating educational content directly.",
    ),
    OnBardingItemModel(
      image: ImageAssetsManger.json3,
      title: isArabic ? "مرحباً بك" : "Welcome",
      description: isArabic
          ? "ضمان بنك أسئلة متنوع يمكن استخدامه في إعداد الاختبارات والتقييمات."
          : "Ensuring a diverse question bank that can be used in preparing tests and assessments.",
    ),
    OnBardingItemModel(
      image: ImageAssetsManger.json4,
      title: isArabic ? "أهلاً وسهلاً" : "Welcome",
      description: isArabic
          ? "واجهة تدعم التعلم وسهولة الوصول إلى المحتوى في أي وقت."
          : "The interface supports learning yet easy to access the content at any time.",
    ),
  ];
}
