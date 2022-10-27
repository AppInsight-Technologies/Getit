import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../providers/myorderitems.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class Refund_screen extends StatefulWidget {
  static const routeName = '/refundscreen';
  const Refund_screen({Key key}) : super(key: key);


  @override
  Refund_screenState createState() => Refund_screenState();

}

class Refund_screenState extends State<Refund_screen> {

  String id;
  String itemid;
  String itemname;
  String varname;
  String price;
  String qty;
  String itemoactualamount;
  String discount;
  double subtotal = 0.0;
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
  var refunditemData;
  String total = "";

@override
  void initState() {

    // TODO: implement initState

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
    final routeArgs = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;

    orderid = routeArgs['orderid'];
    total = routeArgs['total'];
    print("orderid"+total.toString());
   await  Provider.of<MyorderList>(context,listen: false).Refund(orderid).then((_) {
      refunditemData = Provider.of<MyorderList>(context, listen: false,);

      if(refunditemData.refundorder.length > 0) {
        setState(() {
          _isLoading = false;
        });
        for(int i = 0 ;i < refunditemData.refundorder.length; i++){
           subtotal = subtotal + double.parse(refunditemData.refundorder[i].refund);
          }
        //subtotal = refunditemData.refundorder[0].subtotal.toString();
        print("redfunda data ....." + subtotal.toString());
        print("redfunda data ....." + subtotal.toString());
        setState(() {
          _isLoading = false;
        });
      }
      else{
        setState(() {
          _isLoading =false;
        });
      }

    });



  });
  super.initState();
  }
  @override
  Widget build(BuildContext context) {

  /*  final routeArgs = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;

    orderid = routeArgs['orderid'];
    total = routeArgs['total'];
    print("orderid"+total.toString());
*/

    return WillPopScope(
      onWillPop: () {
        // this is the block you need
        if(prev !="splashNotification") {
        } else {
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          return Future.value(false);
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


    return _isLoading?
        ItemListShimmer():
      Expanded(
      child: Container(
       // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        /*decoration: BoxDecoration(
          color: Color(0xffF1F1F1),
        ),*/
        child: SingleChildScrollView(
          child: Column(
            children: [

                   viewOrder(),
              SizedBox(height: 10,),
                  DisplayImage(),
              SizedBox(height: 40,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs.getString("restaurant_address")/*PrefUtils.prefs.getString("restaurant_address")*/),
            ],
          ),
        ),
      ),
    );
  }


  Widget viewOrder() {

    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
   /* if(refunditemData.refundorder[0].itemodelcharge !=0){
      total= double.parse(refunditemData.refundorder[0].itemoactualamount) +
          double.parse(refunditemData.refundorder[0].itemodelcharge) -refunditemData.refundorder[0].loyalty
          - double.parse(refunditemData.refundorder[0]);
    }
    else{
      total= double.parse(refunditemData.refundorder[0]) -refunditemData.refundorder[0].loyalty
          - double.parse(refunditemData.refundorder[0].totalDiscount);
    }
    print("total discoun"+refunditemData.refundorder[0].totalDiscount.toString());*/
  //  String total_saving=(orderitemData.vieworder[0].promocode_discount + orderitemData.vieworder[0].membership_earned).toString();
    //print("total discoun"+orderitemData.vieworder[0].totalDiscount.toString());
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
        child: Column(
          children: [

            SizedBox(height:30),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(
                        S.of(context).refund_orderid
                        //"Ordered Id : "
                        ,
                        style: TextStyle(color: ColorCodes.blackColor),
                      ),
                      Spacer(),
                      Text(
                        orderid,
                        style: TextStyle(color: ColorCodes.blackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        //"Order Date",
                        S.of(context).refund_order_date,

                        style: TextStyle(color: ColorCodes.blackColor),
                      ),
                      Spacer(),
                      Text(
                          refunditemData.refundorder[0].odate.toString(),
                        style: TextStyle(color: ColorCodes.blackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        //"Order Amount",
                        S.of(context).order_amt,
                        style: TextStyle(color: ColorCodes.blackColor),
                      ),
                      Spacer(),
                      Text(
                        IConstants.currencyFormat+double.parse(total.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(color: ColorCodes.blackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 /* Row(
                    children: [
                      Text(
                        S.of(context).short_delivery,
                        //"Short Delivery",
                        style: TextStyle(color: Color(0xff6A6A6A)),
                      ),
                      Spacer(),
                      Text(

                          subtotal,// "1.92",
                        style: TextStyle(color: Color(0xff6A6A6A)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),*/
                  Row(
                    children: [
                      Text(
                        S.of(context).total_refund,
                        //"Total Refund ",
                        style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        IConstants.currencyFormat + subtotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),//"1.92",
                        style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Text(
                        S.of(context).refund_mode,
                       // "Refund Mode",
                        style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      //double.parse(orderitemData.vieworder[0].itemodelcharge) == 0.0 ?
                      Spacer(),
                      Text(
                        refunditemData.refundorder[0].paymentType.toString(),
                        //"Wallet",
                        style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(height:10),

            /*Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.all(15),
              child: SizedBox(
                child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                   itemCount: refunditemData.refundorder.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      OrderhistoryDisplay(
                        refunditemData.refundorder[i].itemname,
                        refunditemData.refundorder[i].varname,
                        refunditemData.refundorder[i].price,
                        refunditemData.refundorder[i].qty,
                        refunditemData.refundorder[i].subtotal,
                        refunditemData.refundorder[i].itemImage,
                        refunditemData.refundorder[i].extraAmount,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),*/


          ],
        ),
      ),
    );
  }
  Widget DisplayImage(){
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
        child: Column(
          children: [
           /* Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(
                  S.of(context).item_details,
                  //"Item Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),*/
            SizedBox(height:10),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: refunditemData.refundorder.length,
                  itemBuilder: (_, i) {
                return Container(
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Column(
                            children: [
                              SizedBox(height: 10,),
                              Container(child:

                              CachedNetworkImage(
                                imageUrl: refunditemData.refundorder[i].itemImage,
                                placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                                  width: 80,
                                  height: 80,),
                                errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                                  width: 80,
                                  height: 80,),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                             // Image.network(refunditemData.refundorder[i].itemImage,height: 80,width: 80,fit: BoxFit.fill,)),
                            )],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            refunditemData.refundorder[i].itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14,
                                                //fontWeight: FontWeight.w600,
                                                color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            refunditemData.refundorder[i].varname,
                                            style: TextStyle(
                                                fontSize: 12,
                                               // fontWeight: FontWeight.w400,
                                                color: ColorCodes.greyColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                         S.of(context).order_qty//"Order Qty : "
                                             + refunditemData.refundorder[i].refundqty,
                                          style: TextStyle(
                                              fontSize: 13,
                                              //fontWeight: FontWeight.w400,
                                              color: ColorCodes.greyColor),
                                        ),

                                        Container(
                                          height: 25,
                                          child: VerticalDivider(
                                            color: ColorCodes.greyColor,
                                            endIndent: 8,
                                            thickness: 1,
                                            indent: 8,
                                          ),
                                        ),
                                        Text(
                                          S.of(context).order_amt + " : "//"Order Amount : "
                                              + IConstants.currencyFormat + double.parse(refunditemData.refundorder[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              fontSize: 13,
                                              //fontWeight: FontWeight.w400,
                                              color: ColorCodes.greyColor),
                                        ),
                                      ],
                                    ),

                                  ])),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(
                             S.of(context).status,// "Status",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                 // fontWeight: FontWeight.w600,
                                  color: ColorCodes.greyColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              S.of(context).refund_amount,//"Refund Amount",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                 // fontWeight: FontWeight.w600,
                                  color: ColorCodes.greyColor),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              IConstants.currencyFormat + double.parse(refunditemData.refundorder[i].refund).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  //fontWeight: FontWeight.w600,
                                  color: ColorCodes.greenColor),
                            ),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                );
                 }
              ),


          ],
        ),
      ),
              ]
    )));
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
            if(prev !="splashNotification") {
              Navigator.of(context).pop();
            } else {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            }
            //Navigator.pushNamedAndRemoveUntil(context, MyorderScreen.routeName, (route) => false);
          }
      ),
      title: Text(
        S.of(context).refund_details
       // "Refund Details"
        ,
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

}
