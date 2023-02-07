import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/View/screens/baby%20growth/widgets/scr.baby_growth_tab_1.dart';
import 'package:splash_screen/View/screens/baby%20weight%20height%20gain/scr.baby_ojon_height.dart';

import '../../../Controller/utils/util.custom_text.dart';
import '../../../consts/const.colors.dart';

class BabyGrowthScreenMain extends StatefulWidget {
  final babyId;
  final runningMonths;
  const BabyGrowthScreenMain(
      {Key? key, required this.babyId, required this.runningMonths})
      : super(key: key);

  @override
  State<BabyGrowthScreenMain> createState() => _BabyGrowthScreenMainState();
}

class _BabyGrowthScreenMainState extends State<BabyGrowthScreenMain>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late SharedPreferences sharedPreferences;
  List<String> currentWeightsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("Baby running month: ${widget.runningMonths}");

    // m: get user current data
/*     MyServices.mGetSharedPrefIns().then((value) {
      setState(() {
        sharedPreferences = value;
        currentWeightsList =
            MyServices.mGetBabyWeightList(sharedPreferences: sharedPreferences);
      });
    }); */

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
      body: Column(
        
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
              BabyGrowthTab1Screen(
                  runningMonths: widget.runningMonths, babyId: widget.babyId),
              const BabyWeightHeightScreen()
              // Container()
            ],
          ))
        ],
      ),
    );
  }

  Widget vBackUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
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
}
