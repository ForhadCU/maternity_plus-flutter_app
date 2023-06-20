// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:maa/services/authentication/with_google.dart';
import 'package:maa/utils/util.custom_text.dart';
import 'package:maa/views/screens/launcherSlides/scr.launcher_slides.dart';
import 'package:maa/views/widgets/dot_blink_loader.dart';
import 'package:maa/consts/const.colors.dart';
import 'package:maa/consts/const.keywords.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Logger logger = Logger();

  late StreamSubscription subscription;
  bool isLoading = true;
  late bool isSigningIn = false;
  late SharedPreferences _pref;

  @override
  void initState() {
    super.initState();
    mCheckConnectivity();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (kDebugMode) logger.d("Connectivity Result: ${result.toString()}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
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
              ? const DotBlickLoader(
                  dotOneColor: MyColors.pink3,
                  dotTwoColor: MyColors.pink4,
                  dotThreeColor: MyColors.pink5,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage("lib/assets/images/ic_warning.png"),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      text: "No internet connection available",
                      fontcolor: Colors.white24,
                      fontWeight: FontWeight.bold,
                      fontsize: 16,
                    )
                  ],
                )
          // child: ,
          ),
    );
  }

  void mCheckConnectivity() async {
    _pref = await SharedPreferences.getInstance();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      mShowSigninDialog();
      // isLoading = false;
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void mShowSigninDialog() {
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
              children: const [
                Text(
                  'Please sign in with google account',
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isSigningIn)
                  RawMaterialButton(
                    onPressed: () async {
                      // print("G button Clicked");
                      setState(() {
                        // isSigningIn = true;
                        Navigator.pop(context);
                      });

                /*      await SignInWithEmailPass(
                          email: "user@gmail.com", pass: "123456").mSignIn(); */

                      // Authentication.signInWithGoogle(bc: context)
                    await  SignInWithGoogle(buildContext: context)
                          .mSignIn()
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
                                  duration: const Duration(milliseconds: 0)));
                        } else {
                          if (kDebugMode) {
                            logger.w('Null Credential');
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Not Signed in. Try again!")));
                          mShowSigninDialog();
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
                        mShowSigninDialog();
                      }); 
                    },
                    elevation: 2.0,
                    constraints: const BoxConstraints(
                        maxHeight: 40,
                        minHeight: 40,
                        maxWidth: 40,
                        minWidth: 40),
                    shape: const CircleBorder(),
                    fillColor: Colors.white,
                    child: const Image(
                      image: AssetImage("lib/assets/images/ic_google.png"),
                    ),
                  )
                else
                  const DotBlickLoader(
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
  }

  void mSaveCradential(User user) {
    // print("Display Name: ${user.displayName}");
    _pref.setString(MyKeywords.username, user.displayName.toString());
    _pref.setString(MyKeywords.email, user.email.toString());
    _pref.setString(MyKeywords.uid, user.uid.toString());
    _pref.setString(MyKeywords.userImageUrl, user.photoURL.toString());
    // _pref.setString(MyKeywords.loggedin, "y");
  }
}
