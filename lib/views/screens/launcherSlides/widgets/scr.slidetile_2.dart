
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.date_format.dart';
import 'package:maa/consts/const.keywords.dart';

import '../../../../consts/const.colors.dart';
import '../../../../consts/const.data.bn.dart';

class SlideTile2 extends StatefulWidget {
  const SlideTile2({Key? key}) : super(key: key);

  @override
  State<SlideTile2> createState() => _SlideTile2State();
}

class _SlideTile2State extends State<SlideTile2>
    with SingleTickerProviderStateMixin {
  late DateTime expectedSessionEnd;
  late String expectedSessionEndStr;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    mAnimation();

    expectedSessionEndStr = "";
    loadexpectedSessionEnd();
    // calculateexpectedSessionEnd();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CustomText(
            text: MaaData.dateChange,
            fontcolor: MyColors.textOnPrimary,
            fontsize: 20,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 14,
          ),
          InkWell(
            // onTap: (){},
            onTap: () {
              _mSelectDate(context);
            },
            child: SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: AnimatedContainer(
                  height: _animation.value,
                  width: _animation.value,
                  duration: const Duration(milliseconds: 1000),
                  child: Image.asset(
                    "lib/assets/images/ic_action_calendar_month_intro.png",
                    /* fit: BoxFit.fill,
                    height: MyScreenSize.mGetHeight(context, 14), */
                  ),
                ),
              ),
            ),
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
            text: MaaData.slide_3_title,
            fontcolor: MyColors.textOnPrimary,
            fontsize: 28,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 18,
          ),
          CustomText(
            text: expectedSessionEndStr,
            fontcolor: MyColors.textOnPrimary,
            fontWeight: FontWeight.w400,
            fontsize: 24,
          )
        ],
      ),
    );
  }

  _mSelectDate(BuildContext context) {
    DateTime? selectDate = expectedSessionEnd;
    showDatePicker(
            context: context,
            initialDate: selectDate,
            firstDate: DateTime(selectDate.year - 1),
            // firstDate: DateTime(DateTime.now().year + 1),
            lastDate: selectDate.add(const Duration(days: 30)))
        .then((value) {
      setState(() {
        selectDate = value;
        if (selectDate != null && selectDate != expectedSessionEnd) {
          expectedSessionEnd = selectDate!;
          setDate(expectedSessionEnd.toString());
          expectedSessionEndStr = CustomDateForamt.mFormateDate(expectedSessionEnd);
        }
      });
    });
  }

  void setDate(String d) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      pref.setString(MyKeywords.expectedSessionEnd, d);
    });
  }

  Future<DateTime> calculateexpectedSessionEnd() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      String sDate =
          pref.getString(MyKeywords.sessionStart) ?? DateTime.now().toString();
      expectedSessionEnd = DateTime.parse(sDate).add(const Duration(days: 280));
      setDate(expectedSessionEnd.toString());
      expectedSessionEndStr = CustomDateForamt.mFormateDate(expectedSessionEnd);
    });
    return expectedSessionEnd;
  }

  void loadexpectedSessionEnd() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    calculateexpectedSessionEnd().then(
      (value) {
        setState(() {
          String d = pref.getString(MyKeywords.expectedSessionEnd) ?? value.toString();
          // calculateexpectedSessionEnd().toString();
          expectedSessionEnd = DateTime.parse(d);
          setDate(expectedSessionEnd.toString());
          expectedSessionEndStr = CustomDateForamt.mFormateDate(expectedSessionEnd);
        });
      },
    );
  }

  void mAnimation() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween<double>(begin: 60, end: 100).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      setState(() {});
    });
    _controller.forward();
  }
}
