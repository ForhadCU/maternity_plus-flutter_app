// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maa/Controller/services/sqflite_services.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Controller/utils/util.date_format.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/Model/model.mom_info.dart';
import 'package:maa/View/screens/shagotom/scr.shagotom.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';
import 'package:maa/consts/const.keywords.dart';

import '../../../Controller/services/service.my_service.dart';

class PregnancySeshScreen extends StatefulWidget {
  final MomInfo momInfo;
  const PregnancySeshScreen({Key? key, required this.momInfo})
      : super(key: key);

  @override
  State<PregnancySeshScreen> createState() => _PregnancySeshScreenState();
}

class _PregnancySeshScreenState extends State<PregnancySeshScreen> {
  // late String todayDate;
  String? card1Day, card1Month, card1Year;
  String? card2Day, card2Month, card2Year;
  String? card3Day, card3Month, card3Year;
  late SharedPreferences _sharedPreferences;
  final TextEditingController _editingControllerBabyName = TextEditingController();
  TextEditingController _editingControllerDob =
      TextEditingController(text: "dd/mm/yyyy");
  final TextEditingController _editingControllerWeight = TextEditingController();
  final TextEditingController _editingControllerHeadCircumstance =
      TextEditingController();
  final TextEditingController _editingControllerFatherName = TextEditingController();
  final TextEditingController _editingControllerMotherName = TextEditingController();
  final TextEditingController _editingControllerDoctorName = TextEditingController();
  final TextEditingController _editingControllerNurseName = TextEditingController();
  final TextEditingController _editingControllerGender = TextEditingController();
  final TextEditingController kgCtrller = TextEditingController();
  final TextEditingController poundCtrller = TextEditingController();
  final TextEditingController cmCtrller = TextEditingController();
  final TextEditingController feetCtrller = TextEditingController();
  final TextEditingController inchCtrller = TextEditingController();
  bool isEnded = false;
  DateTime startDate = DateTime.now();
  DateTime? selected;
  late String startDateStr;
  late int genderSelectedRadio;
  late String gender;
  late MomInfo _changableMomInfo;

//>>
  @override
  void initState() {
    super.initState();
    genderSelectedRadio = 0;
    // MyServices.mGetSharedPrefIns().then((value) => _sharedPreferences = value);
    _changableMomInfo = widget.momInfo;
    _loadData();
  }

  _mSelectDate(BuildContext context) async {
    selected = startDate;
    DateTime? _firstDate = DateTime.now().add(Duration(days: -280));
    // v: DatePicker
    showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: _firstDate,
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        selected = value;
        if (selected != null && selected != startDate) {
          startDate = selected!;
          // setUpdatedDate(startDate.toString());
          startDateStr = CustomDateForamt.mFormateDate2(startDate);
          _editingControllerDob = TextEditingController(text: startDateStr);
        }
      });
    });
  }

