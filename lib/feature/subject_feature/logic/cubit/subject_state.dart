// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subject_cubit.dart';

sealed class SubjectState extends Equatable {
  const SubjectState();
  @override
  List<Object> get props => [];
}

final class SubjectInitial extends SubjectState {}

class ImageChangedState extends SubjectState {
  final String imagePath;

  const ImageChangedState(this.imagePath);
}

class ToggleShowOriginalTextInitial extends SubjectState {
  final bool showOriginalText;

  const ToggleShowOriginalTextInitial(this.showOriginalText);
}

class SubjectLoading extends SubjectState {
  const SubjectLoading();
}
class SubjectCoursesLoaded extends SubjectState {
  final List<CourseAndSessionCardModel> courses;

  const SubjectCoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}
class SubjectLoaded extends SubjectState {
  final List<SubjectModel> subjects;

  const SubjectLoaded(this.subjects);
}

class SubjectLoadeds extends SubjectState {

}
class SubjectError extends SubjectState {

}
