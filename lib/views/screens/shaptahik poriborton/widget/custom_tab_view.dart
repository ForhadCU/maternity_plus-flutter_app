// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:maa/services/service.my_service.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/consts/const.keywords.dart';

class CustomTavView extends StatefulWidget {
  // final int weekNo;
  final Map<String, dynamic> mapTabData;
  final bool isConnected;
  final int? index;
  final Function? callback;
  const CustomTavView(
      {Key? key,
      required this.mapTabData,
      required this.isConnected,
      this.index,
      this.callback})
      : super(
          key: key,
        );

  @override
  State<CustomTavView> createState() => _CustomTavViewState();
}

class _CustomTavViewState extends State<CustomTavView> {
  late Map<String, dynamic> mapTabData;
  late String changeInChildTitle;
  late String changeInChildDesc;
  late String changeInChildImgurl;
  late String changeInMomTitle;
  late String changeInMomDesc;
  late String symptomsTitle;
  late String symptomsDesc;
  late String instructionTitle;
  late String instructionDesc;
  late bool isShownNextButton;
  late bool isShownPreviousButton;
  late int weekNo;
  bool _isShownButton = true;

  @override
  void initState() {
    super.initState();
    if (widget.index == 0 || widget.index == 3) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (mounted) {
          setState(() {
            _isShownButton = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _mInitData();
    return Stack(
      children: [
        SingleChildScrollView(
          child: InkWell(
            onTap: () {
              setState(() {
                _isShownButton = !_isShownButton;
              });

              Future.delayed(Duration(seconds: 5)).then((value) {
                if (mounted) {
                  setState(() {
                    _isShownButton = false;
                  });
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title
                    CustomText(
                      text: mapTabData['title'],
                      fontWeight: FontWeight.bold,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.black12,
                    ),

                    //paragraph1
                    //title
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: changeInChildTitle,
                      fontWeight: FontWeight.bold,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //desc
                    CustomText(
                      text: changeInChildDesc,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //image
                    Container(
                        padding: EdgeInsets.all(8),
                        child: changeInChildImgurl == '' || !widget.isConnected
                            ? Image(
                                image:
                                    AssetImage('lib/assets/images/summary.png'))
                            : Image(image: NetworkImage(changeInChildImgurl))),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.black12,
                    ),

                    //paragraph 2
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: changeInMomTitle,
                      fontWeight: FontWeight.bold,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //desc
                    CustomText(
                      text: changeInMomDesc,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.black12,
                    ),

                    //paragraph 3
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: symptomsTitle,
                      fontWeight: FontWeight.bold,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //desc
                    CustomText(
                      text: symptomsDesc,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.black12,
                    ),

                    //paragraph 4
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: instructionTitle,
                      fontWeight: FontWeight.bold,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //desc
                    CustomText(
                      text: instructionDesc,
                      // fontsize: 16,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.black12,
                    ),
                  ]),
            ),
          ),
        ),
        Visibility(
          visible: _isShownButton,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.index == 0 && weekNo > 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              widget.callback!(weekNo);
                            },
                            backgroundColor: Color.fromARGB(123, 255, 0, 119),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : widget.index == 3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  widget.callback!(weekNo);
                                },
                                backgroundColor:
                                    Color.fromARGB(123, 255, 0, 119)
                                /* 
                                    Color.fromARGB(123, 255, 0, 119) */
                                ,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _mInitData() {
    mapTabData = widget.mapTabData;
    // c: convert week number into int from string
    weekNo = MyServices.mGetWeekNoFromString(mapTabData[MyKeywords.weekNo]);
    changeInChildTitle =
        MyServices.mGetParagraphTitle(mapTabData[MyKeywords.changesInMom]);
    changeInChildDesc =
        MyServices.mGetParagraphDesc(mapTabData[MyKeywords.changesInMom]); 
    changeInChildImgurl = MyServices.mGenerateImgUrl(
        MyServices.mGetWeekNoFromString(mapTabData[MyKeywords.weekNo]));
    changeInMomTitle =
        MyServices.mGetParagraphTitle(mapTabData[MyKeywords.changesInChild]);
    changeInMomDesc =
        MyServices.mGetParagraphDesc(mapTabData[MyKeywords.changesInChild]);
    symptomsTitle = MyServices.mGetParagraphTitle(mapTabData['symptoms']);
    symptomsDesc = MyServices.mGetParagraphDesc(mapTabData['symptoms']);
    instructionTitle =
        MyServices.mGetParagraphTitle(mapTabData['instructions']);
    instructionDesc = MyServices.mGetParagraphDesc(mapTabData['instructions']);
  }
}
