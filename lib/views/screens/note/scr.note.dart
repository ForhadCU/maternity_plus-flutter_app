import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/models/model.mom_info.dart';
import 'package:maa/models/model.note.dart';
import 'package:maa/models/model.symp.dart';
import 'package:maa/models/model.symp_details.dart';
import 'package:maa/views/screens/note/widget/calender_part.dart';
import 'package:maa/views/screens/note/widget/note_sym_dlg.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';

import 'widget/note_card.dart';
import 'widget/symptoms_card.dart';

class NoteScreen extends StatefulWidget {
  final String email;
  final int momId;
  final MomInfo momInfo;
  const NoteScreen(
      {Key? key,
      required this.email,
      required this.momId,
      required this.momInfo})
      : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late String currentDate;
  late String note;
  late String sympIntensities;
  late List<SympDataModel> sympDataModelList;
  late List<String> actualSympIntensity;
  late List<String> actualSympNames;
  var logger = Logger();
  // late String symptomsIntensityStr;
  @override
  void initState() {
    // logger.d(widget.momInfo.sessionEnd);
    super.initState();
    currentDate = DateFormat("yMMMMd").format(DateTime.now());
    // logger.d(currentDate);
    note = "";
    sympIntensities = "";
    sympDataModelList = [];
    actualSympIntensity = [];
    actualSympNames = [];
    //read notes
    MySqfliteServices.mFetchCurrentNote(
            email: widget.momInfo.email,
            momId: widget.momInfo.momId,
            currentDate: currentDate)
        .then((noteModelList) {
      setState(() {
        // logger.d('noteModelList size: ${noteModelList.length}');
        note = noteModelList.isNotEmpty ? noteModelList[0].note : note;
        /*  for (var i = 0; i < noteModelList.length; i++) {
          NoteModel noteModel = noteModelList[i];
          note = noteModel.note;
        } */
      });
    });
    //read symptoms
    MySqfliteServices.mFetchCurrentSympIntensity(
            email: widget.momInfo.email,
            momId: widget.momInfo.momId,
            currentDate: currentDate)
        .then((symptomModelList) {
      setState(() {
        if (symptomModelList.isNotEmpty) {
          SymptomDetailsModel model = symptomModelList[0];
          sympIntensities = model.symptoms;
          sympDataModelList =
              MyServices.mGetSympDataList(sympIntensityStr: sympIntensities);
          actualSympNames = MyServices.mGetSympIntensityStr(
              sympDataModelList)['actualSympNames'];
          actualSympIntensity = MyServices.mGetSympIntensityStr(
              sympDataModelList)['actualSympIntensity'];
        } else {
          sympDataModelList = MyServices.mGetSympDataList(
              sympIntensityStr: MaaData.SymptomsIntensity);
          actualSympIntensity = [];
          actualSympNames = [];
        }
      });
    });

    // currentDate = DateTime.now().toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.pink2,
        title: const CustomText(
          text: "নোট",
          fontWeight: FontWeight.w500,
          fontsize: 24,
          fontcolor: MyColors.textOnPrimary,
        ),
        actions: [
          widget.momInfo.sessionEnd != null
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => NoteSymptompsDialog(
                              initialIndex: 0,
                              sympDataModelList: sympDataModelList,
                              symptomsIntensityStr: sympIntensities,
                              note: note,
                              currentDate: currentDate,
                              callback: (NoteModel noteModel,
                                  SymptomDetailsModel sympIntenSityModel) {
                                mUpdateNoteSympScreen(
                                    sympIntenSityModel, noteModel);
                              }));
                    },
                    icon: Image.asset(
                      'lib/assets/images/add_note_weight_icon.png',
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(6),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Calender Part
                  CalenderPart(
                      momInfo: widget.momInfo,
                      callback: (String selectedDate) async {
                        currentDate = selectedDate;
                        // logger.d(currentDate);
                        List<NoteModel> currentNote =
                            await MySqfliteServices.mFetchCurrentNote(
                                email: widget.momInfo.email,
                                momId: widget.momInfo.momId,
                                currentDate: currentDate);
                        // logger.d(noteModelList.length);
                        if (currentNote.isNotEmpty) {
                          note = currentNote[0].note;
                        } else {
                          note = "";
                        }
                        //symptoms part
                        List<SymptomDetailsModel> symIntersityModelList =
                            await MySqfliteServices.mFetchCurrentSympIntensity(
                                email: widget.momInfo.email,
                                momId: widget.momInfo.momId,
                                currentDate: currentDate);
                        // logger.d(symIntersityModelList);
                        if (symIntersityModelList.isNotEmpty) {
                          SymptomDetailsModel model = symIntersityModelList[0];

                          sympIntensities = model.symptoms;
                          // logger.d(symptoms);
                          sympDataModelList = MyServices.mGetSympDataList(
                              sympIntensityStr: sympIntensities);
                          /* logger.d(
                          'sympDataModelList: ${sympDataModelList.toString()}'); */
                          actualSympNames = MyServices.mGetSympIntensityStr(
                              sympDataModelList)['actualSympNames'];
                          // logger.d('actualSympNames: ${actualSympNames.toString()}');
                          actualSympIntensity = MyServices.mGetSympIntensityStr(
                              sympDataModelList)['actualSympIntensity'];
                          // logger.d('actualSympIntensity: ${actualSympIntensity}');
                          for (var i = 0; i < actualSympNames.length; i++) {
                            /* logger.d(
                            "Name: ${actualSympNames[i]} & Intensity: ${actualSympIntensity[i]}"); */
                          }
                        } else {
                          sympIntensities = "";
                          sympDataModelList = MyServices.mGetSympDataList(
                              sympIntensityStr: MaaData.SymptomsIntensity);
                          actualSympIntensity = [];
                          actualSympNames = [];
                        }
                        //refresh state
                        setState(() {});
                        // logger.d(selectedDate);
                      }),
                  const SizedBox(
                    height: 12,
                  ),

                  //Note and Symptoms Part
                  InkWell(
                    onTap: () {
                      /* showDialog(
                          context: context,
                          builder: (context) => NoteSymptompsDialog(
                              sympDataModelList: sympDataModelList,
                              symptomsIntensityStr: sympIntensities,
                              note: note,
                              currentDate: currentDate,
                              callback: (NoteModel noteModel,
                                  SymptomDetailsModel sympIntenSityModel) {
                                mUpdateNoteSympScreen(
                                    sympIntenSityModel, noteModel);
                              })); */
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => NoteSymptompsDialog(
                                    initialIndex: 0,
                                    sympDataModelList: sympDataModelList,
                                    symptomsIntensityStr: sympIntensities,
                                    note: note,
                                    currentDate: currentDate,
                                    callback: (NoteModel noteModel,
                                        SymptomDetailsModel
                                            sympIntenSityModel) {
                                      mUpdateNoteSympScreen(
                                          sympIntenSityModel, noteModel);
                                    }));
                          },
                          child: SymptomsCard(
                              currentDate: currentDate,
                              sympNameList: actualSympNames,
                              sympIntensityList: actualSympIntensity),
                        )),
                        const SizedBox(
                          width: 3,
                        ),

                        //Note
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => NoteSymptompsDialog(
                                    initialIndex: 1,
                                    sympDataModelList: sympDataModelList,
                                    symptomsIntensityStr: sympIntensities,
                                    note: note,
                                    currentDate: currentDate,
                                    callback: (NoteModel noteModel,
                                        SymptomDetailsModel
                                            sympIntenSityModel) {
                                      mUpdateNoteSympScreen(
                                          sympIntenSityModel, noteModel);
                                    }));
                          },
                          child: NoteCard(
                            note: note,
                            currentDate: currentDate,
                          ),
                        )),
                      ],
                    ),
                  )
                ]),
          )),
          widget.momInfo.sessionEnd != null
              ? InkWell(
                  onTap: () {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            title: "Sorry! Initiate new pregnancy session.")
                        .show();
                  },
                  child: Container(
                    color: Colors.black38,
                  ),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }

  void mUpdateNoteSympScreen(
    SymptomDetailsModel sympIntenSityModel,
    NoteModel noteModel,
  ) async {
    //note part
    if (noteModel.note != note) {
      if (note == "") {
        await MySqfliteServices.addNote(
            momInfo: widget.momInfo, noteModel: noteModel);
      } else {
        await MySqfliteServices.mUpdateNote(
            momInfo: widget.momInfo, noteModel: noteModel);
      }

      /*   List<NoteModel> noteModelList =
                              await SqfliteServices.mFetchNotes(); */
      List<NoteModel> currentNote = await MySqfliteServices.mFetchCurrentNote(
          email: widget.momInfo.email,
          momId: widget.momInfo.momId,
          currentDate: currentDate);
      // logger.d(noteModelList.length);
      if (currentNote.isNotEmpty) {
        note = currentNote[0].note;
      } else {
        note = "";
      }
    }
    //symptom part
    // logger.d('Symptoms: ${sympIntenSityModel.symptoms}');

    if (sympIntenSityModel.symptoms != sympIntensities) {
      if (sympIntensities == "") {
        await MySqfliteServices.addSympIntensity(
            momInfo: widget.momInfo, sympIntenSityModel: sympIntenSityModel);
      } else {
        await MySqfliteServices.updateSympIntensity(
            momInfo: widget.momInfo, sympIntenSityModel: sympIntenSityModel);
      }

      sympIntensities = sympIntenSityModel.symptoms;
      sympDataModelList =
          MyServices.mGetSympDataList(sympIntensityStr: sympIntensities);
      actualSympNames =
          MyServices.mGetSympIntensityStr(sympDataModelList)['actualSympNames'];
      actualSympIntensity = MyServices.mGetSympIntensityStr(
          sympDataModelList)['actualSympIntensity'];
    }
    setState(() {});
  }
}
