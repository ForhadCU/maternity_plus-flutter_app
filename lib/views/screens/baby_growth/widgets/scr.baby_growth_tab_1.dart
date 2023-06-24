import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maa/models/model.baby_growth.dart';
import 'package:maa/views/screens/baby_growth/widgets/dlg_google_signin.dart';
import 'package:maa/views/screens/baby_growth/widgets/tabview.dart';
import 'package:maa/consts/const.colors.dart';

class BabyGrowthQuestionScreen extends StatefulWidget {
  final int? runningMonths;
  final int? babyId;
  final int momId;
  final String email;
  const BabyGrowthQuestionScreen(
      {Key? key,
      required this.runningMonths,
      required this.babyId,
      required this.momId,
      required this.email})
      : super(key: key);

  @override
  State<BabyGrowthQuestionScreen> createState() =>
      _BabyGrowthQuestionScreenState();
}

class _BabyGrowthQuestionScreenState extends State<BabyGrowthQuestionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _activeTabIndex = 0;
  @override
  void initState() {
    super.initState();

    //it will call when user want to take Cloud service
    // _mCheckUser();

    // _listBabyGrowthData = MyServices.mGetBabyGrowthDummyDataList();
    /*  SqfliteServices.mIsDbTableEmpty(tableName: MaaData.TABLE_NAMES[5])
        .then((value) {}); */
    // print('Running month: ${widget.runningMonths!}');

    _tabController = TabController(
        length: 11,
        vsync: this,
        initialIndex: widget.babyId != null ? mGetInitialIndex() : 0)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          // print('index is changing..');
          setState(() {
            _activeTabIndex = _tabController.index;
            kDebugMode ? print('Index: $_activeTabIndex') : null;
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: MyColors.pink6, offset: Offset(0, 1), blurRadius: 0.5)
            ],
            color: MyColors.pink3,
          ),
          child: vTabBar(),
        ),
        Expanded(
            child: widget.babyId != null ? vTabBarView1() : vTabBarView2()),
      ],
    );
  }

  int mGetInitialIndex() {
    if (widget.runningMonths! >= 0 && widget.runningMonths! < 3) {
      return 0;
    } else if (widget.runningMonths! >= 3 && widget.runningMonths! < 6) {
      return 1;
    } else if (widget.runningMonths! >= 6 && widget.runningMonths! < 9) {
      return 2;
    } else if (widget.runningMonths! >= 9 && widget.runningMonths! < 12) {
      return 3;
    } else if (widget.runningMonths! >= 12 && widget.runningMonths! < 18) {
      return 4;
    } else if (widget.runningMonths! >= 18 && widget.runningMonths! < 24) {
      return 5;
    } else if (widget.runningMonths! >= 24 && widget.runningMonths! < 36) {
      return 6;
    } else if (widget.runningMonths! >= 36 && widget.runningMonths! < 48) {
      return 7;
    } else if (widget.runningMonths! >= 48 && widget.runningMonths! < 60) {
      return 8;
    } else if (widget.runningMonths! >= 60 && widget.runningMonths! < 72) {
      return 9;
    } /* else if (widget.runningMonths! >= 72) {
      return 10;
    } */ else {
      return 10;
    }
  }

  void _mCheckUser() {
    _auth.authStateChanges().listen((event) {
      if (event != null) {
        print('User currently signed in');

        //it's for else part

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return GoogleSignInDialog(callback: () {});
            });

        setState(() {});
      } else {
        print('User is not signed in currently');
        setState(() {});
        //show dialgo for sign in
      }
    });
  }

  void _mSetActiveTabIndex() {
    _activeTabIndex = _tabController.index;
    print('Index: $_activeTabIndex');
  }

  Widget vTabBarView1() {
    return TabBarView(
      controller: _tabController,
      children: [
        BabyGrowthTabView(
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: true,
          timestar: 1,
          babyId: widget.babyId,
          momId: widget.momId,
          email: widget.email,
          isAnsModifiable: widget.runningMonths! < 3 ? true : false,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 3 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 3 && widget.runningMonths! < 6
                  ? true
                  : false,
          timestar: 2,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 6 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 6 && widget.runningMonths! < 9
                  ? true
                  : false,

          timestar: 3,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 9 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 9 && widget.runningMonths! < 12
                  ? true
                  : false,
          timestar: 4,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 12 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 12 && widget.runningMonths! < 18
                  ? true
                  : false,

          timestar: 5,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 18 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 18 && widget.runningMonths! < 24
                  ? true
                  : false,

          timestar: 6,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 24 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 24 && widget.runningMonths! < 36
                  ? true
                  : false,

          timestar: 7,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 36 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 36 && widget.runningMonths! < 48
                  ? true
                  : false,

          timestar: 8,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 48 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 48 && widget.runningMonths! < 60
                  ? true
                  : false,

          timestar: 9,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 60 ? true : false,
          isAnsModifiable:
              widget.runningMonths! >= 60 && widget.runningMonths! < 72
                  ? true
                  : false,

          timestar: 10,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: widget.runningMonths! >= 72 ? true : false,
          isAnsModifiable: widget.runningMonths! >= 72 ? true : false,

          timestar: 11,
        ),
      ],
    );
  }

  Widget vTabBarView2() {
    return TabBarView(
      controller: _tabController,
      children: [
        BabyGrowthTabView(
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          timestar: 1,
          babyId: widget.babyId,
          momId: widget.momId,
          email: widget.email,
          isAnsModifiable: false,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,
          timestar: 2,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 3,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,
          timestar: 4,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 5,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 6,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 7,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 8,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 9,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 10,
        ),
        BabyGrowthTabView(
          momId: widget.momId,
          email: widget.email,
          babyId: widget.babyId,
          // listBabyGrowthData: _listBabyGrowthData,
          isShown: false,
          isAnsModifiable: false,

          timestar: 11,
        ),
      ],
    );
  }

  Widget vTabBar() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      indicatorColor: Colors.white,
      onTap: (index) {
        _activeTabIndex = index;
      },
      tabs: const [
        Tab(
          // text: MyServices.getBangNumFormat(1),
          text: "১ মাস",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(3),
          text: "৩ মাস",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(6),
          text: "৬ মাস",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(9),
          text: "৯ মাস",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "১ বছর",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "১.৫ বছর",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "২ বছর",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "৩ বছর",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "৪ বছর",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "৫ বছর",
          height: 24,
        ),
        Tab(
          // text: MyServices.getBangNumFormat(12),
          text: "৬ বছর",
          height: 24,
        ),
      ],
    );
  }
}
