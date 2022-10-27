import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Shimmer.fromColors(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(height: 200,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(height: 80,width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  )),
              Container(height: 80,width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  )),
              Container(height: 80,width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  )),
              Container(height: 80,width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  )),
            ],
          ),
        ),
      ],
    ),
      baseColor: ColorCodes.baseColor,
      highlightColor: ColorCodes.lightGreyWebColor,);

  }
}
