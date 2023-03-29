// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.date_format.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/Model/model.mom_info.dart';
import 'package:splash_screen/View/screens/shagotom/scr.shagotom.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.keywords.dart';

class AddNewBaby extends StatefulWidget {
  final String email;
  final int momId;
  const AddNewBaby({Key? key, required this.email, required this.momId})
      : super(key: key);

  @override
  State<AddNewBaby> createState() => _AddNewBabyState();
}

class _AddNewBabyState extends State<AddNewBaby> {
  final TextEditingController _editingControllerBabyName =
      TextEditingController();
  TextEditingController _editingControllerDob =
      TextEditingController(text: "dd/mm/yyyy");
  final TextEditingController _editingControllerHeadCircumstance =
      TextEditingController();
  final TextEditingController _editingControllerFatherName =
      TextEditingController();
  final TextEditingController _editingControllerMotherName =
      TextEditingController();
  final TextEditingController _editingControllerDoctorName =
      TextEditingController();
  final TextEditingController _editingControllerNurseName =
      TextEditingController();
  final TextEditingController _kgCtrller = TextEditingController();
  final TextEditingController _poundCtrller = TextEditingController();
  final TextEditingController _cmCtrller = TextEditingController();
  final TextEditingController _feetCtrller = TextEditingController();
  final TextEditingController _inchCtrller = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  FocusNode focusNode7 = FocusNode();
  FocusNode focusNode8 = FocusNode();
  FocusNode focusNode9 = FocusNode();
  FocusNode focusNode10 = FocusNode();
  FocusNode focusNode11 = FocusNode();
  bool isEnded = false;
  DateTime startDate = DateTime.now();
  DateTime? selected;
  late String startDateStr;
  late int genderSelectedRadio;
  late String gender;

