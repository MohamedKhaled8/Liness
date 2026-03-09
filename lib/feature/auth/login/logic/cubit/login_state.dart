part of 'login_cubit.dart';

sealed class LoginState  {
  const LoginState();


}

final class LoginInitial extends LoginState {}

final class LogInSuccess extends LoginState {
   final String message;
  const LogInSuccess({
    required this.message,
  });
}
class LoginEmailValidated extends LoginState {
  final String? emailError;

  const LoginEmailValidated(this.emailError);
}

final class LogInLoading extends LoginState {}

final class LogInFailed extends LoginState {
  final String errorMessage;
  const LogInFailed({required this.errorMessage});
}


final class LoginPasswordVisibilityToggled extends LoginState {
  final bool isPasswordVisible;
  const LoginPasswordVisibilityToggled(this.isPasswordVisible);

}
class LoggedOutState extends LoginState {}