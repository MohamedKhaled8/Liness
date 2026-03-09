abstract class ExamState {}

class ExamStateInit extends ExamState {}

class ExamUpdateAnswerState extends ExamState {
  final int questionNumber;
  final int newAnswer;
  ExamUpdateAnswerState(this.questionNumber, this.newAnswer);
}

final class ExamLoadingState extends ExamState {}

final class ExamLoadedState extends ExamState {}

final class ExamErrorState extends ExamState {}
