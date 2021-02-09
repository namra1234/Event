import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/common/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ImageContainer extends StatelessWidget {
  ImageContainer({
    this.url,
    this.bytes,
    this.margin,
    this.imageWidth: 300,
    this.imageHeight: 200,
    this.shadowContainer: false,
    this.blackshadowContainer: false,
    this.useShadow: true,
    this.fit: BoxFit.cover,
    this.onTap,
    this.bottomContainerHorizontalOffset: .2,
    this.shadowOffset: 6,
    this.radius,
  });

  final String url;
  final Uint8List bytes;

  final EdgeInsetsGeometry margin;
  final double imageWidth, imageHeight;
  final bool shadowContainer;
  final bool blackshadowContainer;
  final bool useShadow;
  final BoxFit fit;
  final GestureTapCallback onTap;
  final double bottomContainerHorizontalOffset;
  final double shadowOffset;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    final loading = Center(
      child: CircularProgressIndicator(),
    );

    Widget image = loading;
    if (bytes != null) {
      image = Image.memory(
        bytes,
        width: double.infinity,
        height: double.infinity,
        fit: fit,
      );
    } else if (url != null) {
      image = CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => loading,
        errorWidget: (context, url, error) => Center(
          child: Icon(
            Icons.error,
          ),
        ),
        fit: fit,
      );
    }

    return GestureDetector(
      onTap: this.onTap,
      child: Container(
          margin: margin,
          decoration: BoxDecoration(
            boxShadow: useShadow && !shadowContainer
                ? [
                    BoxShadow(
                        color: ColorConstants.kBlackColor.withOpacity(.25),
                        blurRadius: 5,
                        offset: Offset(0, 5))
                  ]
                : [],
          ),
          width: imageWidth,
          height: imageHeight,
          child: Stack(
            children: [
              shadowContainer ? gradientContainer() : blackshadowContainer ? blackgradientContainer() : Container(),
              
              Padding(
                padding: EdgeInsets.only(
                  bottom: shadowContainer ? shadowOffset : blackshadowContainer ? shadowOffset :0,
                ),
                child: ClipRRect(
                  borderRadius: radius ?? BorderRadius.circular(10.0),
                  child: image,
                ),
              )
            ],
          )),
    );
  }

  Widget gradientContainer() {
    final offset = imageWidth != null
        ? bottomContainerHorizontalOffset * imageWidth
        : 30.0;

    return Container(
      margin: EdgeInsets.only(
        left: offset,
        right: offset,
        top: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.kBlackColor.withOpacity(.5),
            blurRadius: 5,
          )
        ],
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorConstants.kSecondaryColor, ColorConstants.kPrimaryColor]),
      ),
    );
  }

    Widget blackgradientContainer() {
    final offset = imageWidth != null
        ? bottomContainerHorizontalOffset * imageWidth
        : 30.0;

    return Container(
      margin: EdgeInsets.only(
        left: offset,
        right: offset,
        top: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.kBlackColor.withOpacity(.5),
            blurRadius: 5,
          )
        ],
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorConstants.kGreyColor,ColorConstants.kGreyColor]),
      ),
    );
  }
}
