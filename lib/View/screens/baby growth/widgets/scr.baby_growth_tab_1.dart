import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.baby_growth.dart';
import 'package:splash_screen/View/screens/baby%20growth/widgets/dlg_google_signin.dart';
import 'package:splash_screen/View/screens/baby%20growth/widgets/tabview.dart';
import 'package:splash_screen/consts/const.colors.dart';

class BabyGrowthTab1Screen extends StatefulWidget {
  final runningMonths;
  final babyId;
  const BabyGrowthTab1Screen(
      {Key? key, required this.runningMonths, required this.babyId})
      : super(key: key);

  @override
  State<BabyGrowthTab1Screen> createState() => _BabyGrowthTab1ScreenState();
}

class _BabyGrowthTab1ScreenState extends State<BabyGrowthTab1Screen>
    with TickerProviderStateMixin {
  late List<BabyGrowthModel> _listBabyGrowthData;
  late TabController _tabController;
  bool _isSignedInChecking = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  int _activeTabIndex = 0;
  @override
  void initState() {
    super.initState();

    //it will call when user want to take Cloud service
    // _mCheckUser();

    _listBabyGrowthData = MyServices.mGetBabyGrowthDummyDataList();
    /*  SqfliteServices.mIsDbTableEmpty(tableName: MaaData.TABLE_NAMES[5])
        .then((value) {}); */
    // print('Running month: ${widget.runningMonths}');

    _tabController =
        TabController(length: 11, vsync: this, initialIndex: mGetInitialIndex())
          ..addListener(() {
            if (!_tabController.indexIsChanging) {
              // print('index is changing..');
              setState(() {
                _activeTabIndex = _tabController.index;
                print('Index: $_activeTabIndex');
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
    return /* Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const CustomText(
            text: 'Baby Growth',
            fontcolor: MyColors.textOnPrimary,
            fontsize: 22,
          ),
          backgroundColor: MyColors.pink2,
          actions: [
            InkWell(
              onTap: () {},
              child: Row(
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
              ),
            )
          ],
        ),
        body:  */ /* _isSignedInChecking
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 221, 213, 213)),
                ),
              )
            : */
        Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: MyColors.pink6, offset: Offset(0, 1), blurRadius: 0.5)
            ],
            color: MyColors.pink3,
          ),
          child: TabBar(
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
              ), Tab(
                // text: MyServices.getBangNumFormat(12),
                text: "৬ বছর",
                height: 24,
              ),
            ],
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            BabyGrowthTabView(
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: true,
              timestar: 1,
              babyId: widget.babyId,
              isAnsModifiable: widget.runningMonths < 3 ? true : false,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 3 ? true : false,
              isAnsModifiable:
                  widget.runningMonths >= 3 && widget.runningMonths < 6
                      ? true
                      : false,
              timestar: 2,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 6 ? true : false,
              isAnsModifiable:
                  widget.runningMonths >= 6 && widget.runningMonths < 9
                      ? true
                      : false,

              timestar: 3,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 9 ? true : false,
              isAnsModifiable:
                  widget.runningMonths >= 9 && widget.runningMonths < 12
                      ? true
                      : false,
              timestar: 4,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 12 ? true : false,
              isAnsModifiable: widget.runningMonths >= 12 ? true : false,

              timestar: 5,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 18 ? true : false,
              isAnsModifiable: widget.runningMonths >= 18 ? true : false,

              timestar: 6,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 24 ? true : false,
              isAnsModifiable: widget.runningMonths >= 24 ? true : false,

              timestar: 7,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 36 ? true : false,
              isAnsModifiable: widget.runningMonths >= 36 ? true : false,

              timestar: 8,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 48 ? true : false,
              isAnsModifiable: widget.runningMonths >= 48 ? true : false,

              timestar: 9,
            ),
            BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 60 ? true : false,
              isAnsModifiable: widget.runningMonths >= 60 ? true : false,

              timestar: 10,
            ),BabyGrowthTabView(
              babyId: widget.babyId,
              // listBabyGrowthData: _listBabyGrowthData,
              isShown: widget.runningMonths >= 72 ? true : false,
              isAnsModifiable: widget.runningMonths >= 72 ? true : false,

              timestar: 11,
            ),
          ],
        ))
      ],
    );

    //  BabyGrowthTabView(listBabyGrowthData: listBabyGrowthData),

    // );
  }

  int mGetInitialIndex() {
    if (widget.runningMonths >= 0 && widget.runningMonths < 3) {
      return 0;
    } else if (widget.runningMonths >= 3 && widget.runningMonths < 6) {
      return 1;
    } else if (widget.runningMonths >= 6 && widget.runningMonths < 9) {
      return 2;
    } else if (widget.runningMonths >= 9 && widget.runningMonths < 12) {
      return 3;
    } else {
      return 4;
    }
  }

  void _mCheckUser() {
    _user = _auth.currentUser;

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

        setState(() {
          _isSignedInChecking = false;
        });
      } else {
        print('User is not signed in currently');
        setState(() {
          _isSignedInChecking = false;
        });
        //show dialgo for sign in
      }
    });
  }

  void _mSetActiveTabIndex() {
    _activeTabIndex = _tabController.index;
    print('Index: $_activeTabIndex');
  }
}
