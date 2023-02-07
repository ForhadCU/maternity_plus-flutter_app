import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.max_min_weightlist.dart';
import 'package:splash_screen/Model/model.ojon.dart';
import 'package:splash_screen/View/screens/ojon/widgets/dlg_input_ojon.dart';
import 'package:splash_screen/View/screens/ojon/widgets/dlg_input_primary_ojon.dart';
import 'package:splash_screen/View/screens/ojon/widgets/wdgt.graphPart.dart';
import 'package:splash_screen/View/screens/ojon/widgets/wdgt.ojonAndWeekPart.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.keywords.dart';

class OjonScreen extends StatefulWidget {
  const OjonScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OjonScreen> createState() => _OjonScreenState();
}

class _OjonScreenState extends State<OjonScreen> {
  late bool isSetPrimaryWeight = false;
  double primaryWeight = 0.00;
  List<double> currentWeightsListForGraph = [];
  List<String> currentWeightsList = [];
  List<double> minWeight = [];
  List<double> maxWeight = [];
  late SharedPreferences sharedPreferences;
  late int _actualWeeks = 0;
  late int _runningWeeks = 0;
  late int _currentRoundValue = 0;
  late int _currentFrucValueAsInt = 0;
  late double _lastUpdatedWeight = 0.00;
  late List<OjonModel> maxOjonList = [];
  late List<OjonModel> minOjonList = [];
  late List<OjonModel> currentOjonList = [];
  late String encodedMinWeightList;
  late String encodedMaxWeightList;
  late String? encodedCurrentWeightList;

