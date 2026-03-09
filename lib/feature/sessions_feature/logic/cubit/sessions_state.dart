part of 'sessions_cubit.dart';

sealed class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object> get props => [];
}

final class SessionsInitial extends SessionsState {}

final class SessionsLoadingState extends SessionsState {}

final class SessionsLoadedState extends SessionsState {}

final class SessionsErrorState extends SessionsState {}
