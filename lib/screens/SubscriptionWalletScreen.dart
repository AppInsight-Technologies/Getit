import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../generated/l10n.dart';
import '../screens/Payment_SubscriptionScreen.dart';
import '../screens/subscribe_screen.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import 'dart:io';

import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../controller/payment/payment_contoller.dart';

class SubscriptionWalletScreen extends StatefulWidget {
  static const routeName = '/subscription-wallet-screen';
  @override
  _SubscriptionWalletScreenState createState() => _SubscriptionWalletScreenState();
}

class _SubscriptionWalletScreenState extends State<SubscriptionWalletScreen> {
  //SharedPreferences prefs;

  double walletbalance = 0;
  bool notransaction = true;
  bool checkskip = false;
  bool _isWeb =false;
  int _groupValue = 1;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool iphonex = false;
  var name, email = "", photourl = "", phone = "";
  final TextEditingController moneycontroller = new TextEditingController();
  var startDate,endDate,itemCount,deliveries,itemname,itemprice,itemqty,address,paymentMode,addressid,schedule,useraddtype;
  var totalamount;

  var itemid;
  var itemimg;
  var varprice;
  var varname;
  var cronTime;
  var varid ;
  var varmrp;


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

      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      moneycontroller.text = routeArgs["total"];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    addressid = routeArgs['addressid'];
    startDate=routeArgs["startDate"];
    endDate = routeArgs["endDate"];
    itemCount=routeArgs["itemCount"];
    deliveries=routeArgs["deliveries"];
    itemname =routeArgs["itemname"];
    itemprice= routeArgs["varprice"];
    itemqty= routeArgs["varname"];
    address= routeArgs["address"];
    paymentMode=routeArgs["paymentMode"];
    totalamount = routeArgs["total"];
    useraddtype= routeArgs["useraddtype"];
    itemname = routeArgs["itemname"];
    itemid = routeArgs["itemid"];
    itemimg = routeArgs["itemimg"];
    cronTime= routeArgs['cronTime'].toString();
    name = routeArgs['name'].toString();
    varid = routeArgs['varid'].toString();
    varmrp = routeArgs['varmrp'].toString();
    schedule = routeArgs['schedule'];

