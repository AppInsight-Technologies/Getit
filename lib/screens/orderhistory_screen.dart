import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../screens/myorder_screen.dart';
import '../generated/l10n.dart';
import '../screens/notification_screen.dart';
import '../screens/refund_screen.dart';
import '../providers/notificationitems.dart';
import '../screens/home_screen.dart';
import 'package:launch_review/launch_review.dart';
import '../assets/images.dart';
import '../constants/features.dart';
import '../providers/cartItems.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/orderhistory_shimmer.dart';
import 'package:provider/provider.dart';

import '../screens/return_screen.dart';
import '../widgets/orderhistory_display.dart';
import '../utils/prefUtils.dart';

import '../providers/myorderitems.dart';
import '../providers/addressitems.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import 'cart_screen.dart';

class OrderhistoryScreen extends StatefulWidget {
  static const routeName = '/orderhistory-screen';
  @override
  _OrderhistoryScreenState createState() => _OrderhistoryScreenState();
}

class _OrderhistoryScreenState extends State<OrderhistoryScreen> {
  var _address = "";

  String id;
  String itemid;
  String itemname;
  String varname;
  String price;
  String qty;
  String itemoactualamount;
  String discount;
  String subtotal;
  String itemImage;
  String menuid;
  String barcode;
  var orderitemData;
  bool _isLoading = true;
  var phone = "";
  var _isWeb = false;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool _showReturn = false;
  int _groupValue = -1;
  String orderid,orderstatus,prev;
  String extraAmount;
  bool _isIOS = false;
  var addressitemsData;
  double dueamount = 0.0;
  DateTime orderAdd;
  String finalDate;
  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isIOS = true;
          _isWeb = false;
        });
      } else {
        setState(() {
          _isWeb = false;
          _isIOS = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWeb = true;
        _isIOS = false;
      });
    }
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      print("return exchange"+Features.isReturnOrExchange.toString());
      _address = PrefUtils.prefs.getString("restaurant_address");
      if (PrefUtils.prefs.getString('mobile') != null) {
        phone = PrefUtils.prefs.getString('mobile');
      } else {
        phone = "";
      }
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      orderid = routeArgs['orderid'];
      orderstatus=routeArgs['orderStatus'];
      prev=routeArgs['fromScreen'];

      Provider.of<MyorderList>(context, listen: false).Vieworders(orderid).then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(context, listen: false,);

          extraAmount=orderitemData.vieworder1[0].extraAmount;
          dueamount = double.parse(orderitemData.vieworder[0].dueamount);
          print("due amount..."+orderitemData.vieworder[0].dueamount.toString());
          if(orderitemData.vieworder1[0].deliveryOn != ""){
            print("orderitemData.vieworder1[0].ostatus.toLowerCase()"+orderitemData.vieworder1[0].ostatus.toLowerCase().toString());
            DateTime today = new DateTime.now();
            for(int i = 0; i < orderitemData.vieworder1.length; i++) {
               orderAdd = DateTime.parse(orderitemData.vieworder1[i].deliveryOn).add(Duration(hours:int.parse (orderitemData.vieworder1[i].returnTime)));
              if((orderAdd.isAtSameMomentAs(today) || orderAdd.isAfter(today))&&
                  (orderitemData.vieworder[0].returnStatus == "" || orderitemData.vieworder[0].returnStatus == "null") &&
                      (orderitemData.vieworder1[i].ostatus.toLowerCase() == "delivered" || orderitemData.vieworder1[i].ostatus.toLowerCase() == "completed")) {
                if (orderitemData.vieworder1[i].returnTime != "" && orderitemData.vieworder1[i].returnTime != "0") {
                  setState(() {
                    _showReturn = true;
                  });
                  String month;
                    if(orderAdd.month == 1){
                      month = "Jan";
                    }else if(orderAdd.month == 2){
                      month = "Feb";
                    }else if(orderAdd.month == 3){
                      month = "Mar";
                    }else if(orderAdd.month == 4){
                      month = "Apr";
                    }else if(orderAdd.month == 5){
                      month = "May";
                    }else if(orderAdd.month == 6){
                      month = "June";
                    }else if(orderAdd.month == 7){
                      month = "July";
                    }else if(orderAdd.month == 8){
                      month = "Aug";
                    }else if(orderAdd.month == 9){
                      month = "Sep";
                    }else if(orderAdd.month == 10){
                      month = "Oct";
                    }else if(orderAdd.month == 11){
                      month = "Nov";
                    }else if(orderAdd.month == 12){
                      month = "Dec";
                    }
                  var formattedDate = "${orderAdd.day} ${month}, ${orderAdd.year}";
                  setState(() {
                    finalDate = formattedDate.toString() ;
                  });
                  break;
                }
              }
                /*if (orderitemData.vieworder[0].returnStatus==""||orderitemData.vieworder[0].returnStatus=="null"){
                  setState(() {
                    _showReturn = true;
                  });
                }else{
                  setState(() {
                    _showReturn = false;
                  });
                }*/
                //print("show return exchange"+_showReturn.toString());
              }
          }
          if(prev =="splashNotification" || prev =="pushNotificationScreen") {
            Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(routeArgs['notificationId'], "1" );
          }
          if((prev =="splashNotification" && orderitemData.vieworder[0].ostatus.toString().toUpperCase() == "DELIVERED") ||
              (prev =="pushNotificationScreen" && routeArgs['notificationStatus'] == "0" && orderitemData.vieworder[0].ostatus.toString().toUpperCase() == "DELIVERED")){
            debugPrint(" from splash notification");
            ShowpopupforReview();
          }
          _isLoading = false;
        });
      });

    });
    super.initState();
  }

  _dialogforReturn(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 150.0,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S.of(context).do_you_want_return_exchange,
                        //"Do you want to return or exchange",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      _myRadioButton(
                        title: S.of(context).returns,
                    //    "Return",
                        value: 0,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                      _myRadioButton(
                        title:
                        S.of(context).exchange,
                        // "Exchange",
                        value: 1,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                    ],
                  )),
            );
          });
        });
  }
  Widget _myRadioButton({String title, int value, Function onChanged}) {
    final addressitemsData =
    Provider.of<AddressItemsList>(context, listen: false);

    if (_groupValue == 0) {
      PrefUtils.prefs.setString("return_type", "0"); // 0 => Return
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        _groupValue = -1;
        Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
          'orderid': orderid,
          'title':S.of(context).returns,
          'orderStatus':orderitemData.vieworder[0].odate,
          'returnValid': finalDate,
        });
        // if (addressitemsData.items.length > 0) {
        //
        // } else {
        //   PrefUtils.prefs.setString("addressbook", "myorderdisplay");
        //   Navigator.of(context).pushNamed(AddressScreen.routeName, arguments: {
        //     'addresstype': "new",
        //     'addressid': "",
        //     'delieveryLocation': "",
        //   });
        // }
      });
    } else if (_groupValue == 1) {
      PrefUtils.prefs.setString("return_type", "1"); // 1 => Exchange
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        _groupValue = -1;
        Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
          'orderid': orderid,
          'title':S.of(context).exchange,
          'orderStatus':orderitemData.vieworder[0].odate,
          'returnValid': finalDate,
        });

        // if (addressitemsData.items.length > 0) {
        //
        // } else {
        //   PrefUtils.prefs.setString("addressbook", "myorderdisplay");
        //   Navigator.of(context).pushNamed(AddressScreen.routeName, arguments: {
        //     'addresstype': "new",
        //     'addressid': "",
        //     'orderid': orderid,
        //     'delieveryLocation': "",
        //   });
        // }
      });
    }

    return RadioListTile(
      activeColor: Theme.of(context).primaryColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () {
        // this is the block you need
        if(prev =="splashNotification") {
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
        } else if(prev == "orderConfirmation"){
           /*Navigator.pushReplacementNamed(context, MyorderScreen.routeName,
               arguments: {
                 "orderhistory": "orderhistoryScreen"
               });*/
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          // return Future.value(false);
        }else if(prev == "weborderConfirmation"){
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
        }
        else if(prev == "pushNotificationScreen"){
          Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
        } else if(prev == "webmyOrders"){
          debugPrint("web.....");
          Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName,(route) => false,arguments: {
            "orderhistory": "web"
          });
        }
        else{
          if(_isWeb ){
            debugPrint("clicked.....else");
            Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName,(route) => false,arguments: {
              "orderhistory": ""
            });

        /*  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
          }
          else{
            Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName,(route) => false,arguments: {
              "orderhistory": ""
            });
          }

        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,

        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            _body(),
          ],
        ),
      ),
    );
  }

  _body() {
    final routeArgs =
    ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final itemLeftCount = routeArgs['itemLeftCount'];
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorCodes.lightGreyWebColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(
                child: OrderHistoryShimmer(),//CircularProgressIndicator(),
              )
                  : viewOrder(),
              SizedBox(height: 40,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs.getString("restaurant_address")/*PrefUtils.prefs.getString("restaurant_address")*/),
            ],
          ),
        ),
      ),
    );
  }

  _dialogforProcessing() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }

  void _repeatOrder() {
    Provider.of<CartItems>(context, listen: false).reOrder(orderid).then((_) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
        "after_login": ""
      });
    });
  }

  Widget viewOrder() {
    debugPrint("orderitemData.vieworder[0].giftWrapamount" + orderitemData.vieworder1[0].giftWrapamount.toString());
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    double total;
    double subtotal;
    if(orderitemData.vieworder[0].itemodelcharge !=0) {
      if (orderitemData.vieworder[0].giftWrapamount != "0") {
        total = double.parse(orderitemData.vieworder[0].itemoactualamount) +
            double.parse(orderitemData.vieworder[0].itemodelcharge) -
            orderitemData.vieworder[0].loyalty
            - double.parse(orderitemData.vieworder[0].totalDiscount) +
            double.parse(orderitemData.vieworder[0].dueamount) + double.parse(orderitemData.vieworder[0].giftWrapamount);
      }
      else{
        total= double.parse(orderitemData.vieworder[0].itemoactualamount) +
            double.parse(orderitemData.vieworder[0].itemodelcharge) -orderitemData.vieworder[0].loyalty
            - double.parse(orderitemData.vieworder[0].totalDiscount) + double.parse(orderitemData.vieworder[0].dueamount);
      }
    }
    else {
      if (orderitemData.vieworder[0].giftWrapamount != "0") {
        total = double.parse(orderitemData.vieworder[0].itemoactualamount) -
            orderitemData.vieworder[0].loyalty
            - double.parse(orderitemData.vieworder[0].totalDiscount) +
            double.parse(orderitemData.vieworder[0].dueamount) + double.parse(orderitemData.vieworder[0].giftWrapamount);
      }
      else{
        total = double.parse(orderitemData.vieworder[0].itemoactualamount) -
            orderitemData.vieworder[0].loyalty
            - double.parse(orderitemData.vieworder[0].totalDiscount) +
            double.parse(orderitemData.vieworder[0].dueamount);
      }
    }
    subtotal = double.parse(orderitemData.vieworder[0].itemoactualamount) + double.parse(orderitemData.vieworder[0].dueamount);
    print("total discoun"+orderitemData.vieworder[0].totalDiscount.toString());
    print("total amount"+subtotal.toString());
    print("invoice number....."+orderitemData.vieworder[0].invoice.toString());
    String total_saving=(orderitemData.vieworder[0].promocode_discount + orderitemData.vieworder[0].membership_earned).toString();
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
        child: Column(
          children: [
          //   (total_saving =="00")?SizedBox.shrink():
          //   Card(
          //     child: Container(
          //       width: MediaQuery.of(context).size.width - 20,
          //       decoration: BoxDecoration(color: Theme.of(context).buttonColor),
          //       padding: EdgeInsets.all(15),
          //  child:  Column(
          //    children: [
          //      (orderitemData.vieworder[0].loyalty_earned.toString()=="0")?SizedBox.shrink():
          //      Row(
          //         children: [
          //           Text(
          //               S.of(context).loyalty_earned
          //             // "Ordered on : "
          //             // + orderitemData.vieworder[0].odate
          //           ),
          //           Spacer(),
          //           Image.asset(Images.coinImg, height: 15.0, width: 15.0),
          //           SizedBox(width: 4),
          //           Text(orderitemData.vieworder[0].loyalty_earned),
          //         ],
          // ),
          //      SizedBox(
          //        height: 10,
          //      ),
          //      (orderitemData.vieworder[0].membership_earned.toString()=="0")?SizedBox.shrink():
          //       Row(
          //         children: [
          //           Text(
          //               S.of(context).membership_earned
          //             // "Ordered on : "
          //             // + orderitemData.vieworder[0].odate
          //           ),
          //           Spacer(),
          //           Text(orderitemData.vieworder[0].membership_earned),
          //         ],
          //       ),
          //      SizedBox(
          //        height: 10,
          //      ),
          //      (orderitemData.vieworder[0].promocode_discount.toString()=="0")?SizedBox.shrink():
          //        Row(
          //         children: [
          //           Text(
          //               S.of(context).
          //               promocode_discount
          //           ),
          //           Spacer(),
          //           Text(orderitemData.vieworder[0].promocode_discount),
          //         ],
          //       ),
          //      SizedBox(
          //        height: 10,
          //      ),
          //      //(total_saving =="00")?SizedBox.shrink():
          //      Row(
          //        children: [
          //          Text(
          //              S.of(context).total_savings,
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.greenColor)),
          //
          //          Spacer(),
          //          Text(orderitemData.vieworder[0].promocode_discount + orderitemData.vieworder[0].membership_earned),
          //        ],
          //      ),
          //         ],
          //  ),
          //     ),
          //   ),
            // Container(
            //   width: MediaQuery.of(context).size.width - 20,
            //   height: 50,
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //       S.of(context).item_details,
            //       //"Item Details",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // ),
            SizedBox(height:15),
            Container(
              width: MediaQuery.of(context).size.width - 20,

              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: new ListView.separated(
                      separatorBuilder: (context, index) => Divider(thickness: 2,),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: int.parse(orderitemData.vieworder[0].itemsCount),
                      itemBuilder: (_, i) => Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          OrderhistoryDisplay(
                            orderitemData.vieworder1[i].itemname,
                            orderitemData.vieworder1[i].varname,
                            orderitemData.vieworder1[i].fit,
                            orderitemData.vieworder1[i].price,
                            orderitemData.vieworder1[i].qty,
                            orderitemData.vieworder1[i].subtotal,
                            orderitemData.vieworder1[i].itemImage,
                            orderitemData.vieworder1[i].extraAmount,
                            orderid,
                            orderitemData.vieworder1[i].size,
                          ),

                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  if(Features.isReturnOrExchange)
                    _showReturn?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        GestureDetector(
                          onTap: (){
                            PrefUtils.prefs.setString("return_type", "0"); // 0 => Return
                            Future.delayed(Duration.zero, () async {
                              Navigator.pop(context);

                              Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                                'orderid': orderid,
                                'title':S.of(context).returns,
                                'orderStatus':orderitemData.vieworder[0].odate,
                                'returnValid': finalDate,
                              });

                            });
                          },
                          child: Container(
                            height:35 ,
                            width: MediaQuery.of(context).size.width /2.5,
                            decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              border: Border.all(
                                color: ColorCodes.discountoff,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            ),
                            child: Center(child: Text(
                                "Return",
                                //   'Return or Exchange'
                                style: TextStyle
                                  ( fontSize: 14,color:ColorCodes.discountoff,fontWeight: FontWeight.bold))),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            PrefUtils.prefs.setString("return_type", "1"); // 1 => Exchange
                            Future.delayed(Duration.zero, () async {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                                'orderid': orderid,
                                'title':S.of(context).exchange,
                                'orderStatus':orderitemData.vieworder[0].odate,
                                'returnValid': finalDate,
                              });
                            });
                          },
                          child: Container(
                            height:35 ,
                            width: MediaQuery.of(context).size.width /2.5,
                            decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              border: Border.all(
                                color: ColorCodes.discountoff,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            ),
                            child: Center(child: Text(
                                "Exchange",
                                //   'Return or Exchange'
                                style: TextStyle
                                  ( fontSize: 14,color:ColorCodes.discountoff,fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ],
                    ):
                    SizedBox.shrink(),
                  if(Features.isReturnOrExchange)
                    _showReturn?SizedBox(height: 10,):SizedBox.shrink(),
                  if(Features.isReturnOrExchange)
                    _showReturn?
                  Text(
                      "Return & Exchange Valid Till "+ finalDate+".",
                      style: TextStyle
                        ( fontSize: 13,color:ColorCodes.greyColor)):SizedBox.shrink(),
                  if(Features.isReturnOrExchange)
                    _showReturn?SizedBox(height: 10,):SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(height:6),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      S.of(context).delivery,
                      // "Delivery Slot",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorCodes.greyColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                          S.of(context).ordered_on,
                          style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold)
                         // "Ordered on : "
                         // + orderitemData.vieworder[0].odate
                      ),
                      Spacer(),
                      Text(orderitemData.vieworder[0].odate,
                          style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).delivery_on,
                         // "Delivery on : "
                          style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold)
                              ),
                      Spacer(),
                      Text( orderitemData.vieworder[0].odeltime,
                          style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (orderitemData.vieworder[0].returnStatus==""||orderitemData.vieworder[0].returnStatus=="null")?
                  Row(
                    children: [
                      Text(S.of(context).order_status,
                  style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold)
                      ),
                      Spacer(),
                      Text(orderitemData.vieworder[0].ostatus,style: TextStyle(color: ColorCodes.discountoff, fontWeight: FontWeight.bold),)
                    ],
                  ):
                  Row(
                    children: [
                      Text(
                          //S.of(context).ret
                          S.of(context).return_status//"Return Status : "
                               ),
                      Spacer(),
                      Text(orderitemData.vieworder[0].returnStatus,style: TextStyle(color: ColorCodes.greenColor),)
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(height:6),
            // Container(
            //   width: MediaQuery.of(context).size.width - 20,
            //   height: 50,
            //   alignment: Alignment.centerLeft,
            //   child: Text(S.of(context).address,
            //      // "Address",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Shipping Details",
                      // "Address",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorCodes.greyColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    orderitemData.vieworder[0].customerName,
                    style: TextStyle(fontSize: 18, color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    orderitemData.addressitems[0].houseno + ", " +  orderitemData.addressitems[0].area ,
                    style: TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                  ),
                  Text(
                    orderitemData.addressitems[0].landmark + ", " +  orderitemData.addressitems[0].city ,
                    style: TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,),
                  ),
                  Text(
                    orderitemData.addressitems[0].state + ", " +  orderitemData.addressitems[0].pincode ,
                    style: TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                  ),

                  Text(
                     orderitemData.addressitems[0].mobile ,
                    style: TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                  ),
                ],
              ),
            ),
            SizedBox(height:6),
            // Container(
            //   width: MediaQuery.of(context).size.width - 20,
            //   height: 50,
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //       S.of(context).payment_details,
            //      // "Payment Details",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                     "Payment Summary",
                      // "Payment Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorCodes.greyColor)),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text(
                        S.of(context).ordered_ID
                        //"Ordered Id : "
                        ,
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].itemorderid,
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                (!(orderitemData.vieworder[0].invoice == "-" || orderitemData.vieworder[0].invoice == "" || orderitemData.vieworder[0].invoice == null))?
                  Row(
                    children: [
                      Text(
                        S.of(context).invoice_no,
                        //"Invoice No : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                         orderitemData.vieworder[0].invoice,
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ):
                      SizedBox.shrink(),
                  (!(orderitemData.vieworder[0].invoice == "-" || orderitemData.vieworder[0].invoice == "" || orderitemData.vieworder[0].invoice == null))?
                      SizedBox(
                    height: 10,
                  ):
                  SizedBox.shrink(),
                  Row(
                    children: [
                      Text(S.of(context).payment_option,
                        //"Payment Options : ",
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].opaytype,
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                      S.of(context).ordered_items,
                        //"Ordered Items : ",
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].itemsCount + S.of(context).items,
                          //  " items",
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).sub_total,
                        //"Sub Total : ",
                        style: TextStyle(color: ColorCodes.greyColor,fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        IConstants.currencyFormat + " " + subtotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),//double.parse(orderitemData.vieworder[0].itemoactualamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (orderitemData.vieworder[0].giftWrapamount != "0")
                  Row(
                    children: [
                      Text("Gift Wrap",
                        //"Delivery Charges : ",
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        IConstants.currencyFormat + " " + IConstants.giftWrapamount,
                        //"FREE",
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  if (orderitemData.vieworder[0].giftWrapamount != "0")
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).delivery_charge_order,
                        //"Delivery Charges : ",
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      double.parse(orderitemData.vieworder[0].itemodelcharge) == 0.0 ?
                      Text(
                        S.of(context).free,
                        //"FREE",
                        style: TextStyle(color: ColorCodes.discountoff,fontSize: 12.0, fontWeight: FontWeight.bold),
                      ):
                      Text(
                        IConstants.currencyFormat + " " + double.parse(orderitemData.vieworder[0].itemodelcharge).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if(orderitemData.vieworder[0].loyalty != 0.0 )
                    SizedBox(
                      height: 10,
                    ),
                  if(orderitemData.vieworder[0].loyalty != 0.0 )
                    Row(
                      children: [
                        Text( S.of(context).discount_applied_order,
                         // "Discount Applied (loyalty): ",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
                        ),
                        Spacer(),
                        Text("-" + " " + IConstants.currencyFormat + " " + (orderitemData.vieworder[0].loyalty).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
                        ),
                      ],
                    ),
                  if(double.parse(orderitemData.vieworder[0].totalDiscount) != 0 )
                    SizedBox(
                      height: 10,
                    ),
                  if(double.parse(orderitemData.vieworder[0].totalDiscount) != 0 )
                    Row(
                      children: [
                        Text(S.of(context).promo
                        //  "Promo ("
                              + (orderitemData.vieworder[0].promocode).toString() +")",
                          style: TextStyle(color: ColorCodes.discountoff, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text("-" + " "+ IConstants.currencyFormat + " " + double.parse(orderitemData.vieworder[0].totalDiscount.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(color: ColorCodes.discountoff, fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  if(orderitemData.vieworder[0].wallet != 0.0 )
                    SizedBox(
                      height: 10,
                    ),
                  if(orderitemData.vieworder[0].wallet != 0.0 )
                    Row(
                      children: [
                        Text(
                          S.of(context).wallet,
                       //   "Wallet : ",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
                        ),
                        Spacer(),
                        Text(
                          IConstants.currencyFormat + " " + (orderitemData.vieworder[0].wallet).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
                        ),


                      ],
                    ),
                  SizedBox(height:10),
                  DottedLine(dashColor: ColorCodes.greyColor,),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Amount to be paid",
                        //  "Total",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Spacer(),
                      Text(
                        IConstants.currencyFormat + " " + total.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),/*orderitemData.vieworder[0].itemototalamount,*/
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            if(double.parse(orderitemData.vieworder[0].totalDiscount) != 0 )
            Container(
              width: MediaQuery.of(context).size.width - 20,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: ColorCodes.discountoff),
              padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
              child: Row(
                children: [
                  Text(S.of(context).your_total_saving,
                  //  "Total",
                    style: TextStyle(color: ColorCodes.whiteColor, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(

                    IConstants.currencyFormat + " " + orderitemData.vieworder[0].totalDiscount/*.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)*/,/*orderitemData.vieworder[0].itemototalamount,*/

                    style: TextStyle(
                      color: ColorCodes.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            if(Features.isRefundModule)
              if(dueamount > 0)
            SizedBox(height:30),
            if(Features.isRefundModule)
              if(dueamount > 0)
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
             // padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:15,right: 15,top: 15),
                    child: Text(S.of(context).refund,
                        // "Address",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.greenColor)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15,right: 15),
                    child: Row(
                      children: [
                        Text(S.of(context).due_amount,
                          //  "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          IConstants.currencyFormat + " " + dueamount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),/*orderitemData.vieworder[0].itemototalamount,*/
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                            //color: ColorCodes.mediumBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(Refund_screen.routeName,
                      arguments: {
                        "orderid": orderid,
                        "total": total.toString(),

                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(color: ColorCodes.lightgreen),
                      height:45,
                     // padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                            child: Text(S.of(context).view_details_order,
                              //  "Total",
                              style: TextStyle(fontWeight: FontWeight.bold,color: ColorCodes.greenColor),
                            ),
                          ),
                          Spacer(),
                        IconButton(onPressed: (){
                          Navigator.of(context).pushNamed(Refund_screen.routeName,
                              arguments: {
                                "orderid": orderid,
                                "total": total.toString(),

                              });
                        },
                            icon: new Icon(Icons.arrow_forward_ios,
                              color: ColorCodes.greenColor,))

                          // Text(
                          //   IConstants.currencyFormat + " " + total.toStringAsFixed(2),/*orderitemData.vieworder[0].itemototalamount,*/
                          //   style: TextStyle(
                          //     color: ColorCodes.mediumBlueColor,
                          //   ),
                          //),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            // if(Features.isReturnOrExchange)
            //   _showReturn?
            //   GestureDetector(
            //     onTap: () {
            //       _dialogforReturn(context);
            //     },
            //     child: Container(
            //       height:50 ,
            //       width: MediaQuery.of(context).size.width - 20,
            //       color: ColorCodes.lightBlueColor,
            //       child: Center(child: Text(
            //          S.of(context).return_exchange,
            //        //   'Return or Exchange'
            //           style: TextStyle
            //         ( fontSize: 14,color:ColorCodes.blackColor,fontWeight: FontWeight.bold))),
            //     ),
            //   ):SizedBox.shrink(),
            //:SizedBox.shrink(),
            SizedBox(height: 10,),
            if(Features.isRepeatOrder)
              (orderitemData.vieworder1[0].ostatus.toLowerCase() == "delivered" || orderitemData.vieworder1[0].ostatus.toLowerCase() == "completed")?
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _dialogforProcessing();
                    _repeatOrder();
                  },
                  child: Container(
                    height:50 ,
                    width: MediaQuery.of(context).size.width - 20,
                    color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.repeat, color:ColorCodes.blackColor),
                        ),
                        Text(
                          S.of(context).repeat_order,
                          // 'REPEAT ORDER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color:ColorCodes.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  :
              SizedBox.shrink(),
            _isWeb? SizedBox(
              height: 10.0,
            ):SizedBox.shrink(),

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
          onPressed: () {

            if(prev =="splashNotification") {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            } else if(prev == "orderConfirmation"){
              /*Navigator.pushReplacementNamed(context, MyorderScreen.routeName,
               arguments: {
                 "orderhistory": "orderhistoryScreen"
               });*/
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              // return Future.value(false);
            }else if(prev == "weborderConfirmation"){
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            }
            else if(prev == "pushNotificationScreen"){
              Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
            } else if(prev == "webmyOrders"){
              debugPrint("web.....");
              Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName,(route) => false,arguments: {
                "orderhistory": "web"
              });
            }
            else{
              if(_isWeb ){
                debugPrint("clicked.....else");
                Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName,(route) => false,arguments: {
                  "orderhistory": ""
                });

                /*  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
              }
              else{
                Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName,(route) => false,arguments: {
                  "orderhistory": ""
                });
              }

            }
            return Future.value(true);


            // if(prev =="splashNotification") {
            //   Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            // } else if(prev == "orderConfirmation"){
            //  // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            //   Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            //  /* Navigator.of(context).pushNamed(
            //     MyorderScreen.routeName,
            //     arguments: {
            //       "orderhistory": "orderhistoryScreen"
            //     }
            //   );*/
            // }
            // else if(prev == "pushNotificationScreen"){
            //   Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
            // }
            // else{
            //   Navigator.of(context).pop();
            // }
            //
            //
            // //Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName, (route) => false);
          }
      ),
      title: Text(
          S.of(context).order_details,
      //  'Orders Details',
        style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),),
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorCodes.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 5),
              )
            ],
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

  ShowpopupforReview() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(

          title: Column(
            children: [
              Center(
                child: Image.asset(
                  Images.logoImg,
                  height: 50,
                  width: 138,
                ),
              ),
              SizedBox(height: 15,),
              Text(
                  S.of(context).enjoying
                //  "Enjoying "
                  + IConstants.APP_NAME + "?"),
            ],
          ),
          content: Text(_isIOS ? S.of(context).if_enjoying
         // "If you enjoy using "
              + IConstants.APP_NAME + S.of(context).wouldyou_mind_rating_appstore
            //  " app, would you mind rating us on App Store then?"
              :
          //"If you enjoy using "
          S.of(context).if_enjoying

              + IConstants.APP_NAME +
              //" app, would you mind rating us on Play Store then?"
              S.of(context).wouldyou_mind_rating_playstore
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                 // 'Rate Us'
                  S.of(context).rate_us),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  if (Platform.isIOS) {
                    LaunchReview.launch(
                        writeReview: false, iOSAppId: IConstants.appleId);
                  } else {
                    LaunchReview.launch();
                  }
                }catch(e){};
                //launch("https://play.google.com/store/apps/details?id=" + IConstants.androidId);
              },
            ),
            FlatButton(
              child: Text( S.of(context).no_thanks),
                 // 'No, Thanks'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}