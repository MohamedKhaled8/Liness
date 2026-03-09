import 'package:dartz/dartz.dart';
import '../model/courses_and_session_model.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';

class CoursesRepository {
  //// GET ALL COURSES DATA METHOD
  Future<Either<ErrorModel, CoursesAndSessionModel>> getAllCoursesData() async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        EndPoints.allCourses,
      );
      ////
      final allCoursesList = CoursesAndSessionModel.fromJson(response);
      ////
      return Right(allCoursesList);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
