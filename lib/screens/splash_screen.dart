import 'dart:convert';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../controller/mutations/login.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/authenticate/AuthRepo.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/in_app_update_review.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../providers/branditems.dart';
import '../screens/singleproduct_screen.dart';
import '../screens/introduction_screen.dart';
import '../screens/wallet_screen.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../handler/firebase_notification_handler.dart';
import '../constants/IConstants.dart';
import '../main.dart';
import '../screens/home_screen.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../screens/not_brand_screen.dart';
import '../screens/orderhistory_screen.dart';
import '../screens/not_product_screen.dart';
import '../screens/not_subcategory_screen.dart';
import '../assets/images.dart';
import '../providers/notificationitems.dart';


String  APP_STORE_URL = 'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=' + IConstants.appleId + '&mt=8';
String PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=' + IConstants.androidId;

class SplashScreenPage extends StatefulWidget {
  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool timmer = true;
  final dynamicLink = FirebaseDynamicLinks.instance;

  String activelang = "en";
  bool _isWeb = false;

  void navigationToNextPage() async {
    PrefUtils.prefs.setString("formapscreen", "");
    PrefUtils.prefs.setString("formapscreen", "");
    var LoginStatus = PrefUtils.prefs.getString('LoginStatus');

    if (LoginStatus == null || LoginStatus != "true") {
      PrefUtils.prefs.setString('skip', "yes");
    }
    Navigator.of(context).pushReplacementNamed(
      HomeScreen.routeName,
    );

    /*LoginStatus == null ?
    Navigator.of(context).pushReplacementNamed(
      SignupSelectionScreen.routeName,
    ) :
    _isHomeScreen ? PrefUtils.prefsInstance.containsKey("deliverylocation") ?
    Navigator.of(context).pushReplacementNamed(
      HomeScreen.routeName,
    ) :
    Navigator.of(context).pushReplacementNamed(
      LocationScreen.routeName,) : null;*/
  }

