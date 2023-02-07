import 'dart:core';

import 'package:path/path.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Model/model.baby_growth.dart';
import 'package:splash_screen/Model/model.image_details.dart';
import 'package:splash_screen/Model/model.current_baby_info.dart';
import 'package:splash_screen/Model/model.note.dart';
import 'package:splash_screen/Model/model.symp_details.dart';
import 'package:splash_screen/consts/const.data.bn.dart';
import 'package:splash_screen/consts/const.keywords.dart';
import 'package:sqflite/sqflite.dart';

class MySqfliteServices {
  static Future<Database> dbInit() async {
    //initiate db
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'app.db');

    //delete the Database
    // await deleteDatabase(path);

    return await openDatabase(
      //open the database or create a database if there isn't any
      path,
      version: MaaData.VERSION,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE ${MyKeywords.momnote} (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, note TEXT)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.momsymptoms} (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, symptoms TEXT)");

        await db.execute(
            "CREATE TABLE ${MyKeywords.weeklychanges} (id INTEGER PRIMARY KEY AUTOINCREMENT,  week_no TEXT, title TEXT, changes_in_child TEXT, changes_in_mom TEXT, symptoms TEXT, instructions TEXT)");
        await db.execute("CREATE TABLE ${MyKeywords.babydiary}"
            " (id INTEGER PRIMARY KEY AUTOINCREMENT, baby_id NUMBER, email TEXT, imgUrl TEXT, latitude number, longitude number, timestamp TEXT, date TEXT, caption TEXT)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.babygrowth} (id INTEGER PRIMARY KEY AUTOINCREMENT, baby_id NUMBER, timestar NUMBER, ques_id TEXT, question TEXT,  status NUMBER, timestamp TEXT, options TEXT)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.babyprimary} (id INTEGER PRIMARY KEY AUTOINCREMENT, firebase_id TEXT, session_start TEXT, session_end TEXT)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.babyinfoTable} (${MyKeywords.baby_id} INTEGER PRIMARY KEY AUTOINCREMENT, ${MyKeywords.babyName} TEXT, ${MyKeywords.dob} TEXT, ${MyKeywords.gender} TEXT, ${MyKeywords.weight} NUMBER,${MyKeywords.height} NUMBER, ${MyKeywords.headCircumstance} NUMBER, ${MyKeywords.fatherName} TEXT, ${MyKeywords.motherName} TEXT, ${MyKeywords.doctorName} TEXT, ${MyKeywords.nurseName} TEXT, ${MyKeywords.timestamp} NUMBER)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.babyweightsAndHeightsTable} (${MyKeywords.baby_id} INTEGER, ${MyKeywords.ageNum} INTEGER, ${MyKeywords.ageTag} TEXT, ${MyKeywords.babyWeight} NUMBER, ${MyKeywords.babyHeight} NUMBER)");
        /* id INTEGER PRIMARY KEY AUTOINCREMENT,  */
      },
    );
  }

  static Future<bool> mIsDbTableEmpty({required String tableName}) async {
    final db = await MySqfliteServices.dbInit();
    int count = 0;

    count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tableName"))!;
    // print("db count $count");

    if (count > 0) {
      return false;
    } else {
      return true;
    }
  }

  static Future<int> mAddBabyInfo(
      {required String babyName,
      required String dob,
      required double weight,
      required double height,
      required String gender,
      double? headCircumstance,
      String? fatherName,
      String? motherName,
      String? doctorName,
      String? nurseName}) async {
    final db = await MySqfliteServices.dbInit();
    var ts = DateTime.now().microsecondsSinceEpoch;

    int i = await db.insert(
        MyKeywords.babyinfoTable,
        {
          MyKeywords.babyName: babyName,
          MyKeywords.dob: dob,
          MyKeywords.weight: weight,
          MyKeywords.height: height,
          MyKeywords.gender: gender,
          MyKeywords.headCircumstance: headCircumstance,
          MyKeywords.fatherName: fatherName,
          MyKeywords.motherName: motherName,
          MyKeywords.doctorName: doctorName,
          MyKeywords.nurseName: nurseName,
          MyKeywords.timestamp: ts
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);

    final r = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    var id = int.parse(r[0][MyKeywords.baby_id].toString());

    var weightsList = MyServices.mGetDummyBabyOjons();
    var heightsList = MyServices.mGetDummyBabyHeights();
    weightsList.insert(0, weight.toString());
    heightsList.insert(0, height.toString());
    var ageNumList = MyServices.mProduceWeekMonthNo();

    // print("ageNumList ${ageNumList.length} weightlist ${weightsList.length}");

    //c: store weightlist and heightList against id
    List<CurrentBabyInfo> list = [];
    List<CurrentBabyInfo> list1 = [];
    late int n;
    var ageTag = MyKeywords.weekAsTag;
    for (var i = 0; i < ageNumList.length; i++) {
      var ageNum = ageNumList[i];
      if (i > 13) {
        ageTag = MyKeywords.monthAsTag;
      }

      // print("Baby id is: $id");

      // c: create object list for weight
      list.add(
        CurrentBabyInfo.weightAndHeight(
            baby_id: id,
            ageNum: ageNum,
            ageTag: ageTag,
            dummyWeight: weightsList[i],
            dummyHeight: heightsList[i]),
      );
/* 
      list1.add(CurrentBabyInfo.height(
          baby_id: id,
          ageNum: ageNum,
          ageTag: ageTag,
          dummyHeight: 0.toString())); */
      // c: store each object into babyweights table
      n = await db.insert(MyKeywords.babyweightsAndHeightsTable,
          list[i].weightsAndHeightsToJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    print("Done.");

    return i;

    /* print("babyName: $babyName");
    print("dob: $dob");
    print("weight: $weight");
    print("headCircumstance: $headCircumstance");
    print("fatherName: $fatherName");
    print("motherName: $motherName");
    print("doctorName: $doctorName");
    print("nurseName: ${nurseName.runtimeType}"); */
  }

  static Future<List<String>> mGetBabyCurrentHeightList() async {
    final db = await MySqfliteServices.dbInit();
    List<String> heightList = [];
    int id;
    var mapResults;

    await MySqfliteServices.mGetCurrentBabyId().then((value) async {
      id = value;
      mapResults = await db.rawQuery(
          "SELECT ${MyKeywords.babyHeight} FROM ${MyKeywords.babyweightsAndHeightsTable} WHERE ${MyKeywords.baby_id} = ?",
          [id]);
    });

    // print("Here Current id is: $id");

    List.generate(mapResults.length, (index) {
      heightList.add(mapResults[index][MyKeywords.babyHeight].toString());
      // print("Lsit: ${mapResults[index][MyKeywords.dummyWeight].toString()}");
    });

    return heightList;
  }

  static Future<Map<String, dynamic>> mGetBabyCurrentWeightHeightList() async {
    final db = await MySqfliteServices.dbInit();
    List<String> babyWeightList = [];
    List<String> babyHeightList = [];
    int id;
    var mapResults;

    await MySqfliteServices.mGetCurrentBabyId().then((value) async {
      id = value;
      mapResults = await db.rawQuery(
          "SELECT ${MyKeywords.babyWeight}, ${MyKeywords.babyHeight} FROM ${MyKeywords.babyweightsAndHeightsTable} WHERE ${MyKeywords.baby_id} = ?",
          [id]);
    });

    // print("Here Current id is: $id");

    List.generate(mapResults.length, (index) {
      babyWeightList.add(mapResults[index][MyKeywords.babyWeight].toString());
      // print("Lsit: ${mapResults[index][MyKeywords.dummyWeight].toString()}");
    });
    List.generate(mapResults.length, (index) {
      babyHeightList.add(mapResults[index][MyKeywords.babyHeight].toString());
      // print("Lsit: ${mapResults[index][MyKeywords.dummyWeight].toString()}");
    });

    return {
      MyKeywords.babyWeight: babyWeightList,
      MyKeywords.babyHeight: babyHeightList
    };
  }

  static Future<int> mGetCurrentBabyId() async {
    final db = await MySqfliteServices.dbInit();

    final r1 = await db.rawQuery(
        "SELECT ${MyKeywords.baby_id} FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    int id = int.parse(r1[0][MyKeywords.baby_id].toString());
    return id;
  }

  static Future<DateTime> mGetCurrentBabyDob() async {
    final db = await MySqfliteServices.dbInit();
    var result;
    await MySqfliteServices.mGetCurrentBabyId().then((id) async {
      result = await db.rawQuery(
          "SELECT ${MyKeywords.dob} FROM ${MyKeywords.babyinfoTable} WHERE ${MyKeywords.baby_id} = ?",
          [id]);
    });
    // final mapResult =
    DateTime dateTime = DateTime.parse(result[0][MyKeywords.dob]);

    return dateTime;
  }

  static Future<void> mUpdateAnswerStatus(
      {required int babyId,
      required String quesId,
      required int status}) async {
    final db = await MySqfliteServices.dbInit();
    var r = await db.rawUpdate(
        "UPDATE ${MaaData.TABLE_NAMES[5]} SET status = ? WHERE baby_id = ? AND ques_id = ?",
        [status, babyId, quesId]);

    print("update result: $r");
  }

  static Future<int> mAddBabyPrimaryDetails(
      {String? session_start, String? firebase_id, String? session_end}) async {
    final db = await MySqfliteServices.dbInit();
    int numOfInsertedRow = await db.insert(MaaData.TABLE_NAMES[6], {
      "firebase_id": firebase_id,
      'session_start': session_start,
      'session_end': session_end,
    });

    return numOfInsertedRow;
  }

  static Future<int> mAddInitialQuesDataOfBabyGrowth(
      {required BabyGrowthModel babyGrowthModel}) async {
    final db = await MySqfliteServices.dbInit();

    var numOfInserted = db.insert(
        MaaData.TABLE_NAMES[5], babyGrowthModel.toJsonInitialQuesData(),
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return numOfInserted;
  }

  static Future<void> mAddWeeklyChangeData(bool isDbTableEmpty) async {
    if (isDbTableEmpty) {
      final db = await MySqfliteServices.dbInit();
      int startWeekNo = MaaData.startWeekNo;
      int endWeekNo = MaaData.endWeekNo;
      int insertedRowNum = 0;

      for (var i = startWeekNo; i <= endWeekNo; i++) {
        String currentWeekNo = 'week_$i';
        Map<String, dynamic> map = MaaData.WeeklyChangeJsonData[currentWeekNo];

        insertedRowNum = await db.insert(
          MaaData.TABLE_NAMES[3],
          {
            'week_no': currentWeekNo,
            'title': map['title'],
            'changes_in_child': map['changes_in_child'],
            'changes_in_mom': map['changes_in_mom'],
            'symptoms': map['symptoms'],
            'instructions': map['instructions'],
          },
          conflictAlgorithm: ConflictAlgorithm
              .ignore, // ignores conflictAlgo due to duplicate entries
        );
      }
      // print(insertedRowNum);
    }
  }

  static Future<int> addNote(NoteModel noteModel) async {
    // return number of items inserted as int
    final db = await MySqfliteServices.dbInit();
    return db.insert(
      MaaData.TABLE_NAMES[0],
      noteModel.toJson(), //toMap fuch from NoteModel
      conflictAlgorithm: ConflictAlgorithm
          .ignore, // ignores conflictAlgo due to duplicate entries
    );
  }

// c: [Deprecated] for single image selection
/*   static Future<int> mAddBabyGalleryDataToLocal(
      ImageDetailsModel imageDetailsModel) async {
    final db = await SqfliteServices.dbInit();

    print('json decode : ' + (imageDetailsModel.date.toString()));

    return db.insert(
        MaaData.TABLE_NAMES[4], imageDetailsModel.toJsonForSqlite(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  } */
  //c: for multiple selection of image
  static Future<int> mAddBabyGalleryDataToLocal(
      List<ImageDetailsModel> listImageDetailsModel) async {
    final db = await MySqfliteServices.dbInit();
    int insertCount = 0;

    for (var item in listImageDetailsModel) {
      // print('json decode : ' + (item.date.toString()));

      await db.insert(MaaData.TABLE_NAMES[4], item.allDataToJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      insertCount++;
    }
    return insertCount;
  }

  static Future<int> addSympIntensity(
      SymptomDetailsModel sympIntenSityModel) async {
    final db = await MySqfliteServices.dbInit();
    return db.insert(MaaData.TABLE_NAMES[2], sympIntenSityModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<NoteModel>> mFetchNotes() async {
    // returns the memos as a list (array)
    final db = await MySqfliteServices.dbInit();
    // query all the rows in a table as an array of maps
    // final maps = await db.query("SELECT * FROM momnote");
    final maps = await db.rawQuery("SELECT * FROM ${MaaData.TABLE_NAMES[0]}");

    // print(maps.length);
    return List.generate(maps.length,
        // create a list of notes
        (index) {
      return NoteModel(
          date: maps[index]['date'].toString(),
          note: maps[index]['note'].toString());
    });
  }

/*   static Future<List<Map<String, Object?>>> mGetCurrentBabyWeightList(
      {required int id}) async {
    final db = await MySqfliteServices.dbInit();

    var result = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyweightsTable} WHERE id=?", [id]);

    return result;
  } */

  static Future<int> mGetBabyId() async {
    final db = await MySqfliteServices.dbInit();

    int n = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM ${MaaData.TABLE_NAMES[6]}'))!;
    return n;
  }

  static Future<CurrentBabyInfo> mGetCurrentBabyInfo() async {
    final db = await MySqfliteServices.dbInit();

    // c: read only the last added baby info
    final results = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    CurrentBabyInfo lastBabyInfo = CurrentBabyInfo.fromjson(results.first);

    return lastBabyInfo;
  }

  static Future<String> mGetCurrentBabyGender() async {
    final db = await MySqfliteServices.dbInit();

    var result = await db.rawQuery(
        "SELECT ${MyKeywords.gender} FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    // Map<String, dynamic> map = result[0];

    return result[0][MyKeywords.gender].toString();
  }

  // m: Fetch Baby Diary data from Sqflite Db
  static Future<List<ImageDetailsModel>> mFetchBabyDiaryDataFromSqflite(
      {required int babyId, required String email}) async {
    final db = await MySqfliteServices.dbInit();

    final maps = await db.rawQuery(
        //e: this statement showed an error as '@gmail.com' exception
        // "SELECT * FROM ${MaaData.TABLE_NAMES[4]} WHERE baby_id = $babyId AND email = $email ORDER BY date");
        //c: it's working
        "SELECT * FROM ${MaaData.TABLE_NAMES[4]} WHERE baby_id = ? AND email = ? ORDER BY timestamp",
        [babyId, email]);

    return List.generate(maps.length, (index) {
      return ImageDetailsModel.allDataFromJson(maps[index]);
    });
  }

  static Future<List<BabyGrowthModel>> mFetchBabyGrowthQues(
      {required int babyId, required int timestar}) async {
    final db = await MySqfliteServices.dbInit();
    // var _listBabyGrowthModel = <BabyGrowthModel>[];

    var maps = await db.rawQuery(
        'SELECT * FROM ${MaaData.TABLE_NAMES[5]} WHERE baby_id = $babyId AND timestar = $timestar');

    return List.generate(maps.length, (index) {
      return BabyGrowthModel.initialQuesData(
        question: maps[index]['question'].toString(),
        quesId: maps[index]['ques_id'].toString(),
        ansStatus: int.parse(maps[index]['status'].toString()),
        babyId: int.parse(maps[index]['baby_id'].toString()),
        timestar: int.parse(maps[index]['timestar'].toString()),
        timestamp: maps[index]['timestamp'].toString(),
        options: maps[index]['options'].toString(),
      );
    });

    // return _listBabyGrowthModel;
  }

  static Future<List<Map<String, dynamic>>> mFetchForwardTabsData(
      int presentWeeks) async {
    List<Map<String, dynamic>> mapList = [{}];

    final db = await MySqfliteServices.dbInit();
    String currentWeekNo = 'week_';
    int tab_1WeekNo;
    int tab_2WeekNo;
    int tab_3WeekNo;
    int tab_4WeekNo;

    if (presentWeeks <= MaaData.startWeekNo) {
      //case 1
      tab_1WeekNo = presentWeeks;
      tab_2WeekNo = presentWeeks + 1;
      tab_3WeekNo = presentWeeks + 2;
      tab_4WeekNo = presentWeeks + 3;

      print('case 1');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else if (presentWeeks == MaaData.startWeekNo + 1) {
      //case 2
      tab_1WeekNo = presentWeeks - 1;
      tab_2WeekNo = presentWeeks;
      tab_3WeekNo = presentWeeks + 1;
      tab_4WeekNo = presentWeeks + 2;

      print('case 2');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else if (presentWeeks >= MaaData.endWeekNo) {
      //case 3
      tab_1WeekNo = MaaData.endWeekNo - 3;
      tab_2WeekNo = MaaData.endWeekNo - 2;
      tab_3WeekNo = MaaData.endWeekNo - 1;
      tab_4WeekNo = MaaData.endWeekNo;

      print('case 3');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else {
      //case 4
      tab_1WeekNo = presentWeeks - 2;
      tab_2WeekNo = presentWeeks - 1;
      tab_3WeekNo = presentWeeks;
      tab_4WeekNo = presentWeeks + 1;

      print('case 4');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    }

    mapList = await db.rawQuery("""
          SELECT ${MyKeywords.week_no}, ${MyKeywords.title}, ${MyKeywords.changes_in_child},
           ${MyKeywords.changes_in_mom}, ${MyKeywords.symptoms}, ${MyKeywords.instructions} FROM ${MaaData.TABLE_NAMES[3]}
           WHERE ${MyKeywords.week_no} = '$currentWeekNo$tab_1WeekNo' OR ${MyKeywords.week_no} = '$currentWeekNo$tab_2WeekNo'
            OR ${MyKeywords.week_no} = '$currentWeekNo$tab_3WeekNo'  OR ${MyKeywords.week_no} = '$currentWeekNo$tab_4WeekNo'
            """);

    /* 
       */

    return mapList;
  }

  static Future<List<Map<String, dynamic>>> mFetchBackwardTabsData(
      int presentWeeks) async {
    List<Map<String, dynamic>> mapList = [{}];

    final db = await MySqfliteServices.dbInit();
    String currentWeekNo = 'week_';
    int tab_1WeekNo;
    int tab_2WeekNo;
    int tab_3WeekNo;
    int tab_4WeekNo;

    if (presentWeeks <= MaaData.startWeekNo) {
      //case 1
      tab_1WeekNo = presentWeeks;
      tab_2WeekNo = presentWeeks + 1;
      tab_3WeekNo = presentWeeks + 2;
      tab_4WeekNo = presentWeeks + 3;

      print('case 1');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else if (presentWeeks == MaaData.startWeekNo + 1) {
      //case 2
      tab_1WeekNo = presentWeeks - 1;
      tab_2WeekNo = presentWeeks;
      tab_3WeekNo = presentWeeks + 1;
      tab_4WeekNo = presentWeeks + 2;

      print('case 2');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else if (presentWeeks >= MaaData.endWeekNo) {
      //case 3
      tab_1WeekNo = MaaData.endWeekNo - 3;
      tab_2WeekNo = MaaData.endWeekNo - 2;
      tab_3WeekNo = MaaData.endWeekNo - 1;
      tab_4WeekNo = MaaData.endWeekNo;

      print('case 3');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else {
      //case 4
      tab_1WeekNo = presentWeeks - 1;
      tab_2WeekNo = presentWeeks;
      tab_3WeekNo = presentWeeks + 1;
      tab_4WeekNo = presentWeeks + 2;

      print('case 4');
      print("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    }

    mapList = await db.rawQuery("""
          SELECT ${MyKeywords.week_no}, ${MyKeywords.title}, ${MyKeywords.changes_in_child},
           ${MyKeywords.changes_in_mom}, ${MyKeywords.symptoms}, ${MyKeywords.instructions} FROM ${MaaData.TABLE_NAMES[3]}
           WHERE ${MyKeywords.week_no} = '$currentWeekNo$tab_1WeekNo' OR ${MyKeywords.week_no} = '$currentWeekNo$tab_2WeekNo'
            OR ${MyKeywords.week_no} = '$currentWeekNo$tab_3WeekNo'  OR ${MyKeywords.week_no} = '$currentWeekNo$tab_4WeekNo'
            """);

    /* 
       */

    return mapList;
  }

  static Future<List<NoteModel>> mFetchCurrentNote(String currentDate) async {
    // returns the memos as a list (array)
    final db = await MySqfliteServices.dbInit();
    // query all rows belonging an specific date in a table as an array of maps

    final maps = await db.rawQuery(
        "SELECT date, note FROM ${MaaData.TABLE_NAMES[0]} WHERE date = '$currentDate' GROUP BY date");
    // await db.rawQuery("SELECT date, note FROM ${MaaData.TABLE_NAMES[0]} WHERE date = '$currentDate'  GROUP BY date ORDER BY date DESC");

    // print(maps.length);
    return List.generate(maps.length,
        // create a list of notes
        (index) {
      return NoteModel(
          date: maps[index]['date'].toString(),
          note: maps[index]['note'].toString());
    });
  }

  static Future<List<SymptomDetailsModel>> mFetchCurrentSympIntensity(
      String currentDate) async {
    final db = await MySqfliteServices.dbInit();

    final maps = await db.rawQuery(
        "SELECT date, symptoms FROM ${MaaData.TABLE_NAMES[2]} WHERE date = '$currentDate' GROUP BY date");

    return List.generate(maps.length, (index) {
      return SymptomDetailsModel(
          date: maps[index]['date'].toString(),
          symptoms: maps[index]['symptoms'].toString());
    });
  }

  static Future<List<SymptomDetailsModel>> mFetchAllSympIntensity() async {
    final db = await MySqfliteServices.dbInit();

    final maps = await db.rawQuery(
        "SELECT date, symptoms FROM ${MaaData.TABLE_NAMES[2]} GROUP BY date");

    return List.generate(maps.length, (index) {
      return SymptomDetailsModel(
          date: maps[index]['date'].toString(),
          symptoms: maps[index]['symptoms'].toString());
    });
  }

  static Future<void> mUpdateBabyCurrentWeightList(
      {required double weight, required Map<String, dynamic> map}) async {
    final db = await MySqfliteServices.dbInit();

    int id = await MySqfliteServices.mGetCurrentBabyId();
    /*  print("id: ${id.runtimeType}");
    print("weight: ${id.runtimeType}");
    print("id: ${id.runtimeType}");
    print("id: ${id.runtimeType}"); */
    /* print("ID is: $id");
    print(
        "AgeNum: ${map[MyKeywords.ageNum]} , AgeTag: ${map[MyKeywords.ageTag]}");
    print("Updated weight: $weight"); */

    var r = await db.rawUpdate(
        "UPDATE ${MyKeywords.babyweightsAndHeightsTable} SET ${MyKeywords.babyWeight} = ? WHERE ${MyKeywords.baby_id} = ? AND ${MyKeywords.ageNum} = ? AND ${MyKeywords.ageTag} = ?",
        [weight, id, map[MyKeywords.ageNum], map[MyKeywords.ageTag]]);

    print("Update Result: $r");
  }

  static Future<void> mUpdateBabyCurrentHeightList(
      {required double height, required Map<String, dynamic> map}) async {
    final db = await MySqfliteServices.dbInit();

    int id = await MySqfliteServices.mGetCurrentBabyId();
    /*  print("id: ${id.runtimeType}");
    print("weight: ${id.runtimeType}");
    print("id: ${id.runtimeType}");
    print("id: ${id.runtimeType}"); */
    /* print("ID is: $id");
    print(
        "AgeNum: ${map[MyKeywords.ageNum]} , AgeTag: ${map[MyKeywords.ageTag]}");
    print("Updated weight: $weight"); */

    var r = await db.rawUpdate(
        "UPDATE ${MyKeywords.babyweightsAndHeightsTable} SET ${MyKeywords.babyHeight} = ? WHERE ${MyKeywords.baby_id} = ? AND ${MyKeywords.ageNum} = ? AND ${MyKeywords.ageTag} = ?",
        [height, id, map[MyKeywords.ageNum], map[MyKeywords.ageTag]]);

    print("Update Result: $r");
  }
}