  @override
  void initState() {
    super.initState();
    MyServices.mGetSharedPrefIns().then((value) {
      setState(() {
        encodedMinWeightList = '';
        sharedPreferences = value;
        currentWeightsList =
            MyServices.mGetWeightList(sharedPreferences: sharedPreferences);
        // _priWeight = sharedPreferences.getDouble(MyKeywords.primaryWeight)!;
        _actualWeeks = sharedPreferences.getInt(MyKeywords.actualRunningWeeks)!;
        _runningWeeks = _actualWeeks + 1;

        //check initially primary weight existed or not
        isSetPrimaryWeight = MyServices.mCheckPrimaryWeight(
            sharedPreferences: sharedPreferences);
        print(isSetPrimaryWeight);
        if (!isSetPrimaryWeight) {
          showDialog(
              context: context,
              builder: (context) => InputPrimaryOjonDialog(
                    callBack: (double w, double h) {
                      mPrimaryScreenUpdate(w, h);
                    },
                  ));
        } else {
          setState(() {
            _lastUpdatedWeight = MyServices.mGetLastUpdatedWeight(
                sharedPreferences: sharedPreferences);
            _currentRoundValue = _lastUpdatedWeight.floor();
            MyServices.mSetFrucValueAsInt(
                priWeight: _lastUpdatedWeight,
                callback: (int value) {
                  _currentFrucValueAsInt = value;
                });
            primaryWeight = MyServices.mGetPrimaryWeight(
                sharedPreferences: sharedPreferences);
            isSetPrimaryWeight = true;

            //get Graph data
            encodedMinWeightList = MyServices.mGetEncodedMaxMinWeightList(
                sharedPreferences)['min'];
            encodedMaxWeightList = MyServices.mGetEncodedMaxMinWeightList(
                sharedPreferences)['max'];
            /* encodedCurrentWeightList =
                MyServices.mGetEncodedCurrentWeightList(sharedPreferences) == ''
                    ? '[{}]'
                    : MyServices.mGetEncodedCurrentWeightList(
                        sharedPreferences); */
            encodedCurrentWeightList =
                MyServices.mGetEncodedCurrentWeightList(sharedPreferences);

            /* Map<String, dynamic> decodedMinWeightList =
                jsonDecode(encodedMinWeightList); */
            var decodedMinWeightList = jsonDecode(encodedMinWeightList);
            var decodedMaxWeightList = jsonDecode(encodedMaxWeightList);

            for (var element in decodedMinWeightList) {
              minOjonList.add(OjonModel.fromJson(element));
            }
            for (var element in decodedMaxWeightList) {
              maxOjonList.add(OjonModel.fromJson(element));
            }
            if (encodedCurrentWeightList != null) {
              var decodedCurrentWeightList =
                  jsonDecode(encodedCurrentWeightList!);
              for (var element in decodedCurrentWeightList) {
                currentOjonList.add(OjonModel.fromJson(element));
              }
            }

            // Ojon ojon = Ojon.fromJson(decodedMinWeightList);
            // print("decoded: ${decodedMinWeightList[0]}");
            // print("Ojon ${ojon.week}");
            /*    encodedMinWeightList =
                sharedPreferences.getString('encodedMinWeightList')!;
            encodedMaxWeightList =
                sharedPreferences.getString('encodedMaxWeightList')!; */

            /*   print(
                "data: $data"); */ /*  sharedPreferences.getString('encodedMinWeightList') */
            /*  final List<MaxMinWeightListModel> list =
                MyServices.mGetMaxMinWeihtList(
                    // oldWeightList: currentWeightsList,
                    isItFirsttime: false,
                    runningWeeks: _runningWeeks,
                    oldWeightList: currentWeightsList,
                    bmi: sharedPreferences.getDouble(MyKeywords.primaryBMI)!,
                    primaryWeight: primaryWeight);
            for (var i = 0; i < list.length; i++) {
              MaxMinWeightListModel listModel = list[i];
              maxOjonList = listModel.maxWeightList;
              minOjonList = listModel.minWeightList;
              currentOjonList = listModel.currentOjonList;
              /* for (var element in currentOjonList) {
                print(element.week + ": " + element.weight);
              } */
            } */

            /*  print('maxOjon: ${maxOjonList[0].weight}');
            print('minOjon: ${minOjonList[0].weight}');
            print('currentOjon: ${currentOjonList[0].weight}'); */
          });

          /*   setState(() {
            
          }); */
/* 
          for (var element in maxOjonList) {
            print("${element.week} - ${element.weight}");
          } */
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("after build: $encodedMinWeightList");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const CustomText(
          text: 'ওজন',
          fontsize: 24,
          fontcolor: MyColors.textOnPrimary,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: MyColors.pink2,
        actions: [
          IconButton(
              onPressed: () {
                //show ojon input dialog
                showDialog(
                    context: context,
                    builder: (context) => isSetPrimaryWeight
                        ? InputOjonDialog(
                            currentRoundValue: _currentRoundValue,
                            currentFrucValueAsInt: _currentFrucValueAsInt,
                            runningWeeks: _runningWeeks,
                            callback: (double w) async {
                              _lastUpdatedWeight = w;
                              _currentRoundValue = _lastUpdatedWeight.floor();
                              MyServices.mSetFrucValueAsInt(
                                  priWeight: _lastUpdatedWeight,
                                  callback: (int value) {
                                    _currentFrucValueAsInt = value;
                                  });
                              MyServices.mSetLastUpdatedWeight(
                                  sharedPreferences: sharedPreferences, w: w);
                              currentWeightsListForGraph =
                                  MyServices.mUpdateCurrentWeightList(
                                      sharedPreferences: sharedPreferences,
                                      updatedWeight: w,
                                      actRunningWeek: _actualWeeks);
                              /*  print("Current weightlist : " +
                                  currentWeightsListDoubleformat.toString()); */
                              // print(list.toString());

                              //get graph data
                              currentOjonList =
                                  await MyServices.mGetCurrentMomWeightList(
                                      sharedPreferences: sharedPreferences,
                                      primaryWeight: primaryWeight,
                                      oldWeightList: currentWeightsListForGraph,
                                      runningWeeks: _runningWeeks);

                              //print currentOjonList
                              /*  for (var i = 0;
                                    i < currentOjonList.length;
                                    i++) {
                                  Ojon ojon = currentOjonList[i];
                                  print("Ojon " + ojon.weight);
                                } */

                              currentWeightsList =
                                  /* sharedPreferences
                                      .getStringList(MyKeywords.weightList)!; */
                                  MyServices.mGetWeightList(
                                      sharedPreferences: sharedPreferences);

                              /*  final List<MaxMinWeightListModel> list =
                                    MyServices.mGetMaxMinWeihtList(
                                        oldWeightList: currentWeightsList,
                                        bmi: sharedPreferences
                                            .getDouble(MyKeywords.primaryBMI)!,
                                        primaryWeight: primaryWeight);
                                for (var i = 0; i < list.length; i++) {
                                  MaxMinWeightListModel listModel = list[i];
                                  maxOjonList = listModel.maxWeightList;
                                  minOjonList = listModel.minWeightList;
                                  currentOjonList = listModel.currentWeightList;
                                } */

                              setState(() {});
                            },
                          )
                        : InputPrimaryOjonDialog(
                            callBack: (double w, double h) {
                              mPrimaryScreenUpdate(w, h);
                              /* 
                              setState(() {
                                MyServices.mCalcAndSavePriBMI(
                                    sharedPreferences: sharedPreferences,
                                    weight: w,
                                    height: h);
                                primaryWeight = w;
                                isSetPrimaryWeight = true;
                              //for existed weight
                                MyServices.mSetLastUpdatedWeight(
                                    sharedPreferences: sharedPreferences, w: w);
                                _lastUpdatedWeight =
                                    MyServices.mGetLastUpdatedWeight(
                                        sharedPreferences: sharedPreferences);
                                _currentRoundValue = _lastUpdatedWeight.floor();
                                MyServices.mSetFrucValueAsInt(
                                    priWeight: _lastUpdatedWeight,
                                    callback: (int value) {
                                      _currentFrucValueAsInt = value;
                                    });
                              });
                             */
                            },
                          ));
              },
              icon: Image.asset(
                'lib/assets/images/add_note_weight_icon.png',
                color: Colors.white,
              )),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //v: Ojon and Week List
              OjonAndWeekListWidget(
                  primaryWeight: primaryWeight,
                  currentWeights: currentWeightsList),
              const SizedBox(
                height: 10,
              ),

              //v: Graph List
              GraphWidget(
                primaryWeight: primaryWeight,
                maxOjonList: maxOjonList,
                minOjonList: minOjonList,
                currentOjonList: currentOjonList,
                isSetPrimaryWeight: isSetPrimaryWeight,
                callback: (double w, double h) {
                  mPrimaryScreenUpdate(w, h);

                  /* 
                  setState(() {
                    MyServices.mCalcAndSavePriBMI(
                        sharedPreferences: sharedPreferences,
                        weight: w,
                        height: h);
    
                    primaryWeight = w;
                    isSetPrimaryWeight = true;
    
                    //for existed weight
                    MyServices.mSetLastUpdatedWeight(
                        sharedPreferences: sharedPreferences, w: w);
                    _lastUpdatedWeight = MyServices.mGetLastUpdatedWeight(
                        sharedPreferences: sharedPreferences);
                    _currentRoundValue = _lastUpdatedWeight.floor();
                    MyServices.mSetFrucValueAsInt(
                        priWeight: _lastUpdatedWeight,
                        callback: (int value) {
                          _currentFrucValueAsInt = value;
                        });
                  });
                 */
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mPrimaryScreenUpdate(double w, double h) async {
    MyServices.mCalcAndSavePriBMI(
        sharedPreferences: sharedPreferences, weight: w, height: h);
    primaryWeight = w;
    isSetPrimaryWeight = true;
    MyServices.mSetLastUpdatedWeight(
        sharedPreferences: sharedPreferences, w: w);
    _lastUpdatedWeight =
        MyServices.mGetLastUpdatedWeight(sharedPreferences: sharedPreferences);
    _currentRoundValue = _lastUpdatedWeight.floor();
    MyServices.mSetFrucValueAsInt(
        priWeight: _lastUpdatedWeight,
        callback: (int value) {
          _currentFrucValueAsInt = value;
        });

    //get Graph data
    final List<MaxMinWeightListModel> list =
        await MyServices.mGetMaxMinWeihtList(
            // oldWeightList: currentWeightsList,
            isItFirsttime: true,
            runningWeeks: _runningWeeks,
            oldWeightList: currentWeightsListForGraph,
            bmi: sharedPreferences.getDouble(MyKeywords.primaryBMI)!,
            primaryWeight: primaryWeight);
    for (var i = 0; i < list.length; i++) {
      MaxMinWeightListModel listModel = list[i];
      maxOjonList = listModel.maxWeightList;
      minOjonList = listModel.minWeightList;
      currentOjonList = listModel.currentOjonList;
    }

    setState(() {});
  }
}
