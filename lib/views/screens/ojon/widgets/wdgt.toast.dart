import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CustomToast {
  static Future<bool?> myToast = Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.black,
        fontSize: 16.0
    );
  
}