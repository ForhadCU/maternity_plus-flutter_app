import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splash_screen/Controller/services/cloud_storage.dart';
import 'package:splash_screen/Model/model.image_details.dart';

class FirestoreProvider {
  static void mAddBabyGalleryDataToFirestore(
      {required String email,
      String? caption,
      required String imgUrl,
      double? latitude,
      double? longitude,
      String? timestamp,
      String? date,
      required bool imgFromCamera}) {
    final FirebaseFirestore _firebaseFirestoreRef = FirebaseFirestore.instance;

    _firebaseFirestoreRef
        .collection('USERS')
        .doc(email)
        .collection('DIARY')
        .doc()
        .set({
      "email": email,
      "caption": caption,
      "imgUrl": imgUrl,
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": timestamp,
      "date": date,
      "imgFromCamera": imgFromCamera,
    });
  }

  //c: Valid For Single image selection
  /* static Future<List<ImageDetailsModel>> mFetchAllDiaryDatafromFirestore(
      {required String email}) async {
    final FirebaseFirestore _firebaseFirestoreRef = FirebaseFirestore.instance;
    List<ImageDetailsModel> _listImageDetailModel = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestoreRef
            .collection('USERS')
            .doc(email)
            .collection('DIARY')
            .orderBy("timestamp", descending: true)
            .get();

    for (var element in querySnapshot.docs) {
      _listImageDetailModel.add(ImageDetailsModel.fromJson(element.data()));
      // print("address: ${element['imgUrl']}");
/*       _listImageDetailModel[i].strgImgUri =
          await FirebaseStorageProvider.mGetImgUrl(element['imgUrl']);
      i++; */

      // print('Json: ' + jsonDecode(element.data().toString()));
    }

    for (var i = 0; i < _listImageDetailModel.length; i++) {
      _listImageDetailModel[i].strgImgUri =
          await FirebaseStorageProvider.mGetImgUrl(
              _listImageDetailModel[i].imgUrl!);
    }

    print('out');

    return _listImageDetailModel;
  } */
}
