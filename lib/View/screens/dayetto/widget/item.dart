// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';

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
      padding: EdgeInsets.symmetric(vertical:8),
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
            SizedBox(
              height: 8,
            ),

//description
            CustomText(
              text: desc,
              fontsize: 14,
            ),
            SizedBox(
              height: 4,
            ),

//image
            imgUrl != ''
                ? Image(image: AssetImage(imgUrl!))
                : Container(),
            SizedBox(
              height: 4,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
          ]),
    );
  }
}
