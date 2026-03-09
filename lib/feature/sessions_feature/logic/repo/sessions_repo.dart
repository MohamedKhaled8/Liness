import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class SessionsRepository {
  //// GET ALL SESSIONS DATA METHOD
  Future<Either<ErrorModel, List<CourseAndSessionCardModel>>>
      getAllSessionsData({
    required int courseId,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.coursesSession}$courseId",
      );
      ////
      final sessionsOfCourcesList =
          CourseAndSessionCardModel.fromListJson(response);
      ////
      return Right(sessionsOfCourcesList);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
