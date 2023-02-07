
import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/consts/const.colors.dart';

class NoteCard extends StatelessWidget {
  final String note;
  final String currentDate;
  const NoteCard({Key? key, required this.note, required this.currentDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return note == null ? NoteprimaryCard(title: "নোট") : Container();
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                color: MyColors.pink1,
                child: const CustomText(
                  text: "নোট",
                  fontWeight: FontWeight.bold,
                  fontcolor: MyColors.textOnPrimary,
                  fontsize: 16,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 4, top: 5, bottom: 40),
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: note.isEmpty ? "কোনো নোট পাওয়া যায়নি,\nনোট দিতে এখানে ক্লিক করুন।" : note,
                      fontWeight: FontWeight.w400,
                      fontcolor: MyColors.textOnPrimary,
                      fontsize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        )
        //date text
      ]),
    );
  }
}
