// import 'package:extended_image/extended_image.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maa/Controller/utils/util.my_scr_size.dart';
import 'package:maa/Model/model.babygallery.dart';
import 'package:thumbnailer/thumbnailer.dart';

class Test extends StatefulWidget {
  final List<String> multipleImagesString;
  const Test({Key? key, required this.multipleImagesString}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final List<BabyGalleryModel> _babyGalleryModelList = [];

  @override
  void initState() {
    super.initState();

    // print("Size: ${widget.multipleImagesString.length}");

    for (var i = 0; i < widget.multipleImagesString.length; i++) {
      _babyGalleryModelList.add(BabyGalleryModel.nConstructor1(
          imgUrl: widget.multipleImagesString[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print("width: $width");
    final crossAxisCount = (width > 1000)
        ? 5
        : (width > 700)
            ? 4
            : (width > 300)
                ? 3
                : 2;

    return Scaffold(
      body: GridView.count(
          padding: const EdgeInsets.only(top: 33),
          crossAxisCount: crossAxisCount,
          /* crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          semanticChildCount: 250,
          childAspectRatio: 200 / 244, */
          physics: const BouncingScrollPhysics(),
          children: _babyGalleryModelList.map((babayGalleryModel) {
            return Column(
              children: [
                Container(
                  color: Colors.black12,
                  child: Thumbnail(
                    mimeType: 'image/png',
                    widgetSize: MyScreenSize.mGetWidth(context, 25),
                    dataResolver: () async {
                      return await File(babayGalleryModel.imgUrl).readAsBytes();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    'png image',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );

            /* Image.file(
              File(babayGalleryModel.imgUrl),
              width: 24,
              height: 24,
            ); */
          }).toList() /*  widget.pokemon
            .map(
              (pokemon) => PokemonCard(
                id: pokemon.id,
                name: pokemon.name,
                image: pokemon.img,
              ),
            )
            .toList(), */
          ),
    );
    /* ExtendedImageGesturePageView.builder(
      itemBuilder: (BuildContext context, int index) {
        var item = (widget.multipleImagesString[index]);
        Widget image = ExtendedImage.file(
          File(item),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (extendedImageEditorState) {
            return GestureConfig(
                inPageView: true,
                initialScale: 1.0,
                //you can cache gesture state even though page view page change.
                //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                cacheGesture: false);
          },
        );
        image = Container(
          child: (image),
          padding: const EdgeInsets.all(5.0),
        );
        if (index == currentIndex) {
          return Hero(
            tag: item + index.toString(),
            child: image,
          );
        } else {
          return image;
        }
      },
      itemCount: widget.multipleImagesString.length,
      onPageChanged: (int index) {
        currentIndex = index;
        rebuild.add(index);
      },
      controller: PageController(
        initialPage: currentIndex,
      ),
      scrollDirection: Axis.horizontal,
    ); */
  }
}
