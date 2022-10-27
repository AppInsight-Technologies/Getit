import 'package:flutter/material.dart';
import '../../models/VxModels/VxStore.dart';
import '../../screens/profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../screens/notification_screen.dart';
import '../screens/searchitem_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../providers/branditems.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import 'customer_support_screen.dart';
import 'myorder_screen.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet-screen';
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  //SharedPreferences prefs;
  bool _isloading = true;
  bool _iswalletbalance = true;
  bool _iswalletlogs = true;
  var walletbalance = "0";
  bool notransaction = true;
  bool checkskip = false;
  bool _isWeb =false;
  var _address = "";
  MediaQueryData queryData;
  double wid;
  double maxwid;
  String screen= "";
  bool iphonex = false;
  var name = "", email = "", photourl = "", phone = "";
  GroceStore store = VxState.store;
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
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final type = routeArgs['type'];
      screen  =routeArgs['fromScreen'];
      print("frommmm......"+screen.toString());

      //prefs = await SharedPreferences.getInstance();
      _address = PrefUtils.prefs.getString("restaurant_address");
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


        if (!PrefUtils.prefs.containsKey("apikey")) {
          checkskip = true;
        } else {
          checkskip = false;
        }
      });

     // Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) {
        setState(() {
          _iswalletbalance = false;
          if (type == "wallet")
            walletbalance = /*PrefUtils.prefs.getString("wallet_balance")*/(VxState.store as GroceStore).prepaid.prepaid.toString();
          else
            walletbalance = /*PrefUtils.prefs.getString("loyalty_balance")*/(VxState.store as GroceStore).prepaid.loyalty.toString();
        });
    //  });
      Provider.of<BrandItemsList>(context,listen: false).fetchWalletLogs(type).then((_) {
        setState(() {
          _iswalletlogs = false;
        });
      });
    });

    super.initState();
  }


  void launchWhatsapp({@required number,@required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }


  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final type = routeArgs['type'];

    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          height: 60,
          color: Colors.white,
          //color: Color(0xFFfd8100),
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
                      maxRadius: 13.0,
                      foregroundColor: Colors.white,
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
                    Text(S.of(context).home,
                        style: TextStyle(
                           color: ColorCodes.lightgrey, fontSize: 10.0)),
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
                        color: ColorCodes.lightgrey,
                        width: 50,
                        height: 30,),

                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(S.of(context).categories,
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              if(Features.isWallet)
              Spacer(),
              if(Features.isWallet)
              Column(
                children: <Widget>[
                  SizedBox(
                      height: 7.0,
                    ),
                  CircleAvatar(
                    maxRadius: 13.0,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(Images.walletImg,
                    //  color: ColorCodes.greenColor,
                      color:ColorCodes.primaryColor,
                      width: 50,
                      height: 30,)
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text((type == "wallet") ? S.of(context).wallet : S.of(context).loyalty,
                      style: TextStyle(
                          color:ColorCodes.primaryColor,
                          //color: ColorCodes.greenColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              if(Features.isMembership)
              Spacer(),
              if(Features.isMembership)
              GestureDetector(
                onTap: () {
                  checkskip
                      ? Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                        )
                      : Navigator.of(context).pushReplacementNamed(
                          MembershipScreen.routeName,
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
                        Images.bottomnavMembershipImg,
                        color: ColorCodes.lightgrey,
                        width: 50,
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(S.of(context).membership,
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
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
                          Images.bag,
                          color: ColorCodes.lightgrey,
                          width: 50,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(S.of(context).my_orders,
                          style: TextStyle(
                              color: ColorCodes.lightgrey, fontSize: 10.0)),
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
                      Text(S.of(context).shopping_list,
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
                          Features.isLiveChat?Images.chat: Images.whatsapp,
                          width: 50,
                          height: 30,
                          color: Features.isLiveChat?ColorCodes.lightgrey:null,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text((!Features.isLiveChat && !Features.isWhatsapp)? S.of(context).search : S.of(context).chat,
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

    if (!_iswalletbalance && !_iswalletlogs) {
      _isloading = false;
    }
    final walletData = Provider.of<BrandItemsList>(context,listen: false);
    if (walletData.itemswallet.length <= 0) {
      notransaction = true;
    } else {
      notransaction = false;
    }
    // gradientappbarmobile() {
    //   return  AppBar(
    //     //brightness: Brightness.light,
    //     toolbarHeight: 60.0,
    //   );
    // }
    Widget _bodyMobile(){
      return _isloading
          ? (_isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
        child: LoyalityorWalletShimmer(),
      ): Center(
        child: LoyalityorWalletShimmer(),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor, size: 25),
                onPressed: () {
                  if (screen=="pushNotification")
                  {  print("iffff");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home-screen', (route) => false);
                  }
                  else if(screen=="notification"){
                    print("elseee");
                    Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
                    //  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                    return Future.value(false);
                  }

                  else {
                    print("elseee");
                    Navigator.of(context).popUntil(ModalRoute.withName(
                        HomeScreen.routeName));
                  }
                  return Future.value(false);}

            ),
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left:15, right: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image.asset(Images.walletback,
                      width: MediaQuery.of(context).size.width,
                  height: 150),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35.0, right: 20.0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                    ),
                    // SizedBox(
                    //   width: 30.0,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        (type == "wallet") ?
                            Row(
                              children: [
                                Image.asset(Images.walleticon,
                                height:25, width: 25),
                                SizedBox(width: 12,),
                                Text(
                                  "My Wallet",
                                  style: TextStyle(
                                      color: ColorCodes.whiteColor,
                                      fontSize: 27.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                            :
                            SizedBox.shrink(),
                        SizedBox(
                          height: 20.0,
                        ),
                        (type == "wallet")
                            ? Text(
                          "Total Balance",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: ColorCodes.whiteColor,
                          ),
                        )
                            : Text(
                          S.of(context).available_points,
                          style: TextStyle(
                            fontSize: 28.0,
                            color: ColorCodes.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                          (type == "wallet")
                            ? Text(
                          IConstants.currencyFormat + " " + double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              color: ColorCodes.whiteColor,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        )
                            : Row(
                          children: <Widget>[
                            Text(
                              double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Image.asset(
                              Images.coinImg,
                              width: 21.0,
                              height: 21.0,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
          notransaction ?
              SizedBox.shrink()
        :
          Container(
            padding: EdgeInsets.only(left: 15, top: 15),
            child: Text("Latest Transaction",
                style: TextStyle(color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w900, fontSize: 19)),
          ),
          notransaction
              ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  child: Image.asset(
                    (type == 'wallet')
                        ? Images.walletTransImg
                        : Images.loyaltyImg,
                    width: 232.0,
                    height: 168.0,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  S.of(context).there_is_no_transaction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19.0,
                      color: ColorCodes.greyColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
              : Expanded(
            child: new ListView.builder(
              itemCount: walletData.itemswallet.length,
              itemBuilder: (_, i) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5.0,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(walletData.itemswallet[i].title,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  walletData.itemswallet[i].date + " " + "|" + " " + walletData.itemswallet[i].time,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                walletData.itemswallet[i].title == "Credit" ?
                                Text(
                                  walletData.itemswallet[i].amount,
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorCodes.discount),
                                ):
                                Text(
                                  walletData.itemswallet[i].amount,
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorCodes.redColor),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                // (type == "wallet")
                                //     ? Text(
                                //    S.of(context).total_balance  +
                                //       IConstants.currencyFormat +
                                //       " " +
                                //       double.parse(walletData.itemswallet[i]
                                //           .closingbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                //   style: TextStyle(
                                //       color: Colors.black54,
                                //       fontSize: 12.0),
                                // )
                                //     : Text(
                                //   S.of(context).total_points +
                                //       double.parse(walletData.itemswallet[i]
                                //           .closingbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                //   style: TextStyle(
                                //       color: Colors.black54,
                                //       fontSize: 12.0),
                                // )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 5.0,
                              left: 5.0,
                              right: 10.0,
                              bottom: 5.0),
                          child: Text(
                            walletData.itemswallet[i].note,
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
   Widget  _bodyWeb(){
     return Expanded(
         child: SingleChildScrollView(
             child: Column(
                 children: [
                   _isloading
         ? ((_isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
       child: LoyalityorWalletShimmer(),
     ): Center(
       child: LoyalityorWalletShimmer(),
     ))
         :

                   Align(
                     alignment: Alignment.center,
                     child: Container(
                       //constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                       padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0 ),

                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           SizedBox(height: 15,),
                           Container(
                             margin: EdgeInsets.only(bottom: 20.0),
                             color: Colors.white,
                             child: Row(
                               children: [
                                 Padding(
                                   padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                                 ),
                                 SizedBox(
                                   width: 30.0,
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     (type == "wallet")
                                         ? Text(
                                       IConstants.currencyFormat + " " + double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                       style: TextStyle(
                                           color: Theme.of(context).primaryColor,
                                           fontSize: 35.0,
                                           fontWeight: FontWeight.bold),
                                     )
                                         : Row(
                                       children: <Widget>[
                                         Text(
                                           double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                           style: TextStyle(
                                               color: Theme.of(context).primaryColor,
                                               fontSize: 25.0,
                                               fontWeight: FontWeight.bold),
                                         ),
                                         SizedBox(
                                           width: 5.0,
                                         ),
                                         Image.asset(
                                           Images.coinImg,
                                           width: 21.0,
                                           height: 21.0,
                                           alignment: Alignment.center,
                                         ),
                                       ],
                                     ),
                                     SizedBox(
                                       height: 5.0,
                                     ),
                                     (type == "wallet")
                                         ? Text(
                                       S.of(context).wallet_balance,
                                       style: TextStyle(
                                         fontSize: 21.0,
                                         color: ColorCodes.greyColor,
                                       ),
                                     )
                                         : Text(
                                       S.of(context).available_points,
                                       style: TextStyle(
                                         fontSize: 21.0,
                                         color: ColorCodes.greyColor,
                                       ),
                                     )
                                   ],
                                 ),
                                 SizedBox(
                                   height: 100.0,
                                 ),
                                 Divider(),
                               ],
                             ),
                           ),
                           notransaction
                               ? Expanded(

                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 Align(
                                   child: Image.asset(
                                     (type == 'wallet')
                                         ? Images.walletTransImg
                                         : Images.loyaltyImg,
                                     width: 232.0,
                                     height: 168.0,
                                     alignment: Alignment.center,
                                   ),
                                 ),
                                 SizedBox(
                                   height: 10.0,
                                 ),
                                 Text(
                                   S.of(context).there_is_no_transaction,
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                       fontSize: 19.0,
                                       color: ColorCodes.greyColor,
                                       fontWeight: FontWeight.bold),
                                 ),
                               ],
                             ),
                           )

                               : new ListView.builder(
                             itemCount: walletData.itemswallet.length,
                             shrinkWrap: true,
                             itemBuilder: (_, i) => Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: <Widget>[
                                     SizedBox(
                                       width: 10.0,
                                     ),
                                     Image.asset(
                                       walletData.itemswallet[i].img,
                                       fit: BoxFit.fill,
                                       width: 40.0,
                                       height: 40.0,
                                     ),
                                     SizedBox(
                                       width: 10.0,
                                     ),
                                     Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Text(
                                           walletData.itemswallet[i].title,
                                         ),
                                         SizedBox(
                                           height: 10.0,
                                         ),
                                         Text(
                                           walletData.itemswallet[i].time,
                                           style: TextStyle(
                                               color: Colors.black54,
                                               fontSize: 12.0),
                                         ),
                                       ],
                                     ),
                                     Spacer(),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: <Widget>[
                                         Text(
                                           walletData.itemswallet[i].date,
                                           style: TextStyle(
                                               color: Colors.black54,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 14.0),
                                         ),
                                         SizedBox(
                                           height: 5.0,
                                         ),
                                         Text(
                                          walletData.itemswallet[i].amount,
                                         ),
                                         SizedBox(
                                           height: 5.0,
                                         ),
                                         (type == "wallet")
                                             ? Text(
                                           S.of(context).total_balance  +
                                               IConstants.currencyFormat +
                                               " " +
                                               double.parse(walletData.itemswallet[i]
                                                   .closingbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                           style: TextStyle(
                                               color: Colors.black54,
                                               fontSize: 12.0),
                                         )
                                             : Text(
                                           S.of(context).total_points +
                                              double.parse(walletData.itemswallet[i]
                                                  .closingbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) ,
                                           style: TextStyle(
                                               color: Colors.black54,
                                               fontSize: 12.0),
                                         )
                                       ],
                                     ),
                                     SizedBox(
                                       width: 10.0,
                                     ),
                                   ],
                                 ),
                                 Container(
                                   margin: EdgeInsets.only(
                                       left: 60.0,
                                       top: 10.0,
                                       right: 10.0,
                                       bottom: 10.0),
                                   child: Text(
                                     walletData.itemswallet[i].note,
                                     style: TextStyle(
                                         color: Colors.black54, fontSize: 12.0),
                                   ),
                                 ),
                                 Container(
                                   margin: EdgeInsets.only(
                                       left: 60.0,
                                       top: 10.0,
                                       right: 10.0,
                                       bottom: 10.0),
                                   child: Divider(),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
        ],
             ),
     ),
         );
   }
    return WillPopScope(
      onWillPop: (){
        if (screen=="pushNotification")
        {  print("iffff");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home-screen', (route) => false);
        }
        else if(screen=="notification"){
          print("elseee");
          Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
          //  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
          return Future.value(false);
        }

        else {
          print("elseee");
          Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
        }
          return Future.value(false);
      },
      child: Scaffold(
        // appBar: ResponsiveLayout.isSmallScreen(context) ?
        // gradientappbarmobile() : null,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            _isWeb? _bodyWeb():Flexible(child: _bodyMobile()),
          ],
        ),
        // bottomNavigationBar:  _isWeb ? SizedBox.shrink() :
        // Container(
        //   color: Colors.white,
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        //     child:bottomNavigationbar(),
        //   ),
        // ),
      ),
    );
  }
}
