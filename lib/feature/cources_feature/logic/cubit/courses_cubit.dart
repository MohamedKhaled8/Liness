import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/repos/subject_courses_repo.dart';
import '../../data/repository/courses_repo.dart';
import '../../data/model/courses_and_session_model.dart';
import 'package:liness/core/repos/teacher_cources_data_repo.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(CoursesInitial());

  CoursesRepository coursesRepository = CoursesRepository();

  CoursesAndSessionModel? allCourses;

  //// GET ALL COURSES DATA
  Future<void> getAllCoursesData({
    int? teacherId,
    int? subjectId,
    required BuildContext context,
  }) async {
    if (isClosed) return;
    ////
    dynamic response;
    ////
    emit(CoursesLoadingState());
    ////
    if (teacherId != null) {
      //// GET TEACHERS COURCES DATA
      response = await TeacherCourcesDataRepository.teacherCourses(
        teacherId: teacherId,
      );
      ////
    } else if (subjectId != null) {
      //// GET TEACHERS COURCES DATA
      response = await SubjectCoursesRepository.getSubjectCourses(
        subjectId: subjectId,
      );
      ////
    } else {
      //// ALL COURSES DATA
      response = await coursesRepository.getAllCoursesData();
      ////
    }
    ////
    response.fold(
      (errMessage) {
        if (!isClosed) emit(CoursesErrorState());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (allCourses) {
        ////
        this.allCourses = allCourses;
        ////
        if (!isClosed) emit(CoursesLoadedState());
      },
    );
    ////
  }
}
