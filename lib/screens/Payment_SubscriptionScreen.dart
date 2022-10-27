import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/bottom_navigation.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../screens/subscription_confirm_screen.dart';
import '../controller/payment/payment_contoller.dart';
import '../screens/subscribe_screen.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import 'package:package_info/package_info.dart';


import '../utils/ResponsiveLayout.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';

class PaymenSubscriptionScreen extends StatefulWidget {
  static const routeName = '/payment-subscriptionscreen';
  @override
  _PaymenSubscriptionScreenState createState() => _PaymenSubscriptionScreenState();
}

class _PaymenSubscriptionScreenState extends State<PaymenSubscriptionScreen> {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  int _groupValue = -1;
  var walletbalance = "0";
  bool checked = false;

  bool disable = false;
  bool _isWeb = false;

  PackageInfo packageInfo;
  bool iphonex = false;
  var addressid ;
  var useraddtype ;
  var startDate ;
  var endDate ;
  var itemCount ;
  var deliveries ;
  var total ;

  var schedule ;
  var itemid ;
  var itemimg ;
  var itemname ;
  var varprice ;
  var varname ;
  var address ;
  var paymentMode ;
  var cronTime ;
  var name ;
  var varid ;
  var varmrp ;
 var weeklist;
 var no_of_days;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
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
      _initial();
      packageInfo = await PackageInfo.fromPlatform();

    });
    super.initState();

  }
  void _initial() {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    //walletbalance = PrefUtils.prefs.getString("wallet_balance"); //user wallet balance
    if (double.parse(walletbalance) >= double.parse(routeArgs['total'])) {
      disable = true;
    } else {
      disable = false;
    }




  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    payment.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

    addressid = routeArgs['addressid'].toString();
    useraddtype = routeArgs['useraddtype'].toString();
    startDate = routeArgs['startDate'].toString();
    endDate = routeArgs['endDate'].toString();
    itemCount = routeArgs['itemCount'].toString();
    deliveries =  routeArgs['deliveries'].toString();
    total = (double.parse(routeArgs['total']) - double.parse(walletbalance)).toString();

    schedule =  routeArgs['schedule'];
    itemid = routeArgs['itemid'].toString();
    itemimg = routeArgs['itemimg'].toString();
    itemname = routeArgs['itemname'].toString();
    varprice = routeArgs['varprice'].toString();
    varname = routeArgs['varname'].toString();
    address = routeArgs['address'].toString();
    paymentMode = routeArgs['paymentMode'].toString();
    cronTime = routeArgs['cronTime'].toString();
    name = routeArgs['name'].toString();
    varid = routeArgs['varid'].toString();
    varmrp = routeArgs['varmrp'].toString();
    weeklist = routeArgs['weeklist'].toString();
    no_of_days = routeArgs['no_of_days'].toString();
    _dialogforOrdering() {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AbsorbPointer(
                child: WillPopScope(
                  onWillPop: (){
                    return Future.value(false);
                  },
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Container(
                        width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
                        // color: Theme.of(context).primaryColor,
                        height: 100.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(
                                S.of(context).placing_order,//'Placing order...'
                            ),
                          ],
                        )),
                  ),
                ),
              );
            });
          });
    }

    _buildBottomNavigationBar() {
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      return  BottomNaviagation(
        itemCount: "1" + " " + S.of(context).items,
        title: S.current.proceed_pay, //'PROCEED TO PAY',
        total: double.parse(routeArgs['total'].toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          setState(() {
            if(_groupValue == -1) {
              Fluttertoast.showToast(
                msg:
                S.of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                fontSize: MediaQuery
                    .of(context)
                    .textScaleFactor * 13,);
            }else {
              _dialogforOrdering();
              CreateSubscription();
            }
          });
        },
      );
        // Container(
        // width: MediaQuery.of(context).size.width,
        // height: 54.0,
        // child: Row(
        //   children: <Widget>[
        //     Container (
        //         color: Theme.of(context).primaryColor,
        //         height: 54,
        //         width: MediaQuery.of(context).size.width * 40 / 100,
        //         child: Column(
        //           children: <Widget>[
        //             SizedBox(
        //               height: 15,
        //             ),
        //             Center(
        //               child: Text(
        //                   S.of(context).grand_total//"Grand Total: "
        //                           + IConstants.currencyFormat +
        //                           " "+double.parse(routeArgs['total'].toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) ,
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),
        //                       textAlign: TextAlign.center))
        //               ]),
        //             ),
        //     GestureDetector(
        //       onTap: (){
        //         if(_groupValue == -1) {
        //           Fluttertoast.showToast(
        //             msg:
        //             S.of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
        //             fontSize: MediaQuery
        //               .of(context)
        //               .textScaleFactor * 13,);
        //         }else {
        //             _dialogforOrdering();
        //             /*Navigator.of(context).pushNamed(
        //                 SubscriptionWalletScreen.routeName,
        //                 arguments: {
        //
        //                   "addressid":addressid.toString(),
        //                   "useraddtype": useraddtype.toString(),
        //                   "startDate":startDate.toString(),
        //                   "endDate": endDate.toString(),
        //                   "itemCount": itemCount.toString(),
        //                   "deliveries": deliveries.toString(),
        //                   "total": (double.parse(routeArgs['total']) - walletbalance).toString(),
        //                   "subscriptionAmount": routeArgs['total'].toString(),
        //                   //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
        //                   "schedule": schedule.toString(),
        //                   "itemid": itemid.toString(),
        //                   "itemimg": itemimg.toString(),
        //                   "itemname": itemname.toString(),
        //                   "varprice": varprice.toString(),
        //                   "varname": varname.toString(),
        //                   "address": address.toString(),
        //                   "paymentMode": paymentMode.toString(),
        //                   "cronTime": cronTime.toString(),
        //                   "name": name.toString(),
        //                   "varid": varid.toString(),
        //                   "varmrp": varmrp.toString(),
        //
        //                 }
        //             );*/
        //
        //           CreateSubscription();
        //         }
        //
        //      /*   if(_groupValue == -1) {
        //           Fluttertoast.showToast(
        //             msg:
        //             S.of(context).please_select_paymentmenthods//"Please select a payment method!!!"
        //             , fontSize: MediaQuery
        //               .of(context)
        //               .textScaleFactor * 13,);
        //         }else {
        //           if(_groupValue == 1){
        //             if(routeArgs['paymentMode'].toString() == "1"){
        //               _dialogforOrdering();
        //               if(walletbalance >= double.parse(routeArgs['total'])){
        //                 CreateSubscription();
        //               }else{
        //                 Navigator.of(context).pushNamed(
        //                     SubscriptionWalletScreen.routeName,
        //                     arguments: {
        //
        //                       "addressid":addressid.toString(),
        //                       "useraddtype": useraddtype.toString(),
        //                       "startDate":startDate.toString(),
        //                       "endDate": endDate.toString(),
        //                       "itemCount": itemCount.toString(),
        //                       "deliveries": deliveries.toString(),
        //                       "total": (double.parse(routeArgs['total']) - walletbalance).toString(),
        //                       "subscriptionAmount": routeArgs['total'].toString(),
        //                       //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
        //                       "schedule": schedule.toString(),
        //                       "itemid": itemid.toString(),
        //                       "itemimg": itemimg.toString(),
        //                       "itemname": itemname.toString(),
        //                       "varprice": varprice.toString(),
        //                       "varname": varname.toString(),
        //                       "address": address.toString(),
        //                       "paymentMode": paymentMode.toString(),
        //                       "cronTime": cronTime.toString(),
        //                       "name": name.toString(),
        //                       "varid": varid.toString(),
        //                       "varmrp": varmrp.toString(),
        //
        //                     }
        //                 );
        //               }
        //
        //             }else{
        //               Fluttertoast.showToast(
        //                   msg:"This product is not eligible for Wallet payment",
        //                   fontSize: MediaQuery.of(context).textScaleFactor *13,
        //                   backgroundColor: Colors.black87,
        //                   textColor: Colors.white);
        //             }
        //           }else if(_groupValue == 2){
        //             if(routeArgs['paymentMode'].toString() == "0"){
        //               _dialogforOrdering();
        //               CreateSubscription();
        //             }else{
        //               //Navigator.of(context).pop();
        //               Fluttertoast.showToast(
        //                   msg:"This product is not eligible for Online payment",
        //                   fontSize: MediaQuery.of(context).textScaleFactor *13,
        //                   backgroundColor: Colors.black87,
        //                   textColor: Colors.white);
        //             }
        //           }
        //
        //
        //         }*/
        //       },
        //       child: Container (
        //         color: Theme.of(context).primaryColor,
        //         height: 54,
        //         width: MediaQuery.of(context).size.width * 60 / 100,
        //         child: Column(
        //             children: <Widget>[
        //               SizedBox(
        //                 height: 10,
        //               ),
        //               Center(
        //                   child: Text(
        //                       S.of(context).add_to//"Add to "
        //                           +IConstants.APP_NAME+"\n" + S.of(context).subscription_wallet,///" Subscription Wallet",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),
        //                       textAlign: TextAlign.center)),
        //               SizedBox(
        //                 height: 10,
        //               ),
        //             ]
        //         ),
        //       ),
        //     ),
        //
        //           ],
        //         )
        //       );
    }
    gradientappbarmobile() {
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(
                  SubscribeScreen.routeName,
                  arguments: {
                    "addressid":addressid.toString(),
                    "useraddtype": useraddtype.toString(),
                    "startDate":startDate.toString(),
                    "endDate": endDate.toString(),
                    "itemCount": itemCount.toString(),
                    "deliveries": deliveries.toString(),
                    "total": (double.parse(routeArgs['total']) - double.parse(walletbalance)).toString(),
                    //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
                    "schedule": schedule.toString(),
                    "itemid": itemid.toString(),
                    "itemimg": itemimg.toString(),
                    "itemname": itemname.toString(),
                    "varprice": varprice.toString(),
                    "varname": varname.toString(),
                    "address": address.toString(),
                    "paymentMode": paymentMode.toString(),
                    "cronTime": cronTime.toString(),
                    "name": name.toString(),
                    "varid": varid.toString(),
                    "varmrp": varmrp.toString(),
                    "brand": routeArgs['brand'].toString()
                    /*"itemid": itemid.toString(),
                    "itemname": itemname.toString(),
                    "itemimg": itemimg.toString(),
                    "varname": routeArgs[varname].toString(),
                    "varmrp":varmrp.toString(),
                    "varprice": routeArgs[varprice].toString(),
                    "paymentMode": paymentMode.toString(),
                    "cronTime": cronTime.toString(),
                    "name": name.toString(),
                    "varid": varid.toString()*/

                  }
              );

            }
        ),
        title: Text(
          S.of(context).subscription_payment_option,//'Subscription Payment Options',
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor
                  ])),
        ),
      );
    }

    Widget _bodyMobile() {
      double amountPayable = 0.0;
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

      Widget promocodeMethod() {
        double amount = double.parse(routeArgs['varmrp']);
        int quantity = int.parse(routeArgs['itemCount']);
        double subscriptionAmount = double.parse(routeArgs['total']);
        int deliveryNum = int.parse(routeArgs['deliveries']);

            return Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: ColorCodes.greenColor,
                  //strokeWidth: 1,
                  dashPattern: [3.0],
                  child: Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    height: 30.0,
                   // color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).your_savings,//"Your savings",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: ColorCodes.mediumBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          IConstants.currencyFormat +
                              " " +
                              (  ((amount*quantity) * deliveryNum) -(subscriptionAmount) ).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: ColorCodes.mediumBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              //  Divider(color: ColorCodes.blackColor),
              ],
            );

      }

      Widget paymentDetails() {
        double amount = double.parse(routeArgs['varmrp']);
        int quantity = int.parse(routeArgs['itemCount']);
        double subscriptionAmount = double.parse(routeArgs['total']);
        int deliveryNum = int.parse(routeArgs['deliveries']);
        return Column(
          children: [
           (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?SizedBox(height: 20,): SizedBox(height: 20,),
            Container(
              width: (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
              MediaQuery.of(context).size.width * 0.40
              :MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorCodes.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorCodes.grey.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              padding: EdgeInsets.only(
                  top: 15.0, left: 20.0, right: 20.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 /* Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          S.of(context).amount_payable,//"Amount Payable",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          S.of(context).incl_tax,//"(Incl. of all taxes)",
                          style: TextStyle(
                              fontSize: 10.0, color: ColorCodes.blackColor),
                        ),
                      ],
                    ),
                  ),*/
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
                          MediaQuery.of(context).size.width * 0.20:
                          MediaQuery.of(context).size.width/2
                          ,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).proceed_pay,//"Your subscription value",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              DottedLine(
                                  dashColor: ColorCodes.lightgrey,
                                  lineThickness: 1.0,
                                  dashLength: 2.0,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0),
                              SizedBox(
                                height: 5.0,
                              ),
                              /*if (!_isPickup)
                                Text(
                                  "Delivery charges",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: ColorCodes.mediumBlackColor),
                                ),
                              if (!_isPickup)
                                SizedBox(
                                  height: 10.0,
                                ),*/

                                Text(
                                  S.of(context).discount_applied,//"Discount applied:",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              SizedBox(
                                height: 5.0,
                              ),
                              DottedLine(
                                  dashColor: ColorCodes.lightgrey,
                                  lineThickness: 1.0,
                                  dashLength: 2.0,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                S.of(context).amount_payable,//"Amount payable:",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width:   (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
                        MediaQuery.of(context).size.width * 0.10:MediaQuery.of(context).size.width / 4.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                IConstants.currencyFormat +
                                    " " + ((amount*quantity) * deliveryNum).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              /*if (!_isPickup)
                                Text(
                                  deliverychargetext,
                                  style: TextStyle(
                                      fontSize: 12.0, color: ColorCodes.redColor),
                                ),
                              if (!_isPickup)
                                SizedBox(
                                  height: 10.0,
                                ),*/

                                Text(
                                  "- " +
                                      (  ((amount*quantity) * deliveryNum) -(subscriptionAmount) )
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                IConstants.currencyFormat +
                                    " " +
                                    subscriptionAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Divider(
                    color: ColorCodes.greyColor,
                    thickness: 0.8,
                  ),

                  // promocodeMethod() goes here
                  promocodeMethod(),
                ],
              ),
            ),
            if(_isWeb && ! ResponsiveLayout.isSmallScreen(context))
              Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: 55.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //  SizedBox(width: 60,),
                      GestureDetector(
                        onTap: (){
                          if(_groupValue == -1) {
                            Fluttertoast.showToast(
                              msg:
                              S.of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                              fontSize: MediaQuery
                                  .of(context)
                                  .textScaleFactor * 13,);
                          }else {
                            _dialogforOrdering();
                            CreateSubscription();
                          }
                        },
                        child: Container (
                          color: Theme.of(context).primaryColor,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child:
                                    Text(

                                        S.of(context).proceed_pay,//"Your subscription value",
                                        // style: TextStyle(
                                        //     fontSize: 14.0,
                                        //     color: ColorCodes.greyColor,
                                        //     fontWeight: FontWeight.bold),




                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center)
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ]
                          ),
                        ),
                      ),
                      //  SizedBox(width: 60,),
                    ],
                  )
              ),
          ],
        );
      }
      Widget paymentSelection() {
        return Container(
          width: (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
          MediaQuery.of(context).size.width * 0.40
              :MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorCodes.whiteColor,
            boxShadow: [
              BoxShadow(
                color: ColorCodes.grey.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           // mainAxisAlignment: MainAxisAlignment.start,
           // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?SizedBox(height: 20,): SizedBox(height: 0,),
              Container(
                  width:  (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
              MediaQuery.of(context).size.width * 0.40:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    S.of(context).payment_option,//"Payment Method",
                    style: TextStyle(
                        fontSize: 19.0,
                        color: ColorCodes.greenColor,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 10,),
              // disable?
              // GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () {
              //     setState(() {
              //       checked = true;
              //       _groupValue=1;
              //     });
              //   },
              //   child: Container(
              //
              //     padding: EdgeInsets.only(
              //         top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
              //     child: Row(
              //       mainAxisAlignment:
              //       MainAxisAlignment.spaceBetween,
              //       children: [
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               IConstants.APP_NAME + S.of(context).subscription_wallet,///" Subscription Wallet",
              //               style: TextStyle(
              //                   color: ColorCodes.blackColor,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             SizedBox(
              //               height: 2.0,
              //             ),
              //             Row(
              //               children: [
              //                 Text(
              //                   S.of(context).balance,//"Balance:  ",
              //                   style: TextStyle(
              //                       color: ColorCodes.greyColor,
              //                       fontSize: 10.0),
              //                 ),
              //                 SizedBox(
              //                   width: 2.0,
              //                 ),
              //                 Image.asset(Images.walletImg,
              //                     height: 13.0,
              //                     width: 16.0,
              //                     color: ColorCodes.darkthemeColor),
              //                 SizedBox(
              //                   width: 5.0,
              //                 ),
              //                 Text(
              //                   IConstants.currencyFormat + " " + double.parse(walletbalance.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
              //                   style: TextStyle(
              //                       color: ColorCodes.greyColor,
              //                       fontSize: 10.0),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             checked?  (double.parse(walletbalance) >= double.parse(routeArgs['total']))?
              //             Text(routeArgs['total'], style: TextStyle(fontSize: 12,color: ColorCodes.grey),):
              //             Text(( double.parse(routeArgs['total']) - double.parse(walletbalance)).toString(), style: TextStyle(fontSize: 12,color: ColorCodes.grey),) : SizedBox.shrink(),
              //             SizedBox(width: 5,),
              //             SizedBox(
              //               width: 20.0,
              //               child: _myRadioButton(
              //                 title: "",
              //                 value: 1,
              //                 onChanged: (newValue) {
              //                   setState(() {
              //                     _groupValue = newValue;
              //                     checked = true;
              //                   });
              //                 },
              //               ),
              //             ),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ):
              // Container(
              //   padding: EdgeInsets.only(
              //       top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
              //   child: Row(
              //     mainAxisAlignment:
              //     MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             IConstants.APP_NAME + S.of(context).subscription_wallet,//" Subscription Wallet",
              //             style: TextStyle(
              //                 color: ColorCodes.greyColor,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(
              //             height: 2.0,
              //           ),
              //           Row(
              //             children: [
              //               Text(
              //                 S.of(context).balance,//"Balance:  ",
              //                 style: TextStyle(
              //                     color: ColorCodes.greyColor,
              //                     fontSize: 10.0),
              //               ),
              //               SizedBox(
              //                 width: 2.0,
              //               ),
              //               Image.asset(Images.walletImg,
              //                   height: 13.0,
              //                   width: 16.0,
              //                   color: ColorCodes.darkthemeColor),
              //               SizedBox(
              //                 width: 5.0,
              //               ),
              //               Text(
              //                 IConstants.currencyFormat + " " + walletbalance.toString(),
              //                 style: TextStyle(
              //                     color: ColorCodes.greyColor,
              //                     fontSize: 10.0),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           SizedBox(
              //             width: 20.0,
              //             child: _myRadioButton(
              //               title: "",
              //               value: 1,
              //               onChanged: (newValue) {
              //                 setState(() {
              //                  // _groupValue = newValue;
              //                 //  checked = true;
              //                 });
              //               },
              //             ),
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // ),
              //     Padding(
              //       padding: const EdgeInsets.only(left:20.0,right:20.0),
              //       child: Divider(
              //         color: ColorCodes.lightGreyColor,
              //       ),
              //     ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    checked = false;
                    _groupValue=2;
                  });
                },
                child: Column(
                  children: [
                    Container(

                      padding: EdgeInsets.only(
                          top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).online_payment,//"Online Payment",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes
                                        .blackColor),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Image.asset(Images.onlineImg, height: 24),
                            ],
                          ),
                          SizedBox(
                            width: 20.0,
                            child: _myRadioButton(
                              title: "",
                              value: 2,
                              onChanged: (newValue) {
                                setState(() {
                                  _groupValue = newValue;
                                  checked = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),

            ],
          ),
        );
      }

      return Expanded(
        child: SingleChildScrollView(
          child: (_isWeb) ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      paymentSelection(),
                      SizedBox(width: 20,),
                      paymentDetails(),
                    ],
                  ),
                   Footer(address: PrefUtils.prefs.getString("restaurant_address")),
                ],
              )
              :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              paymentDetails(),
              SizedBox(height: 30,),
              paymentSelection(),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: (){
        final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

        Navigator.of(context).pushNamed(
            SubscribeScreen.routeName,
            arguments: {
              "addressid":addressid.toString(),
              "useraddtype": useraddtype.toString(),
              "startDate":startDate.toString(),
              "endDate": endDate.toString(),
              "itemCount": itemCount.toString(),
              "deliveries": deliveries.toString(),
              "total": (double.parse(routeArgs['total']) - double.parse(walletbalance)).toString(),
              //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
              "schedule": schedule.toString(),
              "itemid": itemid.toString(),
              "itemimg": itemimg.toString(),
              "itemname": itemname.toString(),
              "varprice": varprice.toString(),
              "varname": varname.toString(),
              "address": address.toString(),
              "paymentMode": paymentMode.toString(),
              "cronTime": cronTime.toString(),
              "name": name.toString(),
              "varid": varid.toString(),
              "varmrp": varmrp.toString(),
              "brand": routeArgs['brand'].toString()
              /*"itemid": itemid.toString(),
              "itemname": itemname.toString(),
              "itemimg": itemimg.toString(),
              "varname": varname.toString(),
              "varmrp":varmrp.toString(),
              "varprice": varprice.toString() ,
              "paymentMode": paymentMode.toString(),
              "cronTime": cronTime.toString(),
              "name": name.toString(),
              "varid": varid.toString()*/
            }
        );
        return Future.value(false);
      },
      child: Scaffold (
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        body: Column(
          children: [
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false, false),
            // !_isWeb ? _bodyMobile() : _bodyWeb(),
           /* (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ? null :*/ _bodyMobile(),
            // if (_isWeb && !ResponsiveLayout.isLargeScreen(context)) _bodyMobile(),
          ],
        ),
        bottomNavigationBar:
        _isWeb ? SizedBox.shrink() : _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    if (_groupValue != -1) {
      if (_groupValue == 1) {
        PrefUtils.prefs.setString("payment_type", "Wallet");
      } else if (_groupValue == 2) {
        PrefUtils.prefs.setString("payment_type", "Paytm");
      }
    }

    return Radio(
      activeColor: Theme.of(context).primaryColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      //title: Text(title),
    );
  }

  Future<void> CreateSubscription() async {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
   // DateFormat("dd-MM-yyyy").format(_selectedDate)
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }
    try {
      String text = weeklist.toString().replaceAll('[', "").replaceAll(']', '').replaceAll(' ', '');
      debugPrint("text...."+text +"  "+weeklist.toString().replaceAll('[', "").replaceAll(']', ''));
          final response = await http.post(Api.subscriptionCreate, body: {
        "user_id":PrefUtils.prefs.getString('apikey'),
        "quantity":routeArgs['itemCount'].toString(),
        "delivery":routeArgs['deliveries'].toString(),
        "start_date":routeArgs['startDate'].toString(),
       // "end_date":routeArgs['endDate'].toString(),
        "address":routeArgs['address'].toString(),
        "address_type":routeArgs['useraddtype'].toString(),
        "address_id":routeArgs['addressid'].toString(),
        "amount":routeArgs['total'].toString(),
        "branch":PrefUtils.prefs.getString('branch'),
        "slot":routeArgs['name'].toString(),
        "payment_type":/*routeArgs['paymentMode'].toString()*/ (_groupValue == 1)? "wallet": "Paytm",
        "cron_time":routeArgs['cronTime'].toString(),
        "channel":channel,
        "var_id": routeArgs['varid'].toString(),
        "type": routeArgs['schedule'].toString(),
        "mrp":varmrp,
        "price":varprice,
        "days":text,
        "no_of_days":no_of_days
      });
      debugPrint("body...sub..."+{
        "user_id":PrefUtils.prefs.getString('apikey'),
        "quantity":routeArgs['itemCount'].toString(),
        "delivery":routeArgs['deliveries'].toString(),
        "start_date":routeArgs['startDate'].toString(),
        //"end_date":routeArgs['endDate'].toString(),
        "address":routeArgs['address'].toString(),
        "address_type":routeArgs['useraddtype'].toString(),
        "address_id":routeArgs['addressid'].toString(),
        "amount":routeArgs['total'].toString(),
        "branch":PrefUtils.prefs.getString('branch'),
        "slot":routeArgs['name'].toString(),
        "payment_type":/*routeArgs['paymentMode'].toString()*/ (_groupValue == 1)? "wallet": "Paytm",
        "cron_time":routeArgs['cronTime'].toString(),
        "channel":channel,
        "var_id": routeArgs['varid'].toString(),
        "type": routeArgs['schedule'].toString(),
        "mrp":varmrp,
        "price":varprice,
        "days":text,
        "no_of_days":no_of_days
      }.toString());
      final responseJson = json.decode(response.body);
       debugPrint("response....sub"+responseJson.toString());
      if (responseJson['status'] == 200) {
        double orderAmount = double.parse(responseJson['amount']);
        var orderId = responseJson['id'];
        debugPrint("orderId..."+orderId.toString());
        PrefUtils.prefs.setString("subscriptionorderId", responseJson['id'].toString());
        PrefUtils.prefs.setString("startDate", routeArgs['startDate'].toString());

        if(_groupValue == 1){
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(
              SubscriptionConfirmScreen.routeName,
              arguments: {
                'orderstatus' : "success",
                'sorderId': PrefUtils.prefs.getString("subscriptionorderId")
              }
          );
        }else if(_groupValue == 2){
          Navigator.of(context).pop();
          payment.startPaytmTransaction(context, _isWeb, orderId: orderId.toString(), username: PrefUtils.prefs.getString('apikey'),amount: orderAmount.toString(), routeArgs: routeArgs ,prev:"SubscribeScreen");

        }
       /* Navigator.of(context)
            .pushNamed(PaymenSubscriptionScreen.routeName, arguments: {
          'minimumOrderAmountNoraml': "0",
          'deliveryChargeNormal': "0",
          'minimumOrderAmountPrime': "0",
          'deliveryChargePrime': "0",
          'minimumOrderAmountExpress': "0",
          'deliveryChargeExpress': "0",
          'deliveryType': "subscription",
          'note': "",
          'deliveryCharge': "0",
          'deliveryDurationExpress' : "0",
          "varmrp":routeArgs['varmrp'],
          "varprice":varprice.toString(),
          'orderId':orderId.toString(),
          'amount': orderAmount.toString(),
          "quantity": _itemCount.toString(),
          "deliveryNum": deliveryNum.toString(),
          'prev':"SubscribeScreen"
        });*/

      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: responseJson['data'].toString(),
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    } catch (error) {
      throw error;
    }
  }
}