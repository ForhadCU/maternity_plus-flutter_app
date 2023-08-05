// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/views/screens/shaptahik%20poriborton/widget/custom_tab_view.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';
import 'package:maa/consts/const.keywords.dart';
import 'package:maa/views/widgets/my_widgets.dart';

import '../../../services/connectivity_checker_service.dart';
import '../../../view_models/connectivity_checker_vm.dart';
import '../../../view_models/shaptahik_poriborton_viewmodel.dart';

class ShaptahikPoribortonScreen extends StatefulWidget {
  final int presentWeek;
  final List<Map<String, dynamic>> mapTabData;
  const ShaptahikPoribortonScreen(
      {Key? key, required this.presentWeek, required this.mapTabData})
      : super(key: key);

  @override
  State<ShaptahikPoribortonScreen> createState() =>
      _ShaptahikPoribortonScreenState();
}

class _ShaptahikPoribortonScreenState extends State<ShaptahikPoribortonScreen>
    with TickerProviderStateMixin {
  final Logger logger = Logger();
  late TabController _tabController;
  late List<Map<String, dynamic>> mapTabData;
  late Map<String, dynamic> tab1Data;
  late Map<String, dynamic> tab2Data;
  late Map<String, dynamic> tab3Data;
  late Map<String, dynamic> tab4Data;
  late bool isConnected = false;
  late ShaptahikPoribortonViewModel _shaptahikPoribortonViewModel;
  late ConnectivityCheckerService _connectivityCheckerService;
  late ConnectivityCheckerViewModel _connectivityCheckerViewModel;

  @override
  void initState() {
    super.initState();
    _mInitialization();
    _updateTabData();
    _mCheckConnectivity();

    //set individual tab data
    /* _tabController.addListener(() {
      print(_tabController.index);

      if (_tabController.index == 3) {
        SqfliteServices.mFetchTabsData(
                MyServices.mGetWeekNoFromString(tab4Data[MyKeywords.weekNo]))
            .then((value) {
          _tabController.animation;
          setState(() {
            mapTabData = value;
          });
        });
      } else if (_tabController.index == 0) {
        SqfliteServices.mFetchTabsData(
                MyServices.mGetWeekNoFromString(tab1Data[MyKeywords.weekNo]))
            .then((value) {
          setState(() {
            mapTabData = value;
          });
        });
      }
    }); */
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tab1Data[MyKeywords.weekNo] != mapTabData[0][MyKeywords.weekNo]) {
      _updateTabData();
    }
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.pink2,
          title: CustomText(
            text: 'সাপ্তাহিক পরিবর্তন',
            fontWeight: FontWeight.w400,
            fontsize: 22,
            fontcolor: Colors.white,
          )),
      body: Column(
        children: [
          //tab header
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: MyColors.pink6, offset: Offset(0, 2), blurRadius: 1)
              ],
              color: MyColors.pink2,
            ),
            child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                onTap: (index) {
                  /* 
                  if (index == 3) {
                    SqfliteServices.mFetchTabsData(
                            MyServices.mGetWeekNoFromString(
                                tab4Data[MyKeywords.weekNo]))
                        .then((value) {
                      // _tabController.animation;
                      setState(() {
                        mapTabData = value;
                      });
                    });
                  } else if (index == 0) {
                    SqfliteServices.mFetchTabsData(
                            MyServices.mGetWeekNoFromString(
                                tab1Data[MyKeywords.weekNo]))
                        .then((value) {
                      setState(() {
                        mapTabData = value;
                      });
                    });
                  }
                */
                },
                tabs: [
                  Tab(
                    text:
                        '${MyServices.getBangNumFormat(MyServices.mGetWeekNoFromString(tab1Data[MyKeywords.weekNo]))} ${MaaData.week}',
                    height: 24,
                  ),
                  Tab(
                    text:
                        '${MyServices.getBangNumFormat(MyServices.mGetWeekNoFromString(tab2Data[MyKeywords.weekNo]))} ${MaaData.week}',
                    // text: tab2Data[MyKeywords.weekNo],
                    height: 24,
                  ),
                  Tab(
                    text:
                        '${MyServices.getBangNumFormat(MyServices.mGetWeekNoFromString(tab3Data[MyKeywords.weekNo]))} ${MaaData.week}',
                    height: 24,
                  ),
                  Tab(
                    text:
                        '${MyServices.getBangNumFormat(MyServices.mGetWeekNoFromString(tab4Data[MyKeywords.weekNo]))} ${MaaData.week}',
                    height: 24,
                  ),
                ]),
          ),
          //tab View
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              // first tab bar view widget
              CustomTavView(
                mapTabData: tab1Data,
                isConnected: isConnected,
                index: 0,
                callback: (int weekNo) {
                  _mChangeTabByClick(weekNo);
                },
              ),

              // second tab bar view widget
              CustomTavView(mapTabData: tab2Data, isConnected: isConnected),

              // third tab bar view widget
              CustomTavView(mapTabData: tab3Data, isConnected: isConnected),

              // forth tab bar view widget
              CustomTavView(
                  mapTabData: tab4Data,
                  isConnected: isConnected,
                  index: 3,
                  callback: (int weekNo) {
                    _mChangeTabByClick(weekNo);
                    /* 
                    _shaptahikPoribortonViewModel.isConnected
                        ? MySqfliteServices.mFetchForwardTabsData(weekNo)
                            .then((value) {
                            // _tabController.animation;
                            setState(() {
                              mapTabData = value;
                            });
                          })
                        : {logger.w("Please check your internet connection")};
                  */
                  }),
            ],
          )),
        ],
      ),
    );
  }

  void _updateTabData() {
    tab1Data = mapTabData[0];
    tab2Data = mapTabData[1];
    tab3Data = mapTabData[2];
    tab4Data = mapTabData[3];
  }

  void _mCheckConnectivity() async {
    _connectivityCheckerViewModel.mCheckConnectivity().then((_) {
      kDebugMode
          ? logger.w(
              "Network Connection Status: ${_connectivityCheckerViewModel.isConnected}")
          : null;
      setState(() {}); // m: Refresh UI
    });
  }

  int _mGetIndex() {
    return _shaptahikPoribortonViewModel.getInitialTabIndex(
        tabData: widget.mapTabData, presentWeek: widget.presentWeek);
  }

  void _mInitialization() {
    _connectivityCheckerService = ConnectivityCheckerService();
    _connectivityCheckerViewModel =
        ConnectivityCheckerViewModel(_connectivityCheckerService);
    _shaptahikPoribortonViewModel = ShaptahikPoribortonViewModel();

    _tabController =
        TabController(length: 4, vsync: this, initialIndex: _mGetIndex());
    mapTabData = widget.mapTabData;
  }

  void _mChangeTabByClick(int weekNo) {
    _connectivityCheckerViewModel.isConnected
        ? MySqfliteServices.mFetchBackwardTabsData(weekNo).then((value) {
            // _tabController.animation;
            setState(() {
              mapTabData = value;
            });
          })
        // : {logger.w("Please check your internet connection")};
        : MyWidgets.wDialogNoInternetConn(context: context);
  }
}
