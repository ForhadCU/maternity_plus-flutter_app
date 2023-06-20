import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/models/model.baby_weights_heights_for_age.dart';
import 'package:maa/models/model.height.dart';
// import 'package:maa/Model/model.ojon.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BabyHeightGraphChart extends StatefulWidget {
   final List<String> babyWeekMonthNumStringList;

  final BabyWeightsHeightsForAge babyWeightsHeightsForAge;
  final List<HeightModel> babyCurrentList;
  final String title;
  // final double primaryWeight;

  const BabyHeightGraphChart(
      {Key? key,
      // required this.primaryWeight,
      required this.babyWeekMonthNumStringList,
      required this.babyWeightsHeightsForAge,
      required this.babyCurrentList,
      required this.title})
      : super(key: key);

  @override
  State<BabyHeightGraphChart> createState() => BabyHeightGraphChartState();
}

class BabyHeightGraphChartState extends State<BabyHeightGraphChart> {

  late BabyWeightsHeightsForAge babyWeightsHeightsForAge;
  late List<HeightModel> babycurrentList;

  late List<HeightModel> minThirdStdDeviation = []; //[-3 SD]
  late List<HeightModel> maxThirdStdDeviation = []; //[+3 SD]
  late List<HeightModel> minSecondStdDeviation = []; //[-2 SD]
  late List<HeightModel> maxSecondStdDeviation = []; //[+2 SD]
  late List<HeightModel> minFirstStdDeviation = []; //[-1 SD]
  late List<HeightModel> maxFirstStdDeviation = []; //[+1 SD]
  late List<HeightModel> median = []; //[+1 SD]
/*   late List<HeightModel> minThirdStdDeviationOfHeightList; //[-3 SD]
  late List<HeightModel> maxThirdStdDeviationOfHeightList; //[+3 SD]
  late List<HeightModel> minSecondStdDeviationOfHeightList; //[-2 SD]
  late List<HeightModel> maxSecondStdDeviationOfHeightList; //[+2 SD]
  late List<HeightModel> minFirstStdDeviationOfHeightList; //[-1 SD]
  late List<HeightModel> maxFirstStdDeviationOfHeightList; //[+1 SD]
  late List<HeightModel> medianOfHeightList; //[+1 SD] */
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
                        minimum: double.parse(minThirdStdDeviation.first.yAxisValue),
                        // minimum: double.parse(babycurrentList[0].yAxisValue),
                        maximum:
                            double.parse(maxThirdStdDeviation.last.yAxisValue) +
                                10,
                        interval: 10,
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

                        LineSeries<HeightModel, String>(
                            color: const Color(0xff800000),
                            name: '-3 SD',
                            dataSource: minThirdStdDeviation,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: const Color(0xffff6500),
                            name: '-2 SD',
                            dataSource: minSecondStdDeviation,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            // int.parse(ojon.xAxisValue),
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: const Color(0xffffcc00),
                            name: '-1 SD',
                            dataSource: minFirstStdDeviation,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: const Color(0xff9acc00),
                            name: 'Median',
                            dataSource: median,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: const Color(0xffffcc00),
                            name: '1 SD',
                            dataSource: maxFirstStdDeviation,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: const Color(0xffff6500),
                            name: '2 SD',
                            dataSource: maxSecondStdDeviation,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: const Color(0xff800000),
                            name: '3 SD',
                            dataSource: maxThirdStdDeviation,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
                                double.parse(ojon.yAxisValue)),
                        LineSeries<HeightModel, String>(
                            color: Colors.blue,
                            name: 'Current Progress',
                            dataSource: widget.babyCurrentList,
                            xValueMapper: (HeightModel ojon, _) =>
                                ojon.xAxisValue,
                            yValueMapper: (HeightModel ojon, _) =>
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
        i < babyWeightsHeightsForAge.minFirstStdDeviationOfHeightList.length;
        i++) {
      minThirdStdDeviation.add(HeightModel(
          // xAxisValue: widget.babyWeekMonthNoStringList[i],
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .minThirdStdDeviationOfHeightList[i]
              .toString()));
      minSecondStdDeviation.add(HeightModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .minSecondStdDeviationOfHeightList[i]
              .toString()));
      minFirstStdDeviation.add(HeightModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .minFirstStdDeviationOfHeightList[i]
              .toString()));
      median.add(HeightModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue:
              babyWeightsHeightsForAge.medianOfHeightList[i].toString()));
      maxThirdStdDeviation.add(HeightModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .maxThirdStdDeviationOfHeightList[i]
              .toString()));
      maxSecondStdDeviation.add(HeightModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .maxSecondStdDeviationOfHeightList[i]
              .toString()));
      maxFirstStdDeviation.add(HeightModel(
          xAxisValue: widget.babyWeekMonthNumStringList[i],
          yAxisValue: babyWeightsHeightsForAge
              .maxFirstStdDeviationOfHeightList[i]
              .toString()));
    }
  }
}
