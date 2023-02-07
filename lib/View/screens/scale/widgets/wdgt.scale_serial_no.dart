import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/View/screens/shagotom/widgets/wdgt.timestar_block.dart';



class ScaleSerialNo extends StatelessWidget {
  const ScaleSerialNo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 45,
              itemBuilder: ((context, index) {
                return TimestarBlock(
                  color: Colors.white,
                  width: MyScreenSize.mGetWidth(
                    context,
                    1.85,
                  ),
                  text: index < 9
                      ? '0' + (index + 1).toString()
                      : (index + 1).toString(),
                  textRotate: true,
                  contentAlignment: Alignment.topLeft,
                );
              })),
        ],
      ),
    );
  }
}