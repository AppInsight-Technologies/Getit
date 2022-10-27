import 'dart:convert';
import 'dart:async'; // for Timer class
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/features.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../screens/home_screen.dart';
import '../screens/location_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/cart_screen.dart';
import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../providers/addressitems.dart';
import '../screens/address_screen.dart';
import '../screens/confirmorder_screen.dart';
import 'login_screen.dart';

class OtpconfirmScreen extends StatefulWidget {
  static const routeName = '/otp-confirm';

  @override
  OtpconfirmScreenState createState() => OtpconfirmScreenState();
}

class OtpconfirmScreenState extends State<OtpconfirmScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  var _isLoading = false;
  int _timeRemaining = 30;
  var _showCall = false;
  Timer _timer;
  var mobilenum = "";
  String otp1, otp2, otp3, otp4;
  TextEditingController controller = TextEditingController();
  var otpvalue = "";
  bool _showOtp = false;
  var addressitemsData;

  String apple = "";
  String name = "";
  String email = "";
  String mobile = "";
  String tokenid = "";
  String referid = "";
  bool _isWeb =false;
  bool iphonex = false;
  GroceStore store = VxState.store;


  _getmobilenum() async {
    debugPrint("mobile...");
    debugPrint("mobile...2"+PrefUtils.prefs.getString('Mobilenum'));
    mobilenum = PrefUtils.prefs.getString('Mobilenum');
  }

  @override
  void initState() {
//    LoginUser();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    _getmobilenum();
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
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        addressitemsData = Provider.of<AddressItemsList>(context, listen: false);

        if (PrefUtils.prefs.getString('applesignin') == "yes") {
          apple = PrefUtils.prefs.getString('apple');
        } else {
          apple = "";
        }
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
        //name = PrefUtils.prefs.getString('FirstName') + " " + PrefUtils.prefs.getString('LastName');
        /*if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
          email = "";
        } else {
          email = PrefUtils.prefs.getString('Email');
        }*/
        email = store.userData.email;
        mobile = store.userData.mobileNumber;
        tokenid = PrefUtils.prefs.getString('tokenid');
        referid =PrefUtils.prefs.getString('referid');
      });
    });
    super.initState();
    _listenotp();
  }

  addReferToSF(String value) async{

    PrefUtils.prefs.setString('referid', value);
  }
  void _listenotp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    setState(() {
      _timeRemaining == 0 ? _timeRemaining = 0 : _timeRemaining--;
    });
  }

  addOtpvalToSF(String value) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    if (PrefUtils.prefs.getString('Otpval') == null) {
      PrefUtils.prefs.setString('Otpval', value);
    } else {
      String otp = PrefUtils.prefs.getString('Otpval') + value;
      PrefUtils.prefs.setString('Otpval', otp);
    }
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

  _verifyOtp(String otpvalue) async {
    //var otpval = otp1 + otp2 + otp3 + otp4;
    store.CartItemList.clear();
    store.homescreen.data=null;
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
 //debugPrint("otpvalue.."+otpvalue+ "  "+  PrefUtils.prefs.getString('Otp'));
 //debugPrint(otpvalue+" "+PrefUtils.prefs.getString('Otp'));
    if (otpvalue ==  PrefUtils.prefs.getString('Otp')) {
      setState(() {
        _isLoading = true;
      });

      if(routeArgs['prev'].toString() == "cartScreen") {
        verifynum();
      } else {
        if (!PrefUtils.prefs.getBool('type')) {
          debugPrint("not type....");
          PrefUtils.prefs.setString('LoginStatus', "true");
          PrefUtils.prefs.setString('skip', "no");
         // _getprimarylocation();
          /*return Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,);*/
          Navigator.of(context).pushReplacementNamed(
          HomeScreen.routeName,
        );
        } else {
          PrefUtils.prefs.setString('prevscreen', "otpconfirmscreen");
          Navigator.of(context).pop();
          PrefUtils.prefs.setString('skip', "no");
          return Navigator.of(context).pushNamedAndRemoveUntil(
              SignupScreen.routeName,
              ModalRoute.withName(CartScreen.routeName), arguments: {
            "after_login": ""
          });
          /*       if (PrefUtils.prefs.getString('prevscreen') == 'signingoogle' ||
              PrefUtils.prefs.getString('prevscreen') == 'signupselectionscreen' ||
              PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail' ||
              PrefUtils.prefs.getString('prevscreen') == 'signInApple' ||
              PrefUtils.prefs.getString('prevscreen') == 'signinfacebook') {
            return signupUser();
          } else {
            PrefUtils.prefs.setString('prevscreen', "otpconfirmscreen");
            Navigator.of(context).pop();
            return Navigator.of(context).pushNamedAndRemoveUntil(
                SignupScreen.routeName,
                ModalRoute.withName(CartScreen.routeName));
            *//*Navigator.of(context).pushReplacementNamed(
            SignupScreen.routeName,
          );*//*
          }
//        return signupUser();*/
        }
      }

      /* if (PrefUtils.prefs.getString('type') == "old") {
        PrefUtils.prefs.setString('LoginStatus', "true");
        _getprimarylocation();
        *//*return Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,);*//*
        *//*Navigator.of(context).pushReplacementNamed(
          HomeScreen.routeName,
        );*//*
      } else {
        if (PrefUtils.prefs.getString('prevscreen') == 'signingoogle' ||
            PrefUtils.prefs.getString('prevscreen') == 'signupselectionscreen' ||
            PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail' ||
            PrefUtils.prefs.getString('prevscreen') == 'signInApple' ||
            PrefUtils.prefs.getString('prevscreen') == 'signinfacebook') {
          return SignupUser();
        } else {
          PrefUtils.prefs.setString('prevscreen', "otpconfirmscreen");
          return Navigator.of(context).pushNamedAndRemoveUntil(
              SignupScreen.routeName,
              ModalRoute.withName(CartScreen.routeName));
          *//*Navigator.of(context).pushReplacementNamed(
            SignupScreen.routeName,
          );*//*
        }*/
//        return SignupUser();
      // }
    } else {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
      return Fluttertoast.showToast(msg: S.of(context).please_enter_valid_otp,//"Please enter a valid otp!!!",
      gravity: ToastGravity.BOTTOM,
      fontSize: MediaQuery.of(context).textScaleFactor *13,
      );
    }
  }

  Future<void> verifynum() async {
    try {
      final response = await http.post(Api.updateMobileNumber, body: {
        // await keyword is used to wait to this operation is complete.
        "id":PrefUtils.prefs.getString('apikey'),
        "mobile":PrefUtils.prefs.getString('Mobilenum'),

      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == "200") {
        PrefUtils.prefs.setString('mobile',PrefUtils.prefs.getString('Mobilenum'));

        Navigator.of(context).pop();

        if (addressitemsData.items.length > 0) {
          Navigator.of(context).pushReplacementNamed(
              ConfirmorderScreen.routeName,
              arguments: {"prev": "address_screen"});
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AddressScreen.routeName,
              ModalRoute.withName(CartScreen.routeName), arguments: {
            'addresstype': "new",
            'addressid': "",
            'delieveryLocation': "",
            'latitude': "",
            'longitude': "",
            'branch': "",
            "after_login": ""
          });

          /*Navigator.of(context).pushNamed(
              AddressScreen.routeName,
              arguments: {
                'addresstype': "new",
                'addressid': "",
                'delieveryLocation': "",
                'latitude': "",
                'longitude': "",
                'branch': ""
              });*/
        }
        /*return  Navigator.of(context).pushReplacementNamed(
           ConfirmorderScreen.routeName,
           arguments: {
             "prev": "address_screen",
           });*/

      }
      else{
        Navigator.of(context).pop();
        return Fluttertoast.showToast(msg: responseJson['data'], fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }

    }
    catch (error) {
      throw error;
    }

  }

  Future<void> _getprimarylocation() async {
    try {
      final response = await http.post(Api.getProfile, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs.getString('apiKey'),
      });

      final responseJson = json.decode(response.body);

      final dataJson =
          json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      /*if(dataJsondecode.containsKey('area')){*/
      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[
              index]
          as Map<String, dynamic>)); //store each category values in data list
      //PrefUtils.prefs.setString('LoginStatus', "true");
      /*if(data.contains("area")) {*/
      for (int i = 0; i < data.length; i++) {
        PrefUtils.prefs.setString("deliverylocation", data[i]['area']);
        PrefUtils.prefs.setString("branch", data[i]['branch']);
        debugPrint("Branch in otp screen...."+ data[i]['branch'].toString());
        Navigator.of(context).pop();
        if (PrefUtils.prefs.containsKey("deliverylocation")) {
          if (PrefUtils.prefs.containsKey("fromcart")) {
            if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs.remove("fromcart");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  CartScreen.routeName,
                  ModalRoute.withName(HomeScreen.routeName),arguments: {
                "after_login": "AftercartScreen"
              });
              /*Navigator.of(context).pushReplacementNamed(
                CartScreen.routeName,);*/
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  ModalRoute.withName(OtpconfirmScreen.routeName));
              /*Navigator.of(context).pushReplacementNamed(
                HomeScreen.routeName,);*/
            }
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, ModalRoute.withName('/'));
            /*Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,);*/
          }
        }
        else {
          if(PrefUtils.prefs.getString("ismap").toString()=="true") {
            if(PrefUtils.prefs.getString("fromcart").toString()=="cart_screen"){
              // Navigator.of(context).pop();
              Navigator.of(context)
                  .pushNamed(LoginScreen.routeName,);

            }
            else{
              /* Navigator.of(context).pop();
            return Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );*/
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            }


          }
          else if(PrefUtils.prefs.getString("isdelivering").toString()=="true"){


            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);


          }
          else {
            debugPrint("else...");
            PrefUtils.prefs.setString("formapscreen", "homescreen");
            PrefUtils.prefs.setString("latitude", PrefUtils.prefs.getString("restaurant_lat"));
            PrefUtils.prefs.setString("longitude", PrefUtils.prefs.getString("restaurant_long"));
            PrefUtils.prefs.setString("ismap", "true");
            PrefUtils.prefs.setString("isdelivering", "true");
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
         /* Navigator.of(context).pushNamedAndRemoveUntil(
              LocationScreen.routeName, ModalRoute.withName('/'));*/
          /*Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,);*/
        }
      }

      /* } else {
          Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,);
        }*/
      /*} else {
        Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,);
      }*/

    } catch (error) {
      throw error;
    }
  }

  Future<void> Otpin30sec() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
