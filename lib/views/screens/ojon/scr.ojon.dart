import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/models/model.max_min_weightlist.dart';
import 'package:maa/models/model.mom_info.dart';
import 'package:maa/models/model.mom_weight.dart';
import 'package:maa/models/model.ojon.dart';
import 'package:maa/views/screens/ojon/widgets/dlg_input_ojon.dart';
import 'package:maa/views/screens/ojon/widgets/dlg_input_primary_ojon.dart';
import 'package:maa/views/screens/ojon/widgets/wdgt.graphPart.dart';
import 'package:maa/views/screens/ojon/widgets/wdgt.ojonAndWeekPart.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.keywords.dart';

class OjonScreen extends StatefulWidget {
  final int momId;
  final String email;
  final MomInfo momInfo;
  const OjonScreen(
      {Key? key,
      required this.momId,
      required this.email,
      required this.momInfo})
      : super(key: key);

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
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    widget.momInfo.sessionEnd == null ?
    MyServices.mGetSharedPrefIns().then((value) {
      setState(() {
        encodedMinWeightList = '';
        sharedPreferences = value;
        /*  currentWeightsList =
          MyServices.mGetWeightList(sharedPreferences: sharedPreferences); */
        mLoadWeights();
        // _priWeight = sharedPreferences.getDouble(MyKeywords.primaryWeight)!;
        _actualWeeks = sharedPreferences.getInt(MyKeywords.actualRunningWeeks)!;
        _runningWeeks = _actualWeeks + 1;

        //check initially primary weight existed or not
        // e:  ...............................
        isSetPrimaryWeight = MyServices.mCheckPrimaryWeight(
            sharedPreferences: sharedPreferences);
        // logger.d(isSetPrimaryWeight);
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
            /* _lastUpdatedWeight = MyServices.mGetLastUpdatedWeight(
                sharedPreferences: sharedPreferences); */
            _lastUpdatedWeight = mGetLastUpdatedWeight();
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
            // logger.d("decoded: ${decodedMinWeightList[0]}");
            // logger.d("Ojon ${ojon.week}");
            /*    encodedMinWeightList =
                sharedPreferences.getString('encodedMinWeightList')!;
            encodedMaxWeightList =
                sharedPreferences.getString('encodedMaxWeightList')!; */

            /*   logger.d(
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
                logger.d(element.week + ": " + element.weight);
              } */
            } */

            /*  logger.d('maxOjon: ${maxOjonList[0].weight}');
            logger.d('minOjon: ${minOjonList[0].weight}');
            logger.d('currentOjon: ${currentOjonList[0].weight}'); */
          });

          /*   setState(() {
            
          }); */
          /*
          for (var element in maxOjonList) {
            logger.d("${element.week} - ${element.weight}");
          } */
        }
      });
    }): null;
  }

  @override
  Widget build(BuildContext context) {
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
          widget.momInfo.sessionEnd != null
              ? Container()
              : IconButton(
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
                                  _currentRoundValue =
                                      _lastUpdatedWeight.floor();
                                  MyServices.mSetFrucValueAsInt(
                                      priWeight: _lastUpdatedWeight,
                                      callback: (int value) {
                                        _currentFrucValueAsInt = value;
                                      });
                                  MySqfliteServices.mUpdateMomWeight(
                                      momWeight: MomWeight.weight(
                                          email: widget.email,
                                          momId: widget.momId,
                                          weekNo: _runningWeeks,
                                          weight: w,
                                          timestamp: DateTime.now()
                                              .millisecondsSinceEpoch));
                                  MyServices.mSetLastUpdatedWeight(
                                      sharedPreferences: sharedPreferences,
                                      w: w);
                                  currentWeightsListForGraph =
                                      MyServices.mUpdateCurrentWeightList(
                                          sharedPreferences: sharedPreferences,
                                          updatedWeight: w,
                                          actRunningWeek: _actualWeeks);
                                  /*  logger.d("Current weightlist : " +
                                  currentWeightsListDoubleformat.toString()); */
                                  // logger.d(list.toString());

                                  //get graph data
                                  currentOjonList =
                                      await MyServices.mGetCurrentMomWeightList(
                                          sharedPreferences: sharedPreferences,
                                          primaryWeight: primaryWeight,
                                          oldWeightList:
                                              currentWeightsListForGraph,
                                          runningWeeks: _runningWeeks);

                                  //logger.d currentOjonList
                                  /*  for (var i = 0;
                                    i < currentOjonList.length;
                                    i++) {
                                  Ojon ojon = currentOjonList[i];
                                  logger.d("Ojon " + ojon.weight);
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
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
          ),
          widget.momInfo.sessionEnd != null
              ? InkWell(
                  onTap: () {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            title: "Sorry! Start new pregnancy session.")
                        .show();
                  },
                  child: Container(
                    color: Colors.black38,
                  ),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
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

    //Update Primary Weight at 0th index in sqlite
    await MySqfliteServices.mUpdateMomWeight(
        momWeight: MomWeight.weight(
            email: widget.email,
            momId: widget.momId,
            weekNo: 0,
            weight: w,
            timestamp: DateTime.now().millisecondsSinceEpoch));

    /*  _lastUpdatedWeight =
        MyServices.mGetLastUpdatedWeight(sharedPreferences: sharedPreferences); */
    _lastUpdatedWeight = mGetLastUpdatedWeight();
    _currentRoundValue = _lastUpdatedWeight.floor();
    MyServices.mSetFrucValueAsInt(
        priWeight: _lastUpdatedWeight,
        callback: (int value) {
          _currentFrucValueAsInt = value;
        });

    //get Graph dataf

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

  void mLoadWeights() async {
    currentWeightsList =
        await MySqfliteServices.mFetchMomWeights(momInfo: widget.momInfo);
    setState(() {});
  }

  double mGetLastUpdatedWeight() {
    double lastWeight = 0;
    for (var element in currentWeightsList) {
      if (element == '0') {
        continue;
      } else {
        lastWeight = double.parse(element);
      }
    }
    return lastWeight;
  }
}
