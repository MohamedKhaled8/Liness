import 'package:equatable/equatable.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class CourseSubjectModel extends Equatable {
  final List<CourseAndSessionCardModel> courses;

  const CourseSubjectModel({
    required this.courses,
  });

  @override
  List<Object> get props => [courses];

  factory CourseSubjectModel.fromMap(List<dynamic> json) {
    return CourseSubjectModel(
      courses: List<CourseAndSessionCardModel>.from(
        json.map(
          (e) => CourseAndSessionCardModel.fromJson(e),
        ),
      ),
    );
  }
}
