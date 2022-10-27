import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../blocs/cart_item_bloc.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../screens/signup_selection_screen.dart';
import '../screens/subscribe_screen.dart';
import '../services/firebaseAnaliticsService.dart';
import '../constants/IConstants.dart';
import '../screens/bloc.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/policy_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../providers/cartItems.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/features.dart';
import '../main.dart';
import '../widgets/badge_discount.dart';
import '../providers/branditems.dart';
import '../providers/itemslist.dart';
import '../providers/sellingitems.dart';
import '../screens/singleproduct_screen.dart';
import '../screens/membership_screen.dart';
import '../widgets/badge_ofstock.dart';
import '../data/hiveDB.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/ColorCodes.dart';
import '../data/calculations.dart';
import 'package:http/http.dart' as http;

import 'simmers/singel_item_of_list_shimmer.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
class Items extends StatefulWidget {
  final String _fromScreen;
  final String id;
  final String title;
  final String imageUrl;
  final String brand;
  final String veg_type;
  final String type;
  final String eligibleforexpress;
  final String delivery;
  final String duration;
  final String durationType;
  final String note;
  final String subscribe;
  final String paymentmode;
  final String cronTime;
  final String name;

  Items(this._fromScreen, this.id, this.title, this.imageUrl, this.brand, this.veg_type,this.type,
      this.eligibleforexpress,this.delivery,this.duration,this.durationType,this.note,this.subscribe,this.paymentmode,this.cronTime,this.name);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Box<Product> productBox;
  bool _varlength = false;
  int varlength = 0;
  var itemvarData;
  bool dialogdisplay = false;
  bool bottomsheetdisplay = false;
  bool _checkmembership = false;
  var colorRight = 0xff3d8d3c;
  var colorLeft = 0xff8abb50;
  var _checkmargin = true;
  Color varcolor;

  String varid;
  String varname;
  String unit;
  double weight;
  String varmrp;
  String varprice;
  String varmemberprice;
  String varminitem;
  String varmaxitem;
  int varLoyalty;
  int varQty;
  String varstock;
  bool discountDisplay;
  bool memberpriceDisplay;
  int _groupValue;

  List variationdisplaydata = [];

  List variddata = [];
  List varnamedata = [];
  List unitdata=[];
  List weightdata=[];
  List varmrpdata = [];
  List varpricedata = [];
  List varmemberpricedata = [];
  List varminitemdata = [];
  List varmaxitemdata = [];
  List varLoyaltydata = [];
  List varQtyData = [];
  List varstockdata = [];
  List vardiscountdata = [];
  List discountDisplaydata = [];
  List memberpriceDisplaydata = [];

  List checkBoxdata = [];
  var containercolor = [];
  var iconcolor = [];
  var textcolor = [];
  bool _isLoading = true;
  bool _isAddToCart = false;
  HomeDisplayBloc _bloc;
  bool _isNotify = false;

  int value1;

  var margins;
  bool _isWeb = false;
  bool checkskip = false;

  String countryName = "India";
  String photourl = "";
  String name = "";
  String phone = "";
  String apple = "";
  String email = "";
  String mobile = "";
  String tokenid = "";
  bool _isAvailable = false;
  int unreadCount = 0;
  Timer _timer;
  int _timeRemaining = 30;
  StreamController<int> _events;
  TextEditingController controller = TextEditingController();
  bool _showOtp = false;
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();
  final TextEditingController _referController = new TextEditingController();
  final _lnameFocusNode = FocusNode();
  String fn = "";
  String ln = "";
  String ea = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  var addressitemsData;
  var deliveryslotData;
  var delChargeData;
  var timeslotsData;
  bool express =true;
  var timeslotsindex = "0";
  var otpvalue = "";

  String otp1, otp2, otp3, otp4;
  final _form = GlobalKey<FormState>();
  var day, date, time = "10 AM - 1 PM";
  var addtype;
  var address;
  IconData addressicon;
  DateTime pickedDate;
  var itemslistData;
  var multiimage;
  String _displayimg = "";
  String itemimg = "";
  GroceStore store = VxState.store;

