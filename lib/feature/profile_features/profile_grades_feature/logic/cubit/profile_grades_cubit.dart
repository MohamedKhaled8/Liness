import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/profile_grades_repo.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/model/api/recorde_model.dart';

part 'profile_grades_state.dart';

class ProfileGradesCubit extends Cubit<ProfileGradesState> {
  ProfileGradesCubit() : super(ProfileGradesInitial());

  ProfileGradesRepository profileGradesRepository = ProfileGradesRepository();

  List<ProfileRecordModel> profileRecordListModel = [];
     final ScrollController scrollController = ScrollController();

  //// GET ALL SESSIONS DATA
  Future<void> getProfileGradesData({
    required BuildContext context,
  }) async {
    ////
    emit(ProfileGradesLoadingState());
    ////
    final result = await profileGradesRepository.getProfileGradesData();
    ////
    result.fold(
      (errMessage) {
        emit(ProfileGradesErrorState());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (profileRecordListModel) {
        ////
        this.profileRecordListModel = profileRecordListModel;
        ////
        emit(ProfileGradesLoadedState());
      },
    );
    ////
  }

    void scrollToTop() {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    void scrollToBottom() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
}
