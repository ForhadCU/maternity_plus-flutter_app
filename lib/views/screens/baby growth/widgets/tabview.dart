
import 'package:flutter/material.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/models/model.baby_growth.dart';
import 'package:maa/views/screens/baby%20growth/widgets/itemview.dart';
import 'package:maa/views/widgets/dot_blink_loader.dart';
import 'package:maa/consts/const.colors.dart';

class BabyGrowthTabView extends StatefulWidget {
  // final List<BabyGrowthModel> listBabyGrowthData;
  final bool isShown;
  final int timestar;
  final int? babyId;
  final int momId;
  final String email;
  final bool isAnsModifiable;
  const BabyGrowthTabView({
    Key? key,
    // required this.listBabyGrowthData,
    required this.isAnsModifiable,
    required this.isShown,
    required this.timestar,
    required this.babyId,
    required this.momId,
    required this.email,
  }) : super(key: key);

  @override
  State<BabyGrowthTabView> createState() => _BabyGrowthTabViewState();
}

class _BabyGrowthTabViewState extends State<BabyGrowthTabView> {
  late List<BabyGrowthModel> _listBabyGrowthData;
  bool _isLoadingData = true;
  late List<String> _listTimestarInBang;
  @override
  void initState() {
    super.initState();
    _listTimestarInBang = [
      "১ মাস",
      "৩ মাস",
      "৬ মাস",
      "৯ মাস",
      "১ বছর",
      "১.৫ বছর",
      "২ বছর",
      "৩ বছর",
      "৪ বছর",
      "৫ বছর",
      "৬ বছর"
    ];
    _mLoadDataFromLocalDB();
    // print(widget.timestar);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingData
        ? const DotBlickLoader()
        : Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                // v: notice
                widget.isShown == false
                    ? widget.babyId == null
                        ? vNotice1()
                        : vNotice2()
                    : Container(),

                // v: Questions
                vQuestions(),
              ],
            ),
          );
  }

  void _mLoadDataFromLocalDB() async {
    _listBabyGrowthData =
        await MySqfliteServices.mFetchBabyGrowthQues(timestar: widget.timestar);
    for (var i = 0; i < _listBabyGrowthData.length; i++) {
      int? status = await MySqfliteServices.mFetchAnswerStatus(
          email: widget.email,
          momId: widget.momId,
          babyId: widget.babyId,
          quesId: _listBabyGrowthData[i].ques_id);
      if (status != null) {
        _listBabyGrowthData[i].ans_status = status;
      }
    }
    setState(() {
      _isLoadingData = false;
    });
  }

  void _mUpdateAnswerStatus(String quesId, int status) async {
    await MySqfliteServices.mUpdateAnswerStatus(
      email: widget.email,
      momId: widget.momId,
      babyId: widget.babyId!,
      quesId: quesId,
      answerStatus: status,
    );
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
                _mUpdateAnswerStatus(babyGrowth.ques_id, status);
              },
            );
          }),
    );
  }

  Widget vNotice2() {
    return Column(
      children: [
        Container(
          /* decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(width: 0.5, color: MyColors.pink3)), */
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomText(
                text:
                    "শিশুর ${_listTimestarInBang[widget.timestar - 1]} বয়স থেকে এইখানে ডেটা দিতে পারবেন।",
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

  Widget vNotice1() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(width: 0.5, color: MyColors.pink3)),
          padding: const EdgeInsets.all(8),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomText(
                text: "Sorry! You didn't add any baby yet.",
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
