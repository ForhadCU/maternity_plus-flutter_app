import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Model/model.note.dart';
import 'package:splash_screen/Model/model.symp.dart';
import 'package:splash_screen/Model/model.symp_details.dart';
import 'package:splash_screen/View/screens/note/widget/calender_part.dart';
import 'package:splash_screen/View/screens/note/widget/note_sym_dlg.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

import 'widget/note_card.dart';
import 'widget/symptoms_card.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

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
  // late String symptomsIntensityStr;
  @override
  void initState() {
    super.initState();
    currentDate = DateFormat("yMMMMd").format(DateTime.now());
    // print(currentDate);
    note = "";
    sympIntensities = "";
    sympDataModelList = [];
    actualSympIntensity = [];
    actualSympNames = [];
    //read notes
    MySqfliteServices.mFetchCurrentNote(currentDate).then((noteModelList) {
      setState(() {
        // print('noteModelList size: ${noteModelList.length}');
        note = noteModelList.isNotEmpty ? noteModelList[0].note : note;
        /*  for (var i = 0; i < noteModelList.length; i++) {
          NoteModel noteModel = noteModelList[i];
          note = noteModel.note;
        } */
      });
    });
    //read symptoms
    MySqfliteServices.mFetchCurrentSympIntensity(currentDate)
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
    return WillPopScope(
      onWillPop: () async {
        //fetch all symptoms with intensity
        List<SymptomDetailsModel> symIntersityModelList =
            await MySqfliteServices.mFetchAllSympIntensity();
        // print(symIntersityModelList);
        if (symIntersityModelList.isNotEmpty) {
          for (var model in symIntersityModelList) {
            // SympIntenSityModel model = symIntersityModelList[0];

            sympIntensities = model.symptoms;
            // print(symptoms);
            sympDataModelList =
                MyServices.mGetSympDataList(sympIntensityStr: sympIntensities);
            /* print(
                          'sympDataModelList: ${sympDataModelList.toString()}'); */
            actualSympNames = MyServices.mGetSympIntensityStr(
                sympDataModelList)['actualSympNames'];
            // print('actualSympNames: ${actualSympNames.toString()}');
            actualSympIntensity = MyServices.mGetSympIntensityStr(
                sympDataModelList)['actualSympIntensity'];
            // print('actualSympIntensity: ${actualSympIntensity}');
            print("Date: ${model.date}");
            for (var i = 0; i < actualSympNames.length; i++) {
              print(
                  "Name: ${actualSympNames[i]} & Intensity: ${actualSympIntensity[i]}");
            }
          }
        }

        //fetch all note
        /*  List<NoteModel> list = await SqfliteServices.mFetchNotes();

        for (var item in list) {
          print("date: ${item.date} -- note: ${item.note}");
        } */
        return true;
      },
      child: Scaffold(
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
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  showDialog(
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
                            /* 
                            //note part
                            if (noteModel.note != note) {
                              int n = await SqfliteServices.addNote(noteModel);
                              print("Num of Inserted note item: $n");
                              /*   List<NoteModel> noteModelList =
                                await SqfliteServices.mFetchNotes(); */
                              List<NoteModel> currentNote =
                                  await SqfliteServices.mFetchCurrentNote(
                                      currentDate);
                              // print(noteModelList.length);
                              if (currentNote.isNotEmpty) {
                                note = currentNote[0].note;
                              } else {
                                note = "";
                              }symptoms
                            }
                            //symptom part
                            if (sympIntenSityModel.symptoms != symptoms) {
                              int n = await SqfliteServices.addSympIntensity(
                                  sympIntenSityModel);
    
                              SqfliteServices.mFetchCurrentSympIntensity(
                                      currentDate)
                                  .then((symptomModelList) {
                                SympIntenSityModel model = symptomModelList[0];
                                symptoms = model.symptoms;
                                sympDataModelList = MyServices.mGetSympDataList(
                                    sympIntensityStr: symptoms);
                                actualSympNames = MyServices.mGetSympIntensityStr(
                                    sympDataModelList)['actualSympNames'];
                                actualSympIntensity =
                                    MyServices.mGetSympIntensityStr(
                                        sympDataModelList)['actualSympIntensity'];
                              });
                              // print(sympIntenSityModel.symptoms);
                            }
                            setState(() {});
                           */
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Calender Part
                  CalenderPart(callback: (String selectedDate) async {
                    currentDate = selectedDate;
                    // print(currentDate);
                    List<NoteModel> currentNote =
                        await MySqfliteServices.mFetchCurrentNote(currentDate);
                    // print(noteModelList.length);
                    if (currentNote.isNotEmpty) {
                      note = currentNote[0].note;
                    } else {
                      note = "";
                    }
                    //symptoms part
                    List<SymptomDetailsModel> symIntersityModelList =
                        await MySqfliteServices.mFetchCurrentSympIntensity(
                            currentDate);
                    // print(symIntersityModelList);
                    if (symIntersityModelList.isNotEmpty) {
                      SymptomDetailsModel model = symIntersityModelList[0];

                      sympIntensities = model.symptoms;
                      // print(symptoms);
                      sympDataModelList = MyServices.mGetSympDataList(
                          sympIntensityStr: sympIntensities);
                      /* print(
                          'sympDataModelList: ${sympDataModelList.toString()}'); */
                      actualSympNames = MyServices.mGetSympIntensityStr(
                          sympDataModelList)['actualSympNames'];
                      // print('actualSympNames: ${actualSympNames.toString()}');
                      actualSympIntensity = MyServices.mGetSympIntensityStr(
                          sympDataModelList)['actualSympIntensity'];
                      // print('actualSympIntensity: ${actualSympIntensity}');
                      for (var i = 0; i < actualSympNames.length; i++) {
                        /* print(
                            "Name: ${actualSympNames[i]} & Intensity: ${actualSympIntensity[i]}"); */
                      }
                    } else {
                      sympDataModelList = MyServices.mGetSympDataList(
                          sympIntensityStr: MaaData.SymptomsIntensity);
                      actualSympIntensity = [];
                      actualSympNames = [];
                    }
                    //refresh state
                    setState(() {});
                    // print(selectedDate);
                  }),
                  const SizedBox(
                    height: 12,
                  ),

                  //Note and Symptoms Part
                  InkWell(
                    onTap: () {
                      showDialog(
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
                                //update all values
                                /*     Map<String, dynamic> value =
                                await MyServices.mUpdateNoteSympScreen(
                                    noteModel,
                                    note,
                                    currentDate,
                                    sympIntenSityModel,
                                    symptoms,
                                    sympDataModelList,
                                    actualSympIntensity,
                                    actualSympNames); 
                                   note = value['note'];
                           
                            //then refresh
                             setState(() {
                                symptoms = value['symptoms'];
                            sympDataModelList = value['sympDataModelList'];
                            actualSympIntensity = value['actualSympIntensity'];
                            actualSympNames = value['actualSympNames'];
                         });
                          */
                              }));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Note
                        Expanded(
                            child: NoteCard(
                          note: note,
                          currentDate: currentDate,
                        )),
                        const SizedBox(
                          width: 3,
                        ),
                        Expanded(
                            child: SymptomsCard(
                                currentDate: currentDate,
                                sympNameList: actualSympNames,
                                sympIntensityList: actualSympIntensity))
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void mUpdateNoteSympScreen(
    SymptomDetailsModel sympIntenSityModel,
    NoteModel noteModel,
  ) async {
    //note part
    if (noteModel.note != note) {
      int n = await MySqfliteServices.addNote(noteModel);
      print("Num of Inserted note item: $n");
      /*   List<NoteModel> noteModelList =
                              await SqfliteServices.mFetchNotes(); */
      List<NoteModel> currentNote =
          await MySqfliteServices.mFetchCurrentNote(currentDate);
      // print(noteModelList.length);
      if (currentNote.isNotEmpty) {
        note = currentNote[0].note;
      } else {
        note = "";
      }
    }
    //symptom part
    // print('Symptoms: ${sympIntenSityModel.symptoms}');

    if (sympIntenSityModel.symptoms != sympIntensities) {
      await MySqfliteServices.addSympIntensity(sympIntenSityModel);

      sympIntensities = sympIntenSityModel.symptoms;
      sympDataModelList =
          MyServices.mGetSympDataList(sympIntensityStr: sympIntensities);
      actualSympNames =
          MyServices.mGetSympIntensityStr(sympDataModelList)['actualSympNames'];
      actualSympIntensity = MyServices.mGetSympIntensityStr(
          sympDataModelList)['actualSympIntensity'];

      /* SqfliteServices.mFetchCurrentSympIntensity(currentDate)
          .then((symptomModelList) {
        SympIntenSityModel model = symptomModelList[0];
        sympIntensities = model.symptoms;
        sympDataModelList =
            MyServices.mGetSympDataList(sympIntensityStr: sympIntensities);
        actualSympNames = MyServices.mGetSympIntensityStr(
            sympDataModelList)['actualSympNames'];
        actualSympIntensity = MyServices.mGetSympIntensityStr(
            sympDataModelList)['actualSympIntensity'];
      }); */
      // print(sympIntenSityModel.symptoms);
/* 
      List<NoteModel> currentNote =
          await SqfliteServices.mFetchCurrentNote(currentDate);
      // print(noteModelList.length);
      if (currentNote.isNotEmpty) {
        note = currentNote[0].note;
      } else {
        note = "";
      } */
      //symptoms part
      /*  List<SympIntenSityModel> symIntersityModelList =
          await SqfliteServices.mFetchCurrentSympIntensity(currentDate);
      // print(symIntersityModelList);
      if (symIntersityModelList.isNotEmpty) {
        SympIntenSityModel model = symIntersityModelList[0];

        symptoms = model.symptoms;
        // print(symptoms);
        sympDataModelList =
            MyServices.mGetSympDataList(sympIntensityStr: symptoms);
        actualSympNames = MyServices.mGetSympIntensityStr(
            sympDataModelList)['actualSympNames'];
        actualSympIntensity = MyServices.mGetSympIntensityStr(
            sympDataModelList)['actualSympIntensity'];
      }  */ /* else {
        sympDataModelList = MyServices.mGetSympDataList(
            sympIntensityStr: MaaData.SymptomsIntensity);
        actualSympIntensity = [];
        actualSympNames = [];
      } */
    }
    setState(() {});
  }
}
