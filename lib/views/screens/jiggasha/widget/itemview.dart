import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/consts/const.colors.dart';

class JiggashaItemView extends StatefulWidget {
  final String question;
  final String answer;
  late bool isShowAns;
  final Function callback;

  JiggashaItemView(
      {Key? key,
      required this.callback,
      required this.question,
      required this.answer,
      required this.isShowAns})
      : super(key: key);

  @override
  State<JiggashaItemView> createState() => _JiggashaItemViewState();
}

class _JiggashaItemViewState extends State<JiggashaItemView> {
  // bool isShowAns = false;
  int clickNo = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          !widget.isShowAns
              ? {widget.isShowAns = true, widget.callback()}
              : widget.isShowAns = false;
        });
      },
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(1, 2), blurRadius: 1)
        ]),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MyScreenSize.mGetWidth(context, 100),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              color: MyColors.greenPlates[4],
              child: CustomText(
                text: widget.question,
                fontWeight: FontWeight.bold,
                fontcolor: MyColors.textOnPrimary,
              ),
            ),
            widget.isShowAns
                ? Container(
                    width: MyScreenSize.mGetWidth(context, 100),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    color: MyColors.redPlates[1],
                    child: CustomText(
                      text: widget.answer,
                      fontWeight: FontWeight.normal,
                      fontcolor: MyColors.textOnPrimary,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
