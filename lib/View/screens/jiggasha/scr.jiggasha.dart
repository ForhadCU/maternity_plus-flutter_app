import 'package:flutter/material.dart';
import 'package:maa/Controller/services/service.my_service.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Model/model.jiggasha.dart';
import 'package:maa/View/screens/jiggasha/widget/itemview.dart';
import 'package:maa/consts/const.colors.dart';

class JiggashaScreen extends StatefulWidget {
  const JiggashaScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<JiggashaScreen> createState() => _JiggashaScreenState();
}

class _JiggashaScreenState extends State<JiggashaScreen> {
  late List<JiggashaModel> _list;
   int? clickedIndex;
  @override
  void initState() {
    super.initState();
    setState(() {
      _list = MyServices.mGetJiggashaModelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.pink2,
        title: const CustomText(
          text: 'জিজ্ঞাসা',
          fontWeight: FontWeight.w400,
          fontsize: 22,
          fontcolor: MyColors.textOnPrimary,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _list.isEmpty ? 0 : _list.length,
            itemBuilder: (context, index) {
              JiggashaModel model = _list[index];
              return JiggashaItemView(
                question: model.ques!,
                answer: model.ans!,
                isShowAns: clickedIndex == index ? true : false,
                callback: () {
                  setState(() {
                     clickedIndex = index;
                  });
                },
              );
            }),
      ),
    );
  }
}
