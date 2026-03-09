import 'package:dartz/dartz.dart';
import '../../models/package_data_model.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class PackageDataRepository {
  //// GET PACKAGE DATA METHOD
  Future<Either<ErrorModel, PackageDataModel>> getPackageData({
    required int packageId,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.packageData}$packageId",
      );
      ////
      final packageDataModel = PackageDataModel.fromJson(response);
      ////
      return Right(packageDataModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }

  //// OPEN PACKAGE METHOD
  Future<Either<ErrorModel, String>> openPackage({
    required int packageId,
    required String code,
    required BuildContext context,
  }) async {
    try {
      ////
      await getIt<DioConsumer>().post(
        EndPoints.openPackage,
        data: {
          "id": packageId,
          "code": code,
        },
      );
      ////
      return Right(AppLocalizations.of(context)!
          .translate('The package has been opened successfully'));
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
