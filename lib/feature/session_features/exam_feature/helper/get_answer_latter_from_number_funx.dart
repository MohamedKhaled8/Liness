String getAnswerCharFromNumber({
  required int answerNumber,
}) {
  switch (answerNumber) {
    case 1:
      return 'A';
    case 2:
      return 'B';
    case 3:
      return 'C';
    default:
      return 'D';
  }
}