  @override
  void initState() {
    _bloc = HomeDisplayBloc();
    productBox = Hive.box<Product>(productBoxName);
    _events = new StreamController<int>.broadcast();
    _events.add(30);
    pickedDate = DateTime.now();
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
    Future.delayed(Duration.zero, () async {
      setState(() {
        _isLoading = false;
        dialogdisplay = true;


      });
      if (widget._fromScreen == "home_screen") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findByfeaturedimage(varid);
        _displayimg = multiimage[0].imageUrl;
      } else if (widget._fromScreen == "singleproduct_screen") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIditemsnewimage(varid);
        _displayimg = multiimage[0].imageUrl;
      } else if (widget._fromScreen == "Discount") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findBydiscountimage(varid);
        _displayimg = multiimage[0].imageUrl;
      }  else if (widget._fromScreen == "Offers") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findByofferimage(varid);
        _displayimg = multiimage[0].imageUrl;
      } else if (widget._fromScreen == "Forget") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findByForgotimage(varid);
        _displayimg = multiimage[0].imageUrl;
      }
      else if (widget._fromScreen == "map_screen") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findByofferimage(varid);
        _displayimg = multiimage[0].imageUrl;
      }
      else if (widget._fromScreen == "searchitem_screen") {
        multiimage = Provider.of<ItemsList>(context, listen: false).findBysearchimage(varid);
        _displayimg = multiimage[0].imageUrl;
      } else if (widget._fromScreen == "sellingitem_screen") {
        multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIdallimage(varid);
        _displayimg = multiimage[0].imageUrl;
      } else if (widget._fromScreen == "brands_screen") {
        multiimage = Provider.of<BrandItemsList>(context, listen: false).findBybrandimage(varid);
        _displayimg = multiimage[0].imageUrl;
      }
      if(PrefUtils.prefs.getString("referCodeDynamic") == "" || PrefUtils.prefs.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs.getString("referCodeDynamic");
      }
    });
    setState(() {
      if (PrefUtils.prefs.containsKey("LoginStatus")) {
        if (PrefUtils.prefs.getString('LoginStatus') == "true") {
          PrefUtils.prefs.setString('skip', "no");
          checkskip = false;
        } else {
          PrefUtils.prefs.setString('skip', "yes");
          checkskip = true;
        }
      } else {
        PrefUtils.prefs.setString('skip', "yes");
        checkskip = true;
      }
    });
    super.initState();
  }

  Future<void> _checkMembership() async {
    if(PrefUtils.prefs.getString("membership") == "1"){
      _checkmembership = true;
    } else {
      _checkmembership = false;
      for (int i = 0; i < productBox.length; i++) {
        if (productBox.values.elementAt(i).mode == 1) {
          _checkmembership = true;
        }
      }
    }
  }

  Future<void> _getprimarylocation() async {
    try {
      final response = await http.post(Api.getProfile, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs.getString('apiKey'),
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      final dataJson =
      json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);
      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[
      index]
      as Map<String, dynamic>)); //store each category values in data list
      for (int i = 0; i < data.length; i++) {
        PrefUtils.prefs.setString("deliverylocation", data[i]['area']);

        if (PrefUtils.prefs.containsKey("deliverylocation")) {
          Navigator.of(context).pop();
          if (PrefUtils.prefs.containsKey("fromcart")) {
            if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs.remove("fromcart");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  CartScreen.routeName,
                  ModalRoute.withName(HomeScreen.routeName),arguments: {
                "after_login": ""
              });
            } else {
              Navigator.of(context).popUntil(ModalRoute.withName(
                HomeScreen.routeName,
              ));
            }
          } else {
            Navigator.of(context).pushNamed(
              HomeScreen.routeName,
            );
          }
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
        }
      }
      //Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  // void initiateFacebookLogin() async {
  //   //web.......
  //   final facebookSignIn = FacebookLoginWeb();
  //   final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
  //   //app........
  //   /*final facebookLogin = FacebookLogin();
  //   facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
  //   final result = await facebookLogin.logIn(['email']);*/
  //   switch (result.status) {
  //     case FacebookLoginStatus.error:
  //       Navigator.of(context).pop();
  //       Fluttertoast.showToast(
  //           msg: S.of(context).sign_in_failed,//"Sign in failed!",
  //           fontSize: MediaQuery.of(context).textScaleFactor *13,
  //           backgroundColor: ColorCodes.blackColor,
  //           textColor: ColorCodes.whiteColor);
  //       //onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       Navigator.of(context).pop();
  //       Fluttertoast.showToast(
  //           msg: S.of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
  //           fontSize: MediaQuery.of(context).textScaleFactor *13,
  //           backgroundColor: ColorCodes.blackColor,
  //           textColor: ColorCodes.whiteColor);
  //       //onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       final token = result.accessToken.token;
  //       final graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
  //       final profile = json.decode(graphResponse.body);
  //
  //       PrefUtils.prefs.setString("FBAccessToken", token);
  //
  //       PrefUtils.prefs.setString('FirstName', profile['first_name'].toString());
  //       PrefUtils.prefs.setString('LastName', profile['last_name'].toString());
  //       PrefUtils.prefs.setString('Email', profile['email'].toString());
  //
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

  Future<void> facebooklogin() {
    PrefUtils.prefs.setString('skip', "no");
    PrefUtils.prefs.setString('applesignin', "no");
   // initiateFacebookLogin();
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
            final responseJson = json.decode(utf8.decode(response.bodyBytes));
            if (responseJson['type'].toString() == "old") {
              if (responseJson['data'] != "null") {
                final data = responseJson['data'] as Map<String, dynamic>;

                if (responseJson['status'].toString() == "true") {
                  PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
                  PrefUtils.prefs.setString('userID', data['userID'].toString());
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
              setState(() {
                checkskip = false;
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
                if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
                  email = "";
                } else {
                  email = PrefUtils.prefs.getString('Email');
                }
                mobile = PrefUtils.prefs.getString('Mobilenum');
                tokenid = PrefUtils.prefs.getString('tokenid');

                if (PrefUtils.prefs.getString('mobile') != null) {
                  phone = PrefUtils.prefs.getString('mobile');
                } else {
                  phone = "";
                }
                if (PrefUtils.prefs.getString('photoUrl') != null) {
                  photourl = PrefUtils.prefs.getString('photoUrl');
                } else {
                  photourl = "";
                }
              });
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
                /*Navigator.of(context).pushReplacementNamed(
                  LoginScreen.routeName,);*/
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
          Fluttertoast.showToast(
              msg: S.of(context).sign_in_failed,//"Sign in failed!",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
          break;
        case AuthorizationStatus.cancelled:
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: S.of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
          break;
      }
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: S.of(context).apple_signin_not_available_forthis_device,//"Apple SignIn is not available for your device!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }

  Future<void> otpCall() async {
    try {
      final response = await http.post(Api.resendOtpCall, body: {
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> Otpin30sec() async {
    try {
      final response = await http.post(Api.resendOtp30, body: {
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> checkusertype(String prev) async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      var response;
      if (prev == "signInApple") {
        response = await http.post(Api.emailLogin, body: {
          // await keyword is used to wait to this operation is complete.
          "email": PrefUtils.prefs.getString('Email'),
          "tokenId": PrefUtils.prefs.getString('tokenid'),
          "apple": PrefUtils.prefs.getString('apple'),
        });
      } else {
        response = await http.post(Api.emailLogin, body: {
          // await keyword is used to wait to this operation is complete.
          "email": PrefUtils.prefs.getString('Email'),
          "tokenId": PrefUtils.prefs.getString('tokenid'),
        });
      }

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['type'].toString() == "old") {
        if (responseJson['data'] != "null") {
          final data = responseJson['data'] as Map<String, dynamic>;

          if (responseJson['status'].toString() == "true") {
            PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
            PrefUtils.prefs.setString('userID', data['userID'].toString());
            PrefUtils.prefs.setString('membership', data['membership'].toString());
            PrefUtils.prefs.setString("mobile", data['mobile'].toString());
            PrefUtils.prefs.setString("latitude", data['latitude'].toString());
            PrefUtils.prefs.setString("longitude", data['longitude'].toString());
          } else if (responseJson['status'].toString() == "false") {}
        }

        PrefUtils.prefs.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
         /* if (PrefUtils.prefs.getString('FirstName') != null) {
            if (PrefUtils.prefs.getString('LastName') != null) {
              name = PrefUtils.prefs.getString('FirstName').toString() +
                  " " +
                  PrefUtils.prefs.getString('LastName').toString();
            } else {
              name = PrefUtils.prefs.getString('FirstName').toString();
            }
          } else {
            name = "";
          }*/
          name = store.userData.username;
          //name = PrefUtils.prefs.getString('FirstName') + " " + PrefUtils.prefs.getString('LastName');
          if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs.getString('Email').toString();
          }
          mobile = PrefUtils.prefs.getString('Mobilenum');
          tokenid = PrefUtils.prefs.getString('tokenid');

          if (PrefUtils.prefs.getString('mobile') != null) {
            phone = PrefUtils.prefs.getString('mobile');
          } else {
            phone = "";
          }
          if (PrefUtils.prefs.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs.getString('photoUrl');
          } else {
            photourl = "";
          }
        });
        _getprimarylocation();
      } else {
        Navigator.of(context).pop();
        /* Navigator.of(context).pushReplacementNamed(
          LoginScreen.routeName,
        );*/
        (_isWeb && !ResponsiveLayout.isSmallScreen(context))?_dialogforRefer(context):null;
      }
    } catch (error) {
      Navigator.of(context).pop();
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
                      TextField(
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
                          signupUser();//SignupUser();
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
  Future<void> _handleSignIn() async {
    PrefUtils.prefs.setString('skip', "no");
    PrefUtils.prefs.setString('applesignin', "no");
    try {
      final response = await _googleSignIn.signIn();
      response.email.toString();
      response.displayName.toString();
      response.photoUrl.toString();

      PrefUtils.prefs.setString('FirstName', response.displayName.toString());
      PrefUtils.prefs.setString('LastName', "");
      PrefUtils.prefs.setString('Email', response.email.toString());
      PrefUtils.prefs.setString("photoUrl", response.photoUrl.toString());

      PrefUtils.prefs.setString('prevscreen', "signingoogle");
      checkusertype("Googlesigin");
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: S.of(context).sign_in_failed,//"Sign in failed!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }

  _customToast() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              S.of(context).please_enter_valid_otp,
                //"Please enter a valid otp!!!"
              ),
          );
        });
  }

  addMobilenumToSF(String value) async {
    PrefUtils.prefs.setString('Mobilenum', value);
  }

  _verifyOtp() async {
    //var otpval = otp1 + otp2 + otp3 + otp4;

    //SharedPreferences prefs = await SharedPreferences.getInstance();

    if (controller.text == PrefUtils.prefs.getString('Otp')) {
      setState(() {
        _isLoading = true;
      });

      if (PrefUtils.prefs.getString('type') == "old") {
        PrefUtils.prefs.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
        /*  if (PrefUtils.prefs.getString('FirstName') != null) {
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
          if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs.getString('Email');
          }
          mobile = PrefUtils.prefs.getString('Mobilenum');
          tokenid = PrefUtils.prefs.getString('tokenid');

          if (PrefUtils.prefs.getString('mobile') != null) {
            phone = PrefUtils.prefs.getString('mobile');
          } else {
            phone = "";
          }
          if (PrefUtils.prefs.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs.getString('photoUrl');
          } else {
            photourl = "";
          }
        });
        _getprimarylocation();
      } else {
        if (PrefUtils.prefs.getString('prevscreen') == 'signingoogle' ||
            PrefUtils.prefs.getString('prevscreen') == 'signupselectionscreen' ||
            PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail' ||
            PrefUtils.prefs.getString('prevscreen') == 'signInApple' ||
            PrefUtils.prefs.getString('prevscreen') == 'signinfacebook') {
          return signupUser();
        } else {
          PrefUtils.prefs.setString('prevscreen', "otpconfirmscreen");
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          _dialogforAddInfo();
        }
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      _customToast();
    }
  }

  _saveAddInfoForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState.save();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //checkemail();
    _dialogforProcessing();
    if(PrefUtils.prefs.getString('Email') == "" || PrefUtils.prefs.getString('Email') == "null") {
      return SignupUser();
    } else {
      checkemail();
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
      //  SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": name,
        "email": email,
        "mobileNumber": mobile,
        "path": apple,
        "tokenId": tokenid,
        "branch": PrefUtils.prefs.getString('branch') /*'999'*/,
        "signature":
        PrefUtils.prefs.containsKey("signature") ? PrefUtils.prefs.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs.setString('referral', PrefUtils.prefs.getString('referralCode'));
        PrefUtils.prefs.setString('referid', _referController.text);

        PrefUtils.prefs.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
         /* if (PrefUtils.prefs.getString('FirstName') != null) {
            if (PrefUtils.prefs.getString('LastName') != null) {
              name = PrefUtils.prefs.getString('FirstName'.toString()) +
                  " " +
                  PrefUtils.prefs.getString('LastName'.toString());
            } else {
              name = PrefUtils.prefs.getString('FirstName'.toString());
            }
          } else {
            name = "";
          }*/
          name = store.userData.username;
          //name = PrefUtils.prefs.getString('FirstName') + " " + PrefUtils.prefs.getString('LastName');
          if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs.getString('Email'.toString());
          }
          mobile = PrefUtils.prefs.getString('Mobilenum');
          tokenid = PrefUtils.prefs.getString('tokenid');

          if (PrefUtils.prefs.getString('mobile') != null) {
            phone = PrefUtils.prefs.getString('mobile');
          } else {
            phone = "";
          }
          if (PrefUtils.prefs.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs.getString('photoUrl');
          } else {
            photourl = "";
          }
        });

        Navigator.of(context).pop();
        PrefUtils.prefs.setString("formapscreen", "");
        return Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
        /*return Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);*/
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }
  Future<void> checkemail() async {
    try {
      final response = await http.post(Api.emailCheck, body: {
        "email": PrefUtils.prefs.getString('Email'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          (_isWeb)?Navigator.of(context).pop():null;
          return Fluttertoast.showToast(
              msg: S.of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        } else if (responseJson['type'].toString() == "new") {
          return SignupUser();
        }
      } else {
        return Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong!!!"
        );
      }
    } catch (error) {
      throw error;
    }
  }
  Future<void> SignupUser() async {
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
      String apple = "";
      if (PrefUtils.prefs.getString('applesignin') == "yes") {
        apple = PrefUtils.prefs.getString('apple');
      } else {
        apple = "";
      }

      String name =
          PrefUtils.prefs.getString('FirstName').toString() + " " + PrefUtils.prefs.getString('LastName').toString();

      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": name,
        "email": PrefUtils.prefs.getString('Email'),
        "mobileNumber": PrefUtils.prefs.containsKey("Mobilenum") ? PrefUtils.prefs.getString('Mobilenum') : "",
        "path": apple,
        "tokenId": PrefUtils.prefs.getString('tokenid'),
        "branch": PrefUtils.prefs.getString('branch'),
        "signature":
        PrefUtils.prefs.containsKey("signature") ? PrefUtils.prefs.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        final data = responseJson['data'] as Map<String, dynamic>;
        PrefUtils.prefs.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs.setString("mobile", PrefUtils.prefs.getString('Mobilenum'));
        PrefUtils.prefs.setString('referral', PrefUtils.prefs.getString('referralCode'));
        PrefUtils.prefs.setString('referid', _referController.text);

        PrefUtils.prefs.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
         /* if (PrefUtils.prefs.getString('FirstName') != null) {
            if (PrefUtils.prefs.getString('LastName') != null) {
              name = PrefUtils.prefs.getString('FirstName'.toString()) +
                  " " +
                  PrefUtils.prefs.getString('LastName'.toString());
            } else {
              name = PrefUtils.prefs.getString('FirstName'.toString());
            }
          } else {
            name = "";
          }
*/
          name = store.userData.username;
          //name = PrefUtils.prefs.getString('FirstName') + " " + PrefUtils.prefs.getString('LastName');
          if (PrefUtils.prefs.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs.getString('Email'.toString());
          }
          mobile = PrefUtils.prefs.getString('Mobilenum');
          tokenid = PrefUtils.prefs.getString('tokenid');

          if (PrefUtils.prefs.getString('mobile') != null) {
            phone = PrefUtils.prefs.getString('mobile');
          } else {
            phone = "";
          }
          if (PrefUtils.prefs.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs.getString('photoUrl');
          } else {
            photourl = "";
          }
        });
        Navigator.of(context).pop();
        PrefUtils.prefs.setString("formapscreen", "");
        return Navigator.of(context).pushReplacementNamed(MapScreen.routeName);

        /*return Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
*/
        /*Navigator.of(context).pushReplacementNamed(
          HomeScreen.routeName,
        );*/

      } else if (responseJson['status'].toString() == "false") {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: responseJson['data'].toString(),
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    } catch (error) {
      setState(() {});
      throw error;
    }
  }


  addReferralToSF(String value)async{
    PrefUtils.prefs.setString('referid', value);
  }

  addFirstnameToSF(String value) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs.setString('FirstName', value);
  }

  addLastnameToSF(String value) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs.setString('LastName', value);
  }

  addEmailToSF(String value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs.setString('Email', value);
  }

  _dialogforAddInfo() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                height: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width / 3,
                width: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.7,
                //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).add_info,//"Add your info",
                          style: TextStyle(
                              color: ColorCodes.mediumBlackColor,
                              fontSize: 20.0),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  S.of(context).what_should_we_call_you,//'* What should we call you?',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).name,//'Name',
                                    hoverColor: ColorCodes.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lnameFocusNode);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        fn = "  Please Enter Name";
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      fn = "";
                                    });
                                    return null;
                                  },
                                  onSaved: (value) {
                                    addFirstnameToSF(value);
                                  },
                                ),
                                Text(
                                  fn,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  S.of(context).tell_us_your_email,//'Tell us your e-mail',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      decorationColor:
                                      Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintText: 'xyz@gmail.com',
                                    fillColor: ColorCodes.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: ColorCodes.primaryColor, width: 1.2),
                                    ),
                                  ),
                                  validator: (value) {
                                    bool emailValid;
                                    if (value == "")
                                      emailValid = true;
                                    else
                                      emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);

                                    if (!emailValid) {
                                      setState(() {
                                        ea =
                                        ' Please enter a valid email address';
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      ea = "";
                                    });
                                    return null; //it means user entered a valid input
                                  },
                                  onSaved: (value) {
                                    addEmailToSF(value);
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ea,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                Text(
                                  S.of(context).we_will_email,//' We\'ll email you as a reservation confirmation.',
                                  style: TextStyle(
                                      fontSize: 15.2, color: ColorCodes.emailColor),
                                ),

                                SizedBox(
                                  height: 15.0,
                                ),
                                if(Features.isReferEarn)
                                  Text(
                                    S.of(context).apply_referal_code,//'Apply referral Code',
                                    style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                if(Features.isReferEarn)
                                  TextFormField(
                                    controller: _referController,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        decorationColor: Theme.of(context).primaryColor),
                                    decoration: InputDecoration(
                                      hintText: S.of(context).refer_earn,//'Refer and Earn',
                                      fillColor: Colors.green,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green, width: 1.2),
                                      ),
                                    ),
                                    /*  validator: (value) {
                        bool emailValid;
                        if (value == "")
                          emailValid = true;
                        else
                          emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);

                        if (!emailValid) {
                          setState(() {
                            ea = ' Please enter a valid email address';
                          });
                          return '';
                        }
                        setState(() {
                          ea = "";
                        });
                        return null; //it means user entered a valid input
                      },*/
                                    onSaved: (value) {
                                      addReferralToSF(value);
                                    },
                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        //  Spacer(),
                      ],
                    ),
                  ),


                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _saveAddInfoForm();
                          _dialogforProcessing();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              )),
                          height: 60.0,
                          child: Center(
                            child: Text(
                              S.of(context).continue_button,//"CONTINUE",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ),
                ]),
              ),
            );
          });
        });
  }

  _dialogforOtp() async {
    return alertOtp(context);
  }



  _dialogforSignIn() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                height: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width / 2.2,
                width: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 3.0,
                //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).signin,//"Sign in",
                          style: TextStyle(
                              color: ColorCodes.mediumBlackColor,
                              fontSize: 20.0),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 52,
                          margin: EdgeInsets.only(bottom: 8.0),
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                                width: 0.5, color: ColorCodes.borderColor),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                Images.countryImg,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      S.of(context).country_region,
                                      //"Country/Region",
                                      style: TextStyle(
                                        color: ColorCodes.greyColor,
                                      )),
                                  Text(countryName + " (" + IConstants.countryCode + ")",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 52.0,
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                                width: 0.5, color: ColorCodes.borderColor),
                          ),
                          child: Row(
                            children: <Widget>[
                              Image.asset(Images.phoneImg),
                              SizedBox(
                                width: 14,
                              ),
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width / 4.0,
                                  child: Form(
                                    key: _form,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 16.0),
                                      textAlign: TextAlign.left,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(12)
                                      ],
                                      cursorColor:
                                      Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: 'Enter Your Mobile Number',
                                          hintStyle: TextStyle(
                                            color: Colors.black12,
                                          )),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a Mobile number.';
                                        }
                                        return null; //it means user entered a valid input
                                      },
                                      onSaved: (value) {
                                        addMobilenumToSF(value);
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60.0,
                          margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
                          child: Text(
                            S.of(context).we_will_call_or_text,//"We'll call or text you to confirm your number. Standard message data rates apply.",
                            style: TextStyle(
                                fontSize: 13, color: ColorCodes.mediumBlackWebColor),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              PrefUtils.prefs.setString('skip', "no");
                              PrefUtils.prefs.setString('prevscreen', "mobilenumber");
                              // PrefUtils.prefs.setString('Mobilenum', value);
                              _saveFormLogin();
                              _dialogforProcess();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 32,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: ColorCodes.greenColor,
                                ),
                              ),
                              child: Text(
                                S.of(context).login_using_otp,//"LOGIN USING OTP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: ColorCodes.blackColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60.0,
                          margin: EdgeInsets.only(top: 12.0, bottom: 32.0),
                          child: new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: S.of(context).agreed_terms,//'By continuing you agree to the '
                                ),
                                new TextSpan(
                                    text: S.of(context).terms_of_service,//' terms of service',
                                    style:
                                    new TextStyle(color: ColorCodes.darkthemeColor),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).pushNamed(
                                            PolicyScreen.routeName,
                                            arguments: {
                                              'title': "Terms of Use",
                                              'body': IConstants.restaurantTerms,
                                            });
                                      }),
                                new TextSpan(text: S.of(context).and,//' and'
                                ),
                                new TextSpan(
                                    text: S.of(context).privacy_policy,//' Privacy Policy',
                                    style:
                                    new TextStyle(color: ColorCodes.darkthemeColor),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).pushNamed(
                                            PolicyScreen.routeName,
                                            arguments: {
                                              'title': "Privacy",
                                              'body':
                                              PrefUtils.prefs.getString("privacy"),
                                            });
                                      }),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                              Container(
                                //padding: EdgeInsets.all(4.0),
                                width: 23.0,
                                height: 23.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorCodes.greyColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Text(
                                      S.of(context).or,//"OR",
                                      style: TextStyle(
                                          fontSize: 10.0, color: ColorCodes.greyColor),
                                    )),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28),
                              child: GestureDetector(
                                onTap: () {
                                  _dialogforProcessing();
                                  Navigator.of(context).pop();
                                  _handleSignIn();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  child: Container(

                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(right:23.0,left:23,),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                            //Image.asset(Images.googleImg,width: 20,height: 40,),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            Text(
                                              S.of(context).sign_in_with_google,//"Sign in with Google" , //"Sign in with Google",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes.signincolor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70, horizontal: 28),
                              child: GestureDetector(
                                onTap: () {
                                  _dialogforProcessing();
                                  Navigator.of(context).pop();
                                  facebooklogin();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),

                                      // border: Border.all(width: 0.5, color: ColorCodes.borderColor),
                                    ),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(right:23.0,left: 23),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                                            //Image.asset(Images.facebookImg,width: 20,height: 40,),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            Text(
                                              S.of(context).sign_in_with_facebook,//"Sign in with Facebook" ,// "Sign in with Facebook",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes.signincolor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (_isAvailable)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 28),
                                child: GestureDetector(
                                  onTap: () {
                                    appleLogIn();
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4.0),
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    child: Container(

                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(right:23.0,left:23,),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SvgPicture.asset(Images.appleImg, width: 25, height: 25,),
                                              //Image.asset(Images.appleImg, width: 20,height: 40,),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              Text(
                                                S.of(context).signin_apple,//"Sign in with Apple"  , //"Sign in with Apple",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.signincolor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          });
        });
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
  _dialogforProcess() {
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
  _saveFormLogin() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<BrandItemsList>(context,listen: false).LoginUser();
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    _dialogforOtp();
  }
  void alertOtp(BuildContext ctx) {
    mobile = PrefUtils.prefs.getString("Mobilenum");
    var alert = AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: StreamBuilder<int>(
            stream: _events.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Container(
                  height: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.width / 3,
                  width: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2.5,
                  child: Column(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      padding: EdgeInsets.only(left: 20.0),
                      color: ColorCodes.lightGreyWebColor,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).signup_otp,//"Signup using OTP",
                            style: TextStyle(
                                color: ColorCodes.mediumBlackColor,
                                fontSize: 20.0),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 25.0),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                S.of(context).please_check_otp_sent_to_your_mobile_number,//'Please check OTP sent to your mobile number',
                                style: TextStyle(
                                    color: ColorCodes.mediumBlackWebColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),

                                // textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 20.0),
                                Text(
                                  IConstants.countryCode + '  $mobile',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16.0),
                                ),
                                SizedBox(width: 30.0),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _dialogforSignIn();
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Color(0x707070B8), width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                            S.of(context).change,//'Change',
                                            style: TextStyle(
                                                color: ColorCodes.blackColor,
                                                fontSize: 13))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                S.of(context).enter_otp,//'Enter OTP',
                                style: TextStyle(
                                    color: ColorCodes.greyColor, fontSize: 14),
                                //textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Auto Sms
                                  Container(
                                      height: 40,
                                      //width: MediaQuery.of(context).size.width*80/100,
                                      width: (_isWeb &&
                                          ResponsiveLayout.isSmallScreen(
                                              context))
                                          ? MediaQuery.of(context).size.width /
                                          2
                                          : MediaQuery.of(context).size.width /
                                          3,
                                      //padding: EdgeInsets.zero,
                                      child: PinFieldAutoFill(
                                          controller: controller,
                                          decoration: UnderlineDecoration(
                                              colorBuilder: FixedColorBuilder(
                                                  ColorCodes.greyColor)),
                                          onCodeChanged: (text) {
                                            otpvalue = text;
                                            SchedulerBinding.instance
                                                .addPostFrameCallback(
                                                    (_) => setState(() {}));
                                          },
                                          onCodeSubmitted: (text) {
                                            SchedulerBinding.instance
                                                .addPostFrameCallback(
                                                    (_) => setState(() {
                                                  otpvalue = text;
                                                }));
                                          },
                                          codeLength: 4,
                                          currentCode: otpvalue)),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            _showOtp
                                ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      width: (_isWeb && ResponsiveLayout.isSmallScreen(context))
                                          ? MediaQuery.of(context).size.width * 50 / 100
                                          : MediaQuery.of(context).size.width * 32 / 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        border: Border.all(
                                            color: ColorCodes.greyColor,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S.of(context).resend_otp,//'Resend OTP'
                                          )),
                                    ),
                                  ),
                                  if(Features.callMeInsteadOTP)
                                  Container(
                                    height: 28,
                                    width: 28,
                                    margin: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      border: Border.all(
                                          color: ColorCodes.greyColor,
                                          width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                          S.of(context).or,//'OR',
                                          style: TextStyle(fontSize: 10),
                                        )),
                                  ),
                                  if(Features.callMeInsteadOTP)
                                  _timeRemaining == 0
                                      ? MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior
                                          .translucent,
                                      onTap: () {
                                        otpCall();
                                        _timeRemaining = 60;
                                      },
                                      child: Expanded(
                                        child: Container(
                                          height: 40,
                                          //width: MediaQuery.of(context).size.width*32/100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(6),
                                            border: Border.all(
                                                color: ColorCodes.primaryColor,
                                                width: 1.5),
                                          ),

                                          child: Center(
                                              child: Text(
                                                S.of(context).call_me_instead, //'Call me Instead'
                                              )),
                                        ),
                                      ),
                                    ),
                                  )
                                      : Expanded(
                                    child: Container(
                                      height: 40,
                                      //width: MediaQuery.of(context).size.width*32/100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            6),
                                        border: Border.all(
                                            color:
                                            ColorCodes.greyColor,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: S.of(context).call_in,//'Call in',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black)),
                                              new TextSpan(
                                                text:
                                                ' 00:$_timeRemaining',
                                                style: TextStyle(
                                                  color: ColorCodes.lightGreyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ])
                                : Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _timeRemaining == 0
                                    ? MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    behavior:
                                    HitTestBehavior.translucent,
                                    onTap: () {
                                      //  _showCall = true;
                                      _showOtp = true;
                                      _timeRemaining += 30;
                                      Otpin30sec();
                                    },
                                    child: Expanded(
                                      child: Container(
                                        height: 40,
                                        width: (_isWeb &&
                                            ResponsiveLayout
                                                .isSmallScreen(
                                                context))
                                            ? MediaQuery.of(context)
                                            .size
                                            .width *
                                            30 /
                                            100
                                            : MediaQuery.of(context)
                                            .size
                                            .width *
                                            15 /
                                            100,
                                        //width: MediaQuery.of(context).size.width*32/100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              6),
                                          border: Border.all(
                                              color: ColorCodes.primaryColor,
                                              width: 1.5),
                                        ),
                                        child: Center(
                                            child:
                                            Text(
                                              S.of(context).resend_otp,
                                                //'Resend OTP'
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                                    : Expanded(
                                  child: Container(
                                    height: 40,
                                    //width: MediaQuery.of(context).size.width*40/100,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(6),
                                      border: Border.all(
                                          color: Color(0x707070B8),
                                          width: 1.5),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                S.of(context).resend_otp_in,//'Resend Otp in',
                                                style: TextStyle(
                                                    color: Colors
                                                        .black)),
                                            new TextSpan(
                                              text:
                                              ' 00:$_timeRemaining',
                                              style: TextStyle(
                                                color: ColorCodes.lightGreyColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if(Features.callMeInsteadOTP)
                                Container(
                                  height: 28,
                                  width: 28,
                                  margin: EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    border: Border.all(
                                        color: ColorCodes.greyColor,
                                        width: 1.5),
                                  ),
                                  child: Center(
                                      child: Text(
                                        S.of(context).or,//'OR',
                                        style: TextStyle(fontSize: 10),
                                      )),
                                ),
                                if(Features.callMeInsteadOTP)
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    //width: MediaQuery.of(context).size.width*32/100,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(6),
                                      border: Border.all(
                                          color: ColorCodes.greyColor,
                                          width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                          S.of(context).call_me_instead,//'Call me Instead'
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Spacer(),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _verifyOtp();
                            _dialogforProcessing();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            height: 60.0,
                            child: Center(
                              child: Text(
                                S.of(context).login,//"LOGIN",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ]));
            }));
    _startTimer();
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return alert;
        });
  }
  void _startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_timeRemaining > 0) ? _timeRemaining-- : _timer.cancel();
      //});
      _events.add(_timeRemaining);
    });
  }




  _Toast(String value){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(value),
          );
        });
  }

  _notifyMe() async {
    setState(() {
      _isNotify = true;
    });
    //_notifyMe();
    int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(widget.id,varid,widget.type);
    if(resposne == 200) {
      setState(() {
        _isNotify = false;
      });
      //_isWeb?_Toast("You will be notified via SMS/Push notification, when the product is available"):
      Fluttertoast.showToast(msg: S.of(context).you_will_notify,//"You will be notified via SMS/Push notification, when the product is available" ,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor:
          Colors.black87,
          textColor: Colors.white);

    } else {
      Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong" ,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor:
          Colors.black87,
          textColor: Colors.white);
      setState(() {
        _isNotify = false;
      });
    }
  }

  addToCart(int _itemCount) async {
    if (widget._fromScreen == "home_screen") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByfeaturedimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "singleproduct_screen") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIditemsnewimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "Discount") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findBydiscountimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }
    else if (widget._fromScreen == "Offers") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByofferimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }
    else if (widget._fromScreen == "Forget") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByForgotimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }
    else if (widget._fromScreen == "searchitem_screen") {
      multiimage = Provider.of<ItemsList>(context, listen: false).findBysearchimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "sellingitem_screen") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIdallimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "brands_screen") {
      multiimage = Provider.of<BrandItemsList>(context, listen: false).findBybrandimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }
    await Provider.of<CartItems>(context, listen: false).addToCart(
        widget.id, varid, (varname+unit), varminitem, varmaxitem, varLoyalty.toString(), varstock, varmrp, widget.title,
        _itemCount.toString(), varprice, varmemberprice, itemimg/*widget.imageUrl*/, "0", "0",widget.veg_type,widget.type,widget.eligibleforexpress,widget.delivery,widget.duration,widget.durationType,widget.note).then((_) async {

      debugPrint("adding......" + productBox.length.toString());
      if(widget._fromScreen == "Forget") {
        //cartBloc.cartItems();
        await Provider.of<CartItems>(context, listen: false).fetchCartItems().then((_) {
          setState(() {
            _isAddToCart = false;
            varQty = _itemCount;
          });
        });
      } else
      setState(() {
        _isAddToCart = false;
        varQty = _itemCount;
      });
      final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
      for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
        if(sellingitemData.featuredVariation[i].varid == varid) {
          sellingitemData.featuredVariation[i].varQty = _itemCount;
          break;
        }
      }
      for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
        if (sellingitemData.itemspricevarOffer[i].varid == varid) {
          sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
        if(sellingitemData.itemspricevarSwap[i].varid == varid) {
          sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
        if(sellingitemData.discountedVariation[i].varid == varid) {
          sellingitemData.discountedVariation[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.recentVariation.length; i++) {
        if(sellingitemData.recentVariation[i].varid == varid) {
          sellingitemData.recentVariation[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.forgetVariation.length; i++) {
        if(sellingitemData.forgetVariation[i].varid == varid) {
          sellingitemData.forgetVariation[i].varQty = _itemCount;
          break;
        }
      }
      _bloc.setFeaturedItem(sellingitemData);

      /*CartItems.itemsList.add(CartItemsFields(
        itemId: int.parse(widget.id),
        varId: int.parse(varid),
        varName: varname,
        varMinItem: int.parse(varminitem),
        varMaxItem: int.parse(varmaxitem),
        varStock: int.parse(varstock),
        varMrp: double.parse(varmrp),
        itemName: widget.title,
        itemQty: _itemCount,
        status: 0,
        itemPrice: double.parse(varprice),
        membershipPrice: varmemberprice,
        itemActualprice: double.parse(varmrp),
        itemImage: widget.imageUrl,
        itemLoyalty: varLoyalty,
        membershipId: 0,
        mode: 0,
      ));
      final cartItemsData = Provider.of<CartItems>(context, listen: false);
      _bloc.setCartItem(cartItemsData);
*/
      Product products = Product(
          itemId: int.parse(widget.id),
          varId: int.parse(varid),
          varName: varname+unit,
          varMinItem: int.parse(varminitem),
          varMaxItem: int.parse(varmaxitem),
          itemLoyalty: varLoyalty,
          varStock: int.parse(varstock),
          varMrp: double.parse(varmrp),
          itemName: widget.title,
          itemQty: _itemCount,
          itemPrice: double.parse(varprice),
          membershipPrice: varmemberprice,
          itemActualprice: double.parse(varmrp),
          itemImage: widget.imageUrl,
          membershipId: 0,
          mode: 0,
        veg_type: widget.veg_type,
        type: widget.type,
          eligible_for_express: widget.eligibleforexpress,
          delivery: widget.delivery,
          duration: widget.duration,
          durationType: widget.durationType,
          note: widget.note
      );
      debugPrint("before adding......" + productBox.length.toString());
      if(widget._fromScreen != "Forget")
        productBox.add(products);
      debugPrint("after adding......" + productBox.length.toString());
    });
  }


  addToCartSub(int _itemCount) async {
    if (widget._fromScreen == "home_screen") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByfeaturedimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "singleproduct_screen") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIditemsnewimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "Discount") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findBydiscountimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }  else if (widget._fromScreen == "Offers") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByofferimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "Forget") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByForgotimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }
    else if (widget._fromScreen == "searchitem_screen") {
      multiimage = Provider.of<ItemsList>(context, listen: false).findBysearchimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "sellingitem_screen") {
      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIdallimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    } else if (widget._fromScreen == "brands_screen") {
      multiimage = Provider.of<BrandItemsList>(context, listen: false).findBybrandimage(varid);
      _displayimg = multiimage[0].imageUrl;
      if(itemvarData.length<=1) {
        itemimg =  widget.imageUrl;
      }else{
        itemimg =_displayimg;
      }
    }
    await Provider.of<CartItems>(context, listen: false).addToCart(
        widget.id, varid, varname+unit, varminitem, varmaxitem, varLoyalty.toString(), varstock, varmrp, widget.title,
        _itemCount.toString(), varprice, varmemberprice, itemimg/*widget.imageUrl*/, "0", "0",widget.veg_type,widget.type,widget.eligibleforexpress,widget.delivery,widget.duration,widget.durationType,widget.note).then((_) {


      setState(() {
        _isAddToCart = false;
        varQty = _itemCount;
      });
      final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
      for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
        if(sellingitemData.featuredVariation[i].varid == varid) {
          sellingitemData.featuredVariation[i].varQty = _itemCount;
          break;
        }
      }
      for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
        if (sellingitemData.itemspricevarOffer[i].varid == varid) {
          sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
        if(sellingitemData.itemspricevarSwap[i].varid == varid) {
          sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
        if(sellingitemData.discountedVariation[i].varid == varid) {
          sellingitemData.discountedVariation[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.recentVariation.length; i++) {
        if(sellingitemData.recentVariation[i].varid == varid) {
          sellingitemData.recentVariation[i].varQty = _itemCount;
          break;
        }
      }
      for(int i = 0; i < sellingitemData.forgetVariation.length; i++) {
        if(sellingitemData.forgetVariation[i].varid == varid) {
          sellingitemData.forgetVariation[i].varQty = _itemCount;
          break;
        }
      }
      _bloc.setFeaturedItem(sellingitemData);

      /*CartItems.itemsList.add(CartItemsFields(
        itemId: int.parse(widget.id),
        varId: int.parse(varid),
        varName: varname,
        varMinItem: int.parse(varminitem),
        varMaxItem: int.parse(varmaxitem),
        varStock: int.parse(varstock),
        varMrp: double.parse(varmrp),
        itemName: widget.title,
        itemQty: _itemCount,
        status: 0,
        itemPrice: double.parse(varprice),
        membershipPrice: varmemberprice,
        itemActualprice: double.parse(varmrp),
        itemImage: widget.imageUrl,
        itemLoyalty: varLoyalty,
        membershipId: 0,
        mode: 0,
      ));
      final cartItemsData = Provider.of<CartItems>(context, listen: false);
      _bloc.setCartItem(cartItemsData);
*/
      Product products = Product(
          itemId: int.parse(widget.id),
          varId: int.parse(varid),
          varName: varname+unit,
          varMinItem: int.parse(varminitem),
          varMaxItem: int.parse(varmaxitem),
          itemLoyalty: varLoyalty,
          varStock: int.parse(varstock),
          varMrp: double.parse(varmrp),
          itemName: widget.title,
          itemQty: _itemCount,
          itemPrice: double.parse(varprice),
          membershipPrice: varmemberprice,
          itemActualprice: double.parse(varmrp),
          itemImage: widget.imageUrl,
          membershipId: 0,
          mode: 0,
          veg_type: widget.veg_type,
          type: widget.type,
          eligible_for_express: widget.eligibleforexpress,
          delivery: widget.delivery,
          duration: widget.duration,
          durationType: widget.durationType,
          note: widget.note
      );

      productBox.add(products);
    });
  }


  incrementToCart(int _itemCount) async {
    if(varQty+1 == _itemCount)
      fas.LogAddtoCart(itemId: itemvarData[0].varid, itemName: itemvarData[0].varname+itemvarData[0].unit, itemCategory: itemvarData[0].menuid, quantity: itemvarData[0].varQty, amount:double.parse( itemvarData[0].varprice), value: Cart.ADD);
else if(varQty-1 == _itemCount)
      fas.LogAddtoCart(itemId: itemvarData[0].varid, itemName: itemvarData[0].varname+itemvarData[0].unit, itemCategory: itemvarData[0].menuid, quantity: itemvarData[0].varQty, amount:double.parse( itemvarData[0].varprice), value: Cart.Remove);
else if(_itemCount == 0){
  for(int i=0;i<itemvarData.length;i++){
    fas.LogAddtoCart(itemId: itemvarData[i].varid, itemName: itemvarData[i].varname+itemvarData[0].unit, itemCategory: itemvarData[i].menuid, quantity: itemvarData[i].varQty, amount:double.parse( itemvarData[i].varprice), value: Cart.Remove);
  }
    }
    if (_itemCount + 1 <= int.parse(varminitem)) {
      _itemCount = 0;
    }
    final s = await Provider.of<CartItems>(context, listen: false).updateCart(varid, _itemCount.toString(), varprice).then((_) async {
      setState(() {
        _isAddToCart = false;
        varQty = _itemCount;
      });
      if (_itemCount + 1 <= int.parse(varminitem)) {
        debugPrint("delete....." + productBox.values.length.toString() + "..varid" + varid);
        for (int i = 0; i < productBox.values.length; i++) {
          debugPrint("varid./././" + varid + "..." + productBox.values.elementAt(i).varId.toString());
          if (productBox.values.elementAt(i).varId == int.parse(varid)) {
            productBox.deleteAt(i);
            if (widget._fromScreen == "Forget") {
              //cartBloc.cartItems();
              final cartItemsData = Provider.of<CartItems>(context, listen: false);
              for(int i = 0; i < cartItemsData.items.length; i++) {
                if(cartItemsData.items[i].varId == int.parse(varid)) {
                  cartItemsData.items[i].itemQty = _itemCount;
                }
              }
              _bloc.setCartItem(cartItemsData);
              /*setState(() {
                _isAddToCart = true;
              });
              debugPrint("Corrected.....");
              await Provider.of<CartItems>(context, listen: false).fetchCartItems().then((_) {
                debugPrint("Corrected.....1111");
                setState(() {
                  _isAddToCart = false;
                  varQty = _itemCount;
                });
              });*/
            }
            break;
          }
        }
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          if(sellingitemData.featuredVariation[i].varid == varid) {
            sellingitemData.featuredVariation[i].varQty = _itemCount;
          }
        }
        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          if (sellingitemData.itemspricevarOffer[i].varid == varid) {
            sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          if(sellingitemData.itemspricevarSwap[i].varid == varid) {
            sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          if(sellingitemData.discountedVariation[i].varid == varid) {
            sellingitemData.discountedVariation[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.recentVariation.length; i++) {
          if(sellingitemData.recentVariation[i].varid == varid) {
            sellingitemData.recentVariation[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.forgetVariation.length; i++) {
          if(sellingitemData.forgetVariation[i].varid == varid) {
            sellingitemData.forgetVariation[i].varQty = _itemCount;
            break;
          }
        }
        _bloc.setFeaturedItem(sellingitemData);

      } else {
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          if(sellingitemData.featuredVariation[i].varid == varid) {
            sellingitemData.featuredVariation[i].varQty = _itemCount;
            break;
          }
        }
        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          if (sellingitemData.itemspricevarOffer[i].varid == varid) {
            sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          if(sellingitemData.itemspricevarSwap[i].varid == varid) {
            sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          if(sellingitemData.discountedVariation[i].varid == varid) {
            sellingitemData.discountedVariation[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.recentVariation.length; i++) {
          if(sellingitemData.recentVariation[i].varid == varid) {
            sellingitemData.recentVariation[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.forgetVariation.length; i++) {
          if(sellingitemData.forgetVariation[i].varid == varid) {
            sellingitemData.forgetVariation[i].varQty = _itemCount;
            break;
          }
        }
        _bloc.setFeaturedItem(sellingitemData);

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          if(cartItemsData.items[i].varId == int.parse(varid)) {
            cartItemsData.items[i].itemQty = _itemCount;
          }
        }
        _bloc.setCartItem(cartItemsData);

        Product products = Product(
            itemId: int.parse(widget.id),
            varId: int.parse(varid),
            varName: varname+unit,
            varMinItem: int.parse(varminitem),
            varMaxItem: int.parse(varmaxitem),
            itemLoyalty: varLoyalty,
            varStock: int.parse(varstock),
            varMrp: double.parse(varmrp),
            itemName: widget.title,
            itemQty: _itemCount,
            itemPrice: double.parse(varprice),
            membershipPrice: varmemberprice,
            itemActualprice: double.parse(varmrp),
            itemImage: widget.imageUrl,
            membershipId: 0,
            mode: 0,
          veg_type: widget.veg_type,
          type: widget.type,
            eligible_for_express: widget.eligibleforexpress,
            delivery: widget.delivery,
            duration: widget.duration,
            durationType: widget.durationType,
            note: widget.note
        );

        var items = Hive.box<Product>(productBoxName);

        for (int i = 0; i < items.length; i++) {
          if (Hive.box<Product>(productBoxName).values.elementAt(i).varId == int.parse(varid)) {
            Hive.box<Product>(productBoxName).putAt(i, products);
          }
        }
      }
    });
  }

  Widget handler( int i) {
    if (int.parse(varstock) <= 0) {
      return (varid == itemvarData[i].varid) ?
      Icon(
          Icons.radio_button_checked_outlined,
          color: ColorCodes.grey)
          :
      Icon(
          Icons.radio_button_off_outlined,
          color: ColorCodes.blackColor);

    } else {
      return (varid == itemvarData[i].varid) ?
      Icon(
          Icons.radio_button_checked_outlined,
          color: ColorCodes.mediumBlueColor)
          :
      Icon(
          Icons.radio_button_off_outlined,
          color: ColorCodes.blackColor);
    }
  }

  Widget showoptions1() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState) {
                return Container(
                  // height: 400,
                  child: Padding(

                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 28),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(widget.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Image(
                                  height: 40,
                                  width: 40,
                                  image: AssetImage(
                                      Images.bottomsheetcancelImg),
                                  color: Colors.black,
                                )),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          // height: 200,
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: variationdisplaydata.length,
                                itemBuilder: (_, i) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      setState(() {
                                        varid = itemvarData[i].varid;
                                        varname = itemvarData[i].varname;
                                        unit =itemvarData[i].unit;
                                        weight=itemvarData[i].weight;
                                        varmrp = itemvarData[i].varmrp;
                                        varprice = itemvarData[i].varprice;
                                        varmemberprice = itemvarData[i].varmemberprice;
                                        varminitem = itemvarData[i].varminitem;
                                        varmaxitem = itemvarData[i].varmaxitem;
                                        varLoyalty = itemvarData[i].varLoyalty;
                                        varQty = (itemvarData[i].varQty >= 0) ? itemvarData[i].varQty : int.parse(itemvarData[i].varminitem);
                                        varstock = itemvarData[i].varstock;
                                        discountDisplay = itemvarData[i].discountDisplay;
                                        memberpriceDisplay = itemvarData[i].membershipDisplay;

                                        if (_checkmembership) {
                                          if (varmemberprice.toString() == '-' || double.parse(varmemberprice) <= 0) {
                                            if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                                              margins = "0";
                                            } else {
                                              var difference = (double.parse(varmrp) - double.parse(varprice));
                                              var profit = difference / double.parse(varmrp);
                                              margins = profit * 100;

                                              //discount price rounding
                                              margins = num.parse(margins.toStringAsFixed(0));
                                              margins = margins.toString();
                                            }
                                          } else {
                                            var difference = (double.parse(varmrp) - double.parse(varmemberprice));
                                            var profit = difference / double.parse(varmrp);
                                            margins = profit * 100;

                                            //discount price rounding
                                            margins = num.parse(margins.toStringAsFixed(0));
                                            margins = margins.toString();
                                          }
                                        } else {
                                          if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {margins = "0";
                                          } else {
                                            var difference = (double.parse(varmrp) - double.parse(varprice));
                                            var profit = difference / double.parse(varmrp);
                                            margins = profit * 100;

                                            //discount price rounding
                                            margins = num.parse(margins.toStringAsFixed(0));
                                            margins = margins.toString();
                                          }
                                        }
                                        if (widget._fromScreen == "home_screen") {
                                          multiimage = Provider.of<SellingItemsList>(context, listen: false).findByfeaturedimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        } else if (widget._fromScreen == "singleproduct_screen") {
                                          multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIditemsnewimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        } else if (widget._fromScreen == "Discount") {
                                          multiimage = Provider.of<SellingItemsList>(context, listen: false).findBydiscountimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        }else if (widget._fromScreen == "Offers") {
                                          multiimage = Provider.of<SellingItemsList>(context, listen: false).findByofferimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        }  else if (widget._fromScreen == "Forget") {
                                          multiimage = Provider.of<SellingItemsList>(context, listen: false).findByForgotimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        }
                                        else if (widget._fromScreen == "searchitem_screen") {
                                          multiimage = Provider.of<ItemsList>(context, listen: false).findBysearchimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        } else if (widget._fromScreen == "sellingitem_screen") {
                                          multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIdallimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        } else if (widget._fromScreen == "brands_screen") {
                                          multiimage = Provider.of<BrandItemsList>(context, listen: false).findBybrandimage(varid);
                                          _displayimg = multiimage[0].imageUrl;
                                        }
                                        Future.delayed(Duration(seconds: 0), () {
                                          dialogdisplay = true;
                                          for (int j = 0; j < variddata.length; j++) {
                                            if (i == j) {
                                              setState(() {
                                                checkBoxdata[i] = true;
                                                containercolor[i] = ColorCodes.whiteColor;
                                                textcolor[i] = ColorCodes.mediumBlueColor;
                                                iconcolor[i] = ColorCodes.mediumBlueColor;
                                              });
                                            } else {
                                              setState(() {
                                                checkBoxdata[j] = false;
                                                containercolor[j] = ColorCodes.whiteColor;
                                                iconcolor[j] = ColorCodes.lightgrey;
                                                textcolor[j] = ColorCodes.blackColor;
                                              });
                                            }
                                          }
                                        });
                                        // Navigator.of(context).pop(true);
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      padding: EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _checkmembership
                                              ? //membered usesr
                                          itemvarData[i].membershipDisplay
                                              ? RichText(
                                            text: TextSpan(
                                              style: TextStyle(fontSize: 14.0, color: itemvarData[i].varcolor,),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: varnamedata[i]+" "+unitdata[i]+
                                                      " - ",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: textcolor[i],
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: IConstants.currencyFormat + varmemberpricedata[i] + " ",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: textcolor[i],
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: IConstants.currencyFormat + varmrpdata[i],
                                                    style: TextStyle(color: textcolor[i],
                                                      decoration: TextDecoration.lineThrough,)),
                                              ],
                                            ),
                                          )
                                              : itemvarData[i].discountDisplay
                                              ? RichText(
                                            text: TextSpan(
                                              style: TextStyle(fontSize: 14.0, color: itemvarData[i].varcolor,),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: varnamedata[i]+" "+unitdata[i]+ " - ",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: textcolor[i],
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: IConstants.currencyFormat +
                                                      varpricedata[i] + " ",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: textcolor[i],
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: IConstants.currencyFormat + varmrpdata[i],
                                                    style:
                                                    TextStyle(
                                                      color: textcolor[i],
                                                      decoration:
                                                      TextDecoration.lineThrough,
                                                    )),
                                              ],
                                            ),
                                          )
                                              : new RichText(
                                            text: new TextSpan(
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color:
                                                itemvarData[i]
                                                    .varcolor,
                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                  text: varnamedata[i]+" "+unitdata[i]+ " - ",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: textcolor[i],
                                                  ),
                                                ),
                                                new TextSpan(
                                                  text:
                                                  IConstants.currencyFormat +
                                                      " " +
                                                      varmrpdata[
                                                      i],
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color: textcolor[i],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              : itemvarData[i].discountDisplay
                                              ? RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: itemvarData[i].varcolor,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: varnamedata[i]+" "+unitdata[i]+ " - ",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: textcolor[i],
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                  IConstants.currencyFormat + varpricedata[i] + " ",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: textcolor[i],
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: IConstants.currencyFormat + varmrpdata[i],
                                                    style: TextStyle(
                                                      color: textcolor[i],
                                                      decoration:
                                                      TextDecoration
                                                          .lineThrough,
                                                    )),
                                              ],
                                            ),
                                          )
                                              : new RichText(
                                            text: new TextSpan(
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color: itemvarData[i]
                                                    .varcolor,
                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                  text: varnamedata[i]+" "+unitdata[i]+
                                                      " - ",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: textcolor[i],
                                                  ),
                                                ),
                                                new TextSpan(
                                                  text:
                                                  IConstants.currencyFormat +
                                                      " " +
                                                      varmrpdata[i],
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: textcolor[i],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          handler(i),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if(Features.isSubscription)
                       (widget.subscribe == "0")?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (int.parse(varstock) <= 0)  ?
                              SizedBox(height: 40,)
                                  :
                              GestureDetector(
                                onTap: () async {
                                  if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                    _dialogforSignIn();
                                  }
                                  else {
                                    (checkskip) ?
                                    Navigator.of(context).pushNamed(
                                      SignupSelectionScreen.routeName,
                                        arguments: {
                                          "prev": "signupSelectionScreen",
                                        }
                                    ) :
                                    Navigator.of(context).pushNamed(
                                        SubscribeScreen.routeName,
                                        arguments: {
                                          "itemid": widget.id,
                                          "itemname": widget.title,
                                          "itemimg": widget.imageUrl,
                                          "varname": varname+unit,
                                          "varmrp":varmrp,
                                          "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
                                          "paymentMode": widget.paymentmode,
                                          "cronTime": widget.cronTime,
                                          "name": widget.name,
                                          "varid": varid.toString(),
                                          "brand": widget.brand
                                        }
                                    );
                                  }

                                },
                                child: Container(
                                    height: 40.0,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 76,
                                    decoration: new BoxDecoration(
                                        border: Border.all(color: Theme
                                            .of(context)
                                            .primaryColor),
                                        color: ColorCodes.whiteColor,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(2.0),
                                          topRight: const Radius.circular(2.0),
                                          bottomLeft: const Radius.circular(2.0),
                                          bottomRight: const Radius.circular(2.0),
                                        )),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Text(
                                              S.of(context).subscribe,//'SUBSCRIBE',
                                              style: TextStyle(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ):SizedBox.shrink(),
                        if(Features.isSubscription)
                          SizedBox(
                            height: 10,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (int.parse(varstock) <= 0) ?
                            GestureDetector(
                              onTap: () async {

                                if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                  Navigator.of(context).pop();
                                  _dialogforSignIn();
                                }
                                else {
                                  if (checkskip) {
                                    Navigator.of(context).pushNamed(
                                      SignupSelectionScreen.routeName,
                                        arguments: {
                                          "prev": "signupSelectionScreen",
                                        }
                                    );
                                    // _notifyMe();
                                  }

                                  else {
                                    setState(() {
                                      _isNotify = true;
                                    });
                                    //_notifyMe();
                                    int resposne = await Provider.of<
                                        BrandItemsList>(context, listen: false)
                                        .notifyMe(widget.id, varid, widget.type);
                                    if (resposne == 200) {
                                      setState(() {
                                        _isNotify = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: S.of(context).you_will_notify,//"You will be notified via SMS/Push notification, when the product is available",
                                          fontSize: MediaQuery
                                              .of(context)
                                              .textScaleFactor * 13,
                                          backgroundColor:
                                          Colors.black87,
                                          textColor: Colors.white);

                                    } else {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).something_went_wrong,//"Something went wrong",
                                          fontSize: MediaQuery
                                              .of(context)
                                              .textScaleFactor * 13,
                                          backgroundColor:
                                          Colors.black87,
                                          textColor: Colors.white);
                                      setState(() {
                                        _isNotify = false;
                                      });
                                    }
                                  }
                                }
                              },
                              child: Container(
                                height: 40.0,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 76,
                                decoration: new BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.grey,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(2.0),
                                      topRight: const Radius.circular(2.0),
                                      bottomLeft: const Radius.circular(2.0),
                                      bottomRight: const Radius.circular(2.0),
                                    )),
                                child:
                                _isNotify ?
                                Center(
                                  child: SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: new CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: new AlwaysStoppedAnimation<
                                            Color>(Colors.white),)),
                                )
                                    :
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Center(
                                        child: Text(
                                          S.of(context).notify_me,//'Notify Me',
                                          /*"ADD",*/
                                          style: TextStyle(
                                            /*fontWeight: FontWeight.w700,*/
                                              color:
                                              Colors
                                                  .white /*Colors.black87*/),
                                          textAlign: TextAlign.center,
                                        )),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: new BorderRadius.only(
                                            topRight:
                                            const Radius.circular(2.0),
                                            bottomRight:
                                            const Radius.circular(2.0),
                                          )),
                                      height: 40,
                                      width: 25,
                                      child: Icon(
                                        Icons.add,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Container(
                              height: 40.0,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 76,
                              child: ValueListenableBuilder(
                                valueListenable:
                                Hive.box<Product>(productBoxName)
                                    .listenable(),
                                builder: (context, Box<Product> box, _) {
                                  /*if (box.values.length <= 0)*/ if(varQty <= 0)
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isAddToCart = true;
                                        });
                                        fas.LogAddtoCart(itemId: varid, itemName: varname+unit, itemCategory: itemvarData[0].menuid, quantity: varQty, amount:double.parse(varprice), value: Cart.ADD);
                                        addToCart(int.parse(varminitem));
                                      },
                                      child: (Features.isSubscription)?
                                      Container(
                                        height: 50.0,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: _isAddToCart ?
                                        Center(
                                          child: SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: new CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                        )
                                            :
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            Center(
                                                child: Text(
                                                  S.of(context).buy_once,//'BUY ONCE',
                                                  style: TextStyle(
                                                    color: ColorCodes.whiteColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ],
                                        )
                                      ):
                                      Container(
                                        height: 50.0,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: _isAddToCart ?
                                        Center(
                                          child: SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: new CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                        )
                                            :
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Center(
                                                child: Text(
                                                  S.of(context).add,//'ADD',
                                                  style: TextStyle(
                                                    color: Theme
                                                        .of(context)
                                                        .buttonColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                            Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                new BorderRadius.only(
                                                  bottomRight:
                                                  const Radius.circular(3),
                                                  topRight:
                                                  const Radius.circular(3),
                                                ),
                                              ),
                                              height: 40,
                                              width: 30,
                                              child: Icon(
                                                Icons.add,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  else
                                    return Container(
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _isAddToCart = true;
                                                incrementToCart(varQty - 1);
                                              });
                                            },
                                            child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: new BoxDecoration(
                                                  border: Border.all(
                                                    color: (Features.isSubscription)?Theme
                                                        .of(context)
                                                        .primaryColor:Theme
                                                        .of(context)
                                                        .primaryColor,
                                                  ),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    bottomLeft:
                                                    const Radius.circular(
                                                        3),
                                                    topLeft:
                                                    const Radius.circular(
                                                        3),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "-",
                                                    textAlign: TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:(Features.isSubscription)?Theme
                                                          .of(context)
                                                          .primaryColor: Theme
                                                          .of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            child: _isAddToCart ?
                                            Container(
                                              decoration: BoxDecoration(
                                                color: (Features.isSubscription)?Theme
                                                    .of(context)
                                                    .primaryColor:Theme
                                                    .of(context)
                                                    .primaryColor,
                                              ),
                                              height: 40,
                                              width: 30,
                                              padding: EdgeInsets.only(
                                                  left: 5.0,
                                                  top: 10.0,
                                                  right: 5.0,
                                                  bottom: 10.0),
                                              child: Center(
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<
                                                          Color>(
                                                          Colors.white),)),
                                              ),
                                            )
                                                :
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: (Features.isSubscription)?Theme
                                                      .of(context)
                                                      .primaryColor:Theme
                                                      .of(context)
                                                      .primaryColor,
                                                ),
                                                height: 40,
                                                width: 30,
                                                child: Center(
                                                  child: Text(
                                                    varQty.toString(),
                                                    textAlign: TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                      color:(Features.isSubscription)?ColorCodes.whiteColor: Colors.white,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (varQty < int.parse(varstock)) {
                                                if (varQty < int.parse(varmaxitem)) {
                                                  setState(() {
                                                    _isAddToCart = true;
                                                  });
                                                  incrementToCart(varQty + 1);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                      fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                      backgroundColor:
                                                      Colors.black87,
                                                      textColor: Colors.white);
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                    backgroundColor:
                                                    Colors.black87,
                                                    textColor: Colors.white);
                                              }
                                            },
                                            child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: new BoxDecoration(
                                                  border: Border.all(
                                                    color: (Features.isSubscription)?Theme
                                                        .of(context)
                                                        .primaryColor:Theme
                                                        .of(context)
                                                        .primaryColor,
                                                  ),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    bottomRight:
                                                    const Radius.circular(
                                                        3),
                                                    topRight:
                                                    const Radius.circular(
                                                        3),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "+",
                                                    textAlign: TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: (Features.isSubscription)?Theme
                                                          .of(context)
                                                          .primaryColor:Theme
                                                          .of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        })
        .then((_) => setState(() {
      variddata.clear();
      variationdisplaydata.clear();
    }));
  }

  Widget showoptions() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return  Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                width: 800,
                //height: 200,
                padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                child: Column(

                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(widget.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),

                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: ()=> Navigator.pop(context),
                              child: Image(
                                height: 40,
                                width: 40,
                                image: AssetImage(Images.bottomsheetcancelImg),color: Colors.black,)),
                        ),
                      ],
                    ),

                    Text(
                      S.of(context).please_select_any_option,//'Please select any one option',
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),

                    //Text(
                    //'Size',
                    //style: TextStyle(color: Theme.of(context).primaryColor,
                    // fontSize: 18, fontWeight: FontWeight.bold),
                    //),

                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      child:  ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: itemvarData.length,
                          itemBuilder: (_, i) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  setState(() {
                                    varid = itemvarData[i].varid;
                                    varname = itemvarData[i].varname;
                                    unit =itemvarData[i].unit;
                                    weight=itemvarData[i].weight;
                                    varmrp = itemvarData[i].varmrp;
                                    varprice = itemvarData[i].varprice;
                                    varmemberprice = itemvarData[i].varmemberprice;
                                    varminitem = itemvarData[i].varminitem;
                                    varmaxitem = itemvarData[i].varmaxitem;
                                    varLoyalty = itemvarData[i].varLoyalty;
                                    varQty = (itemvarData[i].varQty >= 0) ? itemvarData[i].varQty : int.parse(itemvarData[i].varminitem);
                                    varstock = itemvarData[i].varstock;
                                    discountDisplay = itemvarData[i].discountDisplay;
                                    memberpriceDisplay = itemvarData[i].membershipDisplay;

                                    if (_checkmembership) {
                                      if (varmemberprice.toString() == '-' || double.parse(varmemberprice) <= 0) {
                                        if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                                          margins = "0";
                                        } else {
                                          var difference = (double.parse(varmrp) - double.parse(varprice));
                                          var profit = difference / double.parse(varmrp);
                                          margins = profit * 100;

                                          //discount price rounding
                                          margins = num.parse(margins.toStringAsFixed(0));
                                          margins = margins.toString();
                                        }
                                      } else {
                                        var difference = (double.parse(varmrp) - double.parse(varmemberprice));
                                        var profit = difference / double.parse(varmrp);
                                        margins = profit * 100;

                                        //discount price rounding
                                        margins = num.parse(margins.toStringAsFixed(0));
                                        margins = margins.toString();
                                      }
                                    } else {
                                      if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                                        margins = "0";
                                      } else {
                                        var difference = (double.parse(varmrp) - double.parse(varprice));
                                        var profit = difference / double.parse(varmrp);
                                        margins = profit * 100;

                                        //discount price rounding
                                        margins = num.parse(margins.toStringAsFixed(0));
                                        margins = margins.toString();
                                      }
                                    }
                                    if (widget._fromScreen == "home_screen") {
                                      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByfeaturedimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    } else if (widget._fromScreen == "singleproduct_screen") {
                                      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIditemsnewimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    } else if (widget._fromScreen == "Discount") {
                                      multiimage = Provider.of<SellingItemsList>(context, listen: false).findBydiscountimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    } else if (widget._fromScreen == "Offers") {
                                      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByofferimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    } else if (widget._fromScreen == "Forget") {
                                      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByForgotimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    }
                                    else if (widget._fromScreen == "searchitem_screen") {
                                      multiimage = Provider.of<ItemsList>(context, listen: false).findBysearchimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    } else if (widget._fromScreen == "sellingitem_screen") {
                                      multiimage = Provider.of<SellingItemsList>(context, listen: false).findByIdallimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    } else if (widget._fromScreen == "brands_screen") {
                                      multiimage = Provider.of<BrandItemsList>(context, listen: false).findBybrandimage(varid);
                                      _displayimg = multiimage[0].imageUrl;
                                    }
                                    Future.delayed(Duration(seconds: 0), () {
                                      dialogdisplay = true;
                                      for (int j = 0; j < variddata.length; j++) {
                                        if (i == j) {
                                          setState(() {
                                            checkBoxdata[i] = true;
                                            containercolor[i] = ColorCodes.whiteColor;
                                            textcolor[i] = ColorCodes.mediumBlueColor;
                                            iconcolor[i] = ColorCodes.mediumBlueColor;
                                          });
                                        } else {
                                          setState(() {
                                            checkBoxdata[j] = false;
                                            containercolor[i] = ColorCodes.whiteColor;
                                            iconcolor[j] = ColorCodes.lightgrey;
                                            textcolor[j] = ColorCodes.blackColor;
                                          });
                                        }
                                      }

                                      /*if (i == j) {
                                        setState(() {
                                          checkBoxdata[i] = true;
                                          containercolor[i] = ColorCodes.whiteColor;
                                          textcolor[i] = ColorCodes.mediumBlueColor;
                                          iconcolor[i] = ColorCodes.mediumBlueColor;
                                        });
                                      } else {
                                        setState(() {
                                          checkBoxdata[j] = false;
                                          containercolor[j] = ColorCodes.whiteColor;
                                          iconcolor[j] = ColorCodes.lightgrey;
                                          textcolor[j] = ColorCodes.blackColor;
                                        });
                                      }*/
                                    });
                                    // Navigator.of(context).pop(true);
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      _checkmembership
                                          ? //membered usesr
                                      itemvarData[i].membershipDisplay
                                          ? RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: itemvarData[i].varcolor,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: varnamedata[i]+" "+unitdata[i]+ " - ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: textcolor[i],
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: IConstants.currencyFormat + varmemberpricedata[i] + " ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: textcolor[i],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text: IConstants.currencyFormat + varmrpdata[i],
                                                style: TextStyle(
                                                  color: textcolor[i],
                                                  decoration: TextDecoration.lineThrough,
                                                )),
                                          ],
                                        ),
                                      )
                                          : itemvarData[i].discountDisplay
                                          ? RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: itemvarData[i].varcolor,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: varnamedata[i]+" "+unitdata[i] + " - ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: textcolor[i],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: IConstants.currencyFormat + varpricedata[i] + " ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: textcolor[i],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text: IConstants.currencyFormat + varmrpdata[i],
                                                style: TextStyle(
                                                  color: textcolor[i],
                                                  decoration: TextDecoration.lineThrough,
                                                )),
                                          ],
                                        ),
                                      )
                                          : new RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                            color: itemvarData[i].varcolor,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                              text: varnamedata[i]+" "+unitdata[i] + " - ",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: textcolor[i],
                                              ),
                                            ),
                                            new TextSpan(
                                              text:
                                              IConstants.currencyFormat +
                                                  " " +
                                                  varmrpdata[
                                                  i],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: textcolor[i],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : itemvarData[i].discountDisplay
                                          ? RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: itemvarData[i].varcolor,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:varnamedata[i]+" "+unitdata[i]+ " - ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: textcolor[i],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: IConstants.currencyFormat + varpricedata[i] + " ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: textcolor[i],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text: IConstants.currencyFormat + varmrpdata[i],
                                                style: TextStyle(
                                                  color: textcolor[i],
                                                  decoration: TextDecoration.lineThrough,
                                                )),
                                          ],
                                        ),
                                      )
                                          : new RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                            color: itemvarData[i].varcolor,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                              text: varnamedata[i]+" "+unitdata[i]+ " - ",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: textcolor[i],
                                              ),
                                            ),
                                            new TextSpan(
                                              text: IConstants.currencyFormat + " " + varmrpdata[i],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: textcolor[i],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      handler(i),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    // ),
                    //Spacer(),
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        if(Features.isSubscription)
                          (widget.subscribe == "0")?
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (int.parse(varstock) <= 0)  ?
                              SizedBox(height: 40,)
                                  :
                              GestureDetector(
                                onTap: () async {
                                  if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                    _dialogforSignIn();
                                  }
                                  else {
                                    (checkskip) ?
                                    Navigator.of(context).pushNamed(
                                      SignupSelectionScreen.routeName,
                                        arguments: {
                                          "prev": "signupSelectionScreen",
                                        }
                                    ) :
                                    Navigator.of(context).pushNamed(
                                        SubscribeScreen.routeName,
                                        arguments: {
                                          "itemid": widget.id,
                                          "itemname": widget.title,
                                          "itemimg": widget.imageUrl,
                                          "varname": varname+unit,
                                          "varmrp":varmrp,
                                          "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
                                          "paymentMode": widget.paymentmode,
                                          "cronTime": widget.cronTime,
                                          "name": widget.name,
                                          "varid": varid.toString(),
                                          "brand": widget.brand
                                        }
                                    );
                                  }
                                },
                                child: Container(
                                    height: 40.0,
                                    width:(MediaQuery.of(context).size.width / 4) + 15,
                                    decoration: new BoxDecoration(
                                        border: Border.all(color: ColorCodes.primaryColor),
                                        color: ColorCodes.whiteColor,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(2.0),
                                          topRight: const Radius.circular(2.0),
                                          bottomLeft: const Radius.circular(2.0),
                                          bottomRight: const Radius.circular(2.0),
                                        )),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Text(
                                              S.of(context).subscribe,//'SUBSCRIBE',
                                              style: TextStyle(
                                                color: ColorCodes.primaryColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
                                      ],
                                    )
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ):SizedBox.shrink(),
                        if(Features.isSubscription)
                          SizedBox(
                            width: 10,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (int.parse(varstock) <= 0) ?
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  /*setState(() {
                                    _isNotify = true;
                                  });*/
                                  /*setState(() {
                                    _isNotify = true;
                                  });
                                  //_notifyMe();
                                  int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(widget.id,varid,widget.type);
                                  if(resposne == 200) {
                                    Fluttertoast.showToast(msg: "You will be notified via SMS/Push notification, when the product is available" ,
                                        fontSize: MediaQuery.of(context).textScaleFactor *13,
                                        backgroundColor:
                                        Colors.black87,
                                        textColor: Colors.white);
                                    setState(() {
                                      _isNotify = false;
                                    });
                                  } else {
                                    Fluttertoast.showToast(msg: "Something went wrong" ,
                                        fontSize: MediaQuery.of(context).textScaleFactor *13,
                                        backgroundColor:
                                        Colors.black87,
                                        textColor: Colors.white);
                                    setState(() {
                                      _isNotify = false;
                                    });
                                  }*/
                                  if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                    Navigator.of(context).pop();
                                    _dialogforSignIn();
                                  }
                                  else {
                                    if (checkskip) {
                                      Navigator.of(context).pushNamed(
                                        SignupSelectionScreen.routeName,
                                          arguments: {
                                            "prev": "signupSelectionScreen",
                                          }
                                      );
                                      // _notifyMe();
                                    }

                                    else {
                                      setState(() {
                                        _isNotify = true;
                                      });
                                      //_notifyMe();
                                      int resposne = await Provider.of<
                                          BrandItemsList>(context, listen: false)
                                          .notifyMe(widget.id, varid, widget.type);
                                      if (resposne == 200) {
                                        setState(() {
                                          _isNotify = false;
                                        });
                                        /*_isWeb
                                            ? _Toast(
                                            "You will be notified via SMS/Push notification, when the product is available")
                                            :*/
                                        Fluttertoast.showToast(
                                            msg: S.of(context).you_will_notify,//"You will be notified via SMS/Push notification, when the product is available",
                                            fontSize: MediaQuery
                                                .of(context)
                                                .textScaleFactor * 13,
                                            backgroundColor:
                                            Colors.black87,
                                            textColor: Colors.white);

                                      } else {
                                        Fluttertoast.showToast(
                                            msg: S.of(context).something_went_wrong,//"Something went wrong",
                                            fontSize: MediaQuery
                                                .of(context)
                                                .textScaleFactor * 13,
                                            backgroundColor:
                                            Colors.black87,
                                            textColor: Colors.white);
                                        setState(() {
                                          _isNotify = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  height: 40.0,
                                  width:(MediaQuery.of(context).size.width / 4) + 15,
                                  decoration: new BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.grey,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(2.0),
                                        topRight: const Radius.circular(2.0),
                                        bottomLeft: const Radius.circular(2.0),
                                        bottomRight: const Radius.circular(2.0),
                                      )),
                                  child:
                                  _isNotify ?
                                  Center(
                                    child: SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: new CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: new AlwaysStoppedAnimation<
                                              Color>(Colors.white),)),
                                  )
                                      :
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                          child: Text(
                                            S.of(context).notify_me,//'Notify Me',
                                            /*"ADD",*/
                                            style: TextStyle(
                                              /*fontWeight: FontWeight.w700,*/
                                                color:
                                                Colors
                                                    .white /*Colors.black87*/),
                                            textAlign: TextAlign.center,
                                          )),
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: new BorderRadius.only(
                                              topRight:
                                              const Radius.circular(2.0),
                                              bottomRight:
                                              const Radius.circular(2.0),
                                            )),
                                        height: 40,
                                        width: 25,
                                        child: Icon(
                                          Icons.add,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                                : Container(
                              height: 40.0,
                              width:(MediaQuery.of(context).size.width / 4) + 15,
                              /*(MediaQuery.of(context).size.width / 3) + 18,*/
                              child: ValueListenableBuilder(
                                valueListenable:
                                Hive.box<Product>(productBoxName)
                                    .listenable(),
                                builder: (context, Box<Product> box, _) {
                                  /*if (box.values.length <= 0)*/ if(varQty <= 0)
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isAddToCart = true;
                                        });
                                        fas.LogAddtoCart(itemId: itemvarData[0].varid, itemName: itemvarData[0].varname, itemCategory: itemvarData[0].menuid, quantity: itemvarData[0].varQty, amount:double.parse( itemvarData[0].varprice), value: Cart.ADD);

                                            addToCart(int.parse(varminitem));
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color:(Features.isSubscription)?ColorCodes.primaryColor : ColorCodes.greenColor,
                                              borderRadius:
                                              BorderRadius.circular(3),
                                            ),
                                            child: _isAddToCart ?
                                            Center(
                                              child: SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child: new CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor: new AlwaysStoppedAnimation<
                                                        Color>(Colors.white),)),
                                            )
                                                :
                                            (Features.isSubscription)?  Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [

                                                Center(
                                                    child: Text(
                                                      S.of(context).buy_once,//'BUY ONCE',
                                                      style: TextStyle(
                                                        color: ColorCodes.whiteColor,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    )),

                                              ],
                                            ) :
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                    new BorderRadius.only(
                                                      bottomRight:
                                                      const Radius.circular(3),
                                                      topRight:
                                                      const Radius.circular(3),
                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        S.of(context).add,//'ADD',
                                                        style: TextStyle(
                                                          color: Theme
                                                              .of(context)
                                                              .buttonColor,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                ),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                    new BorderRadius.only(
                                                      bottomRight:
                                                      const Radius.circular(3),
                                                      topRight:
                                                      const Radius.circular(3),
                                                    ),
                                                  ),
                                                  height: 40,
                                                  width: 30,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      else
                                        return Container(
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    _isAddToCart = true;
                                                    incrementToCart(varQty - 1);
                                                  });
                                                },
                                                child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: new BoxDecoration(
                                                      border: Border.all(
                                                        color: (Features.isSubscription)?ColorCodes.blackColor :Theme
                                                            .of(context)
                                                            .primaryColor,
                                                      ),
                                                      borderRadius:
                                                      new BorderRadius.only(
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            3),
                                                        topLeft:
                                                        const Radius.circular(
                                                            3),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "-",
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: (Features.isSubscription)?ColorCodes.blackColor :Theme
                                                              .of(context)
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Expanded(
                                                child: _isAddToCart ?
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: (Features.isSubscription)?ColorCodes.subscribeColor :Theme
                                                        .of(context)
                                                        .primaryColor,
                                                  ),
                                                  height: 40,
                                                  width: 30,
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      top: 10.0,
                                                      right: 5.0,
                                                      bottom: 10.0),
                                                  child: Center(
                                                    child: SizedBox(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        child: new CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          valueColor: new AlwaysStoppedAnimation<
                                                              Color>(
                                                              Colors.white),)),
                                                  ),
                                                )
                                                    :
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.greenColor,

                                                    ),
                                                    height: 40,
                                                    width: 30,
                                                    child: Center(
                                                      child: Text(
                                                        varQty.toString(),
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                          color: (Features.isSubscription)?ColorCodes.whiteColor :Colors.white,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (varQty < int.parse(varstock)) {
                                                    if (varQty < int.parse(varmaxitem)) {
                                                      setState(() {
                                                        _isAddToCart = true;
                                                      });
                                                      incrementToCart(varQty + 1);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                          S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                          fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                          backgroundColor:
                                                          Colors.black87,
                                                          textColor: Colors
                                                              .white);
                                                    }
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                        fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                        backgroundColor:
                                                        Colors.black87,
                                                        textColor: Colors.white);
                                                  }
                                                },
                                                child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: new BoxDecoration(
                                                      border: Border.all(
                                                        color: (Features.isSubscription)?ColorCodes.blackColor :Theme
                                                            .of(context)
                                                            .primaryColor,
                                                      ),
                                                      borderRadius:
                                                      new BorderRadius.only(
                                                        bottomRight:
                                                        const Radius.circular(
                                                            3),
                                                        topRight:
                                                        const Radius.circular(
                                                            3),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "+",
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: (Features.isSubscription)?ColorCodes.blackColor :Theme
                                                              .of(context)
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                      ],
                    ),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                );
              });
        })
        .then((_) => setState(() {
      variddata.clear();
      variationdisplaydata.clear();
    }));
  }

  @override
  Widget build(BuildContext context) {
    bool _isStock = false;
    if(!_isLoading)
      _checkMembership();
    itemslistData = Provider.of<ItemsList>(context, listen: false).findByIdExpress();

    if (widget._fromScreen == "home_screen") {
      itemvarData = null;
      itemvarData = Provider.of<SellingItemsList>(
        context,
        listen: false,
      ).findById(widget.id);
    } else if (widget._fromScreen == "singleproduct_screen") {
      itemvarData = null;
      itemvarData = Provider.of<SellingItemsList>(
        context,
        listen: false,
      ).findByIdnew(widget.id);
    } else if (widget._fromScreen == "Discount") {
      itemvarData = null;
      itemvarData = Provider.of<SellingItemsList>(
        context,
        listen: false,
      ).findByIddiscount(widget.id);
    }else if (widget._fromScreen == "Offers") {
      itemvarData = null;
      itemvarData = Provider.of<SellingItemsList>(
        context,
        listen: false,
      ).findByIdoffer(widget.id);
    }  else if (widget._fromScreen == "Forget") {
      itemvarData = null;
      itemvarData = Provider.of<SellingItemsList>(
        context,
        listen: false,
      ).findByIdforget(widget.id);
    }
    else if (widget._fromScreen == "searchitem_screen") {
      itemvarData = null;
      itemvarData = Provider.of<ItemsList>(
        context,
        listen: false,
      ).findByIdsearch(widget.id);
    } else if (widget._fromScreen == "sellingitem_screen") {
      itemvarData = null;
      itemvarData = Provider.of<SellingItemsList>(
        context,
        listen: false,
      ).findByIdall(widget.id);
    } else if (widget._fromScreen == "brands_screen") {
      itemvarData = null;
      variddata = [];
      varnamedata = [];
      unitdata =[];
      weightdata=[];
      varmrpdata = [];
      varpricedata = [];
      varmemberpricedata = [];
      varminitemdata = [];
      varmaxitemdata = [];
      varLoyaltydata = [];
      varQtyData = [];
      varstockdata = [];
      vardiscountdata = [];
      discountDisplaydata = [];
      memberpriceDisplaydata = [];

      checkBoxdata = [];
      containercolor = [];
      textcolor = [];
      iconcolor = [];

      itemvarData = Provider.of<BrandItemsList>(
        context,
        listen: false,
      ).findById(widget.id);
    } else {
      itemvarData = null;
      variddata = [];
      varnamedata = [];
      unitdata =[];
      varmrpdata = [];
      varpricedata = [];
      varmemberpricedata = [];
      varminitemdata = [];
      varmaxitemdata = [];
      varLoyaltydata = [];
      varQtyData = [];
      varstockdata = [];
      vardiscountdata = [];
      discountDisplaydata = [];
      memberpriceDisplaydata = [];

      checkBoxdata = [];
      containercolor = [];
      textcolor = [];
      iconcolor = [];

      itemvarData = Provider.of<ItemsList>(
        context,
        listen: false,
      ).findById(widget.id);
    }
    varlength = itemvarData.length;

    if (varlength > 1) {
      _varlength = true;
      variddata.clear();
      variationdisplaydata.clear();
      for (int i = 0; i < varlength; i++) {
        variddata.add(itemvarData[i].varid);
        variationdisplaydata.add(variddata[i]);
        varnamedata.add(itemvarData[i].varname);
        unitdata.add(itemvarData[i].unit);
        weightdata.add(itemvarData[i].weight);
        varmrpdata.add(itemvarData[i].varmrp);
        varpricedata.add(itemvarData[i].varprice);
        varmemberpricedata.add(itemvarData[i].varmemberprice);
        varminitemdata.add(itemvarData[i].varminitem);
        varmaxitemdata.add(itemvarData[i].varmaxitem);
        varLoyaltydata.add(itemvarData[i].varLoyalty);
        varQtyData.add(itemvarData[i].varQty);
        varstockdata.add(itemvarData[i].varstock);
        discountDisplaydata.add(itemvarData[i].discountDisplay);
        memberpriceDisplaydata.add(itemvarData[i].membershipDisplay);

        if (i == 0) {
          checkBoxdata.add(true);
          containercolor.add(ColorCodes.whiteColor);
          textcolor.add(ColorCodes.mediumBlueColor);
          iconcolor.add(ColorCodes.mediumBlueColor);
        } else {
          checkBoxdata.add(false);
          containercolor.add(ColorCodes.whiteColor);
          textcolor.add(ColorCodes.blackColor);
          iconcolor.add(ColorCodes.lightgrey);
        }
      }
    }

    if (varlength <= 0) {
    } else {
      if (!dialogdisplay) {
        varid = itemvarData[0].varid;
        varcolor = itemvarData[0].varcolor;
        varname = itemvarData[0].varname;
        unit=itemvarData[0].unit;
        weight=itemvarData[0].weight;
        varmrp = itemvarData[0].varmrp;
        varprice = itemvarData[0].varprice;
        varmemberprice = itemvarData[0].varmemberprice;
        varminitem = itemvarData[0].varminitem;
        varmaxitem = itemvarData[0].varmaxitem;
        varLoyalty = itemvarData[0].varLoyalty;
        varQty = itemvarData[0].varQty;
        varstock = itemvarData[0].varstock;
        discountDisplay = itemvarData[0].discountDisplay;
        memberpriceDisplay = itemvarData[0].membershipDisplay;

        if (_checkmembership) {
          if (varmemberprice.toString() == '-' ||
              double.parse(varmemberprice) <= 0) {
            if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
              margins = "0";
            } else {
              var difference = (double.parse(varmrp) - double.parse(varprice));
              var profit = difference / double.parse(varmrp);
              margins = profit * 100;

              //discount price rounding
              margins = num.parse(margins.toStringAsFixed(0));
              margins = margins.toString();
            }
          } else {
            var difference =
            (double.parse(varmrp) - double.parse(varmemberprice));
            var profit = difference / double.parse(varmrp);
            margins = profit * 100;

            //discount price rounding
            margins = num.parse(margins.toStringAsFixed(0));
            margins = margins.toString();
          }
        } else {
          if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
            margins = "0";
          } else {
            var difference = (double.parse(varmrp) - double.parse(varprice));
            var profit = difference / double.parse(varmrp);
            margins = profit * 100;

            //discount price rounding
            margins = num.parse(margins.toStringAsFixed(0));
            margins = margins.toString();
          }
        }
      }
    }

    if (_checkmembership) {
      colorRight = 0xffffffff;
      colorLeft = 0xffffffff;
    } else {
      if (varmemberprice == '-' || varmemberprice == "0") {
        setState(() {
          //membershipdisplay = false;
          colorRight = 0xffffffff;
          colorLeft = 0xffffffff;
        });
      } else {
        //membershipdisplay = true;
        colorRight = 0xff3d8d3c;
        colorLeft = 0xff8abb50;
      }
    }

    if (margins == "NaN") {
      _checkmargin = false;
    } else {
      if (int.parse(margins??"0") <= 0) {
        _checkmargin = false;
      } else {
        _checkmargin = true;
      }
    }

    if (int.parse(varstock??"0") <= 0) {
      _isStock = false;
    } else {
      _isStock = true;
    }
    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    _bloc.setFeaturedItem(sellingitemData);
    return Expanded(
      child: Container(
        width: 208.0,
        //height: MediaQuery.of(context).size.height,//aaaaaaaaaaaaaaaaaa
        child: (!_isLoading) ?Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 2.0, bottom: 5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              //border: Border.all(color: Colors.black26),
              boxShadow: [
                BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.50)),
              ],
              borderRadius: new BorderRadius.only(
                topRight: const Radius.circular(2.0),
                topLeft: const Radius.circular(2.0),
                bottomLeft: const Radius.circular(2.0),
                bottomRight: const Radius.circular(2.0),
              )),
          child:  Column(
            children: <Widget>[

              _checkmargin
                  ? Column(
                children: [
                  SizedBox(height: 8,),
                  Consumer<CartCalculations>(
                      builder: (_, cart, ch) => Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: BadgeDiscount(
                              child: ch,
                              value: margins,
                            ),
                          ),
                          if(Features.isExpressDelivery && widget.eligibleforexpress == "0")
                          Align(
                            alignment: Alignment.topRight,
                            child:  Image.asset(Images.express,
                              height: 20.0,
                              width: 25.0,),
                          )
                        ],
                      ),

                      child: !_isStock
                          ? Consumer<CartCalculations>(
                        builder: (_, cart, ch) => BadgeOfStock(
                          child: ch,
                          value: margins,
                          singleproduct: false,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child:MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SingleproductScreen.routeName,
                                    arguments: {
                                      "itemid": widget.id,
                                      "itemname": widget.title,
                                      "itemimg": widget.imageUrl,
                                      "eligibleforexpress": widget.eligibleforexpress,
                                      "delivery": widget.delivery,
                                      "duration": widget.duration,
                                      "durationType":widget.durationType,
                                      "note":widget.note,
                                      "fromScreen":widget._fromScreen,
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: CachedNetworkImage(
                                  imageUrl: /*widget.imageUrl*/multiimage[0].imageUrl,
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                  placeholder: (context, url) =>
                                      Image.asset(
                                        Images.defaultProductImg,
                                        width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                        height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      ),
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                               //   fit: BoxFit.fill,
                                ),
                              ),

                            ),
                          ),
                        ),
                      )
                          : Align(
                        alignment: Alignment.center,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  SingleproductScreen.routeName,
                                  arguments: {
                                    "itemid": widget.id,
                                    "itemname": widget.title,
                                    "itemimg": widget.imageUrl,
                                    "eligibleforexpress": widget.eligibleforexpress,
                                    "delivery": widget.delivery,
                                    "duration": widget.duration,
                                    "durationType":widget.durationType,
                                    "note":widget.note,
                                    "fromScreen":widget._fromScreen,
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: CachedNetworkImage(
                                imageUrl: /*widget.imageUrl*/multiimage[0].imageUrl,
                                errorWidget: (context, url, error) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 110 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                placeholder: (context, url) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 110 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                width: ResponsiveLayout.isSmallScreen(context) ? 110 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                //fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              )
                  : !_isStock
                  ? Column(
                children: [
                  SizedBox(height: 8,),
                  Consumer<CartCalculations>(
                    builder: (_, cart, ch) => BadgeOfStock(
                      child: ch,
                      value: margins,
                      singleproduct: false,
                    ),
                    child: Row(
                      children: [
                        if(Features.isExpressDelivery && widget.eligibleforexpress == "0")
                          Align(
                            alignment: Alignment.topRight,
                            child:  Image.asset(Images.express,
                              height: 20.0,
                              width: 25.0,),
                          ),
                        Align(
                          alignment: Alignment.center,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SingleproductScreen.routeName,
                                    arguments: {
                                      "itemid": widget.id,
                                      "itemname": widget.title,
                                      "itemimg": widget.imageUrl,
                                      "eligibleforexpress": widget.eligibleforexpress,
                                      "delivery": widget.delivery,
                                      "duration": widget.duration,
                                      "durationType":widget.durationType,
                                      "note":widget.note,
                                      "fromScreen":widget._fromScreen,
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.imageUrl,
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                  placeholder: (context, url) => Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                //  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                    children: [
                    //  SizedBox(height: 8,),
                      Stack(
                        children: [

                          if(Features.isExpressDelivery && widget.eligibleforexpress == "0")
                            Align(
                              alignment: Alignment.topRight,
                              child:  Image.asset(Images.express,
                                height: 20.0,
                                width: 25.0,),
                            ),
                          Align(
                          alignment: Alignment.center,
                          child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  SingleproductScreen.routeName,
                                  arguments: {
                                    "itemid": widget.id,
                                    "itemname": widget.title,
                                    "itemimg": widget.imageUrl,
                                    "eligibleforexpress": widget.eligibleforexpress,
                                    "delivery": widget.delivery,
                                    "duration": widget.duration,
                                    "durationType":widget.durationType,
                                    "note":widget.note,
                                    "fromScreen":widget._fromScreen,
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                errorWidget: (context, url, error) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                placeholder: (context, url) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              //  fit: BoxFit.fill,
                              ),
                            ),
                          ),
                ),
              ),
                        ],
                      ),
                    ],
                  ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget.brand,
                      style: TextStyle(
                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: Text(

                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                        TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              // Spacer(),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<Product>(productBoxName).listenable(),
                    builder: (context, Box<Product> box, index) {
                      if(PrefUtils.prefs.getString("membership") == "1"){
                        _checkmembership = true;
                      } else {
                        _checkmembership = false;
                        for (int i = 0; i < productBox.length; i++) {
                          if (productBox.values.elementAt(i).mode == 1) {
                            _checkmembership = true;
                          }
                        }
                      }
                      return _checkmembership
                          ? Row(
                        children: <Widget>[
                          if(Features.isMembership)
                          Container(
                            width: 10.0,
                            height: 9.0,
                            margin: EdgeInsets.only(right: 3.0),
                            child: Image.asset(
                              Images.starImg,
                              color: ColorCodes.starColor,
                            ),
                          ),
                          memberpriceDisplay
                              ? new RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                new TextSpan(
                                    text:
                                    //S.of(context).membership_price//"Membership Price "
                                         IConstants.currencyFormat +
                                        varmemberprice,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                new TextSpan(
                                    text: IConstants.currencyFormat + '$varmrp ',
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration.lineThrough,
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                              ],
                            ),
                          )
                              : discountDisplay
                              ? new RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: IConstants.currencyFormat +
                                        '$varprice ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                new TextSpan(
                                    text: IConstants.currencyFormat +
                                        '$varmrp ',
                                    style: TextStyle(
                                      decoration: TextDecoration
                                          .lineThrough,
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                              ],
                            ),
                          )
                              : new RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: IConstants.currencyFormat +
                                        '$varmrp ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                              ],
                            ),
                          )
                        ],
                      )
                          : discountDisplay
                          ? new RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: IConstants.currencyFormat + '$varprice ',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                            new TextSpan(
                                text: IConstants.currencyFormat + '$varmrp ',
                                style: TextStyle(
                                  decoration:
                                  TextDecoration.lineThrough,
                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                          ],
                        ),
                      )
                          : new RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: IConstants.currencyFormat + '$varmrp ',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                          ],
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  if(Features.isLoyalty)
                  if(double.parse(varLoyalty.toString()) > 0)
                    Container(
                      child: Row(
                        children: [
                          Image.asset(Images.coinImg,
                            height: 15.0,
                            width: 20.0,),
                          SizedBox(width: 4),
                          Text(varLoyalty.toString()),
                        ],
                      ),
                    ),
                  SizedBox(width: 10)
                ],
              ),
              SizedBox(
                height: 8,
              ),
              _varlength
                  ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    (_isWeb && !ResponsiveLayout.isSmallScreen(context))? showoptions(): showoptions1();
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                             // border: Border.all(color: ColorCodes.greenColor),
                            color: ColorCodes.varcolor,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                bottomLeft: const Radius.circular(2.0),
                              )),
                          height: 30,
                          padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                          child: Text(
                            "$varname"+" "+"$unit",
                            style: TextStyle(color: ColorCodes.darkgreen/*Colors.black*/,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: ColorCodes.varcolor,
                            borderRadius: new BorderRadius.only(
                              topRight: const Radius.circular(2.0),
                              bottomRight: const Radius.circular(2.0),
                            )),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: ColorCodes.darkgreen,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              )
                  : Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorCodes.varcolor,
                         // border: Border.all(color: ColorCodes.greenColor),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(2.0),
                            topRight: const Radius.circular(2.0),
                            bottomLeft: const Radius.circular(2.0),
                            bottomRight: const Radius.circular(2.0),
                          )),
                      height: 30,
                      padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                      child: Text(
                        "$varname"+" "+"$unit",
                        style: TextStyle(color:ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(height: 5),

              (Features.isSubscription)?(widget.subscribe == "0")?MouseRegion(
                cursor: SystemMouseCursors.click,
                child: (int.parse(varstock) <= 0) ?
                SizedBox(height: 30,)
                    :GestureDetector(
                  onTap: () {
                    if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      _dialogforSignIn();
                    }
                    else {
                      (checkskip) ?
                      Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                          arguments: {
                            "prev": "signupSelectionScreen",
                          }
                      ) :

                      Navigator.of(context).pushNamed(
                          SubscribeScreen.routeName,
                          arguments: {
                            "itemid": widget.id,
                            "itemname": widget.title,
                            "itemimg": widget.imageUrl,
                            "varname": varname+unit,
                            "varmrp":varmrp,
                            "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
                            "paymentMode": widget.paymentmode,
                            "cronTime": widget.cronTime,
                            "name": widget.name,
                            "varid": varid.toString(),
                            "brand": widget.brand
                          }
                      );
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 30.0,
                          decoration: new BoxDecoration(
                              color: ColorCodes.whiteColor,
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight:
                                const Radius.circular(2.0),
                                bottomLeft:
                                const Radius.circular(2.0),
                                bottomRight:
                                const Radius.circular(2.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text(
                                S.of(context).subscribe,//'SUBSCRIBE',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ) ,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ):SizedBox(height: 30,):SizedBox.shrink(),
              SizedBox(
                height: 8,
              ),
              _isStock
                  ? StreamBuilder<SellingItemsList>(
                stream: _bloc.featuredItem,
                builder: (BuildContext context, AsyncSnapshot<SellingItemsList> snap) {
                  final item = snap.data;
                  if (item == null) {
                    return SizedBox(height: 0);
                  }

                  int itemCount = 0;
                  for(int i = 0; i < item.featuredVariation.length; i++) {
                    if(item.featuredVariation[i].varid == varid) {
                      itemCount = item.featuredVariation[i].varQty;
                      /*varQty = itemCount;
                      _bloc.setFeaturedItem(item);*/
                      break;
                    }
                  }
                  for(int i = 0; i < item.itemspricevarOffer.length; i++) {
                    if(item.itemspricevarOffer[i].varid == varid) {
                      itemCount = item.itemspricevarOffer[i].varQty;
                      /*varQty = itemCount;
                      _bloc.setFeaturedItem(item);*/
                      break;
                    }
                  }
                  for(int i = 0; i < item.itemspricevarSwap.length; i++) {
                    if(item.itemspricevarSwap[i].varid == varid) {
                      itemCount = item.itemspricevarSwap[i].varQty;
                      /*varQty = itemCount;
                      _bloc.setFeaturedItem(item);*/
                      break;
                    }
                  }
                  for(int i = 0; i < item.discountedVariation.length; i++) {
                    if(item.discountedVariation[i].varid == varid) {
                      itemCount = item.discountedVariation[i].varQty;
                      /*varQty = itemCount;
                      _bloc.setFeaturedItem(item);*/
                      break;
                    }
                  }
                  for(int i = 0; i < item.recentVariation.length; i++) {
                    if(item.recentVariation[i].varid == varid) {
                      itemCount = item.recentVariation[i].varQty;
                      /*varQty = itemCount;
                      _bloc.setFeaturedItem(item);*/
                      break;
                    }
                  }
                  for(int i = 0; i < item.forgetVariation.length; i++) {
                    if(item.forgetVariation[i].varid == varid) {
                      itemCount = item.forgetVariation[i].varQty;
                      /*varQty = itemCount;
                      _bloc.setFeaturedItem(item);*/
                      break;
                    }
                  }
                  varQty = itemCount;
                  _bloc.setFeaturedItem(item);


                  /*if (box.values.length <= 0)*/ if(itemCount <= 0)
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAddToCart = true;
                          });
                          fas.LogAddtoCart(itemId: itemvarData[0].varid, itemName: itemvarData[0].varname, itemCategory: itemvarData[0].menuid, quantity: itemvarData[0].varQty, amount:double.parse( itemvarData[0].varprice), value: Cart.ADD);

                          addToCart(int.parse(varminitem));
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: (Features.isSubscription)?40.0:30.0,
                                decoration: new BoxDecoration(
                                    color: (Features.isSubscription)?/*ColorCodes.subscribeColor*/Theme.of(context).primaryColor :ColorCodes.greenColor,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(2.0),
                                      topRight:
                                      const Radius.circular(2.0),
                                      bottomLeft:
                                      const Radius.circular(2.0),
                                      bottomRight:
                                      const Radius.circular(2.0),
                                    )),
                                child: _isAddToCart ?
                                Center(
                                  child: SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: new CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                )
                                    :  (Features.isSubscription)?Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Center(
                                      child: Text(
                                        S.of(context).buy_once,//'BUY ONCE',
                                        style: TextStyle(
                                            color: ColorCodes.whiteColor,
                                            fontSize: 12, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ) :
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      S.of(context).add,//'ADD',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .buttonColor,
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                          color:ColorCodes.cartgreenColor,
                                          borderRadius:
                                          new BorderRadius.only(
                                            topLeft:
                                            const Radius.circular(
                                                2.0),
                                            bottomLeft:
                                            const Radius.circular(
                                                2.0),
                                            topRight:
                                            const Radius.circular(
                                                2.0),
                                            bottomRight:
                                            const Radius.circular(
                                                2.0),
                                          )),
                                      height: 30,
                                      width: 25,
                                      child: Icon(
                                        Icons.add,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  else
                    return Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isAddToCart = true;
                                  incrementToCart(varQty - 1);
                                });
                              },
                              child: Container(
                                  width: 40,
                                  height: (Features.isSubscription)?40:30,
                                  decoration: new BoxDecoration(
                                      color: (Features.isSubscription)?/*ColorCodes.subscribeColor*/ Theme.of(context).primaryColor:ColorCodes.greenColor,
                                      borderRadius: new BorderRadius.only(
                                        topLeft:
                                        const Radius.circular(2.0),
                                        bottomLeft:
                                        const Radius.circular(2.0),
                                      )),
                                  child: Center(
                                    child: Text(
                                      "-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:(Features.isSubscription)?ColorCodes.whiteColor:
                                        Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Spacer(),
                          _isAddToCart ?
                          Center(
                            child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
                          )
                              :
                          Container(
//                                width: 40,
                              height: (Features.isSubscription)?40:30,
                              child: Center(
                                  child: /*Text(varQty.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorCodes.greenColor,
                                      ),
                                    )*/Text(itemCount.toString()/*+" "+unit.toString()*/,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: (Features.isSubscription)?Theme.of(context).primaryColor:ColorCodes.greenColor,
                                    ),
                                  )
                              )),
                          Spacer(),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (varQty < int.parse(varstock)) {
                                  if (varQty < int.parse(varmaxitem)) {
                                    setState(() {
                                      _isAddToCart = true;
                                    });
                                    incrementToCart(varQty + 1);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                        S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                        fontSize: MediaQuery.of(context).textScaleFactor *13,
                                        backgroundColor: Colors.black87,
                                        textColor: Colors.white);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                      fontSize: MediaQuery.of(context).textScaleFactor *13,
                                      backgroundColor: Colors.black87,
                                      textColor: Colors.white);
                                }
                              },
                              child: Container(
                                  width: 40,
                                  height:(Features.isSubscription)?40:30,
                                  decoration: new BoxDecoration(
                                      color:(Features.isSubscription)?/*ColorCodes.subscribeColor*/Theme.of(context).primaryColor :ColorCodes.greenColor,
                                      borderRadius: new BorderRadius.only(
                                        topRight:
                                        const Radius.circular(2.0),
                                        bottomRight:
                                        const Radius.circular(2.0),
                                      )),
                                  child: Center(
                                    child: Text(
                                      "+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:(Features.isSubscription)?ColorCodes.whiteColor:
                                        Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    );
                },
              )
                  : MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    /*setState(() {
                      _isNotify = true;
                    });
                    _notifyMe();*/
                    if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      _dialogforSignIn();
                    }
                    else {
                      (checkskip ) ?
                      Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                          arguments: {
                            "prev": "signupSelectionScreen",
                          }
                      ) :
                      _notifyMe();
                    }
                    // Fluttertoast.showToast(
                    //     msg: "You will be notified via SMS/Push notification, when the product is available" ,
                    //     /*"Out Of Stock",*/
                    //     fontSize: 12.0,
                    //     backgroundColor: Colors.black87,
                    //     textColor: Colors.white);
                  },
                  child: (Features.isSubscription)?
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 40.0,
//                      width: MediaQuery.of(context).size.width,

                          decoration: new BoxDecoration(
                              color: Colors.grey,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                                bottomLeft: const Radius.circular(2.0),
                                bottomRight: const Radius.circular(2.0),
                              )),
                          child:
                          _isNotify ?
                          Center(
                            child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: new AlwaysStoppedAnimation<
                                      Color>(Colors.white),)),
                          )
                              :
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                S.of(context).notify_me,//'Notify Me',
                                /*'ADD',*/
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                    fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: new BorderRadius.only(
                                      topRight: const Radius.circular(2.0),
                                      bottomRight:
                                      const Radius.circular(2.0),
                                    )),
                                height: 40,
                                width: 25,
                                child: Icon(
                                  Icons.add,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )
                  :Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 30.0,
