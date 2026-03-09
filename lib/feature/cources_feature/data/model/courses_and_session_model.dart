import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class CoursesAndSessionModel {
  final int? teacherExp;
  final int? teacherStudentsCount;
  final List<CourseAndSessionCardModel> coursesOrSessions;

  CoursesAndSessionModel({
    this.teacherExp,
    this.teacherStudentsCount,
    required this.coursesOrSessions,
  });

  factory CoursesAndSessionModel.fromJson(json) {
    if (json is List) {
      return CoursesAndSessionModel(
        coursesOrSessions: CourseAndSessionCardModel.fromListJson(
          json,
        ),
      );
    } else {
      return CoursesAndSessionModel(
        teacherExp: json['years'],
        teacherStudentsCount: json['students'],
        coursesOrSessions: CourseAndSessionCardModel.fromListJson(
          json['courses'] ?? json,
        ),
      );
    }
  }
}
