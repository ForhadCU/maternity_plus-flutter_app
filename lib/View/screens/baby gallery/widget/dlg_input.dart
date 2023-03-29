// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/authentication.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/Controller/utils/util.date_format.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/Model/model.babygallery.dart';
import 'package:splash_screen/Model/model.image_details.dart';
import 'package:splash_screen/Model/model.mom_info.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.keywords.dart';

class InputDialog extends StatefulWidget {
  final Function callback;
  final bool isSignedIn;
  final MomInfo momInfo;
  final int? babyid;

  const InputDialog(
      {Key? key,
      required this.callback,
      required this.isSignedIn,
      required this.momInfo,
      required this.babyid})
      : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  String _imageString = '';
  List<ImageDetailsModel> _imgDetailModelList = [];
  late BabyGalleryModel _babyGalleryModel;
  late File _imgFile;
  late Map<String, dynamic> map = {};
  TextEditingController _textEditingControllerCaption =
      TextEditingController(text: '');
  bool _isVisible = false;
  late bool _isSignedIn;
  String? _userEmail;
  bool _isUploadBtnLoading = false;
  bool _isGoogleBtnLoading = false;
  // bool _isShowNewBabyContents = false;

  @override
  void initState() {
    super.initState();
    MyServices.determinePosition().then((value) {
      map = value;
    });
    _isSignedIn = widget.isSignedIn;
    _userEmail = widget.momInfo.email;
    // print('IsSignedIn: ${widget.isSignedIn}');
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerCaption.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* _imgDetailModelList.isNotEmpty
        ? print(
            'imageDetailsModelList 0th item: ${_imgDetailModelList[0].imgUri}')
        : null; */
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        insetPadding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MyScreenSize.mGetHeight(context, 8),
                color: MyColors.pink1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'ছবি অথবা নোট যোগ করুন',
                      fontWeight: FontWeight.w400,
                      fontcolor: Colors.white,
                      fontsize: 20,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    //v: Caption
                    TextField(
                      controller: _textEditingControllerCaption,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: InputDecoration(
                          label: CustomText(
                            text: 'Caption',
                          ),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // v: Image preview
                    Container(
                      height: _imgDetailModelList.isNotEmpty
                          ? MyScreenSize.mGetHeight(context, 20)
                          : 0,
                      alignment: Alignment.center,
                      child: _imgDetailModelList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _imgDetailModelList.length,
                              // itemCount: _imgStrList.isEmpty ? 0 : _imgStrList.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: /* Utility.imageFromBase64String(
                                      _imgDetailModelList[index].imgUrl) ,*/
                                            Image.file(
                                          File(_imgDetailModelList[index]
                                              .getImgUrl),
                                          width: 120,
                                          height: 140,
                                          fit: BoxFit.cover,
                                        ))
                                    // CustomText(text: 'Text $index')
                                    ;
                              }))
                          : null,
                      /*  _imgDetailModelList.isNotEmpty
                              ? Utility.imageFromBase64String(
                                  _imgDetailModelList[0].imgUri!)

                              : null, */
                    ),
                    /*  Container(
                      child: _imageString != ''
                          ? Utility.imageFromBase64String(_imageString)
                          : null,
                    ), */
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // v: local button
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _imgDetailModelList.clear();
                                //* for single image pick
                                /*  MyServices.mPickImgFromLocal()
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {x
                                            // print("value: ${value}");
                                            // _imageString = value!;
                                            // _imgFile = File(value['imgPath']!);
                                            _imgDetailModelList.add(
                                                ImageDetailsModel(
                                                    imgXFile: value['imgXFile'],
                                                    imgFromCamera: false,
                                                    imgUri: value['imgString'],
                                                    imgFile:
                                                        File(value['imgPath']!),
                                                    timestamp: DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString(),
                                                    /* caption:
                                              _textEditingControllerCaption.text, */

                                                    date: CustomDateForamt
                                                        .mFormateDate2(
                                                            DateTime.now())));
                                          });
                                        }
                                      }); */
                                // m: pick image from local storage
                                MyServices.mPickMultipleImageFromLocal()
                                    .then((value) {
                                  if (value != null) {
                                    /*  Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return Test(
                                          multipleImagesString:
                                              value[MyKeywords.multiImgUrls]);
                                    })); */

                                    // c: assign image Details Model list
                                    _imgDetailModelList = value;
                                    // c: Referesh screen for show image preview in the horizontal List view
                                    setState(() {});
                                  }
                                });
                              },
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabled: false,
                                    isDense: true,

                                    // contentPadding: EdgeInsets.all(2),
                                    prefixIcon: Icon(
                                      Icons.file_upload,
                                      size: 24,
                                      color: MyColors.pink3,
                                    ),
                                    label: CustomText(
                                      text: 'Local',
                                      fontWeight: FontWeight.w400,
                                      fontcolor: Colors.black45,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          // v: Camera button
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _imgDetailModelList.clear();

                                MyServices.mPickImgCamera().then((value) {
                                  if (value != null) {
                                    // _imageString = value!;
                                    // _imgDetailModelList.add(value!);

                                    _imgDetailModelList.add(
                                        ImageDetailsModel.imageFromCamera(
                                            imgUrl:
                                                value[MyKeywords.singleImgUrls],
                                            latitude: map['lat'],
                                            longitude: map['long'],
                                            timestamp: DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                            /* caption:
                                              _textEditingControllerCaption.text, */
                                            date:
                                                CustomDateForamt.mFormateDateDB(
                                                    DateTime.now())));
                                    // c: Referesh screen for show image preview in the horizontal List view
                                    setState(() {});
                                  }
                                });
                              },
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabled: false,
                                    isDense: true,

                                    // contentPadding: EdgeInsets.all(2),
                                    prefixIcon: Icon(
                                      Icons.camera,
                                      size: 24,
                                      color: MyColors.pink3,
                                    ),
                                    label: CustomText(
                                      text: 'Camera',
                                      fontWeight: FontWeight.w400,
                                      fontcolor: Colors.black45,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // v: discard button
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: MyColors.pink3),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                text: 'Discard',
                                fontcolor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          // v: save button
                          Expanded(
                            child: _isUploadBtnLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      )
                                    ],
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColors.pink3),
                                    onPressed: () {
                                      _imgDetailModelList.isNotEmpty
                                          ?
                                          // c: [Deprecated] Show save option to the flexible bottom sheet
                                          // mShowSaveOption()
                                          {
                                              // c: put all gallery data to Baby Gallery Data model object
                                              /*  _babyGalleryModel =
                                                  BabyGalleryModel.nConstructor2(
                                                      imgDetailsModelList:
                                                          _imgDetailModelList,
                                                      dateTime: DateTime.now(),
                                                      caption:
                                                          _textEditingControllerCaption
                                                              .value.text), */
                                              //m: save image data into the local storage
                                              mSaveDataToLocal(),
                                              //m: refresh main screen
                                              // mCallBack(),
                                              //c: dismiss dialog
                                              // Navigator.pop(context)
                                            }
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: CustomText(
                                              text: 'Pick a photo',
                                            )));

                                      // c: [Deprecated] Save to Cloud
                                      // mSaveToCloud();
                                    },
                                    child: CustomText(
                                      text: 'Save',
                                      fontcolor: Colors.white,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),

                    // e: for later
                    //Sign in with google
                    Visibility(
                        visible: _isVisible,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              height: 1,
                              thickness: 0.8,
                              color: Colors.black12,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Please Sign in with Google',
                                    fontcolor: Colors.black45,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isGoogleBtnLoading
                                      ? Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : RawMaterialButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isGoogleBtnLoading =
                                                  !_isGoogleBtnLoading;
                                            });
                                            Authentication.signInWithGoogle(
                                                    context: context)
                                                .then((value) {
                                              setState(() {
                                                _userEmail = value!.email!;
                                                _isVisible = !_isVisible;
                                                _isSignedIn = true;
                                                _isGoogleBtnLoading =
                                                    !_isGoogleBtnLoading;
                                              });
                                            });
                                            /*  if (user?.email != null &&
                                            _imgFile != null) {
                                          FirebaseStorageProvider
                                              .mAddImageToFirebaseStorage(
                                                  imgFile: _imgFile,
                                                  imgName: 'imgName1');
                                          /*  FirestoreProvider
                                              .mAddBabyGalleryDataToFirestore(
                                                  email: user!.email.toString(),
                                                  imgUri: _imgDetailModelList
                                                      .first.imgUri!,
                                                  caption:
                                                      _textEditingControllerCaption
                                                          .text); */
                                        } */
                                          },
                                          elevation: 2.0,
                                          constraints: BoxConstraints(
                                              maxWidth: 40,
                                              minWidth: 40,
                                              maxHeight: 40,
                                              minHeight: 40),
                                          shape: CircleBorder(),
                                          fillColor: Colors.white,
                                          // constraints: BoxConstraints(maxw),
                                          child: Image(
                                            image: AssetImage(
                                              "lib/assets/images/ic_google.png",
                                            ),
                                          )),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //v: Methods

  void mShowSaveOption() {
    showFlexibleBottomSheet(
        bottomSheetColor: Colors.white,
        minHeight: 0,
        initHeight: 0.25,
        maxHeight: 1,
        anchors: [0, 0.5, 1],
        isSafeArea: true,
        context: context,
        builder: (BuildContext _context, ScrollController scrollController,
                double bottomSheetOffset) =>
            Container(
              margin: EdgeInsets.only(top: 25, left: 8, bottom: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: 'Save to',
                        fontsize: 12,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    splashColor: MyColors.pink5,
                    onTap: () {
                      /* Navigator.pop(_context);
                  _imgDetailModelList.isNotEmpty
                      ? MyServices.mCopyImgFileToNewPath(
                          imgFile: _imgDetailModelList.first.imgFile!,
                        ).then((value) {
                          _imgDetailModelList.first.imgUri = value;
                          /*  for (var element
                            in _imgDetailModelList) {
                          print(
                              'uri:${element.imgUri}');
                          print(
                              'cap:${_textEditingControllerCaption.text}');
                          print(
                              'lat:${element.latitude}');
                          print(
                              'long:${element.longitude}');
                          print(
                              'time:${element.timestamp}');
                          print(
                              'date:${element.date}');
                        }

                                                          */
                    print(_imgDetailModelList.first.date);
                    value.isNotEmpty
                        ? {
                            _imgDetailModelList.first.caption =
                                _textEditingControllerCaption.text,
                            SqfliteServices
                                .mAddBabyGalleryDataToLocal(
                                    ImageDetailsModel(
                              caption:
                                  _textEditingControllerCaption.text,
                              imgUri:
                                  _imgDetailModelList.first.imgUri,
                              //  imgUri : null,
                              latitude: _imgDetailModelList
                                      .first.latitude ??
                                  0.00,
                              longitude: _imgDetailModelList
                                      .first.longitude ??
                                  0.00,
                              timestamp:
                                  _imgDetailModelList.first.timestamp,
                              date: _imgDetailModelList.first.date,
                            )).then((value) {
                              print(
                                  'Number of BabyGalleryData model added to sqflite: $value');

                              //refresh UI list by callback func
                              widget.callback(ImageDetailsModel(
                                  caption:
                                      _textEditingControllerCaption
                                          .text,
                                  imgUri: _imgDetailModelList
                                      .first.imgUri,
                                  // imgUrl: "$_userEmail/${Path.basename(_imgDetailModelList.first.imgFile!.path)}",
                                  latitude: _imgDetailModelList
                                      .first.latitude,
                                  longitude: _imgDetailModelList
                                      .first.longitude,
                                  timestamp: _imgDetailModelList
                                      .first.timestamp,
                                  date:
                                      _imgDetailModelList.first.date,
                                  imgFromCamera: _imgDetailModelList
                                      .first.imgFromCamera!));
                              Navigator.pop(context);
                            }).catchError((onError) {
                              Navigator.pop(context);
                              print(
                                  'Error in Adding babyGallery data to Sqflite: $onError');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: CustomText(
                                text: 'Something went wrong!',
                              )));
                            })
                          }
                        : () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content: CustomText(
                              text: 'Something went wrong!',
                            )));
                            print('File not save in the local path');
                          };
                  })
                      : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: CustomText(
                          text: 'Pick a photo',
                        )));
                  */
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: 6,
                              horizontal: 14),
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: MyColors.pink4,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: CustomText(text: 'Local album'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    splashColor: MyColors.pink5,
                    onTap: () {
                      Navigator.pop(_context);

// _mShowBabyInputDialog();

/* 
Navigator.pop(
_context);
//save to cloud
if (_isSignedIn) {
_imgDetailModelList
.isNotEmpty
? {
setState(
() {
_isUploadBtnLoading =
!_isUploadBtnLoading;
}),
FirebaseStorageProvider
.mAddImageToFirebaseStorage(
email:
_userEmail!,
imgFile: _imgDetailModelList
.first
.imgFile!, /* imgName: _imgDetailModelList.first.imgUri!.substring(6, 15) */
).then(
(value) {
if (value !=
null) {
FirestoreProvider.mAddBabyGalleryDataToFirestore(
email: _userEmail!,
caption: _textEditingControllerCaption.text,
imgUrl: "$_userEmail/${Path.basename(_imgDetailModelList.first.imgFile!.path)}",
latitude: _imgDetailModelList.first.latitude,
longitude: _imgDetailModelList.first.longitude,
timestamp: _imgDetailModelList.first.timestamp,
date: _imgDetailModelList.first.date,
imgFromCamera: _imgDetailModelList.first.imgFromCamera!);

//refresh UI list by callback func
widget.callback(ImageDetailsModel(
caption: _textEditingControllerCaption.text,
imgUri: _imgDetailModelList.first.imgUri,
// imgUrl: "$_userEmail/${Path.basename(_imgDetailModelList.first.imgFile!.path)}",
latitude: _imgDetailModelList.first.latitude,
longitude: _imgDetailModelList.first.longitude,
timestamp: _imgDetailModelList.first.timestamp,
date: _imgDetailModelList.first.date,
imgFromCamera: _imgDetailModelList.first.imgFromCamera!));
Navigator.pop(
context);

/*    _imgDetailModelList[0]
.caption =
_textEditingControllerCaption
.value.text; */
}
})
}
: null;
} else {
setState(() {
_isVisible =
!_isVisible;
/*   _isGoogleBtnLoading =
!_isGoogleBtnLoading; */
});
}
*/
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: 6,
                              horizontal: 14),
                          child: Icon(
                            Icons.cloud_circle_rounded,
                            color: MyColors.pink4,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: CustomText(text: 'Cloud album'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  void mSaveToCloud() {
    /*
        //save to cloud
    if (_isSignedIn) {
    _imgDetailModelList.isNotEmpty
        ? {
            setState(() {
              _isUploadBtnLoading =
                  !_isUploadBtnLoading;
            }),
            FirebaseStorageProvider
                    .mAddImageToFirebaseStorage(
                        email: _userEmail!,
                        imgFile:
                            _imgDetailModelList
                                .first
                                .imgFile!,
                        imgName:
                            _imgDetailModelList
                                .first.imgUri!
                                .substring(
                                    6, 15))
                .then((value) {
              if (value != null) {
                print(_userEmail);
                FirestoreProvider.mAddBabyGalleryDataToFirestore(
                    email: _userEmail!,
                    caption:
                        _textEditingControllerCaption
                            .text,
                    imgUrl:
                        "$_userEmail/${Path.basename(_imgDetailModelList.first.imgFile!.path)}",
                    latitude: _imgDetailModelList
                        .first.latitude,
                    longitude:
                        _imgDetailModelList
                            .first.longitude,
                    timestamp:
                        _imgDetailModelList
                            .first.date,
                    date: _imgDetailModelList
                        .first.date,
                    imgFromCamera:
                        _imgDetailModelList
                            .first
                            .imgFromCamera!);
                widget.callback(_userEmail);
                Navigator.pop(context);

                /*    _imgDetailModelList[0]
                        .caption =
                    _textEditingControllerCaption
                        .value.text; */
              }
            })
          }
        : null;
  } else {
    setState(() {
      _isVisible = !_isVisible;
      /*   _isGoogleBtnLoading =
          !_isGoogleBtnLoading; */
    });
  }
