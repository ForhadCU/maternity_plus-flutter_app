// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Model/model.kahbar.dart';
import 'package:splash_screen/View/screens/khabar/widget/item.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

class KhabarScreen extends StatelessWidget {
  const KhabarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<KhabarModel> khabarModelList = MyServices.mGetKhabarModelList();
    int i = 0;
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
                  itemCount:
                      khabarModelList.isEmpty ? 0 : khabarModelList.length,
                  itemBuilder: (context, index) {
                    KhabarModel model = khabarModelList[index];
                    if (model.imgAssetUri != '') {
                      i++;
                    }
                    return ListItemKhabar(
                      index: index,
                      title: model.title!,
                      desc: model.desc!,
                      imgUrl: model.imgAssetUri,
                      isLeft: i % 2 == 0 ? false : true,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
