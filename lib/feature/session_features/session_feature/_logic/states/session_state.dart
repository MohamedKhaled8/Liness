abstract class SessionState {}

class SessionStateInit extends SessionState {}

final class SessionLoadingState extends SessionState {}

final class SessionLoadedState extends SessionState {}

final class SessionErrorState extends SessionState {}
