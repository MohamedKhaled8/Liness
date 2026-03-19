import '../repo/session_repo.dart';
import '../states/session_state.dart';
import 'package:flutter/material.dart';
import '../../helper/enums/session_types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/function/dialoge_error.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/session_features/session_feature/model/data/session_model.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionStateInit());

  SessionRepository sessionRepository = SessionRepository();

  SessionModel? sessionModel;
  final isArabic = ChangeTranslateAndTheme.isArabic;

  //// GET SESSION DATA
  Future<void> getSessionData({
    required int sessionId,
    required BuildContext context,
  }) async {
    ////
    emit(SessionLoadingState());
    ////
    final result = await sessionRepository.getSessionData(
      sessionId: sessionId,
    );
    ////
    result.fold(
      (errMessage) {
        emit(SessionErrorState());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (sessionModel) {
        ////
        this.sessionModel = sessionModel;
        ////
        this.sessionModel!.id = sessionId;
        ////
        emit(SessionLoadedState());
      },
    );
    ////
  }

  void updateSessionTimes(int newTimes) {
    if (sessionModel != null) {
      sessionModel!.sessionTimes = newTimes;
      emit(SessionLoadedState());
    }
  }

  //// OPEN SESSION BY CODE
  Future<void> openSession({
    required BuildContext context,
    required String code,
  }) async {
    ////
    if (sessionModel != null) {
      final rootContext = Navigator.of(context).context;

      emit(SessionLoadingState());
      ////
      final result = await sessionRepository.openSession(
        sessionId: sessionModel!.id,
        code: code,
        currentSessionModel: sessionModel!,
      );
      ////
      result.fold(
        (errMessage) {
          ////

          showLocalizedMessage(
            rootContext,
            errMessage.msgAr,
            errMessage.msgEn,
            isError: true,
          );

          ////
          emit(SessionErrorState());
          ////
        },
        (newSessionModel) {
          ////
          sessionModel = newSessionModel;

          showLocalizedMessage(
            rootContext,
            "تم فتح الحصة بنجاح",
            "The session has been successfully opened",
            isError: false,
          );

          ////
          emit(SessionLoadedState());
          ////
        },
      );
      ////
    }
  }

  //// OPEN SESSION METHOD
  void goToSession({
    required BuildContext context,
  }) {
    if (sessionModel != null) {
      if (sessionModel!.sessionType == SessionTypesEnum.video) {
        ////
        sessionModel!.sessionTimes--;
        ////
        _incrementEntryCount(sessionModel!.id);
        ////
        context.pushReplacementNamed(
          Routes.videoScreen,
          arguments: sessionModel!.id,
        );
        ////
        emit(SessionLoadedState());
        ////
      } else if (sessionModel!.sessionType == SessionTypesEnum.examAndVideo) {
        if (sessionModel!.isExamDone) {
          _incrementEntryCount(sessionModel!.id);
          context.pushReplacementNamed(
            Routes.videoScreen,
            arguments: sessionModel!.id,
          );
        } else {
          context.pushReplacementNamed(
            Routes.examScreen,
            //// SET SESSION ID AND MAKE GRADE ID IS NULL
            arguments: [sessionModel!.id, null],
          );
        }
      } else {
        context.pushReplacementNamed(
          Routes.examScreen,
          //// SET SESSION ID AND MAKE GRADE ID IS NULL
          arguments: [sessionModel!.id, null],
        );
      }
    }
  }

  Future<void> _incrementEntryCount(int sessionId) async {
    int currentCount = getIt<CacheHelper>().getData(key: 'entry_count_x_$sessionId') ?? 0;
    await getIt<CacheHelper>().saveData(key: 'entry_count_x_$sessionId', value: currentCount + 1);
  }

  Future<void> checkLoginAndShowMessage(BuildContext context) async {
    if (gLoginUserModel == null) {
      await showMessage(
        context,
        "يرجى تسجيل الدخول لفتح السيشن",
        isError: true,
        onConfirmTapped: () {
          context.pop();
          context.pushNamed(Routes.loginScreen);
        },
      );
    }
  }
}
