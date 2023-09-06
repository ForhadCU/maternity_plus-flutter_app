// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.date_format.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/models/model.current_baby_info.dart';
import 'package:maa/models/model.mom_info.dart';
import 'package:maa/views/screens/shagotom/scr.shagotom.dart';
import 'package:maa/views/widgets/dot_blink_loader.dart';
import 'package:maa/consts/const.colors.dart';

class SwitchBabyAccountScreen extends StatefulWidget {
  final CurrentBabyInfo currentBabyInfo;
  final MomInfo momInfo;
  const SwitchBabyAccountScreen(
      {Key? key, required this.currentBabyInfo, required this.momInfo})
      : super(key: key);

  @override
  State<SwitchBabyAccountScreen> createState() =>
      _SwitchBabyAccountScreenState();
}

class _SwitchBabyAccountScreenState extends State<SwitchBabyAccountScreen> {
  List<CurrentBabyInfo>? _listInactiveBabyInfo;
  @override
  void initState() {
    super.initState();
    mLoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.pink2,
        title: const Text("Switch Baby Account"),
      ),
      body: Container(
        height: MyScreenSize.mGetHeight(context, 100),
        width: MyScreenSize.mGetWidth(context, 100),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: _listInactiveBabyInfo == null
            ? DotBlickLoader()
            : Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 0),
                decoration:
                    BoxDecoration(border: Border.all(color: MyColors.pink6)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        "From",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  vCurrentBaby(),
                  Divider(
                    thickness: 1.5,
                    color: MyColors.pink6,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        "To",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  vBabyList(),
                ]),
              ),
      ),
    );
  }

  Widget vBabyList() {
    return ListView.builder(
        itemCount: _listInactiveBabyInfo!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          CurrentBabyInfo inactiveBabyInfo = _listInactiveBabyInfo![index];
          return Column(
            children: [
              ListTile(
                onTap: () {
                  mAction(inactiveBabyInfo);
                },
                title: Text(inactiveBabyInfo.babyName),
                // titleAlignment: ListTileTitleAlignment.center,
                subtitle: Text(
                    "Date of Birth: ${CustomDateForamt.mFormateDate2(DateTime.parse(inactiveBabyInfo.dob))}"),
                leading: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.black45,
                  // color: MyColors.pink6,
                ),
              ),
              Divider(
                color: Colors.black12,
                height: 0,
              )
            ],
          );
        });
  }

  void mLoadData() async {
    _listInactiveBabyInfo = await MySqfliteServices.mFetchAllInactiveBabiesInfo(
      momId: widget.momInfo.momId,
      email: widget.momInfo.email,
    );

    setState(() {});
  }

  void mAction(CurrentBabyInfo currentBabyInfo) async {
    await MySqfliteServices.mUpdateActiveStatusOfBaby(
        currentBabyInfo.email, currentBabyInfo.babyId, currentBabyInfo.momId);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return ShagotomScreen(momInfo: widget.momInfo);
    }));
  }

  Widget vCurrentBaby() {
    return ListTile(
      title: Text(widget.currentBabyInfo.babyName),
      // titleAlignment: ListTileTitleAlignment.center,
      subtitle: Text(
          "Date of Birth: ${CustomDateForamt.mFormateDate2(DateTime.parse(widget.currentBabyInfo.dob))}"),
      leading: Icon(
        Icons.arrow_forward_ios_outlined,
        color: MyColors.pink6,
      ),
    );
  }
}
