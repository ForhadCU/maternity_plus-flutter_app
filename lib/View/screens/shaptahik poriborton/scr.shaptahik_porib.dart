// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/View/screens/shaptahik%20poriborton/widget/custom_tab_view.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

class ShaptahikPoribortonScreen extends StatefulWidget {
  final int presentWeeks;
  final List<Map<String, dynamic>> mapTabData;
  const ShaptahikPoribortonScreen(
      {Key? key, required this.presentWeeks, required this.mapTabData})
      : super(key: key);

  @override
  State<ShaptahikPoribortonScreen> createState() =>
      _ShaptahikPoribortonScreenState();
}

class _ShaptahikPoribortonScreenState extends State<ShaptahikPoribortonScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> mapTabData;
  late Map<String, dynamic> tab1Data;
  late Map<String, dynamic> tab2Data;
  late Map<String, dynamic> tab3Data;
  late Map<String, dynamic> tab4Data;
  late bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    mapTabData = widget.mapTabData;
    _updateTabData();
    MyServices.mCheckNetworkConnection().then((value) {
      setState(() {
        if (value) {
          isConnected = true;
        } else {
          isConnected = false;
        }
      });
    }); //set individual tab data

    /* _tabController.addListener(() {
      print(_tabController.index);

      if (_tabController.index == 3) {
        SqfliteServices.mFetchTabsData(
                MyServices.mGetWeekNoFromString(tab4Data['week_no']))
            .then((value) {
          _tabController.animation;
          setState(() {
            mapTabData = value;
          });
        });
      } else if (_tabController.index == 0) {
        SqfliteServices.mFetchTabsData(
                MyServices.mGetWeekNoFromString(tab1Data['week_no']))
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
    if (tab1Data['week_no'] != mapTabData[0]['week_no']) {
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
                                tab4Data['week_no']))
                        .then((value) {
                      // _tabController.animation;
                      setState(() {
                        mapTabData = value;
                      });
                    });
                  } else if (index == 0) {
                    SqfliteServices.mFetchTabsData(
                            MyServices.mGetWeekNoFromString(
                                tab1Data['week_no']))
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
                    text: MyServices.getBangNumFormat(
                            MyServices.mGetWeekNoFromString(
                                tab1Data['week_no'])) +
                        ' ' +
                        MaaData.week,
                    height: 24,
                  ),
                  Tab(
                    text: MyServices.getBangNumFormat(
                            MyServices.mGetWeekNoFromString(
                                tab2Data['week_no'])) +
                        ' ' +
                        MaaData.week,
                    // text: tab2Data['week_no'],
                    height: 24,
                  ),
                  Tab(
                    text: MyServices.getBangNumFormat(
                            MyServices.mGetWeekNoFromString(
                                tab3Data['week_no'])) +
                        ' ' +
                        MaaData.week,
                    height: 24,
                  ),
                  Tab(
                    text: MyServices.getBangNumFormat(
                            MyServices.mGetWeekNoFromString(
                                tab4Data['week_no'])) +
                        ' ' +
                        MaaData.week,
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
                  MySqfliteServices.mFetchBackwardTabsData(weekNo)
                      .then((value) {
                    // _tabController.animation;
                    setState(() {
                      mapTabData = value;
                    });
                  });
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
                    MySqfliteServices.mFetchForwardTabsData(weekNo)
                        .then((value) {
                      // _tabController.animation;
                      setState(() {
                        mapTabData = value;
                      });
                    });
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
}
