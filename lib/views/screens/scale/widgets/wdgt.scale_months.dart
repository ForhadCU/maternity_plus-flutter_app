import 'package:flutter/material.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/views/screens/shagotom/widgets/wdgt.timestar_block.dart';
import 'package:maa/consts/const.colors.dart';

class ScaleMonthsView extends StatelessWidget {
  const ScaleMonthsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListView.builder(
            itemCount: 11,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return TimestarBlock(
                width: index == 10
                    ? MyScreenSize.mGetWidth(context, 3.376)
                    : MyScreenSize.mGetWidth(context, 9),
                color: MyColors.pink4,
                text: index == 10 ? '' : (index + 1).toString(),
                fontColor: MyColors.textOnPrimary,
                textRotate: false,
                contentAlignment: Alignment.center,
              );
            }),
      ],
    );
  }
}
