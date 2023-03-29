import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/consts/const.keywords.dart';

import '../../../../consts/const.colors.dart';
import '../../../../consts/const.data.bn.dart';

class SlideTile3 extends StatefulWidget {
  const SlideTile3({Key? key}) : super(key: key);

  @override
  State<SlideTile3> createState() => _SlideTile3State();
}

class _SlideTile3State extends State<SlideTile3> {
  late int runingWeek;
  late int runingDay;
  late int remainingWeek;
  late int remainingDay;
  late int totalDay;
  var logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runingWeek = 0;
    runingDay = 0;
    remainingWeek = 0;
    remainingDay = 0;
    totalDay = 0;

    _calDayWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "lib/assets/images/glance.png",
            fit: BoxFit.fill,
            height: MyScreenSize.mGetHeight(context, 24),
          ),
          const SizedBox(
            height: 18,
          ),
          const Divider(
            height: 1,
            thickness: 2,
            color: MyColors.textOnPrimary,
          ),
          const SizedBox(
            height: 12,
          ),
          const CustomText(
            text: MaaData.glance,
            fontcolor: MyColors.textOnPrimary,
            fontsize: 28,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text:
                    "${MaaData.running} ${runingWeek.toString()} ${MaaData.week} ${runingDay.toString()} ${MaaData.day}",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.w400,
                fontsize: 18,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),

          //vRemainText
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text:
                    "${MaaData.remaining} ${remainingWeek.toString()} ${MaaData.week}"
                    " ${remainingDay.toString()} ${MaaData.day} ( ${totalDay.toString()} ${MaaData.day} )",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.w400,
                fontsize: 18,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _calDayWeek() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      DateTime today = DateTime.now();
      String? sDateStr = _pref.getString(MyKeywords.sessionStart);
      String? eDateStr = _pref.getString(MyKeywords.expectedSessionEnd);
      DateTime from = DateTime.parse(sDateStr!);
      DateTime to = DateTime.parse(eDateStr!);
// e: ...........
      // int totalDaysBetween = _mDiffBetweenDates(sDate, eDate);
      totalDay = MyServices.mGettotalDaysBtween(DateTime.now(), to);
      //Save totalday for later
      _pref.setInt(MyKeywords.totaldays, totalDay);

      int totalRunningDays = MyServices.mGettotalDaysBtween(from, today);
      runingWeek = (totalRunningDays / 7).floor();
      runingDay = (totalRunningDays % 7);
      int totalRemainingDays = MyServices.mGettotalDaysBtween(today, to);
      remainingWeek = (totalRemainingDays / 7).floor();
      remainingDay = (totalRemainingDays % 7);
    });
  }

/*   int _mDiffBetweenDates(DateTime sDate, DateTime eDate) {
    sDate = DateTime(sDate.year, sDate.month, sDate.day);
    eDate = DateTime(eDate.year, eDate.month, eDate.day);

    return (eDate.difference(sDate).inHours / 24).round();
  } */
}
