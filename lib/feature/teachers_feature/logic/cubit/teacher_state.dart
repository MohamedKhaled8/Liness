part of 'teacher_cubit.dart';

sealed class TeacherState extends Equatable {
  const TeacherState();

  @override
  List<Object> get props => [];
}

final class TeacherInitial extends TeacherState {}

class TeacherLoadingState extends TeacherState {}

class TeacherLoadedState extends TeacherState {
  final TeacherCoursesModel? teacherCourses;

  const TeacherLoadedState([this.teacherCourses]);
}

class TeacherErrorState extends TeacherState {}
