import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'color_constants.dart';
import 'imageContainer.dart';
import 'photoView.dart';
import 'utility.dart';

class GalleryGrid extends StatefulWidget {
  GalleryGrid({
    this.isEditable: false,
    this.pictures,
    this.preview: false,
  });

  final bool isEditable;
  final List<dynamic> pictures;
  final bool preview;

  @override
  State<StatefulWidget> createState() => _GalleryGridState(
        images: pictures,
      );
}

class _GalleryGridState extends State<GalleryGrid> {
  _GalleryGridState({this.images});

  List<dynamic> images;

  @override
  void initState() {
    if (images == null) {
      images = [];
    }

    while (images.length < 4) {
      images.add(null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(
      height: 10,
      width: 10,
    );

    return SizedBox(
      height: 250,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.maxWidth;

        return Row(
          children: [
            Container(
              width: .9* width,
              child: pictureGridItem(
                imageToContainer(0),
              ),
            ),
            space,
            
          ],
        );
      }),
    );
  }

  Widget pictureGridItem(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.kWhiteColor,
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .25),
            blurRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(7),
      ),
      child: child,
    );
  }

  Widget imageToContainer(int index) {
    var image = images[index];
    Widget pic;

    if (image is Uint8List) {
      pic = GestureDetector(
       onTap: () => onImageClicked(image,0),
        child: ImageContainer(
          useShadow: false,
          shadowContainer: false,
          imageWidth: double.infinity,
          imageHeight: double.infinity,
          bytes: image,
        ),
      );
    }

    Widget actionContainer = Container();
    if (widget.isEditable) {
      if (pic != null) {
        actionContainer = Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => doAction(index),
            icon: Icon(
              Icons.delete,
              color: ColorConstants.kPrimaryColor,
            ),
            iconSize: 30,
          ),
        );
      } else {
        actionContainer = Material(
          color: ColorConstants.kBlackColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(7),
          child: InkWell(
            onTap: () => doAction(index),
            borderRadius: BorderRadius.circular(7),
            child: Center(
              child: Icon(
                Icons.add,
                size: 40,
                color: ColorConstants.kPrimaryColor,
              ),
            ),
          ),
        );
      }
    }

    return Stack(
      children: [
        pic ?? Container(),
        actionContainer,
      ],
    );
  }

  void doAction(int index) async {
    try {
      var image = images[index];

      if (image != null) {
        setState(() {
          images[index] = null;
        });
      } else {
        final tempImageList = List.from(images);
        var rejectImage = false;
        tempImageList.removeWhere((element) => element == null);
        var pickedImageList = await MultiImagePicker.pickImages(
          maxImages: 1 - tempImageList.length,
          enableCamera: true,
        );

        if (pickedImageList != null && pickedImageList.length > 0) {
          for (var pickedImage in pickedImageList) {
            
            var imgName = pickedImage.name.split(".");
            var imgNameLength = imgName.length;

            if (imgName[imgNameLength - 1] == "jpg" ||
                imgName[imgNameLength - 1] == "JPG" ||
                imgName[imgNameLength - 1] == "png" ||
                imgName[imgNameLength - 1] == "PNG" ||
                imgName[imgNameLength - 1] == "jpeg" ||
                imgName[imgNameLength - 1] == "JPEG") {
              var bytes =
                  (await pickedImage.getByteData()).buffer.asUint8List();
              int selectedIndex;
              // first priority to tapped index
              if (images[index] == null) {
                selectedIndex = index;
              } else {
                // second priority to any other null
                selectedIndex = images.indexOf(null);
              }
              setState(() {
                images[selectedIndex] = bytes;
              });
            } else {
              rejectImage = true;
            }
          }

          if (rejectImage) {
            Fluttertoast.showToast(
              msg: "You can only select jpg and png type image.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 13.0,
            );
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void onImageClicked(dynamic pic, int index) {
    if (widget.preview) {
      PhotoViewScreen.show(
          context,
          widget.pictures.map((e) => pic.url).toList(),
          index);
    }
  }
}
