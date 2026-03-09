import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/cources_feature/data/model/courses_and_session_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class SubjectCoursesRepository {
  // TeacherCourcesDataRepository();

  //// GET SUBJECT COURCES DATA METHOD
  static Future<Either<ErrorModel, CoursesAndSessionModel>> getSubjectCourses({
    required int subjectId,
  }) async {
    try {
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.coursesSubject}$subjectId",
      );
      ////
      final subjectCourses = CoursesAndSessionModel.fromJson(response);
      ////
      return Right(subjectCourses);

      ///
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
