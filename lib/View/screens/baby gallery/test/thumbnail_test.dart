import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// example app demonstrating thumbnailer plugin
class ThumnailTestScreen extends StatefulWidget {
  const ThumnailTestScreen({super.key});

  @override
  ThumnailTestScreenState createState() => ThumnailTestScreenState();
}

class ThumnailTestScreenState extends State<ThumnailTestScreen> {
  @override
  void initState() {
    print('ThumbnailScreen start...');
    super.initState();
    Thumbnailer.addCustomMimeTypesToIconDataMappings(<String, IconData>{
      'custom/mimeType': FontAwesomeIcons.key,
    });
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Icons'),
    const Tab(text: 'Images'),
    const Tab(text: 'Creation Strategies'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: DefaultTabController(
            length: myTabs.length,
            child: Scaffold(
              appBar: AppBar(title: TabBar(tabs: myTabs)),
              body: TabBarView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType: 'text/html',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'simplest Thumbnail , only set necessary params (mimeType,widgetSize)',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType: 'text/html',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              decoration: WidgetDecoration(
                                backgroundColor: Colors.blueAccent,
                                iconColor: Colors.red,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'Thumbnail with set background color and icon color',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType: 'text/html',
                              dataSize: 125000,
                              name: 'file name',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              decoration: WidgetDecoration(
                                backgroundColor: Colors.blueAccent,
                                iconColor: Colors.red,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'Thumbnail with name and dataSize',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType:
                                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                              dataSize: 125000,
                              name: 'file name',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              decoration: WidgetDecoration(
                                backgroundColor: Colors.blueAccent,
                                iconColor: Colors.red,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Center(
                                child: Text(
                                  'Icons are set thanks to mimeType param and map Thumbnailer._mimeTypeToIconDataMap',
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType:
                                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                              dataSize: 125000,
                              name: 'file name',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              decoration: WidgetDecoration(
                                backgroundColor: Colors.blueAccent,
                                iconColor: Colors.red,
                                textColor: Colors.red,
                                wrapperBgColor: Colors.black,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'Thumbnail with set text color and wrapper color',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType:
                                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                              dataSize: 125000,
                              name: 'file name',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              onlyName: true,
                              decoration: WidgetDecoration(
                                backgroundColor: Colors.blueAccent,
                                iconColor: Colors.red,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Center(
                                child: Text(
                                  'parameter onlyName set to true to allow gracefull degradation',
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              mimeType:
                                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                              dataSize: 125000,
                              name: 'file name',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              decoration: WidgetDecoration(
                                backgroundColor: Colors.blueAccent,
                                iconColor: Colors.red,
                                textColor: Colors.red,
                                wrapperSize: 120,
                                wrapperBgColor: Colors.black,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'Thumbnail with wrapper size set',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //* Image Grid
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.noHeader,
                                    body:
                                        Image.asset('lib/assets/images/e7.jpg'))
                                .show();
                          },
                          child: Column(
                            children: <Widget>[
                              Thumbnail(
                                dataResolver: () async {
                                  return (await DefaultAssetBundle.of(context)
                                          .load('lib/assets/images/e7.jpg'))
                                      .buffer
                                      .asUint8List();
                                },
                                mimeType: 'image/png',
                                widgetSize: MyScreenSize.mGetWidth(context, 25),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: Text(
                                  'png image',
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'image/png',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                              dataSize: 12345,
                              name: 'png',
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                // 'png image with data size and name set',
                                "",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'image/jpg',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'jpg image',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        /*  Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'image/jpg',
                              decoration: WidgetDecoration(
                                wrapperBgColor: Colors.deepOrange,
                                wrapperSize: 110,
                              ),
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'jpg image with wrapper and wrapper color',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ), */
                        /* Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'image/jpg',
                              onlyIcon: true,
                              decoration: WidgetDecoration(
                                wrapperBgColor: Colors.deepOrange,
                                wrapperSize: 110,
                              ),
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'jpg with flag preferIcon set to true',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ), */
                        /*  Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'image/png',
                              onlyIcon: true,
                              dataSize: 12345,
                              name: 'png',
                              widgetSize: MyScreenSize.mGetWidth(context, 25),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'png with flag preferIcon set to true',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ), */
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: GridView.count(
                      crossAxisCount: 1,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'image/png',
                              widgetSize: 300,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                'in basic implementation there are 3 creation strategies, 1st is for images',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType: 'application/pdf',
                              widgetSize: 300,
                              decoration: WidgetDecoration(
                                  wrapperBgColor: Colors.blueAccent),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                '2nd is for pdf files (blue on edges is colored wrapper)',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Thumbnail(
                              dataResolver: () async {
                                return (await DefaultAssetBundle.of(context)
                                        .load('lib/assets/images/e7.jpg'))
                                    .buffer
                                    .asUint8List();
                              },
                              mimeType:
                                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                              widgetSize: 300,
                              decoration: WidgetDecoration(
                                  wrapperBgColor: Colors.blueAccent),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                '3rd is for xlsx and odt files',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
