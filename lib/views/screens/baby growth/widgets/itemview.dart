
import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/models/model.baby_growth.dart';
import 'package:maa/consts/const.colors.dart';

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
  @override
  Widget build(BuildContext context) {
    // print(widget.babyGrowth.ans_status);
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 8, right: 4),
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: MyColors.textOnPrimary, boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1)
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: widget.babyGrowth.question),
          const SizedBox(
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
                        const Text('হ্যা')
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
                        const Text('না')
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
