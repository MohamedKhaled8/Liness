import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/feature/sessions_feature/logic/repo/sessions_repo.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';
part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit() : super(SessionsInitial());

  SessionsRepository sessionsRepository = SessionsRepository();

  List<CourseAndSessionCardModel> sessionsOfCourcesList = [];

  //// GET ALL SESSIONS DATA
  Future<void> getAllSessionsData({
    required int courseId,
    required BuildContext context,
  }) async {
    ////
    emit(SessionsLoadingState());
    ////
    final result = await sessionsRepository.getAllSessionsData(
      courseId: courseId,
    );
    ////
    result.fold(
      (errMessage) {
        emit(SessionsErrorState());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (sessionsOfCourcesList) {
        this.sessionsOfCourcesList = sessionsOfCourcesList;
        emit(SessionsLoadedState());
      },
    );
    ////
  }
}
