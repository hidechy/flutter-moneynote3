class Score {
  final String yearmonth;
  final int prevTotal;
  final int thisTotal;
  final int score;
  final int benefit;
  final String benefitCompany;
  final int minus;
  final int average;

  Score(
      {required this.yearmonth,
      required this.prevTotal,
      required this.thisTotal,
      required this.score,
      required this.benefit,
      required this.benefitCompany,
      required this.minus,
      required this.average});
}
