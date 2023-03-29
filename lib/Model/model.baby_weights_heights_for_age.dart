class BabyWeightsHeightsForAge {
  late List<double> minThirdStdDeviationOfWeightList; //[-3 SD]
  late List<double> maxThirdStdDeviationOfWeightList; //[+3 SD]
  late List<double> minSecondStdDeviationOfWeightList; //[-2 SD]
  late List<double> maxSecondStdDeviationOfWeightList; //[+2 SD]
  late List<double> minFirstStdDeviationOfWeightList; //[-1 SD]
  late List<double> maxFirstStdDeviationOfWeightList; //[+1 SD]
  late List<double> medianOfWeightList; //[+1 SD]
  late List<double> minThirdStdDeviationOfHeightList; //[-3 SD]
  late List<double> maxThirdStdDeviationOfHeightList; //[+3 SD]
  late List<double> minSecondStdDeviationOfHeightList; //[-2 SD]
  late List<double> maxSecondStdDeviationOfHeightList; //[+2 SD]
  late List<double> minFirstStdDeviationOfHeightList; //[-1 SD]
  late List<double> maxFirstStdDeviationOfHeightList; //[+1 SD]
  late List<double> medianOfHeightList; //[+1 SD]

  BabyWeightsHeightsForAge();

  BabyWeightsHeightsForAge.cWeightsForAge(
      {required this.minThirdStdDeviationOfWeightList,
      required this.maxThirdStdDeviationOfWeightList,
      required this.minSecondStdDeviationOfWeightList,
      required this.maxSecondStdDeviationOfWeightList,
      required this.minFirstStdDeviationOfWeightList,
      required this.maxFirstStdDeviationOfWeightList,
      required this.medianOfWeightList});
  BabyWeightsHeightsForAge.cHeightsForAge(
      {required this.minThirdStdDeviationOfHeightList,
      required this.maxThirdStdDeviationOfHeightList,
      required this.minSecondStdDeviationOfHeightList,
      required this.maxSecondStdDeviationOfHeightList,
      required this.minFirstStdDeviationOfHeightList,
      required this.maxFirstStdDeviationOfHeightList,
      required this.medianOfHeightList});
}
