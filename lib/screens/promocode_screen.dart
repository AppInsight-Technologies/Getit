import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/api.dart';
import '../../data/calculations.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../providers/myorderitems.dart';

import '../../screens/payment_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/simmers/item_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class PromocodeScreen extends StatefulWidget{
  static const routeName = '/promocode-screen';
  @override
  PromocodeScreenState createState() => PromocodeScreenState();
}

class PromocodeScreenState extends State<PromocodeScreen>{
  bool _isLoading = true;
  bool _isWeb = false;
  bool iphonex = false;
  var promocodeData;
  double maxwid;
  double wid;
  MediaQueryData queryData;
  Future<List<Promocode>> _future = Future.value([]);
 final TextEditingController promocontroller = new TextEditingController();
 //  String promocontroller = "";
  String membershipvx=(VxState.store as GroceStore).userData.membership;
  List<CartItem> productBox=[];
  String promovarprice;
  double deliveryAmt = 0;

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

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
     /* Provider.of<MyorderList>(context,listen: false).GetPromoCode().then((_) {
        promocodeData = Provider.of<MyorderList>(context, listen: false);
        setState(() {
          _isLoading = false;
        });
      });*/

      MyorderList().GetPromoCode().then((value) {

        setState(() {
          _future = Future.value(value);
          _isLoading = false;
        });
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        Navigator.of(context).pushReplacementNamed(
            PaymentScreen.routeName,
            arguments: {
              'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
              'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
              'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
              'deliveryChargePrime': routeArgs['deliveryChargePrime'],
              'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
              'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
              'deliveryType': routeArgs['deliveryType'],
              'addressId': PrefUtils.prefs.getString("addressId"),
              'note': routeArgs['note'],
              'deliveryCharge': routeArgs['deliveryCharge'],
              'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'],
              'fromScreen':'',
              'responsejson':"",
            });
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        body: _isLoading ? _isWeb?Center(
          child: CircularProgressIndicator(),
        ):ItemListShimmer()
            :
        _body(),
      ),
    );
  }
  _body(){


    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false, false),

          Container(
            child: FutureBuilder<List<Promocode>>(
              future: _future,
              builder: (BuildContext context,AsyncSnapshot<List<Promocode>> snapshot){
                final promoData = snapshot.data;
             // print("snapshot.data...."+promoData.length.toString());

                  return _isWeb?
                  SingleChildScrollView(
                      child:
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                              height: _isWeb?MediaQuery.of(context).size.height*0.60
                                  :MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: ColorCodes.searchwebbackground,
                              child: new ListView.builder(
                                  itemCount: promoData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      child: Text("edjhcbfhjc"),
                                    ) ;
                                  }),
                            ),

                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //footer
                          if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
                        ],
                      )
                  ) :
                  SingleChildScrollView(
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              TextFormField(
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                                      controller: promocontroller,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                        hintText: "Enter Coupon Code",
                                        hintStyle: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w800, fontSize: 16,),
                                        hoverColor: ColorCodes.greenColor,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.6),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.6),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.6),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: ColorCodes.greyColor, width: 0.6),
                                        ),
                                          suffixIcon:  Container(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap:() {
                                                    checkPromo(promocontroller.text);
                                                  },
                                                  child: Text(
                                                      "Apply",
                                                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800, fontSize: 17,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                      ),
                                      onSaved: (value) {
                                        //addFirstnameToSF(value);
                                      },
                                    ),
                              SizedBox(height: 20,),
                              if(promoData!=null) Container(
                                width: MediaQuery.of(context).size.width,
                                  height: 30,
                                child: Text("Available Coupons", style: TextStyle(color: ColorCodes.blackColor, fontSize: 20,fontWeight: FontWeight.bold),)
                              ),
                              SizedBox(height: 10,),
                              if(promoData!=null)SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: promoData.length,
                                    itemBuilder: (BuildContext context, int index) {


                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(

                                            children: [

                                              Container(
                                                height:40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: ColorCodes.starColor,
                                                  ),
                                                  color: ColorCodes.promocolor,
                                                ),
                                                child: Row(
                                                  children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                                        child: Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.blackColor),
                                                      ),
                                                    VerticalDivider(color: ColorCodes.starColor,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                                      child: Text(promoData[index].promocode, style: TextStyle(color: ColorCodes.blackColor, fontSize: 15,fontWeight: FontWeight.bold),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                             // SizedBox(width: 120,),
                                            Spacer(),
                                              GestureDetector(
                                                onTap: (){
                                                  //checkPromo(promoData[index].promocode);
                                                  setState(() {
                                                    checkPromo(promoData[index].promocode);
                                                  });

                                                 // dialogforPopup(promoData[index].promocode);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                                  child: Text("APPLY",
                                                    style: TextStyle(color: ColorCodes.discountoff, fontSize: 15,fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Text(promoData[index].description, style: TextStyle(color: ColorCodes.blackColor, fontSize: 15,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 10,),
                                          Divider(color: ColorCodes.grey,thickness: 1,),
                                          SizedBox(height: 5,),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
               /* else
                  return Expanded(
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Align(
                        // heightFactor: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              Images.nowishlistfound,
                              fit: BoxFit.fill,
                              height: 250.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Center(
                                child: Text(
                                  "No Promocode found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                )),
                            SizedBox(
                              height:20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );*/

              },
            ),
          ),
        ],),
    );
  }
  gradientappbarmobile() {

    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: (){
        final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        Navigator.of(context).pushReplacementNamed(
            PaymentScreen.routeName,
            arguments: {
              'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
              'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
              'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
              'deliveryChargePrime': routeArgs['deliveryChargePrime'],
              'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
              'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
              'deliveryType': routeArgs['deliveryType'],
              'addressId': PrefUtils.prefs.getString("addressId"),
              'note': routeArgs['note'],
              'deliveryCharge': routeArgs['deliveryCharge'],
              'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'],
              'fromScreen':'',
              'responsejson':"",
            });
      }),
      title: Text("Apply Coupons",
        style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),
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

  dialogforPopup(String promocode, String amount, String responsejson) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(

          onWillPop: () {
           // SystemNavigator.pop();
            return Future.value(false);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.appLoyalty,
              height: 100,
              width: 138,
              color: ColorCodes.discountoff,
            ),
            content: Container(
              height: 180,
              child: Column(
                children: [
                  Text(" \'" + promocode + " \'"+ " "+"applied",style: TextStyle(color: ColorCodes.blackColor, fontSize: 25,fontWeight: FontWeight.bold), ),
                  SizedBox(height: 5,),
                  Text(IConstants.currencyFormat+" "+ amount,style: TextStyle(color: ColorCodes.blackColor, fontSize: 40,fontWeight: FontWeight.bold), ),
                  SizedBox(height: 5,),
                  Text("savings with this coupon",style: TextStyle(color: ColorCodes.blackColor, fontSize: 14,fontWeight: FontWeight.bold), ),
                  SizedBox(height: 5,),
                  Text("Keep using "+ promocode +"and save \n more with each order",style: TextStyle(color: ColorCodes.blackColor,
                      fontSize: 16), ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: (){

                  final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
                  debugPrint("payment navi...."+routeArgs['minimumOrderAmountNoraml']);
                  Navigator.of(context).pushNamed(PaymentScreen.routeName,arguments: {
                    'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
                    'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
                    'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
                    'deliveryChargePrime': routeArgs['deliveryChargePrime'],
                    'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
                    'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
                    'deliveryType': routeArgs['deliveryType'],
                    'addressId': PrefUtils.prefs.getString("addressId"),
                    'note': routeArgs['note'],
                    'deliveryCharge': routeArgs['deliveryCharge'],
                    'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'],
                    'fromScreen':'promocodeScreen',
                    'responsejson':responsejson.toString(),
                  });
                },
                child: Center(
                  child:  Text("YAY!",style: TextStyle(color: ColorCodes.discountoff, fontSize: 20,fontWeight: FontWeight.bold), ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkPromo(String promocode) async {

      var item = [];
      for (int i = 0; i < productBox.length; i++) {
        if (membershipvx == "1") {
          if (double.parse(productBox[i].price) <= 0 ||
              productBox[i].price.toString() == "" ||
              productBox[i].price ==
                  productBox[i].varMrp) {
            promovarprice = productBox[i].varMrp.toString();
          } else {
            promovarprice = productBox[i].price.toString();
          }
        } else {
          if (double.parse(productBox[i].membershipPrice) <=
              0 ||
              productBox[i].membershipPrice == "" ||
              double.parse(productBox[i].membershipPrice) ==
                  productBox[i].varMrp) {
            promovarprice = productBox[i].varMrp.toString();
          } else {
            promovarprice = productBox[i].membershipPrice;
          }
        }
        var item1 = {};
        item1["\"itemid\""] =
            "\"" + productBox[i].varId.toString() + "\"";
        item1["\"qty\""] = productBox[i].quantity.toString();
        item1["\"price\""] = promovarprice;
        item.add(item1);
      }
      double cartTotal = 0.0;
      if ((VxState.store as GroceStore).userData.membership == "1") {
        debugPrint("totalMember...."+ CartCalculations.totalMember.toString());
        cartTotal = CartCalculations.totalMember;
      } else {
        debugPrint("total...."+CartCalculations.total.toString());
        cartTotal = CartCalculations.total;
      }

      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      deliveryAmt = double.parse(routeArgs['deliveryAmt']);
       debugPrint("body...."+{
         "promocode": promocode,
         "items": item.toString(),
         "user": PrefUtils.prefs.getString('apikey'),
         "total": cartTotal.toString(),
         "delivery":  deliveryAmt.toString(),
         "branch": PrefUtils.prefs.getString('branch'),
       }.toString());
      try {
        final response = await http.post(Api.checkPromocode, body: {
          "promocode": promocode,
          "items": item.toString(),
          "user": PrefUtils.prefs.getString('apikey'),
          "total": cartTotal.toString(),
          "delivery":  deliveryAmt.toString(),
          "branch": PrefUtils.prefs.getString('branch'),
        });
        final responseJson = json.decode(response.body);
        debugPrint("check promo resp...."+responseJson.toString());
        if (responseJson['status'].toString() == "done") {
         // dialogforPopup(promocode,responseJson['amount'].toString(), responseJson.toString());
          Navigator.of(context).pushNamed(PaymentScreen.routeName,arguments: {
            'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'].toString(),
            'deliveryChargeNormal': routeArgs['deliveryChargeNormal'].toString(),
            'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'].toString(),
            'deliveryChargePrime': routeArgs['deliveryChargePrime'].toString(),
            'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'].toString(),
            'deliveryChargeExpress': routeArgs['deliveryChargeExpress'].toString(),
            'deliveryType': routeArgs['deliveryType'].toString(),
            'addressId': PrefUtils.prefs.getString("addressId"),
            'note': routeArgs['note'].toString(),
            'deliveryCharge': routeArgs['deliveryCharge'].toString(),
            'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'].toString(),
            'fromScreen':'promocodeScreen',
            'prmocodeType':responseJson['prmocodeType'].toString(),
            'status':responseJson['status'].toString(),
            'msg':responseJson['msg'].toString(),
            'amount': responseJson['amount'].toString(),
            'promocode':promocode.toString(),
            'responsejson':"yes",

          });

        }else{
          Fluttertoast.showToast(
              msg: responseJson['msg'].toString(),
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);;

        }
      } catch (error) {
        throw error;
      }

  }
}