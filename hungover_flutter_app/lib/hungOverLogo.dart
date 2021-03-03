import 'package:flutter/material.dart';

class HungOverLogo{

  //HungOver Logo
  static Widget hungOverLogo() {
    var assetImage = AssetImage("assets/images/hungOver.png");
    var image = Image(
      image: assetImage,
      height: 200,
      width: 200,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(0),
    );
  }
}
