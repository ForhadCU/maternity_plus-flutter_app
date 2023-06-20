
import 'package:flutter/material.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/models/model.daiyetto.dart';
import 'package:maa/views/screens/emergency/widgets/item.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';

class DayettoScreen extends StatelessWidget {
  const DayettoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DayettoModel> dayettoModelList = MyServices.mGetDayettoModelList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          MaaData.responsibility,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
        ),
        backgroundColor: MyColors.pink2,
      ),
      body: Container(
        padding: const EdgeInsets.all(6),
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
