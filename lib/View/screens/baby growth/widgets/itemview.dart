// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.baby_growth.dart';
import 'package:splash_screen/consts/const.colors.dart';

class BabyGrowthItemView extends StatefulWidget {
  final BabyGrowthModel babyGrowth;
  final bool isShown;
  final Function callBack;
  final bool isAnsModifiable;
  const BabyGrowthItemView(
      {Key? key,
      required this.babyGrowth,
      required this.isShown,
      required this.callBack,
      required this.isAnsModifiable})
      : super(key: key);

  @override
  State<BabyGrowthItemView> createState() => _BabyGrowthItemViewState();
}

class _BabyGrowthItemViewState extends State<BabyGrowthItemView> {
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    // print(widget.babyGrowth.ans_status);
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 4, left: 8, right: 4),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(color: MyColors.textOnPrimary, boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1)
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: widget.babyGrowth.question),
          SizedBox(
            height: 12,
          ),
          widget.isShown
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                            activeColor: MyColors.pink4,
                            value: 1,
                            groupValue: widget.babyGrowth.ans_status,
                            onChanged: (value) {
                              setState(() {
                                widget.isAnsModifiable
                                    ? {
                                        widget.babyGrowth.ans_status =
                                            int.parse(value.toString()),
                                        widget.callBack(value)
                                      }
                                    : null;
                              });
                            }),
                        Text('হ্যা')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.grey,
                            value: 2,
                            groupValue: widget.babyGrowth.ans_status,
                            onChanged: (value) {
                              setState(() {
                                widget.isAnsModifiable
                                    ? {
                                        widget.babyGrowth.ans_status =
                                            int.parse(value.toString()),
                                        widget.callBack(value)
                                      }
                                    : null;
                              });
                            }),
                        Text('না')
                      ],
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
