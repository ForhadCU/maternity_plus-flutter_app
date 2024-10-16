// ignore_for_file: unused_local_variable, unused_catch_clause

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maa/services/sqflite_services.dart';
import 'package:maa/utils/util.date_format.dart';
import 'package:maa/utils/util.image.dart';
import 'package:maa/models/model.baby_growth.dart';
import 'package:maa/models/model.baby_week_month_no.dart';
import 'package:maa/models/model.baby_weights_heights_for_age.dart';
import 'package:maa/models/model.daiyetto.dart';
import 'package:maa/models/model.emergency.dart';
import 'package:maa/models/model.height.dart';
import 'package:maa/models/model.image_details.dart';
import 'package:maa/models/model.jiggasha.dart';
import 'package:maa/models/model.kahbar.dart';
import 'package:maa/models/model.max_min_weightlist.dart';
import 'package:maa/models/model.ojon.dart';
import 'package:maa/models/model.symp.dart';
import 'package:maa/consts/const.data.bn.dart';
import 'package:maa/consts/const.keywords.dart';
import 'package:url_launcher/url_launcher.dart';

class MyServices {
  static String mMakeDoubleDigitNumString({required int inputNum}) {
    late String s;

    s = "0$inputNum";

    return s;
  }

  static List<BabyGrowthModel> mGetInitialQuesDataOfBabyGrowth() {
    var _listInitialQuesDataModel = <BabyGrowthModel>[];
    // const _totalTimestar = 5;
    const _numOfQuesInEachTimestar = 8;
    const _timestarList = [
      '1',
      '3',
      '6',
      '9',
      '12',
      '18',
      '24',
      '36',
      '48',
      '60',
      '72',
    ];
    // Logger().d(_timestarList.length);
    for (var t = 1; t <= _timestarList.length; t++) {
      late String quesId;
      const ansStatus = 0;
      final timestar = t;
      /*  final timestarNumMap =
          MaaData.babyGrowthJsonData['month_${_timestarList[t - 1]}']; */
      // Logger().d('month_${_timestarList[t - 1]}');
      // Logger().d(t);

      for (var element
          in MaaData.babyGrowthJsonData['month_${_timestarList[t - 1]}']) {
        /* Logger().d(element['ques_id']);
        Logger().d(element['ques_id']); */

        BabyGrowthModel babyGrowthModel = BabyGrowthModel.initialQuesData(
          // momId: element[MyKeywords.momId],
          // email: element[MyKeywords.email],
          question: element['question'],
          quesId: element['ques_id'],
          timestar: timestar,
          options: element['options'],
          // ansStatus: ansStatus,
          // babyId: babyId,
          /*      
          timestamp: '',
          */
        );

        _listInitialQuesDataModel.add(babyGrowthModel);
      }

      // for (int q = 1; q <= _numOfQuesInEachTimestar; q++) {
      /*  for (int q = 1; q <= 8; q++) {
        //Question id should be come from MaaData
        quesId =
            "M${t < 10 && t > 0 ? MyServices.mMakeDoubleDigitNumString(inputNum: t) : t}"
            "Q${q < 10 && q > 0 ? MyServices.mMakeDoubleDigitNumString(inputNum: q) : q}";
        // Logger().d("Month $t: ${timestarNumMap['$q']['question']}");
        BabyGrowthModel babyGrowthModel = BabyGrowthModel.initialQuesData(
            question: timestarNumMap[q.toString()]['question'],
            quesId: quesId,
            ansStatus: ansStatus,
            babyId: babyId,
            timestar: timestar,
            timestamp: '');

        _listInitialQuesDataModel.add(babyGrowthModel);
      } */
    }
/*     for (var element in _listInitialQuesDataModel) {
      Logger().d(element.ques_id);
    } */

    return _listInitialQuesDataModel;
  }

  static List<BabyGrowthModel> mGetBabyGrowthDummyDataList() {
    List<BabyGrowthModel> listBabyGrowth = [];

    for (var i = 1; i < 10; i++) {
      listBabyGrowth.add(BabyGrowthModel.initialQuesOnly(
          question:
              "$i. এটি একটি সেম্পল প্রশ্ন, আপনার শিশু কি অন্যদের ডাকে সাড়া দেয়?"));
    }

    return listBabyGrowth;
  }

  static Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    var latitude, longitude;
    Position currentPosition;

    late StreamSubscription<Position> streamSubscription;

    // Test if location services are enabled.
    /*     serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.f
      // await Geolocator.openLocationSettings();

     /*  if (!await Geolocator.isLocationServiceEnabled()) {
        return Future.error('Location is not enabled');
      } */

