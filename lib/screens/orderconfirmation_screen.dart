import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../providers/sellingitems.dart';
import '../../screens/bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/images.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../providers/branditems.dart';
import '../screens/orderhistory_screen.dart';
import '../widgets/simmers/orderconfirmation_shimmer.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../assets/ColorCodes.dart';
import '../screens/home_screen.dart';
import '../constants/IConstants.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../widgets/footer.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../utils/prefUtils.dart';
import '../providers/cartItems.dart';

class OrderconfirmationScreen extends StatefulWidget {
  static const routeName = '/orderconfirmation-screen';

  @override
  OrderconfirmationScreenState createState() => OrderconfirmationScreenState();
}

class OrderconfirmationScreenState extends State<OrderconfirmationScreen> {
  bool _isOrderstatus = true;
  bool _isLoading = true;
  bool _isWeb = false;
  var _address = "";
  double wid;
  double maxwid;
  var orderid;
  MediaQueryData queryData;
  bool iphonex = false;
  String referalCode = "";
  Uri dynamicUrl;
  var name = "";
  double amount = 0.00;
  //Box<Product> productBox;
  List<CartItem> productBox=[];
  HomeDisplayBloc _bloc;
  GroceStore store = VxState.store;
  @override
  void initState() {
    //Hive.openBox<Product>(productBoxName);
    productBox = /*Hive.box<Product>(productBoxName)*/(VxState.store as GroceStore).CartItemList;
    _bloc = HomeDisplayBloc();
    /*try {
      if (Platform.isIOS || Platform.isAndroid) {
        final document = await getApplicationDocumentsDirectory();
        Hive.init(document.path);
        Hive.registerAdapter(ProductAdapter());
        Hive.openBox<Product>(productBoxName);

      }
    } catch (e) {
      Hive.registerAdapter(ProductAdapter());
      Hive.openBox<Product>(productBoxName);
    }*/


    PrefUtils.prefs.remove("subscriptionorderId");
    Future.delayed(Duration.zero, () async {
      // debugPrint("membership....41  "+PrefUtils.prefs.getString("membership"));
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
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
      setState(() {
       /* if (PrefUtils.prefs.getString('FirstName') != null) {
          if (PrefUtils.prefs.getString('LastName') != null) {
            name = PrefUtils.prefs.getString('FirstName') +
                " " +
                PrefUtils.prefs.getString('LastName');
          } else {
            name = PrefUtils.prefs.getString('FirstName');
          }
        } else {
          name = "";
        }*/
        name = store.userData.username;
      });

      referalCode= PrefUtils.prefs.getString('myreffer');
      //orderid =  PrefUtils.prefs.getString("orderId");


      var referData;
      Provider.of<BrandItemsList>(context,listen: false).ReferEarn().then((_) async {
        referData = await Provider.of<BrandItemsList>(context, listen: false);
        setState(() {
          amount = double.parse(referData.referEarn.amount);
        });

        debugPrint("amount...order"+amount.toString());
      });
      final routeArgs = ModalRoute
          .of(context)
          .settings
          .arguments as Map<String, String>;

      final orderstatus = routeArgs['orderstatus'];
      orderid = routeArgs['orderid'];
      if(orderstatus == "success"){
        //  debugPrint("membership....42  "+PrefUtils.prefs.getString("membership"));
        /* setState(() {
          _isOrderstatus = true;
          _isLoading = false;
        });*/

         cartcontroller.clear((value) {
           if(value){
             setState(() {
               _isOrderstatus = true;
               _isLoading = false;
             });
           }
         });
    /*    await Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
          // debugPrint("membership....43  "+PrefUtils.prefs.getString("membership"));
          Hive.box<Product>(productBoxName).clear();
          //debugPrint("membership....50  "+PrefUtils.prefs.getString("membership"));
          setState(() {
            _isOrderstatus = true;
            _isLoading = false;
          });
        });*/
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          sellingitemData.featuredVariation[i].varQty = 0;
        }

        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          sellingitemData.itemspricevarOffer[i].varQty = 0;
          break;
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          sellingitemData.itemspricevarSwap[i].varQty = 0;
          break;
        }

        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          sellingitemData.discountedVariation[i].varQty = 0;
          break;
        }

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          cartItemsData.items[i].itemQty = 0;
        }

      } else {
        // debugPrint("membership....44  "+PrefUtils.prefs.getString("membership"));
        for(int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1"){
            PrefUtils.prefs.setString("membership", "0");
          }
        }
        /* Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
          //Hive.box<Product>(productBoxName).deleteFromDisk();
          Hive.box<Product>(productBoxName).clear();
          final orderId = routeArgs['orderId'];
          paymentStatus(orderId);
        });*/
        final orderId = routeArgs['orderId'];
        paymentStatus(orderId);
      }

      // debugPrint("membership....51  "+PrefUtils.prefs.getString("membership"));
      createReferralLink(referalCode);
      // debugPrint("membership....50  "+PrefUtils.prefs.getString("membership"));


    });
    // debugPrint("membership....2  "+PrefUtils.prefs.getString("membership"));
    super.initState();
  }

  Future<String> createReferralLink(String referralCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: 'https://denimers.page.link',
        link: Uri.parse('https://referandearn.com/refer?code=$referralCode'),
        androidParameters: AndroidParameters(
          packageName: IConstants.androidId,
        ),
        iosParameters: IosParameters(
            bundleId: IConstants.androidId,
            appStoreId: IConstants.appleId
        )
      /* socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Refer A Friend',
        description: 'Refer and earn',
        imageUrl: Uri.parse(
            'https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),*/
    );

    final ShortDynamicLink shortLink =
    await dynamicLinkParameters.buildShortLink();
    dynamicUrl = shortLink.shortUrl;
    return dynamicUrl.toString();
  }

  Future<void> paymentStatus(String orderId) async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(
          Api.getOrderStatus,
          body: { // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs.getString('branch'),
          }
      );
      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "yes") {
        PrefUtils.prefs.remove("orderId");
        for(int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1"){
            PrefUtils.prefs.setString("membership", "2");
          }
        }
        cartcontroller.clear((value) {
          if(value){
            setState(() {
              _isOrderstatus = true;
              _isLoading = false;
            });
          }
        });
      /*  Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
          Hive.box<Product>(productBoxName).clear();
          setState(() {
            _isOrderstatus = true;
            _isLoading = false;
          });
        });*/
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          sellingitemData.featuredVariation[i].varQty = 0;
        }

        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          sellingitemData.itemspricevarOffer[i].varQty = 0;
          break;
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          sellingitemData.itemspricevarSwap[i].varQty = 0;
          break;
        }

        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          sellingitemData.discountedVariation[i].varQty = 0;
          break;
        }

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          cartItemsData.items[i].itemQty = 0;
        }

      } else {
        for(int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1"){
            PrefUtils.prefs.setString("membership", "0");
          }
        }
        setState(() {
          _isOrderstatus = false;
          _isLoading = false;
        });
        /*Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
          Hive.box<Product>(productBoxName).clear();
          setState(() {
            _isOrderstatus = false;
            _isLoading = false;
          });
        });*/
      }
