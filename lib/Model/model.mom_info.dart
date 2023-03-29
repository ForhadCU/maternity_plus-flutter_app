import 'package:splash_screen/consts/const.keywords.dart';

class MomInfo {
  late int momId;
  late String email;
  String? phone;
  String? uid;
  late String sessionStart;
  late String expectedSessionEnd;
  String? sessionEnd;
  int? timestamp;

  MomInfo({
    required this.momId,
    required this.email,
    this.phone,
    required this.sessionStart,
    required this.expectedSessionEnd,
    this.sessionEnd,
    this.timestamp,
  });

  MomInfo.fromJson({required Map<String, dynamic> json}) {
    momId = json[MyKeywords.momId];
    email = json[MyKeywords.email];
    phone = json[MyKeywords.phone];
    sessionStart = json[MyKeywords.sessionStart];
    expectedSessionEnd = json[MyKeywords.expectedSessionEnd];
    sessionEnd = json[MyKeywords.sessionEnd];
    timestamp = json[MyKeywords.timestamp];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    json[MyKeywords.email] = email;
    json[MyKeywords.momId] = momId;
    json[MyKeywords.uid] = uid;
    json[MyKeywords.phone] = phone;
    json[MyKeywords.sessionStart] = sessionStart;
    json[MyKeywords.expectedSessionEnd] = expectedSessionEnd;
    json[MyKeywords.sessionEnd] = sessionEnd;
    json[MyKeywords.timestamp] = DateTime.now().millisecondsSinceEpoch;

    return json;
  }
}
