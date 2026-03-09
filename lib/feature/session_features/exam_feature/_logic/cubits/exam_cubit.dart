import '../repo/exam_repo.dart';
import '../states/exam_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/feature/session_features/exam_feature/model/exam_model.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit() : super(ExamStateInit());

  ExamRepository sessionRepository = ExamRepository();

  ExamModel? examModel;

  List<Map<String, dynamic>> userAnswers = [];

  bool examGradeView = false;

  int? sessionId = 0;

  //// GET EXAM DATA
  Future<void> getExamData({
    required int? sessionId,
    required int? gradeId,
    required BuildContext context,
  }) async {
    ////
    this.sessionId = sessionId;
    dynamic result;
    ////
    emit(ExamLoadingState());
    ////
    if (gradeId != null) {
      result = await sessionRepository.getExamGradeData(
        gradeId: gradeId,
      );
    } else {
      result = await sessionRepository.getExamData(
        sessionId: sessionId!,
      );
    }
    ////
    result.fold(
      (errMessage) {
        emit(ExamErrorState());
        ////
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );
        ////
      },
      (examModel) {
        ////
        this.examModel = examModel;
        ////
        gradeId != null ? examGradeView = true : null;
        ////
        emit(ExamLoadedState());
        ////
      },
    );
    ////
  }

  //// SUBMIT EXAM
  Future<void> submitExam({
    required BuildContext context,
  }) async {
    if (examModel != null) {
      if (userAnswers.length == examModel!.examQuestions.length) {
        ////
        emit(ExamLoadingState());
        ////
        final result = await sessionRepository.submitExam(
          examId: examModel!.examId.toString(),
          questions: userAnswers,
          currentExamModel: examModel!,
        );
        ////
        result.fold(
          (errMessage) {
            ////
            emit(ExamErrorState());
            ////
            showLocalizedMessage(
              context,
              errMessage.msgAr,
              errMessage.msgEn,
              isError: true,
              onTap: () {
                context.pop();
                context.pop();
              },
            );
            ////
          },
          (examModelWithCorrectAnswers) {
            ////
            examModel = examModelWithCorrectAnswers;
            ////
            emit(ExamLoadedState());
          },
        );
        ////
      } else {
        showLocalizedMessage(
          context,
          "يحب الاجابة علي كل الأسئلة",
          "you must answer all questions",
          isError: true,
          onTap: () {
            context.pop();
          },
        );
      }
    }
  }

  //// SET USER ANSWERS IN userAnswers List
  setUserAnswer({
    required int questionId,
    required int answerNumber,
  }) {
    userAnswers.firstWhere(
      (map) {
        if (map.containsValue(questionId)) {
          ////
          map.update('ans', (value) => answerNumber);
          ////
          return true;
          ////
        }
        return false;
      },
      orElse: () {
        userAnswers.add(
          {
            'id': questionId,
            'ans': answerNumber,
          },
        );
        return {};
      },
    );
    ////
    ////
    emit(ExamUpdateAnswerState(questionId, answerNumber));
    ////
  }
  ////

  //// GET SELECTED ANSWER FOR CURRENT QUESTION
  bool getSelectedAnswer({
    required int questionId,
    required int answerNumber,
    required int questionIndex,
  }) {
    ////
    bool state = false;
    ////
    if (examGradeView && examModel != null) {
      state =
          examModel!.examQuestions[questionIndex].userAnswer == answerNumber;
    } else {
      userAnswers.firstWhere(
        (map) {
          if (map.containsValue(questionId) &&
              map.containsValue(answerNumber)) {
            state = true;
          }
          return false;
        },
        orElse: () {
          return {};
        },
      );
    }
    ////
    return state;
    ////
  }
  ////
}
