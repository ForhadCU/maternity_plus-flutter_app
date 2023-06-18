import 'package:flutter/material.dart';
import 'package:maa/Controller/utils/util.custom_text.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/Model/model.baby_weights_heights_for_age.dart';
import 'package:maa/Model/model.ojon.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BabyOjonGraphChart extends StatefulWidget {
  final List<String> babyWeekMonthNumStringList;

  final BabyWeightsHeightsForAge babyWeightsHeightsForAge;
  final List<OjonModel> babyCurrentList;
  final String title;
  // final double primaryWeight;

  const BabyOjonGraphChart(
      {Key? key,
      // required this.primaryWeight,
      required this.babyWeekMonthNumStringList,
      required this.babyWeightsHeightsForAge,
      required this.babyCurrentList,
      required this.title})
      : super(key: key);

  @override
  State<BabyOjonGraphChart> createState() => BabyOjonGraphChartState();
}

class BabyOjonGraphChartState extends State<BabyOjonGraphChart> {
/*   final List<OjonModel> ojonData = MyServices.mGetOjonDataForGraph();
  final List<OjonModel> ojonData1 = MyServices.mGetOjonDataForGraph1();
  final List<OjonModel> ojonData2 = []; */
  late OjonModel ojon;
  late BabyWeightsHeightsForAge babyWeightsHeightsForAge;
  late List<OjonModel> babycurrentList;

  late List<OjonModel> minThirdStdDeviation = []; //[-3 SD]
  late List<OjonModel> maxThirdStdDeviation = []; //[+3 SD]
  late List<OjonModel> minSecondStdDeviation = []; //[-2 SD]
  late List<OjonModel> maxSecondStdDeviation = []; //[+2 SD]
  late List<OjonModel> minFirstStdDeviation = []; //[-1 SD]
  late List<OjonModel> maxFirstStdDeviation = []; //[+1 SD]
  late List<OjonModel> median = []; //[+1 SD]
/*   late List<OjonModel> minThirdStdDeviationOfHeightList; //[-3 SD]
  late List<OjonModel> maxThirdStdDeviationOfHeightList; //[+3 SD]
  late List<OjonModel> minSecondStdDeviationOfHeightList; //[-2 SD]
  late List<OjonModel> maxSecondStdDeviationOfHeightList; //[+2 SD]
  late List<OjonModel> minFirstStdDeviationOfHeightList; //[-1 SD]
  late List<OjonModel> maxFirstStdDeviationOfHeightList; //[+1 SD]
  late List<OjonModel> medianOfHeightList; //[+1 SD] */
  @override
  void initState() {
    super.initState();
    // ojon = widget.maxOjonList[40];
    mPrepareGraphData();
    // print(widget.babyWeekMonthNoModelList)
  }

  @override
  Widget build(BuildContext context) {
    /*  */
    /* for (var element in widget.babyCurrentList) {
      print("x: ${element.xAxisValue}, y: ${element.yAxisValue}");
    }
    print("build: OJON Graph and ${widget.babyCurrentList.length}");
 */
    return InkWell(
        onTap: (() {
          /* 
          //Landscape mode of GraphView
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => BabyGraphLandScape(
                      primaryWeight: widget.primaryWeight,
                      maxOjonList: widget.maxOjonList,
                      minOjonList: widget.minOjonList,
                      currentOjonList: widget.currentOjonList))));
         */
        }),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
          height: MyScreenSize.mGetHeight(context, 40),
          child: Column(
            children: [
              Container(
                color: MyColors.pink1,
                padding: const EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                child: CustomText(
                  // text: 'সাপ্তাহিক ওজন',
                  // text: 'শিশুর ওজন গ্রাফ',
                  text: widget.title,
                  fontsize: 18,
                  fontcolor: MyColors.textOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SfCartesianChart(
                      legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: const TextStyle(fontSize: 12)),
                      primaryYAxis: NumericAxis(
                        // minimum: widget.primaryWeight,
                        minimum:    double.parse(minThirdStdDeviation.first.yAxisValue),
                        // minimum: double.parse(babycurrentList[0].yAxisValue),
                        maximum:
                            double.parse(maxThirdStdDeviation.last.yAxisValue) +
                                2,
                        interval: 2,
                        // desiredIntervals: 4,
                      ),

                      primaryXAxis: CategoryAxis(
                          multiLevelLabelStyle: const MultiLevelLabelStyle(
                            borderColor: Colors.black54,
                            borderWidth: .5,
                            borderType: MultiLevelBorderType.squareBrace,
                          ),
                          multiLevelLabels: const <CategoricalMultiLevelLabel>[
                            CategoricalMultiLevelLabel(
                                start: "0w", end: "13w", text: 'weeks'),
                            CategoricalMultiLevelLabel(
                                start: "5m", end: "60m", text: 'months'),
                          ],

                          /*  minimum: 0,
                          maximum: 70, */
                          interval: 5),
                      // primaryXAxis: NumericAxis(minimum: 0, maximum: 40, interval: 5),
                      series: <ChartSeries>[
                        //Render Line Chart

                        LineSeries<OjonModel, String>(
                            color: const Color(0xff800000),
                            name: '-3 SD',
                            dataSource: minThirdStdDeviation,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: const Color(0xffff6500),
                            name: '-2 SD',
                            dataSource: minSecondStdDeviation,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            // int.parse(ojon.xAxisValue),
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: const Color(0xffffcc00),
                            name: '-1 SD',
                            dataSource: minFirstStdDeviation,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: const Color(0xff9acc00),
                            name: 'Median',
                            dataSource: median,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: const Color(0xffffcc00),
                            name: '1 SD',
                            dataSource: maxFirstStdDeviation,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: const Color(0xffff6500),
                            name: '2 SD',
                            dataSource: maxSecondStdDeviation,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: const Color(0xff800000),
                            name: '3 SD',
                            dataSource: maxThirdStdDeviation,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<OjonModel, String>(
                            color: Colors.blue,
                            name: 'Current Progress',
                            dataSource: widget.babyCurrentList,
                            xValueMapper: (OjonModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (OjonModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                      ],
                    ),
                    Container(color: Colors.transparent)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void mPrepareGraphData() {
    babyWeightsHeightsForAge = widget.babyWeightsHeightsForAge;
    // babycurrentList = widget.babyCurrentList;
    /*  print(widget.babyWeekMonthNoStringList.length);
    print(babyWeightsHeightsForAge.minFirstStdDeviationOfWeightList.length); */
    for (var i = 0;
        i < babyWeightsHeightsForAge.minFirstStdDeviationOfWeightList.length;
        i++) {
      minThirdStdDeviation.add(OjonModel(
          // xAxisValue: widget.babyWeekMonthNoStringList[i],
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .minThirdStdDeviationOfWeightList[i]
              .toString()));
      minSecondStdDeviation.add(OjonModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .minSecondStdDeviationOfWeightList[i]
              .toString()));
      minFirstStdDeviation.add(OjonModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .minFirstStdDeviationOfWeightList[i]
              .toString()));
      median.add(OjonModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue:
              babyWeightsHeightsForAge.medianOfWeightList[i].toString()));
      maxThirdStdDeviation.add(OjonModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .maxThirdStdDeviationOfWeightList[i]
              .toString()));
      maxSecondStdDeviation.add(OjonModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .maxSecondStdDeviationOfWeightList[i]
              .toString()));
      maxFirstStdDeviation.add(OjonModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .maxFirstStdDeviationOfWeightList[i]
              .toString()));
    }
  }
}
