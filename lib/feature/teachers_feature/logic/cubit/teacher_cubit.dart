import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/feature/teachers_feature/data/model/teacher_courses_model.dart';
import 'package:liness/feature/teachers_feature/data/repository/teacher_repository.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit() : super(TeacherInitial());

  TeacherRepository teacherCardRepository = getIt<TeacherRepository>();

  TeacherCoursesModel? teacherCoursesModel;

  List<TeacherCardModel> allTeachresDataModelList = [];

  //// GET ALL TECHARES DATA
  Future<void> getAllTeachersdData({
    required BuildContext context,
  }) async {
    ////
    emit(TeacherLoadingState());
    ////
    final result = await teacherCardRepository.getAllTeachersdData();
    ////
    result.fold(
      (errMessage) {
        emit(TeacherErrorState());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (allTeachresDataModelList) {
        this.allTeachresDataModelList = allTeachresDataModelList;
        emit(TeacherLoadedState(teacherCoursesModel));
      },
    );
    ////
  }
  ////
}
