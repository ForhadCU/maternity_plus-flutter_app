import 'package:flutter/material.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/views/screens/shagotom/widgets/wdgt.timestar_block.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';




class ScaleInstructionView extends StatelessWidget {
  const ScaleInstructionView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //vLef side
        Expanded(
            child: Row(
          children: [
            //vHeading column
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return TimestarBlock(
                        text: MaaData.headinglist[index],
                        color: MyColors.app1,
                        fontColor: MyColors.textOnPrimary,
                        height: MyScreenSize.mGetHeight(context, 5.5),
                        fontWeight: FontWeight.bold,
                        contentAlignment: Alignment.center,
                        // textRotate: false,
                      );
                    })),
            //vValue Column
            Expanded(
                flex: 12,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return TimestarBlock(
                          text: MaaData.valuelist1[index],
                          // color: MyColors.app1,
                          // fontColor: MyColors.textOnPrimary,
                          height: MyScreenSize.mGetHeight(context, 5.5),
                          // fontWeight: FontWeight.bold,
                          contentAlignment: Alignment.centerLeft,
                          // textRotate: false,
                        );
                      }),
                )),
          ],
        )),
        //vRight side
        Expanded(
            child: Row(
          children: [
            //vValue Column
            Expanded(
                flex: 12,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return TimestarBlock(
                          text: MaaData.valuelist2[index],
                          height: MyScreenSize.mGetHeight(context, 5.5),
                          contentAlignment: Alignment.centerRight,
                          // textRotate: false,
                        );
                      }),
                )),
            //vHeading column
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return TimestarBlock(
                        text: MaaData.sLetterlist[index],
                        color: MyColors.abc[index],
                        fontColor: MyColors.textOnPrimary,
                        height: MyScreenSize.mGetHeight(context, 5.5),
                        fontWeight: FontWeight.bold,
                        contentAlignment: Alignment.center,
                        // textRotate: false,
                      );
                    })),
          ],
        )),
      ],
    );
  }
}