//      var Mobilenum = PrefUtils.prefs.getString('Mobilenum');

      final response = await http.post(Api.resendOtp30, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> otpCall() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.resendOtpCall, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> signupUser() async {
    // imp feature in adding async is the it automatically wrap into Future.
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
      //SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": name,
        "email": email,
        "mobileNumber": mobile,
        "path": apple,
        "tokenId": tokenid,
        "branch": PrefUtils.prefs.getString('branch'),
        "signature":
            PrefUtils.prefs.containsKey("signature") ? PrefUtils.prefs.getString('signature') : "",
       // "referralid":/*referid*/ PrefUtils.prefs.getString('referid'),
        "referralid": (PrefUtils.prefs.getString("referCodeDynamic") == "" || PrefUtils.prefs.getString("referCodeDynamic") == null)? "": PrefUtils.prefs.getString('referid'),
        "device": channel.toString(),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs.setString('mobile', PrefUtils.prefs.getString('Mobilenum'));
        PrefUtils.prefs.setString('referid', PrefUtils.prefs.getString('referid'));
        PrefUtils.prefs.setString('LoginStatus', "true");
        /*Navigator.of(context).pop();

        return Navigator.of(context).pushNamedAndRemoveUntil(
            LocationScreen.routeName, ModalRoute.withName('/'));*/
        /*Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,);*/

        if(responseJson['type'].toString() == "old"){
          Navigator.of(context).pop();
          return Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName, ModalRoute.withName('/'));
        }
        else{
          if (PrefUtils.prefs.getString("ismap").toString() == "true") {
            addprimarylocation();
          }
          else if (PrefUtils.prefs.getString("isdelivering").toString() == "true")
          {
            // Navigator.of(context).pop();
            addprimarylocation();
          }
          else {
            Navigator.of(context).pop();
            debugPrint("else...");

            PrefUtils.prefs.setString("latitude", PrefUtils.prefs.getString("restaurant_lat"));
            PrefUtils.prefs.setString("longitude", PrefUtils.prefs.getString("restaurant_long"));
            PrefUtils.prefs.setString("ismap", "true");
            PrefUtils.prefs.setString("isdelivering", "true");
            addprimarylocation();
            //prefs.setString("formapscreen", "homescreen");
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
          // Navigator.of(context).pop();
          // return Navigator.of(context).pushNamedAndRemoveUntil(
          //     LocationScreen.routeName, ModalRoute.withName('/'));
        }
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }


  Future<void> addprimarylocation() async {
    debugPrint("A d d p r i m r y .....");

    var url = IConstants.API_PATH + 'add-primary-location';
    try {

      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs.getString("userID"),
        "latitude": PrefUtils.prefs.getString("latitude"),
        "longitude":PrefUtils.prefs.getString("longitude"),
        "area": IConstants.deliverylocationmain.value.toString(),
        "branch": PrefUtils.prefs.getString('branch'),
      });
      final responseJson = json.decode(response.body);
      debugPrint("response add primary...."+responseJson.toString());
      if (responseJson["data"].toString() == "true") {
        if(PrefUtils.prefs.getString("ismap").toString()=="true") {
          if(PrefUtils.prefs.getString("fromcart").toString()=="cart_screen"){
            // Navigator.of(context).pop();
            Navigator.of(context)
                .pushNamed(LoginScreen.routeName,);

          }
          else{
            /* Navigator.of(context).pop();
            return Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );*/
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          }


        }
        else if(PrefUtils.prefs.getString("isdelivering").toString()=="true"){

          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);


        }
        else {
          debugPrint("else...");

          PrefUtils.prefs.setString("formapscreen", "homescreen");
          PrefUtils.prefs.setString("latitude", PrefUtils.prefs.getString("restaurant_lat"));
          PrefUtils.prefs.setString("longitude", PrefUtils.prefs.getString("restaurant_long"));
          PrefUtils.prefs.setString("ismap", "true");
          PrefUtils.prefs.setString("isdelivering", "true");
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
          /* Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,
          );*/
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
   /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: Theme.of(context).primaryColor, // status bar color
    ));*/
    IConstants.isEnterprise? FlutterStatusbarcolor.setStatusBarColor(ColorCodes.primaryColor):
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.grey,
    ));

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      // appBar: NewGradientAppBar(
      //   gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       colors: [
      //         ColorCodes.accentColor,
      //                   ColorCodes.primaryColor
      //       ]),
      //   title: Text(
      //     'Signup using OTP',
      //     style: TextStyle(fontWeight: FontWeight.normal),
      //   ),
      // ),
      backgroundColor: ColorCodes.whiteColor,
      body:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Verify with OTP",
                style: TextStyle(
                    color: ColorCodes.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
                // textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20.0),
                Text(
                  IConstants.countryCode + '  $mobilenum',
                  style: new TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16.0),
                ),
                SizedBox(width: 30.0),
                GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginCredentialScreen.routeName,
                        ModalRoute.withName('/'));*/
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0x707070B8), width: 1.5),
                    ),
                    child: Center(
                        child: Text(
                            S.of(context).change,//'Change',
                            style: TextStyle(
                                color: ColorCodes.blackColor, fontSize: 13))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right:20),
              child: Text(
                S.of(context).enter_otp,//'Enter OTP',
                style: TextStyle(color: ColorCodes.greyColor, fontSize: 14, fontWeight: FontWeight.bold),
                //textAlign: TextAlign.left,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              // Auto Sms
              Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 98 / 100,
                  padding: EdgeInsets.only(left: 20.0,right:20),
                  child: PinFieldAutoFill(
                    controller: controller,
                    decoration: UnderlineDecoration(
                        //gapSpace: 30.0,
                        textStyle: TextStyle(fontSize: 18, color: ColorCodes.blackColor),
                        colorBuilder: FixedColorBuilder(ColorCodes.greyColor)),
                    onCodeChanged: (text) {
                      otpvalue = text;
                      print("text......" + text + "  "+ otpvalue);
                      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {

                      }));
                      if(text.length == 4) {
                        _dialogforProcessing();
                        _verifyOtp(otpvalue);
                      }
                    },
                    onCodeSubmitted: (text) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((_) => setState(() {
                                otpvalue = text;
                                print("text......otp" + text + "  "+ otpvalue);
                              }));
                    },
                    codeLength: 4,
                    currentCode: otpvalue,
                  ))
            ]),
            SizedBox(
              height: 35,
            ),

            // new Resend OTP buttons

            _showOtp
                ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height/16,
                          width: MediaQuery.of(context).size.width * 38 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: ColorCodes.lightGreyWebColor, width: 1),
                          ),
                          child: Center(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).resend_otp,//'Resend OTP',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      if(Features.callMeInsteadOTP)
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: ColorCodes.greyColor, width: 1.5),
                          ),
                          child: Center(
                              child: Text(
                                S.of(context).or,//'OR',
                            style: TextStyle(
                                fontSize: 7, color: ColorCodes.greyColor),
                          )),
                        ),
                        if(Features.callMeInsteadOTP)
                        _timeRemaining == 0
                            ? GestureDetector(
                                onTap: () {
                                  otpCall();
                                  _timeRemaining = 60;
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height/16,
                                  width: MediaQuery.of(context).size.width *
                                      38 /
                                      100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: Colors.green, width: 1.5),
                                  ),
                                  child: Center(
                                      child: Text(
                                        S.of(context).call_me_instead,//'Call me Instead',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  )),
                                ),
                              )
                            : Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: S.of(context).call_in,//'Call in',
                                        style:
                                            TextStyle(color: Colors.black)),
                                    new TextSpan(
                                      text: ' 00:$_timeRemaining',
                                      style: TextStyle(
                                        color: ColorCodes.lightGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _timeRemaining == 0
                          ? GestureDetector(
                              onTap: () {
                                // _showCall = true;
                                _showOtp = true;
                                _timeRemaining += 30;
                                Otpin30sec();
                              },
                              child: Center(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right:20),
                                    child: Text(
                                      S.of(context).resend_otp,//'Resend OTP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height/16,
                              width:
                                  MediaQuery.of(context).size.width * 45 / 100,

                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(6),
                              //   border: Border.all(
                              //       color: Color(0x707070B8), width: 1.5),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.only(top:2.0,bottom:2,left:20,right:20),
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: S.of(context).resend_otp_in,//'Resend Otp in',
                                            style:
                                                TextStyle(color: ColorCodes.greyColor, fontSize: 16)),
                                        new TextSpan(

                                          text: ' 00:$_timeRemaining',
                                          style: TextStyle(
                                            color: ColorCodes.blackColor, fontWeight: FontWeight.bold,fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      if(Features.isor)
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: ColorCodes.greyColor, width: 1.5),
                        ),
                        child: Center(
                            child: Text(
                              S.of(context).or,//'OR',
                          style: TextStyle(fontSize: 8),
                        )),
                      ),
                      if(Features.callMeInsteadOTP)
                      Center(child: Text(S.of(context).call_me_instead,//'Call me Instead',
                        style: TextStyle(color: ColorCodes.discountoff, fontWeight: FontWeight.bold, fontSize: 16, decoration: TextDecoration.underline,),)),
                    ],
                  ),
            // This expands the row element vertically because it's inside a column
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // This makes the blue container full width.
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          _dialogforProcessing();
                          _verifyOtp(otpvalue);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
                          child: Container(
//                          padding: EdgeInsets.all(20),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: ColorCodes.discountoff,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  border: Border.all(
                                    color: ColorCodes.discountoff,
                                  )),
                              height: 50.0,
                              child: Center(
                                child: Text(
                                  "SUBMIT OTP",//"LOGIN",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color:ColorCodes.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ]),
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
            Navigator.of(context).pop();
           // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            return Future.value(false);
          }
      ),
      titleSpacing: 0,
      title: Text(
        S.of(context).signup_otp,//'Signup using OTP',
        style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),
      ),
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
