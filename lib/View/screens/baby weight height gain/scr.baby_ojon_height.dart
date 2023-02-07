import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.baby_week_month_no.dart';
import 'package:splash_screen/Model/model.baby_weights_heights_for_age.dart';
import 'package:splash_screen/Model/model.height.dart';
import 'package:splash_screen/Model/model.ojon.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/widgets/dlg_secondary_height_input.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/widgets/dlg_secondary_ojon_input.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/widgets/wdgt.heightAndWeekPart.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/widgets/wdgt.heightGraphChart.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/widgets/wdgt.ojonAndWeekPart.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/widgets/wdgt.ojonGraphChart.dart';
import 'package:splash_screen/View/widgets/dot_blink_loader.dart';
import 'package:splash_screen/consts/const.keywords.dart';

class BabyWeightHeightScreen extends StatefulWidget {
  const BabyWeightHeightScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BabyWeightHeightScreen> createState() => _BabyWeightHeightScreenState();
}

class _BabyWeightHeightScreenState extends State<BabyWeightHeightScreen> {
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
  late bool isSetPrimaryWeight = false;
  double primaryWeight = 0.00;
  List<OjonModel> currentWeightsListForGraph = [];
  List<HeightModel> currentHeightsListForGraph = [];
  List<String> currentWeightsStringList = [];
  List<String> currentHeightsStringList = [];
  List<double> minWeight = [];
  List<double> maxWeight = [];
  late SharedPreferences sharedPreferences;
  late int _actualWeeks = 0;
  late int _babyAge = 0;
  late int _currentWeightRoundValue = 0;
  late int _currentWeightFrucValueAsInt = 0;
  late int _currentHeightRoundValue = 0;
  late int _currentHeightFrucValueAsInt = 0;
  late double _lastUpdatedWeight = 0.00;
  late List<HeightModel> maxOjonList = [];
  late List<HeightModel> minOjonList = [];
  late List<HeightModel> currentOjonList = [];
  late String encodedMinWeightList;
  late String encodedMaxWeightList;
  late String? encodedCurrentWeightList;
  late String gender;
  late BabyWeightsHeightsForAge modelForWeights;
  late BabyWeightsHeightsForAge modelForHeights;
  late List<BabyWeekMonthNo> babyWeekMonthNoModelList;
  bool isLoading = true;
  late DateTime dob;
  late int runningday;
  late double lastGivenWeight;
  late double lastGivenHeight;
  late Map<String, dynamic> babyAgeMap;
  late int positionOfCurrentEntry;

  @override
  void initState() {
    // print("Size: "+MaaData.weight_for_age[0].length.toString());
    super.initState();
    MySqfliteServices.mGetCurrentBabyGender().then((value) async {
      gender = value;
      mGetGraphData();

      await MySqfliteServices.mGetCurrentBabyDob().then((value) {
        // print(value);
        dob = value;
        runningday = MyServices.mGetRunningDays(dob: dob);
        babyAgeMap = MyServices.mGetBabyAge(runningday: runningday);
        MyServices.mGetLastGivenWeight().then((map) {
          lastGivenWeight = map[MyKeywords.lastGivenWeight];
          lastGivenHeight = map[MyKeywords.lastGivenHeight];
          // positionOfCurrentEntry = map[MyKeywords.indexOfLastGivenWeight] + 1;
          _currentWeightRoundValue = lastGivenWeight.floor();
          _currentHeightRoundValue = lastGivenHeight.floor();
          MyServices.mSetFrucValueAsInt(
              priWeight: lastGivenWeight,
              callback: (int value) {
                _currentWeightFrucValueAsInt = value;
              });
          MyServices.mSetFrucValueAsInt(
              priWeight: lastGivenHeight,
              callback: (int value) {
                _currentHeightFrucValueAsInt = value;
              });
        });
      });
      // m: get weightlist
      await MySqfliteServices.mGetBabyCurrentWeightHeightList().then((value) =>
          {
            currentWeightsStringList = value[MyKeywords.babyWeight],
            currentWeightsListForGraph.clear(),
            currentWeightsListForGraph = MyServices.mMakeCurrentWeightsForGraph(
                currentWeightsStringList: currentWeightsStringList,
                babyWeekMonthNumStringList:
                    MyServices.mGetBabyWeekMonthNo()[MyKeywords.listOfOnlyNum]),
          });
      // m: get heightList
      await MySqfliteServices.mGetBabyCurrentHeightList().then((value) => {
            currentHeightsStringList = value,
            currentHeightsListForGraph.clear(),
            currentHeightsListForGraph = MyServices.mMakeCurrentHeightsForGraph(
                currentHeightsStringList: currentHeightsStringList,
                babyWeekMonthNumStringList:
                    MyServices.mGetBabyWeekMonthNo()[MyKeywords.listOfOnlyNum]),
            /*    print("Height String List"),
            for (var item in value) {print(item)},
            print("Height List for Graph"),
            for (var item in currentHeightsListForGraph)
              {print("x : ${item.xAxisValue}, y: ${item.yAxisValue}")} */
          });

      // print(currentWeightsList);

      isLoading = false;
      setState(() {});
    });

    babyWeekMonthNoModelList =
        MyServices.mGetBabyWeekMonthNo()[MyKeywords.intoBangFont];
  }