  @override
  void initState() {
    super.initState();
    genderSelectedRadio = 0;
    Logger().d("Email: ${widget.email}");
    Logger().d("MomId: ${widget.momId}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mUnFocusEditText();
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: MyColors.pink2,
            title: CustomText(
              text: "আপনার শিশুর পরিচয় দিন",
              fontWeight: FontWeight.w400,
              fontsize: 22,
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                vInputBabyName(),
                SizedBox(
                  height: 16,
                ),
                vInputDob(),
                SizedBox(
                  height: 30,
                ),
                vInputWeight(),
                vInputHeight(),
                SizedBox(
                  height: 30,
                ),
                vInputGenderSelection(),
                vInputHeadCircums(),
                vInputFatherName(),
                vInputMotherName(),
                vInputDoctorName(),
                vInputNurseName(),
                SizedBox(
                  height: 24,
                ),
                vSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _mSelectDate(BuildContext context) async {
    selected = startDate;
    DateTime? firstDate = DateTime.now().add(Duration(days: -(6*365 - 1)));
    // DateTime? firstDate = DateTime.now().add(Duration(days: (6*365 - 1)));
    // v: DatePicker
    showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: firstDate,
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        selected = value;
        if (selected != null && selected != startDate ) {
          startDate = selected!;
          // setUpdatedDate(startDate.toString());
          startDateStr = CustomDateForamt.mFormateDate2(startDate);
          _editingControllerDob = TextEditingController(text: startDateStr);
        }
      });
    });
  }

  Widget vInputWeight() {
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
                      focusNode: focusNode2,
                      controller: _kgCtrller,
                      onChanged: (value) {
                        // double n = double.parse(value);

                        if (_kgCtrller.value.text.isNotEmpty) {
                          // double n = double.parse(value);
                          _poundCtrller.text =
                              MyServices.mConvertKgToPound(value.toString())
                                  .toStringAsFixed(1);
                        } else {
                          _poundCtrller.clear();
                        }
                      },
                      onTap: () => _kgCtrller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _kgCtrller.value.text.length),
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
                      focusNode: focusNode11,
                      controller: _poundCtrller,
                      onTap: () => _poundCtrller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _poundCtrller.value.text.length),
                      onChanged: (value) => _poundCtrller.value.text.isNotEmpty
                          ? _kgCtrller.text =
                              MyServices.mConvertPoundToKg(value)
                                  .toStringAsFixed(1)
                          : _kgCtrller.clear(),
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
    // Logger().d("CmCtrl: ${cmCtrller.text}, WtCtrl: ${kgCtrller.text}");
    MomInfo? momInfo;
    if (_editingControllerBabyName.text.isNotEmpty &&
        _editingControllerDob.text.isNotEmpty &&
        _cmCtrller.text.isNotEmpty &&
        _kgCtrller.text.isNotEmpty &&
        genderSelectedRadio != 0) {
      MySqfliteServices.mAddBabyInfo(
              momId: widget.momId,
              email: widget.email,
              babyName: _editingControllerBabyName.text,
              dob: selected.toString(),
              // weight: double.parse(_kgCtrller.text),
              weight: _kgCtrller.text,
              // height: double.parse(_cmCtrller.text),
              height: _cmCtrller.text,
              gender: gender,
              headCircumstance:
                  _editingControllerHeadCircumstance.text.isNotEmpty
                      ? /* double.parse(_editingControllerHeadCircumstance.text) */
                       _editingControllerHeadCircumstance.text
                      : "0.00",
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
          momInfo = await MySqfliteServices.mFetchMomInfo(
              email: widget.email, currentMomId: widget.momId);
          await Future.delayed(Duration(milliseconds: 2500));
          Navigator.pop(context);
          mClearAllFields();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return ShagotomScreen(momInfo: momInfo!);
          }));
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) {}));
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fill the required* field")));
    }
  }

  Widget vInputHeight() {
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
                      focusNode: focusNode3,
                      controller: _cmCtrller,
                      onTap: () => _cmCtrller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _cmCtrller.value.text.length),
                      onChanged: (value) {
                        if (_cmCtrller.value.text.isNotEmpty) {
                          _feetCtrller.text =
                              MyServices.mConvertCmToFeet(value).toString();
                          _inchCtrller.text =
                              MyServices.mConvertCmToInch(value).toString();
                        } else {
                          _feetCtrller.clear();
                          _inchCtrller.clear();
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
                              focusNode: focusNode4,
                              controller: _feetCtrller,
                              onTap: () => _feetCtrller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _feetCtrller.value.text.length),
                              onChanged: (value) {
                                _cmCtrller.text = MyServices.mConvertFeetToCm(
                                        value.isNotEmpty
                                            ? _feetCtrller.value.text
                                            : '0',
                                        _inchCtrller.value.text.isNotEmpty
                                            ? _inchCtrller.value.text
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
                              focusNode: focusNode5,
                              controller: _inchCtrller,
                              onTap: () => _inchCtrller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _inchCtrller.value.text.length),
                              onChanged: (value) {
                                _cmCtrller.text = MyServices.mConvertFeetToCm(
                                        _feetCtrller.value.text.isNotEmpty
                                            ? _feetCtrller.value.text
                                            : '0',
                                        value.isNotEmpty
                                            ? _inchCtrller.value.text
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

  Widget vInputGenderSelection() {
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
                    activeColor: MyColors.pink3,
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
              activeColor: MyColors.pink3,
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

  Widget vInputDob() {
    return InkWell(
      splashColor: MyColors.pink3,
      onTap: () {
        _mSelectDate(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _editingControllerDob,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              enabled: false,
              // readOnly: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 2),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Date of birth*'),
            ),
          ),
          Expanded(
              flex: 3,
              child: Container(
                  padding: EdgeInsets.only(left: 24),
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.event)))
        ],
      ),
    );
  }

  Widget vInputBabyName() {
    return TextField(
      focusNode: focusNode1,
      controller: _editingControllerBabyName,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'Baby Name*',
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget vInputHeadCircums() {
    return TextField(
      focusNode: focusNode6,
      controller: _editingControllerHeadCircumstance,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: 'Head Circumstance'),
    );
  }

  Widget vInputFatherName() {
    return TextField(
      focusNode: focusNode7,
      controller: _editingControllerFatherName,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: 'Father\'s name'),
    );
  }

  Widget vInputMotherName() {
    return TextField(
      focusNode: focusNode8,
      controller: _editingControllerMotherName,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: 'Mother\'s name'),
    );
  }

  Widget vInputDoctorName() {
    return TextField(
      focusNode: focusNode9,
      controller: _editingControllerDoctorName,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: 'Doctor\'s name'),
    );
  }

  Widget vInputNurseName() {
    return TextField(
      focusNode: focusNode10,
      controller: _editingControllerNurseName,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: 'Nurse\'s name'),
    );
  }

  Widget vSaveButton() {
    return ElevatedButton(
        onPressed: () async {
          mUnFocusEditText();
          mActions();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.pink3,
            // padding: EdgeInsets.only(left: 24, right: 24)
            fixedSize: Size(MyScreenSize.mGetWidth(context, 50), 0)),
        child: CustomText(
          text: 'Save',
          fontcolor: Colors.white,
        ));
  }

  void mClearAllFields() {
    setState(() {
      _editingControllerBabyName.clear();
      _editingControllerDob.clear();
      _kgCtrller.clear();
      _poundCtrller.clear();
      _cmCtrller.clear();
      _feetCtrller.clear();
      _inchCtrller.clear();
      genderSelectedRadio = 0;
      _editingControllerDoctorName.clear();
      _editingControllerHeadCircumstance.clear();
      _editingControllerFatherName.clear();
      _editingControllerMotherName.clear();
      _editingControllerNurseName.clear();
    });
  }

  void mUnFocusEditText() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    focusNode3.unfocus();
    focusNode4.unfocus();
    focusNode5.unfocus();
    focusNode6.unfocus();
    focusNode7.unfocus();
    focusNode8.unfocus();
    focusNode9.unfocus();
    focusNode10.unfocus();
    focusNode11.unfocus();
  }
}
