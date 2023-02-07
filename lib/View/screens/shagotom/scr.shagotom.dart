// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/service.colors_array.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/View/screens/baby%20gallery/scr.baby_gallery.dart';
import 'package:splash_screen/View/screens/baby%20growth/src.baby_growth_main.dart';
// import 'package:splash_screen/View/screens/baby%20growth/scr.baby_growth2.dart';
import 'package:splash_screen/View/screens/dayetto/scr.dayetto.dart';
import 'package:splash_screen/View/screens/emergency/scr.emergency.dart';
import 'package:splash_screen/View/screens/jiggasha/scr.jiggasha.dart';
import 'package:splash_screen/View/screens/khabar/scr.khabar.dart';
import 'package:splash_screen/View/screens/note/scr.note.dart';
import 'package:splash_screen/View/screens/ojon/scr.ojon.dart';
import 'package:splash_screen/View/screens/pregnancySesh/scr.pregnancySesh.dart';
import 'package:splash_screen/View/screens/shagotom/widgets/dlg_about_us.dart';
import 'package:splash_screen/View/screens/shagotom/widgets/wdgt.shaptahikPoriborton.dart';
import 'package:splash_screen/View/screens/shaptahik%20poriborton/scr.shaptahik_porib.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';
import 'package:splash_screen/consts/const.keywords.dart';

import '../scale/scr.scale.dart';
import 'widgets/wdgt.ek_nojore.dart';

class ShagotomScreen extends StatefulWidget {
  final int babyId;
  const ShagotomScreen({Key? key, required this.babyId}) : super(key: key);

  @override
  State<ShagotomScreen> createState() => _ShagotomScreenState();
}

class _ShagotomScreenState extends State<ShagotomScreen> {
  late int runningDays;
  late int totalRunningDays;
  late int previousWeeks;
  late int presentWeeks;
  late int runningMonths;
  late int totalRemaingingDays;
  late DateTime startDate;
  late DateTime endDate;
  late DateTime today;
  late List<Color> timestarColorList;
  late int baby_runningdays;
  late int baby_runningmonths;
  double iconHeight = 38;
  double? iconWidth = 38;
  late List<Map<String, dynamic>> mapTabsData = [{}];
  // late int _babyId;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    if (Platform.isIOS) PathProviderIOS.registerWith();

