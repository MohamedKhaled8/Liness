import 'package:equatable/equatable.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class TeacherCoursesModel extends Equatable {
  final int teacherStudentCont;
  final int teacherExp;
  final List<CourseAndSessionCardModel> courses;

  const TeacherCoursesModel({
    required this.teacherStudentCont,
    required this.teacherExp,
    required this.courses,
  });

  factory TeacherCoursesModel.fromJson(
      Map<String, dynamic> map, String teacherName) {
    return TeacherCoursesModel(
      teacherStudentCont: map['students'] as int,
      teacherExp: map['years'] as int,
      courses: List.generate(
        map['courses'].length,
        (index) => CourseAndSessionCardModel.fromJson(
          map['courses'][index] as Map<String, dynamic>,
          // teacherName,
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [teacherStudentCont, teacherExp, courses];
}