    int total=0;
    Widget _myRadioButton({int value, Function onChanged}) {

      return Radio(
        activeColor: Theme.of(context).primaryColor,
        value: value,
        groupValue: _groupValue,
        onChanged: onChanged,
      );
    }
    bottomNavigationbar() {

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Row(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width * 40 / 100,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).total,//'Total: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    IConstants.currencyFormat + " " + totalamount,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {

                  if(moneycontroller.text == "" ) {
                    Fluttertoast.showToast(msg: S.of(context).please_return_amount_add,//"Please return amount to add"
                    );

                  }else if(double.parse(moneycontroller.text) < double.parse(routeArgs['total'])){
                    Fluttertoast.showToast(msg: S.of(context).wallet_amount_less,//"Your wallet amount is less than total amount. Please add sufficient amount"
                    );
                  }else{

                  }
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width * 60 / 100,
                height: 50,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 17,
                    ),
                    Center(
                      child: Text(
                        S.of(context).proceed_pay,//'PROCEED TO PAY',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,

        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
            onPressed: () {
              Navigator.of(context).pushNamed(
                  PaymenSubscriptionScreen.routeName,
                  arguments: {
                    "addressid":addressid.toString(),
                    "useraddtype": useraddtype.toString(),
                    "startDate":startDate.toString(),
                    "endDate": endDate.toString(),
                    "itemCount": itemCount.toString(),
                    "deliveries": deliveries.toString(),
                    "total": routeArgs['subscriptionAmount'].toString(),
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

                    // "varid": routeArgs['varid'].toString(),
                  }
              );
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(S.of(context).subscription_wallet_screen,//"Subscription Wallet Screen",
          style: TextStyle(color: ColorCodes.menuColor),),
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
    Widget _bodyMobile(){
     return Container(

       child: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Card(
                 shape: RoundedRectangleBorder(
                   side:
                   BorderSide(color: ColorCodes.lightGreyWebColor, width: 1),
                 ),
                 margin: EdgeInsets.only(left: 12, right: 12, bottom: 12, top:30),
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: <Widget>[
                       Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             //SizedBox(height: 10,),
                             Row(
                               children: [
                                 Column(
                                   children: [
                                     Text(
                                       IConstants.currencyFormat +" "+walletbalance.toString(),
                                       style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.black),
                                     ),
                                     SizedBox(height: 5,),
                                     Text(
                                       S.of(context).wallet_balance,//"Wallet Balance",
                                       style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.black),
                                     ),
                                   ],
                                 ),

                               ],
                             ),

                           ]),
                       Container(
                         height: 60.0,
                         child: VerticalDivider(
                           color: ColorCodes.greyColor,
                           thickness: 1.5,
                         ),
                       ),
                       Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             //SizedBox(height: 10,),
                             Row(
                               children: [
                                 Column(
                                   children: [
                                     Text(
                                       IConstants.currencyFormat +" "+walletbalance.toString(),
                                       style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.black),
                                     ),
                                     SizedBox(height: 5,),
                                     Text(
                                       S.of(context).reserved_balance,//"Reserved Balance",
                                       style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.black),
                                     ),
                                   ],
                                 ),

                               ],
                             ),
                             SizedBox(
                               height: 5,
                             ),

                           ]),
                     ],
                   ),
                 )
             ),
             SizedBox(height: 20,),
             Row(
               children: [
                 SizedBox(width: 12,),
                 Text(S.of(context).add_money,//"Add Money",
                   style: TextStyle(fontWeight: FontWeight.w600,
                       fontSize: 18,
                       color: ColorCodes.blackColor

                   ),
                   textAlign: TextAlign.left,
                 ),
               ],
             ),
             SizedBox(height: 10,),
             Column(
               children: [
                 SizedBox(height: 10,),
                 Container(
                   //color: ColorCodes.whiteColor,
                   margin: EdgeInsets.only(left: 12, right: 12),
                   height:60,
                   child: TextFormField(
                     textAlign: TextAlign.left,
                     controller: moneycontroller,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       hintText: IConstants.currencyFormat + "0",

                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6),
                         borderSide: BorderSide(color: Colors.grey),
                       ),
                       errorBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6),
                         borderSide: BorderSide(color: ColorCodes.primaryColor),
                       ),
                       focusedErrorBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6),
                         borderSide: BorderSide(color: ColorCodes.primaryColor),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6),
                         borderSide: BorderSide(color: ColorCodes.primaryColor),
                       ),
                     ),
                     onSaved: (value) {
                       addMoneyToSF(value);
                     },
                   ),
                 ),
                 SizedBox(height: 20,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           total=total+1000;
                           debugPrint("total....."+total.toString());
                           moneycontroller.text = "1000";
                         });
                       },
                       child: Container(
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey),
                             borderRadius: BorderRadius.circular(10.0),
                             color: Theme.of(context).buttonColor,
                           ),
                           height: 40,
                           width: 80,
                           alignment: Alignment.center,
                           child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).thousand,//"1000"
                           )
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         moneycontroller.text = "2000";
                       },
                       child: Container(
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey),
                           borderRadius: BorderRadius.circular(10.0),
                           color: Theme.of(context).buttonColor,
                         ),
                         height: 40,
                         width: 80,
                         alignment: Alignment.center,
                         child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).two_thousand,//"2000"
                         )
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         moneycontroller.text = "3000";
                       },
                       child: Container(
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey),
                             borderRadius: BorderRadius.circular(10.0),
                             color: Theme.of(context).buttonColor,
                           ),
                           height: 40,
                           width: 80,
                           alignment: Alignment.center,
                           child: Text("+"+" "+ IConstants.currencyFormat +
                               S.of(context).three_thousand,//"3000"
                           )
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         moneycontroller.text = "4000";
                       },
                       child: Container(
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey),
                             borderRadius: BorderRadius.circular(10.0),
                             color: Theme.of(context).buttonColor,
                           ),
                           height: 40,
                           width: 80,
                           alignment: Alignment.center,
                           child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).four_thousand,//"4000"
                           )
                       ),
                     ),
                   ],
                 ),

               ],
             ),
             SizedBox(height: 30,),

             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left:12.0),
                   child: Text(
                     S.of(context).payment_mode,//"Payment Mode",
                     style: TextStyle(fontWeight: FontWeight.w600,
                         fontSize: 18,
                         color: ColorCodes.blackColor

                     ),
                     textAlign: TextAlign.left,
                   ),
                 ),
                 SizedBox(height: 20,),
                 Padding(
                   padding: const EdgeInsets.only(left: 12.0),
                   child: ListTile(
                     onTap: (){
                       setState(() {
                         _groupValue = 1;
                       });
                     },
                     dense: true,
                     leading:  Container(
                       child: _myRadioButton(
                         value: 1,
                         onChanged: (newValue) {
                           setState(() {
                             _groupValue = newValue;
                           });
                         },
                       ),
                     ),
                     contentPadding: EdgeInsets.all(0.0),
                     title: Text(
                         S.of(context).online_payment,//'Online Payment',
                         style: TextStyle(
                             color: ColorCodes.blackColor,
                             fontSize: 16, fontWeight: FontWeight.bold
                         )
                     ),
                   ),
                 ),
               ],
             ),

             // SizedBox(height: 30,),
             // Column(
             //   mainAxisAlignment: MainAxisAlignment.start,
             //   crossAxisAlignment: CrossAxisAlignment.start,
             //   children: [
             //
             //     Row(
             //       children: [
             //         SizedBox(width: 12,),
             //         Text(S.of(context).wallet_history,//"Wallet History",
             //           style: TextStyle(fontWeight: FontWeight.bold,
             //               fontSize: 18,
             //               color: ColorCodes.blackColor
             //
             //           ),
             //           textAlign: TextAlign.left,
             //         ),
             //       ],
             //     ),
             //     SizedBox(height: 5,),
             //     Row(
             //       children: [
             //         SizedBox(width: 12,),
             //         Text(S.of(context).recent_transaction,//"Your recent transactions will show here",
             //           style: TextStyle(fontWeight: FontWeight.bold,
             //               fontSize: 12,
             //               color: ColorCodes.blackColor
             //
             //           ),
             //           textAlign: TextAlign.left,
             //         ),
             //       ],
             //     ),
             //   ],
             // ),
             // SizedBox(height: 10,),
             // Column(
             //   children: [
             //     SizedBox(height: 10,),
             //     Row(
             //       mainAxisAlignment: MainAxisAlignment.center,
             //       crossAxisAlignment: CrossAxisAlignment.center,
             //       children: [
             //         SizedBox(width: 10,),
             //         Expanded(
             //           child: Container(
             //             //width: MediaQuery.of(context).size.width * 60 / 100,
             //             child: Text("")
             //           ),
             //         ),
             //
             //       ],
             //     ),
             //     SizedBox(height: 10,),
             //   ],
             // ),
           ],
         ),
       ),
     );
    }
    Widget  _bodyWeb(){
      return Expanded(

        child: SingleChildScrollView(
          child: Container(
            color: ColorCodes.whiteColor,
            // height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                      side:
                      BorderSide(color: ColorCodes.lightGreyWebColor, width: 1),
                    ),
                    margin: EdgeInsets.only(left: 12, right: 12, bottom: 12, top:30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          IConstants.currencyFormat +" "+walletbalance.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          S.of(context).wallet_balance,//"Wallet Balance",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),

                              ]),
                          Container(
                            height: 60.0,
                            child: VerticalDivider(
                              color: ColorCodes.greyColor,
                              thickness: 1.5,
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          IConstants.currencyFormat +" "+walletbalance.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          S.of(context).reserved_balance,//"Reserved Balance",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                              ]),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 12,),
                    Text(S.of(context).add_money,//"Add Money",
                      style: TextStyle(fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: ColorCodes.blackColor

                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      height:60,
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        controller: moneycontroller,
                        decoration: InputDecoration(
                          hintText: IConstants.currencyFormat + "0",

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.primaryColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.primaryColor),
                          ),
                        ),
                        onSaved: (value) {
                          addMoneyToSF(value);
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              total=total+1000;
                              debugPrint("total....."+total.toString());
                              moneycontroller.text = "1000";
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).buttonColor,
                              ),
                              height: 40,
                              width: 80,
                              alignment: Alignment.center,
                              child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).thousand,//"1000"
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            moneycontroller.text = "2000";
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).buttonColor,
                              ),
                              height: 40,
                              width: 80,
                              alignment: Alignment.center,
                              child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).two_thousand,//"2000"
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            moneycontroller.text = "3000";
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).buttonColor,
                              ),
                              height: 40,
                              width: 80,
                              alignment: Alignment.center,
                              child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).three_thousand,//"3000"
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            moneycontroller.text = "4000";
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).buttonColor,
                              ),
                              height: 40,
                              width: 80,
                              alignment: Alignment.center,
                              child: Text("+"+" "+ IConstants.currencyFormat + S.of(context).four_thousand,//"4000"
                              )
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: 30,),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:12.0),
                      child: Text(S.of(context).payment_mode,//"Payment Mode",
                        style: TextStyle(fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: ColorCodes.blackColor

                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: ListTile(
                        onTap: (){
                          setState(() {
                            _groupValue = 1;
                          });
                        },
                        dense: true,
                        leading:  Container(
                          child: _myRadioButton(
                            value: 1,
                            onChanged: (newValue) {
                              setState(() {
                                _groupValue = newValue;
                              });
                            },
                          ),
                        ),
                        contentPadding: EdgeInsets.all(0.0),
                        title: Text(
                            S.of(context).online_payment,//'Online Payment',
                            style: TextStyle(
                                color: ColorCodes.blackColor,
                                fontSize: 16, fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        SizedBox(width: 12,),
                        Text(S.of(context).wallet_history,//"Wallet History",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: ColorCodes.blackColor

                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        SizedBox(width: 12,),
                        Text(S.of(context).recent_transaction,//"Your recent transactions will show here",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: ColorCodes.blackColor

                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            //width: MediaQuery.of(context).size.width * 60 / 100,
                              child: Text("")
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).primaryColor,
                        width: MediaQuery.of(context).size.width * 40 / 100,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).total,//'Total: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              IConstants.currencyFormat + totalamount,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(paymentMode == "1"){
                            if(_groupValue == 1){
                              payment.startPaytmTransaction(context,  _isWeb,orderId: "", username: PrefUtils.prefs.getString('apikey'),amount: (itemprice*itemCount), routeArgs: routeArgs);
                            }else{
                              Fluttertoast.showToast(msg: S.of(context).select_payment_mode,//"Select Payment mode"
                              );
                            }
                          }else{
                            if(moneycontroller.text == ""){
                              Fluttertoast.showToast(msg: S.of(context).please_return_amount_add,//"Please return amount to add"
                              );
                            }else if(_groupValue == 1){
                              payment.startPaytmTransaction(context, _isWeb, orderId: "", username: PrefUtils.prefs.getString('apikey'),amount: moneycontroller.text, routeArgs: routeArgs);
                            }else{
                              Fluttertoast.showToast(msg: S.of(context).select_payment_mode,//"Select Payment mode"
                              );
                            }
                          }

                        },
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 60 / 100,
                          height: 50,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 17,
                              ),
                              Center(
                                child: Text(
                                  S.of(context).proceed_pay,//'PROCEED TO PAY',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
              ],
            ),
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushNamed(
            PaymenSubscriptionScreen.routeName,
            arguments: {
            "addressid":addressid.toString(),
            "useraddtype": useraddtype.toString(),
            "startDate":startDate.toString(),
            "endDate": endDate.toString(),
            "itemCount": itemCount.toString(),
            "deliveries": deliveries.toString(),
            "total": routeArgs['subscriptionAmount'].toString(),
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

             // "varid": routeArgs['varid'].toString(),
            }
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            _isWeb? _bodyWeb():Flexible(child: _bodyMobile(),
            )],
        ),
        bottomNavigationBar:  _isWeb ? SizedBox.shrink() :
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child:bottomNavigationbar(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    payment.dispose();
  }

  addMoneyToSF(String value) async {
    PrefUtils.prefs.setString('amount', value);
  }



}
