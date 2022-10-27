import 'dart:io';
import '../assets/images.dart';
import '../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../screens/address_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/map_screen.dart';
import '../widgets/header.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../providers/sellingitems.dart';
import '../screens/home_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/selling_items.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';


class NotavailabilityProduct extends StatefulWidget {
  static const routeName = 'notavailability-screen';
  @override
  _NotavailabilityProductState createState() => _NotavailabilityProductState();
}

class _NotavailabilityProductState extends State<NotavailabilityProduct> {
  var similarlistData;
  Box<Product> productBox;
  String currentBranch;
  String val;
  var _checkitem = false;
  var _isLoading = true;
  bool _isWeb = false;
  bool iphonex = false;
  bool endOfProduct = false;


  @override
 void initState() {

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
    Future.delayed(Duration.zero, () async {
      productBox = Hive.box<Product>(productBoxName);

        final routeArgs = ModalRoute
            .of(context)
            .settings
            .arguments as Map<String, dynamic>;
        currentBranch = routeArgs['currentBranch'];
        val = routeArgs['val'];
        debugPrint("currentBranch....rfgfd"+ currentBranch + " "+val);
        await Provider.of<SellingItemsList>(context, listen: false)
            .fetchSwapProductold(currentBranch, val)
            .then((_) {
          similarlistData = Provider.of<SellingItemsList>(context, listen: false);
          _isLoading = false;
          debugPrint("isloading.."+_isLoading.toString());
          if (similarlistData.itemsSwap.length <= 0) {
            setState(() {
              _checkitem = false;
            });
          } else {

            setState(() {
              _checkitem = true;
            });
          }
        });



    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _bodyMobile(){
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = 1;
      if (deviceWidth > 1200) {
        widgetsInRow = 5;
      } else if (deviceWidth > 768) {
        widgetsInRow = 3;
      }
      double aspectRatio = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 360:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 180;
      return _isLoading
          ? /*Expanded(
        child: */Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ItemListShimmer(),
            //),
      ),
          ],
        )
          :
    /*  Expanded(
        child:*/ _checkitem ? (_isWeb && !ResponsiveLayout.isSmallScreen(context))? Flexible(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: new GridView.builder(
                        shrinkWrap: true,
                        itemCount: similarlistData.itemsSwap.length,
                        controller: new ScrollController(keepScrollOffset: false),
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widgetsInRow,
                          crossAxisSpacing: 3,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return SellingItems(
                            "notavailableProduct",
                            similarlistData.itemsSwap[index].id,
                            similarlistData.itemsSwap[index].title,
                            similarlistData.itemsSwap[index].imageUrl,
                            similarlistData.itemsSwap[index].brand,
                            "",
                            similarlistData.itemsSwap[index].veg_type,
                            similarlistData.itemsSwap[index].type,
                            similarlistData.itemsSwap[index].eligible_for_express,
                            similarlistData.itemsSwap[index].delivery,
                            similarlistData.itemsSwap[index].duration,
                            similarlistData.itemsSwap[index].durationType,
                            similarlistData.itemsSwap[index].note,
                            similarlistData.itemsSwap[index].subscribe,
                            similarlistData.itemsSwap[index].paymentmode,
                            similarlistData.itemsSwap[index].cronTime,
                            similarlistData.itemsSwap[index].name,

                          );
                        }),
                  ),

                ),
                SizedBox(height: 30,),
                // if(_isWeb)
                //   GestureDetector(
                //     onTap: () {
                //       if (PrefUtils.prefs.getString("skip") == "no") {
                //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
                //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                //           if (PrefUtils.prefs.containsKey("fromcart")) {
                //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                //               PrefUtils.prefs.remove("fromcart");
                //               Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                //                   ModalRoute.withName(CartScreen.routeName));
                //               Navigator.of(context).pushReplacementNamed(
                //                 CartScreen.routeName,
                //               );
                //             } else {
                //               debugPrint("location 9 . . . . .");
                //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                //             }
                //           }else {
                //             debugPrint("location 10 .1 . . . .");
                //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                //           }
                //         }
                //         else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                //           Navigator.of(context)
                //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
                //             'addresstype': "new",
                //             'addressid': "",
                //           });
                //         }
                //       } else {
                //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
                //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                //           if (PrefUtils.prefs.containsKey("fromcart")) {
                //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                //               PrefUtils.prefs.remove("fromcart");
                //               Navigator.of(context).pushNamedAndRemoveUntil(
                //                   MapScreen.routeName,
                //                   ModalRoute.withName(CartScreen.routeName));
                //
                //               Navigator.of(context).pushReplacementNamed(
                //                 CartScreen.routeName,
                //               );
                //             } else {
                //               debugPrint("location 7 . . . . .");
                //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                //             }
                //           } else {
                //             debugPrint("location 8 . . . . .");
                //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                //             /*Navigator.of(context)
                //           .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
                //         "currentBranch": currentBranch
                //       });*/
                //             ///hello
                //           }
                //         } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                //           Navigator.of(context)
                //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
                //             'addresstype': "new",
                //             'addressid': "",
                //           });
                //         }
                //
                //       }
                //     },
                //     child: Container(
                //       height: 50,
                //       width: double.infinity,
                //       color: Theme.of(context).primaryColor,
                //       child: Center(
                //         child: Text(
                //           S.of(context).confirm,
                //           style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address"))
              ],
            ),
          ),
        ):SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                child: new GridView.builder(
                    shrinkWrap: true,
                    itemCount: similarlistData.itemsSwap.length,
                    controller: new ScrollController(keepScrollOffset: false),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widgetsInRow,
                      crossAxisSpacing: 3,
                      childAspectRatio: aspectRatio,
                      mainAxisSpacing: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return SellingItems(
                        "notavailableProduct",
                        similarlistData.itemsSwap[index].id,
                        similarlistData.itemsSwap[index].title,
                        similarlistData.itemsSwap[index].imageUrl,
                        similarlistData.itemsSwap[index].brand,
                        "",
                        similarlistData.itemsSwap[index].veg_type,
                        similarlistData.itemsSwap[index].type,
                        similarlistData.itemsSwap[index].eligible_for_express,
                        similarlistData.itemsSwap[index].delivery,
                        similarlistData.itemsSwap[index].duration,
                        similarlistData.itemsSwap[index].durationType,
                        similarlistData.itemsSwap[index].note,
                        similarlistData.itemsSwap[index].subscribe,
                        similarlistData.itemsSwap[index].paymentmode,
                        similarlistData.itemsSwap[index].cronTime,
                        similarlistData.itemsSwap[index].name,

                      );
                    }),
              ),

            ),
            SizedBox(height: 30,),
            // if(_isWeb)
            //   GestureDetector(
            //     onTap: () {
            //       if (PrefUtils.prefs.getString("skip") == "no") {
            //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
            //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
            //           if (PrefUtils.prefs.containsKey("fromcart")) {
            //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
            //               PrefUtils.prefs.remove("fromcart");
            //               Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
            //                   ModalRoute.withName(CartScreen.routeName));
            //               Navigator.of(context).pushReplacementNamed(
            //                 CartScreen.routeName,
            //               );
            //             } else {
            //               debugPrint("location 9 . . . . .");
            //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            //             }
            //           }else {
            //             debugPrint("location 10 . 2. . . .");
            //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            //           }
            //         }
            //         else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
            //           Navigator.of(context)
            //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
            //             'addresstype': "new",
            //             'addressid': "",
            //           });
            //         }
            //       } else {
            //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
            //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
            //           if (PrefUtils.prefs.containsKey("fromcart")) {
            //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
            //               PrefUtils.prefs.remove("fromcart");
            //               Navigator.of(context).pushNamedAndRemoveUntil(
            //                   MapScreen.routeName,
            //                   ModalRoute.withName(CartScreen.routeName));
            //
            //               Navigator.of(context).pushReplacementNamed(
            //                 CartScreen.routeName,
            //               );
            //             } else {
            //               debugPrint("location 7 . . . . .");
            //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            //             }
            //           } else {
            //             debugPrint("location 8 . . . . .");
            //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            //             /*Navigator.of(context)
            //               .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
            //             "currentBranch": currentBranch
            //           });*/
            //             ///hello
            //           }
            //         } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
            //           Navigator.of(context)
            //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
            //             'addresstype': "new",
            //             'addressid': "",
            //           });
            //         }
            //
            //       }
            //     },
            //     child: Container(
            //       height: 50,
            //       width: double.infinity,
            //       color: Theme.of(context).primaryColor,
            //       child: Center(
            //         child: Text(
            //           S.of(context).confirm,
            //           style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address"))
          ],
        ),
      )
          :
      (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      Flexible(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: new Image.asset(
                    Images.noItemImg, fit: BoxFit.fill,
                    height: 250.0,
                    width: 200.0,
//                    fit: BoxFit.cover
                  ),
                ),
                SizedBox(height: 5,),
                  // if(_isWeb)
                  //   GestureDetector(
                  //     onTap: () {
                  //       if (PrefUtils.prefs.getString("skip") == "no") {
                  //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
                  //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                  //           if (PrefUtils.prefs.containsKey("fromcart")) {
                  //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                  //               PrefUtils.prefs.remove("fromcart");
                  //               Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                  //                   ModalRoute.withName(CartScreen.routeName));
                  //               Navigator.of(context).pushReplacementNamed(
                  //                 CartScreen.routeName,
                  //               );
                  //             } else {
                  //               debugPrint("location 9 . . . . .");
                  //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  //             }
                  //           }else {
                  //             debugPrint("location 10 . 3. . . .");
                  //            // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  //           }
                  //         }
                  //         else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                  //           Navigator.of(context)
                  //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
                  //             'addresstype': "new",
                  //             'addressid': "",
                  //           });
                  //         }
                  //       } else {
                  //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
                  //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                  //           if (PrefUtils.prefs.containsKey("fromcart")) {
                  //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                  //               PrefUtils.prefs.remove("fromcart");
                  //               Navigator.of(context).pushNamedAndRemoveUntil(
                  //                   MapScreen.routeName,
                  //                   ModalRoute.withName(CartScreen.routeName));
                  //
                  //               Navigator.of(context).pushReplacementNamed(
                  //                 CartScreen.routeName,
                  //               );
                  //             } else {
                  //               debugPrint("location 7 . . . . .");
                  //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  //             }
                  //           } else {
                  //             debugPrint("location 8 . . . . .");
                  //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  //             /*Navigator.of(context)
                  //         .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
                  //       "currentBranch": currentBranch
                  //     });*/
                  //             ///hello
                  //           }
                  //         } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                  //           Navigator.of(context)
                  //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
                  //             'addresstype': "new",
                  //             'addressid': "",
                  //           });
                  //         }
                  //
                  //       }
                  //     },
                  //     child: Container(
                  //       height: 50,
                  //       width: double.infinity,
                  //       color: Theme.of(context).primaryColor,
                  //       child: Center(
                  //         child: Text(
                  //           S.of(context).confirm,
                  //           style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address"))
              ],
            ),
          ),
        ),
      ):
      SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: new Image.asset(
                  Images.noItemImg, fit: BoxFit.fill,
                  height: 250.0,
                  width: 200.0,
//                    fit: BoxFit.cover
                ),
              ),
              SizedBox(height: 30,),
              // if(_isWeb)
              //   GestureDetector(
              //     onTap: () {
              //       if (PrefUtils.prefs.getString("skip") == "no") {
              //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
              //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
              //           if (PrefUtils.prefs.containsKey("fromcart")) {
              //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
              //               PrefUtils.prefs.remove("fromcart");
              //               Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
              //                   ModalRoute.withName(CartScreen.routeName));
              //               Navigator.of(context).pushReplacementNamed(
              //                 CartScreen.routeName,
              //               );
              //             } else {
              //               debugPrint("location 9 . . . . .");
              //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              //             }
              //           }else {
              //             debugPrint("location 10 . .4 . . .");
              //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              //           }
              //         }
              //         else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
              //           Navigator.of(context)
              //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
              //             'addresstype': "new",
              //             'addressid': "",
              //           });
              //         }
              //       } else {
              //         if (PrefUtils.prefs.getString("formapscreen") == "" ||
              //             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
              //           if (PrefUtils.prefs.containsKey("fromcart")) {
              //             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
              //               PrefUtils.prefs.remove("fromcart");
              //               Navigator.of(context).pushNamedAndRemoveUntil(
              //                   MapScreen.routeName,
              //                   ModalRoute.withName(CartScreen.routeName));
              //
              //               Navigator.of(context).pushReplacementNamed(
              //                 CartScreen.routeName,
              //               );
              //             } else {
              //               debugPrint("location 7 . . . . .");
              //               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              //             }
              //           } else {
              //             debugPrint("location 8 . . . . .");
              //             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              //             /*Navigator.of(context)
              //             .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
              //           "currentBranch": currentBranch
              //         });*/
              //             ///hello
              //           }
              //         } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
              //           Navigator.of(context)
              //               .pushReplacementNamed(AddressScreen.routeName, arguments: {
              //             'addresstype': "new",
              //             'addressid': "",
              //           });
              //         }
              //
              //       }
              //     },
              //     child: Container(
              //       height: 50,
              //       width: double.infinity,
              //       color: Theme.of(context).primaryColor,
              //       child: Center(
              //         child: Text(
              //           S.of(context).confirm,
              //           style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   ),
              if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address"))
            ],
          ),
        ),
      );
    //  );
    }

    gradientappbarmobile() {
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,

        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color:ColorCodes.menuColor),
            onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              }
        ),
        title: Text(
          S.of(context).Swap_Products,
          style: TextStyle(color: ColorCodes.menuColor),),
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
      );
    }

    _bottomNavigation() {
      return SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            if (PrefUtils.prefs.getString("skip") == "no") {
              if (PrefUtils.prefs.getString("formapscreen") == "" ||
                  PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                if (PrefUtils.prefs.containsKey("fromcart")) {
                  if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                    PrefUtils.prefs.remove("fromcart");
                    Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                        ModalRoute.withName(CartScreen.routeName), arguments: {
                          "after_login": ""
                        });
                    Navigator.of(context).pushReplacementNamed(
                      CartScreen.routeName, arguments: {
                      "after_login": ""
                    }
                    );
                  } else {
                    debugPrint("location 9 . . . . .");
                    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  }
                }else {
                  debugPrint("location 10 . . 5. . .");
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                }
              }
              else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                Navigator.of(context)
                    .pushReplacementNamed(AddressScreen.routeName, arguments: {
                  'addresstype': "new",
                  'addressid': "",
                });
              }
            } else {
                if (PrefUtils.prefs.getString("formapscreen") == "" ||
                    PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                  if (PrefUtils.prefs.containsKey("fromcart")) {
                    if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                      PrefUtils.prefs.remove("fromcart");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MapScreen.routeName,
                          ModalRoute.withName(CartScreen.routeName), arguments: {
                        "after_login": ""
                      });

                      Navigator.of(context).pushReplacementNamed(
                        CartScreen.routeName, arguments: {
                        "after_login": ""
                      }
                      );
                    } else {
                      debugPrint("location 7 . . . . .");
                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    }
                  } else {
                    debugPrint("location 8 . . . . .");
                     Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    /*Navigator.of(context)
                        .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
                      "currentBranch": currentBranch
                    });*/
                    ///hello
                  }
                } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                  Navigator.of(context)
                      .pushReplacementNamed(AddressScreen.routeName, arguments: {
                    'addresstype': "new",
                    'addressid': "",
                  });
                }

            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                S.of(context).confirm,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
        ? gradientappbarmobile()
        : null,

      body: Column(
        children: [
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false, false),
          _bodyMobile(),
        ],
      ),
      bottomNavigationBar: (_isWeb)?SizedBox.shrink():_bottomNavigation(),
    );
  }
}
