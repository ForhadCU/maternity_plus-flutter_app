import 'package:flutter/material.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.keywords.dart';
import 'package:maa/models/model.baby_growth.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';

class BabyGrowthItemView extends StatefulWidget {
  final BabyGrowthModel babyGrowth;
  final bool isShown;
  final Function callBackForAnsStatus;
  final Function callbackForSaveInputAns;
  final Function callbackForUnFocus;
  final bool isAnsModifiable;
  final FocusNode focusNode;
  const BabyGrowthItemView(
      {Key? key,
      required this.babyGrowth,
      required this.isShown,
      required this.callBackForAnsStatus,
      required this.isAnsModifiable,
      required this.callbackForSaveInputAns,
      required this.focusNode,
      required this.callbackForUnFocus})
      : super(key: key);

  @override
  State<BabyGrowthItemView> createState() => _BabyGrowthItemViewState();
}

class _BabyGrowthItemViewState extends State<BabyGrowthItemView> {
  TextEditingController _inputFieldCtrler = TextEditingController();
  bool _isShownSaveButton = false;

  @override
  void initState() {
    super.initState();
    // logger.w("IS Shown : ${widget.isShown}");
    _mSetInputedAns();

    // logger.d("Options: ${widget.babyGrowth.options}");
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.babyGrowth.ans_status);
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 8, right: 4),
      margin: const EdgeInsets.all(3),
      decoration:
          const BoxDecoration(color: MyColors.textOnPrimary, boxShadow: [
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
              ? widget.babyGrowth.options == MyKeywords.choose
                  ? _vChoose()
                  : _vInputField()
              : Container(),
        ],
      ),
    );
  }

  _vChoose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _vYes(),
        _vNo(),
      ],
    );
  }

  _vYes() {
    return Row(
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
                        widget.callBackForAnsStatus(value)
                      }
                    : null;
              });
            }),
        const Text('হ্যা')
      ],
    );
  }

  _vNo() {
    return Row(
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
                        widget.callBackForAnsStatus(value)
                      }
                    : null;
              });
            }),
        const Text('না')
      ],
    );
  }

  _vInputField() {
    return Column(
      children: [
        TextFormField(
          onTap: () {
            widget.isAnsModifiable
                ? {
                    widget.callbackForUnFocus(),
                    setState(() {
                      _isShownSaveButton = true;
                    }),
                  }
                : null;
          },
          readOnly: !widget.isAnsModifiable,
          focusNode: widget.focusNode,
          controller: _inputFieldCtrler,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            hintText:
                widget.isAnsModifiable ? "উত্তর লিখুন" : "উত্তর দেওয়া হয়নি",
            border: OutlineInputBorder(),
          ),
        ),
        _isShownSaveButton ? _vSaveButton() : Container(),
      ],
    );
  }

  _vSaveButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _isShownSaveButton = !_isShownSaveButton;
            widget.callbackForSaveInputAns(
                _inputFieldCtrler.value.text != widget.babyGrowth.inputedAnswer
                    ? _inputFieldCtrler.value.text
                    : '');
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.pink3,
          minimumSize: Size(0, MyScreenSize.mGetHeight(context, 4)),
          // maximumSize: Size(0, MyScreenSize.mGetHeight(context, 1.5)),
        ),
        child: const CustomText(
          text: "উত্তরটি সেভ করুন",
          fontsize: 12,
          fontcolor: Colors.white,
        ));
  }

  void _mSetInputedAns() {
    var s = widget.babyGrowth.inputedAnswer;

    s != null
        ? s != ""
            ? _inputFieldCtrler.text = s
            : null
        : null;
  }
}
