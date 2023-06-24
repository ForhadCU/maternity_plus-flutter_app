import 'package:flutter/material.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/models/model.baby_week_month_no.dart';
import 'package:maa/views/screens/ojon/widgets/item_ojondataList.dart';
import 'package:maa/consts/const.colors.dart';

class BabyHeightAndWeekListWidget extends StatefulWidget {
  // final List<double> currentWeights;
  final List<String> currentHeights;
  final List<BabyWeekMonthNo> babyWeekMonthNoModelList;
  final Function callBack;
  const BabyHeightAndWeekListWidget(
      {Key? key,
      required this.currentHeights,
      required this.babyWeekMonthNoModelList,
      required this.callBack})
      : super(key: key);

  @override
  State<BabyHeightAndWeekListWidget> createState() =>
      _BabyHeightAndWeekListWidgetState();
}

class _BabyHeightAndWeekListWidgetState
    extends State<BabyHeightAndWeekListWidget> {
  // late List<Ojon> ojonList = [];
  late List<String> weithList = [];
  double titleTextSize = 18;
  late bool isFoundStartingValue;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isFoundStartingValue = false;

    return Container(
      height: MyScreenSize.mGetHeight(context, 35),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          // color: MyColors.demo1,
          borderRadius: BorderRadius.circular(4)),
      child: Stack(
        children: [
          // v: main view
          Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              //heading
              Container(
                color: MyColors.pink1,
                padding: const EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                child: CustomText(
                  // text: 'সাপ্তাহিক ওজন',
                  text: 'শিশুর উচ্চতার বিস্তারিত',
                  fontsize: titleTextSize,
                  fontcolor: MyColors.textOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //List
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(
                    top: 6, left: 18, right: 18, bottom: 6),
                color: MyColors.col,
                child: Column(children: [
                  //List heading
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "সপ্তাহ/মাস নং",
                              fontcolor: MyColors.textOnPrimary,
                              fontsize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "সেন্টিমিটার",
                              fontcolor: MyColors.textOnPrimary,
                              fontsize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //horizontal Line
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: MyColors.textOnPrimary,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  //List Body
                  //static
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /* 
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            text: "প্রাথমিক ওজন",
                            fontcolor: Colors.black,
                            fontsize: 14,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: widget.primaryWeight.toStringAsFixed(2),
                            fontcolor: Colors.black,
                            fontsize: 14,
                          ),
                        ],
                      ),
                    ),
                   */
                    ],
                  ),

                  // v: Left and Right List
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 2),
                      child: widget.currentHeights.isEmpty
                          ? ListView.builder(
                              itemCount: widget.babyWeekMonthNoModelList.length,
                              itemBuilder: (context, index) {

                                return OjonDataListItem(
                                    week:
                                        "${widget.babyWeekMonthNoModelList[index].num} ${widget.babyWeekMonthNoModelList[index].text} ",
                                    ojon: "---");

                                /* OjonDataListItem(
                              week: MyServices.mGenerateBangNum((index + 1)),
                              ojon: widget.currentWeights[index + 1] == 0.0
                                  ? "---"
                                  : widget.currentWeights[index + 1]
                                      .toStringAsFixed(2)); */
                              })
                          : ListView.builder(
                              itemCount: widget.babyWeekMonthNoModelList.length,
                              itemBuilder: (context, index) {
                                widget.currentHeights[index] != "0"
                                    ? isFoundStartingValue = true
                                    : null;
                                if (isFoundStartingValue) {
                                  return OjonDataListItem(
                                      week:
                                          "${widget.babyWeekMonthNoModelList[index].num} ${widget.babyWeekMonthNoModelList[index].text} ",
                                      ojon: widget.currentHeights.isEmpty ||
                                              widget.currentHeights[index] ==
                                                  "0"
                                          ? "---"
                                          : widget.currentHeights[index]);
                                } else {
                                  return Container();
                                }
                                /* OjonDataListItem(
                              week: MyServices.mGenerateBangNum((index + 1)),
                              ojon: widget.currentWeights[index + 1] == 0.0
                                  ? "---"
                                  : widget.currentWeights[index + 1]
                                      .toStringAsFixed(2)); */
                              }),
                    ),
                  )
                ]),
              ))
            ],
          ),

          // v: floating action button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                widget.callBack();
              },
              backgroundColor: MyColors.pink2,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
