part of 'register_cubit.dart';

sealed class RegisterState {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {}

class RegisterEmailValidated extends RegisterState {
  final String? emailError;

  RegisterEmailValidated(this.emailError);
}

final class RegisterPasswordVisibilityToggled extends RegisterState {
  final bool isPasswordVisible;

  const RegisterPasswordVisibilityToggled(
    this.isPasswordVisible,
  );
}

final class RegisterConfirmPasswordVisibilityToggled extends RegisterState {
  final bool isConfirmPasswordVisible;

  const RegisterConfirmPasswordVisibilityToggled(
    this.isConfirmPasswordVisible,
  );
}

final class SelectYearsStudent extends RegisterState {
  final String selectedYear;

  const SelectYearsStudent({required this.selectedYear});
}

final class SelectYearsArabic extends RegisterState {
  final String selectedYearArabic;

  const SelectYearsArabic({required this.selectedYearArabic});
}

class RegisterSuccess extends RegisterState {
  final String message;
  const RegisterSuccess({
    required this.message,
  });
}

class RegisterLoading extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String erroeMessage;
  const RegisterFailure({
    required this.erroeMessage,
  });
}

final class SelectGovernorate extends RegisterState {
  final String selectedGovernorate;
  const SelectGovernorate({required this.selectedGovernorate});
}

class RegisterGovernorateChanged extends RegisterState {
  final String selectedGovernorate;

  const RegisterGovernorateChanged({required this.selectedGovernorate});
}

class RegisterGovernorateArabicChanged extends RegisterState {
  final String selectedGovernorateArabic;

  const RegisterGovernorateArabicChanged(
      {required this.selectedGovernorateArabic});
}
