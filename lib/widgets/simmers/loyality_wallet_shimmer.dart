import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';

class LoyalityorWalletShimmer extends StatelessWidget {
  const LoyalityorWalletShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorCodes.baseColor,
      highlightColor: ColorCodes.lightGreyWebColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
     /* Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
         *//* Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
          ),
          SizedBox(
            width: 30.0,
          ),*//*
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              *//*Text(
                "Wallet Balance",
                style: TextStyle(
                  fontSize: 21.0,
                  color: Color(0xff646464),
                ),
              ),
              Text(
                "Available Points",
                style: TextStyle(
                  fontSize: 21.0,
                  color: Color(0xff646464),
                ),
              )*//*
              Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: Colors.black, ),),),
              Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: Colors.black, ),),),
            ],
          ),
          SizedBox(
            height: 100.0,
          ),
          Divider(),
        ],
      ),
    ),*/
          new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(0.0),
            itemCount: 6,
            itemBuilder: (_, i) => Container(
                margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Shimmer.fromColors(
                  baseColor: ColorCodes.baseColor,
                  highlightColor: ColorCodes.lightGreyWebColor,
                  child: Container(
                    height: 90.0,
                    color: Theme.of(context).buttonColor,
                  ),
                )),
          ),
        ],

      ),
    );
  }
}
