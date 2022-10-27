import 'dart:io';
import 'package:flutter/gestures.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/myordersfields.dart';
import '../../screens/CodReturnScreen.dart';
import '../../screens/ReturnConfirmation.dart';
import '../../screens/return_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../generated/l10n.dart';

import '../constants/IConstants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/addressitems.dart';
import '../providers/myorderitems.dart';
import '../providers/deliveryslotitems.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../screens/address_screen.dart';
import '../screens/myorder_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import 'orderhistory_screen.dart';

class CodReturnScreen extends StatefulWidget {
  static const routeName = '/codreturn-screen';

  @override
  CodReturnScreenState createState() => CodReturnScreenState();
}

class CodReturnScreenState extends State<CodReturnScreen> {
  int _groupValue = 0;
  //SharedPreferences prefs;
  var _checkaddress = false;
  List popupItems = [];
  var addressitemsData;
  var deliveryslotData;
  var addtype;
  var address;
  IconData addressicon;
  var _checkslots = false;
  var date, qty;
  MyorderList orderitemData;
  bool _isLoading = true;
  var box_color = ColorCodes.lightColor;
  bool _isWeb = false;
  MediaQueryData queryData;
  bool _selectitem = false;
  double wid;
  double maxwid;
  bool w = true;
  bool x = false;
  bool y = false;
  bool z = false;
  var note = TextEditingController();
  bool _showCheck=false;
  //var deliverytime=0;
  var returntime=0;
  String reason ;
  String issue ;
  List<String> _issuelist=[];
  String paymentType;
  String amount ="0";
  bool value = false;
  bool walletvalue = false;
  bool agree = false;
  String finalDate;
  final TextEditingController accountcontroller = new TextEditingController();
  final TextEditingController confirmaccountcontroller = new TextEditingController();
  final TextEditingController ifscController = new TextEditingController();
  String An ="", Cn="", In="";
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
    note.text = "";
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

      final routeArgs =
      ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      final orderid = routeArgs['orderid'];
      finalDate      = routeArgs['returnValid'];
      final title = routeArgs['title'];
      debugPrint("esdfgvhbjn"+routeArgs['orderid']);


      Provider.of<MyorderList>(context,listen: false).Vieworders(orderid).then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(
            context,
            listen: false,
          );
          for(int i=0;i<orderitemData.vieworder1.length;i++){
            paymentType = orderitemData.vieworder1[i].opaytype;
            if (orderitemData.vieworder1[i].deliveryOn != "") {
              debugPrint('test..');
              DateTime today = new DateTime.now();
              DateTime orderAdd = DateTime.parse(
                  orderitemData.vieworder1[i].deliveryOn).add(Duration(
                  hours: int.parse(orderitemData.vieworder1[i].returnTime)));
              if ((orderAdd.isAtSameMomentAs(today) || orderAdd.isAfter(today)) &&
                  (orderitemData.vieworder[0].ostatus.toLowerCase() ==
                      "delivered" ||
                      orderitemData.vieworder[0].ostatus.toLowerCase() ==
                          "completed")) {
                debugPrint('test1..');
                if (orderitemData.vieworder1[i].returnTime != "")
                  setState(() {
                    _showCheck = true;
                  });
                if (orderitemData.vieworder1[i].returnTime == "0" ) {
                  setState(() {
                    _showCheck = false;
                  });
                } else {
                  setState(() {
                    _showCheck = false;
                  });
                }
              }
            }
          }