//                      width: MediaQuery.of(context).size.width,

                          decoration: new BoxDecoration(
                              color: Colors.grey,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                                bottomLeft: const Radius.circular(2.0),
                                bottomRight: const Radius.circular(2.0),
                              )),
                          child:
                          _isNotify ?
                          Center(
                            child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: new AlwaysStoppedAnimation<
                                      Color>(Colors.white),)),
                          )
                              :
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                S.of(context).notify_me, //'Notify Me',
                                /*'ADD',*/
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                    fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: new BorderRadius.only(
                                      topRight: const Radius.circular(2.0),
                                      bottomRight:
                                      const Radius.circular(2.0),
                                    )),
                                height: 30,
                                width: 25,
                                child: Icon(
                                  Icons.add,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              ),
              (memberpriceDisplay)?
              (Features.isSubscription)? SizedBox(height: 13):SizedBox(height: 5): Spacer(),
              if(memberpriceDisplay) Spacer(),
              ValueListenableBuilder(
                valueListenable: Hive.box<Product>(productBoxName).listenable(),
                builder: (context, Box<Product> box, index) {
                  if(PrefUtils.prefs.getString("membership") == "1"){
                    _checkmembership = true;
                  } else {
                    _checkmembership = false;
                    for (int i = 0; i < productBox.length; i++) {
                      if (productBox.values.elementAt(i).mode == 1) {
                        _checkmembership = true;
                      }
                    }
                  }
                  return Column(
                    children: [
                      if(Features.isMembership)
                        Row(
                          children: <Widget>[
                            !_checkmembership
                                ? memberpriceDisplay
                                ? GestureDetector(
                              onTap: () {
                                (checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                _dialogforSignIn() :
                                (checkskip && !_isWeb)?
                                Navigator.of(context).pushReplacementNamed(
                                    SignupSelectionScreen.routeName)
                                    :Navigator.of(context).pushNamed(
                                  MembershipScreen.routeName,
                                );
                              },
                              child: Container(
                                height: 25,
                                width: 193,
                                decoration:
                                BoxDecoration(color: ColorCodes.membershipColor),
                                child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    Image.asset(
                                      Images.starImg,
                                      width: 12,
                                      height: 11,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                        // S.of(context).membership_price//"Membership Price "
                                             IConstants.currencyFormat +
                                            varmemberprice,
                                        style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            )
                                : SizedBox.shrink()
                                : SizedBox.shrink(),
                          ],
                        ),
                      !_checkmembership
                          ? memberpriceDisplay
                          ? SizedBox(
                        height:( _isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                      )
                          : SizedBox(
                        height:( _isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                      )
                          : SizedBox(
                        height:( _isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ): SingelItemOfList(),
      ),
    );
  }

}

