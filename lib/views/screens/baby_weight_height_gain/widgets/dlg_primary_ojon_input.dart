
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/consts/const.colors.dart';

class BabyPrimaryOjonInputDialog extends StatefulWidget {
  final Function callBack;
  const BabyPrimaryOjonInputDialog({Key? key, required this.callBack})
      : super(key: key);

  @override
  State<BabyPrimaryOjonInputDialog> createState() => _BabyPrimaryOjonInputDialogState();
}

class _BabyPrimaryOjonInputDialogState extends State<BabyPrimaryOjonInputDialog> {
  final TextEditingController kgCtrller = TextEditingController();
  final TextEditingController poundCtrller = TextEditingController();
  final TextEditingController cmCtrller = TextEditingController();
  final TextEditingController feetCtrller = TextEditingController();
  final TextEditingController inchCtrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      /* insetAnimationDuration: Duration(microseconds: 3000),
      insetAnimationCurve: Curves.bounceInOut, */
      insetPadding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          color: MyColors.pink2,
          alignment: Alignment.center,
          child: const CustomText(
            text: 'আপনার প্রাথমিক ওজন ও উচ্চতা দিন',
            fontWeight: FontWeight.w600,
            fontcolor: MyColors.textOnPrimary,
            fontsize: 18,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //v: Weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'ওজন',
                          fontcolor: Colors.grey,
                          fontsize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: kgCtrller,
                          onChanged: (value) =>
                              kgCtrller.value.text.isNotEmpty
                                  ? poundCtrller.text =
                                      MyServices.mConvertKgToPound(value)
                                          .toStringAsFixed(1)
                                  : poundCtrller.clear(),
                          onTap: () => kgCtrller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: kgCtrller.value.text.length),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: '0.0',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const CustomText(
                          text: 'কেজি',
                          fontWeight: FontWeight.w500,
                          fontsize: 16,
                          fontcolor: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: poundCtrller,
                          onTap: () => poundCtrller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: poundCtrller.value.text.length),
                          onChanged: (value) =>
                              poundCtrller.value.text.isNotEmpty
                                  ? kgCtrller.text =
                                      MyServices.mConvertPoundToKg(value)
                                          .toStringAsFixed(1)
                                  : kgCtrller.clear(),
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '0.0',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const CustomText(
                          text: 'পাউন্ড',
                          fontWeight: FontWeight.w500,
                          fontsize: 16,
                          fontcolor: Colors.grey,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            // v: Height
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'উচ্চতা',
                          fontcolor: Colors.grey,
                          fontsize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: cmCtrller,
                          onTap: () => cmCtrller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: cmCtrller.value.text.length),
                          onChanged: (value) {
                            if (cmCtrller.value.text.isNotEmpty) {
                              feetCtrller.text =
                                  MyServices.mConvertCmToFeet(value)
                                      .toString();
                              inchCtrller.text =
                                  MyServices.mConvertCmToInch(value)
                                      .toString();
                            } else {
                              feetCtrller.clear();
                              inchCtrller.clear();
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '0.0',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const CustomText(
                          text: 'সেমি',
                          fontWeight: FontWeight.w500,
                          fontsize: 16,
                          fontcolor: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: feetCtrller,
                                  onTap: () => feetCtrller.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              feetCtrller.value.text.length),
                                  onChanged: (value) {
                                    cmCtrller
                                        .text = MyServices.mConvertFeetToCm(
                                            value.isNotEmpty
                                                ? feetCtrller.value.text
                                                : '0',
                                            inchCtrller.value.text.isNotEmpty
                                                ? inchCtrller.value.text
                                                : '0')
                                        .toStringAsFixed(2);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomText(
                                  text: 'ফিট',
                                  fontWeight: FontWeight.w500,
                                  fontsize: 16,
                                  fontcolor: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: inchCtrller,
                                  onTap: () => inchCtrller.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              inchCtrller.value.text.length),
                                  onChanged: (value) {
                                    cmCtrller
                                        .text = MyServices.mConvertFeetToCm(
                                            feetCtrller.value.text.isNotEmpty
                                                ? feetCtrller.value.text
                                                : '0',
                                            value.isNotEmpty
                                                ? inchCtrller.value.text
                                                : '0')
                                        .toStringAsFixed(2);
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomText(
                                  text: 'ইঞ্চি',
                                  fontWeight: FontWeight.w500,
                                  fontsize: 16,
                                  fontcolor: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomText(
                      text: 'বাতিল',
                      fontcolor: MyColors.pink3,
                      fontsize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                InkWell(
                  onTap: () {
                    if (kgCtrller.value.text.isNotEmpty &&
                        cmCtrller.value.text.isNotEmpty) {
                      final double w = double.parse(kgCtrller.value.text);
                      final double h = double.parse(cmCtrller.value.text);

                      widget.callBack(w, h);
                      // widget.callBack();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Primary data has been saved')));
                      Navigator.pop(context);
                    } else {
                    kDebugMode ?  print("No data entry"): null;
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomText(
                      text: 'সংরক্ষণ',
                      fontcolor: MyColors.pink3,
                      fontsize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                )
              ],
            ),
            const SizedBox(
              height: 8,
            )
          ],
        )
      ]),
    );
  }
}
