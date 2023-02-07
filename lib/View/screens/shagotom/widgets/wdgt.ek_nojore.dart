import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

import 'wdgt.timestar_block.dart';

class EkNojoreView extends StatefulWidget {
  final int runningDays;
  final int runningWeeks;
  final int totalRemaingingDays;
  final List<Color> timestarColorList;
  const EkNojoreView(
      {Key? key,
      required this.runningDays,
      required this.runningWeeks,
      required this.totalRemaingingDays,
      required this.timestarColorList})
      : super(key: key);

  @override
  State<EkNojoreView> createState() => _EkNojoreViewState();
}

class _EkNojoreViewState extends State<EkNojoreView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(1, 1),
          blurRadius: 1,
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              CustomText(
                text: MaaData.glance,
                fontcolor: MyColors.pink2,
                fontWeight: FontWeight.w600,
                fontsize: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              CustomText(
                text:
                    '${widget.runningWeeks.toString()} ${MaaData.week} ${widget.runningDays.toString()} ${MaaData.day}',
                fontsize: 15,
                fontWeight: FontWeight.bold,
                fontcolor: Colors.black54,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 8,
          ),

//vTimestar static bolcks
          SizedBox(
            height: MyScreenSize.mGetHeight(context, 2.0),
            child: Row(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.timestarColorList.length,
                    itemBuilder: (context, index) {
                      return TimestarBlock(
                          color: widget.timestarColorList[index]);
                    }),
              ],
            ),
          ),
          const SizedBox(
            height: 0.5,
          ),

//vTimestar Dynamic bolcks
          SizedBox(
            height: MyScreenSize.mGetHeight(context, 2.0),
            child: Row(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        widget.runningWeeks > 40 ? 40 : widget.runningWeeks + 1,
                    itemBuilder: (context, index) {
                      return TimestarBlock(
                          color: index == widget.runningWeeks
                              ? MyColors.app1
                              : widget.timestarColorList[index]);
                    }),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 8,
          ),

          Row(
            children: [
              CustomText(
                text:
                    "${MaaData.remaining} ${widget.totalRemaingingDays.toString()} ${MaaData.day}",
                fontsize: 15,
                fontWeight: FontWeight.bold,
                fontcolor: Colors.black54,
              ),
            ],
          )
        ],
      ),
    );
  }
}
