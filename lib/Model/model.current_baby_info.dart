import 'package:splash_screen/consts/const.keywords.dart';

class CurrentBabyInfo {
  late String babyName;
  late String dob;
  late double weight;
  late double height;
  late String gender;
  late double headCircumstance;
  late String fatherName;
  late String motherName;
  late String doctorName;
  late String nurseName;
  late int babyId;
  late int momId;
  late String email;
  late int ageNum;
  late String ageTag;
  late String dummyWeight;
  late String dummyHeight;

  CurrentBabyInfo(
      {required this.babyName,
      required this.dob,
      required this.weight,
      required this.gender,
      required this.headCircumstance,
      required this.fatherName,
      required this.motherName,
      required this.doctorName,
      required this.nurseName});

  CurrentBabyInfo.weightAndHeight({
    required this.babyId,
    required this.ageNum,
    required this.ageTag,
    required this.dummyWeight,
    required this.dummyHeight,
  });
  /*   CurrentBabyInfo.height(
      {required this.baby_id,
      required this.ageNum,
      required this.ageTag,
      required this.dummyHeight}); */

  CurrentBabyInfo.fromjson(Map<String, dynamic> json) {
    babyId = json[MyKeywords.baby_id];
    momId = json[MyKeywords.momId];
    email = json[MyKeywords.email];
    babyName = json[MyKeywords.babyName];
    dob = json[MyKeywords.dob];
    weight = double.parse(json[MyKeywords.weight]);
    // weight = json[MyKeywords.weight];
    height = double.parse(json[MyKeywords.height]);
    // height = json[MyKeywords.height];
    gender = json[MyKeywords.gender];
    // headCircumstance = double.parse(json[MyKeywords.headCircumstance]);
    headCircumstance = double.parse(json[MyKeywords.headCircumstance]);
    fatherName = json[MyKeywords.fatherName];
    motherName = json[MyKeywords.motherName];
    doctorName = json[MyKeywords.doctorName];
    nurseName = json[MyKeywords.nurseName];
  }

  /* CurrentBabyInfo.idFromJson(Map<String, dynamic> json){
    
  } */

  Map<String, dynamic> weightsAndHeightsToJson() {
    Map<String, dynamic> json = {};
    json[MyKeywords.baby_id] = babyId;
    json[MyKeywords.ageNum] = ageNum;
    json[MyKeywords.ageTag] = ageTag;
    json[MyKeywords.babyWeight] = dummyWeight;
    json[MyKeywords.babyHeight] = dummyHeight;
    return json;
  }

  /*   Map<String, dynamic> heightsToJson() {
    Map<String, dynamic> json = {};

    json[MyKeywords.baby_id] = baby_id;
    json[MyKeywords.ageNum] = ageNum;
    json[MyKeywords.ageTag] = ageTag;
    json[MyKeywords.dummyHeight] = dummyHeight;

    return json;
  } */
}
