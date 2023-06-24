import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/models/model.baby_weights_heights_for_age.dart';
import 'package:maa/views/screens/baby_growth/widgets/scr.baby_growth_tab_1.dart';
import 'package:maa/views/screens/baby_weight_height_gain/scr.baby_ojon_height.dart';
import 'package:maa/views/widgets/dot_blink_loader.dart';
import 'package:maa/consts/const.keywords.dart';

import '../../../utils/util.custom_text.dart';
import '../../../consts/const.colors.dart';

class BabyGrowthScreenMain extends StatefulWidget {
  final int? babyId;
  final int momId;
  final String email;
  const BabyGrowthScreenMain(
      {Key? key,
      required this.babyId,
      required this.momId,
      required this.email})
      : super(key: key);

  @override
  State<BabyGrowthScreenMain> createState() => _BabyGrowthScreenMainState();
}

class _BabyGrowthScreenMainState extends State<BabyGrowthScreenMain>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late SharedPreferences sharedPreferences;
  List<String> currentWeightsList = [];
  int? babyRunningMonths;

  int? babyRunningdays;

  int? _currentWeightRoundValue;

  int? _currentHeightRoundValue;

  int? _currentWeightFrucValueAsInt;

  int? _currentHeightFrucValueAsInt;

  Map<String, dynamic>? weightListMap;

  List<String>? heightList;

  Map<String, dynamic>? babyAgeMap;

  late BabyWeightsHeightsForAge modelForWeights;

  late BabyWeightsHeightsForAge modelForHeights;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // print("Baby running month: ${widget.runningMonths}");

    // m: get user current data
/*     MyServices.mGetSharedPrefIns().then((value) {
      setState(() {
        sharedPreferences = value;
        currentWeightsList =
            MyServices.mGetBabyWeightList(sharedPreferences: sharedPreferences);
      });
    }); */

    mLoadData();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          // print('Main Tab index is : ${_tabController.index}');
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// v: Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: const CustomText(
          text: 'Baby Growth',
          fontcolor: MyColors.textOnPrimary,
          fontsize: 22,
        ),
        backgroundColor: MyColors.pink2,
        // v: Action bar items
        actions: [
          InkWell(
            onTap: () {},
            child: vBackUp(),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: DotBlickLoader())
          : Column(
              children: [
                // v: Tab bar
                Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 1,
                      ),
                    ], color: MyColors.pink2),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        onTap: (index) {},
                        tabs: const [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Tab(
                              text: "শিশুর স্বাভাবিক বৃদ্ধি নিশ্চিতকরণ",
                              height: 30,
                            ),
                          ),
                          Tab(
                            text: "ওজন-উচ্চতা চার্ট",
                            height: 30,
                          )
                        ])),
                // v: TabBarView
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    BabyGrowthQuestionScreen(
                        runningMonths: babyRunningMonths,
                        momId: widget.momId,
                        email: widget.email,
                        babyId: widget.babyId),
                    BabyWeightHeightScreen(
                      momId: widget.momId,
                      babyId: widget.babyId,
                      email: widget.email,
                      currentHeightRoundValue: _currentHeightRoundValue,
                      currentWeightRoundValue: _currentWeightRoundValue,
                      currentWeightFrucValueAsInt: _currentWeightFrucValueAsInt,
                      currentHeightFrucValueAsInt: _currentHeightFrucValueAsInt,
                      weightListMap: weightListMap,
                      babyAgeMap: babyAgeMap,
                      heightList: heightList,
                      modelForHeights: modelForHeights,
                      modelForWeights: modelForWeights,
                    )
                    // Container()
                  ],
                ))
              ],
            ),
    );
  }

  Widget vBackUp() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Backup',
          fontcolor: Colors.white,
        ),
        SizedBox(
          width: 8,
        ),
        Icon(
          Icons.backup,
          color: Color.fromARGB(255, 216, 216, 216),
          size: 18,
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }

  void mLoadData() async {
    if (widget.babyId != null) {
      DateTime dob = await MySqfliteServices.mGetCurrentBabyDob(
          momId: widget.momId, babyId: widget.babyId!, email: widget.email);
      String gender = await MySqfliteServices.mGetCurrentBabyGender();

      // baby_runningdays = 180;
      babyRunningdays = MyServices.mGetRunningDays(dob: dob);
      babyRunningMonths = (babyRunningdays! / 30).floor();

      // logger.w("BB Running Months: $babyRunningMonths");

      mGetGraphData(gender: gender);

      babyAgeMap = MyServices.mGetBabyAge(runningday: babyRunningdays!);
      Map<String, dynamic> map = await MyServices.mGetLastGivenWeight(
          email: widget.email, momId: widget.momId, babyId: widget.babyId!);
      var lastGivenWeight = map[MyKeywords.lastGivenWeight];
      var lastGivenHeight = map[MyKeywords.lastGivenHeight];
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

      // m: get weightlist
      weightListMap = await MySqfliteServices.mGetBabyCurrentWeightHeightList(
        babyId: widget.babyId,
        email: widget.email,
        momId: widget.momId,
      );

      // m: get heightList
      heightList = await MySqfliteServices.mGetBabyCurrentHeightList();

      // print(currentWeightsList);
      isLoading = false;
      setState(() {});
    } else {
      // c: If no baby existed, get default Graphdata for "male"
      mGetGraphData(gender: MyKeywords.male);
      isLoading = false;

      setState(() {});
    }
  }

  void mGetGraphData({required String gender}) {
    final List<BabyWeightsHeightsForAge> list =
        MyServices.mGetBabyWeightHeightForAgeLists(gender: gender);
    modelForWeights = list[0];

    modelForHeights = list[1];
  }
}
