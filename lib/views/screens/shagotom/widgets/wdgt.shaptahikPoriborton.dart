// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/utils/util.my_scr_size.dart';
import 'package:maa/views/screens/shagotom/widgets/wdgt.lebeltext.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.data.bn.dart';

class ShaptahikPoribortonView extends StatefulWidget {
  final int runningDays;
  final int runningWeeks;
  final int totalRunningDays;
  final Function callback;
  final bool isConnected;
  const ShaptahikPoribortonView(
      {Key? key,
      required this.callback,
      required this.runningDays,
      required this.runningWeeks,
      required this.totalRunningDays, required this.isConnected})
      : super(key: key);

  @override
  State<ShaptahikPoribortonView> createState() =>
      _ShaptahikPoribortonViewState();
}

class _ShaptahikPoribortonViewState extends State<ShaptahikPoribortonView> {

  late String shortDesc;
  String? shortDescAudio;
  String initImgUrl = 'lib/assets/images/summary.png';
  late String postImgUrl;
  // late bool _isConnected;
  AudioCache audioCache = AudioCache();
  late bool isPlaying;
  AudioPlayer audioPlayer = AudioPlayer();
  static const String audioInitialPath = "audio/w";
  static const String audioInitialExtention = ".mp3";

  @override
  void initState() {
    super.initState();
    // mCheckNetworkConnection();

    print(widget.runningDays + widget.runningWeeks + widget.totalRunningDays);

    postImgUrl = '';
    // _isConnected = widget.isConnected;
    isPlaying = false;

    audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      print("PlayerState is: $playerState");
      if (playerState == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else /* if (playerState == PlayerState.completed)  */ {
        setState(() {
          isPlaying = false;
        });
        // isPlaying = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // shortDesc = getShortDesc();

    getShortDescAndAudio();

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(1, 1),
          blurRadius: 1,
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      //title
                      CustomText(
                        text: MaaData.weekly_change,
                        fontcolor: MyColors.pink2,
                        fontWeight: FontWeight.w600,
                        fontsize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      //subTitle
                      CustomText(
                        text:
                            '${widget.runningWeeks.toString()} ${MaaData.week} ${widget.runningDays.toString()} ${MaaData.day}',
                        fontsize: 15,
                        fontWeight: FontWeight.bold,
                        fontcolor: Colors.black54,
                      )
                    ],
                  ),
                ],
              ),
              // v: Audio player
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  // decoration: BoxDecoration(color: MyColors.pink6, borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    padding: EdgeInsets.all(8),
                    splashColor: Colors.blue,
                    onPressed: (() async {
                      if (shortDescAudio != null) {
                        await audioPlayer
                            .setSource(AssetSource(shortDescAudio!));
                        if (!isPlaying) {
                          await audioPlayer.resume();
                        } else {
                          await audioPlayer.stop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "দুঃখিত! তৃতীয় সপ্তাহ হতে এখানে তথ্য শুনতে পাবেন")));
                      }
                    }),
                    // icon: isPlaying ? Icon(Icons.volume_up) : Icon(Icons.mic),
                    icon: isPlaying
                        ? Image(
                            image: AssetImage(
                                "lib/assets/images/anim_playsound.gif"),
                                color: MyColors.pink3,
                            width: 24,
                            height: 24,
                          )
                        : Icon(Icons.volume_up),
                    iconSize: 28,
                    color: Colors.red,
                    splashRadius: 4,
                  ))
            ],
          ),

          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 8,
          ),

          //image
          InkWell(
            onTap: () {
              widget.totalRunningDays >= 15
                  ? widget.callback()
                  : print('Running days should not greater than 14');
            },
            child: Container(
              color: MyColors.pink5,
              height: MyScreenSize.mGetHeight(context, 36),
              child: Stack(children: [
                Positioned(
                  left: 2,
                  right: 2,
                  bottom: 0,
                  top: 0,
                  child: postImgUrl == '' || !widget.isConnected
                      ? Image(
                          image: AssetImage('lib/assets/images/summary.png'))
                      : Image(image: NetworkImage(postImgUrl)),

                  /* Image(
                        // image: AssetImage(initImgUrl)
                        image:NetworkImage(postImgUrl)) */
                ),
                //lebel
                Positioned(
                  bottom: 0,
                  child: LebelText(),
                )
              ]),
            ),
          ),

          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 8,
          ),
          //Weekly Suggestion

          Container(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: shortDesc,
              fontsize: 15,
              fontcolor: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  void getShortDescAndAudio() {
    if (widget.runningWeeks >= 2 &&
        widget.totalRunningDays > 14 &&
        widget.totalRunningDays % 7 != 0 &&
        widget.runningWeeks <= 40) {
      widget.runningWeeks == 40
          ? postImgUrl = ''
          : _mGenerateImgUrl(widget.runningWeeks + 1);

      shortDesc = MaaData.shortDescriptionData.elementAt(widget.runningWeeks);

      // m: it will work when get audio path name from static pathName's arraylist
      /*  shortDescAudio =
          MaaData.audioShortDescList.elementAt(widget.runningWeeks + 1); */

      // c: it's dinamically assigning audio path
      shortDescAudio = mGenerateAudioPath(widget.runningWeeks + 1);
    } else if (widget.runningWeeks <= 41 &&
        widget.runningWeeks > 0 &&
        widget.totalRunningDays % 7 == 0) {
      if (widget.runningWeeks == 3) {
        _mGenerateImgUrl(3);

        shortDescAudio = mGenerateAudioPath(widget.runningWeeks + 1);
      } else if (widget.runningWeeks > 3) {
        _mGenerateImgUrl(widget.runningWeeks);
        shortDescAudio = mGenerateAudioPath(widget.runningWeeks + 1);
      } else {
        postImgUrl = '';
      }
      shortDesc = MaaData.shortDescriptionData.elementAt(widget.runningWeeks);
    } else if (widget.runningWeeks <= 40) {
      shortDesc = MaaData.shortDescriptionData.elementAt(widget.runningWeeks);
    } else {
      shortDesc = MaaData.shortDescriptionData
          .elementAt(MaaData.shortDescriptionData.length - 1);
    }
  }
/* 
  void mCheckNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        _isConnected = false;
      });
    }
  } */

  _mGenerateImgUrl(int i) {
    postImgUrl = 'https://agamilabs.com/maa/images/512/w$i.jpg';
  }

  String mGenerateAudioPath(int i) {
    return audioInitialPath + i.toString() + audioInitialExtention;
  }

/*   void _mTest(int index) async {
    final String url = "https://agamilabs.com/maa/images/512/w$index.jpg";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      setState(() {
        // postImgUrl = json.decode(res.body);
        print('Body: '+ json.decode(res.body));
      });
    } else {
      throw Exception('Failed to load photo');
    }
  } */
}
