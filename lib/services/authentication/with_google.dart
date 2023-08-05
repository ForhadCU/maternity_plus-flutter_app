// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/debug_print.dart';
import '../../utils/util.custom_text.dart';
import 'authentication.dart';

class SignInWithGoogle implements Authentication {
  BuildContext buildContext;

  SignInWithGoogle({required this.buildContext});

  @override
  Future<User?> mSignIn() async {
    const String accountExisted = "account-exists-with-different-credential";
    const String crendentialInvalid = "invalid-credential";

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

   /*  if (kDebugMode) {
      Warning()
          .mPrint(message: "GoogleSignInAccount Details: $googleSignInAccount");
    } */

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        kDebugMode
            ? Warning().mPrint(message: "Google Sign in done. User is: $user")
            : null;

        /* Navigator.of(context).pushReplacement(PageTransition(
            child: TeamCheckScreen(),
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 800))); */
      } on FirebaseAuthException catch (e) {
        if (e.code == accountExisted) {
          //handle the error here
          ScaffoldMessenger.of(buildContext).showSnackBar(const SnackBar(
              content: CustomText(
            text:
                "The account is already exists with a differrent crendential.",
          )));
        } else if (e.code == crendentialInvalid) {
          //handle the error here
          ScaffoldMessenger.of(buildContext).showSnackBar(const SnackBar(
              content: CustomText(
            text: "Error occured while accesing credentials. Try again!",
          )));
        }
      } catch (e) {
        //handle the error here
       /*  ScaffoldMessenger.of(buildContext).showSnackBar(const SnackBar(
            content: CustomText(
                text: "Error occured using Google Sign-In. Try again!"))); */
      }
    } else {
      if (kDebugMode) {
        Debuging().mPrint(message: "Google Sign in account is null");
      }
    }

    return user;
  }
}
