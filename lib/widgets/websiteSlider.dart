import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../assets/ColorCodes.dart';
import '../providers/advertise1items.dart';
import '../screens/singleproduct_screen.dart';
import '../screens/items_screen.dart';
import '../providers/categoryitems.dart';
import '../screens/subcategory_screen.dart';
import 'package:provider/provider.dart';
import '../assets/images.dart';
import '../screens/banner_product_screen.dart';
import '../screens/not_brand_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteSlider extends StatefulWidget {
  HomePageData homedata;

  WebsiteSlider(this.homedata);


  @override
  _WebsiteSliderState createState() => _WebsiteSliderState();
}

class _WebsiteSliderState extends State<WebsiteSlider> {
  var _carauselslider = false;

  @override
  Widget build(BuildContext context) {

    if(widget.homedata.data.wesiteslider!=null)
    if (widget.homedata.data.wesiteslider.length >= 0) {
      _carauselslider = true;
    } else {
      _carauselslider = false;
    }

    return _carauselslider ? GFCarousel(
      autoPlay: true,
      viewportFraction: 1.0,
      height: 380.0,
      aspectRatio: 1,
      pagination: true,
      passiveIndicator: Colors.white,
      activeIndicator: Theme.of(context).accentColor,
      autoPlayInterval: Duration(seconds: 8),
//        initialPage: 0,
//        enableInfiniteScroll: true,
//        reverse: false,
//        autoPlay: true,
//        autoPlayInterval: Duration(seconds: 3),
//        autoPlayAnimationDuration: Duration(milliseconds: 800),
//        pauseAutoPlayOnTouch: Duration(seconds: 10),
//        enlargeCenterPage: true,
//        scrollDirection: Axis.horizontal,
      items: <Widget>[
        for (var i = 0; i < widget.homedata.data.wesiteslider.length; i++)
          Builder(
            builder: (BuildContext context) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (widget.homedata.data.wesiteslider[i].bannerFor == "1") {
                      Navigator.of(context).pushNamed(
                          BannerProductScreen.routeName,
                          arguments: {
                            "id" : widget.homedata.data.wesiteslider[i].id,
                            'type': "product"
                          }
                      );
                    } else if (widget.homedata.data.wesiteslider[i].bannerFor == "2") {
                      //Category

                      final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
                      String cattitle = "";
                      for (int j = 0; j < categoriesData.items.length; j++) {
                        if (widget.homedata.data.wesiteslider[i].id == categoriesData.items[j].catid) {
                          cattitle = categoriesData.items[j].title;
                        }
                      }
                      Navigator.of(context)
                          .pushNamed(SubcategoryScreen.routeName, arguments: {
                        'catId': widget.homedata.data.wesiteslider[i].id ,
                        'catTitle': cattitle,
                      });
                    } else if (widget.homedata.data.wesiteslider[i].bannerFor == "3") {
                      String maincategory = "";
                      String catid = "";
                      String subTitle = "";
                      String index = "";

                      Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                        'maincategory': maincategory,
                        'catId': catid,
                        'catTitle': subTitle,
                        'subcatId': widget.homedata.data.wesiteslider[i].id,
                        'indexvalue': index,
                        'prev': "advertise"

                      });
                    } else if(widget.homedata.data.wesiteslider[i].bannerFor == "5") {
                      //brands
                      Navigator.of(context).pushNamed(NotBrandScreen.routeName,
                          arguments: {
                            'brandsId' : widget.homedata.data.wesiteslider[i].id,
                            'fromScreen' : "Banner",
                            'notificationId' : "",
                            'notificationStatus': ""
                          }
                      );
                    } else if(widget.homedata.data.wesiteslider[i].bannerFor == "4") {
                      //Subcategory and nested category
                      Navigator.of(context).pushNamed(BannerProductScreen.routeName,
                          arguments: {
                            'id' : widget.homedata.data.wesiteslider[i].id,
                            'type': "category"
                          }
                      );
                    } else if(widget.homedata.data.wesiteslider[i].bannerFor == "6") {
                      String url = widget.homedata.data.wesiteslider[i].click_link;
                      if (canLaunch(url) != null)
                        launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                    }
                  },
                  child: Container(
                    color: ColorCodes.fill,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                          imageUrl: widget.homedata.data.wesiteslider[i].bannerImage,
                          errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                          placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
                          fit: BoxFit.fill)
                  ),
                ),
              );
            },
          )
      ],
    ) : Container() ;
  }
}