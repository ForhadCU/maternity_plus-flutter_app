// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';


import 'widgets/wdgt.scale_dynamic_blocks.dart';
import 'widgets/wdgt.scale_heading.dart';
import 'widgets/wdgt.scale_instruction.dart';
import 'widgets/wdgt.scale_months.dart';
import 'widgets/wdgt.scale_serial_no.dart';
import 'widgets/wdgt.scale_static_blocks.dart';
import 'widgets/wdgt.scale_survive.dart';

class ScalScreen extends StatefulWidget {
  final int runningDays;
  final int totalRunningDays;
  final int runningWeeks;
  final int runningMonths;
  final int totalRemaingingDays;
  final List<Color> timestarColorList;

  const ScalScreen(
      {Key? key,
      required this.runningDays,
      required this.runningWeeks,
      required this.totalRemaingingDays,
      required this.totalRunningDays,
      required this.timestarColorList,
      required this.runningMonths})
      : super(key: key);

  @override
  State<ScalScreen> createState() => _ScalScreenState();
}

class _ScalScreenState extends State<ScalScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MyScreenSize.mGetHeight(context, 7),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              fontsize: 16,
              text: 'Scale',
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: InteractiveViewer(
          maxScale: 1.6,
          minScale: 0.6,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //vScale Part
                  SizedBox(
                    height: MyScreenSize.mGetHeight(context, 35),
                    child: Row(
                      children: [
                        //vHeading
                        ScaleHeadingView(),
                        //vBlocks
                        Container(
                          width: MyScreenSize.mGetWidth(
                              context, 96.65), //fixed screen width percentage
                          margin: EdgeInsets.only(left: 3),
                          color: MyColors.textOnPrimary,
                          child: Column(
                            children: [
                              //vSerial Number
                              Expanded(flex: 3, child: ScaleSerialNo()),

                              //vTimastar static blocks
                              Expanded(
                                  flex: 2,
                                  child: ScaleStaticBlocks(
                                    timestarColorList: widget.timestarColorList,
                                  )),

                              //vTimestar dynamic block
                              Expanded(
                                  flex: 2,
                                  child: ScaleDynamicBlocks(
                                    runningWeeks: widget.runningWeeks,
                                    timestarColorList: widget.timestarColorList,
                                  )),

                              //vMonth
                              Expanded(flex: 2, child: ScaleMonthsView()),

                              //vSurvive
                              Expanded(flex: 5, child: ScaleSurvive()),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  //vInstruction part
                  SizedBox(
                    width: MyScreenSize.mGetWidth(context, 98),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //vhorizontal line
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: MyColors.app1,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          //vInstruction Row
                          ScaleInstructionView(),
                          SizedBox(
                            height: 4,
                          ),
                          //horizontal line
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: MyColors.app1,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //vRemainingDays Textview
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: '${MaaData.running} ${MyServices.getBangNumFormat(widget.runningWeeks + 1)} ${MaaData.week} (${MyServices.getBangNumFormat(widget.runningMonths)} ${MaaData.month}), ${MyServices.getBangNumFormat(MyServices.getTimestarNum(widget.runningWeeks + 1).toInt())} ${MaaData.valuelist1[1]}',
                                fontcolor: MyColors.app1,
                                fontsize: 15,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