      return Future.error('Location services are disabled.');
    } 
    */

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();

    /*  //get auto listen of lat and lon
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
    }); */

    //get User Location
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return {
      'lat': currentPosition.latitude,
      'long': currentPosition.longitude,
    };
  }

  static Future<List<ImageDetailsModel>?> mPickMultipleImageFromLocal() async {
    try {
      ImagePicker imgpicker = ImagePicker();
      final List<XFile> multipleImages = await imgpicker.pickMultiImage();
      List<ImageDetailsModel> imageDetailsModelList = [];
      for (var i = 0; i < multipleImages.length; i++) {
        String imgUrl = multipleImages[i].path;
        // String newImgUrl;
        // c: copy selected
        await MyServices.mCopyImgFileToNewPath(imgFile: File(imgUrl))
            .then((newImgUrl) => {
                  imageDetailsModelList.add(ImageDetailsModel.imageFromLocal(
                      imgUrl: newImgUrl,
                      // e: main code
                      date: CustomDateForamt.mFormateDateDB(DateTime.now()),
                      // c: temp: for input img on different date to db
                      /* date: CustomDateForamt.mFormateDateDB(
                          DateTime.now().add(const Duration(days: 2))), */
                      timestamp:
                          DateTime.now().millisecondsSinceEpoch.toString()))
                });
        // final imgFile = File(multipleImages[i].path);
        // String imgStr = Utility.base64String(imgFile.readAsBytesSync());
      }
      return imageDetailsModelList;
    } on PlatformException catch (e) {
      Logger().d('Failed to pick image: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> mPickImgFromLocal() async {
    try {
      final imgXFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imgXFile == null) return null;
      final imgFile = File(imgXFile.path);
      String imgString = Utility.base64String(imgFile.readAsBytesSync());

      return {
        'imgString': imgString,
        'imgPath': imgXFile.path,
        'imgXFile': imgXFile
      };

      /*  setState(() {
        _imageString = imgString;
      }); */
    } on PlatformException catch (e) {
      Logger().d('Failed to pick image: $e');
    }

    return null;
  }

  static Future<Map<String, dynamic>?> mPickImgCamera() async {
    try {
      final imgXFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (imgXFile == null) return null;

      //! it's memory consuming approach
      /* final imageFileTemp = File(imgXFile.path);
      String imgString = Utility.base64String(imageFileTemp.readAsBytesSync()); */

      // do: get path only
      String imgUrl = imgXFile.path;

      await MyServices.mCopyImgFileToNewPath(imgFile: File(imgUrl))
          .then((value) => imgUrl = value);

      return {MyKeywords.singleImgUrls: imgUrl};
    } on PlatformException catch (e) {
      Logger().d('Failed to pick image: $e');
      return null;
    }
  }

  static Future<String> mCopyImgFileToNewPath({required File imgFile}) async {
    // getting a directory
    final Directory appDocumentDirectory =
        await getApplicationDocumentsDirectory();
    //getting path from directory for saving
    final String appDocumentPath = appDocumentDirectory.path;

    // $email/${Path.basename(imgFile.path)}
    // c: make imgName unique
    final String imgName = Path.basename(imgFile.path);
    // c: copy the imgFile to new path
    final File newImgFile = await imgFile.copy('$appDocumentPath/$imgName');
    // c: convert image file to image path string
    final String newImgUrl = newImgFile.path;
    // c: [Deprecated] it'll consume lots of space in memory
    /* String imgString = Utility.base64String(newImage.readAsBytesSync());
    return imgString; */
    return newImgUrl;
  }

  static Future<void> mLaunchUrl(String url) async {
    Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }

  static Future<void> mSendOpinion(
      {required String toEmail,
      required String subject,
      required String massege}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(massege)}';

    // if(await canLaunchUrl(Uri.parse(url)))

    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  //share file
  static Future<void> mShareApp() async {
    await FlutterShare.share(
        title: 'Share',
        text: 'market://details?id=com.agamilabs.maa',
        linkUrl: 'market://details?id=com.agamilabs.maa',
        // linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  static Future<bool> mCheckNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger().d('connected');

        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      Logger().d('not connected');
      return false;
    }
  }

  static String mGetParagraphTitle(String paragraph) {
    return paragraph.substring(0, paragraph.indexOf("হঃ") + 2);
  }

  static String mGetParagraphDesc(String paragraph) {
    return paragraph.substring(paragraph.indexOf("হঃ") + 2);
  }

  static String mGenerateImgUrl(int i) {
    return 'https://agamilabs.com/maa/images/512/w$i.jpg';
  }

  static int mGetWeekNoFromString(String weekNoStr) {
    String str = weekNoStr.substring(weekNoStr.indexOf('_') + 1);

    return int.parse(str);
  }

  static int mPresentWeekCalc(int totalRunningDays) {
    int presentWeek = 0;

    if (totalRunningDays % 7 == 0) {
      presentWeek = (totalRunningDays / 7).round();
    } else {
      presentWeek = (totalRunningDays / 7).ceil();
    }

    return presentWeek;
  }

  static List<KhabarModel> mGetKhabarModelList() {
    List<KhabarModel> list = [];
    List<String> title = MaaData.foodTitles;
    List<String> desc = MaaData.foodDesc;
    List<String> imgUri = MaaData.foodImages;
    for (var i = 0; i < title.length; i++) {
      list.add(
          KhabarModel(title: title[i], desc: desc[i], imgAssetUri: imgUri[i]));
    }
    return list;
  }

  static List<DayettoModel> mGetDayettoModelList() {
    List<DayettoModel> list = [];
    List<String> title = MaaData.respTitle;
    List<String> desc = MaaData.respDesc;
    List<String> imgUri = MaaData.respImgAssetUri;
    for (var i = 0; i < title.length; i++) {
      list.add(
          DayettoModel(title: title[i], desc: desc[i], imgAssetUri: imgUri[i]));
    }
    return list;
  }

  static List<EmergencyModel> mGetEmergencyModelList() {
    List<EmergencyModel> list = [];
    List<String> title = MaaData.emergDataTitle;
    List<String> desc = MaaData.emergencyDesc;
    List<String> imgUri = MaaData.emergImageAssetUri;
    for (var i = 0; i < title.length; i++) {
      list.add(EmergencyModel(
          title: title[i], desc: desc[i], imgAssetUri: imgUri[i]));
    }
    return list;
  }

  static List<JiggashaModel> mGetJiggashaModelList() {
    List<JiggashaModel> list = [];
    List<String> questions = MaaData.questions;
    List<String> answers = MaaData.answers;
    for (var i = 0; i < questions.length; i++) {
      list.add(JiggashaModel(ques: questions[i], ans: answers[i]));
    }
    return list;
  }

  /* static Future<Map<String, dynamic>> mUpdateNoteSympScreen(
      NoteModel noteModel,
      String note,
      String currentDate,
      SymptomDetailsModel sympIntenSityModel,
      String symptoms,
      List<SympDataModel> sympDataModelList,
      List<String> actualSympIntensity,
      List<String> actualSympNames) async {
    //note part
    if (noteModel.note != note) {
      int n = await MySqfliteServices.addNote(noteModel);
      // Logger().d("Num of Inserted note item: $n");
      /*   List<NoteModel> noteModelList =
                              await SqfliteServices.mFetchNotes(); */
      List<NoteModel> currentNote =
          await MySqfliteServices.mFetchCurrentNote(currentDate);
      // Logger().d(noteModelList.length);
      if (currentNote.isNotEmpty) {
        note = currentNote[0].note;
      } else {
        note = "";
      }
    }
    //symptom part
    if (sympIntenSityModel.symptoms != symptoms) {
      int n = await MySqfliteServices.addSympIntensity(sympIntenSityModel);

      MySqfliteServices.mFetchCurrentSympIntensity(currentDate)
          .then((symptomModelList) {
        SymptomDetailsModel model = symptomModelList[0];
        symptoms = model.symptoms;
        sympDataModelList =
            MyServices.mGetSympDataList(sympIntensityStr: symptoms);
        actualSympNames = MyServices.mGetSympIntensityStr(
            sympDataModelList)['actualSympNames'];
        actualSympIntensity = MyServices.mGetSympIntensityStr(
            sympDataModelList)['actualSympIntensity'];
      });
      // Logger().d(sympIntenSityModel.symptoms);
    }
    return {
      "note": note,
      "symptoms": symptoms,
      "sympDataModelList": sympDataModelList,
      "actualSympNames": actualSympNames,
      "actualSympIntensity": actualSympIntensity
    };
  } */

  static Map<String, dynamic> mGetSympIntensityStr(
      List<SympDataModel> sympDataList) {
    String sympIntensityStr = "";
    const String separator = ",";
    List<String> actualSympIntensity = [];
    List<String> actualSympNames = [];
    for (var i = 0; i < sympDataList.length; i++) {
      SympDataModel currentModel = sympDataList[i];
      sympIntensityStr = sympIntensityStr +
          currentModel.sympIntesity +
          (i == sympDataList.length - 1 ? "" : ",");
      //get actual list
      if (currentModel.sympIntesity != "") {
        actualSympIntensity.add(currentModel.sympIntesity);
        actualSympNames.add(currentModel.sympName);
      }
    }
    // List<String> strlist = sympIntensityStr.split(",");
    // Logger().d(strlist);
    return {
      "symptoms": sympIntensityStr,
      "actualSympIntensity": actualSympIntensity,
      "actualSympNames": actualSympNames
    };
  }

  static List<SympDataModel> mGetSympDataList(
      {required String sympIntensityStr}) {
    List<SympDataModel> list = [];
    List<String> symptomNames = MaaData.Symptoms;
    List<String> sympIntensities = sympIntensityStr.split(",");
    // Logger().d(sympIntensities.length);
    SympDataModel model;
    for (var i = 0; i < symptomNames.length; i++) {
      list.add(SympDataModel(
          sympName: symptomNames[i], sympIntesity: sympIntensities[i]));
    }

    return list;
  }

  static Future<List<OjonModel>> mGetBabyCurrentWeightList(
      {required sharedPreferences,
      required List<double> oldWeightList,
      required int runningWeeks,
      required double primaryWeight}) async {
    List<OjonModel> currentOjonList = [];
    OjonModel currentOjon;
    currentOjon = OjonModel(
        xAxisValue: 0.toString(), yAxisValue: primaryWeight.toString());
    currentOjonList.add(currentOjon);

    List<double> updatedCurrentList = oldWeightList..insert(0, primaryWeight);
    // Logger().d(updatedCurrentList.toString());
    double currentWeightLastValue = primaryWeight;
    //c: Algorithm to fill the blank weeks(steps) for graph value
    for (var i = 1; i <= runningWeeks; i++) {
      Map<String, dynamic> weekValuMap =
          getWeekValue(i, updatedCurrentList, currentWeightLastValue);
      currentWeightLastValue = weekValuMap['lastValue'] ?? 0;
      // Logger().d(weekValuMap['step']);
      int times = 1;
      for (var j = 0; j < weekValuMap['step']; j++) {
        updatedCurrentList[i + j] = ((weekValuMap['inc']) * 2.2) * times++ +
            (i == 0 ? updatedCurrentList[i] : updatedCurrentList[i - 1]);
        // Logger().d('Up: ${updatedCurrentList[i + j]}');
        currentOjonList.add(OjonModel(
            xAxisValue: (i + j).toString(),
            yAxisValue: (updatedCurrentList[i + j]).toStringAsFixed(2)));
      }
      i = weekValuMap['step'] + i - 1;
    }

    //Store object into SharedPreferences
    final String encodedCurrentWeightList = OjonModel.encode(currentOjonList);
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        MyKeywords.encodedBabyCurrentWeightList, encodedCurrentWeightList);

    return currentOjonList;
  }

  static Future<List<OjonModel>> mGetCurrentBabyWeightListForGraph(
      {required List<double> oldWeightList,
      required int positionOfCurrentEntry,
      required double primaryWeight}) async {
    List<OjonModel> currentOjonList = [];
    OjonModel currentOjon;
    currentOjon = OjonModel(
        xAxisValue: 0.toString(), yAxisValue: primaryWeight.toString());
    currentOjonList.add(currentOjon);

    List<double> updatedCurrentList = oldWeightList..insert(0, primaryWeight);
    // Logger().d(updatedCurrentList.toString());
    double currentWeightLastValue = primaryWeight;
    //Currrent Weights
    for (var i = 1; i <= positionOfCurrentEntry; i++) {
      Map<String, dynamic> weekValuMap =
          getWeekValue(i, updatedCurrentList, currentWeightLastValue);
      currentWeightLastValue = weekValuMap['lastValue'] ?? 0;
      // Logger().d(weekValuMap['step']);
      int times = 1;
      for (var j = 0; j < weekValuMap['step']; j++) {
        updatedCurrentList[i + j] = ((weekValuMap['inc']) * 2.2) * times++ +
            (i == 0 ? updatedCurrentList[i] : updatedCurrentList[i - 1]);
        // Logger().d('Up: ${updatedCurrentList[i + j]}');
        currentOjonList.add(OjonModel(
            xAxisValue: (i + j).toString(),
            yAxisValue: (updatedCurrentList[i + j]).toStringAsFixed(2)));
      }
      i = weekValuMap['step'] + i - 1;
    }

    //Store object into SharedPreferences
    /* final String encodedCurrentWeightList = OjonModel.encode(currentOjonList);
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'encodedCurrentWeightList', encodedCurrentWeightList); */

    return currentOjonList;
  }

  static Future<List<OjonModel>> mGetCurrentMomWeightList(
      {required sharedPreferences,
      required List<double> oldWeightList,
      required int runningWeeks,
      required double primaryWeight}) async {
    List<OjonModel> currentOjonList = [];
    OjonModel currentOjon;
    currentOjon = OjonModel(
        xAxisValue: 0.toString(), yAxisValue: primaryWeight.toString());
    currentOjonList.add(currentOjon);

    List<double> updatedCurrentList = oldWeightList..insert(0, primaryWeight);
    // Logger().d(updatedCurrentList.toString());
    double currentWeightLastValue = primaryWeight;
    //Currrent Weights
    for (var i = 1; i <= runningWeeks; i++) {
      Map<String, dynamic> weekValuMap =
          getWeekValue(i, updatedCurrentList, currentWeightLastValue);
      currentWeightLastValue = weekValuMap['lastValue'] ?? 0;
      // Logger().d(weekValuMap['step']);
      int times = 1;
      for (var j = 0; j < weekValuMap['step']; j++) {
        updatedCurrentList[i + j] = ((weekValuMap['inc']) * 2.2) * times++ +
            (i == 0 ? updatedCurrentList[i] : updatedCurrentList[i - 1]);
        // Logger().d('Up: ${updatedCurrentList[i + j]}');
        currentOjonList.add(OjonModel(
            xAxisValue: (i + j).toString(),
            yAxisValue: (updatedCurrentList[i + j]).toStringAsFixed(2)));
      }
      i = weekValuMap['step'] + i - 1;
    }

    //Store object into SharedPreferences
    final String encodedCurrentWeightList = OjonModel.encode(currentOjonList);
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'encodedCurrentWeightList', encodedCurrentWeightList);

    return currentOjonList;
  }

  static String? mGetEncodedCurrentWeightList(
      SharedPreferences sharedPreferences) {
    String? s1 = sharedPreferences.getString('encodedCurrentWeightList');

    return s1;
  }

  static List<BabyWeightsHeightsForAge> mGetBabyWeightHeightForAgeLists(
      {required String gender}) {
    List<BabyWeightsHeightsForAge> list = [];
    //make two instances with WeightsForAges data and HeightsForAges data.
    // c: [-3 SD, -2 SD, -1 SD, Median, 1 SD, 2 SD, 3 SD]
    late List<double> minThirdStdDeviationOfWeightList = []; //[-3 SD]
    late List<double> maxThirdStdDeviationOfWeightList = []; //[+3 SD]
    late List<double> minSecondStdDeviationOfWeightList = []; //[-2 SD]
    late List<double> maxSecondStdDeviationOfWeightList = []; //[+2 SD]
    late List<double> minFirstStdDeviationOfWeightList = []; //[-1 SD]
    late List<double> maxFirstStdDeviationOfWeightList = []; //[+1 SD]
    late List<double> medianOfWeightList = []; //[+1 SD]
    late List<double> minThirdStdDeviationOfHeightList = []; //[-3 SD]
    late List<double> maxThirdStdDeviationOfHeightList = []; //[+3 SD]
    late List<double> minSecondStdDeviationOfHeightList = []; //[-2 SD]
    late List<double> maxSecondStdDeviationOfHeightList = []; //[+2 SD]
    late List<double> minFirstStdDeviationOfHeightList = []; //[-1 SD]
    late List<double> maxFirstStdDeviationOfHeightList = []; //[+1 SD]
    late List<double> medianOfHeightList = []; //[+1 SD]
    int listIndex = gender == MyKeywords.male ? 0 : 1;

    for (var i = 0; i < MaaData.weight_for_age[listIndex].length; i++) {
      // c: weights
      minThirdStdDeviationOfWeightList
          .add(MaaData.weight_for_age[listIndex][i][0]); //-3 SD
      minSecondStdDeviationOfWeightList
          .add(MaaData.weight_for_age[listIndex][i][1]); //-2 SD
      minFirstStdDeviationOfWeightList
          .add(MaaData.weight_for_age[listIndex][i][2]); //-1 SD
      medianOfWeightList.add(MaaData.weight_for_age[listIndex][i][3]); //median
      maxFirstStdDeviationOfWeightList
          .add(MaaData.weight_for_age[listIndex][i][4]); //1 SD
      maxSecondStdDeviationOfWeightList
          .add(MaaData.weight_for_age[listIndex][i][5]); //2 SD
      maxThirdStdDeviationOfWeightList
          .add(MaaData.weight_for_age[listIndex][i][6]); //3 SD
      // c: heights
      minThirdStdDeviationOfHeightList
          .add(MaaData.height_for_age[listIndex][i][0]); //-3 SD
      minSecondStdDeviationOfHeightList
          .add(MaaData.height_for_age[listIndex][i][1]); //-2 SD
      minFirstStdDeviationOfHeightList
          .add(MaaData.height_for_age[listIndex][i][2]); //-1 SD
      medianOfHeightList.add(MaaData.height_for_age[listIndex][i][3]); //median
      maxFirstStdDeviationOfHeightList
          .add(MaaData.height_for_age[listIndex][i][4]); //1 SD
      maxSecondStdDeviationOfHeightList
          .add(MaaData.height_for_age[listIndex][i][5]); //2 SD
      maxThirdStdDeviationOfHeightList
          .add(MaaData.height_for_age[listIndex][i][6]); //3 SD
    }
    list.add(BabyWeightsHeightsForAge.cWeightsForAge(
        minThirdStdDeviationOfWeightList: minThirdStdDeviationOfWeightList,
        maxThirdStdDeviationOfWeightList: maxThirdStdDeviationOfWeightList,
        minSecondStdDeviationOfWeightList: minSecondStdDeviationOfWeightList,
        maxSecondStdDeviationOfWeightList: maxSecondStdDeviationOfWeightList,
        minFirstStdDeviationOfWeightList: minFirstStdDeviationOfWeightList,
        maxFirstStdDeviationOfWeightList: maxFirstStdDeviationOfWeightList,
        medianOfWeightList: medianOfWeightList));
    list.add(BabyWeightsHeightsForAge.cHeightsForAge(
        minThirdStdDeviationOfHeightList: minThirdStdDeviationOfHeightList,
        maxThirdStdDeviationOfHeightList: maxThirdStdDeviationOfHeightList,
        minSecondStdDeviationOfHeightList: minSecondStdDeviationOfHeightList,
        maxSecondStdDeviationOfHeightList: maxSecondStdDeviationOfHeightList,
        minFirstStdDeviationOfHeightList: minFirstStdDeviationOfHeightList,
        maxFirstStdDeviationOfHeightList: maxFirstStdDeviationOfHeightList,
        medianOfHeightList: medianOfHeightList));

    return list;
  }

  static Future<List<MaxMinWeightListModel>> mGetMaxMinWeihtList(
      {/* required List<double> oldWeightList, */

      required double bmi,
      required double primaryWeight,
      required int runningWeeks,
      required List<double> oldWeightList,
      required bool isItFirsttime}) async {
    List<MaxMinWeightListModel> maxminWeightList = [];
    List<OjonModel> minWeightList = [];
    List<OjonModel> maxWeightList = [];
    List<OjonModel> currentWeightList = [];
    OjonModel minOjon;
    OjonModel maxOjon;
    OjonModel currentOjon;

    minOjon = OjonModel(
        xAxisValue: 0.toString(), yAxisValue: primaryWeight.toString());
    maxOjon = OjonModel(
        xAxisValue: 0.toString(), yAxisValue: primaryWeight.toString());
    // currentOjon = Ojon(week: 0.toString(), weight: primaryWeight.toString());
/*     minOjon = Ojon(week: 0.toString(), weight: 0.toString());
    maxOjon = Ojon(week: 0.toString(), weight: 0.toString());
    currentOjon = Ojon(week: 0.toString(), weight: 0.toString()); */
    minWeightList.add(minOjon);
    maxWeightList.add(maxOjon);
    // currentWeightList.add(currentOjon);

    Logger().d("Current BMI: $bmi");

    if (bmi < 18.5) {
      //Under Weight
      Logger().d("Under");
      List<double> updatedMaxList = MaaData.underWtMx..insert(0, primaryWeight);
      List<double> updatedMinList = MaaData.underWtMn..insert(0, primaryWeight);
      // List<double> updatedCurrentList = oldWeightList..insert(0, primaryWeight);
      double maxlastValue = 0;
      double minlastValue = 0;
      double currentWeightLastValue = 0;

      //Max Weights
      for (var i = 1; i < updatedMaxList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMaxList, maxlastValue);
        maxlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMaxList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMaxList[i - 1];
          maxWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMaxList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }

      //Min Weights
      for (var i = 1; i < updatedMinList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMinList, minlastValue);
        minlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMinList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMinList[i - 1];
          minWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMinList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }

      /*    //Currrent Weights
      for (var i = 1; i < updatedCurrentList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedCurrentList, currentWeightLastValue);
        currentWeightLastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedCurrentList[i + j] =
              (weekValuMap['inc']) * times++ + updatedCurrentList[i - 1];
          currentWeightList.add(Ojon(
              week: (i + j).toString(),
              weight: (updatedCurrentList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      } */
