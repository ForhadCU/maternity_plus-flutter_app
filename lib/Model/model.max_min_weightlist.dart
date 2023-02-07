import 'package:flutter/material.dart';
import 'package:splash_screen/Model/model.ojon.dart';

class MaxMinWeightListModel {
  List<OjonModel> minWeightList;
  List<OjonModel> maxWeightList;
  List<OjonModel> currentOjonList;

  MaxMinWeightListModel(
      {required this.minWeightList,
      required this.maxWeightList,
      required this.currentOjonList});
}