*/
  }

  mSaveDataToLocal() {
    setState(() {
      _isUploadBtnLoading = true;
    });
    for (var element in _imgDetailModelList) {
      element.babyId = widget.babyid;
      element.email = widget.momInfo.email;
      element.momId = widget.momInfo.momId;
      element.caption = _textEditingControllerCaption.value.text;
    }
    /* for (var i = 0; i < _imgDetailModelList.length; i++) {
      _imgDetailModelList[i].babyId = widget.babyid;
      _imgDetailModelList[i].email = widget.userEmail;

      print("${_imgDetailModelList[i].babyId} ${_imgDetailModelList[i].email}");
    } */
    MySqfliteServices.mAddBabyGalleryDataToLocal(_imgDetailModelList)
        .then((value) => {
              print("Num of image inserted in to local db: $value "),
              mCallBack(),
            })
        .onError((error, stackTrace) {
      throw Exception(error);
    });
  }

  mCallBack() {
    widget.callback();
    Navigator.pop(context);
  }

  //* For BabyData Sync
  /* Column(
mainAxisSize: MainAxisSize.min,
children: [
  Container(
    height: MyScreenSize.mGetHeight(context, 8),
    color: MyColors.pink1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'বেবি তথ্য',
          fontWeight: FontWeight.w400,
          fontcolor: Colors.white,
          fontsize: 20,
        ),
      ],
    ),
  ),
  Container(
    padding: EdgeInsets.all(8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          // controller: _textEditingControllerCaption,
          maxLines: 1,

          // maxLength: 200,
          decoration: InputDecoration(
            isDense: true,
            label: CustomText(
              text: 'Nick Name*',
            ), /*   border: OutlineInputBorder() */
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          // controller: _textEditingControllerCaption,
          maxLines: 1,

          // maxLength: 200,
          decoration: InputDecoration(
            isDense: true,
            label: CustomText(
              text: 'Full Name',
            ), /*   border: OutlineInputBorder() */
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          // controller: _textEditingControllerCaption,
          maxLines: 1,

          // maxLength: 200,
          decoration: InputDecoration(
            isDense: true,
            label: CustomText(
              text: 'Date of Birth*',
            ), /*   border: OutlineInputBorder() */
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          // controller: _textEditingControllerCaption,
          maxLines: 1,

          // maxLength: 200,
          decoration: InputDecoration(
            isDense: true,
            label: CustomText(
              text: 'Father Name',
            ), /*   border: OutlineInputBorder() */
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          // controller: _textEditingControllerCaption,
          maxLines: 1,

          // maxLength: 200,
          decoration: InputDecoration(
            isDense: true,
            label: CustomText(
              text: 'Mother Name',
            ), /*   border: OutlineInputBorder() */
          ),
        ),
        SizedBox(
          height: 8,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                // padding: EdgeInsets.fromLTRB(12, 0, 12, 0)
                fixedSize: Size(24, 12)),
            onPressed: () {},
            child: CustomText(
              text: 'Proceed',
              fontcolor: Colors.white,
            ))
      ],
    ),
  )
],
) */

  /* void _mShowBabyInputDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please sign in with google account',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            )
          ],
        ),
      ),
      title: 'My Baby',
      desc: 'This is also Ignored',
      // btnOkOnPress: () {},
    ).show();
  } */
}