/*       if (!isItFirsttime) {
        currentWeightList = mGetCurrentWeightList(
            oldWeightList: oldWeightList,
            runningWeeks: runningWeeks,
            primaryWeight: primaryWeight);
      } else {
        //make a dummy weekAndWeightList
        for (var i = 1; i <= oldWeightList.length; i++) {
          currentWeightList.add(
              Ojon(week: i.toString(), weight: oldWeightList[i].toString()));
        }
      } */

      maxminWeightList.add(MaxMinWeightListModel(
          minWeightList: minWeightList,
          maxWeightList: maxWeightList,
          currentOjonList: currentWeightList));

      /*   int j = 0;
      for (var element in updatedMaxList) {
        Logger().d("Index ${j} Updated maxWeight: $element");
        j++;
      }

      Logger().d("final value: ");
      for (var i = 0; i < maxWeightList.length; i++) {
        Ojon ojon = maxWeightList[i];
        Logger().d("Point $i :  (X, Y) = (${ojon.week}, ${ojon.weight}), ");
      } */
    } else if (bmi >= 18.5 && bmi < 25.0) {
      //Normal weight
      Logger().d("Normal");
/*           Logger().d(
        "primaryWeight : $primaryWeight, runningWeeks: $runningWeeks, oldWeightList: $oldWeightList, ");
 */
      List<double> updatedMaxList = MaaData.normalWtMx
        ..insert(0, primaryWeight);
      List<double> updatedMinList = MaaData.normalWtMn
        ..insert(0, primaryWeight);
      double maxlastValue = 0;
      double minlastValue = 0;
      for (var i = 1; i < updatedMaxList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMaxList, maxlastValue);
        maxlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMaxList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMaxList[i - 1];
          maxWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMaxList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }
      for (var i = 1; i < updatedMinList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMinList, minlastValue);
        minlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMinList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMinList[i - 1];
          minWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMinList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }
