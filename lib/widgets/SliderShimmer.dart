
import 'dart:io';

import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';

class SliderShimmer{
  bool isweb = true;


  sliderShimmer(BuildContext context,Platform platform,{@required double height}) {
    if(Platform.isAndroid||Platform.isIOS){
      isweb = false;
    }
    return isweb ?
    SizedBox.shrink()
        :
    Shimmer.fromColors(
        baseColor: /*Color(0xffd3d3d3)*/Colors.grey[200],
        highlightColor: ColorCodes.lightGreyWebColor,
        child:Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            height: height,
              width: MediaQuery.of(context).size.width - 20.0,
          color: Colors.white,
        ));
  }
}