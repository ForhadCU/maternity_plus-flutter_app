import 'package:splash_screen/consts/const.keywords.dart';

class NoteModel {
  String date;
  String note;
  late String email;
  late int momId;

  NoteModel({required this.date, required this.note});
  NoteModel.nConstructor1(
      {required this.date,
      required this.note,
      required this.email,
      required this.momId});

  Map<String, dynamic> toJson() {
    // used when inserting data to the database

    return <String, dynamic>{
      "date": date,
      "note": note,
      MyKeywords.email: email,
      MyKeywords.momId: momId
    };
  }
}