  // >>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: DotBlickLoader())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Expanded(child: CustomText(text: "ওজন নেওয়ার নিয়মঃ ...",))
                      ],)
                      ,
                      const SizedBox(height: 14,)
                      ,
                      //v: Weight for age List
                      BabyOjonAndWeekListWidget(
                        babyWeekMonthNoModelList: babyWeekMonthNoModelList,
                        currentWeights: currentWeightsStringList,
                        callBack: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return BabySecondaryOjonInputDialog(
                                  currentRoundValue: _currentWeightRoundValue,
                                  currentFrucValueAsInt:
                                      _currentWeightFrucValueAsInt,
                                  babyAgeMap: babyAgeMap,
                                  callback: (double updatedWeight) async {
                                    _currentWeightRoundValue =
                                        updatedWeight.floor();
                                    MyServices.mSetFrucValueAsInt(
                                        priWeight: updatedWeight,
                                        callback: (int value) {
                                          _currentWeightFrucValueAsInt = value;
                                        });

                                    //c: Update weight list
                                    await MySqfliteServices
                                            .mUpdateBabyCurrentWeightList(
                                                weight: updatedWeight,
                                                map: babyAgeMap)
                                        .then((value) async {
                                      var map = await MySqfliteServices
                                          .mGetBabyCurrentWeightHeightList();
                                      currentWeightsStringList =
                                          map[MyKeywords.babyWeight];
                                      /*  currentWeightsStringList =
                                          await MySqfliteServices
                                              .mGetBabyCurrentWeightList(); */

                                      currentWeightsListForGraph = MyServices
                                          .mMakeCurrentWeightsForGraph(
                                              currentWeightsStringList:
                                                  currentWeightsStringList,
                                              babyWeekMonthNumStringList:
                                                  MyServices
                                                          .mGetBabyWeekMonthNo()[
                                                      MyKeywords
                                                          .listOfOnlyNum]);
                                    });
                                    //c: data for graph and fill the blank weeks with predictable weights
                                    /*  List<double> currentWeightsToDouble =
                                        MyServices.mMakeCurrentWeightsToDouble(
                                            currentWeightsList:
                                                currentWeightsStringList);
                                    currentWeightsListForGraph.clear();
                                    currentWeightsListForGraph =
                                        await MyServices
                                            .mGetCurrentBabyWeightListForGraph(
                                                oldWeightList:
                                                    currentWeightsToDouble,
                                                positionOfCurrentEntry:
                                                    positionOfCurrentEntry,
                                                primaryWeight:
                                                    currentWeightsToDouble[0]); */
                                    setState(() {});
                                  },
                                );
                              });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //v: Weight for age Graph part
                      BabyOjonGraphChart(
                        babyWeekMonthNumStringList: MyServices
                            .mGetBabyWeekMonthNo()[MyKeywords.listOfOnlyNum],
                        title: "শিশুর ওজন গ্রাফ",
                        babyWeightsHeightsForAge: modelForWeights,
                        babyCurrentList: currentWeightsListForGraph,
                        // primaryWeight: ,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // v: Height for age list
                      BabyHeightAndWeekListWidget(
                        // primaryWeight: primaryWeight,
                        babyWeekMonthNoModelList: babyWeekMonthNoModelList,
                        currentHeights: currentHeightsStringList,
                        callBack: () {
                          mAction();
                          // showDialog();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //v: Height for age Graph part
                      BabyHeightGraphChart(
                        babyWeekMonthNumStringList: MyServices
                            .mGetBabyWeekMonthNo()[MyKeywords.listOfOnlyNum],
                        title: "শিশুর উচ্চতা গ্রাফ",
                        babyWeightsHeightsForAge: modelForHeights,
                        babyCurrentList: currentHeightsListForGraph,
                        // primaryWeight: ,
                      )
                      /*  BabyHeightGraphChart(
                        title: 'শিশুর উচ্চতা গ্রাফ',
                        babyWeightsHeightsForAge: modelForWeights,
                        babyCurrentList: [
                          HeightModel(
                              xAxisValue: 0.toString(),
                              yAxisValue: 3.toString()),
                          HeightModel(
                              xAxisValue: 1.toString(),
                              yAxisValue: 4.toString()),
                          HeightModel(
                              xAxisValue: 2.toString(),
                              yAxisValue: 5.toString()),
                          HeightModel(
                              xAxisValue: 4.toString(),
                              yAxisValue: 6.toString()),
                          HeightModel(
                              xAxisValue: 5.toString(),
                              yAxisValue: 7.toString()),
                        ],
                        // primaryWeight: ,
                      ), */
                    ],
                  ),
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
    MyServices.mSetBabyLastUpdatedWeight(
        sharedPreferences: sharedPreferences, w: w);
    _lastUpdatedWeight = MyServices.mGetBabyLastUpdatedWeight(
        sharedPreferences: sharedPreferences);
    _currentWeightRoundValue = _lastUpdatedWeight.floor();
    MyServices.mSetFrucValueAsInt(
        priWeight: _lastUpdatedWeight,
        callback: (int value) {
          _currentWeightFrucValueAsInt = value;
        });

    setState(() {});
  }

  //get Graph data
  void mGetGraphData() {
    final List<BabyWeightsHeightsForAge> list =
        MyServices.mGetBabyWeightHeightForAgeLists(gender: gender);
    modelForWeights = list[0];

    modelForHeights = list[1];
/*     minThirdStdDeviationOfHeightList =
        modelForHeights.minThirdStdDeviationOfHeightList; //[-3 SD]
    maxThirdStdDeviationOfHeightList =
        modelForHeights.maxThirdStdDeviationOfHeightList; //[+3 SD]
    minSecondStdDeviationOfHeightList =
        modelForHeights.minSecondStdDeviationOfHeightList; //[-2 SD]
    maxSecondStdDeviationOfHeightList =
        modelForHeights.maxSecondStdDeviationOfHeightList; //[+2 SD]
    minFirstStdDeviationOfHeightList =
        modelForHeights.minFirstStdDeviationOfHeightList; //[-1 SD]
    maxFirstStdDeviationOfHeightList =
        modelForHeights.maxFirstStdDeviationOfHeightList; //[+1 SD]
    medianOfHeightList = modelForHeights.medianOfHeightList; // median */
  }

  void mAction() {
    showDialog(
        context: context,
        builder: (context) {
          return BabySecondaryHeightInputDialog(
            currentRoundValue: _currentHeightRoundValue,
            currentFrucValueAsInt: _currentHeightFrucValueAsInt,
            babyAgeMap: babyAgeMap,
            callback: (double updatedHeight) async {
              _currentHeightRoundValue = updatedHeight.floor();
              MyServices.mSetFrucValueAsInt(
                  priWeight: updatedHeight,
                  callback: (int value) {
                    _currentHeightFrucValueAsInt = value;
                  });

              //c: Update height list
              await MySqfliteServices.mUpdateBabyCurrentHeightList(
                      height: updatedHeight, map: babyAgeMap)
                  .then((value) async {
                var map =
                    await MySqfliteServices.mGetBabyCurrentWeightHeightList();
                currentHeightsStringList = map[MyKeywords.babyHeight];
                /*  currentWeightsStringList =
                                          await MySqfliteServices
                                              .mGetBabyCurrentWeightList(); */

                currentHeightsListForGraph =
                    MyServices.mMakeCurrentHeightsForGraph(
                        currentHeightsStringList: currentHeightsStringList,
                        babyWeekMonthNumStringList: MyServices
                            .mGetBabyWeekMonthNo()[MyKeywords.listOfOnlyNum]);
              });
              //c: data for graph and fill the blank weeks with predictable weights
              /*  List<double> currentWeightsToDouble =
                                        MyServices.mMakeCurrentWeightsToDouble(
                                            currentWeightsList:
                                                currentWeightsStringList);
                                    currentWeightsListForGraph.clear();
                                    currentWeightsListForGraph =
                                        await MyServices
                                            .mGetCurrentBabyWeightListForGraph(
                                                oldWeightList:
                                                    currentWeightsToDouble,
                                                positionOfCurrentEntry:
                                                    positionOfCurrentEntry,
                                                primaryWeight:
                                                    currentWeightsToDouble[0]); */
              setState(() {});
            },
          );
        });
  }
}