// >>>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: MyColors.pink2,
            title: CustomText(
              text: "আপনার শিশুর পরিচয় দিন",
              fontWeight: FontWeight.w400,
              fontsize: 22,
            )),
        body: SizedBox(
          height: MyScreenSize.mGetHeight(context, 100),
          child: primaryScreen(),
        ));
  }

  void _loadData() async {
    // DateTime s = DateTime.parse(_pref.getString(MyKeywords.startdate)!);
    DateTime s = DateTime.parse(widget.momInfo.sessionStart);
    // DateTime e = DateTime.parse(_pref.getString(MyKeywords.enddate)!);
    DateTime e = DateTime.parse(widget.momInfo.expectedSessionEnd);
    DateTime t = DateTime.now();

    setState(() {
      //day
      card1Day = DateFormat('d').format(s);
      card2Day = DateFormat('d').format(e);
      card3Day = DateFormat('d').format(t);

      //month
      card1Month = DateFormat('MMMM').format(s);
      card2Month = DateFormat('MMMM').format(e);
      card3Month = DateFormat('MMMM').format(t);

      //year
      card1Year = DateFormat('y').format(s);
      card2Year = DateFormat('y').format(e);
      card3Year = DateFormat('y').format(t);
    });
    // DateFormat('d').format();
  }

  Widget height() {
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: 'Height*',
              fontsize: 16,
              fontcolor: Colors.black,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                              MyServices.mConvertCmToFeet(value).toString();
                          inchCtrller.text =
                              MyServices.mConvertCmToInch(value).toString();
                        } else {
                          feetCtrller.clear();
                          inchCtrller.clear();
                        }
                      },
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      textAlign: TextAlign.center,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                      text: 'সে.মি',
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
                                cmCtrller.text = MyServices.mConvertFeetToCm(
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
                                cmCtrller.text = MyServices.mConvertFeetToCm(
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
      ],
    );
  }

  Widget genderSelection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: CustomText(
              text: "Select Gender*",
              fontsize: 16,
              fontcolor: Colors.black,
            )),
          ],
        ),
        Row(
          children: [
            // v: male button
            Expanded(
                child: RadioListTile(
                    title: CustomText(
                      text: ("Male"),
                    ),
                    value: 1,
                    groupValue: genderSelectedRadio,
                    onChanged: (changedValue) {
                      setState(() {
                        genderSelectedRadio =
                            int.parse(changedValue.toString());
                        gender = MyKeywords.male;
                      });
                    })),
            // v: female button
            Expanded(
                child: RadioListTile(
              title: CustomText(text: "Female"),
              value: 2,
              groupValue: genderSelectedRadio,
              onChanged: (changedValue) {
                setState(() {
                  genderSelectedRadio = int.parse(changedValue.toString());
                  gender = MyKeywords.female;
                });
              },
            ))
          ],
        )
      ],
    );
  }

  Widget weight() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: 'Weight*',
              fontsize: 16,
              fontcolor: Colors.black,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        double? parsedValue = double.tryParse(value);
                        if (parsedValue != null) {
                          // do something with parsedValue
                        }
                      },
                    ), */
                    TextFormField(
                      controller: kgCtrller,
                      onChanged: (value) {
                        // double n = double.parse(value);

                        if (kgCtrller.value.text.isNotEmpty) {
                          // double n = double.parse(value);
                          poundCtrller.text =
                              MyServices.mConvertKgToPound(value.toString())
                                  .toStringAsFixed(1);
                        } else {
                          poundCtrller.clear();
                        }
                      },
                      onTap: () => kgCtrller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: kgCtrller.value.text.length),
                      textAlign: TextAlign.center,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
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
                      onChanged: (value) => poundCtrller.value.text.isNotEmpty
                          ? kgCtrller.text = MyServices.mConvertPoundToKg(value)
                              .toStringAsFixed(1)
                          : kgCtrller.clear(),
                      textAlign: TextAlign.center,
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
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
      ],
    );
  }

  void mActions() {
    /* 
    // print("CmCtrl: ${cmCtrller.text}, WtCtrl: ${kgCtrller.text}");
    if (_editingControllerBabyName.text.isNotEmpty &&
        _editingControllerDob.text.isNotEmpty &&
        cmCtrller.text.isNotEmpty &&
        kgCtrller.text.isNotEmpty &&
        genderSelectedRadio != 0) {
      MySqfliteServices.mAddBabyInfo(
              babyName: _editingControllerBabyName.text,
              dob: selected.toString(),
              weight: double.parse(kgCtrller.text),
              height: double.parse(cmCtrller.text),
              gender: gender,
              headCircumstance:
                  _editingControllerHeadCircumstance.text.isNotEmpty
                      ? double.parse(_editingControllerHeadCircumstance.text)
                      : 0,
              fatherName: _editingControllerFatherName.text,
              motherName: _editingControllerMotherName.text,
              doctorName: _editingControllerDoctorName.text,
              nurseName: _editingControllerNurseName.text)
          .then((value) async {
        if (value > 0) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Succesfully Saved",
          ).show();
          await Future.delayed(Duration(milliseconds: 3000));
          Navigator.pop(context);
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fill the required* field")));
    }
  */
  }

  Widget primaryScreen() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            //1
            Row(
              children: [
                //part: card 1
                Expanded(
                    child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color.fromARGB(12, 0, 0, 0))),
                  margin: EdgeInsets.only(right: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        color: MyColors.pink1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'শেষ মাসিকের প্রথম দিন',
                              fontcolor: MyColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        // color: MyColors.pink1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "$card1Day",
                              fontcolor: MyColors.pink1,
                              fontWeight: FontWeight.bold,
                              fontsize: 22,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        color: MyColors.pink2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "$card1Month, $card1Year",
                              fontcolor: MyColors.textOnPrimary,
                              fontWeight: FontWeight.w400,
                              fontsize: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color.fromARGB(12, 0, 0, 0))),
                  margin: EdgeInsets.only(left: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        color: MyColors.pink1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: MaaData.slide_3_title,
                              fontcolor: MyColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        // color: MyColors.pink1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "$card2Day",
                              fontcolor: MyColors.pink1,
                              fontWeight: FontWeight.bold,
                              fontsize: 22,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        color: MyColors.pink2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "$card2Month, $card2Year",
                              fontcolor: MyColors.textOnPrimary,
                              fontWeight: FontWeight.w400,
                              fontsize: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            //part: 2
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color.fromARGB(12, 0, 0, 0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    color: MyColors.pink1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'প্রসবের তারিখ',
                          fontcolor: MyColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    // color: MyColors.pink1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "$card3Day",
                          fontcolor: MyColors.pink1,
                          fontWeight: FontWeight.bold,
                          fontsize: 22,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    color: MyColors.pink2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "$card3Month, $card3Year",
                          fontcolor: MyColors.textOnPrimary,
                          fontWeight: FontWeight.w400,
                          fontsize: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 0.5,
                    thickness: 0.8,
                    color: MyColors.pink1,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'রিপোর্ট',
                        fontcolor: MyColors.greenPlates[4],
                        fontWeight: FontWeight.bold,
                        fontsize: 18,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: 'রিপোর্টে যা যা উল্লেখিত থাকবেঃ',
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Container(
                                  height: MyScreenSize.mGetHeight(context, 3),
                                  width: MyScreenSize.mGetWidth(context, 6),
                                  decoration:
                                      BoxDecoration(color: Colors.green),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                CustomText(
                                  text: 'ওজন সংক্রান্ত তথ্য',
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Container(
                                  height: MyScreenSize.mGetHeight(context, 3),
                                  width: MyScreenSize.mGetWidth(context, 6),
                                  decoration:
                                      BoxDecoration(color: Colors.green),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                CustomText(
                                  text: 'নোট সমূহ',
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Container(
                                  height: MyScreenSize.mGetHeight(context, 3),
                                  width: MyScreenSize.mGetWidth(context, 6),
                                  decoration:
                                      BoxDecoration(color: Colors.green),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                CustomText(
                                  text: 'লক্ষণ সমূহ',
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.5,
                    thickness: 0.8,
                    color: MyColors.pink1,
                  )
                ],
              ),
            ),
          ]),
        ),
        Expanded(
            child: InkWell(
          onTap: () async {
            /* setState(() {
              isEnded = true;
            }); */
            print("object");
            // c: update sessionEnd date into MomInfo Model
            _changableMomInfo.sessionEnd = DateTime.now().toString();
            var res = await MySqfliteServices.mUpdateMomInfo(
                momInfo: _changableMomInfo);
            if (res != 0) {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return ShagotomScreen(momInfo: _changableMomInfo);
              }));
            } else {
              print("Problem in updating mom info");
            }

            // e: For later: save and send data for getting pregnancy report
            // save();
          },
          child: Container(
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'প্রেগন্যান্সি শেষ করুন এবং রিপোর্ট ',
                    fontcolor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontsize: 16,
                  ),
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }
}

