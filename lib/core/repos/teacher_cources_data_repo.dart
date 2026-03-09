import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import '../../feature/cources_feature/data/model/courses_and_session_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class TeacherCourcesDataRepository {
  // TeacherCourcesDataRepository();

  //// GET TEACHER COURCES DATA METHOD
  static Future<Either<ErrorModel, CoursesAndSessionModel>> teacherCourses({
    required int teacherId,
    // required String teacherName,
  }) async {
    try {
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.teacherCources}$teacherId",
      );

      final teacherCourses = CoursesAndSessionModel.fromJson(response);

      return Right(teacherCourses);
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
