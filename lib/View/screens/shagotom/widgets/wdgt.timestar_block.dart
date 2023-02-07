import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';



class TimestarBlock extends StatefulWidget {
  final Color? color;
  final String? text;
  final double? width;
  final Color? fontColor;
  final bool? textRotate;
  final Alignment? contentAlignment;
  final double? margin;
  final FontWeight? fontWeight;
  final double? height;
  const TimestarBlock({
    Key? key,
    this.color,
    this.text,
    this.width,
    this.fontColor,
    this.textRotate,
    this.contentAlignment,
    this.fontWeight,
    this.height,
    this.margin,
  }) : super(key: key);

  @override
  State<TimestarBlock> createState() => _TimestarBlockState();
}

class _TimestarBlockState extends State<TimestarBlock> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.contentAlignment,
      margin: widget.margin != null
          ? EdgeInsets.all(widget.margin!)
          : const EdgeInsets.all(1),
      // height: MyScreenSize.mGetHeight(context, 1),
      width: widget.width ?? MyScreenSize.mGetWidth(context, 1.75),
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.color ?? Colors.white,
      ),
      child: widget.text != null
          ? widget.textRotate == true
              ? RotatedBox(
                  quarterTurns: -1,
                  child: CustomText(
                      fontWeight: widget.fontWeight ?? FontWeight.normal,
                      text: widget.text!,
                      fontcolor: widget.fontColor ?? Colors.black),
                )
              : CustomText(
                  fontWeight: widget.fontWeight ?? FontWeight.normal,
                  text: widget.text!,
                  fontcolor: widget.fontColor ?? Colors.black)
          : null,
    );
  }
}
