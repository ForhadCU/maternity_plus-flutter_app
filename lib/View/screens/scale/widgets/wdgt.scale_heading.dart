import 'package:flutter/material.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/consts/const.colors.dart';

class ScaleHeadingView extends StatelessWidget {
  const ScaleHeadingView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyScreenSize.mGetWidth(context, 2),
      color: MyColors.app1,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topCenter,
              child: const CustomText(
                text: "W",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            )),
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topCenter,
              child: const CustomText(
                text: "T",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            )),
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topCenter,
              child: const CustomText(
                text: "P",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            )),
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topCenter,
              child: const CustomText(
                text: "M",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            )),
        Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.topCenter,
              child: const CustomText(
                text: "S",
                fontcolor: MyColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            )),
      ]),
    );
  }
}