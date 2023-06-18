import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as Path;

class FirebaseStorageProvider {
  // static Future<TaskSnapshot?> mAddImageToFirebaseStorage(
  static Future<TaskSnapshot?> mAddImageToFirebaseStorage(
      {required File imgFile,
      // required String imgName,
      required String email}) async {
    final firebaseStorageRef = FirebaseStorage.instance.ref();

    try {
      TaskSnapshot snapshot;

      snapshot = await firebaseStorageRef
          .child("$email/${Path.basename(imgFile.path)}")
          .putFile(imgFile);
      // await firebaseStorageRef.child("$email/$imgName").putFile(imgFile);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return snapshot;
    } on firebase_core.FirebaseException catch (e) {
      Logger().d("My Image exception : $e");
    }

    return null;
  }

  static Future<Uint8List?> mGetImgUrl(String imageFileName) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    // storageBucket: 'gs://maaapp-ab769.appspot.com/');

    // final firebaseStorageRef = FirebaseStorage.instance.ref();

    Uint8List? imageBytes;
    await firebaseStorage
        .ref()
        .child(imageFileName)
        .getData(100000000)
        .then((value) => {imageBytes = value})
        .catchError((error) {
      Logger().d('Error in getting storage data: ${error.toString()}');
    });
    return imageBytes;
  }
}
