import 'dart:io';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';

import '../screens/searchitem_screen.dart';
import '../screens/singleproduct_screen.dart';
import '../screens/wallet_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/footer.dart';

import '../main.dart';
import '../screens/home_screen.dart';
import '../screens/not_product_screen.dart';
import '../screens/not_subcategory_screen.dart';
import '../screens/orderhistory_screen.dart';
import '../providers/notificationitems.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../data/calculations.dart';
import '../data/hiveDB.dart';
import '../screens/not_brand_screen.dart';
import '../widgets/badge.dart';
import 'cart_screen.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification-screen';
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isNotification = true;
  bool _isWeb = false;
  ScrollController _controller = new ScrollController();
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool _isLoading = true;
  var notificationData;

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
      Provider.of<NotificationItemsList>(context, listen: false).fetchNotificationLogs(PrefUtils.prefs.getString('apikey')).then((_) {
        setState(() {
          notificationData = Provider.of<NotificationItemsList>(context, listen: false);
          _isLoading = false;
          if (notificationData.notItems.length <= 0) {
            _isNotification = false;
          } else {
            _isNotification = true;
          }
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: ColorCodes.whiteColor,
      body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            _isLoading ? Center(
                child: LoyalityorWalletShimmer()
            )
                :
            _body(),
          ]
      ),
    );
  }
  _body() {
    return _isWeb ? _bodyweb() :
    _bodyMobile();
  }
  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
          onPressed: () => Navigator.of(context).pop()),
      title: Text(
        S.of(context).notification,//'Notification',
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
      actions:<Widget> [
        Container(
          height: 25,
          width: 25,
          margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SearchitemScreen.routeName,);
            },
            child: Icon(
              Icons.search,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        /* SizedBox(
          width: 5,
        ),*/
        ValueListenableBuilder(
          valueListenable: Hive.box<Product>(productBoxName).listenable(),
          builder: (context, Box<Product> box, index) {
            if (box.values.isEmpty)
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                    "after_login": ""
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                  width: 26,
                  height: 28,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    // color: Theme.of(context).buttonColor
                  ),

                  child:
                  Image.asset(
                    Images.header_cart,
                    height: 28,
                    width: 28,
                    color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                  ),
                  // Icon(
                  //   Icons.shopping_cart_outlined,
                  //   size: 17,
                  //   color: Colors.white,
                  // ),
                ),
              );

            int cartCount = 0;
            for (int i = 0;
            i < Hive.box<Product>(productBoxName).length;
            i++) {
              cartCount = cartCount +
                  Hive.box<Product>(productBoxName)
                      .values
                      .elementAt(i)
                      .itemQty;
            }
            return Consumer<CartCalculations>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                color: ColorCodes.darkgreen,
                value: cartCount.toString(),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                    "after_login": ""
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                  width: 26,
                  height: 28,
                  decoration: BoxDecoration(
                    //  color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    // color: Theme.of(context).buttonColor
                  ),
                  child:
                  Image.asset(
                    Images.header_cart,
                    height: 28,
                    width: 28,
                    color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                  ),

                  // Icon(
                  //   Icons.shopping_cart_outlined,
                  //   size: 17,
                  //     color: Colors.white,
                  // ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10),
      ],
    );

  }
  Widget _bodyweb() {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    return !_isNotification
        ?    Flexible(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 80.0, right: 80.0),
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    child: new Image.asset(
                        Images.notificationImg)),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  S.of(context).dont_have_any_notification,// "Don't have any item in the notification list",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                  },
                  child: Container(
                    width: 110.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Center(
                        child: Text(
                          S.of(context).go_to_home,  //'Go To Home',
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Colors.white, fontSize: 16.0),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs.getString("restaurant_address"))
            ],
          ),
        ),
      ),
    )
        : Expanded(
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,

                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    itemCount: notificationData.notItems.length,
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () {
                        if (notificationData
                            .notItems[i].notificationFor ==
                            "2")
                        {

                          print("for order history....");
                          // Order and fetching order id
                          Navigator.of(context).pushNamed(
                              OrderhistoryScreen.routeName,
                              arguments: {
                                'orderid': notificationData.notItems[i].data,
                                'fromScreen': "pushNotificationScreen",
                                'notificationId': notificationData.notItems[i].id,
                                'notificationStatus': notificationData.notItems[i].status
                              });
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "3") {
                          //Web Link
                          //custom link
                          String url = notificationData.notItems[i].data;
                          if (canLaunch(url) != null)
                            launch(url);
                          else
                            // can't launch url, there is some error
                            throw "Could not launch $url";
                          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id.toString(), "1" );
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "4") {

                          //Product with array of product id (Then have to call api)
                          Navigator.of(context).pushNamed(
                              NotProductScreen.routeName,
                              arguments: {
                                'productId': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "5") {
                          //Sub category with array of sub category
                          Navigator.of(context).pushNamed(NotSubcategoryScreen.routeName,
                              arguments: {
                                'subcategoryId' : notificationData.notItems[i].data,
                                'fromScreen' : "NotificationScreen",
                                'notificationId' : notificationData.notItems[i].id,
                                'notificationStatus': notificationData.notItems[i].status,

                              }
                          );
                        } else if (notificationData.notItems[i].notificationFor == "6") {
                          //redirect to app home page
                          if (notificationData.notItems[i].status == "0")
                            Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                          Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "3") {
                          //Web Link
                        }
                        else if (notificationData
                            .notItems[i].notificationFor ==
                            "4") {
                          //Product with array of product id (Then have to call api)
                          Navigator.of(context).pushNamed(
                              NotProductScreen.routeName,
                              arguments: {
                                'productId': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "5") {
                          //Sub category with array of sub category
                          Navigator.of(context).pushNamed(
                              NotSubcategoryScreen.routeName,
                              arguments: {
                                'subcategoryId': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });
                        } else if (notificationData.notItems[i].notificationFor == "6") {
                          //redirect to app home page
                          if (notificationData.notItems[i].status == "0")
                            Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                          Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                        } else if(notificationData.notItems[i].notificationFor == "10") {
                          Navigator.of(context).pushReplacementNamed(NotBrandScreen.routeName,
                              arguments: {
                                'brandsId' : notificationData.notItems[i].data,
                                'fromScreen' : "NotificationScreen",
                                'notificationId' : notificationData.notItems[i].id,
                                'notificationStatus': notificationData.notItems[i].status
                              }
                          );
                        }
                        else if (notificationData
                            .notItems[i].notificationFor ==
                            "13")
                        {
                          if(notificationData.notItems[i].status == "0") {
                            Provider.of<NotificationItemsList>(context, listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                            Provider.of<NotificationItemsList>(context, listen: false).fetchNotificationLogs(PrefUtils.prefs.getString('apikey'));
                          }

                        }

                        else if(notificationData.notItems[i].notificationFor == "12")
                        {
                          if(notificationData.notItems[i].status == "0") {
                            Provider.of<NotificationItemsList>(context, listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                            Provider.of<NotificationItemsList>(context, listen: false).fetchNotificationLogs(PrefUtils.prefs.getString('apikey'));
                          }
                          Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                              arguments: {
                                'type' : "wallet",
                                'fromScreen': "notification",
                              }
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 10.0,bottom:8.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(color: Colors.white, borderRadius:BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                            border: Border.all(
                                width: 2,
                                color: ColorCodes.lightBlueColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CircleAvatar(
                            //     radius: 12, backgroundColor: Colors.transparent,
                            //     child: Image.asset('assets/images/icon_android.png')),
                            SizedBox(width: 5),
                            if(notificationData.notItems[i].status == "0")
                              Text(notificationData.notItems[i].message, style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                            if(notificationData.notItems[i].status == "1")
                              Text(notificationData.notItems[i].message, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.black),),
                            SizedBox(height: 5.0,),
                            Text(
                              notificationData
                                  .notItems[i].dateTime,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),),
                          ],
                        ),
                      ),
                      // child: Container(
                      //   height: 80,
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 20, vertical: 5),
                      //   margin: EdgeInsets.fromLTRB(20, 10, 40, 5),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(15),
                      //           topRight: Radius.circular(15),
                      //           bottomRight: Radius.circular(15)),
                      //       border: Border.all(
                      //           width: 2,
                      //           color: ColorCodes.lightBlueColor)),
                      //   child: Column(
                      //     mainAxisAlignment:
                      //         MainAxisAlignment.center,
                      //     crossAxisAlignment:
                      //         CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         notificationData.notItems[i].message,
                      //         style: TextStyle(
                      //             fontSize: 15.0,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.black),
                      //       ),
                      //       SizedBox(height: 5),
                      //       Text(
                      //         notificationData
                      //             .notItems[i].dateTime,
                      //         style: TextStyle(
                      //           fontSize: 12.0,
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.grey,
                      //         ),),
                      //         SizedBox(height: 5),
                      //         Text(
                      //           notificationData
                      //               .notItems[i].dateTime,
                      //           style: TextStyle(
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.w500,
                      //             color: Colors.grey,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs.getString("restaurant_address"))
            ],

          )),
    );}
  Widget _bodyMobile() {
    final notificationData = Provider.of<NotificationItemsList>(context,listen: false);
    if (notificationData.notItems.length <= 0) {
      _isNotification = false;
    } else {
      _isNotification = true;
    }
    return !_isNotification
        ?         Expanded(
      child: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
              Align(
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 80.0, right: 80.0),
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    child: new Image.asset(
                        Images.notificationImg)),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  S.of(context).dont_have_any_notification,//"Don't have any item in the notification list",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  print("mode ......");
                  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));

                },
                child: Container(
                  width: 110.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Center(
                      child: Text(
                        S.of(context).go_to_home,//'Go To Home',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(color: Colors.white, fontSize: 16.0),
                      )),
                ),
              ),
              SizedBox(height: 20.0,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs.getString("restaurant_address"))
            ],
          ),
        ),
      ),
    )
        : Expanded(
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    itemCount: notificationData.notItems.length,
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () {

                        print("mode 2......"+notificationData.notItems[i].notificationFor.toString());
                        if (notificationData.notItems[i].notificationFor == "2")

                        {

                          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                          // Order and fetching order id
                          Navigator.of(context).pushReplacementNamed(
                              OrderhistoryScreen.routeName,
                              arguments: {
                                'orderid': notificationData.notItems[i].data.toString(),
                                'fromScreen': "pushNotificationScreen",
                                'notificationId': notificationData.notItems[i].id.toString(),
                                'notificationStatus': notificationData.notItems[i].status.toString()
                              });
                          /* Navigator.of(context).pushNamed(
                              OrderhistoryScreen.routeName,
                              arguments: {
                                'orderid': notificationData
                                    .notItems[i].data,
                                'fromScreen':
                                "pushNotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });*/
                        } else if (notificationData.notItems[i].notificationFor == "3") {
                          print("mode 3......"+notificationData.notItems[i].notificationFor == "3".toString());
                          //Web Link
                          //custom link
                          String url = notificationData.notItems[i].data;
                          if (canLaunch(url) != null)
                            launch(url);
                          else
                            // can't launch url, there is some error
                            throw "Could not launch $url";
                          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id.toString(), "1" );
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "4") {
                          print("mode 4......"+notificationData
                              .notItems[i].notificationFor ==
                              "4".toString());

                          //Product with array of product id (Then have to call api)
                          Navigator.of(context).pushReplacementNamed(
                              NotProductScreen.routeName,
                              arguments: {
                                'productId': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "5") {
                          print("mode 5......"+notificationData
                              .notItems[i].notificationFor ==
                              "5".toString());
                          //Sub category with array of sub category
                          Navigator.of(context).pushReplacementNamed(NotSubcategoryScreen.routeName,
                              arguments: {
                                'subcategoryId' : notificationData.notItems[i].data,
                                'fromScreen' : "NotificationScreen",
                                'notificationId' : notificationData.notItems[i].id,
                                'notificationStatus': notificationData.notItems[i].status,

                              }
                          );
                        } else if (notificationData.notItems[i].notificationFor == "6") {
                          print("mode 6......"+notificationData
                              .notItems[i].notificationFor ==
                              "6".toString());
                          //redirect to app home page
                          if (notificationData.notItems[i].status == "0")
                            Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                          Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "3") {
                          //Web Link
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "4") {
                          //Product with array of product id (Then have to call api)
                          Navigator.of(context).pushReplacementNamed(
                              NotProductScreen.routeName,
                              arguments: {
                                'productId': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });
                        } else if (notificationData
                            .notItems[i].notificationFor ==
                            "5") {
                          //Sub category with array of sub category
                          Navigator.of(context).pushReplacementNamed(
                              NotSubcategoryScreen.routeName,
                              arguments: {
                                'subcategoryId': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData
                                    .notItems[i].status
                              });
                        } else if (notificationData.notItems[i].notificationFor == "6") {
                          //redirect to app home page
                          if (notificationData.notItems[i].status == "0")
                            Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                          Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                        } else if(notificationData.notItems[i].notificationFor == "10") {
                          Navigator.of(context).pushReplacementNamed(NotBrandScreen.routeName,
                              arguments: {
                                'brandsId' : notificationData.notItems[i].data,
                                'fromScreen' : "NotificationScreen",
                                'notificationId' : notificationData.notItems[i].id,
                                'notificationStatus': notificationData.notItems[i].status
                              }
                          );
                        }
                        else if (notificationData
                            .notItems[i].notificationFor ==
                            "13") {
                          if(notificationData.notItems[i].status == "0") {
                            Provider.of<NotificationItemsList>(context, listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                            Provider.of<NotificationItemsList>(context, listen: false).fetchNotificationLogs(PrefUtils.prefs.getString('apikey'));
                          }
                          {
                            Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                                arguments: {
                                  'type' : "loyalty",
                                  'fromScreen': "notification",

                                }
                            );
                          }
                        }


                        else if (notificationData
                            .notItems[i].notificationFor ==
                            "14") {
                          print("single.....product");
                          //Product with array of product id (Then have to call api)
                          Navigator.of(context).pushNamed(
                              SingleproductScreen.routeName,
                              arguments: {
                                'itemid': notificationData
                                    .notItems[i].data,
                                'fromScreen': "NotificationScreen",
                                'notificationId':
                                notificationData.notItems[i].id,
                                'notificationStatus':
                                notificationData.notItems[i].status,
                                'notificationFor': '14',
                              });
                        }
                        else if(notificationData.notItems[i].notificationFor == "12") {
                          if(notificationData.notItems[i].status == "0") {
                            Provider.of<NotificationItemsList>(context, listen: false).updateNotificationStatus(notificationData.notItems[i].id, "1");
                            Provider.of<NotificationItemsList>(context, listen: false).fetchNotificationLogs(PrefUtils.prefs.getString('apikey'));
                          }
                          Navigator.of(context).pushNamed(WalletScreen.routeName,
                              arguments: {
                                'type' : "wallet",
                                'fromScreen': "notification",
                              }
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 10.0,bottom:8.0),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 15.0),
                        decoration: BoxDecoration(color: (notificationData.notItems[i].status == "0") ? ColorCodes.mediumgren : ColorCodes.whiteColor,
                            /*borderRadius:BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),*/
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                width: (notificationData.notItems[i].status == "0")?0 :1,
                                color: (notificationData.notItems[i].status == "0")? ColorCodes.mediumgren :ColorCodes.lightGreyWebColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CircleAvatar(
                            //     radius: 12, backgroundColor: Colors.transparent,
                            //     child: Image.asset('assets/images/icon_android.png')),
                            SizedBox(width: 10),
                           // if(notificationData.notItems[i].status == "0")
                              Text(notificationData.notItems[i].message, style: TextStyle(fontSize: 18.0,
                                  color: ColorCodes.greenColor,fontWeight: FontWeight.bold,),),
                           // if(notificationData.notItems[i].status == "1")
                          //    Text(notificationData.notItems[i].message, style: TextStyle(fontSize: 18.0, color: Colors.grey),),
                            SizedBox(height: 5.0,),
                            Text(
                              notificationData
                                  .notItems[i].dateTime,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs.getString("restaurant_address"))
            ],

          )),
    );}

}
