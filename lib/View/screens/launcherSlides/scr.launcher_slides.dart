// ignore_for_file: avoid_logger.d

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Model/model.mom_info.dart';
import 'package:splash_screen/Model/model.mom_weight.dart';
import 'package:splash_screen/Model/model.splash_slides.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';
import 'package:splash_screen/consts/const.keywords.dart';

import '../shagotom/scr.shagotom.dart';
import 'widgets/scr.slidetile_0.dart';
import 'widgets/scr.slidetile_1.dart';
import 'widgets/scr.slidetile_2.dart';
import 'widgets/scr.slidetile_3.dart';

class LauncherSlidesScreen extends StatefulWidget {
  // final bool isSignedIn;
  const LauncherSlidesScreen({
    Key? key,
    /* required this.isSignedIn */
  }) : super(key: key);

  @override
  State<LauncherSlidesScreen> createState() => _LauncherSlidesScreenState();
}

class _LauncherSlidesScreenState extends State<LauncherSlidesScreen> {
  late List<SliderModel> mySLides;
  int slideIndex = 0;
  late PageController controller;
  late int _momId;

  bool _isSaving = false;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  var logger = Logger();

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color:
            isCurrentPage ? MyColors.dotLightScreen1 : MyColors.dotDarkScreen1,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // if (!widget.isSignedIn) {
    //   mShowDialog();
    // }
    mySLides = [];
    mySLides = getSlides();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode1.unfocus();
        focusNode2.unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle()),
        body: Container(
          decoration: const BoxDecoration(
            color: MyColors.pink2,
          ),
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                color: MyColors.pink2,
                // height: MediaQuery.of(context).size.height - 100,
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      slideIndex = index;
                    });
                  },
                  children: <Widget>[
                    // SlideTile1(scrNo: mySLides[0].scrNo),
                    SlideTile0(
                      focusNode1: focusNode1,
                      focusNode2: focusNode2,
                    ),
                    const SlideTile1(),
                    const SlideTile2(),
                    const SlideTile3(),
                  ],
                ),
              ),
              bottomSheet: /* slideIndex != 3 ? */
                  Container(
                color: MyColors.pink2,

                // margin: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1, thickness: 1, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        slideIndex == 0
                            ? ElevatedButton(
                                onPressed: () {
                                  null;
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: MyColors.pink2,
                                ),
                                child: const Text(
                                  "",
                                  style: TextStyle(
                                      color: MyColors.textOnPrimary,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  controller.animateToPage(slideIndex - 1,
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.linear);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  backgroundColor: MyColors.pink2,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      MaaData.previous,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: MyColors.textOnPrimary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                        Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              i == slideIndex
                                  ? _buildPageIndicator(true)
                                  : _buildPageIndicator(false),
                          ],
                        ),

                        //part: Shongrokkhon Button
                        /* _isSaving ? const DotBlickLoader() : */ ElevatedButton(
                          onPressed: () {
                            slideIndex == 3
                                ? {
                                    /* setState(() {
                                      _isSaving = true;
                                    }), */
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            title: 'Saving..')
                                        .show(),
                                    _mRouteToMain(),
                                  }
                                : controller.animateToPage(slideIndex + 1,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.linear);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 1, backgroundColor: MyColors.pink2),
                          child: Row(
                            children: [
                              Text(
                                slideIndex == 3 ? MaaData.save : MaaData.next,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: MyColors.textOnPrimary,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  _mRouteToMain() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final db = await MySqfliteServices.dbInit();
    bool quesDataExisted;

    String sessionStart = _pref.getString(MyKeywords.sessionStart)!;
    String email = _pref.getString(MyKeywords.email)!;
    String uid = _pref.getString(MyKeywords.uid)!;
    String expectedSessionEnd = _pref.getString(MyKeywords.expectedSessionEnd)!;
    String? phone = _pref.getString(MyKeywords.phone);

    await MySqfliteServices.mIsDbTableEmpty(
            tableName: MyKeywords.momprimaryTable)
        .then((value) async => {
              await MySqfliteServices.mAddMomPrimaryDetails(
                sessionStart: sessionStart,
                expectedSessionEnd: expectedSessionEnd,
                email: email,
                uid: uid,
                phone: phone,
              ).then((value) async => {
                    // logger.d('Data inserted into BabyDetails Table: $value'),
                    if (value != null)
                      {
                        _momId = value,
                        // logger.d("Current momId: $value"),
                        /*  _babyId =
                                await MySqfliteServices.mFetchActiveBabyId(
                                    email: email, momId: value),
                            logger.d('\x1b[33m Baby id: $_babyId \x1b[0m'), */

                        quesDataExisted = await MySqfliteServices
                            .mCheckExistedQuesDataOfBabyGrowth(),
                        quesDataExisted
                            ? null
                            : {
                                for (var babyGrowthModel in MyServices
                                    .mGetInitialQuesDataOfBabyGrowth())
                                  {
                                    await MySqfliteServices
                                        .mAddInitialQuesDataOfBabyGrowth(
                                            babyGrowthModel: babyGrowthModel),
                                  },
                              },

                        // add dummy mom-weights
                        for (var i = 0; i <= 40; i++)
                          {
                            await MySqfliteServices.mAddInitialMomWeights(
                                momWeight: MomWeight.weight(
                                    email: email,
                                    momId: /* momId */ value,
                                    weekNo: i,
                                    weight: 0.00,
                                    timestamp:
                                        DateTime.now().millisecondsSinceEpoch))
                          },

                        Navigator.pop(context),

                        // c: Save current status and momId
                        _pref.setString(MyKeywords.loggedin, 'y'),
                        _pref.setInt(MyKeywords.momId, value),

                        // c: Clear previous SharedPreference data
                        _pref.remove(MyKeywords.sessionStart),
                        _pref.remove(MyKeywords.expectedSessionEnd),

                        //Go to Shagotom Screen
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: ShagotomScreen(
                                  momInfo: MomInfo(
                                      momId: value,
                                      email: email,
                                      phone: phone,
                                      expectedSessionEnd: expectedSessionEnd,
                                      sessionStart: sessionStart),
                                ),
                                type: PageTransitionType.rightToLeft))
                      }
                  })
            });
  }

  void mShowDialog() {
    /* AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.info,
            body: const Center(child: Text(
                    'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'This is Ignored',
            desc:   'This is also Ignored',
            btnOkOnPress: () {},
            ).show(); */
  }
}
