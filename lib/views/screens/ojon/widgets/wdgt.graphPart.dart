// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/models/model.ojon.dart';
import 'package:maa/views/screens/ojon/widgets/dlg_input_primary_ojon.dart';
import 'package:maa/views/screens/ojon/widgets/wdgt.graphChart.dart';
import 'package:maa/views/screens/ojon/widgets/wdgt.landscapeGraph.dart';
import 'package:maa/views/screens/ojon/widgets/wdgt.viewGraphBtn.dart';
import 'package:maa/consts/const.colors.dart';

class GraphWidget extends StatefulWidget {
  final Function callback;
  final List<OjonModel> maxOjonList;
  final List<OjonModel> minOjonList;
  final List<OjonModel> currentOjonList;
  // final List<String> currentWeightList;
  final double primaryWeight;
  bool isSetPrimaryWeight;
  GraphWidget(
      {Key? key,
      // required this.currentWeightList,
      required this.primaryWeight,
      required this.isSetPrimaryWeight,
      required this.callback,
      required this.maxOjonList,
      required this.minOjonList,
      required this.currentOjonList})
      : super(key: key);

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  double titleTextSize = 18;
  bool isShowGraph = false;
  var logger = Logger();


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyScreenSize.mGetHeight(context, 50),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //heading
          Container(
            color: MyColors.pink1,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomText(
              text: 'ওজনের ছক',
              fontsize: titleTextSize,
              fontcolor: MyColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          //Graph
          Expanded(
            child: Container(
              // color: MyColors.col,
              child: !widget.isSetPrimaryWeight
                  ? InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => InputPrimaryOjonDialog(
                                  callBack: (double w, double h) {
                                    /*  setState(() {
                                      widget.isSetPrimaryWeight = true;
                                      widget.callback(w, h);
                                    }); */
                                    widget.isSetPrimaryWeight = true;
                                    widget.callback(w, h);
                                  },
                                ));
                      },
                      child:
                          //alert text
                          Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: 'No chart data available.',
                            fontcolor: MyColors.abc[0],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          CustomText(
                            text: "এখানে তথ্য দেখতে আপনার ওজন প্রদান করুন",
                            fontcolor: MyColors.abc[0],
                            fontWeight: FontWeight.w400,
                          )
                        ],
                      ),
                    )
                  : OjonGraphChart(
                      primaryWeight: widget.primaryWeight,
                      maxOjonList: widget.maxOjonList,
                      minOjonList: widget.minOjonList,
                      currentOjonList: widget.currentOjonList),
            ),
          ),
          //button for Extended view of Graph
          InkWell(
            onTap: () {
              logger.d('Clicked Graph View Button');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GraphLandScape(
                          primaryWeight: widget.primaryWeight,
                          maxOjonList: widget.maxOjonList,
                          minOjonList: widget.minOjonList,
                          currentOjonList: widget.currentOjonList)));
            },
            child: ViewGraphButton.viewGraphButton,
          ),
        ],
      ),
    );
  }
}


/* Fluttertoast.showToast(  
        msg: 'This is toast notification',  
        toastLength: Toast.LENGTH_SHORT,  
        gravity: ToastGravity.BOTTOM,  
        timeInSecForIos: 1,  
        backgroundColor: Colors.red,  
        textColor: Colors.yellow  
    );   */