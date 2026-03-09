import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/package_features/all_packages_feature/models/package_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class PackagesRepository {
  // TeacherCourcesDataRepository();

  //// GET PACKAGES DATA IN HOME SCREEN
  static Future<Either<ErrorModel, List<PackageModel>>>
      getPackagesData() async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        EndPoints.packages,
      );
      ////
      final packagesModelList = PackageModel.fromListJson(response);
      ////
      return Right(packagesModelList);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
