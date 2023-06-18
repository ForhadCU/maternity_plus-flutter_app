// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:maa/Controller/services/service.colors_array.dart';
import 'package:maa/Controller/services/service.my_service.dart';
import 'package:maa/Controller/services/sqflite_services.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Controller/utils/util.date_format.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/Model/model.current_baby_info.dart';
import 'package:maa/Model/model.mom_info.dart';
import 'package:maa/View/screens/add%20new%20baby/scr.add_new_baby.dart';
import 'package:maa/View/screens/baby%20gallery/scr.baby_gallery.dart';
import 'package:maa/View/screens/baby%20growth/src.baby_growth_main.dart';
// import 'package:maa/View/screens/baby%20growth/scr.baby_growth2.dart';
import 'package:maa/View/screens/dayetto/scr.dayetto.dart';
import 'package:maa/View/screens/emergency/scr.emergency.dart';
import 'package:maa/View/screens/internet%20error/scr.internet_error.dart';
import 'package:maa/View/screens/jiggasha/scr.jiggasha.dart';
import 'package:maa/View/screens/khabar/scr.khabar.dart';
import 'package:maa/View/screens/launcherSlides/scr.launcher_slides.dart';
import 'package:maa/View/screens/note/scr.note.dart';
import 'package:maa/View/screens/ojon/scr.ojon.dart';
import 'package:maa/View/screens/pregnancySesh/scr.pregnancySesh.dart';
import 'package:maa/View/screens/shagotom/widgets/dlg_about_us.dart';
import 'package:maa/View/screens/shagotom/widgets/wdgt.shaptahikPoriborton.dart';
import 'package:maa/View/screens/shaptahik%20poriborton/scr.shaptahik_porib.dart';
import 'package:maa/View/screens/switch%20baby%20account/scr.switch_baby_acc.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';
import 'package:maa/consts/const.keywords.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../scale/scr.scale.dart';
import 'widgets/wdgt.ek_nojore.dart';

class ShagotomScreen extends StatefulWidget {
  final MomInfo momInfo;
  const ShagotomScreen({Key? key, required this.momInfo}) : super(key: key);

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

  String? email;
  String? userName;
  String? userImageUrl;

  Color _titleColor = Colors.white;

  int? babyId;

  CurrentBabyInfo? _currentBabyInfo;
  var logger = Logger();

  // late int __babyInfo!.babyId;
//>>>
  @override
  void initState() {
    super.initState();

    // if (Platform.isAndroid) PathProviderAndroid.registerWith();
    // if (Platform.isIOS) PathProviderIOS.registerWith();


    _mValueInit(); //initailize declared variable
    _mLoadData(); //load data from SharedPref
    _mGetColorList();
    //c: Get Colors array for timestar blocks
  }

  @override
  Widget build(BuildContext context) {
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
          title: const CustomText(
            text: MaaData.welcome,
            fontcolor: MyColors.textOnPrimary,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontsize: 24,
          ),
          // v: Appbar menu
          /*   actions: [
            vPopupMenuItem(),
          ], */
        ),

        drawer: Drawer(
          child: vDrawerItems(context),
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
                    vBottomSheet());
            // Container();
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
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? totalDays = MyServices.mGettotalDaysBtween(
        DateTime.now(), DateTime.parse(widget.momInfo.expectedSessionEnd));

    startDate = DateTime.parse(widget.momInfo.sessionStart);
    endDate = DateTime.parse(widget.momInfo.expectedSessionEnd);

    totalRunningDays = MyServices.mGettotalDaysBtween(startDate, today);
    email = pref.getString(MyKeywords.email);
    userName = pref.getString(MyKeywords.username);
    userImageUrl = pref.getString(MyKeywords.userImageUrl);
    // logger.d("User image url: $userImageUrl");

    _currentBabyInfo = await MySqfliteServices.mFetchActiveBabyInfo(
        email: email!, momId: widget.momInfo.momId);
    _currentBabyInfo != null ? babyId = _currentBabyInfo!.babyId : null;
    logger.i("Baby id: $babyId ");
    setState(() {
      runningDays = (totalRunningDays % 7);
      previousWeeks = (totalRunningDays / 7).floor();
      runningMonths = (totalRunningDays / 30).ceil();
      //get present running week number
      presentWeeks = MyServices.mPresentWeekCalc(totalRunningDays);

      totalRemaingingDays = totalDays - totalRunningDays;

      pref.setInt(MyKeywords.runningDays, runningDays);
      pref.setInt(MyKeywords.totalRunningDays, totalRunningDays);
      pref.setInt(MyKeywords.actualRunningWeeks, previousWeeks);
      pref.setInt(MyKeywords.runningMonths, runningMonths);
      pref.setInt(MyKeywords.totalRemaingingDays, totalRemaingingDays);
    });

