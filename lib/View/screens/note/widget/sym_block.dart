
import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';

class SympBlock extends StatelessWidget {
  final Color blockColor;
  const SympBlock({Key? key, required this.blockColor, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyScreenSize.mGetHeight(context, 4),
      width: MyScreenSize.mGetWidth(context, 12),
      decoration: BoxDecoration(color: blockColor, boxShadow: const [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.38), offset: Offset(1, 1), blurRadius: 0.5)
      ]),
    );
  }
}
