import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:maa/Controller/services/authentication/authentication.dart';
import 'package:maa/Controller/utils/debug_print.dart';

class SignInWithEmailPass implements Authentication {
  String email;
  String pass;

  SignInWithEmailPass({required this.email, required this.pass});
  @override
  Future<User?> mSignIn() async {
    FirebaseAuth mAuth = FirebaseAuth.instance;

    await mAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      kDebugMode ? Info().mPrint(message: "User : ${value.user!.email}") : null;
    }).onError((error, stackTrace) =>
            kDebugMode ? Warning().mPrint(message: error.toString()) : null);
    throw UnimplementedError();
  }
}
