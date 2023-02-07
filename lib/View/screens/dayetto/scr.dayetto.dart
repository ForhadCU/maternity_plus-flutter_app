// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.daiyetto.dart';
import 'package:splash_screen/Model/model.emergency.dart';
import 'package:splash_screen/View/screens/emergency/widgets/item.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

class DayettoScreen extends StatelessWidget {
  const DayettoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DayettoModel> dayettoModelList = MyServices.mGetDayettoModelList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          MaaData.responsibility,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
        ),
        backgroundColor: MyColors.pink2,
      ),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dayettoModelList.isEmpty ? 0 : dayettoModelList.length,
                  itemBuilder: (context, index) {
                    DayettoModel model = dayettoModelList[index];
                    return ListItemEmergency(
                      title: model.title!,
                      desc: model.desc!,
                      imgUrl: model.imgAssetUri,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
