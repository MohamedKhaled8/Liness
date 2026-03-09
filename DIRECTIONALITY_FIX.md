# حل مشكلة Directionality في Theme Animation

## المشكلة
كان يحدث خطأ `Directionality` عند استخدام `AdvancedThemeTransition` خارج `MaterialApp`:

```
The ownership chain for the affected widget is: "Stack ← AnimatedBuilder ← BlocListener<AppCubit, AppState> ← BlocBuilder<AppCubit, AppState> ← BlocListener<AppCubit, AppState> ← AdvancedThemeTransition ← BlocListener<AppCubit, AppState> ← BlocBuilder<AppCubit, AppState> ← LayoutBuilder ← ScreenGo ← ⋯"
```

## السبب
- `AdvancedThemeTransition` يستخدم `Stack` widget
- `Stack` يحتاج إلى `Directionality` لتحديد اتجاه النص
- `Directionality` عادة ما يتم توفيره بواسطة `MaterialApp`
- لكن `AdvancedThemeTransition` كان يتم استخدامه قبل `MaterialApp`

## الحل

### 1. إضافة Directionality يدوياً
```dart
return Directionality(
  textDirection: appCubit.currentLocale.languageCode == 'ar' 
      ? TextDirection.rtl 
      : TextDirection.ltr,
  child: AdvancedThemeTransition(
    // باقي الكود
  ),
);
```

### 2. إضافة alignment صريح للـ Stack
```dart
return Stack(
  alignment: Alignment.center, // إضافة هذا السطر
  children: [
    // باقي المحتوى
  ],
);
```

## الملفات المحدثة

### 1. `liness_app.dart`
- إضافة `Directionality` wrapper
- تحديد اتجاه النص بناءً على اللغة الحالية

### 2. `advanced_theme_transition.dart`
- إضافة `alignment: Alignment.center` للـ Stack

### 3. `animated_theme_wrapper.dart`
- إضافة `alignment: Alignment.center` للـ Stack

## النتيجة
- ✅ لا توجد أخطاء Directionality
- ✅ الأنيميشن يعمل بشكل صحيح
- ✅ دعم كامل للغة العربية والإنجليزية
- ✅ اتجاه النص صحيح في جميع الحالات

## ملاحظات إضافية
- هذا الحل يضمن عمل الأنيميشن بشكل صحيح مع جميع اللغات
- `Directionality` يتم تحديده تلقائياً بناءً على اللغة المختارة
- `alignment: Alignment.center` يضمن أن الـ Stack يعمل بشكل صحيح حتى بدون Directionality
