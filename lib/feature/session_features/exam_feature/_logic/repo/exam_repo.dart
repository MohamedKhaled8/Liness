import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/session_features/exam_feature/model/exam_model.dart';
import 'package:liness/feature/session_features/exam_feature/model/exam_question_model.dart';

class ExamRepository {
  //// GET EXAM DATA METHOD
  Future<Either<ErrorModel, ExamModel>> getExamData({
    required int sessionId,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.sessionView}$sessionId",
      );
      ////
      final examModel = ExamModel.fromJson(response);
      ////
      return Right(examModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }

  //// SUBMIT EXAM METHOD
  Future<Either<ErrorModel, ExamModel>> submitExam({
    required String examId,
    required List<Map<String, dynamic>> questions,
    required ExamModel currentExamModel,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().post(
        EndPoints.submitExam,
        data: {
          'id': examId,
          'questions': questions,
        },
      );
      //// EDIT USER EXAM
      currentExamModel.isPass = response['state'] == 'done';
      currentExamModel.total = response['total'];
      //// EDIT USER EXAM QUESTIONS
      currentExamModel.examQuestions = ExamQuestionModel.correctAnwFromListJson(
        response["questions"],
        currentExamModel.examQuestions,
      );
      ////
      return Right(currentExamModel);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }

  //// GET GRADE DATA METHOD
  Future<Either<ErrorModel, ExamModel>> getExamGradeData({
    required int gradeId,
  }) async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        "${EndPoints.examGrades}$gradeId",
      );
      ////
      final examGrades = ExamModel.fromJson(response);
      ////
      return Right(examGrades);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
