import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../assets/ColorCodes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/banner_product_screen.dart';
import '../screens/items_screen.dart';
import '../screens/not_brand_screen.dart';
import '../screens/pages_screen.dart';
import '../screens/subcategory_screen.dart';
import '../widgets/SliderShimmer.dart';
import '../assets/images.dart';
import '../blocs/sliderbannerBloc.dart';
import '../models/brandfieldsModel.dart';

class CarouselSliderimage extends StatefulWidget {
  var _carauselslider = true;
  bool isweb;
  HomePageData homedata;
  CarouselSliderimage(this.homedata);
  @override
  _CarouselSliderimageState createState() => _CarouselSliderimageState();
}

class _CarouselSliderimageState extends State<CarouselSliderimage> {


  @override
  Widget build(BuildContext context) {
    debugPrint("size mainslider....."+widget.homedata.data.mainslider.length.toString());
    // Platform platform;
  return widget.homedata.data.mainslider.length >0?


      GFCarousel(
      autoPlay: true,
      viewportFraction: 1.0,
      height: MediaQuery.of(context).size.height / 1.75,
      pagination: true,
      pagerSize: 8,
      passiveIndicator: ColorCodes.blackColor.withOpacity(0.2),
      activeIndicator: ColorCodes.blackColor,
      autoPlayInterval: Duration(seconds: 8),
      items: [

        for (var i = 0; i < widget.homedata.data.mainslider.length; i++)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {

                if(widget.homedata.data.mainslider[i].bannerFor == "1" ) {
                  // Specific product
                  Navigator.of(context).pushNamed(
                      BannerProductScreen.routeName,
                      arguments: {
                        "id" : widget.homedata.data.mainslider[i].id,
                        'type': "product",
                      }
                  );

                } else if(widget.homedata.data.mainslider[i].bannerFor  == "2") {
                  //Category

                  // final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
                  String cattitle = "";
                  /*    for(int j = 0; j < widget.homedata.data.mainslider.results.length; j++) {
                          // if(bannerData.items[i].banner_data == categoriesData.items[j].catid) {
                          //   cattitle = categoriesData.items[j].title;
                          // }
                        }*/
                  Navigator.of(context).pushNamed(
                      SubcategoryScreen.routeName,
                      arguments: {
                        'catId' : widget.homedata.data.mainslider[i].id,
                        'catTitle': cattitle,
                      }
                  );
                } else if(widget.homedata.data.mainslider[i].bannerFor == "3") {
                  //subcategory

                  String subTitle = "";

                  Navigator.of(context).pushNamed(ItemsScreen.routeName,
                      arguments: {
                        'maincategory' : subTitle.toString(),
                        'catId' : "",
                        'catTitle': subTitle.toString(),
                        'subcatId' : widget.homedata.data.mainslider[i].id,
                        'indexvalue' : "0",
                        'prev' : "carousel"
                      }
                  );
                } else if(widget.homedata.data.mainslider[i].bannerFor == "5") {
                  //brands
                  Navigator.of(context).pushNamed(NotBrandScreen.routeName,
                      arguments: {
                        'brandsId' : widget.homedata.data.mainslider[i].id,
                        'fromScreen' : "Banner",
                        'notificationId' : "",
                        'notificationStatus': ""
                      }
                  );
                } else if(widget.homedata.data.mainslider[i].bannerFor == "4") {
                  //Subcategory and nested category
                  Navigator.of(context).pushNamed(BannerProductScreen.routeName,
                      arguments: {
                        'id' : widget.homedata.data.mainslider[i].id,
                        'type': "category"
                      }
                  );
                } else if(widget.homedata.data.mainslider[i].bannerFor == "6") {
                  String url = widget.homedata.data.mainslider[i].click_link;
                  if (canLaunch(url) != null)
                    launch(url);
                  else
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                } else if(widget.homedata.data.mainslider[i].bannerFor == "7") {
                  //Pages
                  Navigator.of(context).pushNamed(PagesScreen.routeName,
                      arguments: {
                        'id' : widget.homedata.data.mainslider[i].id,
                      }
                  );
                }
              },
              child:
              Container(
                color: ColorCodes.whiteColor,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: CachedNetworkImage(
                      imageUrl: widget.homedata.data.mainslider[i].bannerImage,
                      placeholder: (context, url) {
                        Platform platform;
                        /*Image.asset(Images.defaultSliderImg)*/
                        return SliderShimmer().sliderShimmer(context, platform, height: 500);
                      },
                      errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                      fit: BoxFit.fill),
                ),
              ),
            ),
          ),
      ],
    ):
  Container(
    color: ColorCodes.whiteColor,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 1.75,
    padding: EdgeInsets.symmetric(horizontal: 15.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child:  Image.asset(Images.defaultSliderImg),
          ),
  );


  }

  Widget img() {
    return Image.asset(Images.defaultSliderImg);
  }
}