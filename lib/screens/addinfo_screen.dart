import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/api.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../data/calculations.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/user.dart';
import '../../screens/addressbook_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/category_screen.dart';
import '../../screens/confirmorder_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/map_screen.dart';
import '../../screens/membership_screen.dart';
import '../../screens/otpconfirm_screen.dart';
import '../../screens/payment_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/return_screen.dart';
import '../../screens/shoppinglist_screen.dart';
import '../../screens/signup_selection_screen.dart';
import '../../screens/subscribe_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../widgets/badge.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/features.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'location_screen.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../utils/prefUtils.dart';
import '../models/newmodle/address.dart'as newaddress;

class AddInfo extends StatefulWidget {
  static const routeName = '/addinfo_screen';

  @override
  AddInfoState createState() => AddInfoState();
}

class AddInfoState extends State<AddInfo> {
  final _lnameFocusNode = FocusNode();
  bool valuefirst = false;
  bool _isWeb = false;
  Widget _child;
  var _addresstag = "Home";
  var _home = ColorCodes.ratestarcolor;
  var _work = Colors.grey;
  var _other = Colors.grey;
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  String _lat, _lng;
  String fn = "";
  Timer timer;
  double _homeWidth = 2.0;
  double _workWidth = 1.0;
  double _otherWidth = 1.0;
  String addresstype = "";
  String addressid = "";
  String _address = "",addressLine="";
  String ln = "";
  String ea = "";
  String mb = "";
  String pn = "";
  String fl = "";
  String st = "";
  String ld = "";
  String ct = "";
  String stt = "";
  String fulladdress="";

  int _groupValue = 1;


