class SliderModel {
  String scrNo;
  SliderModel({required this.scrNo});
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel;

  //1
  sliderModel = SliderModel(scrNo: "0");
  slides.add(sliderModel);

  //2
  sliderModel = SliderModel(scrNo: "1");
  slides.add(sliderModel);

  sliderModel = SliderModel(scrNo: "2");
  slides.add(sliderModel);
  sliderModel = SliderModel(scrNo: "3");
  slides.add(sliderModel);

  return slides;
}
