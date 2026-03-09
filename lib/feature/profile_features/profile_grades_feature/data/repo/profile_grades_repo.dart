import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/model/api/recorde_model.dart';

class ProfileGradesRepository {
  //// GET PROFILE GRADES DATA METHOD
  Future<Either<ErrorModel, List<ProfileRecordModel>>>
      getProfileGradesData() async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        EndPoints.userGrades,
      );
      ////
      final profileGradesList = ProfileRecordModel.fromListJson(response);
      ////
      return Right(profileGradesList);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
