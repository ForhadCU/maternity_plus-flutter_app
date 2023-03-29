import 'package:splash_screen/consts/const.keywords.dart';

class MomWeight {
  late String email;
  late int momId;
  late int weekNo;
  late double weight;
  late int timestamp;

  MomWeight.weight(
      {required this.email,
      required this.momId,
      required this.weekNo,
      required this.weight,
      required this.timestamp});

  Map<String, dynamic> toJosn() {
    late Map<String, dynamic> json = {};
    json[MyKeywords.email] = email;
    json[MyKeywords.momId] = momId;
    json[MyKeywords.weekNo] = weekNo;
    json[MyKeywords.weight] = weight;
    json[MyKeywords.timestamp] = timestamp;
    return json;
  }

  MomWeight.fromJson({required Map<String, dynamic> json}) {
    email = json[MyKeywords.email];
    momId = json[MyKeywords.momId];
    weekNo = json[MyKeywords.weekNo];
    weight = json[MyKeywords.weight];
  }
}
