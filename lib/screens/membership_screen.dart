import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';
import '../screens/searchitem_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import '../providers/cartItems.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/IConstants.dart';
import '../providers/membershipitems.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../providers/branditems.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../data/calculations.dart';
import '../utils/prefUtils.dart';
import 'customer_support_screen.dart';
import 'myorder_screen.dart';

class MembershipScreen extends StatefulWidget {
  static const routeName = '/membership-screen';

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
 // Box<Product> productBox;
  bool _checkmembership = false;
  var orderdate = "";
  var expirydate = "";
  var orderid = "";
  var ordertotal = "";
  var name = "";
  var duration = "";
  var paytype = "";
  var address = "";
  bool _loading = true;
  bool checkskip = false;
  bool memberMode = false;
  //SharedPreferences prefs;
  bool _isWeb = false;
  var _address = "";
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool _isAddToCart = false;
  bool iphonex = false;
  var email = "", photourl = "", phone = "";
  var postImage= "";
  GroceStore store = VxState.store;
  List<CartItem> productBox=[];

  @override
  void initState() {

    productBox = /*Hive.box<Product>(productBoxName);*/(VxState.store as GroceStore).CartItemList;
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
        if (PrefUtils.prefs.getString('Email') != null) {
          email = PrefUtils.prefs.getString('Email');
        } else {
          email = "";
        }

        if (PrefUtils.prefs.getString('mobile') != null) {
          phone = PrefUtils.prefs.getString('mobile');
        } else {
          phone = "";
        }

      });
      //prefs = await SharedPreferences.getInstance();
      _address = PrefUtils.prefs.getString("restaurant_address");
    //  await Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) {
        setState(() {
          if (!PrefUtils.prefs.containsKey("apikey")) {
            setState(() {
              checkskip = true;
            });
          } else {
            checkskip = false;
          }

          for (int i = 0; i < productBox.length; i++) {
            if (productBox[i].mode == "1") {
              setState(() {
                memberMode = true;
              });
            }
          }

          if (memberMode) {
            Provider.of<MembershipitemsList>(context, listen: false).Getmembership().then((_) async {
              final membershipData = Provider.of<MembershipitemsList>(context, listen: false);
              if (membershipData.items.length > 0)
                await precacheImage(AssetImage(membershipData.items[0].avator), context).then((_) {
                  Future.delayed(Duration.zero, () async {
                    setState(() {
                      _loading = false;
                      _checkmembership = false;
                    });
                  });
                }); else {
                setState(() {
                  _loading = false;
                  _checkmembership = false;
                });
              }

            });
          } else if (PrefUtils.prefs.getString("membership") == "1") {
            _checkmembership = true;
            Provider.of<MembershipitemsList>(context,listen: false).Getmembershipdetails().then((_) async {
              setState(() {
                postImage =PrefUtils.prefs.getString("post_image");
                orderdate = PrefUtils.prefs.getString("orderdate");
                expirydate = PrefUtils.prefs.getString("expirydate");
                orderid = PrefUtils.prefs.getString("orderid");
                ordertotal = PrefUtils.prefs.getString("membershipprice");
                // name = PrefUtils.prefs.getString("membershipname");
                duration = PrefUtils.prefs.getString("duration");
                paytype = PrefUtils.prefs.getString("memebershippaytype");
                address = PrefUtils.prefs.getString("membershipaddress");
                _loading = false;
              });
            });
          } else {
            Provider.of<MembershipitemsList>(context, listen: false).Getmembership().then((_) async {
              final membershipData = Provider.of<MembershipitemsList>(context, listen: false);
              if (membershipData.items.length > 0)
                await precacheImage(AssetImage(membershipData.items[0].avator), context).then((_) {
                  Future.delayed(Duration.zero, () async {
                    setState(() {
                      _loading = false;
                      _checkmembership = false;
                    });
                  });
                }); else {
                setState(() {
                  _loading = false;
                  _checkmembership = false;
                });
              }
            });
          }
        });
      //});
    });
    super.initState();
  }

  _addtocart(String membershipid, String duration, String discountprice, String price) async {
    // await Provider.of<CartItems>(context, listen: false).addToCart(
    //     "0", "0", duration, "1", "1", "1", "1", price, "Membership",
    //     "1", double.parse(discountprice).toString(), discountprice, Images.membershipImg, membershipid, "1", "","1","","","","","").then((_) {
    //
    //
    //   setState(() {
    //     _isAddToCart = false;
    //   });
    //   PrefUtils.prefs.setString("membership", "1");
    //   debugPrint("membership......screen"+PrefUtils.prefs.getString("membership") );
    //
    //   Product products = Product(
    //       itemId: 0,
    //       varId: 0,
    //       varName: duration,
    //       varMinItem: 1,
    //       varMaxItem: 1,
    //       varStock: 1,
    //       varMrp: double.parse(price),
    //       itemName: "Membership",
    //       itemQty: 1,
    //       itemPrice: double.parse(discountprice),
    //       membershipPrice: discountprice,
    //       itemActualprice: double.parse(price),
    //       itemImage: Images.membershipImg,
    //       membershipId: int.parse(membershipid),
    //       mode: 1,
    //       veg_type: "",
    //       type: "",
    //       eligible_for_express: "",
    //       delivery: "",
    //       duration: "",
    //       durationType: "",
    //       note: ""
    //   );
    //
    //   //productBox.add(products);
    // });
    cartcontroller.addtoCart( PriceVariation(quantity: 1,mode: "4",status: "0",discointDisplay: false,
        loyaltys:0,membershipDisplay:false,menuItemId: "",
        netWeight: "",weight:"",id: "0",variationName: duration,unit:"1",minItem: "",maxItem: "",loyalty: 0,stock: 1,mrp: double.parse(price),
        price: double.parse(price),membershipPrice: double.parse(price)),ItemData(type: "",eligibleForExpress: "1",vegType:"",delivery: "0",
        duration:"0",brand: "",id: "0",itemName: "Membership",mode: "1",deliveryDuration:DeliveryDurationData(duration:"",status: "",durationType: "",note: "", id: "",branch: "",blockFor: "") ), (onload){
    setState(() {
      _isAddToCart = onload;
    });
    setState(() {
      _isAddToCart = false;
      //  _varQty = _itemCount;
    });
    });
  }

  _removefromcart(String discountprice) async {
    await Provider.of<CartItems>(context, listen: false).updateCart(
        "0", "0", double.parse(discountprice).toString()).then((_) {

      PrefUtils.prefs.setString("membership", "0");
      CartCalculations.deleteMembershipItem();

      setState(() {
        _isAddToCart = false;
      });
    });
  }

  _updatetocart(String membershipid, String duration, String discountprice, String price) async {

    await Provider.of<CartItems>(context, listen: false).addToCart(
        "0", "0", duration, "1", "1", "1", "1", price, "Membership",
        "1", double.parse(discountprice).toString(), discountprice, Images.membershipImg, membershipid, "1", "", "1","","","","","").then((_) {


      setState(() {
        _isAddToCart = false;
      });

      CartCalculations.deleteMembershipItem();
      Product products = Product(
          itemId: 0,
          varId: 0,
          varName: duration,
          varMinItem: 1,
          varMaxItem: 1,
          varStock: 1,
          varMrp: double.parse(price),
          itemName: "Membership",
          itemQty: 1,
          itemPrice: double.parse(discountprice),
          membershipPrice: discountprice,
          itemActualprice: double.parse(price),
          itemImage: Images.membershipImg,
          membershipId: int.parse(membershipid),
          mode: 1,
          veg_type: "",
          type: "",
          eligible_for_express: "",
          delivery: "",
          duration: "",
          durationType: ""
      );

     // productBox.add(products);
    });
  }


  void launchWhatsapp({@required number,@required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        Images.homeImg,
                        color: ColorCodes.lightgrey,
                        width: 50,
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        S.of(context).home,//"Home",
                        style: TextStyle(
                          color: ColorCodes.lightgrey,
                          fontSize: 10.0,
                        )),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    CategoryScreen.routeName,
                  );
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(Images.categoriesImg,
                          width: 50,
                          height: 30,
                          color: ColorCodes.lightgrey),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        S.of(context).categories,//"Categories",
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              if(Features.isWallet)
                Spacer(),
              if(Features.isWallet)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    )
                        : Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                        arguments: {"type": "wallet"});
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.walletImg,
                            width: 50,
                            height: 30,
                            color: ColorCodes.lightgrey),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S.of(context).wallet,//"Wallet",
                          style: TextStyle(
                              color: ColorCodes.lightgrey, fontSize: 10.0)),
                    ],
                  ),
                ),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(Images.bottomnavMembershipImg,
                          width: 50,
                          height: 30,
                          color: ColorCodes.primaryColor),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        S.of(context).membership,//"Membership",
                        style: TextStyle(
                            color: ColorCodes.primaryColor,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    )
                        : Navigator.of(context).pushReplacementNamed(
                      MyorderScreen.routeName,arguments: {
                      "orderhistory": ""
                    }
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                            Images.shoppinglistsImg,
                            width: 50,
                            height: 30,
                            color: ColorCodes.primaryColor
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S.of(context).my_orders,//"My Orders",
                          style: TextStyle(
                              color: ColorCodes.primaryColor,
                              fontSize: 10.0)),
                    ],
                  ),
                ),
              if(Features.isShoppingList)
                Spacer(flex: 1),
              if(Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    )
                        : Navigator.of(context).pushReplacementNamed(
                      ShoppinglistScreen.routeName,
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.shoppinglistsImg,
                          width: 50,
                          height: 30,),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S.of(context).shopping_list,//"Shopping list",
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
                    ],
                  ),
                ),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip && Features.isLiveChat
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    )
                        : (Features.isLiveChat && Features.isWhatsapp)?
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    }):
                    (!Features.isLiveChat && !Features.isWhatsapp)?
                    Navigator.of(context).pushNamed(SearchitemScreen.routeName)

                        :
                    Features.isWhatsapp?launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery"):
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: (!Features.isLiveChat && !Features.isWhatsapp)?
                        Icon(
                          Icons.search,
                          color: ColorCodes.lightgrey,

                        )
                            :
                        Image.asset(
                          Features.isLiveChat?Images.appCustomer: Images.whatsapp,
                          width: 50,
                          height: 30,
                          color: Features.isLiveChat?ColorCodes.lightgrey:null,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text((!Features.isLiveChat && !Features.isWhatsapp)? S.of(context).search//"Search"
                          : S.of(context).chat,//"Chat",
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
                    ],
                  ),
                ),
              Spacer(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar:  ResponsiveLayout.isSmallScreen(context)
          ? gradientappbarmobile()
          : null,
//        drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false, false),
          _body(),
        ],
      ),
      bottomNavigationBar: _isWeb ? SizedBox.shrink() : Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child: bottomNavigationbar(),
      ),
    );
  }

  Widget _body(){
    final membershipData = Provider.of<MembershipitemsList>(context,listen: false);
    //  debugPrint("image..."+PrefUtils.prefs.getString("membershipname"));
    return _checkmembership
        ?  Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _loading
                ? Center(
              child: LoyalityorWalletShimmer(),
            )
                :
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                child: Column(
                  children: <Widget>[
                    /*SizedBox(
                            height: 50.0,
                          ),*/
                    Image.network(
                      postImage,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Divider(
                      color: Color(0xFFC2E7F9),
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xFFF2BF40),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          S.of(context).plan,//"Plan:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          PrefUtils.prefs.getString("membershipname"),
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Text(IConstants.currencyFormat + " " + double.parse(ordertotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Divider(
                      color: Color(0xFFC2E7F9),
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 45.0),
                        Icon(
                          Icons.star,
                          color: Color(0xFFF2BF40),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          S.of(context).renewal_payment,//"Renewal and Next Payment",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 5, 40, 10),
                      child: Text(
                        S.of(context).membership_expire//'Your membership will expire on '
                            + expirydate +
                            S.of(context).inform_via_sms, //'. You will be informed via email or SMS and can renew only after expiry.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 50),
                    /*RaisedButton(
                                   onPressed: () {},
                                   color: Color(0xFFF2BF40),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(6),
                                   ),
                                   child: Text(
                                     'View Order Details',
                                     style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                     ),
                                   ),
                                   padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                                 ),*/
                  ],
                ),

              ),
            ),
            /* Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(width: 1.0, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                                left: BorderSide(width: 1.0, color: Colors.grey),
                                right: BorderSide(width: 1.0, color: Colors.grey),
                              )),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Order date",
                                    style: TextStyle(fontSize: 14.0),
                                  )),
                                  Expanded(
                                      child: Text(
                                    orderdate,
                                    style: TextStyle(fontSize: 14.0),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Order id",
                                    style: TextStyle(fontSize: 14.0),
                                  )),
                                  Expanded(
                                      child: Text(
                                    orderid,
                                    style: TextStyle(fontSize: 14.0),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Order total",
                                    style: TextStyle(fontSize: 14.0),
                                  )),
                                  Expanded(
                                      child: Text(
                                    _currencyFormat + ordertotal + " ( 1 item )",
                                    style: TextStyle(fontSize: 14.0),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),*/

            /* Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Purchase Details",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),*/
            /* Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(width: 1.0, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                                left: BorderSide(width: 1.0, color: Colors.grey),
                                right: BorderSide(width: 1.0, color: Colors.grey),
                              )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 50.0,
                                height: 50.0,
                                child: Image.asset(
                                  Images.membershipImg,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      name + " (" + duration + " Months)",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Qty: 1",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                _currencyFormat + " " + ordertotal,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),*/
            /* Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Payment information",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),*/
            /* Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(width: 1.0, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                                left: BorderSide(width: 1.0, color: Colors.grey),
                                right: BorderSide(width: 1.0, color: Colors.grey),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Payment Method",
                                style: TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                paytype,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Divider(),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Billing Address",
                                style: TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                address,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),*/
            SizedBox(height: 40,),
            if (_isWeb)
              Footer(address: PrefUtils.prefs.getString("restaurant_address")),
          ],
        ),
      ),
    )
        : Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _loading
                ? Container(
              height: 100,
              child: Center(
                child: LoyalityorWalletShimmer(),
              ),
            )
                :
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                child: Column(
                  children: <Widget>[
                    if(membershipData.items.length > 0)
                      CachedNetworkImage(
                        imageUrl: membershipData.items[0].avator,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    if(membershipData.items.length > 0)
                      SizedBox(height: 20.0),
                    Container(
                      height: 400,
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Text(
                                S.of(context).select_membership,//"Select the membership plan which suits your needs",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 300,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                membershipData.typesitems.length,
                                itemBuilder: (ctx, i) {
                                  return ValueListenableBuilder(
                                      valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                      builder: (context, Box<Product> box, index) {
                                        for (int j = 0; j < membershipData.typesitems.length; j++) {
                                          if (CartCalculations.checkmembershipItem == 0) {
                                            membershipData.typesitems[j].text = "Select";
                                            membershipData.typesitems[j]
                                                .backgroundcolor =
                                                Color(0xFFF2BF40);
                                            membershipData.typesitems[j]
                                                .textcolor =
                                                Colors.black;
                                          } else {
                                            for (int k = 0; k < productBox.length; k++) {
                                              if (productBox[k].membershipId.toString() == membershipData.typesitems[j].typesid) {
                                                membershipData.typesitems[j].text = "Remove";
                                                membershipData.typesitems[j].backgroundcolor = Colors.green;
                                                membershipData.typesitems[j].textcolor = Colors.white;
                                              } else {
                                                membershipData.typesitems[j].text = "Update";
                                                membershipData.typesitems[j].backgroundcolor = Color(0xFFF2BF40);
                                                membershipData.typesitems[j].textcolor = Colors.black;
                                              }
                                            }
                                          }
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            print("onmembershiptap");
                                            if((VxState.store as GroceStore).userData.membership == "0" || memberMode ||(VxState.store as GroceStore).userData.membership == "1") {
                                              print("onmembershiptap");

                                              setState(() {
                                                _isAddToCart = true;
                                              });
                                              if (membershipData.typesitems[i]
                                                  .text == "Select") {
                                                _addtocart(
                                                  membershipData.typesitems[i].typesid,
                                                  membershipData.typesitems[i].typesduration,
                                                  membershipData.typesitems[i].typesdiscountprice,
                                                  membershipData.typesitems[i].typesprice,
                                                );
                                              } else
                                              if (membershipData.typesitems[i].text == "Remove") {
                                                _removefromcart(membershipData.typesitems[i].typesdiscountprice);
                                              } else {
                                                _updatetocart(
                                                  membershipData.typesitems[i].typesid,
                                                  membershipData.typesitems[i].typesduration,
                                                  membershipData.typesitems[i].typesdiscountprice,
                                                  membershipData.typesitems[i].typesprice,
                                                );
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: S.of(context).membership_processing,//"Your order with Membership is processing!",
                                                  fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
                                            }
                                          },
                                          child: Container(
                                            width: 250,
                                            height: 50,
                                            //padding: EdgeInsets.all(10),
                                            margin:
                                            EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: membershipData.typesitems[i].backgroundcolor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.white),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: _isAddToCart ? Center(
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                              )
                                                  :
                                              (membershipData.typesitems[i].typesdiscountprice == membershipData.typesitems[i].typesprice)?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesdiscountprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: membershipData
                                                          .typesitems[i]
                                                          .textcolor,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    membershipData.typesitems[i].typesduration + S.of(context).membership_month,//" month",
                                                    style: TextStyle(
                                                        color: membershipData.typesitems[i].textcolor,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              )
                                                  : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesdiscountprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: membershipData
                                                              .typesitems[i]
                                                              .textcolor,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4,),
                                                      Text(IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                        style: TextStyle(
                                                            color: membershipData
                                                                .typesitems[i]
                                                                .textcolor,
                                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                                            decoration: TextDecoration.lineThrough,
                                                            fontWeight: FontWeight.w400

                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    membershipData.typesitems[i].typesduration + S.of(context).membership_month,//" month",
                                                    style: TextStyle(
                                                        color: membershipData.typesitems[i].textcolor,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }),
                          ),
                          /* new Row(
                        children: <Widget>[
                          Expanded(
                              child: SizedBox(
                                height: 220.0,
                                child: new ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: membershipData.typesitems.length,
                                  itemBuilder: (_, i) => Expanded(
                                    child: Container(
                                      width: 170.0,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3.0),
                                            border: Border(
                                              top: BorderSide(width: 1.0, color: Colors.white),
                                              bottom: BorderSide(width: 1.0, color: Colors.white),
                                              left: BorderSide(width: 1.0, color: Colors.white),
                                              right: BorderSide(width: 1.0, color: Colors.white),
                                            )),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              membershipData.typesitems[i].typesduration + " month",
                                              style: TextStyle(color: Color(0xff48b9c6), fontSize: 18.0),
                                            ),
                                            Divider(),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  _currencyFormat + " " + membershipData.typesitems[i].typesdiscountprice,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Divider(),
                                                  ValueListenableBuilder(
                                                    valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                                    builder: (context, Box<Product> box, index) {
                                                      for(int j = 0; j < membershipData.typesitems.length; j++) {
                                                        if (Calculations.checkmembershipItem == 0) {
                                                          membershipData.typesitems[j].text = "Select";
                                                          membershipData.typesitems[j].backgroundcolor = Color(0xff35a2df);
                                                          membershipData.typesitems[j].textcolor = Colors.white;
                                                        } else {
                                                          for(int k = 0; k < productBox.length; k++) {
                                                            if(productBox.values.elementAt(k).membershipId.toString() == membershipData.typesitems[j].typesid) {
                                                              membershipData.typesitems[j].text = "Remove";
                                                              membershipData.typesitems[j].backgroundcolor = Colors.white;
                                                              membershipData.typesitems[j].textcolor = Color(0xff35a2df);
                                                            } else {
                                                              membershipData.typesitems[j].text = "Update";
                                                              membershipData.typesitems[j].backgroundcolor = Color(0xff35a2df);
                                                              membershipData.typesitems[j].textcolor = Colors.white;
                                                            }
                                                          }
                                                        }
                                                      }

                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (membershipData.typesitems[i].text == "Select") {
                                                            _addtocart(
                                                              membershipData.typesitems[i].typesid,
                                                              membershipData.typesitems[i].typesduration,
                                                              membershipData.typesitems[i].typesdiscountprice,
                                                              membershipData.typesitems[i].typesprice,
                                                            );
                                                          } else if(membershipData.typesitems[i].text == "Remove") {
                                                            _removefromcart();
                                                          } else {
                                                            _updatetocart(
                                                              membershipData.typesitems[i].typesid,
                                                              membershipData.typesitems[i].typesduration,
                                                              membershipData.typesitems[i].typesdiscountprice,
                                                              membershipData.typesitems[i].typesprice,
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 40.0,
                                                          margin: EdgeInsets.all(10.0),
                                                          decoration: BoxDecoration(color: membershipData.typesitems[i].backgroundcolor, borderRadius: BorderRadius.circular(3.0),
                                                              border: Border(
                                                                top: BorderSide(width: 1.0, color: Theme.of(context).accentColor,),
                                                                bottom: BorderSide(width: 1.0, color: Theme.of(context).accentColor,),
                                                                left: BorderSide(width: 1.0, color: Theme.of(context).accentColor,),
                                                                right: BorderSide(width: 1.0, color: Theme.of(context).accentColor,),
                                                              )),
                                                          child: Center(
                                                              child: Text(membershipData.typesitems[i].text,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: membershipData.typesitems[i].textcolor),
                                                              )),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      */
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isWeb)
              Footer(address: PrefUtils.prefs.getString("restaurant_address")),
          ],
        ),
      ),
    );
  }
  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
          onPressed: () => Navigator.of(context).pop()),
      title: Text(
        S.of(context).membership,//'Membership',
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
      actions: <Widget>[
        Container(
          //  margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
          child: ValueListenableBuilder(
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
                    margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                    width: 25,
                    height: 25,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      /* color: Theme.of(context).buttonColor*/),
                    child: /*Icon(
                        Icons.shopping_cart_outlined,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),*/
                    Image.asset(
                      Images.header_cart,
                      height: 28,
                      width: 28,
                      color:Colors.white,
                    ),
                  ),
                );


              return Consumer<CartCalculations>(
                builder: (_, cart, ch) => Badge(
                  child: ch,
                  color: ColorCodes.darkgreen,
                  value: CartCalculations.itemCount.toString(),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                      "after_login": ""
                    });
                  },
                  child: Container(
                    /* margin: EdgeInsets.only(top: 6, right: 10, bottom: 10),*/
                    margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      /*color: Theme.of(context).buttonColor*/),
                    child: /*Icon(
                        Icons.shopping_cart_outlined,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),*/
                    Image.asset(
                      Images.header_cart,
                      height: 28,
                      width: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
