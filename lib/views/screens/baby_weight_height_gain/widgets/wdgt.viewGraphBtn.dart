
import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/consts/const.colors.dart';

class BabyViewGraphButton {
  static Widget viewGraphButton = Container(
    decoration: const BoxDecoration(
        color: MyColors.pink1,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))),
    margin: const EdgeInsets.only(bottom: 10),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: const CustomText(
      text: 'বিস্তারিত দেখতে গ্রাফ চাপুন',
      fontsize: 14,
      fontcolor: MyColors.textOnPrimary,
    ),
  );
}
