import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/home/data/model/image_model.dart';
import 'package:liness/feature/home/data/model/session_resent_model.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';

class HomeRepository {
  Future<Either<ErrorModel, List<ImageModel>>> fetchImages() async {
    try {
      final response = await getIt<DioConsumer>().get(EndPoints.cover);
      List<dynamic> imageUrls = response as List<dynamic>;

      final images =
          imageUrls.map((url) => ImageModel(imageUrl: url.toString())).toList();

      return Right(images);
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }

  Future<Either<ErrorModel, List<TeacherCardModel>>> fetchTeachers() async {
    try {
      final response = await getIt<DioConsumer>().get(EndPoints.teacherRandom);
      List<dynamic> teacherData = response as List<dynamic>;

      final teachers =
          teacherData.map((data) => TeacherCardModel.fromJson(data)).toList();
      return Right(teachers);
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }

  Future<Either<ErrorModel, List<SessionResentModel>>>
      fetchSessionResent() async {
    try {
      final response = await getIt<DioConsumer>().get(EndPoints.sessionRecent);
      List<dynamic> sessionRecent = response as List<dynamic>;

      final session = sessionRecent
          .map((data) => SessionResentModel.fromJson(data))
          .toList();
      return Right(session);
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
