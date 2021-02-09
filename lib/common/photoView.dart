import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewScreen extends StatefulWidget {

  PhotoViewScreen(this.galleryItems, { this.initial: 0 });

  final List<String> galleryItems;
  final int initial;

  @override
  State<StatefulWidget> createState() => _PhotoViewScreenState();

  static void show(BuildContext context, List<String> images, int initial) {
    showDialog(
        context: context,
        child: PhotoViewScreen(
          images,
          initial: initial,
        )
    );
  }
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {

  PageController controller = PageController();

  @override
  void initState() {
    controller = PageController(
      initialPage: widget.initial,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
          pageController: controller,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.galleryItems[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
//              heroAttributes: HeroAttributes(tag: galleryItems[index].id),
            );
          },
          itemCount: widget.galleryItems.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
//          backgroundDecoration: widget.backgroundDecoration,
//          pageController: widget.pageController,
//          onPageChanged: onPageChanged,
        )
    );
  }

}