    MySqfliteServices.mIsDbTableEmpty(tableName: MyKeywords.weeklychangesTable)
        .then((value) {
      MySqfliteServices.mAddWeeklyChangeData(value).then((value) => {
            MySqfliteServices.mFetchForwardTabsData(presentWeeks).then((map) {
              setState(() {
                mapTabsData = map;
                bool? isAgreed = pref.getBool(MyKeywords.agreementStatus);
                if (isAgreed == null || !isAgreed) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: vAgreementDialog(pref),
                        );
                      });
                }
              });
            })
          });
    });
  }

  void _mGetColorList() async {
    timestarColorList = await MyColorArray.mGetTimestartColorArray();
    // logger.d(timestartColorList.length);
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
      return PregnancySeshScreen(
        momInfo: widget.momInfo,
      );
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

  Widget vPopupMenuItem() {
    return PopupMenuButton(
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
            value: 1,
            child: CustomText(
              text: 'প্রেগন্যান্সি শেষ করুন',
            ),
          ));
          list.add(PopupMenuDivider(
            height: 2,
          ));
          list.add(PopupMenuItem(
            value: 2,
            child: CustomText(
              text: 'পূর্বের ইতিহাস',
            ),
          ));
          list.add(PopupMenuDivider(
            height: 2,
          ));
          list.add(PopupMenuItem(
            value: 3,
            child: CustomText(
              text: 'এপটি শেয়ার করুন',
            ),
          ));
          list.add(PopupMenuDivider(
            height: 2,
          ));
          list.add(PopupMenuItem(
            value: 4,
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
          ));
          list.add(PopupMenuDivider(
            height: 2,
          ));
          list.add(PopupMenuItem(
            value: 5,
            child: CustomText(
              text: 'About Us',
            ),
          ));

          return list;
        });
  }

  Widget vDrawerItems(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 100 * 60,
      child: ListView(
        children: [
          vDrawerHeader(),
          vItemPregnancyTermination(),
          vItemInitPregnancy(),
          vItemHistory(),
          Divider(
            thickness: 1.5,
          ),
          SizedBox(
            height: 12,
          ),
          vItemBabySwitch(),
          vItemNewBaby(),
          Divider(
            thickness: 1.5,
          ),
          vItemCloudSync(),
          vPurchaseStorage(),
          Divider(
            thickness: 1.5,
          ),
          vItemAppShare(),
          vItemOpinion(),
          vItemAboutUs(),
        ],
      ),
    );
  }

  Widget vDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyColors.pink2),
      accountName: Text(
        userName ?? "",
        style: TextStyle(fontSize: 18),
      ),
      accountEmail: Text(
        email ?? "",
      ),
      currentAccountPicture: userImageUrl == null
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                size: 48,
              ))
          : CircleAvatar(
              backgroundImage: NetworkImage(userImageUrl!),
              backgroundColor: Colors.transparent,
              /* child: userImageUrl == null
                  ? Icon(
                      Icons.person,
                      size: 48,
                    )
                  : Container() */
            ),
    );
  }

  Widget vBottomSheet() {
    return Container(
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
                            builder: (context) => EmergencyScreen())),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image:
                              AssetImage('lib/assets/images/emergency_i.png'),
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
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DayettoScreen())),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KhabarScreen()));
                    },
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('lib/assets/images/food_i.png'),
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
                              builder: (context) => OjonScreen(
                                    momId: widget.momInfo.momId,
                                    email: email ?? "",
                                    momInfo: widget.momInfo,
                                  )));
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NoteScreen(
                                email: email!,
                                momId: widget.momInfo.momId,
                                momInfo: widget.momInfo,
                              )));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('lib/assets/images/note_i.png'),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JiggashaScreen()));
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
                      /*  await MySqfliteServices.mGetCurrentBabyDob()
                          .then((value) {
                        // baby_runningdays = 180;
                        baby_runningdays =
                            MyServices.mGetRunningDays(dob: value);
                        // logger.d("Baby running Day : $baby_runningdays");
                        baby_runningmonths = (baby_runningdays / 30).floor();
                        /* baby_runningdays % 30 != 0
                                                ? (baby_runningdays / 30).ceil()
                                                : (baby_runningdays / 30)
                                                    .floor(); */
                      }); */

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BabyGrowthScreenMain(
                                babyId: babyId,
                                momId: widget.momInfo.momId,
                                email: email!,
                              )));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('lib/assets/images/growth.png'),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BabyGalleryScreen(
                                momInfo: widget.momInfo,
                                babyId: babyId,
                              )));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image:
                              AssetImage('lib/assets/images/baby_gallery.png'),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InternetErrorScreen()));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage("lib/assets/images/shop.png"),
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
        ));
  }

  Widget vAgreementDialog(SharedPreferences _pref) {
    return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: MaaData.agreementSubTitle_1,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: MaaData.agreementSubDesc_1),
                              ]),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: MaaData.agreementSubTitle_2,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(text: MaaData.agreementSubDesc_2),
                        SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: MaaData.agreementSubTitle_3,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(text: MaaData.agreementSubDesc_3),
                        SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: MaaData.agreementSubTitle_4,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(text: MaaData.agreementSubDesc_4),
                        SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: MaaData.agreementSubTitle_5,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(text: MaaData.agreementSubDesc_5),
                        SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: MaaData.agreementSubTitle_6,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(text: MaaData.agreementSubDesc_6),
                        SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: MaaData.agreementSubTitle_7,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(text: MaaData.agreementSubDesc_7),
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
                  mainAxisAlignment: MainAxisAlignment.end,
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
                        _pref.setBool(MyKeywords.agreementStatus, true);
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
        ));
  }

  Widget vItemNewBaby() {
    return ListTile(
      title: Text(
        "নতুন বেবী যোগ করুন",
      ),
      leading: Image(
        image: AssetImage("lib/assets/images/ic_baby.png"),
        width: 24,
        height: 24,
        color: MyColors.pink3,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddNewBaby(
            email: email!,
            momId: widget.momInfo.momId,
          );
        }));
      },
    );
  }

  Widget vItemInitPregnancy() {
    return ListTile(
      title: Text(
        "নতুন প্রেগন্যান্সি শুরু করুন",
      ),
      leading: Image(
        image: AssetImage("lib/assets/images/firstscreenlogo.png"),
        width: 24,
        height: 24,
        color: MyColors.pink3,
      ),
      // leading: Image(image: AssetImage("lib/assets/images/firstscreenlogo.png", ), width: 24, height: 24,),
      onTap: () /* async */ {
        Navigator.pop(context);
        // final _pref = await SharedPreferences
        logger.d("Session End: ${widget.momInfo.sessionEnd}");
        if (widget.momInfo.sessionEnd != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LauncherSlidesScreen();
          }));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(
            text: "Sorry! End your running pregnancy session please.",
          )));
        }
      },
    );
  }

  Widget vItemBabySwitch() {
    return ListTile(
      title: Text(
        "সুইচ বেবী একাউন্ট",
      ),
      leading: const Icon(
        Icons.arrow_forward_ios,
        color: MyColors.pink3,
      ),

      subtitle: _currentBabyInfo == null
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MyScreenSize.mGetHeight(context, 1),
                      height: MyScreenSize.mGetWidth(context, 2),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentBabyInfo!.babyName,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(CustomDateForamt.mFormateDate2(
                            DateTime.parse(_currentBabyInfo!.dob)))
                      ],
                    ),
                  ],
                ),
              ],
            ),

      // leading: Image(image: AssetImage("lib/assets/images/firstscreenlogo.png", ), width: 24, height: 24,),
      onTap: () async {
        Navigator.pop(context);

        if (babyId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sorry! You didn't add any baby yet.")));
        } else {
          var i = await MySqfliteServices.mFetchInactiveBabyInfo(
              momId: widget.momInfo.momId, email: widget.momInfo.email);
          if (i.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Sorry! You have not more than a baby to switch.")));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SwitchBabyAccountScreen(
                currentBabyInfo: _currentBabyInfo!,
                momInfo: widget.momInfo,
              );
            }));
          }
        }
      },
    );
  }

  Widget vItemPregnancyTermination() {
    return ListTile(
      title: Text(
        "প্রেগন্যান্সি শেষ করুন",
      ),
      leading: const Icon(
        Icons.flag,
        color: MyColors.pink2,
      ),
      onTap: () {
        route();
      },
    );
  }

  Widget vItemHistory() {
    return ListTile(
      title: Text(
        "পূর্বের ইতিহাস",
      ),
      leading: const Icon(
        Icons.history,
        color: MyColors.pink2,
      ),
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Comming soon.")));
      },
    );
  }

  Widget vItemAppShare() {
    return ListTile(
      title: Text(
        "অ্যাপটি শেয়ার করুন",
      ),
      leading: const Icon(
        Icons.share,
        color: MyColors.pink2,
      ),
      onTap: () {
        MyServices.mShareApp();
      },
    );
  }

  Widget vItemOpinion() {
    return ListTile(
      title: Text(
        "মতামত দিন",
      ),
      leading: const Icon(
        Icons.comment,
        color: MyColors.pink2,
      ),
      onTap: () {
        MyServices.mSendOpinion(
            toEmail: 'info@agamilabs.com',
            subject: 'মা ও শিশুর বিকাশ',
            massege: 'আপনার প্রতিক্রিয়া');
      },
    );
  }

  Widget vItemAboutUs() {
    return ListTile(
      title: Text(
        "About Us",
      ),
      leading: const Icon(
        Icons.group,
        color: MyColors.pink2,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AboutUsDialog();
            });
      },
    );
  }

  Widget vItemCloudSync() {
    return ListTile(
      title: Text(
        "ক্লাউড sync",
      ),
      leading: const Icon(
        Icons.cloud_sync,
        color: MyColors.pink2,
      ),
      onTap: () {},
    );
  }

  Widget vPurchaseStorage() {
    return ListTile(
      title: Text(
        "পারচেজ স্টোরেজ",
      ),
      leading: const Icon(
        Icons.storage,
        color: MyColors.pink2,
      ),
      onTap: () {},
    );
  }
}
