import 'package:maa/consts/const.keywords.dart';

class SymptomDetailsModel {
  late String date;
  late String symptoms;
  late String sympName;
  late String sympIntensity;
  late List<SymptomDetailsModel> listSympNameAndIntensity;
  late String email;
  late int momId;

  SymptomDetailsModel({required this.date, required this.symptoms});
  SymptomDetailsModel.nameAndIntensity(
      {required this.date,
      required this.sympName,
      required this.sympIntensity});
  SymptomDetailsModel.sympDetailsData(
      {required this.date, required this.listSympNameAndIntensity});
  SymptomDetailsModel.nInsertSymp(
      {required this.email,
      required this.momId,
      required this.symptoms,
      required this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "date": date,
      "symptoms": symptoms,
      MyKeywords.email: email,
      MyKeywords.momId: momId
    };
  }

  Map<String, dynamic> toJsonNameAndIntensity() {
    return {"name": sympName, "intensity": sympIntensity};
  }

  Map<String, dynamic> toJsonSympNameAndIntensityList() {
    List<Map>? mapSympNameAndIntensity = listSympNameAndIntensity.isNotEmpty
        ? listSympNameAndIntensity
            .map((e) => e.toJsonNameAndIntensity())
            .toList()
        : null;
    return {"date": date, "symplist": mapSympNameAndIntensity};
  }

/*   Map<String, dynamic> toJsonSympDetailsData(){
    return {
      "date": date,
      "symplist": 
    }
  } */
}
