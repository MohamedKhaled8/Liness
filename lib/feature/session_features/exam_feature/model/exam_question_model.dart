class ExamQuestionModel {
  final int questionId;
  String questionImage;
  int questionPoints;
  final int? correctAnswer;
  final int? userAnswer;

  ExamQuestionModel({
    required this.questionId,
    this.questionImage = '',
    this.questionPoints = 0,
    this.correctAnswer,
    this.userAnswer = 0,
  });

  factory ExamQuestionModel.fromJson(map) {
    return ExamQuestionModel(
      questionId: map['id'] as int,
      questionImage: map['img'] as String,
      questionPoints: map["points"] ?? 0,
      userAnswer: map['ans'] != null ? map['ans'] as int : null,
      correctAnswer: map['correct'] != null ? map['correct'] as int : null,
    );
  }

  // CONSTRACTOR TO EDIT USER QUESTIONS
  factory ExamQuestionModel.correctAnsFromJson(map) {
    return ExamQuestionModel(
      questionId: map['id'] ?? 0,
      userAnswer: map['ans'] ?? 0,
      correctAnswer: map['correct'] != null ? map['correct'] as int : null,
    );
  }

  // Constructor to create a list of ExamQuestionModel from a list of JSON
  static List<ExamQuestionModel> fromListJson(list) {
    ////
    final List<ExamQuestionModel> listModel = [];
    ////
    for (int index = 0; index < list.length; index++) {
      listModel.add(
        ExamQuestionModel.fromJson(list[index]),
      );
    }
    ////
    return listModel;
    ////
  }

  // CONSTRACTOR TO EDIT USER QUESTIONS FROM LIST
  static List<ExamQuestionModel> correctAnwFromListJson(
      list, List<ExamQuestionModel> currrentQuestionsModel) {
    ////
    final List<ExamQuestionModel> listModel = [];
    ////
    for (int index = 0; index < list.length; index++) {
      listModel.add(
        ExamQuestionModel.correctAnsFromJson(list[index])
          ..questionImage = currrentQuestionsModel[index].questionImage
          ..questionPoints = currrentQuestionsModel[index].questionPoints,
      );
    }
    ////
    return listModel;
    ////
  }
}
