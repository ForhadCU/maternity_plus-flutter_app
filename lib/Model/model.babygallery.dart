import 'package:splash_screen/Model/model.image_details.dart';

class BabyGalleryModel {
  late String imgUrl; //c: for testing grid view
  late final List<ImageDetailsModel> imgDetailsModelList;
  late final String dateTime;
  late final String caption;

  // BabyGalleryModel();
  BabyGalleryModel.nConstructor2({
    required this.imgDetailsModelList,
    required this.dateTime,
    // required this.caption,
  });

  BabyGalleryModel.nConstructor1({required this.imgUrl});

  /* get getImgUrl => imgUrl;

  set setImgUrl(imgUrl) => this.imgUrl = imgUrl; */
}
