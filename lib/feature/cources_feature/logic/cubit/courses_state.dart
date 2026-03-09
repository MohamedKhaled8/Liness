part of 'courses_cubit.dart';

// sealed class CoursesState extends Equatable {
//   // const CoursesState();

//   // @override
//   // List<Object> get props => [];
// }

abstract class CoursesState {}

class CoursesInitial extends CoursesState {}

class CoursesLoadingState extends CoursesState {}

class CoursesLoadedState extends CoursesState {}

class CoursesErrorState extends CoursesState {}