/*       if (!isItFirsttime) {
        currentWeightList = mGetCurrentWeightList(
            oldWeightList: oldWeightList,
            runningWeeks: runningWeeks,
            primaryWeight: primaryWeight);
      } */

      maxminWeightList.add(MaxMinWeightListModel(
          minWeightList: minWeightList,
          maxWeightList: maxWeightList,
          currentOjonList: currentWeightList));

      /*   int j = 0;
      for (var element in updatedMaxList) {
        Logger().d("Index ${j} Updated maxWeight: $element");
        j++;
      }

      Logger().d("final value: ");
      for (var i = 0; i < maxWeightList.length; i++) {
        Ojon ojon = maxWeightList[i];
        Logger().d("Point $i :  (X, Y) = (${ojon.week}, ${ojon.weight}), ");
      } */
    } else if (bmi >= 25.0 && bmi < 30.0) {
      //Over Weight
      Logger().d("OVer");
      List<double> updatedMaxList = MaaData.overWtMx..insert(0, primaryWeight);
      List<double> updatedMinList = MaaData.overWtMn..insert(0, primaryWeight);
      double maxlastValue = 0;
      double minlastValue = 0;
      for (var i = 1; i < updatedMaxList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMaxList, maxlastValue);
        maxlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMaxList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMaxList[i - 1];
          maxWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMaxList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }
      for (var i = 1; i < updatedMinList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMinList, minlastValue);
        minlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMinList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMinList[i - 1];
          minWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMinList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }

