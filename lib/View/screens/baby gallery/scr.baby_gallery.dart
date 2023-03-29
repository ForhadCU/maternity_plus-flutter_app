import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.date_format.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/Model/model.babygallery.dart';
import 'package:splash_screen/Model/model.image_details.dart';
import 'package:splash_screen/Model/model.mom_info.dart';
import 'package:splash_screen/View/screens/baby%20gallery/widget/dlg_input.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:logger/logger.dart';

class BabyGalleryScreen extends StatefulWidget {
  final MomInfo momInfo;
  final int? babyId;
  const BabyGalleryScreen(
      {Key? key, required this.momInfo, required this.babyId})
      : super(key: key);

  @override
  State<BabyGalleryScreen> createState() => _BabyGalleryScreenState();
}

class _BabyGalleryScreenState extends State<BabyGalleryScreen> {
  File? imageFile;
  String? _imageString;
  // List<ImageDetailsModel> _listImageDiaryModel = [];
  List<BabyGalleryModel> _listBabyGalleryModelList = [];
  var lat;
  var long;
  var addr;
  late FirebaseAuth _mAuth;
  User? _user;
  late bool isSignedIn = false;
  Position? _positionCurrent;
  bool _isLoading = true;
  late String email;

  @override
  void initState() {
    super.initState();
    // determinePosition();

    _mAuth = FirebaseAuth.instance;
    _user = _mAuth.currentUser;
    //m: load user email from sharedpreferences
    mLoadAll();
    // mLoad().then((value) => mLoadDatafromLocal());

// c: Temp
    /* 
  void mFetchDataAndCheckCurrentUser(){
    SqfliteServices.mFetchBabyDiaryDataFromSqflite().then((value) {
      value.isNotEmpty
          ? setState(() {
              _listBabyGalleryModelList = value;
              _isLoading = false;
             
            })
          : null;

      _mAuth.authStateChanges().listen((User? u) {
        if (u != null) {
          Logger().d("User currently signed In");
          /*    //get user email from sharedPreferences and assign to variable */
          isSignedIn =
              true; // for giving a decision to the dialog if it make singin action or not
          _userEmail = u.email!;

          //Fetch data
          FirestoreProvider.mFetchAllDiaryDatafromFirestore(email: _userEmail!)
              .then((value) {
            setState(() {
              _isLoading = false;
              _listBabyGalleryModelList = List.from(_listBabyGalleryModelList)
                ..addAll(value);
            });
          });
        } else {
          Logger().d("User is not signed in currently ");
          setState(() {
            isSignedIn = false;
            _isLoading = false;
          });
        }
      });
    }).onError((error, stackTrace) {
      Logger().d(
          'Something went wrong during babyGallery Data retrieving from Sqflite, Error: $error');
    }); 
   }

 */
  }

  @override
  Widget build(BuildContext context) {
    //c: responsive grid image number
    /* final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width > 1000)
        ? 5
        : (width > 700)
            ? 4
            : (width > 300)
                ? 3
                : 2; */

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.pink2,
        onPressed: () => {
          widget.babyId == null
              ? vShowAlerDialog()
              :

              // v: input Dialog
              _mShowDialog(context: context)
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 255, 255, 255),
            // color: Color.fromARGB(255, 255, 255, 150),
          ),
        ),
      ),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.pink2,
          title: const CustomText(
            text: 'বেবি গ্যালারি',
            fontWeight: FontWeight.w400,
            fontsize: 22,
            fontcolor: MyColors.textOnPrimary,
          )),
      body: /* widget.babyId == null
          ? Stack(
              children: [Expanded(child: Container())],
            )
          :  */
          Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: _isLoading
                ? vCircProgress()
                : Container(
                    padding: const EdgeInsets.all(8),
                    child: _listBabyGalleryModelList.isNotEmpty
                        ?
                        //c: [Deprecated] List view for single image
                        // mListView()
                        //v: image listView
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _listBabyGalleryModelList.length,
                            itemBuilder: ((context, index) {
                              return
                                  //v: image gridView
                                  Container(
                                // color: Colors.blue,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: MyColors.pink6,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 2),
                                      child: CustomText(
                                          text: CustomDateForamt.mFormateDate2(
                                              DateTime.parse(
                                                  _listBabyGalleryModelList[
                                                          index]
                                                      .dateTime))),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    GridView.count(
                                        // padding: const EdgeInsets.only(top: 33),
                                        crossAxisCount: 3,
                                        shrinkWrap: true,
                                        childAspectRatio: 0.85,
                                        /* crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                      semanticChildCount: 250,
                                      childAspectRatio: 200 / 244, */
                                        physics: const BouncingScrollPhysics(),
                                        children:
                                            _listBabyGalleryModelList[index]
                                                .imgDetailsModelList
                                                .map((imgDetailsModelList) {
                                          return InkWell(
                                            onTap: () {
                                              AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.noHeader,
                                                  bodyHeaderDistance: 0,
                                                  padding: EdgeInsets.zero,
                                                  body: Image.file(
                                                    File(imgDetailsModelList
                                                        .imgUrl),
                                                    fit: BoxFit.cover,
                                                  )).show();
                                            },
                                            // v: Thumbnail img
                                            child: Column(
                                              // mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Thumbnail(
                                                  decoration: WidgetDecoration(
                                                      backgroundColor:
                                                          Colors.black12),
                                                  mimeType: 'image/png',
                                                  widgetSize: /* 80 */
                                                      MyScreenSize.mGetWidth(
                                                          context, 30),
                                                  dataResolver: () async {
                                                    return await File(
                                                            imgDetailsModelList
                                                                .imgUrl)
                                                        .readAsBytes();
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Text(
                                                    "${DateTime.parse(imgDetailsModelList.date).day}D ${DateTime.parse(imgDetailsModelList.date).month}M  ${DateTime.parse(imgDetailsModelList.date).year}Y",
                                                    // overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          /* Image.file(
                                            File(babayGalleryModel.imgUrl),
                                            width: 24,
                                            height: 24,
                                          ); */
                                        }).toList() /*  widget.pokemon
                                          .map(
                                            (pokemon) => PokemonCard(
                                              id: pokemon.id,
                                              name: pokemon.name,
                                              image: pokemon.img,
                                            ),
                                          )
                                          .toList(), */

                                        ),
                                  ],
                                ),
                              );
                            }))
                        : Center(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomText(
                                text: 'ছবি আপলোড করতে ',
                                fontcolor: Colors.black45,
                              ),
                              InkWell(
                                onTap: () => {
                                  widget.babyId == null
                                      ? vShowAlerDialog()
                                      :

                                      // v: input Dialog
                                      _mShowDialog(context: context)
                                },
                                child: const CustomText(
                                  text: 'এখানে ক্লিক',
                                  fontcolor: MyColors.pink2,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                              const CustomText(
                                text: ' করুন।',
                                fontcolor: Colors.black45,
                              ),
                            ],
                          )),
                  ),
          )
        ],
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<StreamSubscription> _determinePosition() async {

/*   Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placeMark[0];
    addr = "${place.subAdministrativeArea}";
    Logger().d('Address: $addr');
  } */

  void _mShowDialog({required BuildContext context}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          // MyServices.determinePosition();

          return InputDialog(
              babyid: widget.babyId,
              momInfo: widget.momInfo,
              isSignedIn: isSignedIn,
              callback: /* (String userEmail) {
              setState(() {
                FirestoreProvider.mFetchAllDiaryDatafromFirestore(
                        email: userEmail)
                    .then((value) {
                  setState(() {
                    _listBabyGalleryModelList = value;
                    _isLoading = false;
                  });
                });
              });
            }, */
                  /* (ImageDetailsModel imageDetailsModel) {
                setState(() {
                  _listBabyGalleryModelList.add(imageDetailsModel);
                  _isLoading = false;
                });
              }); */

                  //c: without saving data to db
                  /* (BabyGalleryModel babyGalleryModel) {
                setState(() {
                  _isLoading = false;
                  _listBabyGalleryModelList.add(babyGalleryModel);
                });
                // Logger().d(babyGalleryModel.imgDetailsModelList.length);
                /*  _listBabyGalleryModelList.add(babyGalleryModel);
                  Logger().d(
                      'size: ${_listBabyGalleryModelList[1].imgDetailsModelList.length}'); */

                /*  setState(() {
                
                }); */
              } */

                  //c: call from input dialog after saving data
                  () {
                //m: load image data from local db
                mLoadDatafromLocal();
              });
        });
  }

  void mLoadDatafromLocal() {
    if (widget.babyId != null) {
      //m: send babyid as parm and get all gallery data
      MySqfliteServices.mFetchBabyDiaryDataFromSqflite(
              babyId: widget.babyId!,
              email: widget.momInfo.email,
              momId: widget.momInfo.momId)
          .then((value) {
        // String previousDate = CustomDateForamt.mFormateDateDB(DateTime.now());

        String previousDate = '';
        List<ImageDetailsModel> _listImageDetailsModel = [];
        _listBabyGalleryModelList.clear();
        for (int i = 0; i < value.length; i++) {
          Logger().d("date: ${value[i].date} image: ${value[i].imgUrl}");
          if (value[i].date == previousDate) {
            _listImageDetailsModel.add(ImageDetailsModel.imageFromCamera(
                imgUrl: value[i].imgUrl,
                date: value[i].date,
                latitude: value[i].latitude,
                longitude: value[i].longitude,
                caption: value[i].caption,
                timestamp: value[i].timestamp));
            if (i == value.length - 1) {
              //e: cleared previous _listImageDetailsModel
              /*  _listBabyGalleryModelList.add(BabyGalleryModel.nConstructor2(
              imgDetailsModelList: _listImageDetailsModel,
              dateTime: previousDate,
            )); 
            _listImageDetailsModel.clear();
            */
              //c: copy the previous _listImageDetailsModel into new list
              //c: then put it to the _listBabyGalleryModelList
              List<ImageDetailsModel> temp = List.from(_listImageDetailsModel);
              _listBabyGalleryModelList.add(BabyGalleryModel.nConstructor2(
                imgDetailsModelList: temp,
                dateTime: previousDate,
              ));
              //c: now we can clear the previous list
              _listImageDetailsModel.clear();
            }
          } else {
            if (_listImageDetailsModel.isNotEmpty) {
              //c: [same] as abovementioned process
              List<ImageDetailsModel> temp = List.from(_listImageDetailsModel);
              _listBabyGalleryModelList.add(BabyGalleryModel.nConstructor2(
                imgDetailsModelList: temp,
                dateTime: previousDate,
              ));
              _listImageDetailsModel.clear();
            }
            previousDate = value[i].date;
            i--;
          }
        }
        setState(() {
          _isLoading = false;
        });
        // Logger().d("babyGDataList : ${_listBabyGalleryModelList.length}");
      }); /* .onError((error, stackTrace) => throw Exception(error)); */
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> mLoad() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('email')!;
  }

  void _mUpdateUI() {
    // c: Valid for single image selection
    /* 
    if (_userEmail != null) {
      //call fetchDiaryData();
      FirestoreProvider.mFetchAllDiaryDatafromFirestore(email: _userEmail!)
          .then((value) {
        // Logger().d('Model Size: ${value.length}');
        /* for (var item in value) {
              Logger().d('ImgUrl: ${item.strgImgUri}');
            } */
        setState(() {
          _isLoading = !_isLoading;

          _listBabyGalleryModelList = value;
        });
      });
    } else {
      Logger().d("User is not signed in currently ");
      setState(() {
        isSignedIn = false;
        _isLoading = !_isLoading;
      });
      //for giving a decision to the dialog if it make singin action or not
      /*      //check SharedPreference either email is stored or not
              //if stored then get email and call  */

      // user = ;
    }
   */
  }

  // m: Widgets
  Widget vCircProgress() {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
      ),
    );
  }

  void mLoadAll() async {
    await mLoad();
    mLoadDatafromLocal();
  }

  vShowAlerDialog() {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: "Sorry! You didn't add any baby yet.")
        .show();
  }
}
