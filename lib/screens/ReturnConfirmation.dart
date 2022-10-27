import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
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

class ReturnconfirmationScreen extends StatefulWidget {
  static const routeName = '/returnconfirmation-screen';

  @override
  ReturnconfirmationScreenState createState() => ReturnconfirmationScreenState();
}

class ReturnconfirmationScreenState extends State<ReturnconfirmationScreen> {
  bool _isOrderstatus = true;
  bool _isLoading = false;
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

    productBox = (VxState.store as GroceStore).CartItemList;
    _bloc = HomeDisplayBloc();

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

        name = store.userData.username;
      });


      final routeArgs = ModalRoute
          .of(context)
          .settings
          .arguments as Map<String, String>;

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () { // this is the block you need

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home-screen', (Route<dynamic> route) => false);
        return Future.value(false);
      },
      child: Scaffold(
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
    final routeArgs =
    ModalRoute.of(context).settings.arguments as Map<String, String>;
    return _isLoading ?
    Center(
      child: OrderConfirmationShimmer(),//CircularProgressIndicator(),
    )
        :
    Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      color: ColorCodes.discountoff,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*_isOrderstatus ?*/
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Icon(
                                  Icons.check_circle, color: ColorCodes.whiteColor, size: 50,),
                              ),
                            ),
                               /* :
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                              ),
                            ),*/
                            SizedBox(height: 10),
                            Text(
                              S.of(context).hi//'Thank You for Choosing '
                                  + name + ',',
                              style: TextStyle(fontSize: 19.0, color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 15),
                            Text(
                             routeArgs['title']+ " Request Confirmed!",//'Thank You for Choosing ',
                              style: TextStyle(fontSize: 24.0, color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Items will be picked up by ",//'Thank You for Choosing ',
                              style: TextStyle(fontSize: 14.0, color: ColorCodes.whiteColor, fontWeight: FontWeight.w400),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                Text(
                                  routeArgs['title'].toUpperCase()+" ID" + ":" ,
                                  style: TextStyle(fontSize: 16 , color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              //  SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorCodes.grey.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(7.0),topRight:Radius.circular(7.0) ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Please check your email for the further details.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: ColorCodes.blackColor),
                        ),
                      ),
                      (routeArgs['title'] == "Return")? Image.asset(
                        Images.returnconfirm,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ):Image.asset(
                        Images.returnconfirm,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Explore the latest trends in fashion", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: ColorCodes.blackColor)),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                              "Continue Shopping",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: ColorCodes.discountoff),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),

                if(_isWeb && !ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
              ]
          ),
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
