import 'exam_question_model.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';


class ExamModel {
  final int examId;
  num examTime;
  String examName;
  String result;
  String total;
  bool isPass;
  List<ExamQuestionModel> examQuestions;

  ExamModel({
    required this.examId,
    required this.examTime,
    this.examName = '',
    this.total = '',
    required this.result,
    this.isPass = false,
    required this.examQuestions,
    // required this.submited,
  });

  factory ExamModel.fromJson(json) {
    return ExamModel(
      examId: json['id'] ?? 0,
      examTime: json['time'] ?? 0,
      isPass: json['state'] != null ? json['state'] == 'done' : false,
      examName: json['name'] ?? '',
      result: json['result'] ?? '',
      total: json['total'] ?? '',
      examQuestions: ExamQuestionModel.fromListJson(json['questions']),
      // submited: false,
    );
  }
}

final ExamModel examModelDemo = ExamModel(
  examId: 1,
  examTime: 59,
  result: '',
  examQuestions: List.generate(
    11,
    (index) => ExamQuestionModel(
      questionId: index,
      questionImage: ImageAssetsManger.chimecalSubject,
      questionPoints: 2,
    ),
  ),
  // submited: false,
);
