
import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/consts/const.colors.dart';

class SympPrimaryCard extends StatelessWidget {
  final String title;
  final List<String> sympIntensityList;
  final List<String> sympNameList;
  const SympPrimaryCard(
      {Key? key,
      required this.title,
      required this.sympIntensityList,
      required this.sympNameList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                color: MyColors.pink2,
                child: CustomText(
                  text: title,
                  fontWeight: FontWeight.bold,
                  fontcolor: MyColors.textOnPrimary,
                  fontsize: 16,
                ),
              ),
            ),
          ],
        ),
/*           sympNameList.len  */ Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 4, top: 5, bottom: 40),
                color: MyColors.pink3,
                child: const CustomText(
                  text: "একটি দিন নির্বাচন করুন।",
                  fontWeight: FontWeight.w400,
                  fontcolor: MyColors.textOnPrimary,
                  fontsize: 16,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
