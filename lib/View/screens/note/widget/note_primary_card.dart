import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/consts/const.colors.dart';

class NoteprimaryCard extends StatelessWidget {
  final String title;
  const NoteprimaryCard({Key? key, required this.title}) : super(key: key);

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
        Row(
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