    _mValueInit(); //initailize declared variable
    _mLoadData(); //load data from SharedPref
    _mGetColorList();
    //c: Get Colors array for timestar blocks
  }

  @override
  Widget build(BuildContext context) {
/*     print('runningweek: $runningWeeks');
    print('runningdays: $runningDays');
    print('Totalrunningdays: $totalRunningDays'); */
    // print('presentWeek: ${MyServices.mPresentWeekCalc(totalRunningDays)}');
    // print("MapTabsData: $mapTabsData");

    return WillPopScope(
      onWillPop: () async {
        //? show exit dialog
        mShowExitDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.pink2,
          leading: InkWell(
            onTap: () {
              //? show exit dialog
              mShowExitDialog();
            },
            child: Icon(
              Icons.arrow_back,
              color: MyColors.textOnPrimary,
            ),
          ),
          title: const CustomText(
            text: MaaData.welcome,
            fontcolor: MyColors.textOnPrimary,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontsize: 24,
          ),
          // v: Appbar menu
          actions: [
            PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (value) {
                  if (value == 1) {
                    // mStartTime();
                    route();
                    /*  Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PregnancySeshScreen();
                    })); */
                  } else if (value == 5) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AboutUsDialog();
                        });
                  } else if (value == 3) {
                    MyServices.mShareApp();
                  }
                },
                itemBuilder: (context) {
                  var list = <PopupMenuEntry<Object>>[];

                  list.add(PopupMenuItem(
                    child: CustomText(
                      text: 'প্রেগন্যান্সি শেষ করুন',
                    ),
                    value: 1,
                  ));
                  list.add(PopupMenuDivider(
                    height: 2,
                  ));
                  list.add(PopupMenuItem(
                    child: CustomText(
                      text: 'পূর্বের ইতিহাস',
                    ),
                    value: 2,
                  ));
                  list.add(PopupMenuDivider(
                    height: 2,
                  ));
                  list.add(PopupMenuItem(
                    child: CustomText(
                      text: 'এপটি শেয়ার করুন',
                    ),
                    value: 3,
                  ));
                  list.add(PopupMenuDivider(
                    height: 2,
                  ));
                  list.add(PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        MyServices.mSendOpinion(
                            toEmail: 'info@agamilabs.com',
                            subject: 'মা ও শিশুর বিকাশ',
                            massege: 'আপনার প্রতিক্রিয়া');
                      },
                      child: CustomText(
                        text: 'মতামত দিন',
                      ),
                    ),
                    value: 4,
                  ));
                  list.add(PopupMenuDivider(
                    height: 2,
                  ));
                  list.add(PopupMenuItem(
                    child: CustomText(
                      text: 'About Us',
                    ),
                    value: 5,
                  ));

                  return list;
                })
            /*  Image.asset('lib/assets/images/menu.png', width: 23, height: 23),
            const SizedBox(
              width: 10,
            ), */
          ],
        ),
        // v: Floating action button
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.pink2,
          onPressed: () {
            showFlexibleBottomSheet(
                bottomSheetColor: Colors.white,
                minHeight: 0,
                initHeight: 0.4,
                maxHeight: 1,
                anchors: [0, 0.5, 1],
                isSafeArea: true,
                context: context,
                builder: (
                  BuildContext context,
                  ScrollController scrollController,
                  double bottomSheetOffset,
                ) =>
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        // height: MyScreenSize.mGetHeight(context, 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //1st Row
                            Row(
                              children: [
                                //1
                                Expanded(
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EmergencyScreen())),
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/emergency_i.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("ইমারজেন্সি")
                                      ],
                                    ),
                                  ),
                                ),

                                //2
                                Expanded(
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DayettoScreen())),
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/responsibilities_i.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("দায়িত্ব")
                                      ],
                                    ),
                                  ),
                                ),

                                //3
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  KhabarScreen()));
                                    },
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/food_i.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("খাবার")
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            //2nd row
                            Row(
                              children: [
                                //4
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OjonScreen()));
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/line_chart_for_weight.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("ওজন")
                                      ],
                                    ),
                                  ),
                                ),
                                //5
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NoteScreen()));
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/note_i.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("নোট")
                                      ],
                                    ),
                                  ),
                                ),

                                //6
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JiggashaScreen()));
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/ic_action_help.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("জিজ্ঞাসা")
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            //3rd Row
                            Row(
                              children: [
                                //4
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      await MySqfliteServices
                                              .mGetCurrentBabyDob()
                                          .then((value) {
                                        // baby_runningdays = 180;
                                          baby_runningdays =
                                            MyServices.mGetRunningDays(
                                                dob: value);
                                        print(
                                            "Baby running Day : $baby_runningdays");
                                        baby_runningmonths =
                                           ( baby_runningdays / 30).floor();
                                        /* baby_runningdays % 30 != 0
                                                ? (baby_runningdays / 30).ceil()
                                                : (baby_runningdays / 30)
                                                    .floor(); */
                                      });
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BabyGrowthScreenMain(
                                                      babyId: widget.babyId,
                                                      runningMonths:
                                                          baby_runningmonths)));
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/growth.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("বেবি গ্রোথ")
                                      ],
                                    ),
                                  ),
                                ),

                                //5
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BabyGalleryScreen(
                                                    babyid: widget.babyId,
                                                  )));
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'lib/assets/images/baby_gallery.png'),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("বেবি গ্যালারী")
                                      ],
                                    ),
                                  ),
                                ),

                                //6
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      /*     Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OjonScreen())); */
                                      MyServices.mLaunchUrl(MaaData.baby_shop);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              "lib/assets/images/shop.png"),
                                          width: iconWidth,
                                          height: iconHeight,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text("বেবি শপ")
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )));
          },
          child: Image(
            image: AssetImage('lib/assets/images/ic_action_tiles_large.png'),
            width: 38,
            height: 38,
          ),
        ),
        // v: Parent Screen
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //vEk nojore
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ScalScreen(
                          runningDays: runningDays,
                          runningWeeks: previousWeeks,
                          runningMonths: runningMonths == 0 ? 1 : runningMonths,
                          totalRunningDays: totalRunningDays,
                          totalRemaingingDays: totalRemaingingDays,
                          timestarColorList: timestarColorList);
                    }));
                  },
                  child: EkNojoreView(
                      runningDays: runningDays,
                      runningWeeks: previousWeeks,
                      totalRemaingingDays: totalRemaingingDays,
                      timestarColorList: timestarColorList),
                ),
                SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: () {},
                  child: ShaptahikPoribortonView(
                      callback: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ShaptahikPoribortonScreen(
                            presentWeeks: presentWeeks,
                            mapTabData: mapTabsData,
                          );
                        }));
                      },
                      runningDays: runningDays,
                      runningWeeks: previousWeeks,
                      totalRunningDays: totalRunningDays),
                )
                //Shaptahik Poriborton
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mLoadData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String? s = _pref.getString(MyKeywords.startdate);
    String? e = _pref.getString(MyKeywords.enddate);
    int? totatDays = _pref.getInt(MyKeywords.totaldays);

    startDate = DateTime.parse(s!);
    endDate = DateTime.parse(e!);

    totalRunningDays = MyServices.mGettotalDaysBtween(startDate, today);

    MySqfliteServices.mGetBabyId().then((value) {
      // _babyId = value+1;
      print("babyId: ${value}");
    });

    setState(() {
      runningDays = (totalRunningDays % 7);
      previousWeeks = (totalRunningDays / 7).floor();
      runningMonths = (totalRunningDays / 30).ceil();
      //get present running week number
      presentWeeks = MyServices.mPresentWeekCalc(totalRunningDays);

      totalRemaingingDays = totatDays! - totalRunningDays;

      _pref.setInt(MyKeywords.runningDays, runningDays);
      _pref.setInt(MyKeywords.totalRunningDays, totalRunningDays);
      _pref.setInt(MyKeywords.actualRunningWeeks, previousWeeks);
      _pref.setInt(MyKeywords.runningMonths, runningMonths);
      _pref.setInt(MyKeywords.totalRemaingingDays, totalRemaingingDays);
    });

    MySqfliteServices.mIsDbTableEmpty(tableName: MaaData.TABLE_NAMES[3]).then(
        (value) => MySqfliteServices.mAddWeeklyChangeData(value).then((value) =>
            {
              MySqfliteServices.mFetchForwardTabsData(presentWeeks).then((map) {
                setState(() {
                  mapTabsData = map;
                  bool? isAgreed = _pref.getBool(MyKeywords.agreementStatus);
                  if (isAgreed == null || !isAgreed) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                                padding: EdgeInsets.all(6),
                                height: MyScreenSize.mGetHeight(context, 80),
                                child: Column(
                                  children: [
                                    // v: Title of the agreement dialog
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          CustomText(
                                            text: MaaData.agreementTitle,
                                            fontWeight: FontWeight.w500,
                                            fontsize: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Container(
                                        color: Colors.white,
                                        child: SingleChildScrollView(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: MaaData
                                                                .agreementSubTitle_1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text: MaaData
                                                                .agreementSubDesc_1),
                                                      ]),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  text: MaaData
                                                      .agreementSubTitle_2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                CustomText(
                                                    text: MaaData
                                                        .agreementSubDesc_2),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  text: MaaData
                                                      .agreementSubTitle_3,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                CustomText(
                                                    text: MaaData
                                                        .agreementSubDesc_3),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  text: MaaData
                                                      .agreementSubTitle_4,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                CustomText(
                                                    text: MaaData
                                                        .agreementSubDesc_4),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  text: MaaData
                                                      .agreementSubTitle_5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                CustomText(
                                                    text: MaaData
                                                        .agreementSubDesc_5),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  text: MaaData
                                                      .agreementSubTitle_6,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                CustomText(
                                                    text: MaaData
                                                        .agreementSubDesc_6),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  text: MaaData
                                                      .agreementSubTitle_7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                CustomText(
                                                    text: MaaData
                                                        .agreementSubDesc_7),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 12),
                                        // color: Colors.blue,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                SystemNavigator.pop();
                                              },
                                              child: CustomText(
                                                text: MaaData.disagree,
                                                fontWeight: FontWeight.w400,
                                                fontsize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 24,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _pref.setBool(
                                                    MyKeywords.agreementStatus,
                                                    true);
                                                Navigator.pop(context);
                                              },
                                              child: CustomText(
                                                text: MaaData.agree,
                                                fontWeight: FontWeight.w400,
                                                fontsize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        });
                  }
                });
              })
            }));
  }

  void _mGetColorList() async {
    timestarColorList = await MyColorArray.mGetTimestartColorArray();
    // print(timestartColorList.length);
  }

  void _mValueInit() {
    today = DateTime.now();
    runningDays = 0;
    previousWeeks = 0;
    presentWeeks = 0;
    totalRunningDays = 0;
    totalRemaingingDays = 0;
    timestarColorList = [];
  }

  void mShowExitDialog() {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.bottomSlide,
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            btnOkText: MaaData.yes,
            btnCancelText: MaaData.no,
            desc: MaaData.want_to_exit,
            // showCloseIcon: true,
            btnOkOnPress: () {
              SystemNavigator.pop();
            },
            btnCancelOnPress: () {})
        .show();
  }

/*   void mNavigate() {
    startTime() async {
      var duration = new Duration(seconds: 6);
      return new Timer(duration, route);
    }
  } */
  mStartTime() async {
    var duration = Duration(seconds: 6);
    return Timer(duration, route);
  }

  route() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PregnancySeshScreen();
    }));
  }

  mShowAgreementDialog() {
    /* AwesomeDialog(
            context: context,
            /* dialogType: DialogType.noHeader, */ title: "Title")
        .show(); */
    Dialog(
      child: CustomText(text: 'This is dialog'),
    );
  }
}
