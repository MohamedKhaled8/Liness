import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/session_features/session_feature/model/data/session_model.dart';

class SessionRepository {
  //// GET SESSION DATA METHOD
  Future<Either<ErrorModel, SessionModel>> getSessionData({
    required int sessionId,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.sessionData}$sessionId",
      );
      ////
      final sessionModel = SessionModel.fromJson(response);
      ////
      return Right(sessionModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }

  //// OPEN SESSION METHOD
  Future<Either<ErrorModel, SessionModel>> openSession({
    required int sessionId,
    required String code,
    required SessionModel currentSessionModel,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().post(
        EndPoints.sessionOpen,
        data: {
          'id': sessionId,
          'code': code,
        },
      );
      ////
      currentSessionModel.isClosed = response['state'] != 'open';
      ////
      currentSessionModel.sessionTimes = response['times'];
      ////
      return Right(currentSessionModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
