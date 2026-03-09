import 'package:flutter/widgets.dart';
import '../repo/package_data_repo.dart';
import 'package:equatable/equatable.dart';
import '../../models/package_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';

part 'package_data_state.dart';

class PackageDataCubit extends Cubit<PackageDataState> {
  PackageDataCubit() : super(PackageDataInitial());

  PackageDataRepository packageDataRepository = PackageDataRepository();

  PackageDataModel? packageDataModel;

  int packageId = 0;

  //// GET PackageData DATA
  Future<void> getPackageDataData({
    required int packageId,
    required BuildContext context,
  }) async {
    ////
    this.packageId = packageId;
    ////
    emit(PackageDataLoadingState());
    ////
    final result = await packageDataRepository.getPackageData(
      packageId: packageId,
    );
    ////
    result.fold(
      (errMessage) {
        emit(PackageDataErrorState());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (packageDataModel) async {
        ////
        this.packageDataModel = packageDataModel;

        ////
        emit(PackageDataLoadedState());
      },
    );
    ////
  }

  //// OPEN PACKAGE DATA METHOD
  Future<void> openPackage({
    required BuildContext context,
    required String code,
  }) async {
    ////
    emit(PackageDataLoadingState());
    //// OPEN PACKAGE DATA
    final result = await packageDataRepository.openPackage(
      packageId: packageId,
      code: code,
      context: context,
    );
    ////
    result.fold(
      (errMessage) {
        emit(PackageDataErrorState());
        ////
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );
        ////
      },
      (successMessage) async {
        ////
        packageDataModel?.notBuy = false;

        ////
        showLocalizedMessage(
          context,
          successMessage,
          successMessage,
          isError: false,
        );
        ////
        emit(PackageDataLoadedState());
      },
    );
    ////
  }
}