/*       if (!isItFirsttime) {
        currentWeightList = mGetCurrentWeightList(
            oldWeightList: oldWeightList,
            runningWeeks: runningWeeks,
            primaryWeight: primaryWeight);
      } */

      maxminWeightList.add(MaxMinWeightListModel(
          minWeightList: minWeightList,
          maxWeightList: maxWeightList,
          currentOjonList: currentWeightList));

      /*   int j = 0;
      for (var element in updatedMaxList) {
        Logger().d("Index ${j} Updated maxWeight: $element");
        j++;
      }

      Logger().d("final value: ");
      for (var i = 0; i < maxWeightList.length; i++) {
        Ojon ojon = maxWeightList[i];
        Logger().d("Point $i :  (X, Y) = (${ojon.week}, ${ojon.weight}), ");
      } */
    } else if (bmi >= 30.0) {
      //Obess
      Logger().d("Obess");

      List<double> updatedMaxList = MaaData.obeseWtMx..insert(0, primaryWeight);
      List<double> updatedMinList = MaaData.obeseWtMn..insert(0, primaryWeight);
      // List<double> updatedCurrentList = oldWeightList..insert(0, primaryWeight);

      double maxlastValue = 0;
      double minlastValue = 0;
      double currentWeightLastValue = 0;

      for (var i = 1; i < updatedMaxList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMaxList, maxlastValue);
        maxlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMaxList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMaxList[i - 1];
          maxWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMaxList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }
      for (var i = 1; i < updatedMinList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedMinList, minlastValue);

        minlastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedMinList[i + j] =
              (weekValuMap['inc']) * times++ + updatedMinList[i - 1];
          minWeightList.add(OjonModel(
              xAxisValue: (i + j).toString(),
              yAxisValue: (updatedMinList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      }

      /*      if (!isItFirsttime) {
        currentWeightList = mGetCurrentWeightList(
            oldWeightList: oldWeightList,
            runningWeeks: runningWeeks,
            primaryWeight: primaryWeight);
      }
      */
      /*     //Currrent Weights
      for (var i = 0; i < updatedCurrentList.length; i++) {
        Map<String, dynamic> weekValuMap =
            getWeekValue(i, updatedCurrentList, currentWeightLastValue);
        currentWeightLastValue = weekValuMap['lastValue'];
        int times = 1;
        for (var j = 0; j < weekValuMap['step']; j++) {
          updatedCurrentList[i + j] = (weekValuMap['inc']) * times++ +
              (i > 0 ? updatedCurrentList[i - 1] : updatedCurrentList[i]);
          currentWeightList.add(Ojon(
              week: (i + j).toString(),
              weight: (updatedCurrentList[i + j]).toStringAsFixed(2)));
        }
        i = weekValuMap['step'] + i - 1;
      } */

      maxminWeightList.add(MaxMinWeightListModel(
          minWeightList: minWeightList,
          maxWeightList: maxWeightList,
          currentOjonList: currentWeightList));
      /* 
      int j = 0;
      for (var element in updatedMaxList) {
        Logger().d("Index ${j} Updated maxWeight: $element");
        j++;
      }

      Logger().d("final value: ");
      for (var i = 0; i < maxWeightList.length; i++) {
        Ojon ojon = maxWeightList[i];
        Logger().d("Point $i :  (X, Y) = (${ojon.week}, ${ojon.weight}), ");
      } */
    }

    //Store object into Sharedpreferences
    final String encodedMinWeightList = OjonModel.encode(minWeightList);
    final String encodedMaxWeightList = OjonModel.encode(maxWeightList);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'encodedMinWeightList', encodedMinWeightList);
    await sharedPreferences.setString(
        'encodedMaxWeightList', encodedMaxWeightList);

    return maxminWeightList;
  }

  static Map<String, dynamic> mGetEncodedMaxMinWeightList(
      SharedPreferences sharedPreferences) {
    String s1 = sharedPreferences.getString('encodedMinWeightList')!;
    String s2 = sharedPreferences.getString('encodedMaxWeightList')!;

    return {"min": s1, "max": s2};
  }

  static double mGetBabyLastUpdatedWeight(
      {required SharedPreferences sharedPreferences}) {
    if (sharedPreferences.getDouble(MyKeywords.babyLastUpdatedWeight) != null) {
      return sharedPreferences.getDouble(MyKeywords.babyLastUpdatedWeight)!;
    } else {
      return 0.00;
    }
  }

  static double mGetLastUpdatedWeight(
      {required SharedPreferences sharedPreferences}) {
    if (sharedPreferences.getDouble(MyKeywords.lastUpdatedWeight) != null) {
      return sharedPreferences.getDouble(MyKeywords.lastUpdatedWeight)!;
    } else {
      return 0.00;
    }
  }

  static void mSetBabyLastUpdatedWeight(
      {required SharedPreferences sharedPreferences, required double w}) {
    sharedPreferences.setDouble(MyKeywords.babyLastUpdatedWeight, w);
  }

  static void mSetLastUpdatedWeight(
      {required SharedPreferences sharedPreferences, required double w}) {
    sharedPreferences.setDouble(MyKeywords.lastUpdatedWeight, w);
  }

  static double mGetBabyPrimaryWeight(
      {required SharedPreferences sharedPreferences}) {
    return sharedPreferences.getDouble(MyKeywords.babyPrimaryWeight)!;
  }

  static double mGetPrimaryWeight(
      {required SharedPreferences sharedPreferences}) {
    return sharedPreferences.getDouble(MyKeywords.primaryWeight)!;
  }

/*   static List<double> mUpdateBabyCurrentWeightList(
      {required SharedPreferences sharedPreferences,
      required double updatedWeight,
      required int actRunningWeek}) {
    List<String> oldList =
        sharedPreferences.getStringList(MyKeywords.babyWeightList)!;
    oldList[actRunningWeek] = updatedWeight.toStringAsFixed(2);
    sharedPreferences.setStringList(MyKeywords.babyWeightList, oldList);
    oldList = sharedPreferences.getStringList(MyKeywords.babyWeightList)!;
    // Logger().d("OjonList" + oldList.toString());
    List<double> oldListDoubleFormat = [];
    for (var i = 0; i < oldList.length; i++) {
      oldListDoubleFormat.add(double.parse(oldList[i]));
    }
    return oldListDoubleFormat;
  }
 */
  static List<double> mUpdateCurrentWeightList(
      {required SharedPreferences sharedPreferences,
      required double updatedWeight,
      required int actRunningWeek}) {
    List<String> oldList =
        sharedPreferences.getStringList(MyKeywords.weightList)!;
    oldList[actRunningWeek] = updatedWeight.toStringAsFixed(2);
    sharedPreferences.setStringList(MyKeywords.weightList, oldList);
    oldList = sharedPreferences.getStringList(MyKeywords.weightList)!;
    // Logger().d("OjonList" + oldList.toString());
    List<double> oldListDoubleFormat = [];
    for (var i = 0; i < oldList.length; i++) {
      oldListDoubleFormat.add(double.parse(oldList[i]));
    }
    return oldListDoubleFormat;
  }

  //m: Load Baby weight list for OjonScreen WeekAndWeightList-part