/*      if(responseJson['status'].toString() == "200") {
        if(status == "paid") {
          Navigator.of(context).pushReplacementNamed(
              OrderconfirmationScreen.routeName,
              arguments: {
                'orderstatus' : "success",
              }
          );
        } else {
          Navigator.of(context).pushReplacementNamed(
              OrderconfirmationScreen.routeName,
              arguments: {
                'orderstatus' : "failure",
              }
          );
        }
      } else {
      }*/

    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: ColorCodes.discountoff,
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () { // this is the block you need
        //Hive.openBox<Product>(productBoxName);
        // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home-screen', (Route<dynamic> route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        /*  appBar: ResponsiveLayout.isSmallScreen(context) ?
            gradientappbarmobile() : null,*/
        backgroundColor: Color(0xffF3F3F3),

        body:SafeArea(
          child: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false, false),
              _body(),
            ],
          ),
        ),

      ),
    );
  }
  _body(){
    return _isWeb?_bodyweb():
    _bodymobile();
  }
  _bodymobile() {

    debugPrint("doble amount...."+amount.toString());
    return _isLoading ?
    Center(
      child: OrderConfirmationShimmer(),//CircularProgressIndicator(),
    )
        :
    Expanded(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  /*Container(
                  //  color: ColorCodes.discountoff,
                    child: Image.asset(Images.orderconfirm,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.85)
                  ),*/

                  Container(
                    color: ColorCodes.discountoff,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isOrderstatus ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.check_circle, color: ColorCodes.whiteColor, size: 50,),
                            ),
                          )
                              :
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            S.of(context).hi//'Thank You for Choosing '
                                + name + ',',
                            style: TextStyle(fontSize: 19.0, color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Your Order has been placed Successfully!",//'Thank You for Choosing ',
                            style: TextStyle(fontSize: 24.0, color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                S.of(context).order + "#" +orderid,
                                style: TextStyle(fontSize: 16 , color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          // debugPrint("membership....40  "+PrefUtils.prefs.getString("membership"));
                          _isWeb?
                          Navigator.of(context).pushNamed(
                              OrderhistoryScreen.routeName,
                              arguments: {
                                'orderid': orderid.toString(),
                                "fromScreen" : "weborderConfirmation",
                                // 'orderStatus':widget.ostatus,

                              })
                          :
                          Navigator.of(context).pushNamed(
                              OrderhistoryScreen.routeName,
                              arguments: {
                                'orderid': orderid.toString(),
                                "fromScreen" : "orderConfirmation",
                                // 'orderStatus':widget.ostatus,

                              });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width ,
                          // height: 32,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              width: 1.0,
                              color: ColorCodes.discountoff,
                            ),
                          ),
                          child: Text(
                            S.of(context).view_details,//"LOGIN USING OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: ColorCodes.discountoff),
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(Images.nowishlistfound,
                          height: 250,),
                          SizedBox(height: 15,),
                          Text("Thank You for shipping with us",
                            //"You have no past orders",
                            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: ColorCodes.darkGrey),),
                        ],
                      ),



                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              if(Features.isReferEarn)
                (amount > 0)?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(Images.gift, height: 100.0, width: 50.0),
                        Text(S.of(context).share_get + IConstants.currencyFormat + amount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(height:8),
                        Text(S.of(context).inwallet_invite_friends + IConstants.APP_NAME + S.of(context).with_unique_referal ,
                            textAlign: TextAlign.center),
                        // Text(S.of(context).with_unique_referal ,
                        //     textAlign: TextAlign.center),
                        SizedBox(height:10),
                        GestureDetector(
                          onTap: (){
                            Share.share('Download ' +
                                IConstants.APP_NAME +
                                ' from Google Play Store and use my referral code ('+ referalCode +')'+" "+dynamicUrl.toString());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width ,
                            // height: 32,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorCodes.greenColor,
                              ),
                            ),
                            child: Text(
                              S.of(context).share_now,//"LOGIN USING OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: ColorCodes.greenColor),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ):
                SizedBox.shrink(),

              if(_isWeb && !ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
            ]
        ),
      ),

    );
  }
  _bodyweb() {

    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return  _isLoading ?
    Center(
      child: OrderConfirmationShimmer(),//CircularProgressIndicator(),
    )
        :
    Expanded(

      child: SingleChildScrollView(

        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(


                  height:MediaQuery.of(context).size.height/2,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  color: ColorCodes.ordergreen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isOrderstatus ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.check_circle, color: ColorCodes.whiteColor, size: 50,),
                          ),
                        )
                            :
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          S.of(context).hi//'Thank You for Choosing '
                              + name + ',',
                          style: TextStyle(fontSize: 20.0, color: ColorCodes.whiteColor),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        Text(
                          S.of(context).thanks_choosing_confirm//'Thank You for Choosing '
                              + IConstants.APP_NAME + '.',
                          style: TextStyle(fontSize: 25.0, color: ColorCodes.whiteColor),
                          // textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              S.of(context).order + "#" +orderid,
                              style: TextStyle(fontSize: 16 , color: ColorCodes.whiteColor),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed(
                                OrderhistoryScreen.routeName,
                                arguments: {
                                  'orderid': orderid.toString(),
                                  // 'orderStatus':widget.ostatus,

                                });
                          },
                          child: Container(
                            width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // height: 32,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorCodes.discountoff,
                              ),
                            ),
                            child: Text(
                              S.of(context).view_details,//"LOGIN USING OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: ColorCodes.discountoff),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                if(Features.isReferEarn)
                  if(amount > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // children: [
                          //   Image.asset(Images.gift, height: 100.0, width: 50.0),
                          //   Text(S.of(context).share_get + IConstants.currencyFormat + amount.toString(),
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          //   SizedBox(height:8),
                          //   Text(S.of(context).inwallet_invite_friends + IConstants.APP_NAME + S.of(context).with_unique_referal ,
                          //       textAlign: TextAlign.center),
                          //   // Text(S.of(context).with_unique_referal ,
                          //   //     textAlign: TextAlign.center),
                          //   SizedBox(height:10),
                          //   GestureDetector(
                          //     onTap: (){
                          //       Share.share('Download ' +
                          //           IConstants.APP_NAME +
                          //           ' from Google Play Store and use my referral code ('+ referalCode +')'+" "+dynamicUrl.toString());
                          //     },
                          //     child: Container(
                          //       width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                          //       // height: 32,
                          //       padding: EdgeInsets.all(15.0),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(5.0),
                          //         border: Border.all(
                          //           width: 1.0,
                          //           color: ColorCodes.greenColor,
                          //         ),
                          //       ),
                          //       child: Text(
                          //         S.of(context).share_now,//"LOGIN USING OTP",
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 15.0,
                          //             color: ColorCodes.greenColor),
                          //       ),
                          //     ),
                          //   ),
                          //
                          //
                          // ],
                        ),
                      ),
                    ),

                if(_isWeb && !ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
              ]
          ),
        ),
      ),

    );
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,

      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        });
      } ),
      title: Text(
        S.of(context).order_confirmation,
        //'Order Confirmation',
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
                ]
            )
        ),
      ),
    );
  }

}