          _isLoading = false;
        });
      });


      addressitemsData =(VxState.store as GroceStore).userData;
      if (addressitemsData.billingAddress.length > 0) {
        _checkaddress = true;
        PrefUtils.prefs.setString("addressId", addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].id);
        addtype = addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].addressType;
        address = addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].address;
        addressicon = addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].addressicon;
       // calldeliverslots("1");
      } else {
        _checkaddress = false;
      }

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final routeArgs =
    ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final orderid = routeArgs['orderid'];
    final title = routeArgs['title'];

    final itemLeftCount = routeArgs['itemLeftCount'];



    _dialogforReturning(BuildContext context) {
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
                    height: 100.0,
                    width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 40.0,
                        ),
                        Text( S.of(context).processing,//'Processing...'
                        ),
                      ],
                    )),
              );
            });
          });
    }

    gradientappbarmobile() {
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
            onPressed: () {
              final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
              Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                'orderid': routeArgs['orderid'],
                'title':S.of(context).returns,
                'orderStatus':routeArgs['orderStatus'],
                'returnValid': routeArgs['returnValid'],
              });
            }),
        title: Text(
          "Order Details",
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
      );
    }


    Widget _bodyMobile(){

      Widget itemsExchange() {
        final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        String image = routeArgs['img'];
        String itemname = routeArgs['itemname'];
        String fit = routeArgs['fit'];
        String size = routeArgs['size'];
        String amount = routeArgs['amount'];
        String qty = routeArgs['quantity'];
        return Column(
          children: [
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
              // margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),

                  Row(
                    children: [
                      Text( "Order Id:"
                          + routeArgs['orderid'],

                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text( routeArgs['Date'],
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(width: 5,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                                    width: 90,
                                    height: 110,),
                                  errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                                    width: 90,
                                    height: 110,),
                                  width: 90,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              )
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/1.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  width:
                                  MediaQuery.of(context).size.width /1.6,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  fit,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 12,color: ColorCodes.greyColor,fontWeight: FontWeight.w700),),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text("Size: " + size, style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Text("| Qty: "+qty, style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  "Refund Amount: "
                                      + amount,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width:MediaQuery.of(context).size.width - 20,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: ColorCodes.returnColl,
                      border: Border.all(
                          color: ColorCodes.discountoff
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10,),
                        Center(
                          child: Text(
                            "Return Valid Till "+ finalDate+".",
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            SizedBox(height: 6,),
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
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text( "How would you like your refund?",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Checkbox(
                          value: this.value,
                          activeColor: ColorCodes.discountoff,
                          onChanged: (bool value) {
                            setState(() {
                              this.value = value;
                            });
                          }),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("IMPS (Bank Transfer)",
                                style: TextStyle(
                                    fontSize: 16,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.bold)),
                            SizedBox(height: 3,),
                            Text("Please enter your bank details for IMPS Transfer.",
                                style: TextStyle(
                                    fontSize: 14,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.left,
                    controller: accountcontroller,
                    style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: ColorCodes.blackColor),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                      hintText:  "Account Number",//'Name',
                      hoverColor: ColorCodes.darkGrey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.3),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                      ),
                    ),
                    onFieldSubmitted: (_) {

                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          An = "Please enter Account Number";
                        });
                        return '';
                      }
                      setState(() {
                        An = "";
                      });
                      return null;
                    },
                    onSaved: (value) {

                    },
                  ),
                  Text(
                    An,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.left,
                    controller: confirmaccountcontroller,
                    style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: ColorCodes.blackColor),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                      hintText:  "Confirm Account Number",//'Name',
                      hoverColor: ColorCodes.darkGrey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.3),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                      ),
                    ),
                    onFieldSubmitted: (_) {

                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          Cn = "Please enter Confirm Account Number";
                        });
                        return '';
                      }else if(accountcontroller.text != value){
                        Cn = "Account Number doesn't match";
                      }
                      setState(() {
                        Cn = "";
                      });
                      return null;
                    },
                    onSaved: (value) {

                    },
                  ),
                  Text(
                    Cn,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10,),
                  Stack(
                    alignment: const Alignment(1.0, 0),
                    children: [
                      TextFormField(
                        textAlign: TextAlign.left,

                        controller: ifscController,
                        style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: ColorCodes.blackColor),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                          hintText:  "IFSC Number",//'Name',
                          hoverColor: ColorCodes.darkGrey,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.5),
                          ),
                        ),
                        onFieldSubmitted: (_) {

                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              In = "Please enter IFSC Number";
                            });
                            return '';
                          }
                          setState(() {
                            In = "";
                          });
                          return null;
                        },
                        onSaved: (value) {

                        },
                      ),
                      GestureDetector(
                        onTap: (){

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("What is IFSC Code?", style: TextStyle(color: ColorCodes.discountoff,
                              fontWeight: FontWeight.bold,),),
                        ),
                      )
                    ],
                  ),
                  Text(
                    In,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6,),
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
              ),
              margin: EdgeInsets.only(bottom: 40),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Checkbox(
                          value: this.walletvalue,
                          activeColor: ColorCodes.discountoff,
                          onChanged: (bool value) {
                            setState(() {
                              this.walletvalue = value;
                            });
                          }),
                      SizedBox(width: 5,),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(IConstants.APP_NAME+" Wallet",
                                style: TextStyle(
                                    fontSize: 16,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.bold)),
                            SizedBox(height: 3,),
                            Text("The refund will be credited in your "+ IConstants.APP_NAME+"Wallet in the form of cash which will never expire & can be used for future shopping on "+IConstants.APP_NAME+".",
                                style: TextStyle(
                                    fontSize: 14,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Checkbox(
                          value: this.agree,
                          onChanged: (bool value) {
                            setState(() {
                              this.agree = value;
                            });
                          }),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Text("I agree that the product is unused with original tags intact.",
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 14,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                itemsExchange(),
                SizedBox(height: 20.0,),
               // proceed(),
                SizedBox(height: 10.0,),
                if (_isWeb)
                  Footer(
                      address: PrefUtils.prefs.getString("restaurant_address")),
              ],
            ),
          ),
        ),
      );
    }



    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? gradientappbarmobile()
          : null,
      // backgroundColor: ColorCodes.whiteColor,
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false, false),
          /*(_isWeb && !ResponsiveLayout.isSmallScreen(context))?_bodyWeb():*/_bodyMobile(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isWeb ? SizedBox.shrink() : Container(
        child: _isLoading?
        SizedBox.shrink():
        Container(
          height: 53,
          margin: EdgeInsets.all(10),

          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
                  Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                    'orderid': routeArgs['orderid'],
                    'title':S.of(context).returns,
                    'orderStatus':routeArgs['orderStatus'],
                    'returnValid': routeArgs['returnValid'],
                  });
                },
                child: Container(
                  height: 53,
                    width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(10.0),bottomLeft:Radius.circular(10.0) ),
                    color: ColorCodes.whiteColor,
                  ),
                  child: Center(
                    child: Text("Back",
                      style: TextStyle(
                        fontSize: 18,

                        color: ColorCodes.discountoff,
                        //color: ColorCodes.discount,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {

                    List array = [];
                    String orderid;
                    String itemname;
                    bool _selectitem = false;
                   if(!value || !walletvalue){
                      Fluttertoast.showToast(
                        msg:
                        "Please select any one refund type",
                        fontSize: MediaQuery
                            .of(context)
                            .textScaleFactor * 13,);
                    }else if(!agree){
                      Fluttertoast.showToast(
                          msg: "Please click agree checkbox",
                          fontSize: MediaQuery
                              .of(context)
                              .textScaleFactor * 13);
                    }
                    else {
                        _dialogforReturning(context);
                        Provider.of<MyorderList>(
                            context, listen: false)
                            .ReturnItem(
                            array.toString(), orderid, itemname,reason,issue,note.text)
                            .then((_) {
                          Provider.of<MyorderList>(
                              context, listen: false)
                              .Vieworders(orderid)
                              .then((_) {
                            setState(() {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushReplacementNamed(
                                ReturnconfirmationScreen.routeName,arguments: {
                                "title": "Return"
                              }
                              );
                            });
                          });
                        });
                      }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.02,
                  height: 53.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorCodes.discountoff,
                  ),
                  child: Center(
                      child: Text(
                         "Return",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<MyordersFields> _getBrandsList(String newValue) async {
    _issuelist.clear();
    for (MyordersFields element in orderitemData.reasons) {
      if(element.title == newValue){
        setState(() {
          issue = null;
          reason = newValue;
          _issuelist = element.options;
        });
        print(reason);
      }
    }
  }
}
