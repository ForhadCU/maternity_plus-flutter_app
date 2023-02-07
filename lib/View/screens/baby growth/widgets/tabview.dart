import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.baby_growth.dart';
import 'package:splash_screen/View/screens/baby%20growth/widgets/itemview.dart';
import 'package:splash_screen/View/widgets/dot_blink_loader.dart';
import 'package:splash_screen/consts/const.colors.dart';

class BabyGrowthTabView extends StatefulWidget {
  // final List<BabyGrowthModel> listBabyGrowthData;
  final bool isShown;
  final int timestar;
  final int babyId;
  final bool isAnsModifiable;
  const BabyGrowthTabView(
      {Key? key,
      // required this.listBabyGrowthData,
      required this.isAnsModifiable,
      required this.isShown,
      required this.timestar,
      required this.babyId})
      : super(key: key);

  @override
  State<BabyGrowthTabView> createState() => _BabyGrowthTabViewState();
}

class _BabyGrowthTabViewState extends State<BabyGrowthTabView> {
  late List<BabyGrowthModel> _listBabyGrowthData;
  bool _isLoadingData = true;
  @override
  void initState() {
    super.initState();
    _mLoadDataFromLocalDB();
    // print(widget.timestar);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingData
        ? const DotBlickLoader()
        : Container(
            padding:const EdgeInsets.all(4),
            child: Column(
              children: [
                // v: notice
                widget.isShown == false ? vNotice() : Container(),

                // v: Questions
                vQuestions(),
              ],
            ),
          );
  }

  void _mLoadDataFromLocalDB() async {
    _listBabyGrowthData = await MySqfliteServices.mFetchBabyGrowthQues(
        babyId: widget.babyId, timestar: widget.timestar);
    setState(() {
      _isLoadingData = false;
    });
  }

  void _mUpdateAnswerStatus(babyId, quesId, int status) async {
    await MySqfliteServices.mUpdateAnswerStatus(
        babyId: babyId, quesId: quesId, status: status);
  }

  Widget vQuestions() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount:
              _listBabyGrowthData.isEmpty ? 0 : _listBabyGrowthData.length,
          itemBuilder: (context, index) {
            BabyGrowthModel babyGrowth = _listBabyGrowthData[index];
            // print(babyGrowth.toJsonInitialQuesData());
            return BabyGrowthItemView(
              babyGrowth: babyGrowth,
              isShown: widget.isShown,
              isAnsModifiable: widget.isAnsModifiable,
              callBack: (int status) {
                _mUpdateAnswerStatus(
                    babyGrowth.babyId, babyGrowth.ques_id, status);
              },
            );
          }),
    );
  }

  Widget vNotice() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Expanded(
                  child: CustomText(
                text: "Notice: goes here..",
                fontcolor: MyColors.pink2,
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
