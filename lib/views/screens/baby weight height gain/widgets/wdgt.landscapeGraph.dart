import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa/models/model.ojon.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BabyGraphLandScape extends StatefulWidget {
  final double primaryWeight;
  final List<OjonModel> maxOjonList;
  final List<OjonModel> minOjonList;
  final List<OjonModel> currentOjonList;
  const BabyGraphLandScape(
      {Key? key,
      required this.primaryWeight,
      required this.maxOjonList,
      required this.minOjonList,
      required this.currentOjonList})
      : super(key: key);

  @override
  State<BabyGraphLandScape> createState() => _BabyGraphLandScapeState();
}

class _BabyGraphLandScapeState extends State<BabyGraphLandScape> {
  late OjonModel ojon;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    ojon = widget.maxOjonList[40];
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        legend: Legend(
            position: LegendPosition.bottom,
            isVisible: true,
            textStyle: const TextStyle(fontSize: 12)),
        zoomPanBehavior:
            ZoomPanBehavior(enablePinching: true, enablePanning: true),
        primaryYAxis: NumericAxis(
          minimum: widget.primaryWeight,
          maximum: double.parse(ojon.yAxisValue) + 44,
          interval: 4,
        ),
        primaryXAxis: NumericAxis(minimum: 0, maximum: 40, interval: 5),
        series: <ChartSeries>[
          //Render Line Chart
          LineSeries<OjonModel, num>(
              name: 'নুন্যতম ওজন',
              dataSource: widget.minOjonList,
              xValueMapper: (OjonModel ojon, _) => int.parse(ojon.xAxisValue),
              yValueMapper: (OjonModel ojon, _) =>
                  double.parse(ojon.yAxisValue)),
          LineSeries<OjonModel, num>(
              name: 'বর্তমান ওজন',
              dataSource: widget.currentOjonList,
              xValueMapper: (OjonModel ojon, _) => int.parse(ojon.xAxisValue),
              yValueMapper: (OjonModel ojon, _) =>
                  double.parse(ojon.yAxisValue)),
          LineSeries<OjonModel, num>(
              name: "সর্বোচ্চ ওজন",
              dataSource: widget.maxOjonList,
              xValueMapper: (OjonModel ojon, _) => int.parse(ojon.xAxisValue),
              yValueMapper: (OjonModel ojon, _) =>
                  double.parse(ojon.yAxisValue))
        ],
      ),
    );
  }
}
