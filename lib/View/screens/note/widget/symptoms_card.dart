
import 'package:flutter/material.dart';
import 'package:maa/Controller/services/service.my_service.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/consts/const.colors.dart';

class SymptomsCard extends StatelessWidget {
  final String currentDate;
  final List<String> sympNameList;
  final List<String> sympIntensityList;
  const SymptomsCard(
      {Key? key,
      required this.sympNameList,
      required this.sympIntensityList,
      required this.currentDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                color: MyColors.pink1,
                child: const CustomText(
                  text: "লক্ষণ",
                  fontWeight: FontWeight.bold,
                  fontcolor: MyColors.textOnPrimary,
                  fontsize: 16,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 4, top: 8, bottom: 40),
          color: MyColors.pink2,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            //date
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: "তারিখঃ $currentDate",
                      fontWeight: FontWeight.w400,
                      fontcolor: MyColors.textOnPrimary,
                      fontsize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            //note

            sympIntensityList.contains("L") || sympIntensityList.contains("M") || sympIntensityList.contains("H")
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: sympNameList.length,
                    itemBuilder: (context, index) {
                      String s;
                      sympIntensityList[index] == "L"
                          ? s = "কম"
                          : sympIntensityList[index] == "M"
                              ? s = "মাঝারি"
                              : s = "বেশি";
                      return Container(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                                  "${MyServices.mGenerateBangNum(index+1)}. ${sympNameList[index]} - $s",
                              fontcolor: MyColors.textOnPrimary,
                            )
                          ],
                        ),
                      );
                    })
                :  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const CustomText(
                            text:
                                "কোনো লক্ষণ পাওয়া যায়নি,\nলক্ষণ দিতে এখানে ক্লিক করুন।",
                            fontWeight: FontWeight.w400,
                            fontcolor: MyColors.textOnPrimary,
                            fontsize: 15,
                          ),
                        ),
                      ),
                    ],
                  )
          ]),
        )
        //date text
      ]),
    );
  }
}
