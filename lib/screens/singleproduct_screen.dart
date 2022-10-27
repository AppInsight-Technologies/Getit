import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/sellingitemsfields.dart';
import '../../providers/myorderitems.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../screens/shoppinglist_screen.dart';
import '../../screens/wishlist_screen.dart';
import '../../widgets/components/color.widget.dart';
import '../../widgets/components/item_component.dart';
import '../../widgets/components/login_web.dart';
import '../../widgets/flutter_flow/flutter_flow_theme.dart';
import '../../widgets/simmers/item_list_shimmer.dart';
import '../../widgets/simmers/singel_item_of_list_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../widgets/bottom_navigation.dart';
import '../generated/l10n.dart';
import '../widgets/components/varint_widget.dart';
import '../screens/items_screen.dart';
import '../screens/sellingitem_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../screens/subscribe_screen.dart';
import 'package:intl/intl.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../services/firebaseAnaliticsService.dart';
import '../widgets/simmers/singel_item_screen_shimmer.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/singleproductimage_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/searchitem_screen.dart';
import '../providers/itemslist.dart';
import '../providers/sellingitems.dart';
import '../providers/branditems.dart';
import '../providers/cartItems.dart';
import '../constants/IConstants.dart';
import '../widgets/badge_ofstock.dart';
import '../data/calculations.dart';
import '../widgets/badge.dart';
import '../widgets/items.dart';
import '../assets/images.dart';
import '../main.dart';
import '../widgets/header.dart';
import '../utils/prefUtils.dart';
import '../screens/home_screen.dart';
import '../constants/features.dart';
import '../assets/ColorCodes.dart';
import '../data/hiveDB.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/badge_discount.dart';
import '../widgets/footer.dart';
import '../screens/map_screen.dart';
import '../screens/bloc.dart';

import 'dart:async';
import 'dart:convert';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/policy_screen.dart';
import 'package:http/http.dart' as http;
import 'brands_screen.dart';
import 'package:collection/collection.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class SingleproductScreen extends StatefulWidget {
  static const routeName = '/singleproduct-screen';

  @override
  _SingleproductScreenState createState() => _SingleproductScreenState();
}


class _SingleproductScreenState extends State<SingleproductScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  var singleitemData;
  List<SellingItemsFields> singleitemvar=[];
  var multiimage;
  bool _isWeb = false;
  bool _isIOS = false;
  bool _checkmembership = false;
  var _checkmargin = true;
  var margins;
  bool _isStock = false;
  var shoplistData;
  String dropdownValue = 'One';

  AnimationController _ColorAnimationController;
  AnimationController _TextAnimationController;
  Animation _colorTween, _iconColorTween;
  Animation<Offset> _transTween;

  String varmemberprice;
  String varprice;
  String varmrp;
  String varid;
  String varname;
  String unit;
  String color;
  String fit;
  String vsize;
  String varstock;
  String varminitem;
  String varmaxitem;
  int varLoyalty;
  String type;
  String veg_type;
  int _varQty;
  bool discountDisplay;
  bool memberpriceDisplay;
  Color varcolor;
  bool _isDelivering = false;
  String itemname = "";
  String itemimg = "";
  String itemdescription = "";
  String itemmanufact = "";
  bool _isdescription = false;
  bool _ismanufacturer = false;
  String _displayimg = "";
  bool _similarProduct = false;
  String _deliverlocation = "";
  final _form = GlobalKey<FormState>();
  List<String> _varMarginList = List<String>();
  final _key = GlobalKey<FormState>();

  List<Tab> tabList = List();
  TabController _tabController;

  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool _isAddToCart = false;
  HomeDisplayBloc _bloc;
  bool iphonex = false;
  var currentDate;
  bool _isNotify = false;
  var itemid;
  var fromScreen;
  var seeallpress;
  var notificationFor;
  bool checkskip = false;
  var mobilenum = "";
  String name = "";
  String phone = "";
  String apple = "";
  String email = "";
  String mobile = "";
  String tokenid = "";
  String countryName = "India";
  String photourl = "";


  bool _isAvailable = false;
  bool _isSkip = false;
  String _deliverLocation = "";
  bool _isUnreadNot = false;
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
  var _showCall = false;
  var deliveryslotData;
  var delChargeData;
  var timeslotsData;
  var timeslotsindex = "0";
  var otpvalue = "";

  String otp1, otp2, otp3, otp4;

  bool _isChangeAddress = false;
  bool _slotsLoading = false;
  var _checkslots = false;
  var day, date, time = "10 AM - 1 PM";
  bool _loadingSlots = true;
  bool _loadingDelCharge = true;

  bool _loading = true;
  var _checkaddress = false;
  var addtype;
  var address;
  IconData addressicon;
  DateTime pickedDate;
  GroceStore store = VxState.store;

  Future<ItemModle> _preduct;
  Map<String,List<SellingItemsFields>> size;
  Map<String,List<SellingItemsFields>> colorgroup;
  bool isSelect = false;
  bool showcolor = false;
  int sizeIndex;
  int colorindex = 0;
  bool _isColorSelect = false;

  List<CartItem> productBox = [];
  @override
  void initState() {
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Color(0xFFffffff))
        .animate(_ColorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.grey, end: Colors.white)
        .animate(_ColorAnimationController);


    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_TextAnimationController);

    _bloc = HomeDisplayBloc();
    _events = new StreamController<int>.broadcast();
    _events.add(30);
    productBox =(VxState.store as GroceStore).CartItemList;
    if (_isdescription)
      tabList.add(new Tab(
        text: 'Description',
      ));
    if (_ismanufacturer)
      tabList.add(new Tab(
        text: 'Manufacturer Details',
      ));
    _tabController = new TabController(
      vsync: this,
      length: tabList.length,
    );
//    _tabController = new TabController(vsync: this,length: 2,);
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            _isIOS = true;
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
      // setState(() {
      //   if(PrefUtils.prefs.containsKey("apikey")) {
      //     checkskip = true;
      //   } else {
      //     checkskip = false;
      //   }
      // });
      checkskip = !PrefUtils.prefs.containsKey('apikey');

      if(PrefUtils.prefs.getString("referCodeDynamic") == "" || PrefUtils.prefs.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs.getString("referCodeDynamic");
      }

      Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((value) {
        final shoplistData = Provider.of<BrandItemsList>(context, listen: false);
      });
      //prefs = await SharedPreferences.getInstance();
      setState(() {
        if (PrefUtils.prefs.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }

      });

      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _deliverlocation = PrefUtils.prefs.getString("deliverylocation");
       itemid = routeArgs['itemid'];
       fromScreen = routeArgs['fromScreen'];
       seeallpress=routeArgs['seeallpress'];
        notificationFor = routeArgs['notificationFor'];
      _preduct = ProductRepo().getRecentProduct(routeArgs['itemid'].toString());
      await Provider.of<ItemsList>(context, listen: false).fetchSingleItems(itemid,notificationFor).then((_) {
        setState(() {

          Provider.of<SellingItemsList>(context, listen: false)
              .fetchNewItems(routeArgs['itemid'].toString())
              .then((_) {
                setState(() {
              _isLoading = false;
              singleitemData = Provider.of<ItemsList>(context, listen: false);
              singleitemvar = Provider.of<ItemsList>(context, listen: false).findByIdsingleitems(itemid,notificationFor);
              varmemberprice = singleitemvar[0].varmemberprice;
              varmrp = singleitemvar[0].varmrp;
              fas.LogItemSelected(contentType: singleitemvar[0].varname, itemId: routeArgs['itemid']);
              varprice = singleitemvar[0].varprice;
              vsize = singleitemvar[0].size;
              varid = singleitemvar[0].varid;
              varname = singleitemvar[0].varname;
              unit=singleitemvar[0].unit;
              color = singleitemvar[0].color;
              fit = singleitemvar[0].fit;
              varstock = singleitemvar[0].varstock;
              varminitem = singleitemvar[0].varminitem;
              varmaxitem = singleitemvar[0].varmaxitem;
              varLoyalty = singleitemvar[0].varLoyalty;
              _varQty = singleitemvar[0].varQty;
              varcolor = singleitemvar[0].varcolor;
              discountDisplay = singleitemvar[0].discountDisplay;
              memberpriceDisplay = singleitemvar[0].membershipDisplay;

              /*if (varmemberprice == '-' || varmemberprice == "0") {
                setState(() {
                  membershipdisplay = false;
                });
              } else {
                membershipdisplay = true;
              }*/
              if(singleitemData.singleitems[0].wishlist ==1) {
                isSelect = true;
              } else {
                isSelect = false;
              }
              for(int i = 0; i < singleitemvar.length; i ++) {
                if (_checkmembership) {
                  if (singleitemvar[i].varmemberprice.toString() == '-' || double.parse(singleitemvar[i].varmemberprice) <= 0) {
                    if (double.parse(singleitemvar[i].varmrp) <= 0 ||
                        double.parse(singleitemvar[i].varprice) <= 0) {
                      _varMarginList.add("0");
                    } else {
                      var difference = (double.parse(singleitemvar[i].varmrp) - double.parse(singleitemvar[i].varprice));
                      var profit = difference / double.parse(singleitemvar[i].varmrp);
                      var margins;
                      margins = profit * 100;

                      //discount price rounding
                      margins = num.parse(margins.toStringAsFixed(0));
                      _varMarginList.add(margins.toString());
                    }
                  } else {
                    var difference =
                    (double.parse(singleitemvar[i].varmrp) - double.parse(singleitemvar[i].varmemberprice));
                    var profit = difference / double.parse(singleitemvar[i].varmrp);
                    var margins;
                    margins = profit * 100;

                    //discount price rounding
                    margins = num.parse(margins.toStringAsFixed(0));
                    _varMarginList.add(margins.toString());
                  }
                } else {
                  if (double.parse(singleitemvar[i].varmrp) <= 0 || double.parse(singleitemvar[i].varprice) <= 0) {
                    margins = "0";
                  } else {
                    var difference =
                    (double.parse(singleitemvar[i].varmrp) - double.parse(singleitemvar[i].varprice));
                    var profit = difference / double.parse(singleitemvar[i].varmrp);
                    var margins;
                    margins = profit * 100;

                    //discount price rounding
                    margins = num.parse(margins.toStringAsFixed(0));
                    _varMarginList.add(margins.toString());
                  }
                }
              }

              if (_checkmembership) {
                if (varmemberprice.toString() == '-' ||
                    double.parse(varmemberprice) <= 0) {
                  if (double.parse(varmrp) <= 0 ||
                      double.parse(varprice) <= 0) {
                    margins = "0";
                  } else {
                    var difference =
                    (double.parse(varmrp) - double.parse(varprice));
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
                  var difference =
                  (double.parse(varmrp) - double.parse(varprice));
                  var profit = difference / double.parse(varmrp);
                  margins = profit * 100;

                  //discount price rounding
                  margins = num.parse(margins.toStringAsFixed(0));
                  margins = margins.toString();
                }
              }

              /*              if(double.parse(varprice) <= 0 || varprice.toString() == "" || double.parse(varprice) == double.parse(varmrp)){
                discountedPriceDisplay = false;
              } else {
                discountedPriceDisplay = true;
              }*/

              if (margins == "NaN") {
                _checkmargin = false;
              } else {
                if (int.parse(margins) <= 0) {
                  _checkmargin = false;
                } else {
                  _checkmargin = true;
                }
              }

              if (int.parse(varstock) <= 0) {
                _isStock = false;
              } else {
                _isStock = true;
              }

              itemname = singleitemData.singleitems[0].title;
              itemimg = singleitemData.singleitems[0].imageUrl;
              veg_type = singleitemData.singleitems[0].veg_type;
              type = singleitemData.singleitems[0].type;

              if (singleitemData.singleitems[0].description.toString() != "null" &&
                  singleitemData.singleitems[0].description.toString().length > 0) {
                itemdescription = singleitemData.singleitems[0].description;
                _isdescription = true;
              }
              if (singleitemData.singleitems[0].manufacturedesc.toString() != "null" &&
                  singleitemData.singleitems[0].manufacturedesc.toString().length > 0) {
                itemmanufact = singleitemData.singleitems[0].manufacturedesc;
                _ismanufacturer = true;
              }

              if(_isdescription)
                tabList.add(new Tab(
                  text: 'Product Description',
                ));

              if(_ismanufacturer)
                tabList.add(new Tab(
                  text: 'Manufacturer Details',
                ));

              _tabController = new TabController(
                vsync: this,
                length: tabList.length,
              );

              multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
              _displayimg = multiimage[0].imageUrl;

            });
          });
        });
      });
      final now = new DateTime.now();
      currentDate = DateFormat('dd/MM/y').format(now);
    });
