import 'dart:convert';

class OjonModel {
  String xAxisValue;
  String yAxisValue;

  OjonModel({required this.xAxisValue, required this.yAxisValue});

  factory OjonModel.fromJson(Map<String, dynamic> jsonData) {
    return OjonModel(
      xAxisValue: jsonData['week'],
      yAxisValue: jsonData['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"weekno": xAxisValue, "weight": yAxisValue};
  }

  static Map<String, dynamic> toMap(OjonModel ojon) => {
        'week': ojon.xAxisValue,
        'weight': ojon.yAxisValue,
      };

  static String encode(List<OjonModel> ojons) => json.encode(
        ojons
            .map<Map<String, dynamic>>((ojon) => OjonModel.toMap(ojon))
            .toList(),
      );

  static List<OjonModel> decode(String ojons) =>
      (json.decode(ojons) as List<dynamic>)
          .map<OjonModel>((item) => OjonModel.fromJson(item))
          .toList();
}
