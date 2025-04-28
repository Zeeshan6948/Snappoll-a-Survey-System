class SurveyQuestions {
  const SurveyQuestions(this.text, this.answers);

  /// [text] takes the question of the survey as [String]
  final String text;

  /// [answers] takes a [List] of possible answers
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffleList = List.of(answers);
    shuffleList.shuffle();
    return shuffleList;
  }
}