//    _tabController = new TabController(vsync: this,length: 2,);
    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);

      _TextAnimationController.animateTo(
          (scrollInfo.metrics.pixels - 350) / 50);
      return true;
    }
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _NotifyMe() async{
    setState(() {
      _isNotify = true;
    });
    //_notifyMe();
    int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(itemid,varid,type);
    if(resposne == 200) {

      _isWeb?_Toast(S.current.you_will_notify):
      Fluttertoast.showToast(msg: S.current.you_will_notify ,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor:
          Colors.black87,
          textColor: Colors.white);
      setState(() {
        _isNotify = false;
      });
    } else {
      Fluttertoast.showToast(msg: S.current.something_went_wrong ,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor:
          Colors.black87,
          textColor: Colors.white);
      setState(() {
        _isNotify = false;
      });
    }
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
                  ModalRoute.withName(HomeScreen.routeName));
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
  //           msg: S.current.sign_in_failed,
  //           fontSize: MediaQuery.of(context).textScaleFactor *13,
  //           backgroundColor: ColorCodes.blackColor,
  //           textColor: ColorCodes.whiteColor);
  //       //onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       Navigator.of(context).pop();
  //       Fluttertoast.showToast(
  //           msg: S.current.sign_in_cancelledbyuser,
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
  Future<void> checkusertype(String prev) async {
    // imp feature in adding async is the it automatically wrap into Future.
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
          /*if (PrefUtils.prefs.getString('FirstName') != null) {
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
                /*if (PrefUtils.prefs.getString('FirstName') != null) {
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
              msg: S.current.sign_in_failed,
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
          break;
        case AuthorizationStatus.cancelled:
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: S.current.sign_in_cancelledbyuser,
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
          break;
      }
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: S.current.apple_signin_not_available_forthis_device,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
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
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> Otpin30sec() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.resendOtp30, body: {
        // await keyword is used to wait to this operation is complete.
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
          msg: S.current.sign_in_failed,
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
            content: Text(S.current.please_enter_valid_otp),
          );
        });
  }

  addMobilenumToSF(String value) async {
    PrefUtils.prefs.setString('Mobilenum', value);
  }

  addReferralToSF(String value)async{
    PrefUtils.prefs.setString('referid', value);
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
          /*if (PrefUtils.prefs.getString('FirstName') != null) {
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
    SignupUser();
  }

  Future<void> signupUser() async {
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

        return Navigator.of(context).pushNamedAndRemoveUntil(
            MapScreen.routeName, ModalRoute.withName('/'));
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
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

      String name = PrefUtils.prefs.getString('FirstName').toString() + " " + PrefUtils.prefs.getString('LastName').toString();

      final response = await http.post(Api.register, body: {
        "username": name,
        "email": PrefUtils.prefs.getString('Email'),
        "mobileNumber": PrefUtils.prefs.containsKey("Mobilenum") ? PrefUtils.prefs.getString('Mobilenum') : "",
        "path": apple,
        "tokenId": PrefUtils.prefs.getString('tokenid'),
        "branch": PrefUtils.prefs.getString('branch'),
        "signature": PrefUtils.prefs.containsKey("signature") ? PrefUtils.prefs.getString('signature') : "",
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
        Navigator.of(context).pop();
        PrefUtils.prefs.setString("formapscreen", "");
        return Navigator.of(context).pushReplacementNamed(MapScreen.routeName);

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

  addFirstnameToSF(String value) async {
    PrefUtils.prefs.setString('FirstName', value);
  }

  addLastnameToSF(String value) async {
    PrefUtils.prefs.setString('LastName', value);
  }

  addEmailToSF(String value) async {
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
                          S.current.add_info,
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
                                  S.current.what_should_we_call_you,
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S.current.name,
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
                                        fn = S.current.please_enter_name;
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
                                  S.current.tell_us_your_email,
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
                                        S.current.please_enter_valid_email_address;
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
                                  S.current.we_will_email,
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
                                      fillColor:  ColorCodes.greenColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color:  ColorCodes.greenColor),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color:  ColorCodes.greenColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color:  ColorCodes.greenColor, width: 1.2),
                                      ),
                                    ),
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
                              S.current.continue_button,
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
  // _dialogforSignIn() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(3.0)),
  //             child: Container(
  //               height: (_isWeb && ResponsiveLayout.isSmallScreen(context))
  //                   ? MediaQuery.of(context).size.height
  //                   : MediaQuery.of(context).size.width / 2.2,
  //               width: (_isWeb && ResponsiveLayout.isSmallScreen(context))
  //                   ? MediaQuery.of(context).size.width
  //                   : MediaQuery.of(context).size.width / 3.0,
  //               //padding: EdgeInsets.only(left: 30.0, right: 20.0),
  //               child: Column(children: <Widget>[
  //                 Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 50.0,
  //                   color: ColorCodes.lightGreyWebColor,
  //                   padding: EdgeInsets.only(left: 20.0),
  //                   child: Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         S.current.signin,
  //                         style: TextStyle(
  //                             color: ColorCodes.mediumBlackColor,
  //                             fontSize: 20.0),
  //                       )),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.only(left: 30.0, right: 30.0),
  //                   child: Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 32.0,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width / 1.2,
  //                         height: 52,
  //                         margin: EdgeInsets.only(bottom: 8.0),
  //                         padding: EdgeInsets.only(
  //                             left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(4.0),
  //                           border: Border.all(
  //                               width: 0.5, color: ColorCodes.borderColor),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             Image.asset(
  //                               Images.countryImg,
  //                             ),
  //                             SizedBox(
  //                               width: 14,
  //                             ),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceEvenly,
  //                               children: [
  //                                 Text(S.current.country_region,//"Country/Region",
  //                                     style: TextStyle(
  //                                       color: ColorCodes.greyColor,
  //                                     )),
  //                                 Text(countryName + " (" + IConstants.countryCode + ")",
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.bold))
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width / 1.2,
  //                         height: 52.0,
  //                         padding: EdgeInsets.only(
  //                             left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(4.0),
  //                           border: Border.all(
  //                               width: 0.5, color: ColorCodes.borderColor),
  //                         ),
  //                         child: Row(
  //                           children: <Widget>[
  //                             Image.asset(Images.phoneImg),
  //                             SizedBox(
  //                               width: 14,
  //                             ),
  //                             Container(
  //                                 width:
  //                                 MediaQuery.of(context).size.width / 4.0,
  //                                 child: Form(
  //                                   key: _form,
  //                                   child: TextFormField(
  //                                     style: TextStyle(fontSize: 16.0),
  //                                     textAlign: TextAlign.left,
  //                                     inputFormatters: [
  //                                       LengthLimitingTextInputFormatter(12)
  //                                     ],
  //                                     cursorColor:
  //                                     Theme.of(context).primaryColor,
  //                                     keyboardType: TextInputType.number,
  //                                     autofocus: true,
  //                                     decoration: new InputDecoration.collapsed(
  //                                         hintText: S.current.enter_yor_mobile_number,
  //                                         hintStyle: TextStyle(
  //                                           color: Colors.black12,
  //                                         )),
  //                                     validator: (value) {
  //                                       if (value.isEmpty) {
  //                                         return S.current.please_enter_phone_number;
  //                                       }
  //                                       return null; //it means user entered a valid input
  //                                     },
  //                                     onSaved: (value) {
  //                                       addMobilenumToSF(value);
  //                                     },
  //                                   ),
  //                                 ))
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width / 1.2,
  //                         height: 60.0,
  //                         margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
  //                         child: Text(
  //                           S.current.we_will_call_or_text,
  //                           style: TextStyle(
  //                               fontSize: 13, color: ColorCodes.mediumBlackColor),
  //                         ),
  //                       ),
  //                       MouseRegion(
  //                         cursor: SystemMouseCursors.click,
  //                         child: GestureDetector(
  //                           behavior: HitTestBehavior.translucent,
  //                           onTap: () {
  //                             PrefUtils.prefs.setString('skip', "no");
  //                             PrefUtils.prefs.setString('prevscreen', "mobilenumber");
  //                             // PrefUtils.prefs.setString('Mobilenum', value);
  //                             _saveFormLogin();
  //                             _dialogforProcess();
  //                           },
  //                           child: Container(
  //                             width: MediaQuery.of(context).size.width / 1.2,
  //                             height: 32,
  //                             padding: EdgeInsets.all(5.0),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(5.0),
  //                               border: Border.all(
  //                                 width: 1.0,
  //                                 color: ColorCodes.greenColor,
  //                               ),
  //                             ),
  //                             child: Text(
  //                               S.current.login_using_otp,
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 15.0,
  //                                   color: ColorCodes.blackColor),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width / 1.2,
  //                         height: 60.0,
  //                         margin: EdgeInsets.only(top: 12.0, bottom: 32.0),
  //                         child: new RichText(
  //                           text: new TextSpan(
  //                             // Note: Styles for TextSpans must be explicitly defined.
  //                             // Child text spans will inherit styles from parent
  //                             style: new TextStyle(
  //                               fontSize: 13.0,
  //                               color: Colors.black,
  //                             ),
  //                             children: <TextSpan>[
  //                               new TextSpan(
  //                                   text: S.current.agreed_terms),
  //                               new TextSpan(
  //                                   text: S.current.terms_of_service,
  //                                   style:
  //                                   new TextStyle(color: ColorCodes.darkthemeColor),
  //                                   recognizer: new TapGestureRecognizer()
  //                                     ..onTap = () {
  //                                       Navigator.of(context).pushNamed(
  //                                           PolicyScreen.routeName,
  //                                           arguments: {
  //                                             'title': "Terms of Use",
  //                                             'body': IConstants.restaurantTerms,
  //                                           });
  //                                     }),
  //                               new TextSpan(text: ' and'),
  //                               new TextSpan(
  //                                   text: S.current.privacy_policy,
  //                                   style:
  //                                   new TextStyle(color: ColorCodes.darkthemeColor),
  //                                   recognizer: new TapGestureRecognizer()
  //                                     ..onTap = () {
  //                                       Navigator.of(context).pushNamed(
  //                                           PolicyScreen.routeName,
  //                                           arguments: {
  //                                             'title': "Privacy",
  //                                             'body':
  //                                             PrefUtils.prefs.getString("privacy"),
  //                                           });
  //                                     }),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         height: 30,
  //                         width: MediaQuery.of(context).size.width / 1.2,
  //                         child: Row(
  //                           children: [
  //                             Expanded(
  //                               child: Divider(
  //                                 thickness: 0.5,
  //                                 color: ColorCodes.greyColor,
  //                               ),
  //                             ),
  //                             Container(
  //                               //padding: EdgeInsets.all(4.0),
  //                               width: 23.0,
  //                               height: 23.0,
  //                               decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                   color: ColorCodes.greyColor,
  //                                 ),
  //                                 shape: BoxShape.circle,
  //                               ),
  //                               child: Center(
  //                                   child: Text(
  //                                     S.current.or,
  //                                     style: TextStyle(
  //                                         fontSize: 10.0, color: ColorCodes.greyColor),
  //                                   )),
  //                             ),
  //                             Expanded(
  //                               child: Divider(
  //                                 thickness: 0.5,
  //                                 color: ColorCodes.greyColor,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             margin: EdgeInsets.symmetric(horizontal: 28),
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 _dialogforProcessing();
  //                                 Navigator.of(context).pop();
  //                                 _handleSignIn();
  //                               },
  //                               child: Material(
  //                                 borderRadius: BorderRadius.circular(4.0),
  //                                 elevation: 2,
  //                                 shadowColor: Colors.grey,
  //                                 child: Container(
  //
  //                                   padding: EdgeInsets.only(
  //                                       left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(4.0),),
  //                                   child:
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(right:23.0,left:23,),
  //                                     child: Center(
  //                                       child: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                         children: <Widget>[
  //                                           SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
  //                                           //Image.asset(Images.googleImg,width: 20,height: 40,),
  //                                           SizedBox(
  //                                             width: 14,
  //                                           ),
  //                                           Text(
  //                                             S.current.sign_in_with_google , //"Sign in with Google",
  //                                             textAlign: TextAlign.center,
  //                                             style: TextStyle(fontSize: 16,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: ColorCodes.signincolor),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70, horizontal: 28),
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 _dialogforProcessing();
  //                                 Navigator.of(context).pop();
  //                                 facebooklogin();
  //                               },
  //                               child: Material(
  //                                 borderRadius: BorderRadius.circular(4.0),
  //                                 elevation: 2,
  //                                 shadowColor: Colors.grey,
  //                                 child: Container(
  //                                   padding: EdgeInsets.only(
  //                                       left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(4.0),
  //
  //                                     // border: Border.all(width: 0.5, color: ColorCodes.borderColor)),
  //                                   ),
  //                                   child:
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(right:23.0,left: 23),
  //                                     child: Center(
  //                                       child: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                         children: <Widget>[
  //                                           SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
  //                                           //Image.asset(Images.facebookImg,width: 20,height: 40,),
  //                                           SizedBox(
  //                                             width: 14,
  //                                           ),
  //                                           Text(
  //                                             S.current.sign_in_with_facebook ,// "Sign in with Facebook",
  //                                             textAlign: TextAlign.center,
  //                                             style: TextStyle(fontSize: 16,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: ColorCodes.signincolor),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           if (_isAvailable)
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 28),
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   appleLogIn();
  //                                 },
  //                                 child: Material(
  //                                   borderRadius: BorderRadius.circular(4.0),
  //                                   elevation: 2,
  //                                   shadowColor: Colors.grey,
  //                                   child: Container(
  //
  //                                     padding: EdgeInsets.only(
  //                                         left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(4.0),),
  //                                     child:
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(right:23.0,left:23,),
  //                                       child: Center(
  //                                         child: Row(
  //                                           mainAxisAlignment: MainAxisAlignment.start,
  //                                           children: <Widget>[
  //                                             SvgPicture.asset(Images.appleImg, width: 25, height: 25,),
  //                                             //Image.asset(Images.appleImg, width: 20,height: 40,),
  //                                             SizedBox(
  //                                               width: 14,
  //                                             ),
  //                                             Text(
  //                                               S.current.signin_apple  , //"Sign in with Apple",
  //                                               textAlign: TextAlign.center,
  //                                               style: TextStyle(fontSize: 16,
  //                                                   fontWeight: FontWeight.bold,
  //                                                   color: ColorCodes.signincolor),
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ]),
  //             ),
  //           );
  //         });
  //       });
  // }
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
                            S.current.signup_otp,
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
                                S.current.please_check_otp_sent_to_your_mobile_number,
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
                                    //_dialogforSignIn();
                                    LoginWeb(context,result: (sucsess){
                                      if(sucsess){
                                        Navigator.of(context).pop();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, HomeScreen.routeName, (route) => false);
                                      }else{
                                        Navigator.of(context).pop();
                                      }
                                    });
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
                                        child: Text(S.current.change,
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
                                S.current.enter_otp,
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
                                      width: (_isWeb &&
                                          ResponsiveLayout
                                              .isSmallScreen(context))
                                          ? MediaQuery.of(context)
                                          .size
                                          .width *
                                          50 /
                                          100
                                          : MediaQuery.of(context)
                                          .size
                                          .width *
                                          32 /
                                          100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        border: Border.all(
                                            color: ColorCodes.greyColor,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(S.current.resend_otp)),
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
                                          S.current.or,
                                          style: TextStyle(fontSize: 10),
                                        )),
                                  ),
                                  if(Features.callMeInsteadOTP)
                                  _timeRemaining == 0
                                      ? MouseRegion(
                                    cursor:
                                    SystemMouseCursors.click,
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
                                                  S.current.call_me_instead)),
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
                                                  text: S.current.call_in,
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
                                            Text(S.current.resend_otp)),
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
                                                S.current.resend_otp_in,
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
                                        S.current.or,
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
                                        child: Text(S.current.call_me_instead)),
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
                                S.current.login,
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


  _notifyMe() async {
    setState(() {
      _isNotify = true;
    });
    //_notifyMe();
    int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(itemid,varid,type);
    if(resposne == 200) {

      //_isWeb?_Toast("You will be notified via SMS/Push notification, when the product is available"):
      Fluttertoast.showToast(msg: S.current.you_will_notify ,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor:
          Colors.black87,
          textColor: Colors.white);
      setState(() {
        _isNotify = false;
      });
    } else {
      Fluttertoast.showToast(msg: S.current.something_went_wrong ,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor:
          Colors.black87,
          textColor: Colors.white);
      setState(() {
        _isNotify = false;
      });
    }
  }


  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case 'Description':
        return  (!ResponsiveLayout.isSmallScreen(context) && _isWeb)?
        Text(
          itemdescription,
          style: TextStyle(color: ColorCodes.blackColor),
        ):ReadMoreText(
          itemdescription,
          style: TextStyle(color: ColorCodes.blackColor),
          trimLines: 2,
          trimCollapsedText: '...Show more',
          trimExpandedText: '...Show less',
          colorClickableText: Theme
              .of(context)
              .primaryColor,
        );
      case 'Manufacturer Details':
        return (!ResponsiveLayout.isSmallScreen(context) && _isWeb)?
        Text(
          itemmanufact,
          style: TextStyle(color: ColorCodes.blackColor),
        ):
        ReadMoreText(
          itemmanufact,
          style: TextStyle(color: ColorCodes.blackColor),
          trimLines: 2,
          trimCollapsedText: '...Show more',
          trimExpandedText: '...Show less',
          colorClickableText: Theme
              .of(context)
              .primaryColor,
        );
    }
  }

  addListnameToSF(String value) async {
    PrefUtils.prefs.setString('list_name', value);
  }

  _saveFormTwo() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState.save();
    Navigator.of(context).pop();
    _dialogforProceesing(context, S.current.creating_list);

    Provider.of<BrandItemsList>(context, listen: false).CreateShoppinglist().then((_) {
      Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context, listen: false);
        Navigator.of(context).pop();
        _dialogforShoppinglistTwo(context);
      });
    });
  }

  additemtolist() {
    _dialogforProceesing(context, S.current.add_item_to_list);
    for (int i = 0; i < shoplistData.itemsshoplist.length; i++) {
      //adding item to multiple list
      if (shoplistData.itemsshoplist[i].listcheckbox) {
        for (int j = 0; j < productBox.length; j++) {
          Provider.of<BrandItemsList>(context, listen: false)
              .AdditemtoShoppinglist(
              productBox[j]
                  .itemId
                  .toString(),
              productBox[j]
                  .varId
                  .toString(),
              shoplistData.itemsshoplist[i].listid)
              .then((_) {
            if (i == (shoplistData.itemsshoplist.length - 1) &&
                j == (productBox.length - 1)) {
              Navigator.of(context).pop();

              Provider.of<BrandItemsList>(context, listen: false)
                  .fetchShoppinglist()
                  .then((_) {
                shoplistData =
                    Provider.of<BrandItemsList>(context, listen: false);
              });
              for (int i = 0; i < shoplistData.itemsshoplist.length; i++) {
                shoplistData.itemsshoplist[i].listcheckbox = false;
              }
            }
          });
        }
      }
    }
  }

  additemtolistTwo() {
    final shoplistDataTwo = Provider.of<BrandItemsList>(context, listen: false);
    _dialogforProceesing(context, "Add item to list...");
    for (int i = 0; i < shoplistDataTwo.itemsshoplist.length; i++) {
      //adding item to multiple list
      if (shoplistDataTwo.itemsshoplist[i].listcheckbox == true) {
        addtoshoppinglisttwo(i);
      }
    }
  }

  addtoshoppinglisttwo(i) async {
    final shoplistDataTwo = Provider.of<BrandItemsList>(context, listen: false);
    final routeArgs =
    ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, String>;
    final itemid = routeArgs['itemid'];

    Product products = Product(
        itemId: int.parse(itemid),
        varId: int.parse(varid),
        varName: varname+unit,
        varMinItem: int.parse(varminitem),
        varMaxItem: int.parse(varmaxitem),
        itemLoyalty: varLoyalty,
        varStock: int.parse(varstock),
        varMrp: double.parse(varmrp),
        itemName: itemname,
        //itemQty: _itemCount,
        itemPrice: double.parse(varprice),
        membershipPrice: varmemberprice,
        itemActualprice: double.parse(varmrp),
        itemImage: itemimg,
        membershipId: 0,
        mode: 0,
      veg_type: veg_type,
      type: type,
    );

    Provider.of<BrandItemsList>(context, listen: false)
        .AdditemtoShoppinglist(products.itemId.toString(),
        products.varId.toString(), shoplistDataTwo.itemsshoplist[i].listid)
        .then((_) {
      Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context, listen: false);
        Navigator.of(context).pop();
      });
    });
  }

  _dialogforProceesing(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 40.0,
                      ),
                      Text(text),
                    ],
                  )),
            );
          });
        });
  }

  _dialogforCreatelistTwo(BuildContext context, shoplistData) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  // color: Theme.of(context).primaryColor,
                  height: 250.0,
                  margin: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 10.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.current.create_shopping_list,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Form(
                        key: _form,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return S.current.please_enter_list_name;
                                }
                                return null; //it means user entered a valid input
                              },
                              onSaved: (value) {
                                addListnameToSF(value);
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: S.current.shopping_list_name,
                                labelStyle: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .accentColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'ex: Monthly Grocery',
                                hintStyle: TextStyle(
                                    color: Colors.black12, fontSize: 10.0),
                                //prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _saveFormTwo();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S.current.shopping_list_name,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Theme
                                    .of(context)
                                    .buttonColor),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S.current.cancel,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Theme
                                    .of(context)
                                    .buttonColor),
                              )),
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  _dialogforShoppinglistTwo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          final x = Provider.of<BrandItemsList>(context, listen: false);
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 10.0, top: 20.0, right: 10.0, bottom: 30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.current.add_to_list,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          child: new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: x.itemsshoplist.length,
                            itemBuilder: (_, i) =>
                                Row(
                                  children: [
                                    Checkbox(
                                      value: x.itemsshoplist[i].listcheckbox,
                                      onChanged: (bool value) {
                                        setState(() {
                                          x.itemsshoplist[i].listcheckbox =
                                              value;
                                        });
                                      },
                                    ),
                                    Text(x.itemsshoplist[i].listname,
                                        style: TextStyle(fontSize: 18.0)),
                                  ],
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            _dialogforCreatelistTwo(context, shoplistData);

                            for (int i = 0; i < x.itemsshoplist.length; i++) {
                              x.itemsshoplist[i].listcheckbox = false;
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                S.current.create_new,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            bool check = false;
                            for (int i = 0; i < x.itemsshoplist.length; i++) {
                              if (x.itemsshoplist[i].listcheckbox)
                                setState(() {
                                  check = true;
                                });
                            }
                            if (check) {
                              Navigator.of(context).pop();
                              additemtolistTwo();
                            } else {
                              Fluttertoast.showToast(
                                  msg: S.current.please_select_atleastonelist,
                                  fontSize: MediaQuery.of(context).textScaleFactor *13,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white);
                            }
                          },
                          child: Container(
                            width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // color: Theme.of(context).primaryColor,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S.current.add,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            for (int i = 0; i < x.itemsshoplist.length; i++) {
                              x.itemsshoplist[i].listcheckbox = false;
                            }
                          },
                          child: Container(
                            width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // color: Theme.of(context).primaryColor,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S.current.cancel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
        });
  }

  Widget handler( int i) {
    if (int.parse(singleitemvar[i].varstock) <= 0) {
      return (varid == singleitemvar[i].varid) ?
      Icon(
          Icons.radio_button_checked_outlined,
          color: ColorCodes.grey)
          :
      Icon(
          Icons.radio_button_off_outlined,
          color: ColorCodes.grey);

    } else {
      return (varid == singleitemvar[i].varid) ?
      Icon(
          Icons.radio_button_checked_outlined,
          color: ColorCodes.mediumBlueColor)
          :
      Icon(
          Icons.radio_button_off_outlined,
          color: ColorCodes.blackColor);
    }
  }

  @override
  Widget build(BuildContext context) {

    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    final routeArgs =
    ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;
    final itemid = routeArgs['itemid'];
    final eligibleforexpress=routeArgs['eligibleforexpress'];
    final delivery = routeArgs['delivery'];
    final duration = routeArgs['duration'];
    final durationType= routeArgs['durationType'];
    final note= routeArgs['note'];
    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    if (sellingitemData.itemsnew.length <= 0) {
      _similarProduct = false;
    } else {
      _similarProduct = true;
    }

    addToCart(int _itemCount) async {
      multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
      _displayimg = multiimage[0].imageUrl;
      if(singleitemvar.length<=1) {
        itemimg = singleitemData.singleitems[0].imageUrl;
      }else{
        itemimg =_displayimg;
      }

      cartcontroller.addtoCart( PriceVariation(id: varid,variationName: vsize,
          unit:unit,fit:fit,minItem: varminitem,maxItem: varmaxitem,loyalty: 0,
          stock: int.parse(varstock),status: "",mrp: double.parse(varmrp),
          price: double.parse(varprice),membershipPrice: double.parse(varmemberprice),
          membershipDisplay: memberpriceDisplay, images: [ImageDate(image:itemimg)]),
          ItemData(id: itemid,itemName: itemname,type: type,deliveryDuration: DeliveryDurationData(),
              delivery: delivery), (onload){
        setState(() {
          _isAddToCart = onload;
        });
        setState(() {
          _isAddToCart = false;
          _varQty = _itemCount;
        });
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          if(sellingitemData.featuredVariation[i].varid == varid) {
            sellingitemData.featuredVariation[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          if(sellingitemData.discountedVariation[i].varid == varid) {
            sellingitemData.discountedVariation[i].varQty = _itemCount;
            break;
          }
        }
        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          if (sellingitemData.itemspricevarOffer[i].varid == varid) {
            sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
            break;
          }
        }
        for (int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          if (sellingitemData.itemspricevarSwap[i].varid == varid) {
            sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.recentVariation.length; i++) {
          if(sellingitemData.recentVariation[i].varid == varid) {
            sellingitemData.recentVariation[i].varQty = _itemCount;
            break;
          }
        }

        for(int i = 0; i < singleitemvar.length; i++) {
          if(singleitemvar[i].varid == varid) {
            singleitemvar[i].varQty = _itemCount;
            break;
          }
        }
      });
    }

    // incrementToCart(int _itemCount) async {
    //   if (_itemCount + 1 <= int.parse(varminitem)) {
    //     _itemCount = 0;
    //   }
    //   final s = await Provider.of<CartItems>(context, listen: false).updateCart(varid, _itemCount.toString(), varprice).then((_) {
    //     setState(() {
    //       _varQty = _itemCount;
    //       _isAddToCart = false;
    //     });
    //     if (_itemCount + 1 <= int.parse(varminitem)) {
    //       for (int i =0; i <productBox.values.length; i++) {
    //         if (productBox.values.elementAt(i).varId == int.parse(varid)) {
    //           productBox.deleteAt(i);
    //           break;
    //         }
    //       }
    //       final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    //       for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
    //         if(sellingitemData.featuredVariation[i].varid == varid) {
    //           sellingitemData.featuredVariation[i].varQty = _itemCount;
    //         }
    //       }
    //       for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
    //         if (sellingitemData.itemspricevarOffer[i].varid == varid) {
    //           sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       for (int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
    //         if (sellingitemData.itemspricevarSwap[i].varid == varid) {
    //           sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
    //         if(sellingitemData.discountedVariation[i].varid == varid) {
    //           sellingitemData.discountedVariation[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       _bloc.setFeaturedItem(sellingitemData);
    //     } else {
    //       final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    //       for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
    //         if(sellingitemData.featuredVariation[i].varid == varid) {
    //           sellingitemData.featuredVariation[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
    //         if (sellingitemData.itemspricevarOffer[i].varid == varid) {
    //           sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       for (int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
    //         if (sellingitemData.itemspricevarSwap[i].varid == varid) {
    //           sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
    //         if(sellingitemData.discountedVariation[i].varid == varid) {
    //           sellingitemData.discountedVariation[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //       for(int i = 0; i < singleitemvar.length; i++) {
    //         if(singleitemvar[i].varid == varid) {
    //           singleitemvar[i].varQty = _itemCount;
    //           break;
    //         }
    //       }
    //
    //       _bloc.setFeaturedItem(sellingitemData);
    //       Product products = Product(
    //           itemId: int.parse(itemid),
    //           varId: int.parse(varid),
    //           varName: varname+unit,
    //           varMinItem: int.parse(varminitem),
    //           varMaxItem: int.parse(varmaxitem),
    //           itemLoyalty: varLoyalty,
    //           varStock: int.parse(varstock),
    //           varMrp: double.parse(varmrp),
    //           itemName: itemname,
    //           itemQty: _itemCount,
    //           itemPrice: double.parse(varprice),
    //           membershipPrice: varmemberprice,
    //           itemActualprice: double.parse(varmrp),
    //           itemImage: itemimg,
    //           membershipId: 0,
    //           mode: 0,
    //         veg_type: veg_type,
    //         type: type,
    //           eligible_for_express: eligibleforexpress,
    //           delivery: delivery,
    //           duration: duration,
    //           durationType: durationType,
    //           note: note
    //       );
    //
    //       var items = Hive.box<Product>(productBoxName);
    //
    //       for (int i = 0; i < items.length; i++) {
    //         UpdateCart(productBoxName,i,varid,products);
    //
    //       }
    //     }
    //   });
    // }

    _buildBottomNavigationBar() {
      singleitemData = Provider.of<ItemsList>(context, listen: false);
      return VxBuilder(
        mutations: {SetCartItem},
        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context, store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          return/* BottomNaviagation(
            itemCount: Calculations.itemCount.toString() + " " + S.of(context).items,
            title: S.current.view_cart,
            total: _checkmembership ? (Calculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                : (Calculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
                Navigator.of(context)
                    .pushNamed(CartScreen.routeName);
              });
            },
          );*/
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.all(10.0),
              height: 53,
              child: (Features.isSubscription)?Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: (singleitemData.singleitems[0].subscribe == "0")?MainAxisAlignment.start:MainAxisAlignment.center,
                children: <Widget>[
                  _isStock
                      ? Container(
                    height: 53.0,
                    width: (singleitemData.singleitems[0].subscribe == "0")?(MediaQuery.of(context)
                        .size
                        .width /
                        3) +
                        35:(MediaQuery.of(context).size.width / 2) + 150,
                    child: VxBuilder(
                      mutations: {SetCartItem},
                      // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                      builder: (context, store, index) {
                        final box = (VxState.store as GroceStore).CartItemList;
                        // debugPrint("qantity....single"+box.where((element) => element.varId==varid).first.quantity);
                        if (box.where((element) => element.varId==varid).length <= 0
                            || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAddToCart = true;
                              });
                              addToCart(int.parse(varminitem));
                            },
                            child: Container(
                              height: 30.0,
                              width: (MediaQuery.of(context).size.width / 3) + 25,
                              decoration: new BoxDecoration(
                                  color: (Features.isSubscription)?Theme
                                      .of(context)
                                      .primaryColor :ColorCodes.greenColor,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(3),
                                    topRight: const Radius.circular(3),
                                    bottomLeft: const Radius.circular(3),
                                    bottomRight: const Radius.circular(3),
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
                                  :(Features.isSubscription)?Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /* SizedBox(
                                                width: 3,
                                              ),*/
                                  Center(
                                      child: Text(
                                        S.current.buy_once,
                                        style:
                                        TextStyle(
                                          color: ColorCodes.whiteColor,
                                        ),
                                        textAlign:
                                        TextAlign
                                            .center,
                                      )),
                                  /*  Spacer(),
                                              Container(
                                                decoration:
                                                BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                    new BorderRadius.only(
                                                      topLeft:
                                                      const Radius.circular(2.0),
                                                      bottomLeft:
                                                      const Radius.circular(2.0),
                                                      topRight:
                                                      const Radius.circular(2.0),
                                                      bottomRight:
                                                      const Radius.circular(2.0),
                                                    )),
                                                height: 30,
                                                width: 25,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 12,
                                                  color: Colors
                                                      .white,
                                                ),
                                              ),*/
                                ],
                              ):
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                      child: Text(
                                        S.current.add,//'ADD',
                                        style:
                                        TextStyle(
                                          color: Theme.of(
                                              context)
                                              .buttonColor,
                                        ),
                                        textAlign:
                                        TextAlign
                                            .center,
                                      )),
                                  Spacer(),
                                  Container(
                                    decoration:
                                    BoxDecoration(
                                        color: ColorCodes.greenColor,
                                        borderRadius:
                                        new BorderRadius.only(
                                          topLeft:
                                          const Radius.circular(2.0),
                                          bottomLeft:
                                          const Radius.circular(2.0),
                                          topRight:
                                          const Radius.circular(2.0),
                                          bottomRight:
                                          const Radius.circular(2.0),
                                        )),
                                    height: 50,
                                    width: 25,
                                    child: Icon(
                                      Icons.add,
                                      size: 12,
                                      color: Colors
                                          .white,
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
                                    // setState(() {
                                    //   _isAddToCart = true;
                                    //   // incrementToCart(_varQty - 1);
                                    // });
                                    // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
                                    if(int.parse(box.where((element) => element.varId==varid).first.quantity) > 0)
                                      cartcontroller.update((done){
                                        setState(() {
                                          _isAddToCart = !done;
                                        });
                                      },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity)
                                          <= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity) - 1).toString(),
                                          var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
                                  },
                                  child: (Features.isSubscription)?
                                  Container(
                                    //margin: EdgeInsets.all(6),
                                      width: 40,
                                      height: 60,
                                      decoration:
                                      new BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          border: Border
                                              .all(
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          ),
                                          borderRadius:
                                          new BorderRadius.only(
                                            bottomLeft:
                                            const Radius.circular(3),
                                            topLeft:
                                            const Radius.circular(3),
                                          )),
                                      child: Center(
                                        child: Text(
                                          "-",
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style:
                                          TextStyle(
                                            color:ColorCodes.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ))
                                      :Container(
                                      width: 30,
                                      height: 30,
                                      decoration:
                                      new BoxDecoration(
                                          border: Border
                                              .all(
                                            color: ColorCodes.greenColor,
                                          ),
                                          borderRadius:
                                          new BorderRadius.only(
                                            bottomLeft:
                                            const Radius.circular(3.0),
                                            topLeft:
                                            const Radius.circular(3.0),
                                          )),
                                      child: Center(
                                        child: Text(
                                          "-",
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style:
                                          TextStyle(
                                            color: ColorCodes.greenColor,
                                          ),
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: _isAddToCart ?
                                  Container(
                                    decoration: BoxDecoration(color: (Features.isSubscription)? ColorCodes.whiteColor:ColorCodes.greenColor,),
                                    height: 60,

                                    child: Center(
                                      child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: new CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)),
                                    ),
                                  )
                                      :
                                  VxBuilder(
                                      mutations: {SetCartItem},
                                      // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                      builder: (context, store, index) {
                                        final box = (VxState.store as GroceStore).CartItemList;

                                        if (box.isEmpty) return SizedBox.shrink();
                                        return  (Features.isSubscription)?
                                        Container(
//                                            width: 40,
                                            decoration:
                                            BoxDecoration(
                                              color: /*Theme
                                                .of(context)
                                                .primaryColor*/ColorCodes.whiteColor,
                                            ),
                                            height: 60,
                                            child: Center(
                                              child: Text(
                                                box.where((element) => element.varId==varid).first.quantity,
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                style:
                                                TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ))
                                            :Container(
//                                            width: 40,
                                            decoration:
                                            BoxDecoration(
                                              color: ColorCodes.greenColor,
                                            ),
                                            height: 60,
                                            child: Center(
                                              child: Text(
                                                box.where((element) => element.varId==varid).first.quantity,
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                style:
                                                TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .buttonColor,
                                                ),
                                              ),
                                            ));
                                      }),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_varQty < int.parse(varstock)) {
                                      if (_varQty < int.parse(varmaxitem)) {
                                        // setState(() {
                                        //   _isAddToCart = true;
                                        // });
                                        // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
                                        cartcontroller.update((done){
                                          setState(() {
                                            _isAddToCart = !done;
                                          });
                                        },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
                                        // incrementToCart(_varQty + 1);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                            S.current.cant_add_more_item,
                                            fontSize: MediaQuery.of(context).textScaleFactor *13,
                                            backgroundColor:
                                            Colors
                                                .black87,
                                            textColor:
                                            Colors.white);
                                      }
                                    } else {
                                      Fluttertoast.showToast(msg: S.current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
                                    }
                                  },
                                  child: (Features.isSubscription)?
                                  Container(
                                    //margin: EdgeInsets.only(right: 3),
                                      width: 40,
                                      height: 60,
                                      decoration:
                                      new BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          border: Border
                                              .all(
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          ),
                                          borderRadius:
                                          new BorderRadius.only(
                                            bottomRight:
                                            const Radius.circular(3),
                                            topRight:
                                            const Radius.circular(3),
                                          )),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style:
                                          TextStyle(
                                            color: ColorCodes.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ))
                                      :Container(
                                      width: 30,
                                      height: 30,
                                      decoration:
                                      new BoxDecoration(
                                          border: Border
                                              .all(
                                            color: ColorCodes.greenColor,
                                          ),
                                          borderRadius:
                                          new BorderRadius.only(
                                            bottomRight:
                                            const Radius.circular(2.0),
                                            topRight:
                                            const Radius.circular(2.0),
                                          )),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style:
                                          TextStyle(
                                            color: ColorCodes.greenColor,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          );
                        /*try {
                                            Product item = Hive.box<
                                                Product>(
                                                productBoxName)
                                                .values
                                                .firstWhere((value) =>
                                            value.varId ==
                                                int.parse(varid));
                                            return Container(
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        _isAddToCart = true;
                                                        incrementToCart(item.itemQty - 1);
                                                      });
                                                    },
                                                    child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                        new BoxDecoration(
                                                            border: Border
                                                                .all(
                                                              color: ColorCodes.greenColor,
                                                            ),
                                                            borderRadius:
                                                            new BorderRadius.only(
                                                              bottomLeft:
                                                              const Radius.circular(2.0),
                                                              topLeft:
                                                              const Radius.circular(2.0),
                                                            )),
                                                        child: Center(
                                                          child: Text(
                                                            "-",
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style:
                                                            TextStyle(
                                                              color: ColorCodes.greenColor,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: _isAddToCart ?
                                                    Container(
                                                      decoration: BoxDecoration(color: ColorCodes.greenColor,),
                                                      height: 30,

                                                      child: Center(
                                                        child: SizedBox(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            child: new CircularProgressIndicator(
                                                              strokeWidth: 2.0,
                                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                                      ),
                                                    )
                                                        :
                                                    Container(
//                                            width: 40,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: ColorCodes.greenColor,
                                                        ),
                                                        height: 30,
                                                        child: Center(
                                                          child: Text(
                                                            item.itemQty.toString(),
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style:
                                                            TextStyle(
                                                              color: Theme.of(context)
                                                                  .buttonColor,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (item.itemQty < int.parse(varstock)) {
                                                        if (item.itemQty < int.parse(varmaxitem)) {
                                                          setState(() {
                                                            _isAddToCart = true;
                                                          });
                                                          incrementToCart(item.itemQty + 1);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                              "Sorry, you can\'t add more of this item!",
                                                              backgroundColor:
                                                              Colors
                                                                  .black87,
                                                              textColor:
                                                              Colors.white);
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(msg: "Sorry, Out of Stock!", backgroundColor: Colors.black87, textColor: Colors.white);
                                                      }
                                                    },
                                                    child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                        new BoxDecoration(
                                                            border: Border
                                                                .all(
                                                              color: ColorCodes.greenColor,
                                                            ),
                                                            borderRadius:
                                                            new BorderRadius.only(
                                                              bottomRight:
                                                              const Radius.circular(2.0),
                                                              topRight:
                                                              const Radius.circular(2.0),
                                                            )),
                                                        child: Center(
                                                          child: Text(
                                                            "+",
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style:
                                                            TextStyle(
                                                              color: ColorCodes.greenColor,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } catch (e) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isAddToCart = true;
                                                });
                                                addToCart(int.parse(varminitem));
                                              },
                                              child: Container(
                                                height: 30.0,
                                                width: (MediaQuery.of(context).size.width / 4) + 15,
                                                decoration:
                                                new BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    borderRadius:
                                                    new BorderRadius
                                                        .only(
                                                      topLeft:
                                                      const Radius.circular(
                                                          2.0),
                                                      topRight:
                                                      const Radius.circular(
                                                          2.0),
                                                      bottomLeft:
                                                      const Radius.circular(
                                                          2.0),
                                                      bottomRight:
                                                      const Radius.circular(
                                                          2.0),
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
                                                    :
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Center(
                                                        child: Text(
                                                          S.current.add,//'ADD',
                                                          style:
                                                          TextStyle(
                                                            color: Theme.of(
                                                                context)
                                                                .buttonColor,
                                                          ),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                        )),
                                                    Spacer(),
                                                    Container(
                                                      decoration:
                                                      BoxDecoration(
                                                          color: Color(
                                                              0xff1BA130),
                                                          borderRadius:
                                                          new BorderRadius.only(
                                                            topLeft:
                                                            const Radius.circular(2.0),
                                                            bottomLeft:
                                                            const Radius.circular(2.0),
                                                            topRight:
                                                            const Radius.circular(2.0),
                                                            bottomRight:
                                                            const Radius.circular(2.0),
                                                          )),
                                                      height: 30,
                                                      width: 25,
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 12,
                                                        color: Colors
                                                            .white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }*/
                      },
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      checkskip
                          ? Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,arguments: {
                        "prev": "signupSelectionScreen",
                      }
                      )
                          : _notifyMe();
                      // Fluttertoast.showToast(
                      //     msg:  "You will be notified via SMS/Push notification, when the product is available" ,
                      //     /*"Out Of Stock",*/
                      //     fontSize: 12.0,
                      //     backgroundColor:
                      //     Colors.black87,
                      //     textColor: Colors.white);
                    },
                    child: Container(
                      height: 50.0,
                      width:(MediaQuery.of(context).size.width / 2) + 150,
                      decoration: new BoxDecoration(
                          border: Border.all(
                              color: Colors.grey),
                          color: Colors.grey,
                          borderRadius:
                          new BorderRadius.only(
                            topLeft: const Radius
                                .circular(2.0),
                            topRight: const Radius
                                .circular(2.0),
                            bottomLeft: const Radius
                                .circular(2.0),
                            bottomRight:
                            const Radius
                                .circular(2.0),
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
                            width: 40,
                          ),
                          Center(
                              child: Text(
                                S.current.notify_me,
                                /* "ADD",*/
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors
                                        .white ),
                                textAlign:
                                TextAlign.center,
                              )),
                          Spacer(),
                          Container(
                            decoration:
                            BoxDecoration(
                                color: Colors
                                    .black12,
                                borderRadius:
                                new BorderRadius
                                    .only(
                                  topRight:
                                  const Radius
                                      .circular(
                                      2.0),
                                  bottomRight:
                                  const Radius
                                      .circular(
                                      2.0),
                                )),
                            height: 50,
                            width: 40,
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
                  (singleitemData.singleitems[0].subscribe == "0")?SizedBox(width: 20,):SizedBox.shrink(),
                  (Features.isSubscription)?
                  (singleitemData.singleitems[0].subscribe == "0")?
                  _isStock?
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          //_dialogforSignIn();
                          LoginWeb(context,result: (sucsess){
                            if(sucsess){
                              Navigator.of(context).pop();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, HomeScreen.routeName, (route) => false);
                            }else{
                              Navigator.of(context).pop();
                            }
                          });
                        }
                        else {
                          (checkskip) ?
                          Navigator.of(context).pushNamed(
                            SignupSelectionScreen.routeName,arguments: {
                            "prev": "signupSelectionScreen",
                          }
                          ) :
                          Navigator.of(context).pushNamed(
                              SubscribeScreen.routeName,
                              arguments: {
                                "itemid": singleitemData.singleitems[0].id,
                                "itemname": singleitemData.singleitems[0].title,
                                "itemimg": singleitemData.singleitems[0].imageUrl,
                                "varname": varname+unit,
                                "varmrp":varmrp,
                                "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
                                "paymentMode": singleitemData.singleitems[0].paymentmode,
                                "cronTime": singleitemData.singleitems[0].cronTime,
                                "name": singleitemData.singleitems[0].name,
                                "varid": varid.toString(),
                                "brand": singleitemData.singleitems[0].brand
                              }
                          );
                        }
                      },
                      child: Container(
                        height: 60.0,
                        width: (MediaQuery.of(context)
                            .size.width / 3) +35,
                        decoration: new BoxDecoration(
                            color: ColorCodes.whiteColor,
                            border: Border.all(color: Theme
                                .of(context)
                                .primaryColor),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(3),
                              topRight:
                              const Radius.circular(3),
                              bottomLeft:
                              const Radius.circular(3),
                              bottomRight:
                              const Radius.circular(3),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(
                              S.current.subscribe,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ) ,
                      ),
                    ),
                  ):
                  SizedBox.shrink()
                      :
                  SizedBox.shrink():SizedBox.shrink(),
                ],
              ):Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _isStock
                      ? Container(
                    //  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    decoration: new BoxDecoration(
                      color: ColorCodes.lightBlueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 53.0,
                    width:(MediaQuery.of(context)
                        .size
                        .width) / 1.1,
                    child: VxBuilder(
                      mutations: {SetCartItem},
                      // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                      builder: (context, store, index) {
                        final box = (VxState.store as GroceStore).CartItemList;
                        //debugPrint("qantity....single..2"+box.where((element) => element.varId==varid).first.quantity);
                        if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                          return GestureDetector(
                            onTap: () {
                              if(_isColorSelect) {
                                setState(() {
                                  _isAddToCart = true;
                                });
                                addToCart(int.parse(varminitem));
                              }
                              else{
                                Fluttertoast.showToast(
                                            msg:
                                           "Please Select Size",
                                            fontSize: MediaQuery.of(context).textScaleFactor *13,
                                            backgroundColor:
                                            Colors
                                                .black87,
                                            textColor:
                                            Colors.white);

                              }
                            },
                            child: Container(
                              //  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              height: 30.0,
                              width: (MediaQuery.of(context).size.width / 2) + 150,
                              decoration: new BoxDecoration(
                                color: (Features.isSubscription)?Theme
                                    .of(context)
                                    .primaryColor :Theme
                                    .of(context)
                                    .primaryColor,
                                /* borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                  bottomLeft: const Radius.circular(2.0),
                                  bottomRight: const Radius.circular(2.0),)
                                */
                                borderRadius: BorderRadius.circular(10),),
                              child: _isAddToCart ?
                              Center(
                                child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: new CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                              )
                                  :(Features.isSubscription)?Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /* SizedBox(
                                                width: 3,
                                              ),*/
                                  Center(
                                      child: Text(
                                        S.current.buy_once,
                                        style:
                                        TextStyle(
                                          color: ColorCodes.whiteColor,
                                        ),
                                        textAlign:
                                        TextAlign
                                            .center,
                                      )),
                                  /*  Spacer(),
                                              Container(
                                                decoration:
                                                BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                    new BorderRadius.only(
                                                      topLeft:
                                                      const Radius.circular(2.0),
                                                      bottomLeft:
                                                      const Radius.circular(2.0),
                                                      topRight:
                                                      const Radius.circular(2.0),
                                                      bottomRight:
                                                      const Radius.circular(2.0),
                                                    )),
                                                height: 30,
                                                width: 25,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 12,
                                                  color: Colors
                                                      .white,
                                                ),
                                              ),*/
                                ],
                              ):
                              Center(
                                  child: Text(
                                    "ADD TO CART",//'ADD',
                                    style:
                                    TextStyle(
                                        color: ColorCodes.blackColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800
                                    ),
                                    textAlign:
                                    TextAlign
                                        .center,
                                  )),
                            ),
                          );
                        else
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  CartScreen.routeName,arguments: {
                                "after_login": ""
                              }
                              );
                            },
                            child: Container(
                              //  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              height: 30.0,
                              width: (MediaQuery.of(context).size.width / 2) + 150,
                              decoration: new BoxDecoration(
                                color: (Features.isSubscription)?Theme
                                    .of(context)
                                    .primaryColor :Theme
                                    .of(context)
                                    .primaryColor,
                                borderRadius: BorderRadius.circular(10),),
                              child:
                              Center(
                                  child: Text(
                                    "GO TO CART",//'ADD',
                                    style:
                                    TextStyle(
                                        color: ColorCodes.blackColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800
                                    ),
                                    textAlign:
                                    TextAlign
                                        .center,
                                  )),
                            ),
                          );
