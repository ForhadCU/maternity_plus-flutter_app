class SymptomDetailsModel {
  late String date;
  late String symptoms;
  late String sympName;
  late String sympIntensity;
  late List<SymptomDetailsModel> listSympNameAndIntensity;

  SymptomDetailsModel({required this.date, required this.symptoms});
  SymptomDetailsModel.nameAndIntensity(
      {required this.date, required this.sympName, required this.sympIntensity});
  SymptomDetailsModel.sympDetailsData(
      {required this.date, required this.listSympNameAndIntensity});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"date": date, "symptoms": symptoms};
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
    return {
      "date": date,
      "symplist": mapSympNameAndIntensity};
  }

/*   Map<String, dynamic> toJsonSympDetailsData(){
    return {
      "date": date,
      "symplist": 
    }
  } */
}
