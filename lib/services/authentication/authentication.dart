
import 'package:firebase_auth/firebase_auth.dart';


abstract class Authentication {
  Future<User?> mSignIn();
}