//                             Container(
//                             child: Row(
//                               children: <Widget>[
//                                 GestureDetector(
//                                   onTap: () async {
//                                     // setState(() {
//                                     //   _isAddToCart = true;
//                                     //   incrementToCart(_varQty - 1);
//                                     // });
//                                     if(int.parse(box.where((element) => element.varId==varid).first.quantity) > 0)
//                                       cartcontroller.update((done){
//                                         setState(() {
//                                           _isAddToCart = !done;
//                                         });
//                                       },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                                     // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                   },
//                                   child: (Features.isSubscription)?
//                                   Container(
//                                       width: 30,
//                                       height: 30,
//                                       decoration:
//                                       new BoxDecoration(
//                                           border: Border
//                                               .all(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomLeft:
//                                             const Radius.circular(2.0),
//                                             topLeft:
//                                             const Radius.circular(2.0),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "-",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                         ),
//                                       ))
//                                       :Container(
//                                     //margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
//                                       width: 50,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                           color: Theme.of(context).primaryColor,
//                                           border: Border
//                                               .all(
//                                             color: Theme.of(context).primaryColor,
//                                             width: 2,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomLeft:
//                                             const Radius.circular(3),
//                                             topLeft:
//                                             const Radius.circular(3),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "-",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                               color: ColorCodes.blackColor,
//                                               fontSize: 25,
//                                               fontWeight: FontWeight.bold
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                                 Expanded(
//                                   child: _isAddToCart ?
//                                   Container(
//                                     decoration: BoxDecoration(color: (Features.isSubscription)? Theme
//                                         .of(context)
//                                         .primaryColor:ColorCodes.whiteColor,),
//                                     height: 60,
//
//                                     child: Center(
//                                       child: SizedBox(
//                                           width: 20.0,
//                                           height: 20.0,
//                                           child: new CircularProgressIndicator(
//                                             strokeWidth: 2.0,
//                                             valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
//                                     ),
//                                   )
//                                       :
//                                   VxBuilder(
//                                       mutations: {SetCartItem},
//                                       // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//                                       builder: (context,GroceStore store, index) {
//                                         final box = (VxState.store as GroceStore).CartItemList.where((element) => element.varId==varid);
//                                         if (box.isEmpty) return SizedBox.shrink();
//                                         return  (Features.isSubscription)?
//                                         Container(
// //                                            width: 40,
//                                             decoration:
//                                             BoxDecoration(
//                                               color: Theme
//                                                   .of(context)
//                                                   .primaryColor,
//                                             ),
//                                             height: 60,
//                                             child: Center(
//                                               child: Text(
//                                                 box.first.quantity.toString(),
//                                                 textAlign:
//                                                 TextAlign
//                                                     .center,
//                                                 style:
//                                                 TextStyle(
//                                                   color: ColorCodes.greenColor,
//                                                 ),
//                                               ),
//                                             ))
//                                             :Container(
// //                                            width: 40,
//                                             decoration:
//                                             BoxDecoration(
//                                               color: ColorCodes.whiteColor,
//                                               border:  Border.all(
//                                                 color: Theme.of(context).primaryColor,
//                                                 //width: 4.0,
//                                               ),
//                                             ),
//
//                                             height: 60,
//                                             child: Center(
//                                               child: Text(
//                                                 box.first.quantity.toString(),
//                                                 textAlign:
//                                                 TextAlign
//                                                     .center,
//                                                 style:
//                                                 TextStyle(
//                                                   color:ColorCodes.blackColor,
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ));
//                                       }),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (_varQty < int.parse(varstock)) {
//                                       if (_varQty < int.parse(varmaxitem)) {
//                                         // setState(() {
//                                         //   _isAddToCart = true;
//                                         // });
//                                         cartcontroller.update((done){
//                                           setState(() {
//                                             _isAddToCart = !done;
//                                           });
//                                         },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity) +1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//
//                                       } else {
//                                         Fluttertoast.showToast(
//                                             msg:
//                                             S.current.cant_add_more_item,
//                                             fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                             backgroundColor:
//                                             Colors
//                                                 .black87,
//                                             textColor:
//                                             Colors.white);
//                                       }
//                                     } else {
//                                       Fluttertoast.showToast(msg: S.current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
//                                     }
//                                   },
//                                   child: (Features.isSubscription)?
//                                   Container(
//                                       width: 50,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                           border: Border
//                                               .all(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomRight:
//                                             const Radius.circular(2.0),
//                                             topRight:
//                                             const Radius.circular(2.0),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "+",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                         ),
//                                       ))
//                                       :Container(
//                                     //  margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
//                                       width: 50,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                         color:Theme.of(context).primaryColor,
//                                         border: Border
//                                             .all(
//                                           color: Theme.of(context).primaryColor,
//                                           width: 2,
//                                         ),
//                                         borderRadius:
//                                         new BorderRadius.only(
//                                           bottomRight:
//                                           const Radius.circular(3),
//                                           topRight:
//                                           const Radius.circular(3),
//                                         ),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           "+",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                               color: ColorCodes.blackColor,
//                                               fontSize: 25,
//                                               fontWeight: FontWeight.bold
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           );
                      },
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      checkskip
                          ? Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,arguments: {
                        "prev": "signupSelectionScreen",
                      }
                      )
                          : _notifyMe();

                    },
                    child:_isLoading? SizedBox.shrink():Container(
                      height: 53.0,
                      width: (MediaQuery.of(context).size.width / 2) + 150,
                      decoration: new BoxDecoration(
                          border: Border.all(
                              color: Colors.grey),
                          color: Colors.grey,
                          borderRadius:
                          new BorderRadius.only(
                            topLeft: const Radius
                                .circular(3.0),
                            topRight: const Radius
                                .circular(3.0),
                            bottomLeft: const Radius
                                .circular(3.0),
                            bottomRight:
                            const Radius
                                .circular(3.0),
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
                            width: 30,
                          ),
                          Center(
                              child: Text(
                                S.current.notify_me,
                                /* "ADD",*/
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors
                                        .white ),
                                textAlign:
                                TextAlign.center,
                              )),
                          Spacer(),
                          Container(
                            decoration:
                            BoxDecoration(
                                color: Colors
                                    .black12,
                                borderRadius:
                                new BorderRadius
                                    .only(
                                  topRight:
                                  const Radius
                                      .circular(
                                      3.0),
                                  bottomRight:
                                  const Radius
                                      .circular(
                                      3.0),
                                )),
                            height: 60,
                            width: 40,
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
                ],
              ),
            );
        },
      );
    }

    Widget createHeaderForMobile() {
      return Container(

        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              ColorCodes.accentColor,
              ColorCodes.primaryColor
            ],
          ),
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: EdgeInsets.only(left: 30)),

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Icon(
                Icons.keyboard_backspace,
                color: ColorCodes.menuColor,
              ),
              onTap: () {
                Navigator.of(context).popUntil(
                    ModalRoute.withName(HomeScreen.routeName,));
              },
            ),

            Padding(padding: EdgeInsets.only(left: 30)),

            Text(itemname, style: TextStyle(
              color: ColorCodes.menuColor,
              fontSize: 21,
              //fontWeight: FontWeight.bold,
            ),),

            Spacer(),

            Container(
              width: 25,
              height: 25,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    SearchitemScreen.routeName,
                  );
                },
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            if(Features.isShare)
              Container(
                width: 25,
                height: 25,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (_isIOS) {
                      Share.share(S.current.download_app +
                          IConstants.APP_NAME +
                          '${S.current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                    } else {
                      Share.share(S.current.download_app +
                          IConstants.APP_NAME +
                          '${S.current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                    }
                  },
                  child: Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ),
            SizedBox(
              width: 15,
            ),
            VxBuilder(
              mutations: {SetCartItem},
              // valueListenable: Hive.box<Product>(productBoxName).listenable(),
              builder: (context, store, index) {
                final box = (VxState.store as GroceStore).CartItemList;

                if (box.isEmpty)
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                        "after_login": ""
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).buttonColor),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                        color: Theme.of(context).primaryColor,
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
                      Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                        "after_login": ""
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).buttonColor),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ),
      );
    }

    Widget _responsiveAppBar() {
      if (ResponsiveLayout.isSmallScreen(context)) {
        return createHeaderForMobile();
      } else {
        return Header(false, false);
      }
    }

    Widget _firstHalfImage() {
      return Container(
        padding: EdgeInsets.only(left: 130, right: 130),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_isStock
                ? Consumer<CartCalculations>(
              builder: (_, cart, ch) =>
                  BadgeOfStock(
                    child: ch,
                    value: margins,
                    singleproduct: true,
                  ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      SingleProductImageScreen.routeName,
                      arguments: {
                        "itemid": itemid,
                        "itemname": itemname,
                        "itemimg": itemimg,
                        "fromScreen": fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
                        'notificationFor': notificationFor.toString(),
                      });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: GFCarousel(
                    autoPlay: true,
                    viewportFraction: 1.0,
                    height: 173,
                    pagination: true,
                    passiveIndicator: Colors.white,
                    activeIndicator:
                    Theme
                        .of(context)
                        .accentColor,
                    autoPlayInterval: Duration(seconds: 8),
                    items: <Widget>[
                      for (var i = 0;
                      i < multiimage.length;
                      i++)
                        Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              5.0)),
                                      child: CachedNetworkImage(
                                          imageUrl: multiimage[i].imageUrl,
                                          placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                          errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                          fit: BoxFit.fill))),
                            );
                          },
                        )
                    ],
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    SingleProductImageScreen.routeName,
                    arguments: {
                      "itemid": itemid,
                      "itemname": itemname,
                      "itemimg": itemimg,
                      "fromScreen":fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
                      'notificationFor': notificationFor.toString(),
                    });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: GFCarousel(
                  autoPlay: true,
                  viewportFraction: 1.0,
                  height: 173,
                  pagination: true,
                  passiveIndicator: Colors.white,
                  activeIndicator:
                  Theme
                      .of(context)
                      .accentColor,
                  autoPlayInterval: Duration(seconds: 8),
                  items: <Widget>[
                    for (var i = 0; i < multiimage.length; i++)
                      Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            5.0)),
                                    child: CachedNetworkImage(
                                      imageUrl: multiimage[i].imageUrl,
                                      placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                      errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                      fit: BoxFit.fill,
                                    )
                                )),
                          );
                        },
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _addButton() {
      return Container(
        //width: 500,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
/*            SizedBox(
              height: 10,
            ),*/
            (Features.isSubscription)?
            (singleitemData.singleitems[0].subscribe == "0")?
            _isStock?
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    //_dialogforSignIn();
                    LoginWeb(context,result: (sucsess){
                      if(sucsess){
                        Navigator.of(context).pop();
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
                      }else{
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  else {
                    (checkskip) ?
                    Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,arguments: {
                      "prev": "signupSelectionScreen",
                    }
                    ) :
                    Navigator.of(context).pushNamed(
                        SubscribeScreen.routeName,
                        arguments: {
                          "itemid": singleitemData.singleitems[0].id,
                          "itemname": singleitemData.singleitems[0].title,
                          "itemimg": singleitemData.singleitems[0].imageUrl,
                          "varname": varname+unit,
                          "varmrp":varmrp,
                          "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
                          "paymentMode": singleitemData.singleitems[0].paymentmode,
                          "cronTime": singleitemData.singleitems[0].cronTime,
                          "name": singleitemData.singleitems[0].name,
                          "varid": varid.toString(),
                          "brand": singleitemData.singleitems[0].brand
                        }
                    );
                  }

                },
                child: Container(
                  height: 30.0,
                  width: (MediaQuery.of(context).size.width / 8.5),
                  decoration: new BoxDecoration(
                    border:Border.all(color: ColorCodes.primaryColor),
                    color: ColorCodes.whiteColor,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                        bottomLeft: const Radius.circular(2.0),
                        bottomRight: const Radius.circular(2.0),
                      ),),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        S.current.subscribe,
                        style: TextStyle(
                            color: ColorCodes.primaryColor,
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ) ,
                ),
              ),
            ):
            SizedBox(height: 30,)
                :
            SizedBox(height: 30,):SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),
            _isStock
                ? Container(
              height: 30.0,
              width: (MediaQuery.of(context).size.width / 8.5),
              child: VxBuilder(
                mutations: {SetCartItem},
                builder: (context, store, index) {
                  final box = (VxState.store as GroceStore).CartItemList;
                  //debugPrint("qantity....single..3"+box.where((element) => element.varId==varid).first.quantity);
                 // if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                  if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAddToCart = true;
                        });
                        addToCart(int.parse(varminitem));
                      },
                      child: Container(
                        height: 30.0,
                        width: (MediaQuery.of(context).size.width / 4) + 15,
                        decoration:
                        new BoxDecoration(
                            color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
                            borderRadius:
                            new BorderRadius
                                .only(
                              topLeft:
                              const Radius.circular(
                                  2.0),
                              topRight:
                              const Radius.circular(
                                  2.0),
                              bottomLeft:
                              const Radius.circular(
                                  2.0),
                              bottomRight:
                              const Radius.circular(
                                  2.0),
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
                            :
                        (Features.isSubscription)?
                        Center(
                            child: Text(
                              S.current.buy_once,
                              style:
                              TextStyle(
                                color: ColorCodes.whiteColor,
                              ),
                              textAlign:
                              TextAlign
                                  .center,
                            )):
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                                child: Text(
                                    S.current.add,//'ADD',
                                  style:
                                  TextStyle(
                                    color: Theme
                                        .of(
                                        context)
                                        .buttonColor,
                                  ),
                                  textAlign:
                                  TextAlign
                                      .center,
                                )),
                            Spacer(),
                            Container(
                              decoration:
                              BoxDecoration(
                                  color:  ColorCodes.greenColor,
                                  borderRadius:
                                  new BorderRadius.only(
                                    topLeft:
                                    const Radius.circular(2.0),
                                    bottomLeft:
                                    const Radius.circular(2.0),
                                    topRight:
                                    const Radius.circular(2.0),
                                    bottomRight:
                                    const Radius.circular(2.0),
                                  )),
                              height: 50,
                              width: 25,
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors
                                    .white,
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
                              // setState(() {
                              //   _isAddToCart = true;
                              //  // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
                              // // cartcontroller.removecart();
                              // //   incrementToCart(_varQty - 1);
                              // });
                              if(int.parse(box.where((element) => element.varId==varid).first.quantity) > 0)
                                cartcontroller.update((done){
                                  setState(() {
                                    _isAddToCart = !done;
                                  });
                                },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);


                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                new BoxDecoration(
                                    border: Border
                                        .all(
                                      color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
                                    ),
                                    borderRadius:
                                    new BorderRadius.only(
                                      bottomLeft:
                                      const Radius.circular(2.0),
                                      topLeft:
                                      const Radius.circular(2.0),
                                    )),
                                child: Center(
                                  child: Text(
                                    "-",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      color: (Features.isSubscription)? ColorCodes.blackColor:ColorCodes.primaryColor,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: _isAddToCart ?
                            Container(
                              decoration:
                              BoxDecoration(
                                color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
                              ),
                              height: 30,
                              child: Center(
                                child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: new CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                              ),
                            )
                                :
                            Container(
                                decoration:
                                BoxDecoration(
                                  color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
                                ),
                                height: 30,
                                child: Center(
                                  child: Text(
                                    _varQty.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: (Features.isSubscription)? ColorCodes.blackColor:Theme
                                          .of(context)
                                          .buttonColor,
                                    ),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_varQty < int.parse(varstock)) {
                                if (_varQty < int.parse(varmaxitem)) {
                                  // setState(() {
                                  //   _isAddToCart = true;
                                  // });
                                  // // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
                                  // incrementToCart(_varQty + 1);
                                  cartcontroller.update((done){
                                    setState(() {
                                      _isAddToCart = !done;
                                    });
                                  },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);

                                } else {
                                  Fluttertoast.showToast(
                                      msg:  S.current.cant_add_more_item,
                                      fontSize: MediaQuery.of(context).textScaleFactor *13,
                                      backgroundColor: Colors.black87,
                                      textColor: Colors.white);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                    S.current.sorry_outofstock,
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                                    backgroundColor:
                                    Colors
                                        .black87,
                                    textColor:
                                    Colors
                                        .white);
                              }
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                new BoxDecoration(
                                    border: Border
                                        .all(
                                      color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
                                    ),
                                    borderRadius:
                                    new BorderRadius.only(
                                      bottomRight:
                                      const Radius.circular(2.0),
                                      topRight:
                                      const Radius.circular(2.0),
                                    )),
                                child: Center(
                                  child: Text(
                                    "+",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      color: (Features.isSubscription)? ColorCodes.blackColor:ColorCodes.greenColor,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );


                  /*try {
                    Product item = Hive
                        .box<
                        Product>(
                        productBoxName)
                        .values
                        .firstWhere((value) =>
                    value.varId ==
                        int.parse(varid));
                    return Container(
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isAddToCart = true;
                                incrementToCart(item.itemQty - 1);
                              });
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                new BoxDecoration(
                                    border: Border
                                        .all(
                                      color: ColorCodes.greenColor,
                                    ),
                                    borderRadius:
                                    new BorderRadius.only(
                                      bottomLeft:
                                      const Radius.circular(2.0),
                                      topLeft:
                                      const Radius.circular(2.0),
                                    )),
                                child: Center(
                                  child: Text(
                                    "-",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      color: ColorCodes.greenColor,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: _isAddToCart ?
                            Container(
                              decoration:
                              BoxDecoration(
                                color: ColorCodes.greenColor,
                              ),
                              height: 30,
                              child: Center(
                                child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: new CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                              ),
                            )
                                :
                            Container(
                                decoration:
                                BoxDecoration(
                                  color: ColorCodes.greenColor,
                                ),
                                height: 30,
                                child: Center(
                                  child: Text(
                                    item.itemQty.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor,
                                    ),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (item.itemQty < int.parse(varstock)) {
                                if (item.itemQty < int.parse(varmaxitem)) {
                                  setState(() {
                                    _isAddToCart = true;
                                  });
                                  incrementToCart(item.itemQty + 1);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Sorry, you can\'t add more of this item!",
                                      backgroundColor: Colors.black87,
                                      textColor: Colors.white);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                    "Sorry, Out of Stock!",
                                    backgroundColor:
                                    Colors
                                        .black87,
                                    textColor:
                                    Colors
                                        .white);
                              }
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                new BoxDecoration(
                                    border: Border
                                        .all(
                                      color: ColorCodes.greenColor,
                                    ),
                                    borderRadius:
                                    new BorderRadius.only(
                                      bottomRight:
                                      const Radius.circular(2.0),
                                      topRight:
                                      const Radius.circular(2.0),
                                    )),
                                child: Center(
                                  child: Text(
                                    "+",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      color: ColorCodes.greenColor,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAddToCart = true;
                        });
                        addToCart(int.parse(varminitem));
                      },
                      child: Container(
                        height: 30.0,
                        width: 50,
                        decoration:
                        new BoxDecoration(
                            color: ColorCodes.greenColor,
                            borderRadius:
                            new BorderRadius
                                .only(
                              topLeft:
                              const Radius.circular(
                                  2.0),
                              topRight:
                              const Radius.circular(
                                  2.0),
                              bottomLeft:
                              const Radius.circular(
                                  2.0),
                              bottomRight:
                              const Radius.circular(
                                  2.0),
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
                            :
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                                child: Text(
                                  S.current.add,//'ADD',
                                  style:
                                  TextStyle(
                                    color: Theme
                                        .of(
                                        context)
                                        .buttonColor,
                                  ),
                                  textAlign:
                                  TextAlign
                                      .center,
                                )),
                            Spacer(),
                            Container(
                              decoration:
                              BoxDecoration(
                                  color: Color(
                                      0xff1BA130),
                                  borderRadius:
                                  new BorderRadius.only(
                                    topLeft:
                                    const Radius.circular(2.0),
                                    bottomLeft:
                                    const Radius.circular(2.0),
                                    topRight:
                                    const Radius.circular(2.0),
                                    bottomRight:
                                    const Radius.circular(2.0),
                                  )),
                              height: 30,
                              width: 25,
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors
                                    .white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }*/
                },
              ),
            )
                : GestureDetector(
              onTap: () {


                if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                  //_dialogforSignIn();
                  LoginWeb(context,result: (sucsess){
                    if(sucsess){
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);
                    }else{
                      Navigator.of(context).pop();
                    }
                  });
                }
                else {
                  (checkskip ) ?
                  Navigator.of(context).pushNamed(
                    SignupSelectionScreen.routeName,arguments: {
                    "prev": "signupSelectionScreen",
                  }
                  ) :
                  _notifyMe();
                }
               /* checkskip
                    ? Navigator.of(context).pushNamed(
                  SignupSelectionScreen.routeName,
                )
                    : _notifyMe();*/

                // Fluttertoast.showToast(
                //     msg: S.current.you_will_notify" ,
                //     /*"Out Of Stock",*/
                //     fontSize: 12.0,
                //     backgroundColor:
                //     Colors.black87,
                //     textColor: Colors.white);
              },
              child: Container(
                height: 30.0,
                //width: (MediaQuery.of(context).size.width / 4) + 15,
                width: 160,
                decoration: new BoxDecoration(
                    border: Border.all(
                        color: Colors.grey),
                    color: Colors.grey,
                    borderRadius:
                    new BorderRadius.only(
                      topLeft: const Radius
                          .circular(2.0),
                      topRight: const Radius
                          .circular(2.0),
                      bottomLeft: const Radius
                          .circular(2.0),
                      bottomRight:
                      const Radius
                          .circular(2.0),
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
                          S.current.notify_me,
                          /*"ADD",*/
                          style: TextStyle(
                            /*fontWeight: FontWeight.w700,*/
                              color: Colors
                                  .white /*Colors.black87*/),
                          textAlign:
                          TextAlign.center,
                        )),
                    Spacer(),
                    Container(
                      decoration:
                      BoxDecoration(
                          color: Colors
                              .black12,
                          borderRadius:
                          new BorderRadius
                              .only(
                            topRight:
                            const Radius
                                .circular(
                                2.0),
                            bottomRight:
                            const Radius
                                .circular(
                                2.0),
                          )),
                      height: 50,
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
          ],
        ),
      );
    }

    Widget _addButton1() {
      return Container(
        child: Column(
          children: [
            _isStock
                ? Container(
              height: 40.0,
              width: (MediaQuery.of(context).size.width / 4) + 15,
              child: VxBuilder(
                mutations: {SetCartItem},
                // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                builder: (context, store, index) {
                  final box = (VxState.store as GroceStore).CartItemList;
                 // debugPrint("qantity....single..4"+box.where((element) => element.varId==varid).first.quantity);
                  if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAddToCart = true;
                        });
                        addToCart(int.parse(varminitem));
                      },
                      child: Container(
                        height: 30.0,
                        width: (MediaQuery.of(context).size.width / 4) + 15,
                        decoration:
                        new BoxDecoration(
                            color: ColorCodes.primaryColor,
                            borderRadius:
                            new BorderRadius
                                .only(
                              topLeft:
                              const Radius.circular(
                                  2.0),
                              topRight:
                              const Radius.circular(
                                  2.0),
                              bottomLeft:
                              const Radius.circular(
                                  2.0),
                              bottomRight:
                              const Radius.circular(
                                  2.0),
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
                            :
                        (Features.isSubscription)?
                        Center(
                            child: Text(
                              S.current.buy_once,
                              style:
                              TextStyle(
                                color: ColorCodes.whiteColor,
                              ),
                              textAlign:
                              TextAlign
                                  .center,
                            )):
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                                child: Text(
                                  S.current.add,//'ADD',
                                  style:
                                  TextStyle(
                                    color: Theme
                                        .of(
                                        context)
                                        .buttonColor,
                                  ),
                                  textAlign:
                                  TextAlign
                                      .center,
                                )),
                            Spacer(),
                            Container(
                              decoration:
                              BoxDecoration(
                                  color:  ColorCodes.greenColor,
                                  borderRadius:
                                  new BorderRadius.only(
                                    topLeft:
                                    const Radius.circular(2.0),
                                    bottomLeft:
                                    const Radius.circular(2.0),
                                    topRight:
                                    const Radius.circular(2.0),
                                    bottomRight:
                                    const Radius.circular(2.0),
                                  )),
                              height: 50,
                              width: 25,
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors
                                    .white,
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
                              if(int.parse(box.where((element) => element.varId==varid).first.quantity) > 0)
                                cartcontroller.update((done){
                                  setState(() {
                                    _isAddToCart = !done;
                                  });
                                },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                new BoxDecoration(
                                    border: Border
                                        .all(
                                      color: ColorCodes.primaryColor,
                                    ),
                                    borderRadius:
                                    new BorderRadius.only(
                                      bottomLeft:
                                      const Radius.circular(2.0),
                                      topLeft:
                                      const Radius.circular(2.0),
                                    )),
                                child: Center(
                                  child: Text(
                                    "-",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      color: ColorCodes.greenColor,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: _isAddToCart ?
                            Container(
                              decoration:
                              BoxDecoration(
                                color: ColorCodes.greenColor,
                              ),
                              height: 30,
                              child: Center(
                                child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: new CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                              ),
                            )
                                :
                            Container(
                                decoration:
                                BoxDecoration(
                                  color: ColorCodes.primaryColor,
                                ),
                                height: 30,
                                child: Center(
                                  child: Text(
                                    _varQty.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor,
                                    ),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_varQty < int.parse(varstock)) {
                                if (_varQty < int.parse(varmaxitem)) {
                                  cartcontroller.update((done){
                                    setState(() {
                                      _isAddToCart = !done;
                                    });
                                  },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);

                                } else {
                                  Fluttertoast.showToast(
                                      msg:  S.current.cant_add_more_item,
                                      fontSize: MediaQuery.of(context).textScaleFactor *13,
                                      backgroundColor: Colors.black87,
                                      textColor: Colors.white);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                    S.current.sorry_outofstock,
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                                    backgroundColor:
                                    Colors
                                        .black87,
                                    textColor:
                                    Colors
                                        .white);
                              }
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                new BoxDecoration(
                                    border: Border
                                        .all(
                                      color:ColorCodes.primaryColor,
                                    ),
                                    borderRadius:
                                    new BorderRadius.only(
                                      bottomRight:
                                      const Radius.circular(2.0),
                                      topRight:
                                      const Radius.circular(2.0),
                                    )),
                                child: Center(
                                  child: Text(
                                    "+",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      color: ColorCodes.primaryColor,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                },
              ),
            )
                : GestureDetector(
              onTap: () {

                if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                  //_dialogforSignIn();
                  LoginWeb(context,result: (sucsess){
                    if(sucsess){
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);
                    }else{
                      Navigator.of(context).pop();
                    }
                  });
                }
                else {
                  (checkskip ) ?
                  Navigator.of(context).pushNamed(
                    SignupSelectionScreen.routeName,arguments: {
                    "prev": "signupSelectionScreen",
                  }
                  ) :
                  _NotifyMe();
                }
                // Fluttertoast.showToast(
                //     msg: "You will be notified via SMS/Push notification, when the product is available" ,
                //    /* "Out Of Stock",*/
                //     fontSize: 12.0,
                //     backgroundColor:
                //     Colors.black87,
                //     textColor: Colors.white);
              },
              child: Container(
                height: 40.0,
                width: (MediaQuery.of(context).size.width / 4) + 15,
               // width: 160,
                decoration: new BoxDecoration(
                    border: Border.all(
                        color: Colors.grey),
                    color: Colors.grey,
                    borderRadius:
                    new BorderRadius.only(
                      topLeft: const Radius
                          .circular(2.0),
                      topRight: const Radius
                          .circular(2.0),
                      bottomLeft: const Radius
                          .circular(2.0),
                      bottomRight:
                      const Radius
                          .circular(2.0),
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
                    :Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Center(
                        child: Text(
                          S.current.notify_me,
                          /*"ADD",*/
                          style: TextStyle(
                            /*fontWeight: FontWeight.w700,*/
                              color: Colors
                                  .white /*Colors.black87*/),
                          textAlign:
                          TextAlign.center,
                        )),
                    Spacer(),
                    Container(
                      decoration:
                      BoxDecoration(
                          color: Colors
                              .black12,
                          borderRadius:
                          new BorderRadius
                              .only(
                            topRight:
                            const Radius
                                .circular(
                                2.0),
                            bottomRight:
                            const Radius
                                .circular(
                                2.0),
                          )),
                      height: 50,
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
          ],
        ),
      );
    }

    /* _quantityPopup() {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                  //height: 200,
                  width: MediaQuery.of(context).size.width / 3.0,
                  //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            color: ColorCodes.lightGreyWebColor,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Select your quantity",
                                  style: TextStyle(
                                      color: ColorCodes.mediumBlackColor,
                                      fontSize: 20.0),
                                )),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: singleitemvar.length,
                              itemBuilder: (_, i) =>
                                  GestureDetector(
                                    onTap: () {
                                      for (int k = 0;
                                      k < singleitemvar.length;
                                      k++) {
                                        if (i == k) {
                                          singleitemvar[k].varcolor =
                                              Color(0xff012961);
                                        } else {
                                          singleitemvar[k].varcolor =
                                              Color(0xffBEBEBE);
                                        }
                                        setState(() {
                                          varmemberprice = singleitemvar[i].varmemberprice;
                                          varmrp = singleitemvar[i].varmrp;
                                          varprice = singleitemvar[i].varprice;
                                          varid = singleitemvar[i].varid;
                                          varname = singleitemvar[i].varname;
                                          varstock = singleitemvar[i].varstock;
                                          varminitem = singleitemvar[i].varminitem;
                                          varmaxitem = singleitemvar[i].varmaxitem;
                                          varLoyalty = singleitemvar[i].varLoyalty;
                                          _varQty = singleitemvar[i].varQty;
                                          varcolor = singleitemvar[i].varcolor;
                                          discountDisplay = singleitemvar[i].discountDisplay;
                                          memberpriceDisplay = singleitemvar[i].membershipDisplay;

                                          if (varmemberprice == '-' ||
                                              varmemberprice == "0") {
                                            setState(() {
                                              membershipdisplay = false;
                                            });
                                          } else {
                                            membershipdisplay = true;
                                          }

                                          if (_checkmembership) {
                                            if (varmemberprice.toString() ==
                                                '-' ||
                                                double.parse(
                                                    varmemberprice) <=
                                                    0) {
                                              if (double.parse(varmrp) <=
                                                  0 ||
                                                  double.parse(varprice) <=
                                                      0) {
                                                margins = "0";
                                              } else {
                                                var difference =
                                                (double.parse(varmrp) -
                                                    double.parse(
                                                        varprice));
                                                var profit = difference /
                                                    double.parse(varmrp);
                                                margins = profit * 100;

                                                //discount price rounding
                                                margins = num.parse(margins
                                                    .toStringAsFixed(0));
                                                margins =
                                                    margins.toString();
                                              }
                                            } else {
                                              var difference =
                                              (double.parse(varmrp) -
                                                  double.parse(
                                                      varmemberprice));
                                              var profit = difference /
                                                  double.parse(varmrp);
                                              margins = profit * 100;

                                              //discount price rounding
                                              margins = num.parse(margins
                                                  .toStringAsFixed(0));
                                              margins = margins.toString();
                                            }
                                          } else {
                                            if (double.parse(varmrp) <= 0 ||
                                                double.parse(varprice) <=
                                                    0) {
                                              margins = "0";
                                            } else {
                                              var difference =
                                              (double.parse(varmrp) -
                                                  double.parse(
                                                      varprice));
                                              var profit = difference /
                                                  double.parse(varmrp);
                                              margins = profit * 100;

                                              //discount price rounding
                                              margins = num.parse(margins
                                                  .toStringAsFixed(0));
                                              margins = margins.toString();
                                            }
                                          }

                                          if (margins == "NaN") {
                                            _checkmargin = false;
                                          } else {
                                            if (int.parse(margins) <= 0) {
                                              _checkmargin = false;
                                            } else {
                                              _checkmargin = true;
                                            }
                                          }
                                          multiimage =
                                              Provider.of<ItemsList>(context, listen: false)
                                                  .findByIdmulti(varid);
                                          _displayimg =
                                              multiimage[0].imageUrl;
                                          for (int j = 0;
                                          j < multiimage.length;
                                          j++) {
                                            if (j == 0) {
                                              multiimage[j].varcolor =
                                                  Color(0xff114475);
                                            } else {
                                              multiimage[j].varcolor =
                                                  Color(0xffBEBEBE);
                                            }
                                          }
                                        });
                                      }
                                      setState(() {
                                        if (int.parse(varstock) <= 0) {
                                          _isStock = false;
                                        } else {
                                          _isStock = true;
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
//                                              Spacer(),
                                        _checkmargin
                                            ? Consumer<Calculations>(
                                          builder: (_, cart, ch) =>
                                              Align(
                                                alignment:
                                                Alignment.topLeft,
                                                child: BadgeDiscount(
                                                  child: ch,
                                                  value: */
    /*margins*/
    /*_varMarginList[i],
                                                ),
                                              ),
                                          child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              // width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.center,
                                              height: 60.0,
                                              //width: 290,
                                              margin: EdgeInsets.only(bottom: 10.0),
                                              decoration:
                                              BoxDecoration(
                                                  color: ColorCodes.fill,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  border: Border(
                                                    top: BorderSide(
                                                        width:
                                                        1.0,
                                                        color: singleitemvar[
                                                        i]
                                                            .varcolor),
                                                    bottom: BorderSide(
                                                        width:
                                                        1.0,
                                                        color: singleitemvar[
                                                        i]
                                                            .varcolor),
                                                    left: BorderSide(
                                                        width:
                                                        1.0,
                                                        color: singleitemvar[
                                                        i]
                                                            .varcolor),
                                                    right: BorderSide(
                                                        width:
                                                        1.0,
                                                        color: singleitemvar[
                                                        i]
                                                            .varcolor),
                                                  )),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    singleitemvar[i]
                                                        .varname,
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                      fontSize:
                                                      14, */
    /*color: singleitemvar[i].varcolor*/
    /*
                                                    ),
                                                  ),
                                                  Container(
                                                      child: Row(
                                                        children: <
                                                            Widget>[
                                                          _checkmembership
                                                              ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <
                                                                Widget>[
                                                              memberpriceDisplay
                                                                  ? Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width: 25.0,
                                                                        height: 25.0,
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .starImg,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          _currencyFormat +
                                                                              singleitemvar[i]
                                                                                  .varmemberprice,
                                                                          style: new TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 14.0)),
                                                                    ],
                                                                  ),
                                                                  Text(_currencyFormat +
                                                                      singleitemvar[i]
                                                                          .varmrp,
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize: 10.0)),
                                                                ],
                                                              )
                                                                  : discountDisplay
                                                                  ? Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width: 25.0,
                                                                        height: 25.0,
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .starImg,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          _currencyFormat +
                                                                              singleitemvar[i]
                                                                                  .varprice,
                                                                          style: new TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 14.0)),
                                                                    ],
                                                                  ),
                                                                  Text(_currencyFormat +
                                                                      singleitemvar[i]
                                                                          .varmrp,
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize: 10.0)),
                                                                ],
                                                              )
                                                                  : Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width: 25.0,
                                                                        height: 25.0,
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .starImg,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          _currencyFormat +
                                                                              singleitemvar[i]
                                                                                  .varmrp,
                                                                          style: new TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 14.0)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                              : discountDisplay
                                                              ? Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Text(_currencyFormat +
                                                                  singleitemvar[i]
                                                                      .varprice,
                                                                  style: new TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 14.0)),
                                                              Text(_currencyFormat +
                                                                  singleitemvar[i]
                                                                      .varmrp,
                                                                  style: TextStyle(
                                                                      decoration: TextDecoration
                                                                          .lineThrough,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize: 10.0)),
                                                            ],
                                                          )
                                                              : Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Text(_currencyFormat +
                                                                  singleitemvar[i]
                                                                      .varmrp,
                                                                  style: new TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 14.0)),
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                  (_isWeb)?handler(i): Icon(
                                                      Icons
                                                          .radio_button_checked_outlined,
                                                      color:
                                                      singleitemvar[
                                                      i]
                                                          .varcolor)
                                                ],
                                              )),
                                        )
                                            : Container(
                                            padding: EdgeInsets.all(10.0),
                                            //width:290,
                                            //height: 60.0,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(bottom: 10.0),
                                            decoration: BoxDecoration(
                                                color: ColorCodes.fill,
                                                borderRadius: BorderRadius.circular(5.0),
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: singleitemvar[i].varcolor),
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: singleitemvar[i].varcolor),
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color:
                                                      singleitemvar[
                                                      i]
                                                          .varcolor),
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color:
                                                      singleitemvar[
                                                      i]
                                                          .varcolor),
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  singleitemvar[i]
                                                      .varname,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize:
                                                    14, */
    /*color: singleitemvar[i].varcolor*/
    /*
                                                  ),
                                                ),
                                                Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        _checkmembership
                                                            ? Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: <
                                                              Widget>[
                                                            memberpriceDisplay
                                                                ? Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 25.0,
                                                                      height: 25.0,
                                                                      child: Image
                                                                          .asset(
                                                                        Images.starImg,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        _currencyFormat +
                                                                            singleitemvar[i]
                                                                                .varmemberprice,
                                                                        style: new TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                ),
                                                                Text(_currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varmrp,
                                                                    style: TextStyle(
                                                                        decoration: TextDecoration
                                                                            .lineThrough,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize: 10.0)),
                                                              ],
                                                            )
                                                                : discountDisplay
                                                                ? Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 25.0,
                                                                      height: 25.0,
                                                                      child: Image
                                                                          .asset(
                                                                        Images.starImg,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        _currencyFormat +
                                                                            singleitemvar[i]
                                                                                .varprice,
                                                                        style: new TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                ),
                                                                Text(_currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varmrp,
                                                                    style: TextStyle(
                                                                        decoration: TextDecoration
                                                                            .lineThrough,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize: 10.0)),
                                                              ],
                                                            )
                                                                : Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 25.0,
                                                                      height: 25.0,
                                                                      child: Image
                                                                          .asset(
                                                                        Images.starImg,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        _currencyFormat +
                                                                            singleitemvar[i]
                                                                                .varmrp,
                                                                        style: new TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                            : discountDisplay
                                                            ? Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                                _currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varprice,
                                                                style: new TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: Colors.black,
                                                                    fontSize: 14.0)),
                                                            Text(
                                                                _currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varmrp,
                                                                style: TextStyle(
                                                                    decoration: TextDecoration
                                                                        .lineThrough,
                                                                    color: Colors.grey,
                                                                    fontSize: 10.0)),
                                                          ],
                                                        )
                                                            : Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                                _currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varmrp,
                                                                style: new TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: Colors.black,
                                                                    fontSize: 14.0)),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                (_isWeb)?handler(i): Icon(
                                                    Icons
                                                        .radio_button_checked_outlined,
                                                    color:
                                                    singleitemvar[i]
                                                        .varcolor)
                                              ],
                                            ))
//                                              Spacer(),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _addButton(),
                              SizedBox(width: 20),
                            ],
                          ),

                          SizedBox(height: 20),
                        ]),
                  ),
                ),
              );
            });
          });
    }*/

    _quantityPopup() {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                  //height: 200,
                  width: MediaQuery.of(context).size.width / 3.0,
                  //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            color: ColorCodes.lightGreyWebColor,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  S.current.select_your_quantity,
                                  style: TextStyle(
                                      color: ColorCodes.mediumBlackColor,
                                      fontSize: 20.0),
                                )),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: singleitemvar.length,
                              itemBuilder: (_, i) =>
                                  GestureDetector(
                                    onTap: () {
                                      for (int k = 0;
                                      k < singleitemvar.length;
                                      k++) {
                                        if (i == k) {
                                          singleitemvar[k].varcolor =
                                              ColorCodes.discountoff;
                                        } else {
                                          singleitemvar[k].varcolor =
                                              ColorCodes.lightgrey;
                                        }
                                        setState(() {
                                          varmemberprice = singleitemvar[i].varmemberprice;
                                          varmrp = singleitemvar[i].varmrp;
                                          varprice = singleitemvar[i].varprice;
                                          varid = singleitemvar[i].varid;
                                          vsize =singleitemvar[i].size;
                                          varname = singleitemvar[i].varname;
                                          unit =singleitemvar[i].unit;
                                          color = singleitemvar[i].color;
                                          fit = singleitemvar[i].fit;
                                          varstock = singleitemvar[i].varstock;
                                          varminitem = singleitemvar[i].varminitem;
                                          varmaxitem = singleitemvar[i].varmaxitem;
                                          varLoyalty = singleitemvar[i].varLoyalty;
                                          _varQty = singleitemvar[i].varQty;
                                          varcolor = singleitemvar[i].varcolor;
                                          discountDisplay = singleitemvar[i].discountDisplay;
                                          memberpriceDisplay = singleitemvar[i].membershipDisplay;

                                          /*if (varmemberprice == '-' || varmemberprice == "0") {
                                            setState(() {
                                              membershipdisplay = false;
                                            });
                                          } else {
                                            membershipdisplay = true;
                                          }*/

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

                                          if (margins == "NaN") {
                                            _checkmargin = false;
                                          } else {
                                            if (int.parse(margins) <= 0) {
                                              _checkmargin = false;
                                            } else {
                                              _checkmargin = true;
                                            }
                                          }
                                          multiimage =
                                              Provider.of<ItemsList>(context, listen: false)
                                                  .findByIdmulti(varid);
                                          _displayimg =
                                              multiimage[0].imageUrl;
                                          for (int j = 0;
                                          j < multiimage.length;
                                          j++) {
                                            if (j == 0) {
                                              multiimage[j].varcolor =
                                                  ColorCodes.primaryColor;
                                            } else {
                                              multiimage[j].varcolor =
                                                  ColorCodes.lightgrey;
                                            }
                                          }
                                        });
                                      }
                                      setState(() {
                                        if (int.parse(varstock) <= 0) {
                                          _isStock = false;
                                        } else {
                                          _isStock = true;
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
//                                              Spacer(),
                                        _checkmargin
                                            ? Consumer<CartCalculations>(
                                          builder: (_, cart, ch) =>
                                              Align(
                                                alignment:
                                                Alignment.topLeft,
                                                child: BadgeDiscount(
                                                  child: ch,
                                                  value: /*margins*/_varMarginList[i],
                                                ),
                                              ),
                                          child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              // width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.center,
                                              height: 60.0,
                                              //width: 290,
                                              margin: EdgeInsets.only(bottom: 10.0),
                                              decoration:
                                              BoxDecoration(
                                                  color: ColorCodes.fill,
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: singleitemvar[i].varcolor),
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color: singleitemvar[i].varcolor),
                                                    left: BorderSide(
                                                        width: 1.0,
                                                        color: singleitemvar[i].varcolor),
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: singleitemvar[i].varcolor),
                                                  )),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    singleitemvar[i]
                                                        .varname+" "+singleitemvar[i].unit,
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                      fontSize:
                                                      14, /*color: singleitemvar[i].varcolor*/
                                                    ),
                                                  ),
                                                  Container(
                                                      child: Row(
                                                        children: <
                                                            Widget>[
                                                          _checkmembership
                                                              ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <
                                                                Widget>[
                                                              memberpriceDisplay
                                                                  ? Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width: 25.0,
                                                                        height: 25.0,
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .starImg,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          IConstants.currencyFormat + singleitemvar[i].varmemberprice,
                                                                          style: new TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: 14.0)),
                                                                    ],
                                                                  ),
                                                                  Text(IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize: 10.0)),
                                                                ],
                                                              )
                                                                  : Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width: 25.0,
                                                                        height: 25.0,
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .starImg,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          IConstants.currencyFormat + singleitemvar[i].varprice,
                                                                          style: new TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                              fontSize: 14.0)
                                                                          ),
                                                                    ],
                                                                  ),
                                                                  if(discountDisplay)
                                                                    Text(IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize: 10.0)),
                                                                ],
                                                              )

                                                            ],
                                                          )
                                                              :/* discountDisplay
                                                              ? */Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Text(IConstants.currencyFormat +
                                                                  singleitemvar[i]
                                                                      .varprice,
                                                                  style: new TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 14.0)),
                                                              if(discountDisplay)
                                                              Text(IConstants.currencyFormat +
                                                                  singleitemvar[i]
                                                                      .varmrp,
                                                                  style: TextStyle(
                                                                      decoration: TextDecoration
                                                                          .lineThrough,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize: 10.0)),
                                                            ],
                                                          )
                                                             /* : Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Text(IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                  style: new TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 14.0)),
                                                            ],
                                                          )*/
                                                        ],
                                                      )),
                                                  Icon(
                                                      Icons.radio_button_checked_outlined,
                                                      color: singleitemvar[i].varcolor)
                                                ],
                                              )),
                                        )
                                            : Container(
                                            padding: EdgeInsets.all(10.0),
                                            //width:290,
                                            //height: 60.0,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(bottom: 10.0),
                                            decoration: BoxDecoration(
                                                color: ColorCodes.fill,
                                                borderRadius: BorderRadius.circular(5.0),
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: singleitemvar[i].varcolor),
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: singleitemvar[i].varcolor),
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color:
                                                      singleitemvar[
                                                      i]
                                                          .varcolor),
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color:
                                                      singleitemvar[
                                                      i]
                                                          .varcolor),
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  singleitemvar[i]
                                                      .varname+" "+singleitemvar[i].unit,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize:
                                                    14, /*color: singleitemvar[i].varcolor*/
                                                  ),
                                                ),
                                                Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        _checkmembership
                                                            ? Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: <
                                                              Widget>[
                                                            memberpriceDisplay
                                                                ? Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 25.0,
                                                                      height: 25.0,
                                                                      child: Image
                                                                          .asset(
                                                                        Images.starImg,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        IConstants.currencyFormat + singleitemvar[i].varmemberprice,
                                                                        style: new TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                ),
                                                                Text(IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                    style: TextStyle(
                                                                        decoration: TextDecoration
                                                                            .lineThrough,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize: 10.0)),
                                                              ],
                                                            )
                                                                : discountDisplay
                                                                ? Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 25.0,
                                                                      height: 25.0,
                                                                      child: Image
                                                                          .asset(
                                                                        Images.starImg,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        IConstants.currencyFormat +
                                                                            singleitemvar[i]
                                                                                .varprice,
                                                                        style: new TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                ),
                                                                Text(IConstants.currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varmrp,
                                                                    style: TextStyle(
                                                                        decoration: TextDecoration
                                                                            .lineThrough,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize: 10.0)),
                                                              ],
                                                            )
                                                                : Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 25.0,
                                                                      height: 25.0,
                                                                      child: Image
                                                                          .asset(
                                                                        Images.starImg,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        IConstants.currencyFormat +
                                                                            singleitemvar[i]
                                                                                .varmrp,
                                                                        style: new TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                            : discountDisplay
                                                            ? Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                                IConstants.currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varprice,
                                                                style: new TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: Colors.black,
                                                                    fontSize: 14.0)),
                                                            Text(
                                                                IConstants.currencyFormat +
                                                                    singleitemvar[i]
                                                                        .varmrp,
                                                                style: TextStyle(
                                                                    decoration: TextDecoration
                                                                        .lineThrough,
                                                                    color: Colors.grey,
                                                                    fontSize: 10.0)),
                                                          ],
                                                        )
                                                            : Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                                IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                style: new TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: Colors.black,
                                                                    fontSize: 14.0)),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Icon(
                                                    Icons
                                                        .radio_button_checked_outlined,
                                                    color:
                                                    singleitemvar[i]
                                                        .varcolor)
                                              ],
                                            ))
