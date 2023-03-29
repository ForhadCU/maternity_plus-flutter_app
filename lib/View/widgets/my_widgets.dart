// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';
import 'package:splash_screen/consts/const.keywords.dart';

class MyWidgets {
  static Widget wDialogCurrentWeight(SharedPreferences sharedPreferences,
      {required Function callback}) {
    double _priWeight = sharedPreferences.getDouble(MyKeywords.primaryWeight)!;
    int _actualWeeks = sharedPreferences.getInt(MyKeywords.runningWeeks)!;
    int _runningWeeks = _actualWeeks + 1;
    int _currentValue = _priWeight.round();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //heading
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              color: MyColors.pink2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'আপনার ওজন দিন',
                    fontWeight: FontWeight.w600,
                    fontcolor: MyColors.textOnPrimary,
                    fontsize: 18,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            //body
            //week no
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: MaaData.weekNo),
                //get week no from sharedpref and convert it into Bangla font
                CustomText(
                    text: MyServices.mGenerateBangNum(_runningWeeks + 95))
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    /*  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NumberPicker(
                            minValue: 0,
                            maxValue: 150,
                            value: _currentValue,
                           onChanged: ,
                      ],
                    ) */
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