  startSplashScreenTimer() async {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    /*await versionCheck(context);
    navigationToNextPage;
   */
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationToNextPage);
  }

  @override
  Future<void> initState()  {
    super.initState();

    Future.delayed(Duration.zero, () async {

      await PrefUtils.init();
      Future.delayed(Duration.zero, () async {
        await PrefUtils.init();


        PrefUtils.prefs.setInt("htmlId", 1);
        PrefUtils.prefs.setString("referCodeDynamic", "");
        var LoginStatus = PrefUtils.prefs.getString('LoginStatus');
        if (!PrefUtils.prefs.containsKey("branch")) PrefUtils.prefs.setString("branch", "81");
        try {
          if (Platform.isIOS || Platform.isAndroid) {
            await new FirebaseNotifications().setUpFirebase();
          //  HomeScreenController(user:  (VxState.store as GroceStore).userData.id??PrefUtils.prefs.getString("tokenid"),branch: PrefUtils.prefs.getString("branch"),languageid: PrefUtils.prefs.getString("language_id"),rows: "0", );
            final signcode = await SmsAutoFill().getAppSignature;
            PrefUtils.prefs.setString('signature', signcode);
            handleDynamicLink();
          }
        } catch (e) {
          _isWeb = true;
        }
        if(!_isWeb)
          await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) async {
            if(Features.isPushNotification)
              try {
                if (Platform.isIOS || Platform.isAndroid) {
                  _firebaseMessaging.configure(
                    onMessage: (Map<String, dynamic> message) async {
                      timmer = false;
                      Provider.of<BrandItemsList>(navigatorKey.currentContext,listen: false).userDetails();
                      final responseJson = json.encode(message);
                      final responseJsonDecode = json.decode(responseJson);
                      final notificationEncode = json.encode(responseJsonDecode['notification']);
                      final notificationDecode = json.decode(notificationEncode);
                      final dataEncode = json.encode(responseJsonDecode['data']);
                      final dataDecode = json.decode(dataEncode);

                      double _signupBonusAmount = double.parse(notificationDecode["body"].toString().replaceAll(new RegExp(r'[^0-9]'),''));

                      if(dataDecode["mode"].toString() == "50") {
                        //return Fluttertoast.showToast(msg: notificationDecode["body"].toString(), fontSize: MediaQuery.of(navigatorKey.currentContext).textScaleFactor * 13,);

                        return showDialog(
                          context: navigatorKey.currentContext,
                          builder: (context) {
                            return AlertDialog(
                              content: Stack(
                                overflow: Overflow.visible,
                                children: [

                                  Container(
                                    height:250,

                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height:10),
                                          Text(S.of(navigatorKey.currentContext).Sign_Up_Bonus,
                                            style: TextStyle(
                                              color: Colors.black54, fontSize: 22,fontWeight: FontWeight.bold,
                                            ), ),
                                          SizedBox(height:10),
                                          Text(
                                            IConstants.currencyFormat + _signupBonusAmount.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                          Text(
                                            S.of(navigatorKey.currentContext).Added_to_your_wallet,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,color: Colors.grey),),
                                          SizedBox(height:20),
                                          Expanded(
                                            child: Text(
                                              notificationDecode["body"].toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18,color: Colors.grey),),
                                          ),
                                          Text(
                                            S.of(navigatorKey.currentContext).yay,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: -50,
                                    child: InkWell(
                                      child:CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child:  Image.asset(Images.gift, height: 60.0, width: 60.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                      } else {
                        return Fluttertoast.showToast(msg: notificationDecode["body"].toString(), fontSize: MediaQuery.of(navigatorKey.currentContext).textScaleFactor * 13,);
                      }


                      /* return Fluttertoast.showToast(
                  msg: notificationDecode["body"].toString());*/
                    },
                    onResume: (Map<String, dynamic> message) async {
                      timmer = false;
                      Provider.of<BrandItemsList>(navigatorKey.currentContext,listen: false).userDetails();

                      final responseJson = json.encode(message);
                      final responseJsonDecode = json.decode(responseJson);
                      final notificationEncode = json.encode(responseJsonDecode['notification']);
                      final notificationDecode = json.decode(notificationEncode);
                      final dataEncode = json.encode(responseJsonDecode['data']);
                      final dataDecode = json.decode(dataEncode);
                      // dispose();
                      // timmer = false;
                      if (dataDecode["mode"].toString() == "2") {
                        // Order and 'ref' key is for fetching order id
                        if (LoginStatus != null) {
                          Navigator.of(context)
                              .pushReplacementNamed(
                              OrderhistoryScreen.routeName, arguments: {
                            'orderid': dataDecode["ref"].toString(),
                            'fromScreen': "splashNotification",
                            'notificationId': dataDecode["nid"].toString()
                          });
                        }
                      } else if (dataDecode["mode"].toString() == "3") { //Web Link
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }

                        String url = dataDecode["ref"].toString();
                        if (canLaunch(url) != null)
                          launch(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                        Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(dataDecode["nid"].toString(), "1" );
                      } else if (dataDecode["mode"].toString() == "4") {
                        //Product with array of product id (Then have to call api)
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(
                            NotProductScreen.routeName, arguments: {
                          'productId': dataDecode["ref"].toString(),
                          'fromScreen': "ClickLink",
                          'notificationId': dataDecode["nid"].toString()
                        });
                      } else if (dataDecode["mode"].toString() == "5") {
                        //Sub category with array of sub category
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(
                            NotSubcategoryScreen.routeName, arguments: {
                          'subcategoryId': dataDecode["ref"].toString(),
                          'fromScreen': "ClickLink",
                          'notificationId': dataDecode["nid"].toString(),
                        });
                      } else if (dataDecode["mode"].toString() == "6") {
                        //redirect to app home page
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Provider.of<NotificationItemsList>(context, listen: false)
                            .updateNotificationStatus(
                            dataDecode["nid"].toString(), "1");
                        Navigator.of(context).pushReplacementNamed(
                          HomeScreen.routeName,
                        );
                      } else if (dataDecode["mode"].toString() == "10") {
                        //redirect to app home page
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Provider.of<NotificationItemsList>(context, listen: false)
                            .updateNotificationStatus(
                            dataDecode["nid"].toString(), "1");
                        Navigator.of(context).pushReplacementNamed(
                            NotBrandScreen.routeName,
                            arguments: {
                              'brandsId': dataDecode["ref"].toString(),
                              'fromScreen': "ClickLink",
                              'notificationId': dataDecode["nid"].toString(),
                            }
                        );
                      }
                      else if(dataDecode["mode"].toString() == "12") {
                        if (LoginStatus != null) {
                          Navigator.of(context).pushReplacementNamed(
                              WalletScreen.routeName,
                              arguments: {
                                'type': "wallet",
                                'fromScreen': "pushNotification",
                              }
                          );
                        }
                      }
                      else if(dataDecode["mode"].toString() == "13") {
                        if (LoginStatus != null) {
                          Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                              arguments: {
                                'type' : "loyalty",
                                'fromScreen': "pushNotification",

                              }
                          );
                        }
                      }
                      else if(dataDecode["mode"].toString() == "14") {
                        if (LoginStatus != null) {
                          Provider.of<NotificationItemsList>(context, listen: false)
                              .updateNotificationStatus(
                              dataDecode["nid"].toString(), "1");
                          Navigator.of(context).pushReplacementNamed(
                              NotBrandScreen.routeName,
                              arguments: {
                                'brandsId': dataDecode["ref"].toString(),
                                'fromScreen': "ClickLink",
                                'notificationId': dataDecode["nid"].toString(),
                              }
                          );
                        }
                      } else if(dataDecode["mode"].toString() == "50") {
                        if (LoginStatus != null) {
                          Navigator.of(context).pushReplacementNamed(
                              WalletScreen.routeName,
                              arguments: {
                                'type': "wallet",
                                'fromScreen': "pushNotification",
                              }
                          );
                        }
                        double _signupBonusAmount = double.parse(notificationDecode["body"].toString().replaceAll(new RegExp(r'[^0-9]'),''));
                        return showDialog(
                          context: navigatorKey.currentContext,
                          builder: (context) {
                            return AlertDialog(
                              content: Stack(
                                overflow: Overflow.visible,
                                children: [

                                  Container(
                                    height:250,

                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height:10),
                                          Text(S.of(navigatorKey.currentContext).Sign_Up_Bonus,
                                            style: TextStyle(
                                              color: Colors.black54, fontSize: 22,fontWeight: FontWeight.bold,
                                            ), ),
                                          SizedBox(height:10),
                                          Text(
                                            IConstants.currencyFormat + _signupBonusAmount.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                          Text(
                                            S.of(navigatorKey.currentContext).Added_to_your_wallet,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,color: Colors.grey),),
                                          SizedBox(height:20),
                                          Expanded(
                                            child: Text(
                                              notificationDecode["body"].toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18,color: Colors.grey),),
                                          ),
                                          Text(
                                            S.of(navigatorKey.currentContext).yay,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: -50,
                                    child: InkWell(
                                      child:CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child:  Image.asset(Images.gift, height: 60.0, width: 60.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    onLaunch: (Map<String, dynamic> message) async {
                      final responseJson = json.encode(message);
                      final responseJsonDecode = json.decode(responseJson);
                      final notificationEncode = json.encode(responseJsonDecode['notification']);
                      final notificationDecode = json.decode(notificationEncode);
                      final dataEncode = json.encode(responseJsonDecode['data']);
                      final dataDecode = json.decode(dataEncode);
                      // dispose();
                      timmer = false;
                      Provider.of<BrandItemsList>(navigatorKey.currentContext,listen: false).userDetails();
                      if (dataDecode["mode"].toString() == "2") {
                        // Order and 'ref' key is for fetching order id
                        if (LoginStatus != null) {
                          Navigator.of(context)
                              .pushReplacementNamed(
                              OrderhistoryScreen.routeName, arguments: {
                            'orderid': dataDecode["ref"].toString(),
                            'fromScreen': "splashNotification",
                            'notificationId': dataDecode["nid"].toString()
                          });
                        }
                      } else if (dataDecode["mode"].toString() == "3") {
                        //Web Link
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        String url = dataDecode["ref"].toString();
                        if (canLaunch(url) != null)
                          launch(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                        Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(dataDecode["nid"].toString(), "1" );
                      } else if (dataDecode["mode"].toString() == "4") {
                        //Product with array of product id (Then have to call api)
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(
                            NotProductScreen.routeName, arguments: {
                          'productId': dataDecode["ref"].toString(),
                          'fromScreen': "ClickLink",
                          'notificationId': dataDecode["nid"].toString()
                        });
                      }
                      else if (dataDecode["mode"].toString() == "5") {
                        //Sub category with array of sub category
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(
                            NotSubcategoryScreen.routeName, arguments: {
                          'subcategoryId': dataDecode["ref"].toString(),
                          'fromScreen': "ClickLink",
                          'notificationId': dataDecode["nid"].toString(),
                        });
                      } else if (dataDecode["mode"].toString() == "6") {
                        //redirect to app home page
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Provider.of<NotificationItemsList>(context, listen: false)
                            .updateNotificationStatus(
                            dataDecode["nid"].toString(), "1");
                        Navigator.of(context).pushReplacementNamed(
                          HomeScreen.routeName,
                        );
                      }
                      else if (dataDecode["mode"].toString() == "10") {
                        //redirect to app home page
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Provider.of<NotificationItemsList>(context, listen: false)
                            .updateNotificationStatus(
                            dataDecode["nid"].toString(), "1");
                        Navigator.of(context).pushReplacementNamed(
                            NotBrandScreen.routeName,
                            arguments: {
                              'brandsId': dataDecode["ref"].toString(),
                              'fromScreen': "ClickLink",
                              'notificationId': dataDecode["nid"].toString(),
                            }
                        );
                      }
                      else if (dataDecode["mode"].toString() == "13") {
                        //Sub category with array of sub category
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        {
                          Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                              arguments: {
                                'type' : "loyalty",
                                'fromScreen': "pushNotification",
                              }
                          );
                        }

                      }


                      else if (dataDecode["mode"].toString() == "14") {
                        //Sub category with array of sub category
                        if (LoginStatus == null) {
                          PrefUtils.prefs.setString('skip', "yes");
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(
                            SingleproductScreen.routeName, arguments: {
                          'itemid': dataDecode["ref"].toString(),
                          'fromScreen': "pushNotification",
                          'notificationId': dataDecode["nid"].toString(),
                          'notificationFor': '14'
                        });
                      }
                      else if(dataDecode["mode"].toString() == "12") {
                        if (LoginStatus != null) {
                          Navigator.of(context).pushReplacementNamed(
                              WalletScreen.routeName,
                              arguments: {
                                'type': "wallet",
                                'fromScreen': "pushNotification",
                              }
                          );
                        }
                      } else if(dataDecode["mode"].toString() == "50") {if (LoginStatus != null) {
                        Navigator.of(context).pushReplacementNamed(
                            WalletScreen.routeName,
                            arguments: {
                              'type': "wallet",
                              'fromScreen': "pushNotification",
                            }
                        );
                      }
                      double _signupBonusAmount = double.parse(notificationDecode["body"].toString().replaceAll(new RegExp(r'[^0-9]'),''));
                      return showDialog(
                        context: navigatorKey.currentContext,
                        builder: (context) {
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: [

                                Container(
                                  height:250,

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height:10),
                                        Text(S.of(navigatorKey.currentContext).Sign_Up_Bonus,
                                          style: TextStyle(
                                            color: Colors.black54, fontSize: 22,fontWeight: FontWeight.bold,
                                          ), ),
                                        SizedBox(height:10),
                                        Text(
                                          IConstants.currencyFormat + _signupBonusAmount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                        Text(
                                          S.of(navigatorKey.currentContext).Added_to_your_wallet,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        SizedBox(height:20),
                                        Expanded(
                                          child: Text(
                                            notificationDecode["body"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        ),
                                        Text(
                                          S.of(navigatorKey.currentContext).yay,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: -50,
                                  child: InkWell(
                                    child:CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white,
                                      child:  Image.asset(Images.gift, height: 60.0, width: 60.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      }
                      // return Fluttertoast.showToast(msg: "onLaunch!!!");
                    },
                    // onBackgroundMessage: myBackgroundMessageHandler
                  );
                  /*if (Platform.isIOS) {
            PrefUtils.prefs.setString("formapscreen", "");
            var LoginStatus = PrefUtils.prefs.getString('LoginStatus');

            LoginStatus == null
                ? Navigator.of(context).pushReplacementNamed(
                    SignupSelectionScreen.routeName,
                  )
                : PrefUtils.prefs.containsKey("deliverylocation")
                    ? Navigator.of(context).pushReplacementNamed(
                        HomeScreen.routeName,
                      )
                    : Navigator.of(context).pushReplacementNamed(
                        LocationScreen.routeName,
                      );
          }*/
                }
              }catch(e){
                timmer = false;
                PrefUtils.prefs.setString("tokenid", "");
                PrefUtils.prefs.setString('skip', "yes");
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
              }
            try {

              //versionCheck(context);

              if (Platform.isAndroid) {
                versionCheck(context);
              } else if(Platform.isIOS) {
                versionCheckForIos();
              }

              // if(timmer)startSplashScreenTimer();

            } catch (e) {
            }
          });
        if(_isWeb){
          timmer = false;
          PrefUtils.prefs.setString("tokenid", "");
          PrefUtils.prefs.setString('skip', "yes");
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }


        // INTRODUCTION SCREEN CHECK

        /*bool introduction = PrefUtils.prefs.getBool('introduction');

        if (introduction == null) {
          Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
        } else {
          startSplashScreenTimer();
        }*/

      });
     // SetUserData();

      PrefUtils.prefs.setInt("htmlId", 1);

      PrefUtils.prefs.setString("referCodeDynamic", "");
      var LoginStatus = PrefUtils.prefs.getString('LoginStatus');
      if (!PrefUtils.prefs.containsKey("branch")) PrefUtils.prefs.setString("branch", "81");
      try {
        if (Platform.isIOS || Platform.isAndroid) {
           new FirebaseNotifications().setUpFirebase();
          if(PrefUtils.prefs.containsKey("apikey")||PrefUtils.prefs.containsKey("tokenid")){
            HomeScreenController(user:  PrefUtils.prefs.getString("apikey")??PrefUtils.prefs.getString("tokenid"),branch: PrefUtils.prefs.getString("branch"),rows: "0" );
          }
       //   HomeScreenController(user:  (VxState.store as GroceStore).userData.id??PrefUtils.prefs.getString("tokenid"),branch: PrefUtils.prefs.getString("branch"),languageid: PrefUtils.prefs.getString("language_id"),rows: "0" );
          final signcode = await SmsAutoFill().getAppSignature;
          PrefUtils.prefs.setString('signature', signcode);
          handleDynamicLink();
        }
      } catch (e) {
        _isWeb = true;
      }
      if(!_isWeb)
        await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) async {
          if(Features.isPushNotification)
            try {
              if (Platform.isIOS || Platform.isAndroid) {
                _firebaseMessaging.configure(
                  onMessage: (Map<String, dynamic> message) async {
                    timmer = false;
                    Provider.of<BrandItemsList>(navigatorKey.currentContext,listen: false).userDetails();
                    final responseJson = json.encode(message);
                    final responseJsonDecode = json.decode(responseJson);
                    final notificationEncode = json.encode(responseJsonDecode['notification']);
                    final notificationDecode = json.decode(notificationEncode);
                    final dataEncode = json.encode(responseJsonDecode['data']);
                    final dataDecode = json.decode(dataEncode);

                    double _signupBonusAmount = double.parse(notificationDecode["body"].toString().replaceAll(new RegExp(r'[^0-9]'),''));

                    if(dataDecode["mode"].toString() == "50") {
                      //return Fluttertoast.showToast(msg: notificationDecode["body"].toString(), fontSize: MediaQuery.of(navigatorKey.currentContext).textScaleFactor * 13,);

                      return showDialog(
                        context: navigatorKey.currentContext,
                        builder: (context) {
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: [

                                Container(
                                  height:250,

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height:10),
                                        Text(S.of(navigatorKey.currentContext).Sign_Up_Bonus,
                                          style: TextStyle(
                                            color: Colors.black54, fontSize: 22,fontWeight: FontWeight.bold,
                                          ), ),
                                        SizedBox(height:10),
                                        Text(
                                          IConstants.currencyFormat + _signupBonusAmount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                        Text(
                                          S.of(navigatorKey.currentContext).Added_to_your_wallet,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        SizedBox(height:20),
                                        Expanded(
                                          child: Text(
                                            notificationDecode["body"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        ),
                                        Text(
                                          S.of(navigatorKey.currentContext).yay,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: -50,
                                  child: InkWell(
                                    child:CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white,
                                      child:  Image.asset(Images.gift, height: 60.0, width: 60.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                    } else {
                      return Fluttertoast.showToast(msg: notificationDecode["body"].toString(), fontSize: MediaQuery.of(navigatorKey.currentContext).textScaleFactor * 13,);
                    }


                    /* return Fluttertoast.showToast(
                  msg: notificationDecode["body"].toString());*/
                  },
                  onResume: (Map<String, dynamic> message) async {
                    timmer = false;
                    Provider.of<BrandItemsList>(navigatorKey.currentContext,listen: false).userDetails();

                    final responseJson = json.encode(message);
                    final responseJsonDecode = json.decode(responseJson);
                    final notificationEncode = json.encode(responseJsonDecode['notification']);
                    final notificationDecode = json.decode(notificationEncode);
                    final dataEncode = json.encode(responseJsonDecode['data']);
                    final dataDecode = json.decode(dataEncode);
                    // dispose();
                    // timmer = false;
                    if (dataDecode["mode"].toString() == "2") {
                      // Order and 'ref' key is for fetching order id
                      if (LoginStatus != null) {
                        Navigator.of(context)
                            .pushReplacementNamed(
                            OrderhistoryScreen.routeName, arguments: {
                          'orderid': dataDecode["ref"].toString(),
                          'fromScreen': "splashNotification",
                          'notificationId': dataDecode["nid"].toString()
                        });
                      }
                    } else if (dataDecode["mode"].toString() == "3") { //Web Link
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }

                      String url = dataDecode["ref"].toString();
                      if (canLaunch(url) != null)
                        launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                      Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(dataDecode["nid"].toString(), "1" );
                    } else if (dataDecode["mode"].toString() == "4") {
                      //Product with array of product id (Then have to call api)
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Navigator.of(context)
                          .pushReplacementNamed(
                          NotProductScreen.routeName, arguments: {
                        'productId': dataDecode["ref"].toString(),
                        'fromScreen': "ClickLink",
                        'notificationId': dataDecode["nid"].toString()
                      });
                    } else if (dataDecode["mode"].toString() == "5") {
                      //Sub category with array of sub category
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Navigator.of(context)
                          .pushReplacementNamed(
                          NotSubcategoryScreen.routeName, arguments: {
                        'subcategoryId': dataDecode["ref"].toString(),
                        'fromScreen': "ClickLink",
                        'notificationId': dataDecode["nid"].toString(),
                      });
                    } else if (dataDecode["mode"].toString() == "6") {
                      //redirect to app home page
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Provider.of<NotificationItemsList>(context, listen: false)
                          .updateNotificationStatus(
                          dataDecode["nid"].toString(), "1");
                      Navigator.of(context).pushReplacementNamed(
                        HomeScreen.routeName,
                      );
                    } else if (dataDecode["mode"].toString() == "10") {
                      //redirect to app home page
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Provider.of<NotificationItemsList>(context, listen: false)
                          .updateNotificationStatus(
                          dataDecode["nid"].toString(), "1");
                      Navigator.of(context).pushReplacementNamed(
                          NotBrandScreen.routeName,
                          arguments: {
                            'brandsId': dataDecode["ref"].toString(),
                            'fromScreen': "ClickLink",
                            'notificationId': dataDecode["nid"].toString(),
                          }
                      );
                    }
                    else if(dataDecode["mode"].toString() == "12") {
                      if (LoginStatus != null) {
                        Navigator.of(context).pushReplacementNamed(
                            WalletScreen.routeName,
                            arguments: {
                              'type': "wallet",
                              'fromScreen': "pushNotification",
                            }
                        );
                      }
                    }
                    else if(dataDecode["mode"].toString() == "13") {
                      if (LoginStatus != null) {
                        Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                            arguments: {
                              'type' : "loyalty",
                              'fromScreen': "pushNotification",

                            }
                        );
                      }
                    }
                    else if(dataDecode["mode"].toString() == "14") {
                      if (LoginStatus != null) {
                        Provider.of<NotificationItemsList>(context, listen: false)
                            .updateNotificationStatus(
                            dataDecode["nid"].toString(), "1");
                        Navigator.of(context).pushReplacementNamed(
                            NotBrandScreen.routeName,
                            arguments: {
                              'brandsId': dataDecode["ref"].toString(),
                              'fromScreen': "ClickLink",
                              'notificationId': dataDecode["nid"].toString(),
                            }
                        );
                      }
                    } else if(dataDecode["mode"].toString() == "50") {
                      if (LoginStatus != null) {
                        Navigator.of(context).pushReplacementNamed(
                            WalletScreen.routeName,
                            arguments: {
                              'type': "wallet",
                              'fromScreen': "pushNotification",
                            }
                        );
                      }
                      double _signupBonusAmount = double.parse(notificationDecode["body"].toString().replaceAll(new RegExp(r'[^0-9]'),''));
                      return showDialog(
                        context: navigatorKey.currentContext,
                        builder: (context) {
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: [

                                Container(
                                  height:250,

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height:10),
                                        Text(S.of(navigatorKey.currentContext).Sign_Up_Bonus,
                                          style: TextStyle(
                                            color: Colors.black54, fontSize: 22,fontWeight: FontWeight.bold,
                                          ), ),
                                        SizedBox(height:10),
                                        Text(
                                          IConstants.currencyFormat + _signupBonusAmount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                        Text(
                                          S.of(navigatorKey.currentContext).Added_to_your_wallet,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        SizedBox(height:20),
                                        Expanded(
                                          child: Text(
                                            notificationDecode["body"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        ),
                                        Text(
                                          S.of(navigatorKey.currentContext).yay,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: -50,
                                  child: InkWell(
                                    child:CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white,
                                      child:  Image.asset(Images.gift, height: 60.0, width: 60.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  onLaunch: (Map<String, dynamic> message) async {
                    final responseJson = json.encode(message);
                    final responseJsonDecode = json.decode(responseJson);
                    final notificationEncode = json.encode(responseJsonDecode['notification']);
                    final notificationDecode = json.decode(notificationEncode);
                    final dataEncode = json.encode(responseJsonDecode['data']);
                    final dataDecode = json.decode(dataEncode);
                    // dispose();
                    timmer = false;
                    Provider.of<BrandItemsList>(navigatorKey.currentContext,listen: false).userDetails();
                    if (dataDecode["mode"].toString() == "2") {
                      // Order and 'ref' key is for fetching order id
                      if (LoginStatus != null) {
                        Navigator.of(context)
                            .pushReplacementNamed(
                            OrderhistoryScreen.routeName, arguments: {
                          'orderid': dataDecode["ref"].toString(),
                          'fromScreen': "splashNotification",
                          'notificationId': dataDecode["nid"].toString()
                        });
                      }
                    } else if (dataDecode["mode"].toString() == "3") {
                      //Web Link
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      String url = dataDecode["ref"].toString();
                      if (canLaunch(url) != null)
                        launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                      Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(dataDecode["nid"].toString(), "1" );
                    } else if (dataDecode["mode"].toString() == "4") {
                      //Product with array of product id (Then have to call api)
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Navigator.of(context)
                          .pushReplacementNamed(
                          NotProductScreen.routeName, arguments: {
                        'productId': dataDecode["ref"].toString(),
                        'fromScreen': "ClickLink",
                        'notificationId': dataDecode["nid"].toString()
                      });
                    }
                    else if (dataDecode["mode"].toString() == "5") {
                      //Sub category with array of sub category
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Navigator.of(context)
                          .pushReplacementNamed(
                          NotSubcategoryScreen.routeName, arguments: {
                        'subcategoryId': dataDecode["ref"].toString(),
                        'fromScreen': "ClickLink",
                        'notificationId': dataDecode["nid"].toString(),
                      });
                    } else if (dataDecode["mode"].toString() == "6") {
                      //redirect to app home page
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Provider.of<NotificationItemsList>(context, listen: false)
                          .updateNotificationStatus(
                          dataDecode["nid"].toString(), "1");
                      Navigator.of(context).pushReplacementNamed(
                        HomeScreen.routeName,
                      );
                    }
                    else if (dataDecode["mode"].toString() == "10") {
                      //redirect to app home page
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Provider.of<NotificationItemsList>(context, listen: false)
                          .updateNotificationStatus(
                          dataDecode["nid"].toString(), "1");
                      Navigator.of(context).pushReplacementNamed(
                          NotBrandScreen.routeName,
                          arguments: {
                            'brandsId': dataDecode["ref"].toString(),
                            'fromScreen': "ClickLink",
                            'notificationId': dataDecode["nid"].toString(),
                          }
                      );
                    }
                    else if (dataDecode["mode"].toString() == "13") {
                      //Sub category with array of sub category
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      {
                        Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
                            arguments: {
                              'type' : "loyalty",
                              'fromScreen': "pushNotification",
                            }
                        );
                      }

                    }


                    else if (dataDecode["mode"].toString() == "14") {
                      //Sub category with array of sub category
                      if (LoginStatus == null) {
                        PrefUtils.prefs.setString('skip', "yes");
                      }
                      Navigator.of(context)
                          .pushReplacementNamed(
                          SingleproductScreen.routeName, arguments: {
                        'itemid': dataDecode["ref"].toString(),
                        'fromScreen': "pushNotification",
                        'notificationId': dataDecode["nid"].toString(),
                        'notificationFor': '14'
                      });
                    }
                    else if(dataDecode["mode"].toString() == "12") {
                      if (LoginStatus != null) {
                        Navigator.of(context).pushReplacementNamed(
                            WalletScreen.routeName,
                            arguments: {
                              'type': "wallet",
                              'fromScreen': "pushNotification",
                            }
                        );
                      }
                    } else if(dataDecode["mode"].toString() == "50") {if (LoginStatus != null) {
                        Navigator.of(context).pushReplacementNamed(
                            WalletScreen.routeName,
                            arguments: {
                              'type': "wallet",
                              'fromScreen': "pushNotification",
                            }
                        );
                      }
                      double _signupBonusAmount = double.parse(notificationDecode["body"].toString().replaceAll(new RegExp(r'[^0-9]'),''));
                      return showDialog(
                        context: navigatorKey.currentContext,
                        builder: (context) {
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: [

                                Container(
                                  height:250,

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height:10),
                                        Text(S.of(navigatorKey.currentContext).Sign_Up_Bonus,
                                          style: TextStyle(
                                            color: Colors.black54, fontSize: 22,fontWeight: FontWeight.bold,
                                          ), ),
                                        SizedBox(height:10),
                                        Text(
                                          IConstants.currencyFormat + _signupBonusAmount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                        Text(
                                          S.of(navigatorKey.currentContext).Added_to_your_wallet,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        SizedBox(height:20),
                                        Expanded(
                                          child: Text(
                                            notificationDecode["body"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,color: Colors.grey),),
                                        ),
                                        Text(
                                          S.of(navigatorKey.currentContext).yay,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: -50,
                                  child: InkWell(
                                    child:CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white,
                                      child:  Image.asset(Images.gift, height: 60.0, width: 60.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    // return Fluttertoast.showToast(msg: "onLaunch!!!");
                  },
                  // onBackgroundMessage: myBackgroundMessageHandler
                );
                /*if (Platform.isIOS) {
            PrefUtils.prefs.setString("formapscreen", "");
            var LoginStatus = PrefUtils.prefs.getString('LoginStatus');

            LoginStatus == null
                ? Navigator.of(context).pushReplacementNamed(
                    SignupSelectionScreen.routeName,
                  )
                : PrefUtils.prefs.containsKey("deliverylocation")
                    ? Navigator.of(context).pushReplacementNamed(
                        HomeScreen.routeName,
                      )
                    : Navigator.of(context).pushReplacementNamed(
                        LocationScreen.routeName,
                      );
          }*/
              }
            }catch(e){
              timmer = false;
              PrefUtils.prefs.setString("tokenid", "");
              PrefUtils.prefs.setString('skip', "yes");
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            }
          try {

            //versionCheck(context);

            if (Platform.isAndroid) {
              versionCheck(context);
            } else if(Platform.isIOS) {
              versionCheckForIos();
            }

            // if(timmer)startSplashScreenTimer();

          } catch (e) {
          }
        });
      if(_isWeb){
        timmer = false;
        PrefUtils.prefs.setString("tokenid", "");
        PrefUtils.prefs.setString('skip', "yes");
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }


      // INTRODUCTION SCREEN CHECK

      /*bool introduction = PrefUtils.prefs.getBool('introduction');

        if (introduction == null) {
          Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
        } else {
          startSplashScreenTimer();
        }*/

    });

  }
  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {

    var LoginStatus = PrefUtils.prefs.getString('LoginStatus');
    final responseJson = json.encode(message);
    final responseJsonDecode = json.decode(responseJson);
    final dataEncode = json.encode(responseJsonDecode['data']);
    final dataDecode = json.decode(dataEncode);
    if (dataDecode["mode"].toString() == "2") {
      // Order and 'ref' key is for fetching order id
      if (LoginStatus != null) {
        Navigator.of(context)
            .pushNamed(OrderhistoryScreen.routeName, arguments: {
          'orderid': dataDecode["ref"].toString(),
          'fromScreen': "splashNotification",
          'notificationId': dataDecode["nid"].toString()
        });
      }
    } else if (dataDecode["mode"].toString() == "3") {
      //Web Link
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      String url = dataDecode["ref"].toString();
      if (canLaunch(url) != null)
        launch(url);
      else
        // can't launch url, there is some error
        throw "Could not launch $url";
      Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(dataDecode["nid"].toString(), "1" );
    } else if (dataDecode["mode"].toString() == "4") {
      //Product with array of product id (Then have to call api)
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      Navigator.of(context)
          .pushNamed(NotProductScreen.routeName, arguments: {
        'productId': dataDecode["ref"].toString(),
        'fromScreen': "ClickLink",
        'notificationId': dataDecode["nid"].toString()
      });
    }else if(dataDecode["mode"].toString() == "12") {
      Navigator.of(context).pushReplacementNamed(WalletScreen.routeName,
          arguments: {
            'type' : "wallet",
            'fromScreen': "pushNotification",

          }
      );
    }
    else if (dataDecode["mode"].toString() == "5") {
      //Sub category with array of sub category
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      Navigator.of(context)
          .pushNamed(NotSubcategoryScreen.routeName, arguments: {
        'subcategoryId': dataDecode["ref"].toString(),
        'fromScreen': "ClickLink",
        'notificationId': dataDecode["nid"].toString(),
      });
    } else if (dataDecode["mode"].toString() == "6") {
      //redirect to app home page
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      Provider.of<NotificationItemsList>(context, listen: false)
          .updateNotificationStatus(
          dataDecode["nid"].toString(), "1");
      Navigator.of(context).pushReplacementNamed(
        HomeScreen.routeName,
      );
    } else if (dataDecode["mode"].toString() == "10") {
      //redirect to app home page
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      if (LoginStatus == null) {
        PrefUtils.prefs.setString('skip', "yes");
      }
      Provider.of<NotificationItemsList>(context, listen: false)
          .updateNotificationStatus(
          dataDecode["nid"].toString(), "1");
      Navigator.of(context).pushReplacementNamed(
          NotBrandScreen.routeName,
          arguments: {
            'brandsId' : dataDecode["ref"].toString(),
            'fromScreen' : "ClickLink",
            'notificationId' : dataDecode["nid"].toString(),
          }
      );
    }


    // Or do other work.
  }
  versionCheck(context) async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    print("pre check for update!");
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      bool forceupdate = remoteConfig
          .getBool('forceupdate');
      inappupdate.checkForUpdate(context,forceupdate,()async {
        print("check for update!");

        //Get Current installed version of app
        final PackageInfo info = await PackageInfo.fromPlatform();
        double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

        //Get Latest version info from firebase config
        final RemoteConfig remoteConfig = await RemoteConfig.instance;

        try {
          // Using default duration to force fetching from remote server.
          await remoteConfig.fetch(expiration: const Duration(seconds: 0));
          await remoteConfig.activateFetched();
          double forcedVersion = double.parse(remoteConfig
              .getString('force_update_current_version')
              .trim()
              .replaceAll(".", ""));
          double optionalVersion = double.parse(remoteConfig
              .getString('optional_update_version')
              .trim()
              .replaceAll(".", ""));

          if (forcedVersion > currentVersion) {
            _showForcedVersionDialog(context);
          } else if (optionalVersion > currentVersion) {
            _showOptionalVersionDialog(context);
          } else {
            /*await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {

            });*/
            // INTRODUCTION SCREEN CHECK
            if(Features.isOnBoarding){
              bool introduction = PrefUtils.prefs.getBool('introduction');
              if(introduction == null) {
                if(timmer) Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
              }
              else {
                if(timmer) startSplashScreenTimer();
              }

            }
            else{
              if(timmer)startSplashScreenTimer();
            }

          }
        } on FetchThrottledException catch (exception) {
          // Fetch throttled.
        }
        catch (exception) {
        }
      });
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
    }
    catch (exception) {
    }

    // //Get Current installed version of app
    // final PackageInfo info = await PackageInfo.fromPlatform();
    // double currentVersion =
    // double.parse(info.version.trim().replaceAll(".", ""));
    //
    // //Get Latest version info from firebase config
    // final RemoteConfig remoteConfig = await RemoteConfig.instance;
    //
    // try {
    //   // Using default duration to force fetching from remote server.
    //   await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    //   await remoteConfig.activateFetched();
    //   double forcedVersion = double.parse(remoteConfig
    //       .getString('force_update_current_version')
    //       .trim()
    //       .replaceAll(".", ""));
    //   double optionalVersion = double.parse(remoteConfig
    //       .getString('optional_update_version')
    //       .trim()
    //       .replaceAll(".", ""));
    //
    //   if (forcedVersion > currentVersion) {
    //     _showForcedVersionDialog(context);
    //   } else if (optionalVersion > currentVersion) {
    //     _showOptionalVersionDialog(context);
    //   } else {
    //     /*await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
    //
    //     });*/
    //     // INTRODUCTION SCREEN CHECK
    //     if(Features.isOnBoarding){
    //       bool introduction = PrefUtils.prefs.getBool('introduction');
    //       if(introduction == null) {
    //         if(timmer) Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
    //       }
    //       else {
    //         if(timmer) startSplashScreenTimer();
    //       }
    //
    //     }
    //     else{
    //       if(timmer)startSplashScreenTimer();
    //     }
    //
    //   }
    // } on FetchThrottledException catch (exception) {
    //   // Fetch throttled.
    // }
    // catch (exception) {
    // }
  }

  versionCheckForIos() async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version_ios');
      remoteConfig.getString('optional_update_version_ios');
      double forcedVersion = double.parse(remoteConfig
          .getString('force_update_current_version_ios')
          .trim()
          .replaceAll(".", ""));
      double optionalVersion = double.parse(remoteConfig
          .getString('optional_update_version_ios')
          .trim()
          .replaceAll(".", ""));

      if (forcedVersion > currentVersion) {
        _showForcedVersionDialog(context);
      } else if (optionalVersion > currentVersion) {
        _showOptionalVersionDialog(context);
      } else {
        // INTRODUCTION SCREEN CHECK
        /*await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {

        });*/
        // INTRODUCTION SCREEN CHECK
        if(Features.isOnBoarding){
          bool introduction = PrefUtils.prefs.getBool('introduction');
          if(introduction == null) {
            if(timmer) Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
          }
          else {
            if(timmer) startSplashScreenTimer();
          }

        }
        else{
          if(timmer)startSplashScreenTimer();
        }
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
    } catch (exception) {
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      // INTRODUCTION SCREEN CHECK

      bool introduction = PrefUtils.prefs.getBool('introduction');

      /*if(introduction == null) {
        Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
      }
      else {
        startSplashScreenTimer();
      }*/
      //startSplashScreenTimer();
      try {
        if (Platform.isAndroid) {
          versionCheck(context);
        } else if (Platform.isIOS) {
          versionCheckForIos();
        }
      }catch(e){

      }
    } else {
      throw 'Could not launch $url';
    }
  }

  _forcedLaunchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      // INTRODUCTION SCREEN CHECK

      /*bool introduction = PrefUtils.prefs.getBool('introduction');

      if(introduction == null) {
        Navigator.of(context).pushReplacementNamed(introductionscreen.routeName);
      }
      else {
        startSplashScreenTimer();
      }*/
      try {
        if (Platform.isAndroid) {
          versionCheck(context);
        } else if (Platform.isIOS) {
          versionCheckForIos();
        }
      }catch(e){

      }
    } else {
      throw 'Could not launch $url';
    }
  }

  _showForcedVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title =
            S.of(context).new_update;
        //"New Update Available";
        String message =  S.of(context).there_is_newer_version;
        //  "There is a newer version of app available please update it now.";
        String btnLabel =  S.of(context).update_now;
        //   "Update Now";
        String btnLabelCancel =   S.of(context).later;
        //"Later";
        return Platform.isIOS
            ? new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _forcedLaunchURL(APP_STORE_URL),
            ),
            /*FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => startSplashScreenTimer(),
            ),*/
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                child: Text(btnLabel),
                onPressed: () {
                  _forcedLaunchURL(PLAY_STORE_URL);
                }
            ),
/*            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => startSplashScreenTimer(),
            ),*/
          ],
        );
      },
    );
  }

  _showOptionalVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title =   S.of(context).new_update;
        //"New Update Available";
        String message =
            S.of(context).there_is_newer_version;
        //  "There is a newer version of app available please update it now.";
        String btnLabel =   S.of(context).update_now;
        // "Update Now";
        String btnLabelCancel =  S.of(context).later;
        // "Later";
        return Platform.isIOS
            ? new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(APP_STORE_URL),
            ),
            FlatButton(
                child: Text(btnLabelCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                  // startSplashScreenTimer();
                  try {
                    if (Platform.isAndroid) {
                      versionCheck(context);
                    } else if (Platform.isIOS) {
                      versionCheckForIos();
                    }
                  }catch(e){

                  }
                }
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(PLAY_STORE_URL),
            ),
            FlatButton(
                child: Text(btnLabelCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                  //startSplashScreenTimer();
                  try {
                    if (Platform.isAndroid) {
                      versionCheck(context);
                    } else if (Platform.isIOS) {
                      versionCheckForIos();
                    }
                  }catch(e){

                  }
                }
            ),
          ],
        );
      },
    );
  }

  handleDynamicLink() async {
    // await Future.delayed(Duration(seconds: 3));

    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];
        PrefUtils.prefs.setString("referCodeDynamic", code);

      }

    }
    /*await dynamicLink.getInitialLink();
    dynamicLink.onLink(onSuccess: (PendingDynamicLinkData data) async {
      handleSuccessLinking(data);
    }, onError: (OnLinkErrorException error) async {
      print(error.message.toString());
    });*/
  }

  void handleSuccessLinking(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];

        PrefUtils.prefs.setString("referCodeDynamic", code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));*/
    // full screen image for splash screen.
    //handleDynamicLink();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      //backgroundColor: ColorCodes.whiteColor,
      home: Center(
        child: new Image.asset(
          Images.splashImg,
          width: MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
