import 'package:maa/Model/model.ojon.dart';

class MaxMinWeightListModel {
  List<OjonModel> minWeightList;
  List<OjonModel> maxWeightList;
  List<OjonModel> currentOjonList;

  MaxMinWeightListModel(
      {required this.minWeightList,
      required this.maxWeightList,
      required this.currentOjonList});
}