void save() {
  /* String startdate =
                      _sharedPreferences.getString(MyKeywords.startdate) !=
                              null
                          ? CustomDateForamt.mFormateDateDB(DateTime.parse(
                              _sharedPreferences
                                  .getString(MyKeywords.startdate)!))
                          : "";
        
                  String enddate =
                      _sharedPreferences.getString(MyKeywords.enddate) !=
                              null
                          ? CustomDateForamt.mFormateDateDB(DateTime.parse(
                              _sharedPreferences
                                  .getString(MyKeywords.enddate)!))
                          : "";
                  String actualdate =
                      CustomDateForamt.mFormateDateDB(DateTime.now());
        
                  //? get all weights
                  List<String> currentWeightsList =
                      MyServices.mGetWeightList(
                          sharedPreferences: _sharedPreferences);
                  double? primaryweight = _sharedPreferences
                      .getDouble(MyKeywords.primaryWeight);
                  List<OjonModel> listOjonModel = [];
        
                  for (var i = 0; i < currentWeightsList.length; i++) {
                    OjonModel ojonModel = OjonModel(
                        week: (i + 1).toString(),
                        weight: currentWeightsList[i].toString());
                    listOjonModel.add(ojonModel);
                  }
        
                  //? get all notes with date
                  List<NoteModel> listNoteModel =
                      await SqfliteServices.mFetchNotes();
        
                  //? fetch all symptoms with intensity
                  List<SymptomDetailsModel> symIntersityModelList =
                      await SqfliteServices.mFetchAllSympIntensity();
                  // print(symIntersityModelList);
                  List<SymptomDetailsModel> listSymptomDtailsModel = [];
        
                  if (symIntersityModelList.isNotEmpty) {
                    for (var model in symIntersityModelList) {
                      // SympIntenSityModel model = symIntersityModelList[0];
        
                      var sympIntensities = model.symptoms;
                      // print(symptoms);
                      var sympDataModelList = MyServices.mGetSympDataList(
                          sympIntensityStr: sympIntensities);
                      /* print(
                        'sympDataModelList: ${sympDataModelList.toString()}'); */
                      var actualSympNames = MyServices.mGetSympIntensityStr(
                          sympDataModelList)['actualSympNames'];
                      // print('actualSympNames: ${actualSympNames.toString()}');
                      var actualSympIntensity =
                          MyServices.mGetSympIntensityStr(
                              sympDataModelList)['actualSympIntensity'];
                      // print('actualSympIntensity: ${actualSympIntensity}');
                      // print("Date: ${model.date}");
                      List<SymptomDetailsModel>
                          listsympNameAndIntesityModel = [];
                      for (var i = 0; i < actualSympNames.length; i++) {
                        /*  print(
                          "Name: ${actualSympNames[i]} & Intensity: ${actualSympIntensity[i]}"); */
                        SymptomDetailsModel symptomDetailsModel =
                            SymptomDetailsModel.nameAndIntensity(
                                date: model.date,
                                sympName: actualSympNames[i],
                                sympIntensity: actualSympIntensity[i]);
                        listsympNameAndIntesityModel
                            .add(symptomDetailsModel);
                      }
                      SymptomDetailsModel symptomDetailsModel =
                          SymptomDetailsModel.sympDetailsData(
                              date: model.date,
                              listSympNameAndIntensity:
                                  listsympNameAndIntesityModel);
                      //print("SympListJson: ${symptomDetailsModel.toJsonSympNameAndIntensityList()}");
                      listSymptomDtailsModel.add(symptomDetailsModel);
                    }
                  }
        
                  String email =
                      _sharedPreferences.getString(MyKeywords.email) ?? "";
                  String uid =
                      _sharedPreferences.getString(MyKeywords.uid) ?? "";
        
                  ReportDataModel reportDataModel =
                      ReportDataModel.namedConstructor1(
                          email: email,
                          uid: uid,
                          startDate: startdate,
                          endDate: enddate,
                          actualDate: actualdate,
                          listNoteModel: listNoteModel,
                          listSymptomDtailsModel: listSymptomDtailsModel,
                          listOjonModel: listOjonModel,
                          primaryWeight: primaryweight);
        
                  String jsonReportDataModel = jsonEncode(reportDataModel);
                  // print("jsonReportDataModel: ${jsonReportDataModel}");
        
                  /*  http.post(
                  Uri.parse(
                      'https://maa.agamilabs.com/api/generate_report.php'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonReportDataModel,
                ); */
                  // send json file to api
                  var result =
                      MyServices.mSendFinalDataToApi(jsonReportDataModel);
                  print("Response from Api: ${result.toString()}");
                 */
}
