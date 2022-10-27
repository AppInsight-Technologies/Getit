import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../generated/l10n.dart';
import '../widgets/bottom_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import '../constants/IConstants.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../data/calculations.dart';
import '../assets/ColorCodes.dart';
import '../screens/cart_screen.dart';
import '../screens/searchitem_screen.dart';
import '../providers/categoryitems.dart';
import '../utils/prefUtils.dart';

class SubcategoryScreen extends StatefulWidget {
  static const routeName = '/subcategory-screen';
  @override
  _SubcategoryScreenState createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  bool _isLoading = true;
  //var subcategoryData;
  String catTitle = "";
  bool _checkmembership = false;
  bool _isWeb = false;
  //SharedPreferences prefs;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool iphonex = false;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
        });
      } else {
        setState(() {
          _isWeb = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWeb = true;
      });
    }
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery
                .of(context)
                .size
                .height >= 812.0;
          });
        } else {
          setState(() {
            _isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          _isWeb = true;
        });
      }
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      final catId = routeArgs['catId'];
      Provider.of<CategoriesItemsList>(context,listen: false).fetchNestedCategory(catId.toString(), "Subcategory").then((
          _) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildBottomNavigationBar() {
      return ValueListenableBuilder(
        valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context, Box<Product> box, index) {
          if (box.values.isEmpty) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
            title: S.current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
                (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
                Navigator.of(context)
                    .pushNamed(CartScreen.routeName, arguments: {
                  "after_login": ""
                });
              });
            },
          );
          // return Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 50.0,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: <Widget>[
          //       Container(
          //         color: Theme.of(context).primaryColor,
          //         height: 50,
          //         width: MediaQuery.of(context).size.width * 35 / 100,
          //         child: Column(
          //           children: <Widget>[
          //             SizedBox(
          //               height: 8.0,
          //             ),
          //             _checkmembership
          //                 ? Text(  S.of(context).total
          //               //"Total: "
          //                   +
          //                 IConstants.currencyFormat +
          //                 (Calculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
          //               style: TextStyle(color: ColorCodes.whiteColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16
          //               ),
          //             )
          //                 : Text(  S.of(context).total
          //               //"Total: "
          //                 + IConstants.currencyFormat + (Calculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
          //               style: TextStyle(
          //                   color: ColorCodes.whiteColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16
          //               ),
          //             ),
          //             Text(
          //               Calculations.itemCount.toString() +
          //                   S.of(context).item,
          //                   //" item",
          //               style: TextStyle(
          //                   color: ColorCodes.discount,
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 14),
          //             )
          //           ],
          //         ),
          //       ),
          //       GestureDetector(
          //           onTap: () => {
          //             setState(() {
          //               Navigator.of(context)
          //                   .pushNamed(CartScreen.routeName);
          //             })
          //           },
          //           child: Container(
          //               color: Theme.of(context).primaryColor,
          //               height: 50,
          //               width: MediaQuery.of(context).size.width * 65 / 100,
          //               child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     SizedBox(
          //                       width: 80,
          //                     ),
          //                     Text(
          //                  S.of(context).view_cart,
          //                      // 'VIEW CART',
          //                       style: TextStyle(
          //                           fontSize: 16.0,
          //                           color: ColorCodes.whiteColor,
          //                           fontWeight: FontWeight.bold),
          //                       textAlign: TextAlign.center,
          //                     ),
          //                     Icon(
          //                       Icons.arrow_right,
          //                       color: ColorCodes.whiteColor,
          //                     ),
          //                   ]))),
          //     ],
          //   ),
          // );
        },
      );

      /*if(Calculations.itemCount > 0) {
        return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height:50,
                width:MediaQuery.of(context).size.width * 35/100,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    _checkmembership
                        ?
                    Text(IConstants.currencyFormat + (Calculations.totalMember).toString(), style: TextStyle(color: Colors.black),)
                        :
                    Text(IConstants.currencyFormat + (Calculations.total).toString(), style: TextStyle(color: Colors.black),),
                    Text(Calculations.itemCount.toString() + " item", style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 9),)
                  ],
                ),),
              GestureDetector(
                  onTap: () =>
                  {
                    setState(() {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    })
                  },
                  child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
                      child:Column(children:[
                        SizedBox(height: 17,),
                        Text('VIEW CART', style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ]
                      )
                  )
              ),
            ],
          ),
        );
      }*/
    }

    /*final subcategoryData = Provider.of<CategoriesItemsList>(
       context,
      listen: false,
    ).findById(catId);*/


    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? gradientappbarmobile()
          : null,
      backgroundColor: ColorCodes.whiteColor,
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false, false),
          _body(),
        ],
      ),
      bottomNavigationBar:_isWeb
          ? SizedBox.shrink() :Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child:_buildBottomNavigationBar(),
      ),
    );
  }
  Widget _body(){
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120;

    if (deviceWidth > 1200) {
      widgetsInRow = 6;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    } else if (deviceWidth > 650) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 140;
    }
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final catId = routeArgs['catId'];
    final catTitle = routeArgs['catTitle'];
    final subcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);

    return _isLoading ?
    Center(
      child: CircularProgressIndicator(),
    )
        :
    (subcategoryData.bannerSubcat.length <= 0) ?
    SingleChildScrollView(
      child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: new Image.asset(
                Images.noCategoryImg, fit: BoxFit.fill,
                height: 200.0,
                width: 200.0,
//                    fit: BoxFit.cover
              ),
            ),
            if (_isWeb)
              Footer(address: PrefUtils.prefs.getString("restaurant_address")),
          ],
        ))
        :
    Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                child: GridView.builder(
                  shrinkWrap: true,
                  controller: new ScrollController(keepScrollOffset: false),
                  padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  itemCount: subcategoryData.bannerSubcat.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: subcategoryData.bannerSubcat[i],
                    child:MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                            'maincategory': catTitle,
                            'catId': catId,
                            'catTitle': subcategoryData.bannerSubcat[i].title,
                            'subcatId': subcategoryData.bannerSubcat[i].catid,
                            'indexvalue': i.toString(),
                            'prev': "category_item"
                          });
                        },
                        child: Card(
                          color: subcategoryData.bannerSubcat[i].featuredCategoryBColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          margin: EdgeInsets.all(5),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              CachedNetworkImage(
                                imageUrl: subcategoryData.bannerSubcat[i].imageUrl,
                                placeholder: (context, url) => Image.asset(
                                    Images.defaultCategoryImg),
                                errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                height: 55,
                                width: 85,
                                fit: BoxFit.fill,
                              ),
                              Spacer(),
                              Text(subcategoryData.bannerSubcat[i].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widgetsInRow,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 5,
                  ),
                ),
              ),
            ),
            if (_isWeb)
              Footer(address: PrefUtils.prefs.getString("restaurant_address")),
          ],
        ),
      ),
    );
  }
  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color:ColorCodes.menuColor),
          onPressed: () => Navigator.of(context).pop()),
      title: Text(
        catTitle ==
            "" ?
        S.of(context).categories
       // "Categories"
            : catTitle,
        style: TextStyle(color: ColorCodes.menuColor),
      ),
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.accentColor,
                  ColorCodes.primaryColor
                ])),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              SearchitemScreen.routeName,
            );
          },
          child: Icon(Icons.search, size: 30.0,),
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }

}