/*   static List<String> mGetBabyWeightList(
      {required SharedPreferences sharedPreferences}) {
    List<String> weightList;
    if (sharedPreferences.getStringList(MyKeywords.babyWeightList) != null) {
      // Logger().d("weightlist is not null");
      // List<double> weightListDoubleFormat = [];
      /* List<String> weightListDoubleFormat = [];
      weihtList = sharedPreferences.getStringList(MyKeywords.weightList)!;
      for (var i = 0; i < weihtList.length; i++) {
        weightListDoubleFormat.add(double.parse(weihtList[i]));
      }
      return weightListDoubleFormat; */
      weightList = sharedPreferences.getStringList(MyKeywords.babyWeightList)!;

      return weightList;
    } else {
      weightList = MyServices.mGetDummyBabyOjons();
      // Logger().d("weightList is null");
      sharedPreferences.setStringList(MyKeywords.babyWeightList, weightList);

      /*  List<double> weightListDoubleFormat = [];
      for (var i = 0; i < weightList.length; i++) {
        weightListDoubleFormat.add(double.parse(weightList[i]));
      }
      return weightListDoubleFormat; */
      return weightList;
    }
  } */

  //get weight list for OjonScreen WeekAndWeightList-part
  static List<String> mGetWeightList(
      {required SharedPreferences sharedPreferences}) {
    List<String> weightList;
    if (sharedPreferences.getStringList(MyKeywords.weightList) != null) {
      // Logger().d("weightlist is not null");
      // List<double> weightListDoubleFormat = [];
      /* List<String> weightListDoubleFormat = [];
      weihtList = sharedPreferences.getStringList(MyKeywords.weightList)!;
      for (var i = 0; i < weihtList.length; i++) {
        weightListDoubleFormat.add(double.parse(weihtList[i]));
      }
      return weightListDoubleFormat; */
      weightList = sharedPreferences.getStringList(MyKeywords.weightList)!;

      return weightList;
    } else {
      weightList = MyServices.mGetDummyOjons();
      // Logger().d("weightList is null");
      sharedPreferences.setStringList(MyKeywords.weightList, weightList);
      /*  List<double> weightListDoubleFormat = [];
      for (var i = 0; i < weightList.length; i++) {
        weightListDoubleFormat.add(double.parse(weightList[i]));
      }
      return weightListDoubleFormat; */
      return weightList;
    }
  }

  static void mSetFrucValueAsInt(
      {required double priWeight, required Function callback}) {
    final String actValue = priWeight.toStringAsFixed(1);
    for (var i = 0; i < actValue.length; i++) {
      if (actValue[i] == '.') {
        callback(int.parse(actValue[i + 1]));
      } else {
        continue;
      }
    }
  }

  static Future<SharedPreferences> mGetSharedPrefIns() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref;
  }

  static void mCalcAndSavePriBMI(
      {required SharedPreferences sharedPreferences,
      required double weight,
      required double height}) {
    final double bmi = weight / (height / 100 * height / 100);

    sharedPreferences.setDouble(MyKeywords.primaryBMI, bmi);
    sharedPreferences.setDouble(MyKeywords.primaryWeight, weight);
    sharedPreferences.setDouble(MyKeywords.primaryHeight, height);
    sharedPreferences.setDouble(MyKeywords.lastUpdatedWeight, weight);
    if (sharedPreferences.getDouble(MyKeywords.primaryBMI) != null) {
      Logger().d("Data Entry successfull");
    }
  }

  static int mGettotalDaysBtween(DateTime startDate, DateTime endDate) {
    int totalDaysBetween = _mGetDiffBetween(startDate, endDate);
    return totalDaysBetween;
  }

  static int _mGetDiffBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  static String getBangNumFormat(int num) {
    String numStr = '';
    if (num == 2 || num == 3) {
      numStr = MaaData.bangNum[num] + MaaData.bangDateSuffix[1];
    } else if (num == 4) {
      numStr = MaaData.bangNum[num] + MaaData.bangDateSuffix[2];
    } else if (num == 6) {
      numStr = MaaData.bangNum[num] + MaaData.bangDateSuffix[3];
    } else if (num <= 10) {
      numStr = mGenerateBangNum(num) + MaaData.bangDateSuffix[0];
    } else if (num <= 45) {
      numStr = mGenerateBangNum(num) + MaaData.bangDateSuffix[4];
    }

    return numStr;
  }

  static num getTimestarNum(int days) {
    if (days <= 26) {
      return (days / 13).ceil().toInt();
    } else {
      return 3;
    }
  }

  static String mGenerateBangNum(int num) {
    String inputStr = num.toString();
    String outputStr = '';

    for (var i = 0; i < inputStr.length; i++) {
      outputStr = outputStr + MaaData.bangNum[int.parse(inputStr[i])];
    }
    return outputStr;
  }

  static List<OjonModel> mGetOjonData() {
    List<OjonModel> ojonData = [];
    List<String> dummyOjons = mGetDummyOjons();
    List<String> dummyWeeks = mGetDummyWeeks();
    for (var i = 0; i < dummyWeeks.length; i++) {
      OjonModel ojon =
          OjonModel(xAxisValue: dummyWeeks[i], yAxisValue: dummyOjons[i]);
      ojonData.add(ojon);
    }
    return ojonData;
  }

  static List<OjonModel> mGetOjonDataForGraph() {
    List<OjonModel> ojonData = [];
    List<String> dummyOjons = mGetDummyOjonsForGraph();
    List<String> dummyWeeks = mGetDummyWeeksForGraph();
    for (var i = 0; i < dummyWeeks.length; i++) {
      OjonModel ojon;
      if (i == 20) {
        ojon = OjonModel(xAxisValue: dummyWeeks[i], yAxisValue: dummyOjons[i]);
      }
      ojon = OjonModel(xAxisValue: dummyWeeks[i], yAxisValue: dummyOjons[i]);
      ojonData.add(ojon);
    }
    return ojonData;
  }

  static List<OjonModel> mGetOjonDataForGraph1() {
    List<OjonModel> ojonData = [];
    List<String> dummyOjons = mGetDummyOjonsForGraph1();
    List<String> dummyWeeks = mGetDummyWeeksForGraph();
    for (var i = 0; i < dummyWeeks.length; i++) {
      OjonModel ojon;
      if (i == 20) {
        ojon = OjonModel(xAxisValue: dummyWeeks[i], yAxisValue: dummyOjons[i]);
      }
      ojon = OjonModel(xAxisValue: dummyWeeks[i], yAxisValue: dummyOjons[i]);
      ojonData.add(ojon);
    }
    return ojonData;
  }

  static List<String> mGetDummyBabyOjons() {
    final List<String> dummyOjons = [];
    const int l = 70;
    const String element1 = "0.00";
    const String elememnt2 = "---";

    for (var i = 0; i < l; i++) {
      /* if (i == 0) {
        dummyOjons.add(element1);
      } */
      dummyOjons.add(element1);
    }
    return dummyOjons;
  }

  static List<String> mGetDummyBabyHeights() {
    final List<String> dummyOjons = [];
    const int l = 70;
    const String element1 = "0.00";
    // const String elememnt2 = "---";

    for (var i = 0; i < l; i++) {
      /* if (i == 0) {
        dummyOjons.add(element1);
      } */
      dummyOjons.add(element1);
    }
    return dummyOjons;
  }

  static List<String> mGetDummyOjons() {
    final List<String> dummyOjons = [];
    const int l = 40;
    const String element1 = "0.0";
    const String elememnt2 = "---";

    for (var i = 0; i < l; i++) {
      /* if (i == 0) {
        dummyOjons.add(element1);
      } */
      dummyOjons.add(element1);
    }
    return dummyOjons;
  }

  static List<String> mGetDummyWeeks() {
    final List<String> dummyWeeks = [];
    const int l = 41;
    // const String elememnt3 = "প্রাথমিক ওজন";
    for (var i = 0; i < l; i++) {
      /*  if (i == 0) {
        dummyWeeks.add(elememnt3);
        continue;
      } */
      dummyWeeks.add(i.toString());
    }
    return dummyWeeks;
  }

  static List<String> mGetDummyOjonsForGraph() {
    final List<String> dummyOjons = [];
    const int l = 41;

    for (var i = 0; i < l; i++) {
      if (i % 2 == 1) {
        dummyOjons.add((i + 6).toString());
      } else if (i == 0) {
        dummyOjons.add(i.toString());
      }
      dummyOjons.add((i + 4).toString());
    }
    return dummyOjons;
  }

  static List<String> mGetDummyOjonsForGraph1() {
    final List<String> dummyOjons = [];
    const int l = 41;

    for (var i = 0; i < l; i++) {
      if (i % 5 == 0) {
        dummyOjons.add((i + 2).toString());
      }
      dummyOjons.add(i.toString());
    }
    return dummyOjons;
  }

  static List<String> mGetDummyWeeksForGraph() {
    final List<String> dummyWeeks = [];
    const int l = 41;
    for (var i = 0; i < l; i++) {
      dummyWeeks.add(i.toString());
    }
    return dummyWeeks;
  }

  static double mConvertKgToPound(String value) {
    return (double.parse(value) * MaaData.kgToPound);
  }

  static double mConvertPoundToKg(String value) {
    return (double.parse(value) / MaaData.kgToPound);
  }

  static int mConvertCmToFeet(String value) {
    final double v = double.parse(value);
    final double totalInch = v / MaaData.incToCm;
    final int feet = (totalInch / MaaData.feetToInch).floor();
    final int inch = (totalInch % MaaData.feetToInch).floor();

    return feet;
  }

  static int mConvertCmToInch(String value) {
    final double v = double.parse(value);
    final double totalInch = v / MaaData.incToCm;
    // final int feet = (totalInch / MaaData.feetToInch).floor();
    final int inch = (totalInch % MaaData.feetToInch).toInt();

    return inch;
  }

  static double mConvertFeetToCm(String f, String i) {
    final double feet = double.parse(f);
    final double inch = double.parse(i);

    final double totalInch = inch + feet * MaaData.feetToInch;
    final double totalCm = totalInch * MaaData.incToCm;

    return totalCm;
  }

  static bool mCheckBabyPrimaryWeight(
      {required SharedPreferences sharedPreferences}) {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final double? primaryWeight;
    primaryWeight = sharedPreferences.getDouble(MyKeywords.babyPrimaryWeight);

    if (primaryWeight == null) {
      return false;
    } else {
      return true;
    }
  }

  static bool mCheckPrimaryWeight(
      {required SharedPreferences sharedPreferences}) {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final double? primaryWeight;
    primaryWeight = sharedPreferences.getDouble(MyKeywords.primaryWeight);

    if (primaryWeight == null) {
      return false;
    } else {
      return true;
    }
  }

  static Map<String, dynamic> getWeekValue(
      int startPosition, List<double> list, double lastValue) {
    int step = 0;
    for (int i = startPosition; i < list.length; i++) {
      ++step;
      if (list[i] != 0.00) {
        double value = list[i] - lastValue;
        double stepInc = ((value / 2.2) / step);
        /*   Logger().d(
            'Start pos: $startPosition & Value is: ${value / 2.2} & step size: $step & Inc value: $stepInc'); */

        return {"inc": stepInc, "step": step, "lastValue": list[i]};
      }
    }

    return {"inc": 0, "step": 0};
  }

  static Future<Map<String, dynamic>> mSendFinalDataToApi(
      String jsonReportDataModel) async {
    // Logger().d(jsonReportDataModel);
    final response = await http.post(
      Uri.parse('https://maa.agamilabs.com/api/generate_report.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': jsonReportDataModel,
      }),
      // body: jsonReportDataModel,
    );

    if (response.statusCode == 201) {
      var res = jsonDecode(response.body);
      return res;
    } else {
      throw Exception("Failed to send data to Api");
      /*   Logger().d("Failed");
      return {}; */
    }
  }

  static List<int> mProduceWeekMonthPatternForBabyWeightHeight() {
    int totalMonth = 60;
    int totalDay = 60 * 30;
    int initialWeekRange = 13;
    int monthStartFrom = 4;
    int loopStartFrom = 0;
    List<int> list = [];

    int currentAgeInDay = 121;
    int i = (currentAgeInDay / 7).floor();
    int ageInMonth = (currentAgeInDay / 30).ceil();

    // age range checking
    // logger.d("Make WeekMonth list");
    bool flag = false;
    for (var i = 0; i <= totalMonth; i++) {
      // for (var i = 17; i <= total; i++) {
      if (i > 13 && !flag) {
        i = 4;
        flag = !flag;
      }
      list.add(i);
    }
    /* logger.w("WeekMonth list");
      logger.d(list); */

    // Logger().d(_list);
    // logger.d(_list);
    return list;
  }

  static Map<String, dynamic> mGenerateBabyWeekMonthNo(
      {required int babyCurrentAgeInDay}) {
    int totalMonth = 60;
    int totalDay = 60 * 30;
    int initialWeekRange = 13;
    int monthStartFrom = 4;
    int loopStartFrom = 0;
    List<int> list = [];

    List<BabyWeekMonthNo> listInBangFontModel = [];
    List<BabyWeekMonthNo> listInEngFontModel = [];
    List<String> listInEngFont = [];
    var weekBangla = MaaData.week;
    var monthBangla = MaaData.month;
    var weekEng = MyKeywords.weekAsTag;
    var monthEng = MyKeywords.monthAsTag;
    var text = weekBangla;
    var text2 = weekEng;

    // int currentAgeInDay = 99;
    // logger.d("Current age in day: $babyCurrentAgeInDay");
    int ageInWeek = (babyCurrentAgeInDay / 7).floor();
    int ageInMonth = (babyCurrentAgeInDay / 30).ceil();

    // age range checking
    if (ageInWeek <= initialWeekRange) {
      // logger.d("Make WeekMonth list");
      bool flag = false;
      for (ageInWeek; ageInWeek <= totalMonth; ageInWeek++) {
        // for (var i = 17; i <= total; i++) {
        if (ageInWeek > 13 && !flag) {
          ageInWeek = 4;
          flag = !flag;
          text = monthBangla;
          text2 = monthEng;
        }
        // list.add(ageInWeek);
        listInBangFontModel.add(BabyWeekMonthNo(
            num: MyServices.mGenerateBangNum(ageInWeek), text: text));

        listInEngFontModel
            .add(BabyWeekMonthNo(num: ageInWeek.toString(), text: weekEng));
        // _listOfOnlyNum.add(constList[i].toString());
        listInEngFont.add(ageInWeek.toString() + text2);
      }
      // logger.w("WeekMonth list");
      // logger.d(listOfOnlyNum);
    } else {
      for (ageInMonth; ageInMonth <= totalMonth; ageInMonth++) {
        listInBangFontModel.add(BabyWeekMonthNo(
            num: MyServices.mGenerateBangNum(ageInMonth), text: monthBangla));
        listInEngFontModel
            .add(BabyWeekMonthNo(num: ageInMonth.toString(), text: monthEng));
        // _listOfOnlyNum.add(constList[i].toString());
        listInEngFont.add(ageInMonth.toString() + monthEng);
        // Logger().d("${_list[i].num}  ${_list[i].text}");
      }
      // var res = mGetBabyOnlyMonthNo(currentMoth: ageInMonth);
      logger.w("Only Month list");
      // logger.d(listOfOnlyNum);
    }

    // return list;
    return {
      MyKeywords.intoBangFontModel: listInBangFontModel,
      MyKeywords.intoEngFontModel: listInEngFontModel,
      MyKeywords.intoEngFont: listInEngFont
    };
  }

  //m: dummy baby week/month no
  //c: 13 weeks and 5 to 60 months
  /* static Map<String, dynamic> mGetBabyBothWeekMonthNo() {
    int initialTotalMonth = 60;
    List<BabyWeekMonthNo> listInBangFont = [];
    List<String> listOfOnlyNum = [];
    var weekBangla = MaaData.week;
    var monthBangla = MaaData.month;
    var weekEng = MyKeywords.weekAsTag;
    var monthEng = MyKeywords.monthAsTag;
    var text = weekBangla;
    var text2 = weekEng;
    var constList = mProduceWeekMonthPatternForBabyWeightHeight();

    bool flag = false;

    for (var i = 0; i < constList.length; i++) {
      if (i > 13 && !flag) {
        text = monthBangla;
        text2 = monthEng;
        flag = !flag;
      }
      listInBangFont.add(BabyWeekMonthNo(
          num: MyServices.mGenerateBangNum(constList[i]), text: text));
      // _listOfOnlyNum.add(constList[i].toString());
      listOfOnlyNum.add(constList[i].toString() + text2);
      // Logger().d("${_list[i].num}  ${_list[i].text}");
    }
    /*     logger.w("ListBangFont: ${listInBangFont}");
    logger.i("ListBangFont: ${listOfOnlyNum}"); */

    return {
      MyKeywords.intoBangFont: listInBangFont,
      MyKeywords.listOfOnlyNum: listOfOnlyNum
    };
  } */

  static Map<String, dynamic> mGetBabyOnlyMonthNo({required int currentMoth}) {
    int initialTotalMonth = 60;
    List<BabyWeekMonthNo> listInBangFont = [];
    List<String> listOfOnlyNum = [];
    // var weekBangla = MaaData.week;
    var monthBangla = MaaData.month;
    // var weekEng = MyKeywords.weekAsTag;
    var monthEng = MyKeywords.monthAsTag;
    var text = monthBangla;
    var text2 = monthEng;
    // var constList = mProduceWeekMonthPatternForBabyWeightHeight();
    bool flag = false;

    logger.d(currentMoth);

    for (currentMoth; currentMoth <= initialTotalMonth; currentMoth++) {
      /* if (currentMoth > 13 && !flag) {
        text = monthBangla;
        text2 = monthEng;
        flag = !flag;
      } */
      listInBangFont.add(BabyWeekMonthNo(
          num: MyServices.mGenerateBangNum(currentMoth), text: text));
      // _listOfOnlyNum.add(constList[i].toString());
      listOfOnlyNum.add(currentMoth.toString() + text2);
      // Logger().d("${_list[i].num}  ${_list[i].text}");
    }
/*     logger.w("ListBangFont: ${listInBangFont}");
    logger.i("ListBangFont: ${listOfOnlyNum}");
 */
    return {
      MyKeywords.intoBangFontModel: listInBangFont,
      MyKeywords.intoEngFont: listOfOnlyNum
    };
  }

