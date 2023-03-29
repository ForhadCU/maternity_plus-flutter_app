// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/Model/model.note.dart';
import 'package:splash_screen/Model/model.symp.dart';
import 'package:splash_screen/Model/model.symp_details.dart';
import 'package:splash_screen/View/screens/note/widget/sym_list_item.dart';
import 'package:splash_screen/consts/const.colors.dart';

class NoteSymptompsDialog extends StatefulWidget {
  final int initialIndex;
  final String currentDate;
  final String note;
  final String symptomsIntensityStr;
  final Function callback;
  final List<SympDataModel> sympDataModelList;
  const NoteSymptompsDialog(
      {Key? key,
      required this.sympDataModelList,
      required this.symptomsIntensityStr,
      required this.currentDate,
      required this.callback,
      required this.note,
      required this.initialIndex})
      : super(key: key);

  @override
  State<NoteSymptompsDialog> createState() => _NoteSymptompsDialogState();
}

class _NoteSymptompsDialogState extends State<NoteSymptompsDialog>
    with TickerProviderStateMixin {
  late TabController tabController;
  // late String _date;
  late final TextEditingController _editingControllerNote;
  // late List<SympDataModel> sympDataModelList;
  List<String> sympIntensityList = [];
  String title = "আজ কেমন অনুভব করছেন?";

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialIndex);
    _editingControllerNote = TextEditingController(text: widget.note);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: Container(
            height: MyScreenSize.mGetHeight(context, 60),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: MyColors.pink2,
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: title,
                            fontWeight: FontWeight.w500,
                            fontcolor: MyColors.textOnPrimary,
                            fontsize: 18,
                          ),
                          CustomText(
                            text: widget.currentDate,
                            fontWeight: FontWeight.w400,
                            fontcolor: MyColors.textOnPrimary,
                            fontsize: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //tab view Header
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: MyColors.pink6,
                        offset: Offset(0, 2),
                        blurRadius: 1)
                  ],
                  color: MyColors.pink2,
                ),
                child: TabBar(
                  labelPadding: const EdgeInsets.only(top: 4),
                  controller: tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      0.0,
                    ),
                    color: MyColors.pink1,
                  ),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(
                      height: 24,
                      text: "লক্ষণ",
                    ),
                    Tab(
                      height: 24,
                      text: "নোট",
                    ),
                  ],
                ),
              ),
              //TabBarView
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    // first tab bar view widget

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //heading
                        Container(
                          margin: const EdgeInsets.only(top: 0.5),
                          padding: const EdgeInsets.only(
                              left: 8, top: 2, bottom: 2, right: 4),
                          decoration:
                              const BoxDecoration(color: MyColors.pink2),
                          child: Row(
                            children: [
                              const Expanded(
                                  flex: 3,
                                  child: CustomText(
                                    text: "নাম",
                                    fontcolor: MyColors.textOnPrimary,
                                  )),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                // color: Colors.green,
                                child: const CustomText(
                                  text: "কম",
                                  fontcolor: MyColors.textOnPrimary,
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                // color: Colors.blue,
                                child: const CustomText(
                                  text: "মাঝারি",
                                  fontcolor: MyColors.textOnPrimary,
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                // color: Colors.yellow,
                                child: const CustomText(
                                  text: "বেশি",
                                  fontcolor: MyColors.textOnPrimary,
                                ),
                              )),
                            ],
                          ),
                        ),

                        //List body
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: false,
                              itemCount: widget.sympDataModelList.isEmpty
                                  ? 0
                                  : widget.sympDataModelList.length,
                              itemBuilder: ((context, index) {
                                SympDataModel model =
                                    widget.sympDataModelList[index];
                                // sympIntensityList.add(model.sympIntesity);
                                return SympListItem(
                                  sympName: model.sympName,
                                  sympIntesity: model.sympIntesity,
                                  callback: (String sympIntensity) {
                                    model.sympIntesity = sympIntensity;
                                  },
                                );
                              })),
                        )
                      ],
                    ),

                    // second tab bar view widget
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _editingControllerNote,
                        onTap: (() => _editingControllerNote.selection =
                            TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    _editingControllerNote.value.text.length)),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 4, bottom: 0),
                          hintText: "এখানে আপনার নোট লিখুন",
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Confirm and Cancell Buttons
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: MyColors.pink6,
                    offset: Offset(0, -2),
                    blurRadius: 1,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
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
                        final String symptoms = MyServices.mGetSympIntensityStr(
                            widget.sympDataModelList)["symptoms"];
                        final date = widget.currentDate;
                        final String note = _editingControllerNote.value.text;

                        // put into model
                        NoteModel noteModel = NoteModel(date: date, note: note);
                        SymptomDetailsModel sympIntenSityModel =
                            SymptomDetailsModel(date: date, symptoms: symptoms);
                        widget.callback(noteModel, sympIntenSityModel);
                        Navigator.pop(context);
                        /*   print(symptoms +
                            " & " +
                            actualsympNames.toString() +
                            " & " +
                            actualsympIntensity.toString()); */
                        // print("SympIntensity String: " +MyServices.mGetSympIntensityStr(symDataList));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
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
              )
            ])));
  }
}
