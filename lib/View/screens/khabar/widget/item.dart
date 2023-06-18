
import 'package:flutter/material.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/consts/const.colors.dart';

class ListItemKhabar extends StatelessWidget {
  final String title;
  final String desc;
  final String? imgUrl;
  final bool isLeft;
  final int index;
  const ListItemKhabar(
      {Key? key,
      required this.index,
      required this.isLeft,
      required this.title,
      required this.desc,
      this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: index == 0
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('lib/assets/images/triangle.png')),
                SizedBox(
                  height: 4,
                ),
                Divider(
                  height: 1,
                  thickness: 2,
                  color: MyColors.app1,
                ),
                SizedBox(
                  height: 12,
                ),
                CustomText(
                  text:
                      "আপনার শিশুর সঠিক বিকাশ নিশ্চিত করতে এবং একটি সুস্বাস্থ্যের অধিকারী শিশু জন্ম দেয়ার জন্য আপনাকে অবশ্যই সঠিক উপায়ে খাদ্য গ্রহণ করতে হবে। গর্ভাবস্থায় একজন মায়ের অনেক ধরনের খাদ্য-উপাদান গ্রহণ করা প্রয়োজন। নিচে খাদ্য তালিকা এবং কোন খাদ্যে কী কী উপাদান থাকে তার বর্ণনা দেয়া হল:",
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            )
          : imgUrl == ''
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//title
                      CustomText(
                        text: title,
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                      const SizedBox(
                        height: 4,
                      ),

//description
                      CustomText(
                        text: desc,
                        fontsize: 14,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      /* Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ), */
                    ])
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      !isLeft
                          ? Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: title,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 14,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),

                                    //description
                                    CustomText(
                                      text: desc,
                                      fontsize: 14,
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                )),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    imgUrl != ''
                                        ? Image(image: AssetImage(imgUrl!))
                                        : Container()
                                  ],
                                ))
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    imgUrl != ''
                                        ? Image(image: AssetImage(imgUrl!))
                                        : Container(),
                                  ],
                                )),
                                const SizedBox(width: 8,)
                                ,
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: title,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 14,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),

                                    //description
                                    CustomText(
                                      text: desc,
                                      fontsize: 14,
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ))
                              ],
                            )
                    ]),
    );
  }
}
