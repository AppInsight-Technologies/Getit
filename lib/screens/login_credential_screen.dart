import 'dart:convert';
import '../constants/api.dart';
import '../generated/l10n.dart';

import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';

import '../providers/branditems.dart';
import '../screens/login_screen.dart';
import '../screens/otpconfirm_screen.dart';
import '../utils/prefUtils.dart';

class LoginCredentialScreen extends StatefulWidget {
  static const routeName = '/logincredential-screen';

  @override
  LoginCredentialScreenState createState() => LoginCredentialScreenState();
}

class LoginCredentialScreenState extends State<LoginCredentialScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  List<String> countrycodelist;

  addMobilenumToSF(String value) async {
    PrefUtils.prefs.setString('Mobilenum', value);
  }

  _saveForm() async {
    final signcode = SmsAutoFill().getAppSignature;
    final isValid =_form.currentState.validate();
    if (!isValid) {
      return;
    }//it will check all validators
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (PrefUtils.prefs.getString('prevscreen') == "signingoogle" ||
        PrefUtils.prefs.getString('prevscreen') == "signInApple" ||
        PrefUtils.prefs.getString('prevscreen') == "signinfacebook"){
      checkMobilenum();
    }
    else {
      final signcode = await SmsAutoFill().getAppSignature;
      PrefUtils.prefs.setString('signature', signcode);
      Provider.of<BrandItemsList>(context,listen: false).LoginUser();
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      return Navigator.of(context).pushNamed(
        OtpconfirmScreen.routeName,
          arguments: {
            "prev": routeArgs['prev'].toString(),
          }
      );
    }

//    return LoginUser();


  }

  Future<void> checkMobilenum() async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(
          Api.mobileCheck,
          body: { // await keyword is used to wait to this operation is complete.
            "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          return Fluttertoast.showToast(msg: S.of(context).mobile_exists,//"Mobile number already exists!!!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else if (responseJson['type'].toString() == "new") {
          final signcode = await SmsAutoFill().getAppSignature;
          PrefUtils.prefs.setString('signature', signcode);
          Provider.of<BrandItemsList>(context,listen: false).LoginUser();
          final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
          return Navigator.of(context).pushNamed(
            OtpconfirmScreen.routeName,
              arguments: {
                "prev": routeArgs['prev'].toString(),
              }
          );
        }
      } else {
        return Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }

    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    countrycodelist = [IConstants.countryCode];
    return Scaffold(body: SafeArea(
        child: Material(
            child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: new IconButton(
                              color: Theme.of(context).textSelectionTheme.selectionColor,
                              icon: new Icon(Icons.arrow_back, color: ColorCodes.menuColor,),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName,
                                    arguments: {
                                      "prev": "logincredentialScreen"
                                    }
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20.0, 20.0, 0.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).please_enter_your_mobile,
                            //'Please enter your mobile number',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            color: Colors.black12,
                          ),
                          height: 60.0,
                          width: MediaQuery.of(context).size.width,
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CountryCodePicker(
                                onChanged: null,
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: IConstants.countryCode,
                                //customList: countrycodelist,
                                //favorite: [IConstants.countryCode,'FR'],
                                //countryFilter: ["AE"],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                              Text(
                                "|   ",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Theme.of(context).buttonColor,
                                ),
                              ),
                              Container(
                                  height: 60.0,
                                  width: 170.0,
                                  child: Form(
                                    key: _form,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 16.0),
                                      textAlign: TextAlign.left,
                                      inputFormatters: [LengthLimitingTextInputFormatter(12)],
                                      cursorColor: Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      decoration: new InputDecoration.collapsed(
                                        //hintText: '9876543210',
                                          hintStyle: TextStyle(color: Colors.black12, )
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return S.of(context).please_enter_phone_number;//'Please enter a Mobile number.';
                                        }
                                        return null; //it means user entered a valid input
                                      },
                                      onSaved: (value) {
                                        addMobilenumToSF(value);
                                      },
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
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
                          child:  GestureDetector(
                              onTap: () {
                                _saveForm();
                                _isLoading = true;
                                if(_isLoading) {
                                  Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                              }, child: Container(
//                          padding: EdgeInsets.all(20),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(color: Theme.of(context).primaryColor,)
                              ),
                              height: 60.0,
                              child: Center(
                                child: Text(
                                  S.of(context).next,//"Next",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context).buttonColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            )
        ),
      ),);
  }
}