  String _latitude = "";
  String _longitude = "";
  String _deliverylocation = "";
  String _branch = "";
  List<CartItem> productBox=[];
  bool _isDelivering = true;
  var lastname = "", fullName="", email = "", phone = "", pincode = "", area = "", houseno = "", street = "", landmark = "", city = "", state = "", _addresstagedit="";
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();
  final TextEditingController mobileNumberController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  TextEditingController _controllerHouseno = new TextEditingController();
  TextEditingController _controllerCity = new TextEditingController();
  TextEditingController _controllerLandmark = new TextEditingController();
  TextEditingController _controllerArea = new TextEditingController();
  TextEditingController _controllerPincode = new TextEditingController();
  TextEditingController _controllerState = new TextEditingController();
  GoogleMapController _controller;
  bool iphonex = false;
  GroceStore store = VxState.store;
  UserData userdata;
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
    } print("xcfvv");
    //userdata = (VxState.store as GroceStore).userData;
    Future.delayed(Duration.zero, () async {
      print("xcfvv");
      //prefs = await SharedPreferences.getInstance();
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _lat = PrefUtils.prefs.getString("latitude");
      _lng = PrefUtils.prefs.getString("longitude");
      addresstype= routeArgs['addresstype'];

      addressid = routeArgs['addressid'];
      fullName = store.userData.username;
      print("dfkjvnv0" + store.userData.username.toString());
      firstnamecontroller.text = store.userData.username;
      mobileNumberController.text = store.userData.mobileNumber;
      if(routeArgs['delieveryLocation'] == "") {

        setState(() {

          _deliverylocation = PrefUtils.prefs.getString("deliverylocation");
          _latitude = PrefUtils.prefs.getString('latitude');
          _longitude = PrefUtils.prefs.getString('longitude');
          _branch = PrefUtils.prefs.getString("branch");
        });
      } else {

        setState(() {
          _deliverylocation = routeArgs['delieveryLocation'];
          _latitude = routeArgs['latitude'];
          _longitude = routeArgs['longitude'];
          _branch = routeArgs['branch'];
          fullName = routeArgs['fullName'];
          houseno = routeArgs['houseno'];
          area = routeArgs['area'];
          landmark = routeArgs['landmark'];
          city = routeArgs['city'];
          state = routeArgs['state'];
          pincode = routeArgs['pincode'];
          phone = routeArgs['mobile'];
          _addresstagedit = routeArgs['addresstag'];
          if(_addresstagedit == "Home"){
            _groupValue = 1;

          }else if(_addresstagedit == "Office"){
            _groupValue = 2;
          }else if(_addresstagedit == "Other"){
            _groupValue = 3;
          }
          debugPrint("_addresstag..."+_addresstagedit);

          firstnamecontroller.text = fullName;
          mobileNumberController.text = phone;
          emailController.text = email;
          _controllerHouseno.text = houseno;
          _controllerCity.text = city;
          _controllerState.text = state;
          _controllerLandmark.text = landmark;
          _controllerArea.text = area;
          _controllerPincode.text = pincode;
          _addresstag = _addresstagedit;
        });
      }

    });
    super.initState();
  }

  Future<void> _getOtp(String mobile) async {
    try {
      final response = await http.post(Api.preRegister, body: {
        // await keyword is used to wait to this operation is complete.
        "mobileNumber": mobile,
        "tokenId": PrefUtils.prefs.getString('tokenid'),
        "signature": PrefUtils.prefs.containsKey("signature") ? PrefUtils.prefs.getString('signature') : "",
      });
      final responseJson = json.decode(response.body);
      final data = responseJson['data'] as Map<String, dynamic>;


      if (responseJson['status'].toString() == "true") {
        if(responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          return Fluttertoast.showToast(msg:
          S.of(context).mobile_exists,
            // "Mobile Number already exists!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else {
          Navigator.of(context).pop();
          PrefUtils.prefs.setString('Otp', data['otp'].toString());
          PrefUtils.prefs.setString('Mobilenum',mobileNumberController.text);
          debugPrint("otp...edit"+PrefUtils.prefs.getString('Otp'));
          Navigator.of(context).pushNamed(OtpconfirmScreen.routeName,
              arguments: {
                "prev":"editscreen",
                "firstName":firstnamecontroller.text,
                "mobileNum":mobileNumberController.text,
                "email":emailController.text,
              });
        }
//        Navigator.of(context).pushNamed(
//          OtpconfirmScreen.routeName,
//        );

      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      throw error;
    }
  }
  _dialogforSaveadd(BuildContext context) {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: 100.0,
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(width: 40.0,),
                          Text(
                            S.of(context).saving,//'Saving...'
                          ),
                        ],
                      )
                  ),
                );
              }
          );
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
  @override
  void dispose() {
    timer?.cancel();
    _controllerHouseno.dispose();
    _controllerCity.dispose();
    _controllerLandmark.dispose();
    _controllerArea.dispose();
    _controllerPincode.dispose();
    _controllerState.dispose();
    super.dispose();
  }
  _saveaddress() async {
    print("lat long......"+ _lat.toString()+"hgfhdsjdsd"+_lng.toString());
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    PrefUtils.prefs.setString('newaddresstype', _addresstag);
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } else {
      _dialogforSaveadd(context);
      setState(() {
        _isLoading = true;
      });


      if(addresstype == "edit") {
        print('edit,,,,,'+addressid+"  "+_controllerPincode.text+"  "+firstnamecontroller.text+ "  "+mobileNumberController.text+"  "+
            _addresstag+"  "+_controllerArea.text+"  "+_controllerHouseno.text+"  "+_controllerState.text+"  "+_controllerCity.text+" "+_controllerLandmark.text);
        AddressController addressController = AddressController();
        await addressController.update(newaddress.Address(id: int.parse(addressid),customer: PrefUtils.prefs.getString("apikey"),apartment:"",mobileno:"",
            street:"",type: _addresstag, pincode: _controllerPincode.text,fullName: firstnamecontroller.text ,mobile: mobileNumberController.text,addressType: _addresstag,
            address:"", lattitude:_lat.toString(),logingitude: _lng.toString(), isdefault: "1", area: _controllerArea.text, houseno: _controllerHouseno.text,
            state: _controllerState.text,city: _controllerCity.text, landmark: _controllerLandmark.text),(value){
          debugPrint("value...."+value.toString());
          if(value){
            _isLoading = false;
            Navigator.of(context).pop();
            debugPrint("addressbook...."+PrefUtils.prefs.getString("addressbook"));
            if (PrefUtils.prefs.containsKey("addressbook")) {
              if (PrefUtils.prefs.getString("addressbook") == "AddressbookScreen") {
                PrefUtils.prefs.setString("addressbook", "");
               // Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(
                    AddressbookScreen.routeName);
              }else if (PrefUtils.prefs.getString("addressbook") == "returnscreen") {
                Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                  'orderid': routeArgs['orderid'],
                  'title':routeArgs['title'],
                });
              } else if (PrefUtils.prefs.getString("addressbook") == "SubscriptionScreen") {
                PrefUtils.prefs.setString("addressbook", "");
                Navigator.of(context).pushReplacementNamed(
                    SubscribeScreen.routeName,arguments: {
                  "itemname": routeArgs['itemname'].toString(),
                  "itemid": routeArgs['itemid'].toString(),
                  "itemimg":routeArgs['itemimg'].toString(),
                  "varname": routeArgs['varname'].toString(),
                  "varprice": routeArgs['varprice'].toString(),
                  "paymentMode":routeArgs['paymentMode'].toString(),
                  "cronTime": routeArgs['cronTime'].toString(),
                  "name": routeArgs['name'].toString(),
                  "varid": routeArgs['varid'].toString(),
                  "varmrp":routeArgs['varmrp'].toString(),
                  "brand": routeArgs['brand'].toString()
                  //"varid": routeArgs['varid'].toString(),
                });
              }else {
                debugPrint("payment 1......");
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(PaymentScreen.routeName, arguments: {
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
                  'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
                  'fromScreen':'addaddress',
                  'responsejson':"",
                });
              }
            }
            else {
              debugPrint("payment 2......");
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushNamed(PaymentScreen.routeName, arguments: {
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
                'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
                'fromScreen':'addaddress',
                'responsejson':"",
              });
            }
          }
        });
      }
      else {
        print('helooo,,,,,'+firstnamecontroller.text+"  "+_addresstag);
        AddressController addressController = AddressController();
        await addressController.add(
            newaddress.Address(customer: PrefUtils.prefs.getString("apikey"),
              pincode: _controllerPincode.text ,fullName: firstnamecontroller.text, mobile: mobileNumberController.text,
              addressType: _addresstag,lattitude:_lat.toString(),logingitude: _lng.toString(),isdefault: "1",
              houseno: _controllerHouseno.text, landmark: _controllerLandmark.text, area: _controllerArea.text,
              city: _controllerCity.text, state: _controllerState.text,),(value){
          if(value){
            print('helooo1,,,,,');
            Navigator.of(context).pop();
            if (PrefUtils.prefs.containsKey("addressbook")) {
              print('helooo1,,,,,1');
              if (PrefUtils.prefs.getString("addressbook") == "AddressbookScreen") {
                print('helooo1,,,,,2');
                PrefUtils.prefs.setString("addressbook", "");
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(
                    AddressbookScreen.routeName);
              }else if (PrefUtils.prefs.getString("addressbook") == "returnscreen") {
                print('helooo1,,,,,3');
                Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                  'orderid': routeArgs['orderid'],
                  'title':routeArgs['title'],
                });
              }  else if (PrefUtils.prefs.getString("addressbook") == "SubscriptionScreen") {
                print('helooo1,,,,,4');
                PrefUtils.prefs.setString("addressbook", "");
                Navigator.of(context).pushReplacementNamed(
                    SubscribeScreen.routeName,arguments: {
                  "itemname": routeArgs['itemname'].toString(),
                  "itemid": routeArgs['itemid'].toString(),
                  "itemimg":routeArgs['itemimg'].toString(),
                  "varname": routeArgs['varname'].toString(),
                  "varprice": routeArgs['varprice'].toString(),
                  "paymentMode":routeArgs['paymentMode'].toString(),
                  "cronTime": routeArgs['cronTime'].toString(),
                  "name": routeArgs['name'].toString(),
                  "varid": routeArgs['varid'].toString(),
                  "varmrp":routeArgs['varmrp'].toString(),
                  "brand": routeArgs['brand'].toString()
                  //"varid": routeArgs['varid'].toString(),
                });
              }else if (PrefUtils.prefs.getString("addressbook") == "confirm") {
                print('helooo1,,,,,4');
                PrefUtils.prefs.setString("addressbook", "");
                Navigator.of(context).pushNamed(
                    ConfirmorderScreen.routeName,
                    arguments: {"prev": "cart_screen"});
              }else {
                print('helooo1,,,,,6');
              //  Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(PaymentScreen.routeName, arguments: {
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
                  'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
                  'fromScreen':'addaddress',
                  'responsejson':"",
                });
              }
            }
            else if(routeArgs['prev'] == "signupselection"){
              print('helooo1,,,,,5');
              Navigator.of(context).pushReplacementNamed(
                  CartScreen.routeName,
                  arguments: {"prev": "address_screen",
                    "after_login":""});
            }else {
              print('helooo1,,,,,7');
              if (productBox.length > 0) {
                if (PrefUtils.prefs.getString("mobile").toString() != "null") {
                  print('helooo1,,,,,8');
                  PrefUtils.prefs.setString("isPickup", "no");
                  debugPrint("payment 4......");
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(PaymentScreen.routeName, arguments: {
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
                    'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
                    'fromScreen':'addaddress',
                    'responsejson':"",
                  });
                }
                else {


                  Navigator.of(context)
                      .pushNamed(LoginScreen.routeName,
                      arguments: {
                        "prev": "addressScreen"
                      });
                }

              } else {
                Navigator.of(context).pushReplacementNamed(
                  HomeScreen.routeName,
                );
              }
            }
          }
        });

        // Provider.of<AddressItemsList>(context, listen: false).NewAddress(
        //     _lat.toString(), _lng.toString(), _branch).then((_) {
        //   Provider.of<AddressItemsList>(context, listen: false)
        //       .fetchAddress()
        //       .then((_) {
        //     Navigator.of(context).pop();
        //     if (PrefUtils.prefs.containsKey("addressbook")) {
        //       if (PrefUtils.prefs.getString("addressbook") == "AddressbookScreen") {
        //         PrefUtils.prefs.setString("addressbook", "");
        //         Navigator.of(context).pop();
        //         Navigator.of(context).pushReplacementNamed(
        //             AddressbookScreen.routeName);
        //       }else if (PrefUtils.prefs.getString("addressbook") == "returnscreen") {
        //         Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
        //           'orderid': routeArgs['orderid'],
        //           'title':routeArgs['title'],
        //         });
        //       }  else if (PrefUtils.prefs.getString("addressbook") == "SubscriptionScreen") {
        //         PrefUtils.prefs.setString("addressbook", "");
        //         Navigator.of(context).pushReplacementNamed(
        //             SubscribeScreen.routeName,arguments: {
        //           "itemname": routeArgs['itemname'].toString(),
        //           "itemid": routeArgs['itemid'].toString(),
        //           "itemimg":routeArgs['itemimg'].toString(),
        //           "varname": routeArgs['varname'].toString(),
        //           "varprice": routeArgs['varprice'].toString(),
        //           "paymentMode":routeArgs['paymentMode'].toString(),
        //           "cronTime": routeArgs['cronTime'].toString(),
        //           "name": routeArgs['name'].toString(),
        //           "varid": routeArgs['varid'].toString(),
        //           "varmrp":routeArgs['varmrp'].toString(),
        //           "brand": routeArgs['brand'].toString()
        //           //"varid": routeArgs['varid'].toString(),
        //         });
        //       }else {
        //         Navigator.of(context).pop();
        //         Navigator.of(context).pushReplacementNamed(
        //             ConfirmorderScreen.routeName,
        //             arguments: {
        //               "prev": "address_screen",
        //             }
        //         );
        //       }
        //     }else {
        //       if (productBox.length > 0) {
        //         if (PrefUtils.prefs.getString("mobile").toString() != "null") {
        //           PrefUtils.prefs.setString("isPickup", "no");
        //
        //           Navigator.of(context).pushReplacementNamed(
        //               ConfirmorderScreen.routeName,
        //               arguments: {"prev": "cart_screen"});
        //         }
        //         else {
        //
        //
        //           Navigator.of(context)
        //               .pushNamed(LoginScreen.routeName,
        //               arguments: {
        //                 "prev": "addressScreen"
        //               });
        //         }
        //
        //       } else {
        //         Navigator.of(context).pushReplacementNamed(
        //           HomeScreen.routeName,
        //         );
        //       }
        //     }
        //   });
        // });
      }
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        if(routeArgs['title'] == "addressbook") {
          Navigator.of(context).pushReplacementNamed(
              AddressbookScreen.routeName);
        }
        else{
          Navigator.of(context).pushReplacementNamed(
              CartScreen.routeName,arguments: {
            "after_login": ""
          }
          );
        }
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
        body:  Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            _body(),
          ],
        ),
        bottomNavigationBar: _isWeb ? SizedBox.shrink() : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child:_bottomNavigationbar(),
        ),
      ),
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
             // Navigator.of(context).pop();
            final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
            if(routeArgs['title'] == "addressbook") {
              Navigator.of(context).pushReplacementNamed(
                  AddressbookScreen.routeName);
            }
            else if(PrefUtils.prefs.containsKey("addressbook")) {
              if (PrefUtils.prefs.getString("addressbook") == "confirm") {
                Navigator.of(context).pushNamed(
                    ConfirmorderScreen.routeName,
                    arguments: {"prev": "cart_screen"});
              }
              else if (PrefUtils.prefs.getString("addressbook") == "payment"){
                Navigator.of(context)
                    .pushNamed(PaymentScreen.routeName, arguments: {
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
                  'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
                  'fromScreen':'addaddress',
                  'responsejson':"",
                });
              }
            }
            else{
              Navigator.of(context).pushReplacementNamed(
                  CartScreen.routeName,arguments: {
                "after_login": ""
              }
              );
            }
            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            return Future.value(false);
          }
      ),
      title: Text(
        S.of(context).add_address,

        // 'Add Address',
        style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),
      ),
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorCodes.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 5),
              )
            ],
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
  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return Radio(
      activeColor: ColorCodes.blackColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,

    );
  }
  _body(){
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Full Name *",
                      // '* What should we call you?',
                      style: TextStyle(fontSize: 15, color: ColorCodes.mediumBlackWebColor),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      textAlign: TextAlign.left,
                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      controller: firstnamecontroller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        //FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            fn = "  Please enter name";
                          });
                          return '';
                        }
                        setState(() {
                          fn = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addFirstnameToSF(value);
                      },
                    ),
                    Text(
                      fn,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      S.of(context).mobile_number + " " +"*",
                      // 'Mobile number',
                      style: TextStyle(fontSize: 15, color: ColorCodes.mediumBlackWebColor),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      keyboardType: TextInputType.number,
                      controller: mobileNumberController,
                      inputFormatters: [LengthLimitingTextInputFormatter(12)],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: ColorCodes.lightgrey, width: 1.2),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            mb = "  Please enter number";
                          });
                          return '';
                        }
                        setState(() {
                          mb = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      mb,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      "Pin Code *",
                      // 'Mobile number',
                      style: TextStyle(fontSize: 15, color: ColorCodes.mediumBlackWebColor),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _controllerPincode,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(12)],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: ColorCodes.lightgrey, width: 1.2),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            pn = "  Please enter pincode";
                          });
                          return '';
                        }
                        setState(() {
                          pn = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      pn,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    // SizedBox(height: 15),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.stretch,
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.of(context)
                    //             .pushNamed(MapScreen.routeName);
                    //       },
                    //       child: Row(
                    //         children: [
                    //           Icon(Icons.location_searching, color: ColorCodes.blackColor, size: 15),
                    //           SizedBox(width: 5.0),
                    //           Text("Use my location",
                    //           style: TextStyle(fontSize: 15, color: ColorCodes.discountoff, fontWeight: FontWeight.w700,
                    //             decoration: TextDecoration.underline,),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _controllerHouseno,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        hintText: "Flat, House No, Building, Company * ",
                        hintStyle: TextStyle(color: ColorCodes.greyColor, fontSize: 15, fontWeight: FontWeight.w500 ),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        //FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            fl = "  Please enter Flat, House No, Building, Company";
                          });
                          return '';
                        }
                        setState(() {
                          fl = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      fl,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.left,
                        controller:_controllerArea,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        hintText: "Street Name, Area* ",
                        hintStyle: TextStyle(color: ColorCodes.greyColor, fontSize: 15, fontWeight: FontWeight.w500 ),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        //FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            st = "  Please enter Street Name, Area";
                          });
                          return '';
                        }
                        setState(() {
                          st = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      st,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _controllerLandmark,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        hintText: "Landmark * ",
                        hintStyle: TextStyle(color: ColorCodes.greyColor, fontSize: 15, fontWeight: FontWeight.w500 ),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        //FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            ld = "  Please enter Landmark";
                          });
                          return '';
                        }
                        setState(() {
                          ld = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      ld,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _controllerCity,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        hintText: "City / District * ",
                        hintStyle: TextStyle(color: ColorCodes.greyColor, fontSize: 15, fontWeight: FontWeight.w500 ),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        //FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            ct = "  Please enter City / District";
                          });
                          return '';
                        }
                        setState(() {
                          ct = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      ct,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _controllerState,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        hintText: "State * ",
                        hintStyle: TextStyle(color: ColorCodes.greyColor, fontSize: 15, fontWeight: FontWeight.w500 ),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                      //  FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            stt = "  Please enter State";
                          });
                          return '';
                        }
                        setState(() {
                          stt = "";
                        });
                        return null;
                      },
                      onSaved: (value) {
                        //addEmailToSF(value);
                      },
                    ),
                    Text(
                      stt,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Type *",
                      // '* What should we call you?',
                      style: TextStyle(fontSize: 15, color: ColorCodes.mediumBlackWebColor),

                    ),
                    SizedBox(height: 5),
                    // Row(
                    //   children: <Widget>[
                    //     Spacer(),
                    //     MouseRegion(
                    //       cursor: SystemMouseCursors.click,
                    //       child: GestureDetector(
                    //         behavior: HitTestBehavior.translucent,
                    //         onTap: () {
                    //           setState(() {
                    //             _addresstag = "Home";
                    //             _home = Theme.of(context).primaryColor;
                    //             _work = Colors.grey;
                    //             _other = Colors.grey;
                    //             _homeWidth = 2.0;
                    //             _workWidth = 1.0;
                    //             _otherWidth = 1.0;
                    //           });
                    //         },
                    //         child: Container(
                    //           width: 60.0,
                    //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),
                    //               border: Border(
                    //                 top: BorderSide(width: _homeWidth, color: _home,),
                    //                 bottom: BorderSide(width: _homeWidth, color: _home,),
                    //                 left: BorderSide(width: _homeWidth, color: _home),
                    //                 right: BorderSide(width: _homeWidth, color: _home),
                    //               )),
                    //           height: 35.0,
                    //           child: Center(
                    //             child: Text(
                    //               S.of(context).home,//"Home",
                    //               style: TextStyle(
                    //                 fontSize: 14.0,
                    //                 color: Colors.black54,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Spacer(),
                    //     MouseRegion(
                    //       cursor: SystemMouseCursors.click,
                    //       child: GestureDetector(
                    //         behavior: HitTestBehavior.translucent,
                    //         onTap: () {
                    //           setState(() {
                    //             _addresstag = "Work";
                    //             _home = Colors.grey;
                    //             _work = Theme.of(context).primaryColor;
                    //             _other = Colors.grey;
                    //             _homeWidth = 1.0;
                    //             _workWidth = 2.0;
                    //             _otherWidth = 1.0;
                    //           });
                    //         },
                    //         child: Container(
                    //           width: 60.0,
                    //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),
                    //               border: Border(
                    //                 top: BorderSide(width: _workWidth, color: _work,),
                    //                 bottom: BorderSide(width: _workWidth, color: _work,),
                    //                 left: BorderSide(width: _workWidth, color: _work,),
                    //                 right: BorderSide(width: _workWidth, color: _work,),
                    //               )),
                    //           height: 35.0,
                    //           child: Center(
                    //             child: Text(
                    //               S.of(context).office,//"Office",
                    //               style: TextStyle(
                    //                 fontSize: 14.0,
                    //                 color: Colors.black54,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Spacer(),
                    //     MouseRegion(
                    //       cursor: SystemMouseCursors.click,
                    //       child: GestureDetector(
                    //         behavior: HitTestBehavior.translucent,
                    //         onTap: () {
                    //           setState(() {
                    //             _addresstag = "Other";
                    //             _home = Colors.grey;
                    //             _work = Colors.grey;
                    //             _other = Theme.of(context).primaryColor;
                    //             _homeWidth = 1.0;
                    //             _workWidth = 1.0;
                    //             _otherWidth = 2.0;
                    //           });
                    //         },
                    //         child: Container(
                    //           width: 60,
                    //           height: 35.0,
                    //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),
                    //               border: Border(
                    //                 top: BorderSide(width: _otherWidth, color: _other,),
                    //                 bottom: BorderSide(width: _otherWidth, color: _other,),
                    //                 left: BorderSide(width: _otherWidth, color: _other,),
                    //                 right: BorderSide(width: _otherWidth, color: _other,),
                    //               )),
                    //           child: Center(
                    //             child: Text(
                    //               S.of(context).other,//"Other",
                    //               style: TextStyle(
                    //                 fontSize: 14.0,
                    //                 color: Colors.black54,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Spacer(),
                    //   ],
                    // ),
                  Container(
                    decoration:   BoxDecoration(border: Border(
                      top: BorderSide( color: ColorCodes.lightGreyColor,width: 1),
                      bottom: BorderSide(  color: ColorCodes.lightGreyColor,width: 1),
                      left: BorderSide(  color: ColorCodes.lightGreyColor,width: 1),
                      right: BorderSide(  color: ColorCodes.lightGreyColor,width: 1),
                    ),
                      borderRadius: new BorderRadius.only(
                            topRight: const Radius.circular(6.0),
                             bottomRight: const Radius.circular(6.0),
                        bottomLeft:  const Radius.circular(6.0),
                          topLeft:  const Radius.circular(6.0),
                           )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            _addresstag = "Home";
                           },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                  child: _myRadioButton(
                                    title: "Home",
                                    value: 1,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _groupValue = newValue;
                                        _addresstag = "Home";
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes
                                          .blackColor),
                                ),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            _addresstag = "Office";
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                            child: Row(

                              children: [
                                SizedBox(
                                  width: 20.0,
                                  child: _myRadioButton(
                                    title: "Office",
                                    value: 2,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _groupValue = newValue;
                                        _addresstag = "Office";
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "Office",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes
                                          .blackColor),
                                ),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            _addresstag = "Other";
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5.0, left: 20.0, right: 20.0, bottom:5.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                  child: _myRadioButton(
                                    title: "Other",
                                    value: 3,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _groupValue = newValue;
                                        _addresstag = "Other";
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                    "Other",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes
                                          .blackColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                    Text(
                      "Country",
                      // '* What should we call you?',
                      style: TextStyle(fontSize: 15, color: ColorCodes.greyColor),

                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor),
                      decoration: InputDecoration(
                        hintText: "India",
                        hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ColorCodes.blackColor ),
                        hoverColor: ColorCodes.lightGreyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        //FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },
                    ),
                   /* SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: ColorCodes.whiteColor,
                          activeColor: ColorCodes.discountoff,
                          value: this.valuefirst,
                          onChanged: (bool value) {
                            setState(() {
                             valuefirst = value;
                              debugPrint("valuefirst..."+valuefirst.toString());
                            });
                          },
                        ),
                        SizedBox(width: 5),
                        Text("Make this address Default", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorCodes.greyColor),),

                      ],
                    ),*/
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            if(_isWeb)
              _bottomNavigationBar1(),
            SizedBox(height: 30,),
            if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
          ],

        ),
      ),
    );


  }
  _bottomNavigationBar1() {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          _saveaddress();
        },
        child: Container(
          height: 50,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              S.of(context).update_profile,
              // 'UPDATE PROFILE',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
  _bottomNavigationbar() {
    return _isDelivering
        ? SingleChildScrollView(
      child: GestureDetector(
        onTap: (){
          _saveaddress();
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          height: 53,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Text(
              "Save Address",
                style: TextStyle(
                fontSize: 20,
                color: ColorCodes.blackColor,
                //color: ColorCodes.discount,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    )
        : SingleChildScrollView(child: Container());
  }


}


 