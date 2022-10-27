import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../providers/carouselitems.dart';
import '../screens/items_screen.dart';
import '../providers/categoryitems.dart';
import '../screens/subcategory_screen.dart';
import 'package:provider/provider.dart';
import '../assets/images.dart';
import '../screens/banner_product_screen.dart';
import '../screens/not_brand_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteSmallbanner extends StatefulWidget {
  HomePageData homedata;
  WebsiteSmallbanner(this.homedata);


  @override
  _WebsiteSmallbannerState createState() => _WebsiteSmallbannerState();
}

class _WebsiteSmallbannerState extends State<WebsiteSmallbanner> {
  var _carauselslider = false;

  @override
  Widget build(BuildContext context) {
    final bannerData = Provider.of<CarouselItemsList>(context, listen: false);

    if(widget.homedata.data.mainslider!=null)
    if (widget.homedata.data.mainslider.length > 0) {
      _carauselslider = true;
    } else {
      _carauselslider = false;
    }

    return _carauselslider ? GFCarousel(
      autoPlay: false,
      viewportFraction: 1.0,
      //
      // width: 540.0,
      height: 280.0,
      aspectRatio: 1,
      pagination: false,
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
        for (var i = 0; i < widget.homedata.data.mainslider.length; i++)
          Builder(
            builder: (BuildContext context) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {


                  },
                  child: Container(
                    height: 280,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.homedata.data.mainslider.length,
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: (){
                            if (widget.homedata.data.mainslider[i].bannerFor == "1") {
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              Navigator.of(context).pushNamed(
                                  BannerProductScreen.routeName,
                                  arguments: {
                                    "id" : widget.homedata.data.mainslider[i].id,
                                    'type': "product"
                                  }
                              );
                            } else if (widget.homedata.data.mainslider[i].bannerFor == "2") {
                              //Category
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              debugPrint("asdf2"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
                              String cattitle = "";
                              for (int j = 0; j < categoriesData.items.length; j++) {
                                if (widget.homedata.data.mainslider[i].id == categoriesData.items[j].catid) {
                                  cattitle = categoriesData.items[j].title;
                                }
                              }
                              Navigator.of(context)
                                  .pushNamed(SubcategoryScreen.routeName, arguments: {
                                'catId': widget.homedata.data.mainslider[i].id,
                                'catTitle': cattitle,
                              });
                            } else if (widget.homedata.data.mainslider[i].bannerFor == "3") {
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              debugPrint("asdf3"+widget.homedata.data.mainslider[i].id.toString());
                              String maincategory = "";
                              String catid = "";
                              String subTitle = "";
                              String index = "";

                              Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                                'maincategory': maincategory,
                                'catId': catid,
                                'catTitle': subTitle,
                                'subcatId': widget.homedata.data.mainslider[i].id,
                                'indexvalue': index,
                                'prev': "advertise"

                              });
                            } else if(widget.homedata.data.mainslider[i].bannerFor == "5") {
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              debugPrint("asdf4"+widget.homedata.data.mainslider[i].id.toString());
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
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              debugPrint("asdf5"+widget.homedata.data.mainslider[i].id.toString());
                              //Subcategory and nested category
                              Navigator.of(context).pushNamed(BannerProductScreen.routeName,
                                  arguments: {
                                    'id' : widget.homedata.data.mainslider[i].id,
                                    'type': "category"
                                  }
                              );
                            } else if(widget.homedata.data.mainslider[i].bannerFor == "6") {
                              debugPrint("asdf1"+widget.homedata.data.mainslider[i].bannerFor.toString());
                              String url = widget.homedata.data.mainslider[i].click_link;
                              if (canLaunch(url) != null)
                                launch(url);
                              else
                                // can't launch url, there is some error
                                throw "Could not launch $url";
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            width: 540.0,
                            height: 280.0,
                            margin: EdgeInsets.only(right: 10.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.homedata.data.mainslider[i].bannerImage,
                              width: 50.0,
                              height: 50.0,
                              placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
                              errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
      ],
    ) : Container() ;
  }
}