import 'package:liness/core/Router/export_routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/core/utils/helper/user_data/caching_user_data.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  GlobalKey<FormState> get key => _key;

  final TextEditingController _emialCont = TextEditingController();
  TextEditingController get emialCont => _emialCont;

  final TextEditingController _passwordCont = TextEditingController();
  TextEditingController get passwordCont => _passwordCont;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  String? emailError;

  // التحقق من البريد الإلكتروني
  void validateEmail(String value, BuildContext context) {
    if (value.contains(' ')) {
      emailError = AppLocalizations.of(context)!
          .translate("Email must not contain spaces");
    } else {
      emailError = null; // لا يوجد خطأ
    }
    emit(LoginEmailValidated(emailError));
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPasswordVisibilityToggled(_isPasswordVisible));
  }

  Future<void> signIn(BuildContext context) async {
    if (!key.currentState!.validate()) return;

    if (!await getIt<ConnectivityNetwork>().checkConnectivity()) {
      emit(const LogInFailed(errorMessage: 'No internet connection.'));
      return;
    }

    // ignore: use_build_context_synchronously
    await _attemptSignIn(context);
  }

  Future<void> _attemptSignIn(BuildContext context) async {
    emit(LogInLoading());

    // String deviceId = await DeviceIdHelper.getDeviceId();

    // استدعاء واجهة تسجيل الدخول
    final response = await getIt<LoginRepository>().signIn(
      email: emialCont.text,
      password: passwordCont.text,
      // deviceId: deviceId,
    );

    response.fold(
      (errMessage) {
        if (ChangeTranslateAndTheme.isArabic) {
          emit(LogInFailed(errorMessage: errMessage.msgAr));
        } else {
          emit(LogInFailed(errorMessage: errMessage.msgEn));
        }
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );
      },
      (userLoginModel) async {
        ////
        gLoginUserModel = userLoginModel;

        ///
        CahcingUserData.cachingLoginUserModel(
          userLoginModel: userLoginModel,
        );
        ////
        CahcingUserData.cachingUserTokens(
          userLoginModel: userLoginModel,
        );
        ////
        emit(const LogInSuccess(message: ''));
        ////
        _navigateToHome(context);
      },
    );
  }

  void _navigateToHome(BuildContext context) {
    context.pushNamedAndRemoveUntil(
      Routes.bottomNavigationBarScreen,
      predicate: (Route<dynamic> route) => false,
    );
  }

  Future<void> logOut(BuildContext context) async {
    await getIt<SecureStorageHelper>().clearData();
    await getIt<CacheHelper>().clearData();
    gLoginUserModel = null;
    emit(LoginInitial());
    // ignore: use_build_context_synchronously
    context.pushReplacementNamed(Routes.loginScreen);
  }

  @override
  Future<void> close() {
    _emialCont.dispose();
    _passwordCont.dispose();
    return super.close();
  }
}
