import 'package:flutter/material.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/View/screens/shagotom/widgets/wdgt.timestar_block.dart';
import 'package:maa/consts/const.colors.dart';



class ScaleDynamicBlocks extends StatelessWidget {
  final int runningWeeks;
  final List<Color> timestarColorList;
  const ScaleDynamicBlocks({Key? key, required this.runningWeeks, required this.timestarColorList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: runningWeeks > 46 ? 45 : runningWeeks + 1,
            itemBuilder: ((context, index) {
              return TimestarBlock(
                // color: .timestarColorList[index],
                color: index == runningWeeks
                    ? MyColors.app1
                    : timestarColorList[index],
                width: MyScreenSize.mGetWidth(
                  context,
                  1.85,
                ),
              );
            })),
      ],
    );
  }
}
