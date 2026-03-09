sealed class AppState {
  const AppState();
}

class AppStateInitial extends AppState {}

class AppStateChangeTheme extends AppState {}

class AppStateChangeLanguage extends AppState {
  final String languageCode;

  const AppStateChangeLanguage({required this.languageCode});
}
