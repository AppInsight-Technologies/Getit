import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/login.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/user.dart';
import '../../providers/addressitems.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../screens/addinfo_screen.dart';
import '../../screens/signup_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/features.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../services/firebaseAnaliticsService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import "package:http/http.dart" as http;

import '../constants/IConstants.dart';
import '../screens/location_screen.dart';
import '../screens/policy_screen.dart';
import '../screens/login_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../providers/branditems.dart';
import '../handler/firebase_notification_handler.dart';
import '../screens/otpconfirm_screen.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignupSelectionScreen extends StatefulWidget {
  static const routeName = '/signupselection-screen';

  @override
  SignupSelectionScreenState createState() => SignupSelectionScreenState();
}

class SignupSelectionScreenState extends State<SignupSelectionScreen> {
  bool _isAvailable = false;
  final _form = GlobalKey<FormState>();
  String countryName = "India";
  bool _isLoading = false;
  bool _isWeb = true;
  int count = 0;
  bool _showOtp = false;
  int _timeRemaining = 30;
  TextEditingController controller = TextEditingController();
  final TextEditingController _referController = new TextEditingController();
  String _appletoken = "";
  UserData addressdata;
  String channel = "";
 String OTP = "";
  GroceStore store = VxState.store;
  Auth _auth = Auth();
  var addressitemsData;
  String apple = "";
  String name = "";
  String email = "";
  String mobile = "";
  String tokenid = "";
  String referid = "";
  var otpvalue = "";
  bool iphonex = false;
  Timer _timer;
  StateSetter otpState;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    fas.setScreenName("Login");


    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          iphonex = MediaQuery.of(context).size.height >= 812.0;
          AppleSignIn.onCredentialRevoked.listen((_) {});
          if (await AppleSignIn.isAvailable()) {
            setState(() {
              _isAvailable = true;
            });
          } else {
            setState(() {
              _isAvailable = false;
            });
          }
          channel = "IOS";
        }else{
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }
      if(PrefUtils.prefs.getString("referCodeDynamic") == "" || PrefUtils.prefs.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs.getString("referCodeDynamic");
      }
      if (PrefUtils.prefs.getString('applesignin') == "yes") {
        _appletoken = PrefUtils.prefs.getString('apple');
      } else {
        _appletoken = "";
      }
      setState(() {
        countryName = CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name;
        PrefUtils.prefs.setString("skip", "no");
      });
      await new FirebaseNotifications().setUpFirebase();
      await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
        if (!PrefUtils.prefs.containsKey("deliverylocation")) {
          PrefUtils.prefs.setString(
              "deliverylocation", PrefUtils.prefs.getString("restaurant_location"));
          PrefUtils.prefs.setString("latitude", PrefUtils.prefs.getString("restaurant_lat"));
          PrefUtils.prefs.setString("longitude", PrefUtils.prefs.getString("restaurant_long"));
        }
      });
      handleDynamicLink();// only create the future once.
    });
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
    super.initState();
    _googleSignIn.signInSilently();

  }

  addReferToSF(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('referid', value);
  }

  addMobilenumToSF(String value) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs.setString('Mobilenum', value);
  }

  handleDynamicLink() async {

    await FirebaseDynamicLinks.instance.getInitialLink();
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData data) async {
      handleSuccessLinking(data);
    }, onError: (OnLinkErrorException error) async {
    });

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
      debugPrint("responseJson..resend.."+responseJson.toString());
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }
  _verifyOtp(String otpvalue, String prevscreen) async {
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

      if(prevscreen == "cartScreen") {
        debugPrint("hihii.....hi..");
        if (!PrefUtils.prefs.getBool('type')) {
          debugPrint("not type....");
          PrefUtils.prefs.setString('LoginStatus', "true");
          PrefUtils.prefs.setString('skip', "no");
          // _getprimarylocation();
          /*return Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,);*/
          Navigator.of(context).pushReplacementNamed(
            CartScreen.routeName, arguments: {
            "after_login": ""
          }
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

        }
       // verifynum();
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

        }
      }

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
      debugPrint("body ver...."+{

        "id":PrefUtils.prefs.getString('apikey'),
        "mobile":PrefUtils.prefs.getString('Mobilenum'),

      }.toString());
      final response = await http.post(Api.updateMobileNumber, body: {

        "id":PrefUtils.prefs.getString('apikey'),
        "mobile":PrefUtils.prefs.getString('Mobilenum'),

      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("responseJson...verif.."+responseJson.toString());
      if (responseJson['status'].toString() == "200") {
        PrefUtils.prefs.setString('mobile',PrefUtils.prefs.getString('Mobilenum'));

        Navigator.of(context).pop();

        addresscontroller.get();
        addressdata =(VxState.store as GroceStore).userData;

        print("bvvdv" + addressdata.billingAddress.length.toString());
        if(addressdata.billingAddress.length>0) {
          debugPrint("hihii.....hi..1");
          Navigator.of(context).pushReplacementNamed(
              CartScreen.routeName,
              arguments: {"prev": "address_screen",
                "after_login":""});
        } else {
          debugPrint("hihii.....hi..2");
          Navigator.of(context).pushReplacementNamed(
              AddInfo.routeName,
              arguments: {
                'addresstype': "new",
                'addressid': "",
                'delieveryLocation': "",
                'latitude': "",
                'longitude': "",
                'branch': "",
                "prev": "signupselection",
              });
          /*Navigator.of(context).pushNamedAndRemoveUntil(
              AddInfo.routeName,
              ModalRoute.withName(CartScreen.routeName), arguments: {
            'addresstype': "new",
            'addressid': "",
            'title': "",
            'delieveryLocation': "",//prefs.getString("restaurant_location"),
            'latitude': "",//prefs.getString("restaurant_lat"),
            'longitude': "",//prefs.getString("restaurant_long"),
            'branch': "",
            "prev": "signupselection",
          });*/

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
  Future<void> otpCall() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.resendOtpCall, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print('call me inseatessvs...'+responseJson.toString());
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }
  void _getTime() {
    otpState(() {
      _timeRemaining == 0 ? _timeRemaining = 0 : _timeRemaining--;
    });
  }
  void otpPoup(String prevscreen){
    print("showotp...."+_showOtp.toString()+"time..."+_timeRemaining.toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
        builder: (BuildContext bc)
        {
          return  StatefulBuilder(builder: (context, setState) {
            otpState = setState;
           return Padding(
             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
             child: Container(
               height: MediaQuery.of(context).size.height / 2.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),),
                  color: ColorCodes.whiteColor,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 56.0,
                              height: 25.0,
                              margin: EdgeInsets.only(top: 8, right: 10.0),
                              child: Center(
                                  child: Text(
                                    "X",//'SKIP',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25.0,
                                        color: ColorCodes.blackColor),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Verify with OTP",
                          style: TextStyle(
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          S
                              .of(context)
                              .enter_otp, //'Enter OTP',
                          style: TextStyle(color: ColorCodes.greyColor,
                              fontSize: 15,),
                          //textAlign: TextAlign.left,
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        // Auto Sms
                        Container(
                            height: 40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 98 / 100,
                            padding: EdgeInsets.only(left: 20.0, right: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PinFieldAutoFill(
                                controller: controller,
                                decoration: UnderlineDecoration(
                                  //gapSpace: 30.0,
                                    textStyle: TextStyle(
                                        fontSize: 18, color: ColorCodes.blackColor),
                                    colorBuilder: FixedColorBuilder(
                                        ColorCodes.greyColor)),
                                onCodeChanged: (text) {
                                  otpvalue = text;
                                  print("text......" + text + "  " + otpvalue);
                                  SchedulerBinding.instance.addPostFrameCallback((
                                      _) =>
                                      setState(() {

                                      }));
                                  if (text.length == 4) {
                                    _dialogforProcessing();
                                    _verifyOtp(otpvalue,prevscreen);
                                  }
                                },
                                onCodeSubmitted: (text) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) =>
                                      setState(() {
                                        otpvalue = text;
                                        print("text......otp" + text + "  " +
                                            otpvalue);
                                      }));
                                },
                                codeLength: 4,
                                currentCode: otpvalue,
                              ),
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
                            _timeRemaining == 0
                                ? GestureDetector(
                              onTap: () {
                                // _showCall = true;
                                // otpCall();
                                // _timeRemaining = 60;
                              },
                              child:
                              Center(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: Text(
                                        S
                                            .of(context)
                                            .resend_otp, //'Resend OTP',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)
                                    ),
                                  ),
                                ),
                              ),
                            ):
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 16,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 45 / 100,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(6),
                              //   border: Border.all(
                              //       color: ColorCodes.lightGreyWebColor,
                              //       width: 1),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0, bottom: 2, left: 15),
                                child:
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: S
                                                .of(context)
                                                .resend_otp_in, //'Resend Otp in',
                                            style:
                                            TextStyle(color: ColorCodes.greyColor,
                                                fontSize: 16)),
                                        new TextSpan(

                                          text: ' 00:$_timeRemaining',
                                          style: TextStyle(
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                            if(Features.isor)
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
                                      S
                                          .of(context)
                                          .or, //'OR',
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: ColorCodes.greyColor),
                                    )),
                              ),



                            if(Features.callMeInsteadOTP)
                              Spacer(),
                            if(Features.callMeInsteadOTP)
                              GestureDetector(
                                onTap: (){
                                    otpCall();
                                    _timeRemaining = 60;
                                    },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Center(child: Text(S
                                      .of(context)
                                      .call_me_instead, //'Call me Instead',
                                    style: TextStyle(color: ColorCodes.discountoff,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,),)),
                                ),
                              ),


                            // if(Features.callMeInsteadOTP)
                            //   _timeRemaining == 0
                            //       ? GestureDetector(
                            //     onTap: () {
                            //       otpCall();
                            //       _timeRemaining = 60;
                            //     },
                            //     child:
                            //     Container(
                            //       height: MediaQuery
                            //           .of(context)
                            //           .size
                            //           .height / 16,
                            //       width: MediaQuery
                            //           .of(context)
                            //           .size
                            //           .width *
                            //           38 /
                            //           100,
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(6),
                            //         border: Border.all(
                            //             color: Colors.green, width: 1.5),
                            //       ),
                            //       child: Center(
                            //           child: Text(
                            //             S
                            //                 .of(context)
                            //                 .call_me_instead, //'Call me Instead',
                            //             style: TextStyle(
                            //                 fontSize: 14, color: Colors.black),
                            //           )),
                            //     ),
                            //   )
                            //       : Center(
                            //     child: RichText(
                            //       textAlign: TextAlign.center,
                            //       text: TextSpan(
                            //         children: <TextSpan>[
                            //           new TextSpan(
                            //               text: S
                            //                   .of(context)
                            //                   .call_in, //'Call in',
                            //               style:
                            //               TextStyle(color: Colors.black)),
                            //           new TextSpan(
                            //             text: ' 00:$_timeRemaining',
                            //             style: TextStyle(
                            //               color: ColorCodes.lightGreyColor,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   )
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
                            child:
                            Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: Text(
                                      S
                                          .of(context)
                                          .resend_otp, //'Resend OTP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)
                                  ),
                                ),
                              ),
                            ),
                          )
                              : Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 16,
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 45 / 100,

                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(6),
                            //   border: Border.all(
                            //       color: Color(0x707070B8), width: 1.5),
                            // ),
                            child:
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0, bottom: 2, left: 15),
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: S
                                              .of(context)
                                              .resend_otp_in, //'Resend Otp in',
                                          style:
                                          TextStyle(color: ColorCodes.greyColor,
                                              fontSize: 16)),
                                      new TextSpan(

                                        text: ' 00:$_timeRemaining',
                                        style: TextStyle(
                                          color: ColorCodes.blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
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
                                Border.all(
                                    color: ColorCodes.greyColor, width: 1.5),
                              ),
                              child: Center(
                                  child: Text(
                                    S
                                        .of(context)
                                        .or, //'OR',
                                    style: TextStyle(fontSize: 8),
                                  )),
                            ),
                          if(Features.callMeInsteadOTP)
                            Spacer(),
                          if(Features.callMeInsteadOTP)
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Center(child: Text(S
                                  .of(context)
                                  .call_me_instead, //'Call me Instead',
                                style: TextStyle(color: ColorCodes.discountoff,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,),)),
                            ),
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
                                    _verifyOtp(otpvalue,prevscreen);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 0.0,
                                        top: 0.0,
                                        right: 0.0,
                                        bottom: iphonex ? 16.0 : 0.0),
                                    child: Container(
                                      margin: EdgeInsets.all(15),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: ColorCodes.discountoff,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                            color: ColorCodes.discountoff,
                                          )),
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          "SUBMIT OTP", //"LOGIN",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: ColorCodes.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
//                   SizedBox(height: 25.0),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       "Verify with OTP",
//                       style: TextStyle(
//                           color: ColorCodes.blackColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0),
//                       // textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: 10.0),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20.0,right:20),
//                     child: Text(
//                       S.of(context).enter_otp,//'Enter OTP',
//                       style: TextStyle(color: ColorCodes.greyColor, fontSize: 14, fontWeight: FontWeight.bold),
//                       //textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                     // Auto Sms
//                     Container(
//                         height: 40,
//                         width: MediaQuery.of(context).size.width * 98 / 100,
//                         padding: EdgeInsets.only(left: 20.0,right:20),
//                         child: PinFieldAutoFill(
//                           controller: controller,
//                           decoration: UnderlineDecoration(
//                             //gapSpace: 30.0,
//                               textStyle: TextStyle(fontSize: 18, color: ColorCodes.blackColor),
//                               colorBuilder: FixedColorBuilder(ColorCodes.greyColor)),
//                           onCodeChanged: (text) {
//                             otpvalue = text;
//                             print("text......" + text + "  "+ otpvalue);
//                             SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
//
//                             }));
//                             if(text.length == 4) {
//                               _dialogforProcessing();
//                               _verifyOtp(otpvalue);
//                             }
//                           },
//                           onCodeSubmitted: (text) {
//                             SchedulerBinding.instance
//                                 .addPostFrameCallback((_) => setState(() {
//                               otpvalue = text;
//                               print("text......otp" + text + "  "+ otpvalue);
//                             }));
//                           },
//                           codeLength: 4,
//                           currentCode: otpvalue,
//                         ))
//                   ]),
//                   SizedBox(
//                     height: 35,
//                   ),
//
//                   // new Resend OTP buttons
//
//                   _showOtp
//                       ? Row(mainAxisAlignment: MainAxisAlignment.start,
//                       //crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                           height: MediaQuery.of(context).size.height/16,
//                           width: MediaQuery.of(context).size.width * 38 / 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(
//                                 color: ColorCodes.lightGreyWebColor, width: 1),
//                           ),
//                           child: Center(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 S.of(context).resend_otp,//'Resend OTP',
//                                 style: TextStyle(fontSize: 15),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                         if(Features.callMeInsteadOTP)
//                           Container(
//                             height: 28,
//                             width: 28,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                   color: ColorCodes.greyColor, width: 1.5),
//                             ),
//                             child: Center(
//                                 child: Text(
//                                   S.of(context).or,//'OR',
//                                   style: TextStyle(
//                                       fontSize: 7, color: ColorCodes.greyColor),
//                                 )),
//                           ),
//                         if(Features.callMeInsteadOTP)
//                           _timeRemaining == 0
//                               ? GestureDetector(
//                             onTap: () {
//                               otpCall();
//                               _timeRemaining = 60;
//                             },
//                             child: Container(
//                               height: MediaQuery.of(context).size.height/16,
//                               width: MediaQuery.of(context).size.width *
//                                   38 /
//                                   100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 border: Border.all(
//                                     color: Colors.green, width: 1.5),
//                               ),
//                               child: Center(
//                                   child: Text(
//                                     S.of(context).call_me_instead,//'Call me Instead',
//                                     style: TextStyle(
//                                         fontSize: 14, color: Colors.black),
//                                   )),
//                             ),
//                           )
//                               : Center(
//                             child: RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(
//                                 children: <TextSpan>[
//                                   new TextSpan(
//                                       text: S.of(context).call_in,//'Call in',
//                                       style:
//                                       TextStyle(color: Colors.black)),
//                                   new TextSpan(
//                                     text: ' 00:$_timeRemaining',
//                                     style: TextStyle(
//                                       color: ColorCodes.lightGreyColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                       ])
//                       : Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       _timeRemaining == 0
//                           ? GestureDetector(
//                         onTap: () {
//                           // _showCall = true;
//                           _showOtp = true;
//                           _timeRemaining += 30;
//                           Otpin30sec();
//                         },
//                         child: Center(
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                                 S.of(context).resend_otp,//'Resend OTP',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
//                             ),
//                           ),
//                         ),
//                       )
//                           : Container(
//                         height: MediaQuery.of(context).size.height/16,
//                         width:
//                         MediaQuery.of(context).size.width * 45 / 100,
//
//                         // decoration: BoxDecoration(
//                         //   borderRadius: BorderRadius.circular(6),
//                         //   border: Border.all(
//                         //       color: Color(0x707070B8), width: 1.5),
//                         // ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(top:2.0,bottom:2,left:15),
//                           child: Center(
//                             child: RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(
//                                 children: <TextSpan>[
//                                   new TextSpan(
//                                       text: S.of(context).resend_otp_in,//'Resend Otp in',
//                                       style:
//                                       TextStyle(color: ColorCodes.greyColor, fontSize: 16)),
//                                   new TextSpan(
//
//                                     text: ' 00:$_timeRemaining',
//                                     style: TextStyle(
//                                       color: ColorCodes.blackColor, fontWeight: FontWeight.bold,fontSize: 17,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       if(Features.isor)
//                         Container(
//                           height: 20,
//                           width: 20,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border:
//                             Border.all(color: ColorCodes.greyColor, width: 1.5),
//                           ),
//                           child: Center(
//                               child: Text(
//                                 S.of(context).or,//'OR',
//                                 style: TextStyle(fontSize: 8),
//                               )),
//                         ),
//                       if(Features.callMeInsteadOTP)
//                         Spacer(),
//                       if(Features.callMeInsteadOTP)
//                         Padding(
//                           padding: const EdgeInsets.only(right:15),
//                           child: Center(child: Text(S.of(context).call_me_instead,//'Call me Instead',
//                             style: TextStyle(color: ColorCodes.discountoff, fontWeight: FontWeight.bold, fontSize: 16, decoration: TextDecoration.underline,),)),
//                         ),
//                     ],
//                   ),
//                   // This expands the row element vertically because it's inside a column
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         // This makes the blue container full width.
//                         Expanded(
//                           child: GestureDetector(
//                               onTap: () {
//                                 _dialogforProcessing();
//                                 _verifyOtp(otpvalue);
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
//                                 child: Container(
// //                          padding: EdgeInsets.all(20),
//                                   child: Container(
//                                     margin: EdgeInsets.all(15),
//                                     padding: EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                         color: ColorCodes.discountoff,
//                                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                         border: Border.all(
//                                           color: ColorCodes.discountoff,
//                                         )),
//                                     height: 50.0,
//                                     child: Center(
//                                       child: Text(
//                                         "SUBMIT OTP",//"LOGIN",
//                                         style: TextStyle(
//                                           fontSize: 18.0,
//                                           color:ColorCodes.whiteColor,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
                    ]),
              ),
           );
            });

      },
    );
  }

  _saveForm() async {
    var shouldAbsorb = true;

    //final signcode = SmsAutoFill().getAppSignature;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState.save();
    //LoginUser();
    //final logindata =

      if(!_isWeb) {
        final signcode = await SmsAutoFill().getAppSignature;
        PrefUtils.prefs.setString('signature', signcode);
      }

      //  Provider.of<BrandItemsList>(context, listen: false).LoginUser();
    userappauth.login(AuthPlatform.phone,data: {"mobile": PrefUtils.prefs.getString('Mobilenum')},
        onSucsess: (SocialAuthUser value,LoginData otp){
      debugPrint("otp..."+otp.otp.toString());
      PrefUtils.prefs.setString('Otp', otp.otp.toString());
      PrefUtils.prefs.setString('apikey', value.id);
      debugPrint("apikey print..."+PrefUtils.prefs.getString('apikey'));
      PrefUtils.prefs.setBool('type',value.newuser);

    });
    setState(() {
      _isLoading = false;
    });
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    return otpPoup(routeArgs['prev'].toString());
    // return Navigator.of(context).pushNamed(OtpconfirmScreen.routeName,
    //     arguments: {
    //       "prev": "signupSelectionScreen",
    //     });


  }

  Future<void> checkMobilenum() async {
    try {
      final response = await http.post(Api.mobileCheck, body: {
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          return Fluttertoast.showToast(msg: S.of(context).mobile_exists,//"Mobile number already exists!!!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else if (responseJson['type'].toString() == "new") {
          if(!_isWeb){
            final signcode = await SmsAutoFill().getAppSignature;
            PrefUtils.prefs.setString('signature', signcode);
            Provider.of<BrandItemsList>(context, listen: false).LoginUser();
            return Navigator.of(context).pushNamed(
                OtpconfirmScreen.routeName,
                arguments: {
                  "prev": "signupSelectionScreen",
                }
            );
          }
        }
      } else {
        return Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _handleSignIn() async {
   // PrefUtils.prefs.setString('skip', "no");
   // PrefUtils.prefs.setString('applesignin', "no");
  //  try {
      // final response = await _googleSignIn.signIn();
      // response.email.toString();
      // response.displayName.toString();
      // response.photoUrl.toString();
      //
      // PrefUtils.prefs.setString('FirstName', response.displayName.toString());
      // PrefUtils.prefs.setString('LastName', "");
      // PrefUtils.prefs.setString('Email', response.email.toString());
      // PrefUtils.prefs.setString("photoUrl", response.photoUrl.toString());

      PrefUtils.prefs.setString('prevscreen', "signingoogle");
      //checkusertype("Googlesigin");
      userappauth.login(AuthPlatform.google,onSucsess: (SocialAuthUser value,_){
        debugPrint("new user...."+value.newuser.toString());
        if(value.newuser){
          debugPrint("data...."+value.name+" "+value.email+" "+_referController.text+" "+
              _appletoken+" "+PrefUtils.prefs.getString("branch")+" "+PrefUtils.prefs.getString("tokenid"));
          debugPrint("new..."+{
            "username": value.name,
            "email": value.email,
            "branch": PrefUtils.prefs.getString("branch"),
            "tokenId":PrefUtils.prefs.getString("ftokenid"),
            "device":channel,
            "referralid":(_referController.text??""),
            "path": _appletoken ,
            "mobileNumber": ((PrefUtils.prefs.getString('Mobilenum'))??"")
          }.toString());
          userappauth.register(data:RegisterAuthBodyParm(
            username: value.name,
            email: value.email,
            branch: PrefUtils.prefs.getString("branch"),
            tokenId:PrefUtils.prefs.getString("ftokenid"),
            guestUserId:PrefUtils.prefs.getString("tokenid"),
            device:channel,
            referralid:_referController.text,
            path: _appletoken ,
              mobileNumber: ((PrefUtils.prefs.getString('Mobilenum'))??""),
          ),onSucsess: (UserData response){
          //  PrefUtils.prefs.setString('FirstName', response.username);
          //  PrefUtils.prefs.setString('LastName', "");
          //  PrefUtils.prefs.setString('Email', response.email);

           /* Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/


            if (PrefUtils.prefs.getString("ismap").toString() == "true") {
              addprimarylocation();
            }
            else if (PrefUtils.prefs.getString("isdelivering").toString() == "true") {
              // Navigator.of(context).pop();
              addprimarylocation();
            }
            else {
              //Navigator.of(context).pop();
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
          },onerror: (message){
            print("error..."+message);
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: message);
          });
        }else{
          PrefUtils.prefs.setString("apikey",value.id);
          _auth.getuserProfile(onsucsess: (value){

          },onerror: (){

          });
          debugPrint("old user....");
         // debugPrint("first name..."+ PrefUtils.prefs.getString('FirstName'));
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
          /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
          ///navigatev to home page
        }

      },onerror:(message){
        print("error...1"+message);
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: message);
      });
    // } catch (error) {
    //   print("error...2"+error.toString());
    //   Navigator.of(context).pop();
    //   if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
    //   Fluttertoast.showToast(
    //       msg: S.of(context).sign_in_failed,//"Sign in failed!",
    //       fontSize: MediaQuery.of(context).textScaleFactor *13,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.black87,
    //       textColor: Colors.white);
    // }
  }

  // void initiateFacebookLogin() async {
  //   final facebookLogin = FacebookLogin();
  //   facebookLogin.loginBehavior =  Platform.isIOS ? FacebookLoginBehavior.webViewOnly : FacebookLoginBehavior.nativeOnly;//FacebookLoginBehavior.webViewOnly; facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final result = await facebookLogin.logIn(['email']);
  //
  //   switch (result.status) {
  //     case FacebookLoginStatus.error:
  //       Navigator.of(context).pop();
  //       if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
  //       Fluttertoast.showToast(
  //           msg: S.of(context).sign_in_failed,//"Sign in failed!",
  //           fontSize: MediaQuery.of(context).textScaleFactor *13,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white);
  //       //onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       Navigator.of(context).pop();
  //       if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
  //       Fluttertoast.showToast(
  //           msg: S.of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
  //           fontSize: MediaQuery.of(context).textScaleFactor *13,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white);
  //       //onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       final token = result.accessToken.token;
  //       result.accessToken.userId;
  //       final graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
  //       final profile = json.decode(graphResponse.body);
  //       PrefUtils.prefs.setString("FBAccessToken", token);
  //
  //       PrefUtils.prefs.setString('FirstName', profile['first_name'].toString());
  //       PrefUtils.prefs.setString('LastName', profile['last_name'].toString());
  //       profile['email'].toString() != "null" ?PrefUtils.prefs.setString('Email', profile['email'].toString()):PrefUtils.prefs.setString('Email',"");
  //       final pictureencode = json.encode(profile['picture']);
  //       final picturedecode = json.decode(pictureencode);
  //
  //       final dataencode = json.encode(picturedecode['data']);
  //       final datadecode = json.decode(dataencode);
  //
  //       PrefUtils.prefs.setString("photoUrl", datadecode['url'].toString());
  //
  //       PrefUtils.prefs.setString('prevscreen', "signinfacebook");
  //       checkusertype("Facebooksigin");
  //       //onLoginStatusChanged(true);
  //       break;
  //   }
  // }

  Future<void> checkusertype(String prev) async {
    try {
      var response;
      if (prev == "signInApple") {
        response = await http.post(Api.emailLogin, body: {
          "email": PrefUtils.prefs.getString('Email'),
          "tokenId": PrefUtils.prefs.getString('tokenid'),
          "apple": PrefUtils.prefs.getString('apple'),
        });
      } else {
        response = await http.post(Api.emailLogin, body: {
          "email": PrefUtils.prefs.getString('Email'),
          "tokenId": PrefUtils.prefs.getString('tokenid'),
        });
      }

      final responseJson = json.decode(response.body);
      if (responseJson['type'].toString() == "old") {
        if (responseJson['data'] != "null") {
          final data = responseJson['data'] as Map<String, dynamic>;

          if (responseJson['status'].toString() == "true") {
            PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
            // PrefUtils.prefs.setString('userID', data['userID'].toString());
            PrefUtils.prefs.setString('membership', data['membership'].toString());
            PrefUtils.prefs.setString("mobile", data['mobile'].toString());
            PrefUtils.prefs.setString("latitude", data['latitude'].toString());
            PrefUtils.prefs.setString("longitude", data['longitude'].toString());
          } else if (responseJson['status'].toString() == "false") {}
        }

        PrefUtils.prefs.setString('LoginStatus', "true");
        _getprimarylocation();
      } else {
        Features.isReferEarn?_dialogforRefer(context):SignupUser();
       // Navigator.of(context).pop();
        //SignupUser();
      /*  Navigator.of(context).pushNamed(
          LoginScreen.routeName,
        );*/
      }
    } catch (error) {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
      Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//'Something Went Wrong..',
        fontSize: MediaQuery.of(context).textScaleFactor *13,gravity: ToastGravity.BOTTOM,);
      throw error;
    }
  }

  _dialogforRefer(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 200.0,
                  width:200,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S.of(context).refer_earn,//"Refer And Earn",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: _referController,
                        decoration: InputDecoration(
                          hintText: S.of(context).refer_earn,//"Refer and Earn (optional)",//"Reasons (Optional)",
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                        ),
                        minLines: 2,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        onPressed: () {
                          _dialogforProcessing();
                          SignupUser();
                        },
                        child: Text(
                          S.of(context).next ,//translate('forconvience.Next'), // "Next",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  )),
            );
          });
        });
  }

  Future<void> SignupUser() async {
    String _appletoken = "";
    String _name = "";
    String _email = "";
    String _mobile = "";
    String _tokenid = "";
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

    if (PrefUtils.prefs.getString('applesignin') == "yes") {
      _appletoken = PrefUtils.prefs.getString('apple');
    } else {
      _appletoken = "";
    }
   /* if (PrefUtils.prefs.getString('FirstName') != null) {
      if (PrefUtils.prefs.getString('LastName') != null) {
        _name = PrefUtils.prefs.getString('FirstName') +
            " " +
            PrefUtils.prefs.getString('LastName');
      } else {
        _name = PrefUtils.prefs.getString('FirstName');
      }
    } else {
      _name = "";
    }*/
    _name = store.userData.username;
    if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
      _email = "";
    } else {
      _email = PrefUtils.prefs.getString('Email');
    }
    _tokenid = PrefUtils.prefs.getString('tokenid');
    try {
      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": _name,
        "email": _email,
        "mobileNumber": _mobile,
        "path": _appletoken,
        "tokenId": _tokenid,
        "branch": PrefUtils.prefs.getString('branch') /*'999'*/,
        "referralid": _referController.text,//(PrefUtils.prefs.getString("referCodeDynamic") == "" || PrefUtils.prefs.getString("referCodeDynamic") == null)? "": PrefUtils.prefs.getString("referCodeDynamic"),
        "device": channel.toString(),
      });
      final responseJson = json.decode(response.body);
      final data = responseJson['data'] as Map<String, dynamic>;
      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
        // PrefUtils.prefs.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs.setString('referral', PrefUtils.prefs.getString('referralCode'));
        PrefUtils.prefs.setString('referid', _referController.text);
        PrefUtils.prefs.setString('LoginStatus', "true");
      /*  Navigator.of(context).pop();
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
          else if (PrefUtils.prefs.getString("isdelivering").toString() == "true") {
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

      } else if (responseJson['status'].toString() == "false") {
        Navigator.of(context).pop();
        if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
        return Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//'Something Went Wrong..',
          fontSize: MediaQuery.of(context).textScaleFactor *13,gravity: ToastGravity.BOTTOM,);
      }
    } catch (error) {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
      Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//'Something Went Wrong..',
        fontSize: MediaQuery.of(context).textScaleFactor *13,gravity: ToastGravity.BOTTOM,);
      throw error;
    }
  }

  Future<void> addprimarylocation() async {
    debugPrint("A d d p r i m r y .....");

    var url = IConstants.API_PATH + 'add-primary-location';
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint("del location"+IConstants.deliverylocationmain.value.toString());
      debugPrint("del lat"+PrefUtils.prefs.getString("latitude"));
      debugPrint("del longitude"+PrefUtils.prefs.getString("longitude"));
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs.containsKey("apikey")? PrefUtils.prefs.getString("apikey"): PrefUtils.prefs.getString("ftokenid"),
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

  Future<void> _getprimarylocation() async {
    try {
      final response = await http.post(Api.getProfile, body: {
        "apiKey": PrefUtils.prefs.getString('apiKey'),
      });

      final responseJson = json.decode(response.body);

      final dataJson =
          json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);
      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[
              index]
          as Map<String, dynamic>)); //store each category values in data list
      for (int i = 0; i < data.length; i++) {
        PrefUtils.prefs.setString("deliverylocation", data[i]['area']);
        PrefUtils.prefs.setString("branch", data[i]['branch']);
        if (PrefUtils.prefs.containsKey("deliverylocation")) {
          Navigator.of(context).pop();
          if (PrefUtils.prefs.containsKey("fromcart")) {
            if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs.remove("fromcart");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  CartScreen.routeName,
                  ModalRoute.withName(HomeScreen.routeName), arguments: {
                "after_login": ""
              });
            } else {
              //Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,);
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            }
          } else {
            //Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,);
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          }
        } else {



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
          /*Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,
          );*/



        }
      }
      //Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  Future<void> facebooklogin() {
    PrefUtils.prefs.setString('skip', "no");
    PrefUtils.prefs.setString('applesignin', "no");
  //  initiateFacebookLogin();
  }

  bool skip() {
    PrefUtils.prefs.setString('skip', "yes");
    PrefUtils.prefs.setString('applesignin', "no");
    if (PrefUtils.prefs.containsKey("deliverylocation")) {
      if (PrefUtils.prefs.getString("deliverylocation") != "") {
        if (PrefUtils.prefs.containsKey("fromcart")) {
          if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
            PrefUtils.prefs.remove("fromcart");
            Navigator.of(context).pushReplacementNamed(
              CartScreen.routeName, arguments: {
              "after_login": ""
            }
            );
          } else {
            /*Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,);*/
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          }
        }
        else {
          /*Navigator.of(context).pushReplacementNamed(
            HomeScreen.routeName,);*/
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
      } else {

        if (PrefUtils.prefs.getString("ismap").toString() == "true") {
          addprimarylocation();
        }
        else if (PrefUtils.prefs.getString("isdelivering").toString() == "true") {
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

       /* Navigator.of(context).pushNamed(
          LocationScreen.routeName,
        );*/
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,(route) => false);

      // pop()
      ;
    }
    return true;
  }

  Future<void> appleLogIn() async {
    PrefUtils.prefs.setString('applesignin', "yes");
    _dialogforProcessing();
    PrefUtils.prefs.setString('skip', "no");
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            final response = await http.post(Api.emailLogin, body: {
              // await keyword is used to wait to this operation is complete.
              "email": result.credential.user.toString(),
              "tokenId": PrefUtils.prefs.getString('tokenid'),
            });
            final responseJson = json.decode(response.body);
            debugPrint("apple......"+responseJson.toString());
            if (responseJson['type'].toString() == "old") {
              if (responseJson['data'] != "null") {
                final data = responseJson['data'] as Map<String, dynamic>;

                if (responseJson['status'].toString() == "true") {
                  PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
                  // PrefUtils.prefs.setString('userID', data['userID'].toString());
                  PrefUtils.prefs.setString('membership', data['membership'].toString());
                  PrefUtils.prefs.setString("mobile", data['mobile'].toString());
                  PrefUtils.prefs.setString("latitude", data['latitude'].toString());
                  PrefUtils.prefs.setString("longitude", data['longitude'].toString());

                  PrefUtils.prefs.setString('name', data['name'].toString());
                  PrefUtils.prefs.setString('FirstName', data['name'].toString());
                  PrefUtils.prefs.setString('FirstName', data['username'].toString());
                  PrefUtils.prefs.setString('LastName', "");
                  PrefUtils.prefs.setString('Email', data['email'].toString());
                  PrefUtils.prefs.setString("photoUrl", "");
                  PrefUtils.prefs.setString('apple', data['apple'].toString());
                } else if (responseJson['status'].toString() == "false") {}
              }
              PrefUtils.prefs.setString('LoginStatus', "true");
              _getprimarylocation();
            } else {
              PrefUtils.prefs.setString('apple', result.credential.user.toString());
              PrefUtils.prefs.setString(
                  'FirstName', result.credential.fullName?.givenName);
              PrefUtils.prefs.setString(
                  'LastName', result.credential.fullName?.familyName);
              PrefUtils.prefs.setString("photoUrl", "");

              if (result.credential.email.toString() == "null") {
                PrefUtils.prefs.setString('prevscreen', "signInAppleNoEmail");
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(
                  LoginScreen.routeName,
                    arguments: {
                      "prev": "signupSelectionScreen"
                    }
                );
              } else {
                PrefUtils.prefs.setString('Email', result.credential.email);
                PrefUtils.prefs.setString('prevscreen', "signInApple");
                checkusertype("signInApple");
              }
            }
          } catch (error) {
            Navigator.of(context).pop();
            throw error;
          }

          break;
        case AuthorizationStatus.error:
          Navigator.of(context).pop();
          print("apperror..."+result.error.toString());
          if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
          Fluttertoast.showToast(
              msg: S.of(context).sign_in_failed,//"Sign in failed!",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
          break;
        case AuthorizationStatus.cancelled:
          Navigator.of(context).pop();
          if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
          Fluttertoast.showToast(
              msg: S.of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
          break;
      }
    } else {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
      Fluttertoast.showToast(
          msg: S.of(context).apple_signin_not_available_forthis_device,//"Apple SignIn is not available for your device!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: ColorCodes.whiteColor, // status bar color
    ));
    IConstants.isEnterprise? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: ColorCodes.whiteColor, // status bar color
    )):
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: ColorCodes.blackColor,
    ));
    return WillPopScope(
      onWillPop: () async {
        skip();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorCodes.yellowColor,
        body: SafeArea(
          child:
              //     _isLoading?
              //       Center(
              //       child: CircularProgressIndicator(),
              // )
              //     :
              Column(children:
              <Widget>[
                Stack(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(
                        //     left: 30.0, top: 10.0, right: 30.0, bottom: 15.0),
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          Images.welcome,
                          width: MediaQuery.of(context).size.width,
                          height: 257.0,
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width / 1.2,
                      //   height: MediaQuery.of(context).size.height / 15,
                      //   margin: EdgeInsets.only(bottom: 8.0),
                      //   padding: EdgeInsets.only(
                      //       left: 10.0, top: 5.0, right: 5.0, bottom: 3.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(4.0),
                      //     border: Border.all(width: 0.5, color: ColorCodes.borderColor),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         Images.countryImg,
                      //       ),
                      //       SizedBox(
                      //         width: 14,
                      //       ),
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           Text(
                      //               S.of(context).country_region,//"Country/Region",
                      //               style: TextStyle(
                      //                 color: ColorCodes.greyColor,
                      //               )),
                      //           Text(countryName + " (" + IConstants.countryCode + ")",
                      //               style: TextStyle(
                      //                   color: Colors.black, fontWeight: FontWeight.bold))
                      //         ],
                      //       ),
                      //       /*Spacer(),
                      //           Row(
                      //             children: [
                      //               Icon(Icons.keyboard_arrow_down),
                      //             ],
                      //           ),*/
                      //     ],
                      //   ),
                      // ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              skip();
                            },
                            child: Container(
                              width: 60.0,
                              height: 30.0,
                              margin: EdgeInsets.only(top: 20, right: 10.0),
                              child: Center(
                                  child: Text(
                                    "X",//'SKIP',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 28.0,
                                        color: ColorCodes.whiteColor),
                                  )),
                            ),
                          ),
                        ],
                      ),
                   ]
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.55,
                  padding: EdgeInsets.only(top: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0),),
                    color: ColorCodes.whiteColor,
                  ),

                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Text("Sign in / Sign up",
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22,))
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 15,//52.0,
                        /*padding: EdgeInsets.only(
                            left: 10.0, top: 0.0, right: 0.0, bottom: 0.0),*/
                        padding: EdgeInsets.only(
                            left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(4.0),
                         // border: Border.all(width: 0.5, color: ColorCodes.borderColor),
                          border: Border(
                            bottom: BorderSide(width: 0.3, color: ColorCodes.borderColor),),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width*0.70,
                                child: Form(
                                  key: _form,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 16.0),
                                    //textAlign: TextAlign.left,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                                    ],
                                    cursorColor: Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    //autofocus: true,
                                    decoration: new InputDecoration.collapsed(
                                        hintText: S.of(context).enter_yor_mobile_number,//'Enter Your Mobile Number',

                                        hintStyle: TextStyle(
                                          color: Colors.grey,

                                        )),
                                    validator: (value) {
                                      String patttern = r'(^(?:[+0]9)?[0-9]{6,10}$)';
                                      RegExp regExp = new RegExp(patttern);
                                      if (value.isEmpty) {
                                        return S.of(context).please_enter_phone_number;//'Please enter a Mobile number.';
                                      } else if (!regExp.hasMatch(value)) {
                                        return S.of(context).valid_phone_number;//'Please enter valid mobile number';
                                      }
                                      return null;
                                    }, //it means user entered a valid input

                                    onSaved: (value) {
                                      addMobilenumToSF(value);
                                    },
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      // Container(
                      //   width: MediaQuery.of(context).size.width / 1.2,
                      //   height: MediaQuery.of(context).size.height / 30,//20.0,
                      //   margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
                      //   child: Text(
                      //     S.of(context).we_will_call_text_signup,//"We'll call or text you to confirm your number.",
                      //     style: TextStyle(fontSize: 13, color: ColorCodes.mediumBlackColor),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          //  _enabled ? _onTap:
                          // clikform();
                          //   _dialogforProcessing();
                          setState(() {
                            _isLoading = true;
                            count + 1;
                          });
                          _isLoading
                              ? CircularProgressIndicator()
                              : PrefUtils.prefs.setString('skip', "no");
                          PrefUtils.prefs.setString('prevscreen', "mobilenumber");

                           _saveForm();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          // height: 32,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 1.0,
                              color: ColorCodes.discountoff,
                            ),
                            color: ColorCodes.discountoff,
                          ),
                          child: Text(
                            S.of(context).continue_button,//"CONTINUE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: ColorCodes.whiteColor),
                          ),
                        ),
                      ),
                      /*Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width / 1.2,
                        margin: EdgeInsets.only(top: 30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              width: 0.5, color: Color(0xff4B4B4B).withOpacity(1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _dialogforProcessing();
                                  _handleSignIn();
                                },
                                child: Image.asset(Images.googleImg)),
                            GestureDetector(
                                onTap: () {
                                  _dialogforProcessing();
                                  facebooklogin();
                                },
                                child: Image.asset(Images.facebookImg)),
                            if (_isAvailable)
                              GestureDetector(
                                  onTap: () {
                                    appleLogIn();
                                  },
                                  child: Image.asset(Images.appleImg))
                          ],
                        ),
                      ),*/
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/50,left: 28.0,right:28,bottom:MediaQuery.of(context).size.height/50),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorCodes.whiteColor,//ColorCodes.greyColor,
                                  ),
                                ),
                                Container(
                                  //padding: EdgeInsets.all(4.0),
                                  width: 23.0,
                                  height: 23.0,
                                  /* decoration: BoxDecoration(
                                          border: Border.all(
                                           // color: Color(0xff707070),
                                          ),
                                          shape: BoxShape.circle,
                                        ),*/
                                  child: Center(
                                      child: Text(
                                        S.of(context).or,//"OR" , //"OR",
                                        style:
                                        TextStyle(fontSize: 13.0, color: ColorCodes.greyColor),
                                      )),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorCodes.whiteColor,//ColorCodes.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: ColorCodes.lightgrey,
                                  ),),
                                margin: EdgeInsets.only(left: 28,),
                                width: MediaQuery.of(context).size.width / 2.4,
                                child: GestureDetector(
                                  onTap: () {
                                    _dialogforProcessing();
                                    _handleSignIn();

                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        //Image.asset(Images.googleImg,width: 20,height: 30,),
                                        Text(
                                          "Google",//'Sign in with google     ' , //"Sign in with Google",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: ColorCodes.signincolor),
                                        ),
                                        Spacer(),
                                        SvgPicture.asset(Images.googleImg, width: 30, height: 30,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: ColorCodes.lightgrey,
                                  ),),
                                margin: EdgeInsets.only(right: 28,),
                                width: MediaQuery.of(context).size.width / 2.4,
                                child: GestureDetector(
                                  onTap: () {
                                    _dialogforProcessing();
                                    // facebooklogin();
                                    userappauth.login(AuthPlatform.facebook,onSucsess: (SocialAuthUser value,_){
                                      //  PrefUtils.prefs.setString('skip', "no");
                                      //  PrefUtils.prefs.setString('applesignin', "no");
                                      if(value.newuser){
                                        userappauth.register(data:RegisterAuthBodyParm(
                                          username: value.name,
                                          email: value.email,
                                          branch: PrefUtils.prefs.getString("branch"),
                                          tokenId:PrefUtils.prefs.getString("ftokenid"),
                                          guestUserId:PrefUtils.prefs.getString("tokenid"),
                                          device:channel,
                                          referralid:_referController.text,
                                          path: _appletoken ,
                                          //mobileNumber: PrefUtils.prefs.getString('Mobilenum')
                                        ),onSucsess: (UserData response){
                                          // PrefUtils.prefs.setString('FirstName', response.username);
                                          //  PrefUtils.prefs.setString('LastName', "");
                                          //  PrefUtils.prefs.setString('Email', response.email);

                                          Navigator.pushNamedAndRemoveUntil(
                                              context, HomeScreen.routeName, (route) => false);
                                        },onerror: (message){
                                          print("error...fa"+message);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(msg: message);
                                        });
                                      }else{
                                        debugPrint("facebook old user....");
                                        PrefUtils.prefs.setString("apikey",value.id);
                                        _auth.getuserProfile(onsucsess: (value){

                                        },onerror: (){

                                        });
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, HomeScreen.routeName, (route) => false);
                                        ///navigatev to home page
                                      }

                                    },onerror:(message){
                                      print("error...fa2"+message);
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(msg: message);
                                    });
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        Text(
                                          "Facebook",//"Sign in with Facebook" ,// "Sign in with Facebook",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: ColorCodes.signincolor),
                                        ),
                                        Spacer(),
                                        SvgPicture.asset(Images.facebookImg, width: 30, height: 30,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ),
                          SizedBox(height: 20),
                          Container(//30.0,
                            margin: EdgeInsets.only(top: 12.0, bottom: 32.0, left: 28, right: 28),
                            child: new RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  color: ColorCodes.greyColor,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: S.of(context).agreed_terms,//'By continuing you agree to the '
                                  ),
                                  new TextSpan(
                                      text: S.of(context).term_and_condition,//' terms of service',
                                      style: new TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w800),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .pushNamed(PolicyScreen.routeName, arguments: {
                                            'title': "Terms of Service",
                                            'body': IConstants.restaurantTerms,
                                          });
                                        }),
                                  // new TextSpan(text: S.of(context).and,//' and'
                                  // ),
                                  // new TextSpan(
                                  //     text: S.of(context).privacy_policy,//' Privacy Policy',
                                  //     style: new TextStyle(color: ColorCodes.darkthemeColor),
                                  //     recognizer: new TapGestureRecognizer()
                                  //       ..onTap = () {
                                  //         Navigator.of(context).pushNamed(
                                  //             PolicyScreen.routeName,
                                  //             arguments: {
                                  //               'title' : "Privacy Policy",
                                  //               'body' : PrefUtils.prefs.getString("privacy"),
                                  //             }
                                  //         );
                                  //       }),
                                ],
                              ),
                            ),
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       margin: EdgeInsets.symmetric(horizontal: 28),
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           _dialogforProcessing();
                          //           _handleSignIn();
                          //
                          //         },
                          //         child: Material(
                          //           borderRadius: BorderRadius.circular(4.0),
                          //           elevation: 2,
                          //           shadowColor: Colors.grey,
                          //           child: Container(
                          //             padding: EdgeInsets.only(
                          //                 left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(4.0),),
                          //             child:
                          //             Padding(
                          //               padding: EdgeInsets.only(right:MediaQuery.of(context).size.width/10,//30.0,
                          //                 left:MediaQuery.of(context).size.width/12,),
                          //               child: Center(
                          //                 child: Row(
                          //                   mainAxisAlignment: MainAxisAlignment.start,
                          //                   children: <Widget>[
                          //                      SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                          //                     //Image.asset(Images.googleImg,width: 20,height: 30,),
                          //                     SizedBox(
                          //                       width: 14,
                          //                     ),
                          //                     Expanded(
                          //                       child: Text(
                          //                         S.of(context).sign_in_with_google,//'Sign in with google     ' , //"Sign in with Google",
                          //                         textAlign: TextAlign.center,
                          //                         maxLines: 2,
                          //                         style: TextStyle(fontSize: 16,
                          //                             fontWeight: FontWeight.bold,
                          //                             color: ColorCodes.signincolor),
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70, horizontal: 28),
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           _dialogforProcessing();
                          //          // facebooklogin();
                          //           userappauth.login(AuthPlatform.facebook,onSucsess: (SocialAuthUser value,_){
                          //           //  PrefUtils.prefs.setString('skip', "no");
                          //           //  PrefUtils.prefs.setString('applesignin', "no");
                          //             if(value.newuser){
                          //               userappauth.register(data:RegisterAuthBodyParm(
                          //                 username: value.name,
                          //                 email: value.email,
                          //                 branch: PrefUtils.prefs.getString("branch"),
                          //                 tokenId:PrefUtils.prefs.getString("ftokenid"),
                          //                 guestUserId:PrefUtils.prefs.getString("tokenid"),
                          //                 device:channel,
                          //                 referralid:_referController.text,
                          //                 path: _appletoken ,
                          //                   //mobileNumber: PrefUtils.prefs.getString('Mobilenum')
                          //               ),onSucsess: (UserData response){
                          //                // PrefUtils.prefs.setString('FirstName', response.username);
                          //               //  PrefUtils.prefs.setString('LastName', "");
                          //               //  PrefUtils.prefs.setString('Email', response.email);
                          //
                          //                 Navigator.pushNamedAndRemoveUntil(
                          //                     context, HomeScreen.routeName, (route) => false);
                          //               },onerror: (message){
                          //                 print("error...fa"+message);
                          //                 Navigator.of(context).pop();
                          //                 Fluttertoast.showToast(msg: message);
                          //               });
                          //             }else{
                          //               debugPrint("facebook old user....");
                          //               PrefUtils.prefs.setString("apikey",value.id);
                          //               _auth.getuserProfile(onsucsess: (value){
                          //
                          //               },onerror: (){
                          //
                          //               });
                          //               Navigator.pushNamedAndRemoveUntil(
                          //                   context, HomeScreen.routeName, (route) => false);
                          //               ///navigatev to home page
                          //             }
                          //
                          //           },onerror:(message){
                          //             print("error...fa2"+message);
                          //             Navigator.of(context).pop();
                          //             Fluttertoast.showToast(msg: message);
                          //           });
                          //         },
                          //         child: Material(
                          //           borderRadius: BorderRadius.circular(4.0),
                          //           elevation: 2,
                          //           shadowColor: Colors.grey,
                          //           child: Container(
                          //             padding: EdgeInsets.only(
                          //                 left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(4.0),
                          //
                          //               // border: Border.all(width: 0.5, color: Color(0xff4B4B4B)),
                          //             ),
                          //             child:
                          //             Padding(
                          //               padding: EdgeInsets.only(right:MediaQuery.of(context).size.width/10,//30.0,
                          //                 left:MediaQuery.of(context).size.width/12,),
                          //               child: Center(
                          //                 child: Row(
                          //                   mainAxisAlignment: MainAxisAlignment.start,
                          //                   children: <Widget>[
                          //                     SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                          //                    // Image.asset(Images.facebookImg,width: 20,height: 30,),
                          //                     SizedBox(
                          //                       width: 14,
                          //                     ),
                          //                     Expanded(
                          //                       child: Text(
                          //                         S.of(context).sign_in_with_facebook,//"Sign in with Facebook" ,// "Sign in with Facebook",
                          //                         textAlign: TextAlign.center,
                          //                         maxLines: 2,
                          //                         style: TextStyle(fontSize: 16,
                          //                             fontWeight: FontWeight.bold,
                          //                             color: ColorCodes.signincolor),
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     if (_isAvailable)
                          //       Container(
                          //         margin: EdgeInsets.symmetric(horizontal: 28),
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             appleLogIn();
                          //           },
                          //           child: Material(
                          //             borderRadius: BorderRadius.circular(4.0),
                          //             elevation: 2,
                          //             shadowColor: Colors.grey,
                          //             child: Container(
                          //
                          //               padding: EdgeInsets.only(
                          //                   left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                          //               decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.circular(4.0),),
                          //               child:
                          //               Padding(
                          //                 padding: EdgeInsets.only(right:MediaQuery.of(context).size.width/10,//30.0,
                          //                   left:MediaQuery.of(context).size.width/12,),
                          //                 child: Center(
                          //                   child: Row(
                          //                     mainAxisAlignment: MainAxisAlignment.start,
                          //                     children: <Widget>[
                          //                        SvgPicture.asset(Images.appleImg, width: 25, height: 25,),
                          //                       //Image.asset(Images.appleImg, width: 20,height: 40,),
                          //                       SizedBox(
                          //                         width: 14,
                          //                       ),
                          //                       Expanded(
                          //                         child: Text(
                          //                           S.of(context).signin_apple,//"Sign in with Apple"  , //"Sign in with Apple",
                          //                           textAlign: TextAlign.center,
                          //                           maxLines: 2,
                          //                           style: TextStyle(fontSize: 16,
                          //                               fontWeight: FontWeight.bold,
                          //                               color: ColorCodes.signincolor),
                          //                         ),
                          //                       )
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //
                          //     /*if (_isAvailable)
                          //             Container(
                          //               margin: EdgeInsets.symmetric(*//*vertical: MediaQuery.of(context).size.height/700,*//* horizontal: 28),
                          //               child: GestureDetector(
                          //                 onTap: () {
                          //                   appleLogIn();
                          //                 },
                          //                 child: Material(
                          //                   borderRadius: BorderRadius.circular(4.0),
                          //                   elevation: 3,
                          //
                          //                   shadowColor: Colors.grey,
                          //                   child: Container(
                          //                     padding: EdgeInsets.only(
                          //                         left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                          //                     decoration: BoxDecoration(
                          //                       borderRadius: BorderRadius.circular(4.0),),
                          //                     child:
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(right:23.0,left: 23),
                          //                       child: Center(
                          //                         child: Row(
                          //                           mainAxisAlignment: MainAxisAlignment.start,
                          //                           children: <Widget>[
                          //                             Image.asset(Images.appleImg),
                          //                             SizedBox(
                          //                               width: 14,
                          //                             ),
                          //                             Text(
                          //                               "Se connecter avec Apple",
                          //                               textAlign: TextAlign.center,
                          //                               style: TextStyle(fontSize: 16,
                          //                                   fontWeight: FontWeight.bold,
                          //                                   color: ColorCodes.signincolor),
                          //                             )
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),*/
                          //   ],
                          // ),

                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
