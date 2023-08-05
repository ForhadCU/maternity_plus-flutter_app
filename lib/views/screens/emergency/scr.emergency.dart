
import 'package:flutter/material.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/models/model.emergency.dart';
import 'package:maa/views/screens/emergency/widgets/item.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<EmergencyModel> emergModelList = MyServices.mGetEmergencyModelList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          MaaData.emergency,
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
            const CustomText(
              text: MaaData.emergencyTip,
              fontWeight: FontWeight.bold,
              fontsize: 15,
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 4,)
            ,
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: emergModelList.isEmpty ? 0 : emergModelList.length,
                  itemBuilder: (context, index) {
                    EmergencyModel model = emergModelList[index];
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
