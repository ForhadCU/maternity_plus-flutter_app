// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/Controller/services/sqflite_services.dart';
import 'package:splash_screen/Model/model.mom_info.dart';
import 'package:splash_screen/View/screens/splash/scr.dummy_splash2.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.keywords.dart';

import '../launcherSlides/scr.launcher_slides.dart';
import '../shagotom/scr.shagotom.dart';

class DummySplashScreen extends StatefulWidget {
  const DummySplashScreen({Key? key}) : super(key: key);

  @override
  State<DummySplashScreen> createState() => _DummySplashScreenState();
}

class _DummySplashScreenState extends State<DummySplashScreen> {
  late bool isLoading;
  late bool isSigningIn = false;
  late SharedPreferences _pref;
   MomInfo? momInfo;

  @override
  void initState() {
    super.initState();
    print("1st");
    isLoading = true;
    checkData();
  }

  @override
  void dispose() {
    super.dispose();
    // isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.pink2,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.pink2,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: MyColors.pink2,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light)),
      body: Center(
        child: isLoading
            ? /* const CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: MyColors.textOnPrimary,
              ) */
            /* DotBlickLoader(
                dotOneColor: MyColors.pink3,
                dotTwoColor: MyColors.pink4,
                dotThreeColor: MyColors.pink5,
              ) */

            // e: Animated Launcher icon goes here..
            // v: dummy
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*   Image.asset(
                      "lib/assets/images/firstscreenlogo.png",
                      height: MyScreenSize.mGetHeight(context, 36),
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 28,
                    ), */
                    const Text("Animated launcher icon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: MyColors.textOnPrimary))
                  ],
                ),
              )
            : Container(),
        // child: ,
      ),
    );
  }

  void checkData() async {
    _pref = await SharedPreferences.getInstance();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String? status = _pref.getString(MyKeywords.loggedin);
    int? _currentMomId = _pref.getInt(MyKeywords.momId);

    // await MySqfliteServices.mGetMomId().then((value) => _currentMomId = value);

    //Test
    /* Navigator.pushReplacement(
          context,
          PageTransition(
              child: const LauncherSlidesScreen(),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 300))); */

    //Orginal Code
    /* status == 'y'
          ? {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ShagotomScreen(
                        babyId: _babyId,
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300)))
            }
          : Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const LauncherSlidesScreen(),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300))); */

    //delay jsut for showoff
    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      //Test
      /* Navigator.pushReplacement(
          context,
          PageTransition(
              child: const LauncherSlidesScreen(),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 300))); */

      //Orginal Code
      // print('Status: $status');
      firebaseAuth.authStateChanges().listen((User? user) {
        if (user != null) {
          print('User already signed in');
          //? check if the user start pregnancy previously
          mFirstEntryCheck(status, user.email, _currentMomId);
        } else {
          print("User not signed in yet");
          /* Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const LauncherSlidesScreen(
                    // isSignedIn: false,
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300))); */

          //part: sign in dialog
          // mShowSignInDialog();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child:
                      const /* LauncherSlidesScreen(
                    // isSignedIn: true,
                    ) */
                      SecondSplashScreen(),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 0)));

          /* setState(() {
            isLoading = false;
          }); */
        }
      }).onError((error, stackTrace) {
        print(
            'Something went wrong during babyGallery Data retrieving from Sqflite, Error: $error');
      });
      /*   status == 'y'
          ? {
              print('BabyId: $_babyId'),
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ShagotomScreen(
                        babyId: _babyId,
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300)))
            }
          : Navigator.pushReplacement(
              context,
              PageTransition(
                  child:  LauncherSlidesScreen(isSignedIn: false,),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300))); */
    });
  }

  void mFirstEntryCheck(String? status, String? email, int? currentMomId) async {
    status == 'y'
        ? {
            momInfo = await MySqfliteServices.mFetchMomInfo(email: email!, currentMomId: currentMomId!),
            if(momInfo != null)
            {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    child: ShagotomScreen(
                      momInfo:  momInfo!,
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300)))
            }
          }
        : Navigator.pushReplacement(
            context,
            PageTransition(
                child:
                    const /* LauncherSlidesScreen(
                    // isSignedIn: true,
                    ) */
                    LauncherSlidesScreen(),
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300)));
  }

  void mShowSignInDialog() {
    /* 
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      dismissOnTouchOutside: false,
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
              children: [
                !isSigningIn
                    ? RawMaterialButton(
                        onPressed: () async {
                          setState(() {
                            isSigningIn = true;
                            Navigator.pop(context);
                          });
                          Authentication.signInWithGoogle(context: context)
                              .then((value) {
                            if (value != null) {
                              mSaveCradential(value);

                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: const LauncherSlidesScreen(
                                          // isSignedIn: true,
                                          ),
                                      type: PageTransitionType.rightToLeft,
                                      duration:
                                          const Duration(milliseconds: 0)));
                            } else {
                              print('Null Credential');
                            }

                            // checkData();
                            /* setState(() {
                                    /*   _userEmail = value!.email!;
                              _isVisible = !_isVisible;
                              _isSignedIn = true;
                              _isGoogleBtnLoading = !_isGoogleBtnLoading; */
                                  }); */
                          }).onError((error, stackTrace) {
                            print(error);
                            mShowSignInDialog();
                          });
                        },
                        elevation: 2.0,
                        constraints: BoxConstraints(
                            maxHeight: 40,
                            minHeight: 40,
                            maxWidth: 40,
                            minWidth: 40),
                        shape: CircleBorder(),
                        fillColor: Colors.white,
                        child: Image(
                          image: AssetImage("lib/assets/images/ic_google.png"),
                        ),
                      )
                    : DotBlickLoader(
                        dotOneColor: MyColors.pink3,
                        dotTwoColor: MyColors.pink4,
                        dotThreeColor: MyColors.pink5,
                      )
              ],
            )
          ],
        ),
      ),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
      // btnOkOnPress: () {},
    ).show();
   */
  }

  void mSaveCradential(User user) {
    /* 
    _pref.setString('email', user.email.toString());
    _pref.setString('uid', user.uid.toString());
   */
  }
}
