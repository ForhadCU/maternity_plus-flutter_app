import 'dart:convert';

class HeightModel {
  String xAxisValue;
  String yAxisValue;

  HeightModel({required this.xAxisValue, required this.yAxisValue});

  factory HeightModel.fromJson(Map<String, dynamic> jsonData) {
    return HeightModel(
      xAxisValue: jsonData['week'],
      yAxisValue: jsonData['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"weekno": xAxisValue, "height": yAxisValue};
  }

  static Map<String, dynamic> toMap(HeightModel height) => {
        'week': height.xAxisValue,
        'height': height.yAxisValue,
      };

  static String encode(List<HeightModel> heights) => json.encode(
        heights
            .map<Map<String, dynamic>>((height) => HeightModel.toMap(height))
            .toList(),
      );

  static List<HeightModel> decode(String heights) =>
      (json.decode(heights) as List<dynamic>)
          .map<HeightModel>((item) => HeightModel.fromJson(item))
          .toList();
}
