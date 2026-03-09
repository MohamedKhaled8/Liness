import 'package:dartz/dartz.dart';
import '../model/video_model.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';

class VideoSessionRepository {
  //// GET VIDEO SESSION DATA METHOD
  Future<Either<ErrorModel, VideoModel>> getVideoSessionData({
    required int sessionId,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.sessionView}$sessionId",
      );
      ////
      final videoModel = VideoModel.fromJson(response);
      ////
      return Right(videoModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
