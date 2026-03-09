# Theme Animation System

نظام أنيميشن متقدم لتغيير الثيمات في تطبيق Liness مع تأثيرات بصرية جميلة.

## المميزات

### 🎨 أنواع الأنيميشن المتاحة

1. **Ripple Effect** - تأثير التموج الدائري
2. **Wave Effect** - تأثير الموجة
3. **Spiral Effect** - تأثير الحلزون
4. **Morphing Effect** - تأثير التحول الهندسي
5. **Explosion Effect** - تأثير الانفجار مع الجسيمات

### ⚡ سرعات الأنيميشن

- **500ms** - سريع ومتجاوب
- **800ms** - متوازن وسلس
- **1000ms** - سلس ومتوازن (افتراضي)
- **1200ms** - بطيء ودرامي
- **1500ms** - بطيء جداً ودرامي

## كيفية الاستخدام

### 1. الاستخدام الأساسي

```dart
import 'package:liness/core/utils/widgets/advanced_theme_transition.dart';

AdvancedThemeTransition(
  duration: const Duration(milliseconds: 1000),
  transitionType: TransitionType.ripple,
  child: MaterialApp(
    // تطبيقك هنا
  ),
)
```

### 2. تخصيص الأنيميشن

```dart
AdvancedThemeTransition(
  duration: const Duration(milliseconds: 800),
  transitionType: TransitionType.wave,
  child: YourWidget(),
)
```

### 3. استخدام Theme Toggle المخصص

```dart
import 'package:liness/core/utils/widgets/custom_theme_toggle.dart';

// التبديل الأساسي
CustomThemeToggle()

// مع تخصيص الألوان والحجم
CustomThemeToggle(
  width: 60,
  height: 30,
  activeColor: ColorsManger.mainBlue,
  inactiveColor: ColorsManger.white,
  thumbColor: Colors.white,
  animationDuration: const Duration(milliseconds: 300),
)

// التبديل البسيط الدائري
SimpleThemeToggle(
  size: 50,
  activeColor: ColorsManger.mainBlue,
  inactiveColor: ColorsManger.white,
)
```

### 4. شاشة إعدادات الأنيميشن

```dart
import 'package:liness/core/utils/widgets/theme_animation_settings.dart';

// شاشة إعدادات كاملة
ThemeAnimationSettings()

// تبديل سريع مع أنيميشن
QuickThemeToggle(
  transitionType: TransitionType.ripple,
  duration: const Duration(milliseconds: 800),
)
```

## الملفات المضافة

### 1. `advanced_theme_transition.dart`
- الأنيميشن المتقدم الرئيسي
- 5 أنواع مختلفة من التأثيرات
- تخصيص كامل للسرعة والمنحنى

### 2. `custom_theme_toggle.dart`
- تبديل الثيم المخصص
- أنيميشن سلس للتبديل
- تصميم قابل للتخصيص

### 3. `theme_animation_settings.dart`
- شاشة إعدادات الأنيميشن
- معاينة مباشرة للتأثيرات
- تخصيص السرعة والنوع

### 4. `theme_animation_demo.dart`
- شاشة عرض الأنيميشن
- تجربة جميع التأثيرات
- أمثلة عملية للاستخدام

### 5. `theme_toggle_examples.dart`
- أمثلة متنوعة للاستخدام
- حالات استخدام مختلفة
- كود جاهز للنسخ

## التكامل مع التطبيق

تم دمج النظام في الملف الرئيسي `liness_app.dart`:

```dart
return AdvancedThemeTransition(
  duration: const Duration(milliseconds: 1000),
  transitionType: TransitionType.ripple,
  child: MaterialApp(
    // باقي إعدادات التطبيق
  ),
);
```

## التخصيص المتقدم

### إضافة نوع أنيميشن جديد

1. أضف النوع الجديد إلى `TransitionType` enum
2. أنشئ `CustomPainter` جديد في `advanced_theme_transition.dart`
3. أضف الحالة في `_getTransitionPainter()`

### تخصيص الألوان

```dart
// في CustomPainter
paint.color = (isDarkMode 
  ? ColorsManger.mainBlue 
  : ColorsManger.primaryColor).withOpacity(opacity);
```

### تخصيص السرعة

```dart
// في AnimationController
AnimationController(
  duration: const Duration(milliseconds: 1200), // مدة مخصصة
  vsync: this,
)
```

## الأداء

- الأنيميشن محسن للأداء
- استخدام `CustomPainter` للرسم المباشر
- إدارة ذكية لدورة حياة الأنيميشن
- تنظيف تلقائي للموارد

## المتطلبات

- Flutter SDK 3.0+
- flutter_bloc للتحكم في الحالة
- dart:math للعمليات الرياضية

## الدعم

للحصول على المساعدة أو الإبلاغ عن مشاكل، يرجى مراجعة:
- ملفات الأمثلة في `theme_toggle_examples.dart`
- شاشة العرض في `theme_animation_demo.dart`
- شاشة الإعدادات في `theme_animation_settings.dart`

---

**ملاحظة**: هذا النظام يحل محل `AnimatedTheme` القديم ويوفر تحكم أكبر وأداء أفضل مع تأثيرات بصرية أكثر جاذبية.
