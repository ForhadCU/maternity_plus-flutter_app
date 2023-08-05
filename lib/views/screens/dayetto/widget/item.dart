
import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';

class ListItemDayetto extends StatelessWidget {
  final String title;
  final String desc;
  final String? imgUrl;
  const ListItemDayetto(
      {Key? key, required this.title, required this.desc, this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical:8),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

//title
            CustomText(
              text: title,
              fontWeight: FontWeight.bold,
              fontsize: 14,
            ),
            const SizedBox(
              height: 8,
            ),

//description
            CustomText(
              text: desc,
              fontsize: 14,
            ),
            const SizedBox(
              height: 4,
            ),

//image
            imgUrl != ''
                ? Image(image: AssetImage(imgUrl!))
                : Container(),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
          ]),
    );
  }
}
