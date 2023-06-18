// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maa/Controller/services/service.my_service.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';
import 'package:maa/consts/const.keywords.dart';

class BabySecondaryHeightInputDialog extends StatefulWidget {
  final Function callback;
  int currentRoundValue;
  int currentFrucValueAsInt;
  final Map<String, dynamic> babyAgeMap;
  // final SharedPreferences sharedPreferences;
  BabySecondaryHeightInputDialog(
      {Key? key,
      required this.callback,
      required this.currentRoundValue,
      required this.currentFrucValueAsInt,
      required this.babyAgeMap})
      : super(key: key);

  @override
  State<BabySecondaryHeightInputDialog> createState() => _BabySecondaryHeightInputDialogState();
}

class _BabySecondaryHeightInputDialogState extends State<BabySecondaryHeightInputDialog> {
/*   late double _priWeight;
  late int _actualWeeks = 0;
  late int _runningWeeks = 0;
  late int _currentRoundValue = 0;
  late int _currentFrucValueAsInt = 0; */

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    /*  MyServices.mGetSharedPrefIns().then((value) {
      setState(() {
        sharedPreferences = value;
        _priWeight = sharedPreferences.getDouble(MyKeywords.primaryWeight)!;
        _actualWeeks = sharedPreferences.getInt(MyKeywords.runningWeeks)!;
        _runningWeeks = _actualWeeks + 1;

        _currentRoundValue = _priWeight
            .floor(); //set current weight's value before decimal point
        MyServices.mSetFrucValueAsInt(
            priWeight: _priWeight,
            callback: (int value) {
              _currentFrucValueAsInt = value;
              print(_currentFrucValueAsInt);
            });
      });
    }); */
    //set current weight's value after decimal point
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //heading
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            color: MyColors.pink2,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'আপনার উচ্চতা দিন',
                  fontWeight: FontWeight.w600,
                  fontcolor: MyColors.textOnPrimary,
                  fontsize: 18,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          //body
          //week no
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.babyAgeMap[MyKeywords.ageTag] == MyKeywords.weekAsTag
                  ? const CustomText(text: MaaData.weekNo)
                  : const CustomText(text: MaaData.monthNo),
              //get week no from sharedpref and convert it into Bangla font
              CustomText(
                  text: MyServices.mGenerateBangNum(
                      widget.babyAgeMap[MyKeywords.ageNum]))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          //Weight picker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: MyScreenSize.mGetHeight(context, 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //weight's round value picking..
                    NumberPicker(
                        itemWidth: 60,
                        minValue: 0,
                        maxValue: 150,
                        infiniteLoop: true,
                        value: widget
                            .currentRoundValue, //set round value from previous weight
                        onChanged: (value) => setState(() {
                              widget.currentRoundValue = value;
                            })),

                    const CustomText(
                      text: '.',
                      fontWeight: FontWeight.bold,
                      fontsize: 16,
                      fontcolor: Colors.purple,
                    ),

                    //weight's fructional value picking..
                    NumberPicker(
                        itemWidth: 60,
                        minValue: 0,
                        maxValue: 9,
                        infiniteLoop: true,
                        value: widget.currentFrucValueAsInt,
                        onChanged: (value) => setState(() {
                              widget.currentFrucValueAsInt = value;
                            }))
                  ],
                ),
              )
            ],
          ),
          //Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                    text: 'বাতিল',
                    fontcolor: MyColors.pink3,
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              InkWell(
                onTap: () {
                  double updatedHeight = double.parse(
                      widget.currentRoundValue.toString() +
                          "." +
                          widget.currentFrucValueAsInt.toString());

                  widget.callback(updatedHeight);
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                    text: 'সংরক্ষণ',
                    fontcolor: MyColors.pink3,
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
