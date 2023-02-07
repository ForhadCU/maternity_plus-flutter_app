// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.date_format.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';
import 'package:splash_screen/consts/const.keywords.dart';

class SlideTile1 extends StatefulWidget {
  const SlideTile1({Key? key}) : super(key: key);

  @override
  State<SlideTile1> createState() => _SlideTile1State();
}

class _SlideTile1State extends State<SlideTile1> with TickerProviderStateMixin {
  DateTime startDate = DateTime.now();
  late String startDateStr;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(
      begin: 60,
      end: 100,
    ).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
        setState(() {});
      });
    _controller.forward();

    startDateStr = '';
    loadDate();
  }

  _mSelectDate(BuildContext context) async {
    DateTime? selected = startDate;
    DateTime? _firstDate = DateTime.now().add(const Duration(days: -280));
    showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: _firstDate,
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        selected = value;
        if (selected != null && selected != startDate) {
          startDate = selected!;
          setUpdatedDate(startDate.toString());
          startDateStr = CustomDateForamt.mFormateDate(startDate);
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_animation.value);
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

          //v: Calander icon
          InkWell(
            onTap: () {
              _mSelectDate(context);
         
            },
            child: Container(
              height: 100,
              width: 100,
              child: Center(
                child: AnimatedContainer(
                  height: _animation.value,
                  width: _animation.value,
                  duration: const Duration(milliseconds: 1000),
                  child: const Image(
                    image: AssetImage(
                        "lib/assets/images/ic_action_calendar_month_intro.png"),
                    // fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            /*     child: AnimatedContainer(
              padding: EdgeInsets.zero,
              duration: const Duration(milliseconds: 1000),
              width: _animation.value,
              height: _animation.value,
              decoration: const BoxDecoration(
                color: Colors.blue,
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1,1)
                  ,
                  blurRadius: 1
                )]
              ),
              child: Image.asset(
                "lib/assets/images/ic_action_calendar_month_intro.png",
                fit: BoxFit.fill,
                // height: MyScreenSize.mGetHeight(context, 14),
              ),
            ), */
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
            text: MaaData.slide_2_title,
            fontcolor: MyColors.textOnPrimary,
            fontsize: 28,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 18,
          ),
          CustomText(
            text: startDateStr,
            fontcolor: MyColors.textOnPrimary,
            fontWeight: FontWeight.w400,
            fontsize: 24,
          )
        ],
      ),
    );
  }

  void loadDate() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      //get stored value
      String d =
          (_pref.getString(MyKeywords.startdate) ?? DateTime.now().toString());
      startDate = DateTime.parse(d);
      //set value
      setDate(d);
      startDateStr = CustomDateForamt.mFormateDate(DateTime.parse(d));
    });
  }

  void setDate(String d) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(MyKeywords.startdate, d);
    });
  }

  void setUpdatedDate(String d) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(MyKeywords.startdate, d);
      prefs.setString(MyKeywords.enddate,
          DateTime.parse(d).add(const Duration(days: 280)).toString());
    });
  }
}
