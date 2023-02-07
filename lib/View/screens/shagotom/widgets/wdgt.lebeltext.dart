import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

class LebelText extends StatelessWidget {
  const LebelText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, -4),
            blurRadius: 12)
      ]),
      height: MyScreenSize.mGetHeight(context, 4),
      width: MyScreenSize.mGetWidth(context, 100),
      child: const CustomText(
        text: MaaData.text1,
        fontcolor: MyColors.textOnPrimary,
        fontsize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
