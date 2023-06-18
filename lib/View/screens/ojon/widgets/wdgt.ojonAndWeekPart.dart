import 'package:flutter/material.dart';
import 'package:maa/Controller/services/service.my_service.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/View/screens/ojon/widgets/item_ojondataList.dart';
import 'package:maa/consts/const.colors.dart';

class OjonAndWeekListWidget extends StatefulWidget {
  final double primaryWeight;
  // final List<double> currentWeights;
  final List<String> currentWeights;
  const OjonAndWeekListWidget(
      {Key? key, required this.primaryWeight, required this.currentWeights})
      : super(key: key);

  @override
  State<OjonAndWeekListWidget> createState() => _OjonAndWeekListWidgetState();
}

class _OjonAndWeekListWidgetState extends State<OjonAndWeekListWidget> {
  // late List<Ojon> ojonList = [];
  late List<String> weithList = [];
  double titleTextSize = 18;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyScreenSize.mGetHeight(context, 35),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          // color: MyColors.demo1,
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          //heading
          Container(
            color: MyColors.pink1,
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.center,
            child: CustomText(
              text: 'সাপ্তাহিক ওজন',
              fontsize: titleTextSize,
              fontcolor: MyColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          //List
          Expanded(
              child: Container(
            padding:
                const EdgeInsets.only(top: 6, left: 18, right: 18, bottom: 6),
            color: MyColors.col,
            child: Column(children: [
              //List heading
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CustomText(
                          text: "সপ্তাহ নং",
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
                      children: const [
                        CustomText(
                          text: "ওজন কেজি",
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
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                ],
              ),

              //dynamic
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 2),
                  child: ListView.builder(
                      itemCount: widget.currentWeights.length,
                      itemBuilder: (context, index) {
                        return OjonDataListItem(
                            week: MyServices.mGenerateBangNum((index + 1)),
                            ojon: widget.currentWeights[index] == "0.0"
                                ? "---"
                                : widget.currentWeights[index]);
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
    );
  }
}
