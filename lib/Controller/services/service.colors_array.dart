import 'package:flutter/cupertino.dart';
import 'package:maa/consts/const.colors.dart';

class MyColorArray {
  static Future<List<Color>> mGetTimestartColorArray() async {
    List<Color> parentColors = [MyColors.firstTrimster, MyColors.secondTrimster, MyColors.thirdTrimster];
    List<Color> children = [];

    for (var i = 0; i < parentColors.length; i++) {
      for (var j = 0; i == 2 ? j < 14 : j < 13; j++) {
        children.add(parentColors[i]);
      }
    }
    return children;
  }
}
