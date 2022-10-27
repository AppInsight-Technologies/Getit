import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class OtpPopup extends StatefulWidget {
  @override
  _OtpPopupState createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  var countrycode = "";
  String mobile = "";
  TextEditingController controller = TextEditingController();
  var otpvalue = "";
  bool _showOtp = false;
  bool _isWeb = false;
  var _isLoading = false;
  int _timeRemaining = 30;
  String fn = "";
  String ln = "";
  String ea = "";
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool iphonex = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery
                .of(context)
                .size
                .height >= 812.0;
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
    });

  }



  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return _dialogforotp();
    throw UnimplementedError();
  }
  _dialogforotp(){
  return  showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(

                height:(_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.height:MediaQuery.of(context).size.width / 3,
                width:(_isWeb && ResponsiveLayout.isSmallScreen(context)) ?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width / 2.5,
                color: Colors.white,
                child: _otp(),

              ),
            );
          });
        });
  }
  _dialogforAddInfo() {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                height: (_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.height:MediaQuery.of(context).size.width / 3.3,
                width: (_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width / 2.7,
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
                           // key: _form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  S.of(context).what_should_we_call_you,//'* What should we call you?',
                                  style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                 // controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).name,//'Name',
                                    hoverColor: Colors.green,
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
                                      borderSide: BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                   // FocusScope.of(context).requestFocus(_lnameFocusNode);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                       fn = S.of(context).please_enter_name;//"  Please Enter Name";
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      fn = "";
                                    });
                                    return null;
                                  },
                                  onSaved: (value) {
                                  //  addFirstnameToSF(value);
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
                                  style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      decorationColor: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintText: 'xyz@gmail.com',
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
                                        ea = S.of(context).please_enter_valid_email_address;//' Please enter a valid email address';
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      ea = "";
                                    });
                                    return null; //it means user entered a valid input
                                  },
                                  onSaved: (value) {
                                    //addEmailToSF(value);
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
                                  style: TextStyle(fontSize: 15.2, color: ColorCodes.emailColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  Spacer(),



/*            GestureDetector(
              onTap: () {
                _saveForm();
              },
              child: Container(
                height: 50,
                width: double.infinity,
                color: Color(0xFF2966A2),
                child: Center(
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )*/
                      ],
                    ),
                  ),
                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                       //   _saveAddInfoForm();
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


  Widget _otp(){
    return Column(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        color: ColorCodes.lightGreyWebColor,
        padding: EdgeInsets.only(left: 20.0),
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
        child:

        Column(
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
                    countrycode + '  $mobile',
                    style: new TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.0),
                  ),
                  SizedBox(width: 30.0),
                  GestureDetector(
                    onTap: () {
//Navigator.pop(context);

                     _dialogforAddInfo();
                    //
                      //_dialogforSignIn();
                      /*Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginCredentialScreen.routeName,
                        ModalRoute.withName('/'));*/
                      // Navigator.of(context).pop();

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
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  S.of(context).enter_otp,//'Enter OTP',
                  style: TextStyle(color: ColorCodes.greyColor, fontSize: 14),
                  //textAlign: TextAlign.left,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                // Auto Sms
                Container(
                    height: 40,
                    //width: MediaQuery.of(context).size.width*80/100,
                    width: MediaQuery.of(context).size.width / 3.5,
                    //padding: EdgeInsets.zero,
                    child: PinFieldAutoFill(
                        controller: controller,
                        decoration: UnderlineDecoration(
                            colorBuilder:
                            FixedColorBuilder(ColorCodes.greyColor)),
                        onCodeChanged: (text){
                          otpvalue = text;
                          SchedulerBinding.instance
                              .addPostFrameCallback((_) => setState(() {}));
                        },
                        onCodeSubmitted: (text) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((_) => setState(() {
                            otpvalue = text;
                          }));
                        },
                        codeLength: 4,
                        currentCode: otpvalue
                    )),
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
                        width: (_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*50/100:MediaQuery.of(context).size.width*32/100,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(6),
                          border: Border.all(
                              color: ColorCodes.greyColor,
                              width: 1.5),
                        ),
                        child:
                        Center(child: Text(
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
                        ?
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior:
                        HitTestBehavior.translucent,
                        onTap: () {
                         // otpCall();
                          _timeRemaining = 60;
                        },
                        child: Expanded(
                          child: Container(
                            height: 40,
                            //width: MediaQuery.of(context).size.width*32/100,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  6),
                              border: Border.all(
                                  color: Colors.green,
                                  width: 1.5),
                            ),
                            child: Center(
                                child: Text(
                                  S.of(context).call_me_instead,//'Call me Instead'
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
                          BorderRadius.circular(6),
                          border: Border.all(
                              color: ColorCodes.greyColor,
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
                        // _showCall = true;

                        _showOtp = true;
                        _timeRemaining += 30;
                        //Otpin30sec();
                      },
                      child: Expanded(
                        child: Container(
                          height: 40,
                          width: (_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*30/100:MediaQuery.of(context).size.width*15/100,
                          //width: MediaQuery.of(context).size.width*32/100,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                6),
                            border: Border.all(
                                color: Colors.green,
                                width: 1.5),
                          ),
                          child: Center(
                              child:
                              Text(
                                S.of(context).resend_otp,//'Resend OTP'
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
                                  text: S.of(context).resend_otp_in,//'Resend Otp in',
                                  style: TextStyle(
                                      color: Colors
                                          .black)),
                              new TextSpan(
                                text:
                                ' 00:$_timeRemaining',
                                style: TextStyle(
                                  color:
                                  ColorCodes.lightGreyColor,
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
                      borderRadius: BorderRadius.circular(20),
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
                            S.of(context).call_me_instead,
                              //'Call me Instead'
                          )),
                    ),
                  ),
                ],
              ),
            ]),

      ),

      /* Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 40.0),
                          Center(
                              child: Text(
                            'Please check OTP sent to your mobile number',
                            style: TextStyle(
                                color: Color(0xFF404040),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              SizedBox(width: 20.0),
                              Text(
                                countrycode + '  $mobile',
                                style: new TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 18.0),
                              ),
                              SizedBox(width: 40.0),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.of(context).pop();
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
                                        child: Text('Change',
                                            style: TextStyle(
                                                color: Color(0xFF070707)))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text('Enter OTP',
                                style: TextStyle(
                                    color: ColorCodes.greyColor, fontSize: 18)),
                          ),
                          Row(children: [
                            SizedBox(
                              width: 30,
                            ),
                            // Auto Sms
                            Container(
                                height: 40,
                                //width: MediaQuery.of(context).size.width*80/100,
                                width: MediaQuery.of(context).size.width / 3.5,
                                //padding: EdgeInsets.zero,
                                child: PinFieldAutoFill(
                                  controller: controller,
                                  decoration: UnderlineDecoration(
                                      colorBuilder:
                                          FixedColorBuilder(Color(0xFF707070))),
                                  onCodeChanged: (text){
                                    otpvalue = text;
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) => setState(() {}));
                                  },
                                  onCodeSubmitted: (text) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) => setState(() {
                                      otpvalue = text;
                                    }));
                                  },
                                  codeLength: 4,
                                    currentCode: otpvalue
                                ))
                          ]),
                          SizedBox(
                            height: 25,
                          ),

                       //   new Resend OTP buttons

                          _showOtp
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          width: (_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*50/100:MediaQuery.of(context).size.width*32/100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: ColorCodes.greyColor,
                                                width: 1.5),
                                          ),
                                          child:
                                              Center(child: Text('Resend OTP')),
                                        ),
                                      ),
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
                                          'OR',
                                          style: TextStyle(fontSize: 10),
                                        )),
                                      ),
                                      _timeRemaining == 0
                                          ? MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
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
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 1.5),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                            'Call me Instead')),
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
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: ColorCodes.greyColor,
                                                      width: 1.5),
                                                ),
                                                child: Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                            text: 'Call in',
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
                                                // _showCall = true;
                                                _showOtp = true;
                                                _timeRemaining += 30;
                                                Otpin30sec();
                                              },
                                              child: Expanded(
                                                child: Container(
                                                  height: 40,
                                                   width: (_isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*30/100:MediaQuery.of(context).size.width*15/100,
                                                  //width: MediaQuery.of(context).size.width*32/100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color: Colors.green,
                                                        width: 1.5),
                                                  ),
                                                  child: Center(
                                                      child:
                                                          Text('Resend OTP')),
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
                                                          text: 'Resend Otp in',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      new TextSpan(
                                                        text:
                                                            ' 00:$_timeRemaining',
                                                        style: TextStyle(
                                                          color:
                                                             ColorCodes.lightGreyColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    Container(
                                      height: 28,
                                      width: 28,
                                      margin: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: ColorCodes.greyColor,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(
                                        'OR',
                                        style: TextStyle(fontSize: 10),
                                      )),
                                    ),
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
                                            child: Text('Call me Instead')),
                                      ),
                                    ),
                                  ],
                                ),
                         // This expands the row element vertically because it's inside a column


                        ]),*/

      Spacer(),
      Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
              //  _verifyOtp();
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
      ),
    ]);
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
}