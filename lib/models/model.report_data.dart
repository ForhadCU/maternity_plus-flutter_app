import 'package:maa/models/model.note.dart';
import 'package:maa/models/model.ojon.dart';
import 'package:maa/models/model.symp_details.dart';

class ReportDataModel {
  late List<NoteModel> listNoteModel;
  late List<SymptomDetailsModel> listSymptomDtailsModel;
  late List<OjonModel> listOjonModel;
  late double? primaryWeight;
  late String startDate;
  late String endDate;
  late String actualDate;
  late String email;
  late String uid;

  ReportDataModel.namedConstructor1(
      {required this.email,
      required this.uid,
      required this.listNoteModel,
      required this.listSymptomDtailsModel,
      required this.listOjonModel,
      required this.primaryWeight,
      required this.startDate,
      required this.endDate,
      required this.actualDate});

  Map toJson() {
    List<Map>? mapListNoteModels = listNoteModel.isNotEmpty
        ? listNoteModel.map((noteModel) => noteModel.toJson()).toList()
        : null;
    List<Map>? mapListSymptomDtailsModel = listSymptomDtailsModel.isNotEmpty
        ? listSymptomDtailsModel
            .map((e) => e.toJsonSympNameAndIntensityList())
            .toList()
        : null;

    List<Map>? mapListOjonModel = listOjonModel.isNotEmpty
        ? listOjonModel.map((e) => e.toJson()).toList()
        : null;

    return {
      "uid": uid,
      "email": email,
      "startdate": startDate,
      "enddate": endDate,
      "actualdate": actualDate,
      "notes": mapListNoteModels,
      "symptoms": mapListSymptomDtailsModel,
      "primaryweight": primaryWeight,
      "weights": mapListOjonModel
    };
  }
}
