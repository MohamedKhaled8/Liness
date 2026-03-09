part of 'profile_grades_cubit.dart';

sealed class ProfileGradesState extends Equatable {
  const ProfileGradesState();

  @override
  List<Object> get props => [];
}

final class ProfileGradesInitial extends ProfileGradesState {}

final class ProfileGradesLoadingState extends ProfileGradesState {}

final class ProfileGradesLoadedState extends ProfileGradesState {}

final class ProfileGradesErrorState extends ProfileGradesState {}