//                                              Spacer(),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _addButton(),
                              SizedBox(width: 20),
                            ],
                          ),

                          SizedBox(height: 20),
                        ]),
                  ),
                ),
              );
            });
          });
    }
    Widget productvariation(int i){
  for (int k = 0;
  k < singleitemvar.length;
  k++) {
    if (i == k) {
      setState(() {
        singleitemvar[k].varcolor =
            ColorCodes.discountoff;
      });
    } else {
      setState(() {
      singleitemvar[k].varcolor =
          ColorCodes.lightgrey;
      });
    }
    setState(() {
      varmemberprice =
          singleitemvar[i]
              .varmemberprice;
      varmrp = singleitemvar[i].varmrp;
      varprice =
          singleitemvar[i].varprice;
      varid = singleitemvar[i].varid;
      vsize =singleitemvar[i].size;
      varname =
          singleitemvar[i].varname;
      unit =singleitemvar[i].unit;
      color =singleitemvar[i].color;
      fit = singleitemvar[i].fit;
      varstock =
          singleitemvar[i].varstock;
      varminitem =
          singleitemvar[i].varminitem;
      varmaxitem =
          singleitemvar[i].varmaxitem;
      varLoyalty =
          singleitemvar[i].varLoyalty;
      _varQty = singleitemvar[i].varQty;
      varcolor =
          singleitemvar[i].varcolor;
      discountDisplay =
          singleitemvar[i]
              .discountDisplay;
      memberpriceDisplay =
          singleitemvar[i]
              .membershipDisplay;

      /*if (varmemberprice == '-' || varmemberprice == "0") {
        setState(() {
          membershipdisplay = false;
        });
      } else {
        membershipdisplay = true;
      }*/

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
      if (margins == "NaN") {
        _checkmargin = false;
      } else {
        if (int.parse(margins) <= 0) {
          _checkmargin = false;
        } else {
          _checkmargin = true;
        }
      }
      multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
      _displayimg = multiimage[0].imageUrl;
      for (int j = 0; j < multiimage.length; j++) {
        if (j == 0) {
          setState(() {
            multiimage[j].varcolor = ColorCodes.primaryColor;
          });
        } else {
          setState(() {
          multiimage[j].varcolor = ColorCodes.lightgrey;
          });
        }
      }
    });
  }
  setState(() {
    if (int.parse(varstock) <= 0) {
      _isStock = false;
    } else {
      _isStock = true;
    }
  });
}
    Widget  quantityPopup1() {
       showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Container(
                    //height: 200,
                    width: 800,
                    //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  //   color: ColorCodes.lightGreyWebColor,
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        S.current.select_your_quantity,
                                        style: TextStyle(
                                            color: ColorCodes.mediumBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
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
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: singleitemvar.length,
                                itemBuilder: (_, i) =>
                                    GestureDetector(
                                      onTap: () {
                                        setState((){
                                          productvariation(i);
                                        });
                                      },
                                      child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      singleitemvar[i]
                                                          .varname+" "+singleitemvar[i].unit,
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color:Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold/*color: singleitemvar[i].varcolor*/
                                                      ),
                                                    ),
                                                    SizedBox(width: 3,),
                                                    Text(
                                                      "-",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                        14, /*color: singleitemvar[i].varcolor*/
                                                      ),
                                                    ),
                                                    SizedBox(width: 3,),
                                                    Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            _checkmembership
                                                                ? Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: <
                                                                  Widget>[
                                                                memberpriceDisplay
                                                                    ? Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width: 25.0,
                                                                          height: 25.0,
                                                                          child: Image
                                                                              .asset(
                                                                            Images.starImg,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            IConstants.currencyFormat +
                                                                                singleitemvar[i]
                                                                                    .varmemberprice,
                                                                            style: new TextStyle(
                                                                                fontWeight: FontWeight
                                                                                    .bold,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontSize: 14.0)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(width: 10,),
                                                                    Text(IConstants.currencyFormat +
                                                                        singleitemvar[i]
                                                                            .varmrp,
                                                                        style: TextStyle(
                                                                            decoration: TextDecoration
                                                                                .lineThrough,
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize: 10.0)),
                                                                  ],
                                                                )
                                                                    : discountDisplay
                                                                    ? Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width: 25.0,
                                                                          height: 25.0,
                                                                          child: Image
                                                                              .asset(
                                                                            Images.starImg,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            IConstants.currencyFormat + singleitemvar[i].varprice,
                                                                            style: new TextStyle(
                                                                                fontWeight: FontWeight
                                                                                    .bold,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontSize: 14.0)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(width: 10,),
                                                                    Text(IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                        style: TextStyle(
                                                                            decoration: TextDecoration
                                                                                .lineThrough,
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize: 14.0)),
                                                                  ],
                                                                )
                                                                    : Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width: 25.0,
                                                                          height: 25.0,
                                                                          child: Image
                                                                              .asset(
                                                                            Images.starImg,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            IConstants.currencyFormat + singleitemvar[i].varmrp,
                                                                            style: new TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                                fontSize: 14.0)),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                                : discountDisplay
                                                                ? Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                    IConstants.currencyFormat +
                                                                        singleitemvar[i]
                                                                            .varprice,
                                                                    style: new TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors.black,
                                                                        fontSize: 14.0)),
                                                                SizedBox(width: 10,),
                                                                Text(
                                                                    IConstants.currencyFormat +
                                                                        singleitemvar[i]
                                                                            .varmrp,
                                                                    style: TextStyle(
                                                                        decoration: TextDecoration
                                                                            .lineThrough,
                                                                        color: Colors.grey,
                                                                        fontSize: 14.0)),
                                                              ],
                                                            )
                                                                : Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                    IConstants.currencyFormat +
                                                                        singleitemvar[i]
                                                                            .varmrp,
                                                                    style: new TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors.black,
                                                                        fontSize: 14.0)),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                Container(
                                                  child: handler(i),
                                                ),
                                              ],
                                            )),
                                    ),
                              ),
                            ),
                            (Features.isSubscription)?
                            (singleitemData.singleitems[0].subscribe == "0")?
                            _isStock?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                        //_dialogforSignIn();
                                        LoginWeb(context,result: (sucsess){
                                          if(sucsess){
                                            Navigator.of(context).pop();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, HomeScreen.routeName, (route) => false);
                                          }else{
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      }
                                      else {
                                        (checkskip) ?
                                        Navigator.of(context).pushNamed(
                                          SignupSelectionScreen.routeName,arguments: {
                                          "prev": "signupSelectionScreen",
                                        }
                                        ) :
                                        Navigator.of(context).pushNamed(
                                            SubscribeScreen.routeName,
                                            arguments: {
                                              "itemid": singleitemData.singleitems[0].id,
                                              "itemname": singleitemData.singleitems[0].title,
                                              "itemimg": singleitemData.singleitems[0].imageUrl,
                                              "varname": varname+unit,
                                              "varmrp":varmrp,
                                              "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
                                              "paymentMode": singleitemData.singleitems[0].paymentmode,
                                              "cronTime": singleitemData.singleitems[0].cronTime,
                                              "name": singleitemData.singleitems[0].name,
                                              "varid": varid.toString(),
                                              "brand": singleitemData.singleitems[0].brand
                                            }
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: (MediaQuery.of(context)
                                          .size.width / 4) +15,
                                      decoration: new BoxDecoration(
                                          border: Border.all(color: ColorCodes.primaryColor),
                                          color: ColorCodes.whiteColor,
                                          borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(2.0),
                                            topRight: const Radius.circular(2.0),
                                            bottomLeft: const Radius.circular(2.0),
                                            bottomRight: const Radius.circular(2.0),
                                          )),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Text(
                                            S.current.subscribe,
                                            style: TextStyle(
                                                color:ColorCodes.primaryColor,
                                                fontSize: 12, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ) ,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ):
                            SizedBox(height: 30,)
                                :
                            SizedBox(height: 30,):SizedBox.shrink(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                               // _addButton1(),

                                Container(
                                  child: Column(
                                    children: [
                                      _isStock
                                          ? Container(
                                        height: 40.0,
                                        width: (MediaQuery.of(context).size.width / 4) + 15,
                                        child:VxBuilder(
                                          mutations: {SetCartItem},
                                          // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                          builder: (context, store, index) {
                                            final box = (VxState.store as GroceStore).CartItemList;
                                           // debugPrint("qantity....single..6"+box.where((element) => element.varId==varid).first.quantity);
                                           // if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                                            if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isAddToCart = true;
                                                  });
                                                  addToCart(int.parse(varminitem));
                                                },
                                                child: Container(
                                                  height: 30.0,
                                                  width: (MediaQuery.of(context).size.width / 4) + 15,
                                                  decoration:
                                                  new BoxDecoration(
                                                      color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
                                                      borderRadius:
                                                      new BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            2.0),
                                                        topRight:
                                                        const Radius.circular(
                                                            2.0),
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            2.0),
                                                        bottomRight:
                                                        const Radius.circular(
                                                            2.0),
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
                                                      :
                                                  (Features.isSubscription)?
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                                             Text(
                                                                                                              S.current.buy_once,
                                                                                                              style:
                                                                                                              TextStyle(
                                                                                                                color: ColorCodes.whiteColor,
                                                                                                              ),
                                                                                                              textAlign:
                                                                                                              TextAlign
                                                                                                                  .center,
                                                                                                            ),

                                                    ],
                                                  )
                                                  :Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                            S.current.add,
                                                            style:
                                                            TextStyle(
                                                              color: Theme
                                                                  .of(
                                                                  context)
                                                                  .buttonColor,
                                                            ),
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                          )),
                                                      Spacer(),
                                                      Container(
                                                        decoration:
                                                        BoxDecoration(
                                                            color: ColorCodes.primaryColor,
                                                            borderRadius:
                                                            new BorderRadius.only(
                                                              topLeft:
                                                              const Radius.circular(2.0),
                                                              bottomLeft:
                                                              const Radius.circular(2.0),
                                                              topRight:
                                                              const Radius.circular(2.0),
                                                              bottomRight:
                                                              const Radius.circular(2.0),
                                                            )),
                                                        height: 50,
                                                        width: 25,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 12,
                                                          color: Colors
                                                              .white,
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
                                                        // setState(() {
                                                        //   _isAddToCart = true;
                                                        //   incrementToCart(_varQty - 1);
                                                        // });
                                                        // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
                                                        if(int.parse(box.where((element) => element.varId==varid).first.quantity) > 0)
                                                          cartcontroller.update((done){
                                                            setState(() {
                                                              _isAddToCart = !done;
                                                            });
                                                          },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);

                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                          new BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color:(Features.isSubscription)?ColorCodes.primaryColor : ColorCodes.primaryColor,
                                                              ),
                                                              borderRadius:
                                                              new BorderRadius.only(
                                                                bottomLeft:
                                                                const Radius.circular(2.0),
                                                                topLeft:
                                                                const Radius.circular(2.0),
                                                              )),
                                                          child: Center(
                                                            child: Text(
                                                              "-",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style:
                                                              TextStyle(
                                                                color: (Features.isSubscription)?ColorCodes.blackColor :ColorCodes.primaryColor,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: _isAddToCart ?
                                                      Container(
                                                        decoration:
                                                        BoxDecoration(
                                                          color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
                                                        ),
                                                        height: 30,
                                                        child: Center(
                                                          child: SizedBox(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              child: new CircularProgressIndicator(
                                                                strokeWidth: 2.0,
                                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                                        ),
                                                      )
                                                          :
                                                      Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
                                                          ),
                                                          height: 30,
                                                          child: Center(
                                                            child: Text(
                                                              _varQty.toString(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: (Features.isSubscription)?ColorCodes.whiteColor :Theme
                                                                    .of(context)
                                                                    .buttonColor,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (_varQty < int.parse(varstock)) {
                                                          if (_varQty < int.parse(varmaxitem)) {
                                                            // setState(() {
                                                            //   _isAddToCart = true;
                                                            // });
                                                            // // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
                                                            // incrementToCart(_varQty + 1);
                                                            cartcontroller.update((done){
                                                              setState(() {
                                                                _isAddToCart = !done;
                                                              });
                                                            },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:  S.current.cant_add_more_item,
                                                                fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                                backgroundColor: Colors.black87,
                                                                textColor: Colors.white);
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                              S.current.sorry_outofstock,
                                                              fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                              backgroundColor:
                                                              Colors
                                                                  .black87,
                                                              textColor:
                                                              Colors
                                                                  .white);
                                                        }
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                          new BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color:(Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
                                                              ),
                                                              borderRadius:
                                                              new BorderRadius.only(
                                                                bottomRight:
                                                                const Radius.circular(2.0),
                                                                topRight:
                                                                const Radius.circular(2.0),
                                                              )),
                                                          child: Center(
                                                            child: Text(
                                                              "+",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style:
                                                              TextStyle(
                                                                color: (Features.isSubscription)?ColorCodes.blackColor :ColorCodes.primaryColor,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                          },
                                        ),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          checkskip
                                              ? Navigator.of(context).pushNamed(
                                            SignupSelectionScreen.routeName,arguments: {
                                            "prev": "signupSelectionScreen",
                                          }
                                          )
                                              : _notifyMe();
                                          // Fluttertoast.showToast(
                                          //     msg: "You will be notified via SMS/Push notification, when the product is available" ,
                                          //     /*"Out Of Stock",*/
                                          //     fontSize: 12.0,
                                          //     backgroundColor:
                                          //     Colors.black87,
                                          //     textColor: Colors.white);
                                        },
                                        child: Container(
                                          height: 40.0,
                                          width: (MediaQuery.of(context).size.width / 4) + 15,
                                          // width: 160,
                                          decoration: new BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.grey,
                                              borderRadius:
                                              new BorderRadius.only(
                                                topLeft: const Radius
                                                    .circular(2.0),
                                                topRight: const Radius
                                                    .circular(2.0),
                                                bottomLeft: const Radius
                                                    .circular(2.0),
                                                bottomRight:
                                                const Radius
                                                    .circular(2.0),
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
                                                    S.current.notify_me,
                                                    /*"ADD",*/
                                                    style: TextStyle(
                                                      /*fontWeight: FontWeight.w700,*/
                                                        color: Colors
                                                            .white /*Colors.black87*/),
                                                    textAlign:
                                                    TextAlign.center,
                                                  )),
                                              Spacer(),
                                              Container(
                                                decoration:
                                                BoxDecoration(
                                                    color: Colors
                                                        .black12,
                                                    borderRadius:
                                                    new BorderRadius
                                                        .only(
                                                      topRight:
                                                      const Radius
                                                          .circular(
                                                          2.0),
                                                      bottomRight:
                                                      const Radius
                                                          .circular(
                                                          2.0),
                                                    )),
                                                height: 50,
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
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),

                            SizedBox(height: 20),
                          ]),

                  ));
            });

         })
          .then((_) => setState(() {
        singleitemData.clear();
        singleitemvar.clear();
      }));
    }

    Widget _footer() {
      if(_isWeb) {
        return Footer(
          address: PrefUtils.prefs.getString("restaurant_address"),
        );
      } else {
        return SizedBox.shrink();
      }
    }

    Widget webBody() {
      return SafeArea(
        child: _isLoading
            ? Center(
          child: new CircularProgressIndicator(),
        )
            : Column(
          children: [
            _responsiveAppBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 340,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _firstHalfImage(),

                            // Top half
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        singleitemData.singleitems[0].brand,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //Spacer(),
                                      //Padding(padding: EdgeInsets.only(left: 500)),
                                      if (_checkmargin)
                                        Container(
                                          width: 88,
                                          height: 25,
                                          margin: EdgeInsets.only(left: 5.0),
                                          padding: EdgeInsets.all(3.0),
                                          // color: Theme.of(context).accentColor,
                                          /*decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(3.0),
                                            color: ColorCodes.greenColor,
                                          ),*/
                                          /*constraints: BoxConstraints(
                                            minWidth: 38,
                                            minHeight: 18,
                                          ),*/
                                          child: Text(
                                            margins + S.current.off,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ColorCodes.greenColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(top: 10)),
                                      Text(
                                        singleitemData.singleitems[0].title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      _checkmembership
                                          ? Row(
                                        children: <Widget>[
                                          memberpriceDisplay
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(IConstants.currencyFormat +
                                                      '$varmemberprice ',
                                                      style: new TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20.0)),
                                                  SizedBox(width:5),
                                                  Text(IConstants.currencyFormat +
                                                      '$varmrp ',
                                                      style: new TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20.0)),
                                                ],
                                              )
                                              /*    new RichText(
                                                text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize:
                                                      14.0,
                                                      color:
                                                      Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          S.current.product_mrp,
                                                          style:
                                                          new TextStyle(fontSize: 16.0)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: new TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16.0))
                                                    ])),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 25.0,
                                                  height: 25.0,
                                                  child: Image
                                                      .asset(
                                                    Images.starImg,
                                                  ),
                                                ),
                                                new RichText(
                                                    text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize:
                                                          14.0,
                                                          color:
                                                          Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text:
                                                              S.current.selling_price,
                                                              style:
                                                              new TextStyle(fontSize: 16.0)),
                                                          new TextSpan(
                                                              text: IConstants.currencyFormat +
                                                                  '$varmemberprice ',
                                                              style: new TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0))
                                                        ])),
                                              ],
                                            ),*/
                                            ],
                                          )
                                              : discountDisplay
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(IConstants.currencyFormat + '$varprice ',
                                                      style: new TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20.0)),
                                                  SizedBox(width:5),
                                                  Text(IConstants.currencyFormat +
                                                      '$varmrp ',
                                                      style: new TextStyle(
                                                          decoration: TextDecoration.lineThrough,
                                                          color: Colors.grey,
                                                          fontSize: 18.0)),
                                                ],
                                              ),
                                              /*  new RichText(
                                                text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize:
                                                      14.0,
                                                      color:
                                                      Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          S.current.product_mrp,
                                                          style:
                                                          new TextStyle(fontSize: 16.0)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: TextStyle(
                                                              decoration: TextDecoration.lineThrough,
                                                              fontSize: 12,
                                                              color: Colors.grey))
                                                    ])),
                                            Row(
                                              children: [
                                                Container(
                                                  width:
                                                  25.0,
                                                  height:
                                                  25.0,
                                                  child: Image
                                                      .asset(
                                                    Images.starImg,
                                                  ),
                                                ),
                                                Text(
                                                    IConstants.currencyFormat + '$varprice ',
                                                    style: new TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 16.0)),
                                              ],
                                            ),*/
                                            ],
                                          )
                                              : Row(
                                            children: [
                                                Container(
                                              width: 25.0,
                                              height: 25.0,
                                              child: Image
                                                  .asset(
                                                Images.starImg,
                                              ),
                                            ),
                                              Text(IConstants.currencyFormat +
                                                  '$varmrp ',
                                                  style: new TextStyle(
                                                    // decoration: TextDecoration.lineThrough,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20.0)),
                                              /*  new RichText(
                                                text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize:
                                                      14.0,
                                                      color:
                                                      Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          S.current.selling_price,
                                                          style:
                                                          new TextStyle(fontSize: 16.0)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: new TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16.0))
                                                    ])),*/
                                            ],
                                          )
                                        ],
                                      )
                                          : discountDisplay
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(IConstants.currencyFormat + '$varprice ',
                                                  style: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20.0)),
                                              SizedBox(width:5),
                                              Text(IConstants.currencyFormat +
                                                  '$varmrp ',
                                                  style: new TextStyle(
                                                      decoration: TextDecoration.lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 18.0)),
                                            ],
                                          ),
                                          /* new RichText(
                                            text: new TextSpan(
                                                style:
                                                new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors
                                                      .black,
                                                ),
                                                children: <
                                                    TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      S.current.product_mrp,
                                                      style: new TextStyle(
                                                          fontSize:
                                                          16.0)),
                                                  new TextSpan(
                                                      text: IConstants.currencyFormat + ' $varmrp ',
                                                      style: TextStyle(
                                                          decoration:
                                                          TextDecoration
                                                              .lineThrough,
                                                          fontSize:
                                                          12,
                                                          color: Colors
                                                              .grey))
                                                ])),
                                        new RichText(
                                            text: new TextSpan(
                                                style:
                                                new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors
                                                      .black,
                                                ),
                                                children: <
                                                    TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      S.current.selling_price,
                                                      style: new TextStyle(
                                                          fontSize:
                                                          16.0)),
                                                  new TextSpan(
                                                      text: IConstants.currencyFormat +
                                                          ' $varprice  ',
                                                      style: new TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize:
                                                          16.0))
                                                ])),*/
                                        ],
                                      )
                                          :       Row(
                                        children: [
                                          Text(IConstants.currencyFormat +
                                              '$varmrp ',
                                              style: new TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize: 20.0)),
                                        ],
                                      ),
                                      Text(
                                        S.current.inclusive_of_all_tax,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  singleitemData.singleitems[0].eligible_for_express == "0" ?
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(Images.express,
                                      height: 20.0,
                                      width: 25.0,
                                    ),
                                  ):
                                  SizedBox.shrink(),
                                  Container(
                                    padding: EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        /*  SizedBox(
                                              height: 10,
                                          ),*/
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (_isWeb)? quantityPopup1():_quantityPopup();
                                            });
                                          },
                                          child:
                                          Container(
                                            width: 200,
                                            child: Row(

                                              children: [
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                       // border: Border.all(color: ColorCodes.greenColor,),
                                                        color: ColorCodes.varcolor,
                                                        borderRadius: new BorderRadius.only(
                                                          topLeft: const Radius.circular(2.0),
                                                          bottomLeft: const Radius.circular(2.0),
                                                        )),
                                                    height: 30,
                                                    padding: EdgeInsets.fromLTRB(5.0, 4.5, 5.0, 4.5),
                                                    child: Text(
                                                      "$varname"+" "+"$unit",
                                                      style: TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
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
                                        ),


                                        //SizedBox(width: 300),

                                        //Spacer(),

                                        _addButton(),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  if(Features.isMembership)
                                    Row(
                                      children: [
                                        !_checkmembership
                                            ? memberpriceDisplay
                                            ? GestureDetector(
                                          onTap: () {
                                            (checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                           // _dialogforSignIn()
                                            LoginWeb(context,result: (sucsess){
                                              if(sucsess){
                                                Navigator.of(context).pop();
                                                Navigator.pushNamedAndRemoveUntil(
                                                    context, HomeScreen.routeName, (route) => false);
                                              }else{
                                                Navigator.of(context).pop();
                                              }
                                            })
                                                :
                                            (checkskip && !_isWeb)?
                                            Navigator.of(context).pushReplacementNamed(
                                                SignupSelectionScreen.routeName,arguments: {
                                              "prev": "signupSelectionScreen",
                                            })
                                                :Navigator.of(context).pushNamed(
                                              MembershipScreen.routeName,
                                            );
                                          },
                                          child: Container(
                                            height: 35,
                                            //width: (MediaQuery.of(context).size.width / 2 ),
                                            width: MediaQuery.of(context).size.width / 2.03,
                                            decoration: BoxDecoration(
                                                color: ColorCodes.membershipColor),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 10),
                                                      Image.asset(
                                                        Images.starImg,
                                                        height: 12,
                                                      ),
                                                      // SizedBox(width: 4),
                                                      // Text(S.current.membership_price,
                                                      //     style: TextStyle(
                                                      //         fontSize: 16.0)
                                                      // ),
                                                      SizedBox(width: 30),
                                                      Text(
                                                          //S.of(context).membership_price + " "//"Membership Price "
                                                               IConstants.currencyFormat +
                                                              varmemberprice,
                                                          style: TextStyle(
                                                              color: ColorCodes.blackColor,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.normal)),
                                                    ],
                                                  ),
                                                ),

                                                //Spacer(),
                                                Container(
                                                  child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.lock,
                                                          color: Colors.black,
                                                          size: 12,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(S.current.unlock,
                                                            style: TextStyle(
                                                                color: ColorCodes.blackColor,
                                                                fontSize: 16.0)),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_sharp,
                                                          color: Colors.black,
                                                          size: 12,
                                                        ),
                                                        SizedBox(width: 10),
                                                      ]
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        )
                                            : SizedBox.shrink()
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_isdescription || _ismanufacturer)

                      //child: new
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, left: 30, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  new Container(
                                    width: 500,
                                    child: new TabBar(
                                        controller: _tabController,
                                        labelColor: Colors.black,
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        indicatorColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        tabs: tabList),
                                  ),
                                  if(Features.isShoppingList)
                                  Container(
                                    child: Row(
                                      children: [
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              final shoplistData =
                                              Provider.of<BrandItemsList>(context,
                                                  listen: false);

                                              if (shoplistData.itemsshoplist.length <=
                                                  0) {
                                                _dialogforCreatelistTwo(
                                                    context, shoplistData);
                                                //_dialogforShoppinglist(context);
                                              } else {
                                                _dialogforShoppinglistTwo(context);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.list_alt_outlined,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5),
                                                Text(S.current.add_to_list, style: TextStyle(
                                                    fontSize: 16, color: ColorCodes.mediumBlackColor,
                                                    fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if(Features.isShare)
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            if (_isIOS) {
                                              Share.share(S.current.download_app +
                                                  IConstants.APP_NAME +
                                                  '${S.current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                                            } else {
                                              Share.share(S.current.download_app +
                                                  IConstants.APP_NAME +
                                                  '${S.current.from_google_play_store}https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                                            }
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Icon(Icons.share, color: Colors.grey, size: 26),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Text(
                                                S.current.share,
                                                style: TextStyle(
                                                    fontSize: 20, color: ColorCodes.mediumBlackColor,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              //Spacer(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),

                              Container(
                                height: 150,
                                padding: EdgeInsets.all(8),
                                child: new TabBarView(
                                  controller: _tabController,
                                  children: tabList.map((Tab tab) {
                                    return _getPage(tab);
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      //),
                      SizedBox(
                        height: 5.0,
                      ),




                      Container(
                        margin: EdgeInsets.only(
                            left: 10, top: 20, right: 10, bottom: 20),
                        child: Column(
                          children: <Widget>[

                            _similarProduct
                                ? Container(
                              child: Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        sellingitemData.newitemname,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: SizedBox(
                                            height: 380.0,
                                            child: new ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection:
                                              Axis.horizontal,
                                              itemCount: sellingitemData
                                                  .itemsnew.length,
                                              itemBuilder: (_, i) =>
                                                  Column(
                                                    children: [
                                                      Items(
                                                        "singleproduct_screen",
                                                        sellingitemData
                                                            .itemsnew[i].id,
                                                        sellingitemData
                                                            .itemsnew[i].title,
                                                        sellingitemData
                                                            .itemsnew[i]
                                                            .imageUrl,
                                                        sellingitemData
                                                            .itemsnew[i].brand,
                                                        sellingitemData.itemsnew[i].veg_type,
                                                          sellingitemData.itemsnew[i].type,
                                                        sellingitemData
                                                            .itemsnew[i]
                                                            .eligible_for_express,
                                                        sellingitemData
                                                            .itemsnew[i].delivery,
                                                        sellingitemData
                                                            .itemsnew[i]
                                                            .duration,
                                                        sellingitemData
                                                            .itemsnew[i].durationType,
                                                        sellingitemData
                                                            .itemsnew[i].note,
                                                        sellingitemData
                                                            .itemsnew[i].subscribe,
                                                        sellingitemData
                                                            .itemsnew[i].paymentmode,
                                                        sellingitemData
                                                            .itemsnew[i].cronTime,
                                                        sellingitemData
                                                            .itemsnew[i].name,

                                                      ),
                                                    ],
                                                  ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                      //if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context) || ResponsiveLayout.isLargeScreen(context))
                      _footer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget mobileBody() {
      singleitemvar = Provider.of<ItemsList>(context, listen: false).findBysizesingleitems(itemid);
      debugPrint("size...."+ singleitemvar.length.toString()+"  "+ singleitemvar.toString());
      for(int i=0; i<singleitemvar.length ;i++){
        size = groupBy(singleitemvar, (obj) => obj.size);
        for(int i=0; i<size.length ;i++)
          for (int j = 0; j < size.values.elementAt(i).length; j++){
           debugPrint("size..."+size.length.toString()+"  "+size.keys.elementAt(i).toString());
          }

      }

      for(int i=0; i<singleitemvar.length ;i++){
        colorgroup = groupBy(singleitemvar, (obj) => obj.varColor);
        for(int i=0; i<colorgroup.length ;i++)
        //  debugPrint("key len..."+colorgroup.keys.elementAt(i).toString());
          for (int j = 0; j < colorgroup.values.elementAt(i).length; j++){
           // debugPrint("length...colo.."+ colorgroup.length.toString()+"  "+colorgroup.values.elementAt(sizeIndex).elementAt(j).size.toString());
            }
      }
      debugPrint("itemdescription...."+itemdescription);
      return SafeArea(
        child: _isLoading
            ? Center(
          child: SingelItemScreenShimmer(),
        )
            : Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    /*SizedBox(
                      height: 20.0,
                    ),*/
                    !_isStock
                        ? Stack(
                          children: [
                            Consumer<CartCalculations>(
                      builder: (_, cart, ch) => BadgeOfStock(
                            child: ch,
                            value: margins,
                            singleproduct: true,
                      ),
                      child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  SingleProductImageScreen.routeName,
                                  arguments: {
                                    "itemid": itemid,
                                    "itemname": itemname,
                                    "itemimg": itemimg,
                                    "fromScreen":fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
                                    'notificationFor': notificationFor.toString(),
                                  });
                            },
                            child: GFCarousel(
                              autoPlay: true,
                              viewportFraction: 1.0,
                              height: MediaQuery.of(context).size.height / 1.7,
                              pagination: true,
                              passiveIndicator: Colors.white,
                              activeIndicator:
                              Theme.of(context).accentColor,
                              autoPlayInterval: Duration(seconds: 8),
                              items: <Widget>[
                                for (var i = 0;
                                i < multiimage.length;
                                i++)
                                  Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                            color: Colors.white,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        5.0)),
                                                child:
                                                    CachedNetworkImage(
                                                        imageUrl: multiimage[i].imageUrl,
                                                        placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                                        errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                                        fit: BoxFit.cover),

                                            )),
                                      );
                                    },
                                  )
                              ],
                            ),
                      ),
                    ),

                          ],
                        )
                        : Stack(
                          children: [
                            GestureDetector(
                      onTap: () {
                            Navigator.of(context).pushNamed(
                                SingleProductImageScreen.routeName,
                                arguments: {
                                  "itemid": itemid,
                                  "itemname": itemname,
                                  "itemimg": itemimg,
                                  "fromScreen":fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
                                  'notificationFor': notificationFor.toString(),
                                });
                      },
                      child: GFCarousel(
                            autoPlay: true,
                            viewportFraction: 1.0,
                            height: MediaQuery.of(context).size.height / 1.7,
                            pagination: true,
                        pagerSize: 8,
                            passiveIndicator: ColorCodes.blackColor.withOpacity(0.2),
                            activeIndicator:
                           ColorCodes.blackColor,
                            autoPlayInterval: Duration(seconds: 8),
                            items: <Widget>[
                              for (var i = 0; i < multiimage.length; i++)
                                Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: /*Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if(singleitemData.singleitems[0].eligible_for_express == "0")
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Image.asset(Images.express,
                                                  height: 20.0,
                                                  width: 20.0,)
                                            ),*/
                                          Container(
                                            color: Colors.white,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                              child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          5.0)),
                                                  child: CachedNetworkImage(
                                                      imageUrl: multiimage[i].imageUrl,
                                                      placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                                      errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                                      fit: BoxFit.cover))),
                                        /*],
                                      ),*/
                                    );
                                  },
                                )
                            ],
                      ),
                    ),
                            
                          ],
                        ),
                    Container(
                      decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                      padding: EdgeInsets.only(
                          left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                singleitemData.singleitems[0].title,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              if(Features.offer)
                              if (_checkmargin)
                                Container(
                                  //margin: EdgeInsets.only(right:5.0),
                                  padding: EdgeInsets.all(2.0),
                                  // color: Theme.of(context).accentColor,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(3.0),
                                    color: /*Color(0xff6CBB3C)*/Colors.transparent,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    margins + S.current.off,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:ColorCodes.discountoff,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Container(
                                width:
                                MediaQuery.of(context).size.width / 2 +
                                    10,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      fit,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ColorCodes.grey,
                                          fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    _checkmembership
                                        ? Row(
                                      children: <Widget>[
                                        memberpriceDisplay
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(IConstants.currencyFormat +
                                                    '$varmemberprice ',
                                                    style: new TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0)),
                                                Text(IConstants.currencyFormat +
                                                    '$varmrp ',
                                                    style: new TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0)),
                                              ],
                                            )
                                        /*    new RichText(
                                                text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize:
                                                      14.0,
                                                      color:
                                                      Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          S.current.product_mrp,
                                                          style:
                                                          new TextStyle(fontSize: 16.0)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: new TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16.0))
                                                    ])),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 25.0,
                                                  height: 25.0,
                                                  child: Image
                                                      .asset(
                                                    Images.starImg,
                                                  ),
                                                ),
                                                new RichText(
                                                    text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize:
                                                          14.0,
                                                          color:
                                                          Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text:
                                                              S.current.selling_price,
                                                              style:
                                                              new TextStyle(fontSize: 16.0)),
                                                          new TextSpan(
                                                              text: IConstants.currencyFormat +
                                                                  '$varmemberprice ',
                                                              style: new TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0))
                                                        ])),
                                              ],
                                            ),*/
                                          ],
                                        )
                                            : discountDisplay
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(IConstants.currencyFormat + '$varprice ',
                                                    style: new TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0)),
                                                Text(IConstants.currencyFormat +
                                                    '$varmrp ',
                                                    style: new TextStyle(
                                                        decoration: TextDecoration.lineThrough,
                                                        color: Colors.grey,
                                                        fontSize: 14.0)),
                                              ],
                                            ),
                                          /*  new RichText(
                                                text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize:
                                                      14.0,
                                                      color:
                                                      Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          S.current.product_mrp,
                                                          style:
                                                          new TextStyle(fontSize: 16.0)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: TextStyle(
                                                              decoration: TextDecoration.lineThrough,
                                                              fontSize: 12,
                                                              color: Colors.grey))
                                                    ])),
                                            Row(
                                              children: [
                                                Container(
                                                  width:
                                                  25.0,
                                                  height:
                                                  25.0,
                                                  child: Image
                                                      .asset(
                                                    Images.starImg,
                                                  ),
                                                ),
                                                Text(
                                                    IConstants.currencyFormat + '$varprice ',
                                                    style: new TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 16.0)),
                                              ],
                                            ),*/
                                          ],
                                        )
                                            : Row(
                                          children: [
                                          /*  Container(
                                              width: 25.0,
                                              height: 25.0,
                                              child: Image
                                                  .asset(
                                                Images.starImg,
                                              ),
                                            ),*/
                                            Text(IConstants.currencyFormat +
                                                '$varmrp ',
                                                style: new TextStyle(
                                                   // decoration: TextDecoration.lineThrough,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0)),
                                          /*  new RichText(
                                                text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize:
                                                      14.0,
                                                      color:
                                                      Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          S.current.selling_price,
                                                          style:
                                                          new TextStyle(fontSize: 16.0)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: new TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16.0))
                                                    ])),*/
                                          ],
                                        )
                                      ],
                                    )
                                        : discountDisplay
                                        ? Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(IConstants.currencyFormat + '$varprice ',
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0)),
                                            SizedBox(width: 8),
                                            Text(IConstants.currencyFormat +
                                                '$varmrp ',
                                                style: new TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    color: Colors.grey,
                                                    fontSize: 14.0)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("[Inclusive of taxes]", style: TextStyle(color: Colors.grey,
                                                fontSize: 12.0, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                       /* new RichText(
                                            text: new TextSpan(
                                                style:
                                                new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors
                                                      .black,
                                                ),
                                                children: <
                                                    TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      S.current.product_mrp,
                                                      style: new TextStyle(
                                                          fontSize:
                                                          16.0)),
                                                  new TextSpan(
                                                      text: IConstants.currencyFormat + ' $varmrp ',
                                                      style: TextStyle(
                                                          decoration:
                                                          TextDecoration
                                                              .lineThrough,
                                                          fontSize:
                                                          12,
                                                          color: Colors
                                                              .grey))
                                                ])),
                                        new RichText(
                                            text: new TextSpan(
                                                style:
                                                new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors
                                                      .black,
                                                ),
                                                children: <
                                                    TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      S.current.selling_price,
                                                      style: new TextStyle(
                                                          fontSize:
                                                          16.0)),
                                                  new TextSpan(
                                                      text: IConstants.currencyFormat +
                                                          ' $varprice  ',
                                                      style: new TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize:
                                                          16.0))
                                                ])),*/
                                      ],
                                    )
                                        :       Row(
                                      children: [
                                        Text(IConstants.currencyFormat +
                                            '$varmrp ',
                                            style: new TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                fontSize: 16.0)),
                                      ],
                                    ),
                                  /*  new RichText(
                                        text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text:
                                                  S.current.selling_price,
                                                  style:
                                                  new TextStyle(
                                                      fontSize:
                                                      16.0)),
                                              new TextSpan(
                                                  text:
                                                  IConstants.currencyFormat +
                                                      '$varmrp ',
                                                  style: new TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 16.0))
                                            ])),*/
                                    // Text(
                                    //   S.current.inclusive_of_all_tax,
                                    //   style: TextStyle(
                                    //       fontSize: 8, color: Colors.grey),
                                    // )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width / 2 -
                                        90,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        if(Features.isLoyalty)
                                          if(double.parse(varLoyalty.toString()) > 0)
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(Images.coinImg,
                                                    height: 15.0,
                                                    width: 20.0,),
                                                  SizedBox(width: 4),
                                                  Text(varLoyalty.toString()),
                                                ],
                                              ),
                                            ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  (singleitemData.singleitems[0].eligible_for_express == "0") ?
                                  Image.asset(Images.express,
                                    height: 20.0,
                                    width: 25.0,):
                                  SizedBox.shrink(),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorCodes.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.only(
                          left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "COLORS",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: new GridView.builder(
                              shrinkWrap: true,
                              controller: new ScrollController(keepScrollOffset: false),
                              itemCount: /*size.values.elementAt(sizeIndex).length*/colorgroup.length,
                              gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 2,
                              ),
                              itemBuilder: (_, i) =>

                                  colorWidget(
                                      onTap:(){

                                        // for (int k = 0; k < size.values.elementAt(sizeIndex).length; k++) {
                                        //   debugPrint("vniv " + size.values.elementAt(sizeIndex).elementAt(i).fit);
                                        //   setState(() {
                                        //     varmemberprice = size.values.elementAt(sizeIndex).elementAt(i).varmemberprice;
                                        //     varmrp = size.values.elementAt(sizeIndex).elementAt(i).varmrp;
                                        //     varprice = size.values.elementAt(sizeIndex).elementAt(i).varprice;
                                        //     varid = size.values.elementAt(sizeIndex).elementAt(i).varid;
                                        //     vsize = size.values.elementAt(sizeIndex).elementAt(i).size;
                                        //     varname = size.values.elementAt(sizeIndex).elementAt(i).varname;
                                        //     unit = size.values.elementAt(sizeIndex).elementAt(i).unit;
                                        //     color = size.values.elementAt(sizeIndex).elementAt(i).color;
                                        //     fit = size.values.elementAt(sizeIndex).elementAt(i).fit;
                                        //     varstock = size.values.elementAt(sizeIndex).elementAt(i).varstock;
                                        //     varminitem = size.values.elementAt(sizeIndex).elementAt(i).varminitem;
                                        //     varmaxitem = size.values.elementAt(sizeIndex).elementAt(i).varmaxitem;
                                        //     varLoyalty = size.values.elementAt(sizeIndex).elementAt(i).varLoyalty;
                                        //     _varQty = size.values.elementAt(sizeIndex).elementAt(i).varQty;
                                        //     varcolor = size.values.elementAt(sizeIndex).elementAt(i).varcolor;
                                        //     discountDisplay = size.values.elementAt(sizeIndex).elementAt(i) .discountDisplay;
                                        //     memberpriceDisplay = size.values.elementAt(sizeIndex).elementAt(i).membershipDisplay;
                                        //
                                        //     if (_checkmembership) {
                                        //       if (varmemberprice.toString() == '-' ||
                                        //           double.parse(varmemberprice) <= 0) {
                                        //         if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                                        //           margins = "0";
                                        //         } else {
                                        //           var difference = (double.parse(varmrp) - double.parse(varprice));
                                        //           var profit = difference / double.parse(varmrp);
                                        //           margins = profit * 100;
                                        //
                                        //
                                        //           margins = num.parse(margins.toStringAsFixed(0));
                                        //           margins = margins.toString();
                                        //         }
                                        //       } else {
                                        //         var difference = (double.parse(varmrp) - double.parse(varmemberprice));
                                        //         var profit = difference / double.parse(varmrp);
                                        //         margins = profit * 100;
                                        //
                                        //
                                        //         margins = num.parse(margins.toStringAsFixed(0));
                                        //         margins = margins.toString();
                                        //       }
                                        //     } else {
                                        //       if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                                        //         margins = "0";
                                        //       } else {
                                        //         var difference = (double.parse(varmrp) - double.parse(varprice));
                                        //         var profit = difference / double.parse(varmrp);
                                        //         margins = profit * 100;
                                        //
                                        //
                                        //         margins = num.parse(margins.toStringAsFixed(0));
                                        //         margins = margins.toString();
                                        //       }
                                        //     }
                                        //
                                        //     if (margins == "NaN") {
                                        //       _checkmargin = false;
                                        //     } else {
                                        //       if (int.parse(margins) <= 0) {
                                        //         _checkmargin = false;
                                        //       } else {
                                        //         _checkmargin = true;
                                        //       }
                                        //     }
                                        //     multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
                                        //     _displayimg = multiimage[0].imageUrl;
                                        //     for (int j = 0; j < multiimage.length; j++) {
                                        //       if (j == 0) {
                                        //         multiimage[j].varcolor = ColorCodes.primaryColor;
                                        //       } else {
                                        //         multiimage[j].varcolor = ColorCodes.lightgrey;
                                        //       }
                                        //     }
                                        //   });
                                        // }
                                        // setState(() {
                                        //   if (int.parse(size.values.elementAt(sizeIndex).elementAt(i).varstock) <= 0) {
                                        //     _isStock = false;
                                        //   } else {
                                        //     _isStock = true;
                                        //   }
                                        // });
                                        // setState(() {
                                        //   colorindex = i;
                                        // });


                                        if(int.parse(singleitemvar[i].varstock) > 0){
                                          for (int k = 0; k < singleitemvar.length; k++) {
                                            if (i == k) {
                                              singleitemvar[k].varcolor = ColorCodes.discountoff;
                                            } else {
                                              singleitemvar[k].varcolor = ColorCodes.lightgrey;
                                            }
                                            setState(() {
                                              //sizeIndex = i;
                                              colorindex = i;

                                              for (int k = 0; k < colorgroup.values.elementAt(colorindex).length; k++) {
                                                setState(() {
                                                  varmemberprice = colorgroup.values.elementAt(colorindex).elementAt(0).varmemberprice;
                                                  varmrp = colorgroup.values.elementAt(colorindex).elementAt(0).varmrp;
                                                  varprice = colorgroup.values.elementAt(colorindex).elementAt(0).varprice;
                                                  varid = colorgroup.values.elementAt(colorindex).elementAt(0).varid;
                                                  vsize = colorgroup.values.elementAt(colorindex).elementAt(0).size;
                                                  varname = colorgroup.values.elementAt(colorindex).elementAt(0).varname;
                                                  unit = colorgroup.values.elementAt(colorindex).elementAt(0).unit;
                                                  color = colorgroup.values.elementAt(colorindex).elementAt(0).color;
                                                  fit = colorgroup.values.elementAt(colorindex).elementAt(0).fit;
                                                  varstock = colorgroup.values.elementAt(colorindex).elementAt(0).varstock;
                                                  varminitem = colorgroup.values.elementAt(colorindex).elementAt(0).varminitem;
                                                  varmaxitem = colorgroup.values.elementAt(colorindex).elementAt(0).varmaxitem;
                                                  varLoyalty = colorgroup.values.elementAt(colorindex).elementAt(0).varLoyalty;
                                                  _varQty = colorgroup.values.elementAt(colorindex).elementAt(0).varQty;
                                                  varcolor = colorgroup.values.elementAt(colorindex).elementAt(0).varcolor;
                                                  discountDisplay = colorgroup.values.elementAt(colorindex).elementAt(0) .discountDisplay;
                                                  memberpriceDisplay = colorgroup.values.elementAt(colorindex).elementAt(0).membershipDisplay;
                                                });
                                              }
                                              if (int.parse(varstock) <= 0) {
                                                _isStock = false;
                                              } else {
                                                _isStock = true;
                                              }
                                              multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
                                              _displayimg = multiimage[0].imageUrl;
                                              for (int j = 0; j < multiimage.length; j++) {
                                                if (j == 0) {
                                                  multiimage[j].varcolor = ColorCodes.primaryColor;
                                                } else {
                                                  multiimage[j].varcolor = ColorCodes.lightgrey;
                                                }
                                              }
                                            });
                                          }

                                        }
                                        else{
                                          Fluttertoast.showToast(msg: S.current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
                                        }

                                      },
                                      i: i,
                                      singleitemvar: /*size.values.elementAt(sizeIndex).elementAt(i).varColor*/colorgroup.keys.elementAt(i),
                                      coloindex: colorindex
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorCodes.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.only(
                          left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "SELECT SIZE",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Size Chart",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  color: ColorCodes.discountoff,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: new GridView.builder(
                              shrinkWrap: true,
                              controller: new ScrollController(keepScrollOffset: false),
                              itemCount: /*size.length*/colorgroup.values.elementAt(colorindex).length,
                              gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                              ),
                              itemBuilder: (_, i) => VarintWidget(
                                onTap:(){
                                  // if(int.parse(singleitemvar[i].varstock) > 0){
                                  //   for (int k = 0; k < singleitemvar.length; k++) {
                                  //     if (i == k) {
                                  //       singleitemvar[k].varcolor = ColorCodes.discountoff;
                                  //     } else {
                                  //       singleitemvar[k].varcolor = ColorCodes.lightgrey;
                                  //     }
                                  //     setState(() {
                                  //       sizeIndex = i;
                                  //       colorindex = 0;
                                  //
                                  //       for (int k = 0; k < size.values.elementAt(sizeIndex).length; k++) {
                                  //         setState(() {
                                  //           varmemberprice = size.values.elementAt(sizeIndex).elementAt(0).varmemberprice;
                                  //           varmrp = size.values.elementAt(sizeIndex).elementAt(0).varmrp;
                                  //           varprice = size.values.elementAt(sizeIndex).elementAt(0).varprice;
                                  //           varid = size.values.elementAt(sizeIndex).elementAt(0).varid;
                                  //           vsize = size.values.elementAt(sizeIndex).elementAt(0).size;
                                  //           varname = size.values.elementAt(sizeIndex).elementAt(0).varname;
                                  //           unit = size.values.elementAt(sizeIndex).elementAt(0).unit;
                                  //           color = size.values.elementAt(sizeIndex).elementAt(0).color;
                                  //           fit = size.values.elementAt(sizeIndex).elementAt(0).fit;
                                  //           varstock = size.values.elementAt(sizeIndex).elementAt(0).varstock;
                                  //           varminitem = size.values.elementAt(sizeIndex).elementAt(0).varminitem;
                                  //           varmaxitem = size.values.elementAt(sizeIndex).elementAt(0).varmaxitem;
                                  //           varLoyalty = size.values.elementAt(sizeIndex).elementAt(0).varLoyalty;
                                  //           _varQty = size.values.elementAt(sizeIndex).elementAt(0).varQty;
                                  //           varcolor = size.values.elementAt(sizeIndex).elementAt(0).varcolor;
                                  //           discountDisplay = size.values.elementAt(sizeIndex).elementAt(0) .discountDisplay;
                                  //           memberpriceDisplay = size.values.elementAt(sizeIndex).elementAt(0).membershipDisplay;
                                  //         });
                                  //       }
                                  //       if (int.parse(varstock) <= 0) {
                                  //         _isStock = false;
                                  //       } else {
                                  //         _isStock = true;
                                  //       }
                                  //     });
                                  //   }
                                  //
                                  // }
                                  // else{
                                  //   Fluttertoast.showToast(msg: S.current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
                                  // }



                                  for (int k = 0; k < colorgroup.values.elementAt(colorindex).length; k++) {
                                    debugPrint("vniv " + colorgroup.values.elementAt(colorindex).elementAt(i).fit);
                                    setState(() {
                                      _isColorSelect = true;
                                      varmemberprice = colorgroup.values.elementAt(colorindex).elementAt(i).varmemberprice;
                                      varmrp = colorgroup.values.elementAt(colorindex).elementAt(i).varmrp;
                                      varprice = colorgroup.values.elementAt(colorindex).elementAt(i).varprice;
                                      varid = colorgroup.values.elementAt(colorindex).elementAt(i).varid;
                                      vsize = colorgroup.values.elementAt(colorindex).elementAt(i).size;
                                      varname = colorgroup.values.elementAt(colorindex).elementAt(i).varname;
                                      unit = colorgroup.values.elementAt(colorindex).elementAt(i).unit;
                                      color = colorgroup.values.elementAt(colorindex).elementAt(i).color;
                                      fit = colorgroup.values.elementAt(colorindex).elementAt(i).fit;
                                      varstock = colorgroup.values.elementAt(colorindex).elementAt(i).varstock;
                                      varminitem = colorgroup.values.elementAt(colorindex).elementAt(i).varminitem;
                                      varmaxitem = colorgroup.values.elementAt(colorindex).elementAt(i).varmaxitem;
                                      varLoyalty = colorgroup.values.elementAt(colorindex).elementAt(i).varLoyalty;
                                      _varQty = colorgroup.values.elementAt(colorindex).elementAt(i).varQty;
                                      varcolor = colorgroup.values.elementAt(colorindex).elementAt(i).varcolor;
                                      discountDisplay = colorgroup.values.elementAt(colorindex).elementAt(i) .discountDisplay;
                                      memberpriceDisplay = colorgroup.values.elementAt(colorindex).elementAt(i).membershipDisplay;

                                      if (_checkmembership) {
                                        if (varmemberprice.toString() == '-' ||
                                            double.parse(varmemberprice) <= 0) {
                                          if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                                            margins = "0";
                                          } else {
                                            var difference = (double.parse(varmrp) - double.parse(varprice));
                                            var profit = difference / double.parse(varmrp);
                                            margins = profit * 100;


                                            margins = num.parse(margins.toStringAsFixed(0));
                                            margins = margins.toString();
                                          }
                                        } else {
                                          var difference = (double.parse(varmrp) - double.parse(varmemberprice));
                                          var profit = difference / double.parse(varmrp);
                                          margins = profit * 100;


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


                                          margins = num.parse(margins.toStringAsFixed(0));
                                          margins = margins.toString();
                                        }
                                      }

                                      if (margins == "NaN") {
                                        _checkmargin = false;
                                      } else {
                                        if (int.parse(margins) <= 0) {
                                          _checkmargin = false;
                                        } else {
                                          _checkmargin = true;
                                        }
                                      }
                                      // multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
                                      // _displayimg = multiimage[0].imageUrl;
                                      // for (int j = 0; j < multiimage.length; j++) {
                                      //   if (j == 0) {
                                      //     multiimage[j].varcolor = ColorCodes.primaryColor;
                                      //   } else {
                                      //     multiimage[j].varcolor = ColorCodes.lightgrey;
                                      //   }
                                      // }
                                    });
                                  }
                                  setState(() {
                                    if (int.parse(colorgroup.values.elementAt(colorindex).elementAt(i).varstock) <= 0) {
                                      _isStock = false;
                                    } else {
                                      _isStock = true;
                                    }
                                  });
                                  setState(() {
                                    sizeIndex = i;
                                  });
                                },
                                i: i,singleitemvar: colorgroup.values.elementAt(colorindex).elementAt(i).size,sing: singleitemvar,varid: sizeIndex,checkmargin: _checkmargin,varMarginList: _varMarginList, checkmembership: _checkmembership,discountDisplay: discountDisplay,memberpriceDisplay: memberpriceDisplay,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorCodes.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(12)
                      ),
                      margin: EdgeInsets.only(bottom: (!_ismanufacturer && !_isdescription)?80.0:0.0),
                      padding: EdgeInsets.only(
                          left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).delivery_details,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height:10),
                          Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height / 18,//52.0,
                            margin: EdgeInsets.only(left: 20, right: 20,bottom:10),
                            /*padding: EdgeInsets.only(
                          left: 10.0, top: 0.0, right: 0.0, bottom: 0.0),*/
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(width: 0.5, color: ColorCodes.borderColor),
                            ),
                            child: Row(
                              children: <Widget>[

                                Container(
                                    width: MediaQuery.of(context).size.width*0.60,
                                    child: Form(
                                      key: _form,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16.0),
                                        //textAlign: TextAlign.left,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(12)
                                        ],
                                        cursorColor: Theme.of(context).primaryColor,
                                        keyboardType: TextInputType.number,
                                        //autofocus: true,
                                        decoration: new InputDecoration.collapsed(
                                            hintText: 'Enter Pincode',

                                            hintStyle: TextStyle(
                                              color: Colors.black12,

                                            )),
                                        // validator: (value) {
                                        //   String patttern = r'(^(?:[+0]9)?[0-9]{6,10}$)';
                                        //   RegExp regExp = new RegExp(patttern);
                                        //   if (value!.isEmpty) {
                                        //     return S.of(context).please_enter_phone_number;//'Please enter a Mobile number.';
                                        //   } else if (!regExp.hasMatch(value)) {
                                        //     return S.of(context).valid_phone_number;//'Please enter valid mobile number';
                                        //   }
                                        //   return null;
                                        // }, //it means user entered a valid input

                                        // onSaved: (value) {
                                        //   addMobilenumToSF(value!);
                                        // },
                                      ),
                                    )),
                                Container(
                                    width: 50,
                                    child:
                                    Text(
                                      "CHECK",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorCodes.discountoff,
                                        fontWeight: FontWeight.w600,),
                                    )
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    (_ismanufacturer || _isdescription)?  SizedBox(
                      height: 6.0,
                    ):SizedBox.shrink(),
                    if(_isdescription)
                    Column(
                      children: [
                       /* Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: ColorCodes.grey.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              )
                            ],
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(12)
                          ),
                         // margin: EdgeInsets.only(bottom: (!_ismanufacturer)?70.0:0.0),
                          padding: EdgeInsets.only(
                              left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Description",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                            ],
                          ),

                        ),*/
                        Container(
                            width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(bottom: (!_ismanufacturer)?80.0:0.0),
                          padding: EdgeInsets.only(
                              left: 9.0, top: 5.0, right: 15.0, bottom: 10.0),
                          child: MediaQuery(

                            data: MediaQuery.of(context).copyWith(
                                textScaleFactor: 1.0),
                            child: Html(data: itemdescription,
                              style: {
                                "span": Style(
                                  fontSize: FontSize(12.0),
                                  fontWeight: FontWeight.normal,
                                )
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    (_ismanufacturer)?  SizedBox(
                      height: 6.0,
                    ):SizedBox.shrink(),
                    if(_ismanufacturer)
                      Column(
                        children: [
                         /* Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorCodes.grey.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                )
                              ],
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(12)
                            ),
                            // margin: EdgeInsets.only(bottom: (!_ismanufacturer)?70.0:0.0),
                            padding: EdgeInsets.only(
                                left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Manufacturer Description",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                              ],
                            ),

                          ),*/
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            margin: EdgeInsets.only(bottom: 80.0),
                            padding: EdgeInsets.only(
                                left: 9.0, top: 5.0, right: 15.0, bottom: 10.0),
                            child: MediaQuery(

                              data: MediaQuery.of(context).copyWith(
                                  textScaleFactor: 1.0),
                              child: Html(data: itemmanufact,
                                style: {
                                  "span": Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.normal,
                                  )
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   decoration: BoxDecoration(
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: ColorCodes.grey.withOpacity(0.2),
                      //         spreadRadius: 4,
                      //         blurRadius: 5,
                      //         offset: Offset(0, 2),
                      //       )
                      //     ],
                      //    // borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      //     color: Colors.white,
                      //     // borderRadius: BorderRadius.circular(12)
                      //   ),
                      //   margin: EdgeInsets.only(bottom: 70.0),
                      //   padding: EdgeInsets.only(
                      //       left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Manufacturer Description",
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w900,
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 10.0,
                      //       ),
                      //       Row(
                      //         children: <Widget>[
                      //
                      //           Expanded(
                      //               child: MediaQuery(
                      //                 data: MediaQuery.of(context).copyWith(
                      //                     textScaleFactor: 1.0),
                      //                 child: Html(data: itemmanufact,
                      //                   style: {
                      //                     "span": Style(
                      //                       fontSize: FontSize(12.0),
                      //                       fontWeight: FontWeight.normal,
                      //                     )
                      //                   },
                      //                 ),
                      //               )
                      //           ),
                      //           // SizedBox(width: 5.0,),
                      //         ],
                      //       ),
                      //
                      //     ],
                      //   ),
                      //
                      // ),
                    if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget mainBody() {
      if (ResponsiveLayout.isSmallScreen(context)) {
        return mobileBody();
      } else {
        return webBody();
      }
    }
    final routeArgs1 =
    ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;
    return Scaffold(
       resizeToAvoidBottomInset: false,
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      AppBarMobile(routeArgs,sellingitemData) : null,
      backgroundColor: ColorCodes.backgroundcolor,
      body:NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: WillPopScope(
            onWillPop: () async{
              final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
              debugPrint("ssss1...."+(VxState.store as GroceStore).homescreen.data.featuredByCart.label.toString());
             var title;
              debugPrint("title1.."+seeallpress.toString());
             if(seeallpress=="featured"){
               title =(VxState.store as GroceStore).homescreen.data.featuredByCart.label;
             }else if(seeallpress=="offers"){
               title =(VxState.store as GroceStore).homescreen.data.offerByCart.label;
             }else if(seeallpress=="discount"){
               title =(VxState.store as GroceStore).homescreen.data.discountByCart.label;
             }
              debugPrint("title.."+title.toString());
              switch(fromScreen){
                case "sellingitem_screen":
                  Navigator.of(context)
                    .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                  'seeallpress': seeallpress,
                  'title': title,
                });
                  return false;
                  break;
                case "not_product_screen":
                  break;
                case "item_screen":
                  Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                    'maincategory': routeArgs['maincategory'],
                    'catId':  routeArgs['catId'],
                    'catTitle':  routeArgs['catTitle'],
                    'subcatId':  routeArgs['subcatId'],
                    'indexvalue': routeArgs['indexvalue'],
                    'prev': routeArgs['prev'],
                  });
                  break;
                case "brands_screen":
              Navigator.of(context).pushReplacementNamed(BrandsScreen.routeName, arguments: {
              "indexvalue":routeArgs['indexvalue'],
              "brandId":routeArgs['brandId'],
              });
                  break;
                case "searchitem_screen":
                  break;
                case "sellingitem_screen":
                //  Navigator.of(context).pop();

                  break;
                case "shoppinglistitem_screen":
                  break;
                case "Offers" :
                //  Navigator.of(context).pop();
                  break;
              }
              return true;
            },
            child: mainBody()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:25.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: !_isStock?
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      debugPrint("ssss...."+sellingitemData.featuredname.toString());
                      var title;
                      debugPrint("title1.."+seeallpress.toString());
                      if(seeallpress=="featured"){
                        title =(VxState.store as GroceStore).homescreen.data.featuredByCart.label;
                      }else if(seeallpress=="offers"){
                        title =(VxState.store as GroceStore).homescreen.data.offerByCart.label;
                      }else if(seeallpress=="discount"){
                        title =(VxState.store as GroceStore).homescreen.data.discountByCart.label;
                      }
                      switch(fromScreen){
                        case "sellingitem_screen":
                          Navigator.of(context)
                              .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                            'seeallpress': seeallpress,
                            'title': title,
                          });
                          return false;
                          break;
                        case "not_product_screen":
                          Navigator.of(context).pop();
                          break;
                        case "item_screen":
                          print("fs iten: "+{ 'maincategory': routeArgs['maincategory'],
                            'catId':  routeArgs['catId'],
                            'catTitle':  routeArgs['catTitle'],
                            'subcatId':  routeArgs['subcatId'],
                            'indexvalue': routeArgs['indexvalue'],
                            'prev': routeArgs['prev']}.toString());
                          Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                            'maincategory': routeArgs['maincategory'],
                            'catId':  routeArgs['catId'],
                            'catTitle':  routeArgs['catTitle'],
                            'subcatId':  routeArgs['subcatId'],
                            'indexvalue': routeArgs['indexvalue'],
                            'prev': routeArgs['prev'],
                          });
                          break;
                        case "brands_screen":
                          Navigator.of(context).pushReplacementNamed(BrandsScreen.routeName, arguments: {
                            "indexvalue":routeArgs['indexvalue'],
                            "brandId":routeArgs['brandId'],
                          });
                          break;
                        case "searchitem_screen":
                          Navigator.of(context).pop();
                          break;
                        case "sellingitem_screen":
                          Navigator.of(context)
                              .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                            'seeallpress': seeallpress,
                            'title': title,
                          });
                          break;
                        case "shoppinglistitem_screen":
                          Navigator.of(context).pop();
                          break;
                        case "home_screen" :
                          Navigator.of(context).pop();
                          break;
                        case "featured"  :
                          Navigator.of(context)
                              .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                            'seeallpress': "featured",
                            'title': (VxState.store as GroceStore).homescreen.data.featuredByCart.label
                          });
                          break;
                        case "offers" :
                          Navigator.of(context)
                              .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                            'seeallpress': "offers",
                            'title': (VxState.store as GroceStore).homescreen.data.offerByCart.label
                          });
                          break;
                        case "singleproduct_screen" :
                          Navigator.of(context).pop();
                          break;
                        case "discount" :
                          Navigator.of(context)
                              .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                            'seeallpress': "discount",
                            'title': (VxState.store as GroceStore).homescreen.data.discountByCart.label
                          });
                          break;
                        case "forget" :
                          Navigator.of(context)
                              .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                            'seeallpress': "forget",
                            'title': sellingitemData.forgetname
                          });
                          break;
                        case "NotificationScreen":
                          Navigator.of(context).pop();
                          break;
                      }
                      return true;

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 15, bottom: 15),
                      width: 33,
                      height: 33,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ColorCodes.whiteColor),
                      child: Center(child: Icon(Icons.arrow_back, size: 28, color: ColorCodes.blackColor,)),
                    ),
                  ),
                  Spacer(),
                  if(Features.isShare)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (_isIOS) {
                          Share.share(S.current.download_app +
                              IConstants.APP_NAME +
                              '${S.current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                        } else {
                          Share.share(S.current.download_app +
                              IConstants.APP_NAME +
                              '${S.current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 15,bottom: 15),
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorCodes.whiteColor),
                        child: Icon(
                          Icons.share_outlined,
                          size: 23,
                          color: ColorCodes.blackColor,
                        ),
                      ),
                    ),
                  if(Features.isShare)
                    SizedBox(width: 10,),
                  if(Features.isShoppingList)
                    Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        // color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                          if (shoplistData.itemsshoplist.length <= 0) {
                            _dialogforCreatelistTwo(context, shoplistData);
                          } else {
                            _dialogforShoppinglistTwo(context);
                          }
                        },
                        child: Image.asset(
                            Images.addToListImg,width: 25,height: 25,color: Colors.white),
                      ),
                    ),
                  if(Features.isShoppingList)
                    SizedBox(
                      width: 10,
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!PrefUtils.prefs.containsKey("apikey"))
                        {
                          Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                              arguments: {
                                "prev": "signupSelectionScreen",
                              });
                        }
                        else {
                          if(!isSelect){
                            Provider.of<MyorderList>(context,listen: false).AddWishList(singleitemData.singleitems[0].id).then((value) {
                              setState((){
                                isSelect = true;
                              });
                            });
                          }else{
                            Provider.of<MyorderList>(context,listen: false).RemoveWishList(singleitemData.singleitems[0].id).then((value){
                              setState((){
                                isSelect = false;
                              });
                            });
                          }
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15,bottom: 15),
                      padding: EdgeInsets.all(7),
                      width: 33,
                      height: 33,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ColorCodes.whiteColor),
                      child:
                      (isSelect)? Image.asset(
                        Images.wishlist,
                        width: 28,
                        height: 28,
                      ):
                      Image.asset(
                        Images.wish,
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  VxBuilder(
                    mutations: {SetCartItem},

                    builder: (context, store, index) {
                      final box = (VxState.store as GroceStore).CartItemList;

                      if (box.isEmpty)
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                              "after_login": ""
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                            padding: EdgeInsets.all(7),
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorCodes.whiteColor),
                            child:   Image.asset(
                              Images.header_cart,
                              height: 28,
                              width: 28,
                              color: ColorCodes.blackColor,
                            ),
                          ),
                        );


                      return Consumer<CartCalculations>(
                        builder: (_, cart, ch) => Badge(
                          child: ch,
                          color:  ColorCodes.greenColor,
                          value: CartCalculations.itemCount.toString(),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                              "after_login": ""
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                            padding: EdgeInsets.all(7),
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorCodes.whiteColor),
                            child:
                            Image.asset(
                              Images.header_cart,
                              height: 28,
                              width: 28,
                              color: ColorCodes.blackColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10,)
                ],
              )
              :AnimatedBuilder(
                animation: _ColorAnimationController,
                builder: (context, child) =>  Container(
                  height: 60,
                  color: _colorTween.value,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          debugPrint("ssss...."+sellingitemData.featuredname.toString());
                          var title;
                          debugPrint("title1.."+seeallpress.toString());
                          if(seeallpress=="featured"){
                            title =(VxState.store as GroceStore).homescreen.data.featuredByCart.label;
                          }else if(seeallpress=="offers"){
                            title =(VxState.store as GroceStore).homescreen.data.offerByCart.label;
                          }else if(seeallpress=="discount"){
                            title =(VxState.store as GroceStore).homescreen.data.discountByCart.label;
                          }
                          switch(fromScreen){
                            case "sellingitem_screen":
                              Navigator.of(context)
                                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                                'seeallpress': seeallpress,
                                'title': title,
                              });
                              return false;
                              break;
                            case "not_product_screen":
                              Navigator.of(context).pop();
                              break;
                            case "item_screen":
                              print("fs iten: "+{ 'maincategory': routeArgs['maincategory'],
                                'catId':  routeArgs['catId'],
                                'catTitle':  routeArgs['catTitle'],
                                'subcatId':  routeArgs['subcatId'],
                                'indexvalue': routeArgs['indexvalue'],
                                'prev': routeArgs['prev']}.toString());
                              Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                                'maincategory': routeArgs['maincategory'],
                                'catId':  routeArgs['catId'],
                                'catTitle':  routeArgs['catTitle'],
                                'subcatId':  routeArgs['subcatId'],
                                'indexvalue': routeArgs['indexvalue'],
                                'prev': routeArgs['prev'],
                              });
                              break;
                            case "brands_screen":
                              Navigator.of(context).pushReplacementNamed(BrandsScreen.routeName, arguments: {
                                "indexvalue":routeArgs['indexvalue'],
                                "brandId":routeArgs['brandId'],
                              });
                              break;
                            case "searchitem_screen":
                              Navigator.of(context).pop();
                              break;
                            case "sellingitem_screen":
                              Navigator.of(context)
                                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                                'seeallpress': seeallpress,
                                'title': title,
                              });
                              break;
                            case "shoppinglistitem_screen":
                              Navigator.of(context).pop();
                              break;
                            case "wishlist_screen":
                              Navigator.of(context)
                                  .pushReplacementNamed(WishListScreen.routeName, arguments: {
                                'seeallpress': seeallpress,
                                'title': title,
                              });
                              break;
                            case "home_screen" :
                              Navigator.of(context).pop();
                              break;
                            case "featured"  :
                              Navigator.of(context)
                                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                                'seeallpress': "featured",
                                'title': (VxState.store as GroceStore).homescreen.data.featuredByCart.label
                              });
                              break;
                            case "offers" :
                              Navigator.of(context)
                                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                                'seeallpress': "offers",
                                'title': (VxState.store as GroceStore).homescreen.data.offerByCart.label
                              });
                              break;
                            case "singleproduct_screen" :
                              Navigator.of(context).pop();
                              break;
                            case "discount" :
                              Navigator.of(context)
                                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                                'seeallpress': "discount",
                                'title': (VxState.store as GroceStore).homescreen.data.discountByCart.label
                              });
                              break;
                            case "forget" :
                              Navigator.of(context)
                                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                                'seeallpress': "forget",
                                'title': sellingitemData.forgetname
                              });
                              break;
                            case "NotificationScreen":
                              Navigator.of(context).pop();
                              break;
                          }
                          return true;
                          // Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15, left: 15, bottom: 15),
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorCodes.whiteColor),
                          child: Center(child: Icon(Icons.arrow_back, size: 28, color: ColorCodes.blackColor,)),
                        ),
                      ),
                      Spacer(),
                      if(Features.isShare)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            if (_isIOS) {
                              Share.share(S.current.download_app +
                                  IConstants.APP_NAME +
                                  '${S.current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                            } else {
                              Share.share(S.current.download_app +
                                  IConstants.APP_NAME +
                                  '${S.current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 15,bottom: 15),
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorCodes.whiteColor),
                            child: Icon(
                              Icons.share_outlined,
                              size: 23,
                              color: ColorCodes.blackColor,
                            ),
                          ),
                        ),
                      if(Features.isShare)
                        SizedBox(width: 10,),
                      if(Features.isShoppingList)
                        Container(
                          width: 25,
                          height: 25,
                          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            // color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                              if (shoplistData.itemsshoplist.length <= 0) {
                                _dialogforCreatelistTwo(context, shoplistData);
                              } else {
                                _dialogforShoppinglistTwo(context);
                              }
                            },
                            child: /*Icon(
                      Icons.add,
                      size: 18,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    )*/Image.asset(
                                Images.addToListImg,width: 25,height: 25,color: Colors.white),
                          ),
                        ),
                      if(Features.isShoppingList)
                        SizedBox(
                          width: 10,
                        ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!PrefUtils.prefs.containsKey("apikey"))
                            {
                              Navigator.of(context).pushNamed(
                                  SignupSelectionScreen.routeName,
                                  arguments: {
                                    "prev": "signupSelectionScreen",
                                  });
                            }
                            else {
                              if(!isSelect){
                                Provider.of<MyorderList>(context,listen: false).AddWishList(singleitemData.singleitems[0].id).then((value) {
                                  setState((){
                                    isSelect = true;
                                  });
                                });
                              }else{
                                Provider.of<MyorderList>(context,listen: false).RemoveWishList(singleitemData.singleitems[0].id).then((value){
                                  setState((){
                                    isSelect = false;
                                  });
                                });
                              }
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15,bottom: 15),
                          padding: EdgeInsets.all(7),
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorCodes.whiteColor),
                          child:
                          (isSelect)? Image.asset(
                            Images.wishlist,
                            width: 28,
                            height: 28,
                          ):
                          Image.asset(
                            Images.wish,
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      VxBuilder(
                        mutations: {SetCartItem},
                        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                        builder: (context, store, index) {
                          final box = (VxState.store as GroceStore).CartItemList;

                          if (box.isEmpty)
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                                  "after_login": ""
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                                padding: EdgeInsets.all(7),
                                width: 33,
                                height: 33,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ColorCodes.whiteColor),
                                child:   Image.asset(
                                  Images.header_cart,
                                  height: 28,
                                  width: 28,
                                  color: ColorCodes.blackColor,
                                ),
                              ),
                            );


                          return Consumer<CartCalculations>(
                            builder: (_, cart, ch) => Badge(
                              child: ch,
                              color:  ColorCodes.greenColor,
                              value: CartCalculations.itemCount.toString(),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                                  "after_login": ""
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                                padding: EdgeInsets.all(7),
                                width: 33,
                                height: 33,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ColorCodes.whiteColor),
                                child: /*Icon(
                            Icons.shopping_cart_outlined,
                            size: 18,
                            color: Colors.white,
                          ),*/
                                Image.asset(
                                  Images.header_cart,
                                  height: 28,
                                  width: 28,
                                  color: ColorCodes.blackColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10,)
                    ],
                  ),
                ),
              ),
            ),
          ),
          _isWeb ? SizedBox.shrink() : Align(
            alignment: Alignment.bottomCenter,
            child: Container(

                width: MediaQuery.of(context).size.width,

                child: _buildBottomNavigationBar()),
          ),
        ],
      )
     
      // bottomNavigationBar:_isWeb ? SizedBox.shrink() :_isLoading?null:Padding(
      //   padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
      //   child:_buildBottomNavigationBar(),
      // ),
    );
  }

  AppBarMobile(Map<String, dynamic> routeArgs, SellingItemsList sellingitemData){
    return  AppBar(
      toolbarHeight: 0.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      title: Text(itemname,style: TextStyle(color: ColorCodes.menuColor),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color:ColorCodes.menuColor),
        onPressed: () {
debugPrint("ssss...."+sellingitemData.featuredname.toString());
var title;
debugPrint("title1.."+seeallpress.toString());
if(seeallpress=="featured"){
  title =(VxState.store as GroceStore).homescreen.data.featuredByCart.label;
}else if(seeallpress=="offers"){
  title =(VxState.store as GroceStore).homescreen.data.offerByCart.label;
}else if(seeallpress=="discount"){
  title =(VxState.store as GroceStore).homescreen.data.discountByCart.label;
}
          switch(fromScreen){
            case "sellingitem_screen":
              Navigator.of(context)
                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                'seeallpress': seeallpress,
                'title': title,
              });
            /*  Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                'maincategory': routeArgs['maincategory'],
                'catId':  routeArgs['catId'],
                'catTitle':  routeArgs['catTitle'],
                'subcatId':  routeArgs['subcatId'],
                'indexvalue': routeArgs['indexvalue'],
                'prev': routeArgs['prev'],
              });*/
              return false;
              break;
            case "not_product_screen":
              Navigator.of(context).pop();
              break;
            case "item_screen":
              print("fs iten: "+{ 'maincategory': routeArgs['maincategory'],
                'catId':  routeArgs['catId'],
                'catTitle':  routeArgs['catTitle'],
                'subcatId':  routeArgs['subcatId'],
                'indexvalue': routeArgs['indexvalue'],
                'prev': routeArgs['prev']}.toString());
              Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                'maincategory': routeArgs['maincategory'],
                'catId':  routeArgs['catId'],
                'catTitle':  routeArgs['catTitle'],
                'subcatId':  routeArgs['subcatId'],
                'indexvalue': routeArgs['indexvalue'],
                'prev': routeArgs['prev'],
              });
              break;
            case "brands_screen":
              Navigator.of(context).pushReplacementNamed(BrandsScreen.routeName, arguments: {
                "indexvalue":routeArgs['indexvalue'],
                "brandId":routeArgs['brandId'],
              });
              break;
            case "searchitem_screen":
              Navigator.of(context).pop();
              break;
            case "sellingitem_screen":
              Navigator.of(context)
                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                'seeallpress': seeallpress,
                'title': title,
              });
              break;
            case "shoppinglistitem_screen":
              Navigator.of(context).pop();
              break;
            case "home_screen" :
              Navigator.of(context).pop();
              break;
            case "featured"  :
              Navigator.of(context)
                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                'seeallpress': "featured",
                'title': (VxState.store as GroceStore).homescreen.data.featuredByCart.label
              });
              break;
            case "offers" :
              Navigator.of(context)
                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                'seeallpress': "offers",
                'title': (VxState.store as GroceStore).homescreen.data.offerByCart.label
              });
              break;
            case "singleproduct_screen" :
              Navigator.of(context).pop();
              break;
            case "discount" :
              Navigator.of(context)
                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                'seeallpress': "discount",
                'title': (VxState.store as GroceStore).homescreen.data.discountByCart.label
              });
              break;
            case "forget" :
              Navigator.of(context)
                  .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
                'seeallpress': "forget",
                'title': sellingitemData.forgetname
              });
              break;
            case "NotificationScreen":
              Navigator.of(context).pop();
              break;
          }
          return true;
          // Navigator.of(context).pop();
        },
      ),
      actions: [
        // Container(
        //   width: 25,
        //   height: 25,
        //   margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(100),
        //    // color: Colors.white,
        //   ),
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.of(context).pushNamed(
        //         SearchitemScreen.routeName,
        //       );
        //     },
        //     child: Icon(
        //       Icons.search,
        //       size: 20,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   width: 15,
        // ),
        if(Features.isShare)
          Container(
            width: 25,
            height: 25,
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
             // color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                if (_isIOS) {
                  Share.share(S.current.download_app +
                      IConstants.APP_NAME +
                      '${S.current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                } else {
                  Share.share(S.current.download_app +
                      IConstants.APP_NAME +
                      '${S.current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                }
              },
              child: Icon(
                Icons.share_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        if(Features.isShare)
        SizedBox(width: 15,),
        if(Features.isShoppingList)
        Container(
          width: 25,
          height: 25,
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
           // color: Colors.white,
          ),
          child: GestureDetector(
            onTap: () {
              final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

              if (shoplistData.itemsshoplist.length <= 0) {
                _dialogforCreatelistTwo(context, shoplistData);
              } else {
                _dialogforShoppinglistTwo(context);
              }
            },
            child: /*Icon(
              Icons.add,
              size: 18,
              color: Theme
                  .of(context)
                  .primaryColor,
            )*/Image.asset(
              Images.addToListImg,width: 25,height: 25,color: Colors.white),
          ),
        ),
        if(Features.isShoppingList)
        SizedBox(
          width: 15,
        ),
        VxBuilder(
          mutations: {SetCartItem},
          // valueListenable: Hive.box<Product>(productBoxName).listenable(),
          builder: (context, store, index) {
            final box = (VxState.store as GroceStore).CartItemList;

            if (box.isEmpty)
              return GestureDetector(
                onTap: () {
                   Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                     "after_login": ""
                   });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                     /* color: Theme.of(context).buttonColor*/),
                  child:   Image.asset(
                    Images.header_cart,
                    height: 28,
                    width: 28,
                    color: Colors.white,
                  ),
                ),
              );


            return Consumer<CartCalculations>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                color:  ColorCodes.greenColor,
                value: CartCalculations.itemCount.toString(),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                    "after_login": ""
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                     /* color: Theme.of(context).buttonColor*/),
                  child: /*Icon(
                    Icons.shopping_cart_outlined,
                    size: 18,
                    color: Colors.white,
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
        SizedBox(width: 10,)
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorCodes.accentColor,
                  ColorCodes.primaryColor
                ])
        ),
      ),
    );
  }
}

class UpdateCart extends ValueNotifier {
  var varid;
  var i;
  var products;


  UpdateCart(value, this.i, this.varid, this.products) : super(value);
  updatecart(){
    if (Hive.box<Product>(productBoxName).values.elementAt(i).varId == int.parse(varid)) {
      Hive.box<Product>(productBoxName).putAt(i, products);
      notifyListeners() ;
    }
  }
}