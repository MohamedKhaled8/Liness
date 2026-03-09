import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/function/dialoge_error.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/core/utils/networking/connectivity_network.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/auth/register/data/repository/register_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _key;

  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _phoneCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  final TextEditingController _parentNumberCont = TextEditingController();

  TextEditingController get nameCont => _nameCont;
  TextEditingController get emialCont => _emailCont;
  TextEditingController get phoneCont => _phoneCont;
  TextEditingController get passwordCont => _passwordCont;
  TextEditingController get parentNumberCont => _parentNumberCont;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  String _selectedYear = 'Student Years';
  String _selectedYearArabic = 'سنوات الطالب';

  String get selectedYear => _selectedYear;
  String get selectedYearArabic => _selectedYearArabic;

  List<String> get yearOptions => yearMapping.keys.toList();
  List<String> get yearOptionsArabic => yearMappingArabic.keys.toList();

  var isArabic = ChangeTranslateAndTheme.isArabic;

  String _selectedGovernorate = 'Cairo';
  String get selectedGovernorate => _selectedGovernorate;

  String _selectedGovernorateArabic = 'القاهرة';
  String get selectedGovernorateArabic => _selectedGovernorateArabic;

  final Map<String, String> yearMapping = {
    'Student Years': '0',
    'First Secondary': '1',
    'Second Secondary': '2',
    'Third Secondary': '3',
  };
  final Map<String, String> yearMappingArabic = {
    'سنوات الطالب': '0',
    'الأول الثانوي': '1',
    'الثاني الثانوي': '2',
    'الثالث الثانوي': '3',
  };

  String? emailError;

  // التحقق من البريد الإلكتروني
  void validateEmail(String value, BuildContext context) {
    if (value.contains(' ')) {
      emailError = AppLocalizations.of(context)!
          .translate("Email must not contain spaces");
    } else {
      emailError = null; // لا يوجد خطأ
    }
    emit(RegisterEmailValidated(emailError));
  }

  Future<void> loadSelectedYear() async {
    _selectedYear = getIt<CacheHelper>().getDataString(key: 'selectedYear') ??
        'Student Years';
    _selectedYearArabic =
        getIt<CacheHelper>().getDataString(key: 'selectedYearArabic') ??
            'Student Years Arabic';
    emit(SelectYearsStudent(selectedYear: _selectedYear));
    emit(SelectYearsArabic(selectedYearArabic: _selectedYearArabic));
  }

  Future<void> setSelectedYear(String newValue) async {
    _selectedYear = newValue;
    _selectedYearArabic = newValue;
    await getIt<CacheHelper>()
        .saveData(key: 'selectedYear', value: _selectedYear);
    await getIt<CacheHelper>()
        .saveData(key: 'selectedYearArabic', value: _selectedYearArabic);
    emit(SelectYearsStudent(selectedYear: _selectedYear));
    emit(SelectYearsArabic(selectedYearArabic: _selectedYearArabic));
  }

  final List<String> governorateOptions = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef',
    'Dakahlia',
    'Damietta',
    'Faiyum',
    'Gharbia',
    'Ismailia',
    'Kafr El Sheikh',
    'Minya',
    'Monufia',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sharqia',
    'Sohag',
    'South Sinai',
    'Suez',
  ];

  final List<String> governorateOptionsArabic = [
    'القاهرة',
    'الإسكندرية',
    'الجيزة',
    'أسوان',
    'أسيوط',
    'البحيرة',
    'بني سويف',
    'الدقهلية',
    'دمياط',
    'الفيوم',
    'الغربية',
    'الإسماعيلية',
    'كفر الشيخ',
    'المنيا',
    'المنوفية',
    'شمال سيناء',
    'بورسعيد',
    'القليوبية',
    'قنا',
    'البحر الأحمر',
    'الشرقية',
    'سوهاج',
    'جنوب سيناء',
    'السويس',
  ];

  Future<void> loadSelectedGovernorate() async {
    final cachedGovernorate =
        getIt<CacheHelper>().getDataString(key: 'selectedGovernorate');
    final cachedGovernorateArabic =
        getIt<CacheHelper>().getDataString(key: 'selectedGovernorateArabic');

    if (cachedGovernorate != null &&
        governorateOptions.contains(cachedGovernorate) &&
        cachedGovernorateArabic != null &&
        governorateOptionsArabic.contains(cachedGovernorateArabic)) {
      _selectedGovernorate = cachedGovernorate;
      _selectedGovernorateArabic = cachedGovernorateArabic;
    } else {
      _selectedGovernorate = governorateOptions.first;
      _selectedGovernorateArabic = governorateOptionsArabic.first;
    }
    emit(RegisterGovernorateChanged(selectedGovernorate: _selectedGovernorate));
    emit(RegisterGovernorateArabicChanged(
        selectedGovernorateArabic: _selectedGovernorateArabic));
  }

  Future<void> setSelectedGovernorate(String newValue) async {
    _selectedGovernorate = newValue;
    _selectedGovernorateArabic = newValue;
    await getIt<CacheHelper>()
        .saveData(key: 'selectedGovernorate', value: _selectedGovernorate);
    await getIt<CacheHelper>().saveData(
        key: 'selectedGovernorateArabic', value: _selectedGovernorateArabic);
    emit(RegisterGovernorateChanged(selectedGovernorate: _selectedGovernorate));
    emit(RegisterGovernorateArabicChanged(
        selectedGovernorateArabic: _selectedGovernorateArabic));
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(RegisterPasswordVisibilityToggled(
      _isPasswordVisible,
    ));
  }

  Future<void> retryRegister(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    register(context);
  }

  Future<void> register(BuildContext context) async {
    emit(RegisterLoading());

    if (!formKey.currentState!.validate()) return;
    if (!await getIt<ConnectivityNetwork>().checkConnectivity()) {
      // ignore: use_build_context_synchronously
      await _handleError(context, 'No internet connection.');
      return;
    }

    final year = isArabic
        ? yearMappingArabic[_selectedYearArabic]
        : yearMapping[_selectedYear];
    if (year == null) {
      // ignore: use_build_context_synchronously
      await _handleError(context, 'Invalid year selected');
      return;
    }

    final governorate =
        isArabic ? _selectedGovernorateArabic : _selectedGovernorate;

    final result = await getIt<RegisterRepository>().registerUser(
      name: nameCont.text,
      email: emialCont.text,
      password: passwordCont.text,
      pPhone: parentNumberCont.text,
      phone: phoneCont.text,
      year: year,
      state: governorate,
      // deviceId: await MobileDeviceIdentifier().getDeviceId() ?? '',
    );

    result.fold(
      (errMessage) => _handleRegistrationFailure(context, errMessage),
      (successMessage) async {
        ////
        showLocalizedMessage(
          context,
          successMessage,
          successMessage,
          isError: false,
        );
        await Future.delayed(const Duration(seconds: 2));
        ////
        // ignore: use_build_context_synchronously
        context.pushReplacementNamed(Routes.loginScreen);
        ////
      },
    );
  }

  Future<void> _handleError(BuildContext context, String message) async {
    emit(RegisterFailure(
      erroeMessage: isArabic ? 'خطأ: $message' : message,
    ));
    showMessage(context, isArabic ? 'خطأ: $message' : message, isError: true);
  }

  void _handleRegistrationFailure(BuildContext context, ErrorModel errMessage) {
    final message = isArabic ? errMessage.msgAr : errMessage.msgEn;
    emit(RegisterFailure(erroeMessage: message));
    showMessage(context, message, isError: true);
  }

  // void _handleRegistrationSuccess(
  //     BuildContext context, RegisterUserModel signUpModel) {
  //   CacheHelper.saveData(key: 'userName', value: signUpModel.name);
  //   emit(const RegisterSuccess(message: 'Sign Up Success'));
  //   _clearControllers();

  //   showMessage(
  //     context,
  //     isArabic ? 'تم التسجيل بنجاح!' : 'Registration successful!',
  //     isError: false,
  //   );

  //   Future.delayed(const Duration(seconds: 5), () {
  //     context.pushReplacementNamed(Routes.loginScreen);
  //   });
  // }

  void clearControllers() {
    nameCont.clear();
    emialCont.clear();
    phoneCont.clear();
    passwordCont.clear();
    parentNumberCont.clear();
  }

  @override
  Future<void> close() {
    _disposeControllers();
    return super.close();
  }

  void _disposeControllers() {
    nameCont.dispose();
    emialCont.dispose();
    phoneCont.dispose();
    passwordCont.dispose();
    parentNumberCont.dispose();
  }
}
