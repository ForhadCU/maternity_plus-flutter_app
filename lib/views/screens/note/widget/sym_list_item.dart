import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/views/screens/note/widget/sym_block.dart';
import 'package:maa/consts/const.colors.dart';

class SympListItem extends StatefulWidget {
  final String sympName;
  final String sympIntesity;
  final Function callback;
  const SympListItem(
      {Key? key,
      required this.sympName,
      required this.sympIntesity,
      required this.callback})
      : super(key: key);

  @override
  State<SympListItem> createState() => _SympListItemState();
}

class _SympListItemState extends State<SympListItem> {
  Color blockColor1 = Colors.grey;
  Color blockColor2 = Colors.grey;
  Color blockColor3 = Colors.grey;
  final String low = "L";
  final String medium = "M";
  final String high = "H";
  String? key;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    key = widget.sympIntesity;
    mLoadBlockColor(widget.sympIntesity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 0.5),
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: CustomText(
                    text: widget.sympName,
                    fontcolor: Colors.black,
                    // fontsize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    if (key != low) {
                      mLoadBlockColor(low);
                      widget.callback(low);
                      key = low;
                    } else {
                      key = null;
                      //reset
                      mLoadBlockColor("");
                      widget.callback("");
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SympBlock(
                      blockColor: blockColor1,
                    )),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    if (key != medium) {
                      mLoadBlockColor(medium);
                      widget.callback(medium);
                      key = medium;
                    } else {
                      key = null;
                      //reset
                      mLoadBlockColor("");
                      widget.callback("");
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SympBlock(
                    blockColor: blockColor2,
                  ),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    if (key != high) {
                      mLoadBlockColor(high);
                      widget.callback(high);
                      key = high;
                    } else {
                      key = null;
                      //reset
                      mLoadBlockColor("");
                      widget.callback("");
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SympBlock(
                      blockColor: blockColor3,
                    )),
              )),
            ],
          ),
        ],
      ),
    );
  }

  void mLoadBlockColor(String sympIntesity) {
    if (sympIntesity == "L") {
      blockColor1 = MyColors.sympBlock1;
      blockColor2 = Colors.grey;
      blockColor3 = Colors.grey;
    } else if (sympIntesity == "M") {
      blockColor1 = MyColors.sympBlock2;
      blockColor2 = MyColors.sympBlock2;
      blockColor3 = Colors.grey;
    } else if (sympIntesity == "H") {
      blockColor1 = MyColors.sympBlock3;
      blockColor2 = MyColors.sympBlock3;
      blockColor3 = MyColors.sympBlock3;
    } else {
      blockColor1 = Colors.grey;
      blockColor2 = Colors.grey;
      blockColor3 = Colors.grey;
    }
  }
}
