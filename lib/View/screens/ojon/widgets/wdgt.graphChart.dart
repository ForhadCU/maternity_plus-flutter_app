import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Model/model.ojon.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'wdgt.landscapeGraph.dart';

class OjonGraphChart extends StatefulWidget {
  final List<OjonModel> maxOjonList;
  final List<OjonModel> minOjonList;
  final List<OjonModel> currentOjonList;
  final double primaryWeight;
  const OjonGraphChart(
      {Key? key,
      required this.primaryWeight,
      required this.maxOjonList,
      required this.minOjonList,
      required this.currentOjonList})
      : super(key: key);

  @override
  State<OjonGraphChart> createState() => OjonGraphChartState();
}

class OjonGraphChartState extends State<OjonGraphChart> {
  final List<OjonModel> ojonData = MyServices.mGetOjonDataForGraph();
  final List<OjonModel> ojonData1 = MyServices.mGetOjonDataForGraph1();
  final List<OjonModel> ojonData2 = [];
  late OjonModel ojon;
  var logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ojon = widget.maxOjonList[40];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (() {
          logger.d("Clicked");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => GraphLandScape(
                      primaryWeight: widget.primaryWeight,
                      maxOjonList: widget.maxOjonList,
                      minOjonList: widget.minOjonList,
                      currentOjonList: widget.currentOjonList))));
        }),
        child: Stack(
          children: [
            SfCartesianChart(
              legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  textStyle: const TextStyle(fontSize: 12)),
              primaryYAxis: NumericAxis(
                minimum: widget.primaryWeight,
                maximum: double.parse(ojon.yAxisValue) + 12,
                interval: 4,
                // desiredIntervals: 4,
              ),
              primaryXAxis: NumericAxis(minimum: 0, maximum: 40, interval: 5),
              series: <ChartSeries>[
                //Render Line Chart
                LineSeries<OjonModel, num>(
                    name: 'নুন্যতম ওজন',
                    dataSource: widget.minOjonList,
                    xValueMapper: (OjonModel ojon, _) =>
                        int.parse(ojon.xAxisValue),
                    yValueMapper: (OjonModel ojon, _) =>
                        double.parse(ojon.yAxisValue)),
                LineSeries<OjonModel, num>(
                    name: 'বর্তমান ওজন',
                    color: Colors.green,
                    dataSource: widget.currentOjonList,
                    xValueMapper: (OjonModel ojon, _) =>
                        int.parse(ojon.xAxisValue),
                    yValueMapper: (OjonModel ojon, _) =>
                        double.parse(ojon.yAxisValue)),
                LineSeries<OjonModel, num>(
                    name: 'সর্বোচ্চ ওজন',
                    dataSource: widget.maxOjonList,
                    xValueMapper: (OjonModel ojon, _) =>
                        int.parse(ojon.xAxisValue),
                    yValueMapper: (OjonModel ojon, _) =>
                        double.parse(ojon.yAxisValue)),
              ],
            ),
            Container(color: Colors.transparent)
          ],
        ));
  }
}
