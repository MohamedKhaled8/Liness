import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/repos/packages_repo.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/feature/package_features/all_packages_feature/models/package_model.dart';
part 'packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(PackagesInitial());

  List<PackageModel> packagesModelList = [];

  Future<void> getPackagesData({
    required BuildContext context,
  }) async {
    if (isClosed) return;
    emit(PackagesLoadingState());

    final result = await PackagesRepository.getPackagesData();

    result.fold(
      (errMessage) {
        if (!isClosed) emit(PackagesErrorState());
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );
      },
      (packagesModelList) {
        ////
        this.packagesModelList = packagesModelList;
        ////
        if (!isClosed) emit(PackagesLoadedState());
        ////
      },
    );
  }
}