/*   static Future<double> mGetLastGivenMomWeight({required MomInfo momInfo}){

  } */

  static Future<Map<String, dynamic>> mGetLastGivenWeight(
      {required int babyId, required String email, required int momId}) async {
    double lastWeight = 0;
    double lastHeight = 0;
    late int index;
    await MySqfliteServices.mGetBabyCurrentWeightHeightList(
            email: email, momId: momId, babyId: babyId)
        .then((value) {
      for (var element in value[MyKeywords.babyWeight]) {
        if (element == '0') {
          continue;
        } else {
          lastWeight = double.parse(element);
        }
      }
      for (var element in value[MyKeywords.babyHeight]) {
        if (element == '0') {
          continue;
        } else {
          lastHeight = double.parse(element);
        }
      }
    });

    return {
      MyKeywords.lastGivenWeight: lastWeight,
      MyKeywords.lastGivenHeight: lastHeight,
    };
  }

  static int mGetRunningDays({required DateTime dob}) {
    Duration diff = DateTime.now().difference(dob);
    int result = diff.inDays + 1;
    return result;
    // Logger().d("Running Day: " + runningday.toString());
  }

  static Map<String, dynamic> mGetBabyAge({required int runningday}) {
    int ageNum;
    String ageTag;
    // runningday = 24; //test
    if (runningday <= (7 * 13)) {
      ageNum = (runningday / 7).floor();
      // Logger().d(runningday / 7);
      ageTag = 'w';
    } else {
      ageNum = runningday % 30 != 0
          ? (runningday / 30).ceil()
          : (runningday / 30).floor();
      ageTag = 'm';
    }
    return {MyKeywords.ageNum: ageNum, MyKeywords.ageTag: ageTag};
  }

  static List<double> mMakeCurrentWeightsToDouble(
      {required List<String> currentWeightsList}) {
    List<double> list = [];
    for (var element in currentWeightsList) {
      list.add(double.parse(element));
    }
    return list;
  }

  static List<OjonModel> mMakeCurrentWeightsForGraph(
      {required List<String> currentWeightsStringList,
      required List<String> babyWeekMonthNumStringList}) {
    List<OjonModel> _list = [];
    // Logger().d("CurrentWeightsStringLIst: $currentWeightsStringList");
    for (int i = 0; i < currentWeightsStringList.length; i++) {
      var item = currentWeightsStringList[i];
      if (item != "0") {
        _list.add(OjonModel(
            xAxisValue: babyWeekMonthNumStringList[i], yAxisValue: item));
      }

      /*  _list.add(OjonModel(
          xAxisValue: currentWeightsStringList.indexOf(item).toString(),
          yAxisValue: item)); */
    }
    for (var element in _list) {
      logger.d(
          "Graph Value List: xAxisValue: ${element.xAxisValue} yAxisvalue: ${element.yAxisValue}");
      
    }
    return _list;
  }

  static List<HeightModel> mMakeCurrentHeightsForGraph(
      {required List<String> currentHeightsStringList,
      required List<String> babyWeekMonthNumStringList}) {
    List<HeightModel> _list = [];
    // Logger().d("CurrentWeightsStringLIst: $currentWeightsStringList");
    for (int i = 0; i < currentHeightsStringList.length; i++) {
      var item = currentHeightsStringList[i];
      if (item != "0") {
        _list.add(HeightModel(
            xAxisValue: babyWeekMonthNumStringList[i], yAxisValue: item));
      }

      /*  _list.add(OjonModel(
          xAxisValue: currentWeightsStringList.indexOf(item).toString(),
          yAxisValue: item)); */
    }

    return _list;
  }
}
