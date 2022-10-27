import 'dart:convert';
import 'dart:async'; // for Timer class

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/ColorCodes.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';

import '../screens/home_screen.dart';
import '../constants/IConstants.dart';
import '../utils/prefUtils.dart';

class EditOtpScreen extends StatefulWidget {
  static const routeName = '/editotp-confirm';

  @override
  EditOtpScreenState createState() => EditOtpScreenState();
}

class EditOtpScreenState extends State<EditOtpScreen> {
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  int _timeRemaining = 30;
  var _showCall = false;
  Timer _timer;
  String otp1, otp2, otp3, otp4;
  TextEditingController controller = TextEditingController();
  var otpvalue = "";

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    _listenotp();
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

  Future<void> UpdateProfile() async {

    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    try {
      final response = await http.post(Api.updateCustomerProfile, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs.getString('apikey'),
        "name": routeArgs['firstName'],
        "mobile": routeArgs['mobileNum'],
        "email": routeArgs['email'],
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson["status"] == 200) {
        PrefUtils.prefs.setString('FirstName', routeArgs['firstName']);
        PrefUtils.prefs.setString('LastName', "");
        PrefUtils.prefs.setString('mobile', routeArgs['mobileNum']);
        PrefUtils.prefs.setString('Email', routeArgs['email']);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S.of(context).something_went_wrong,
            // "Something went wrong",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: S.of(context).something_went_wrong,
          // "Something went wrong",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
      throw error;
    }
  }

  _verifyOtp() async {

    if (otpvalue == PrefUtils.prefs.getString('Otp')) {
      _dialogforProcessing();
      UpdateProfile();
    } else {
      return Fluttertoast.showToast(msg:S.of(context).please_enter_valid_otp,
      // "Please enter a valid otp!!!",
        fontSize: MediaQuery.of(context).textScaleFactor *13,);
    }
  }

  Future<void> Otpin30sec() async {
    try {
      final response = await http.post(Api.resendOtp30, body: {
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
      final responseJson = json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> OtpCall() async {
    try {

      final response = await http.post(Api.resendOtpCall, body: {
        "resOtp": PrefUtils.prefs.getString('Otp'),
        "mobileNumber": PrefUtils.prefs.getString('Mobilenum'),
      });
      final responseJson = json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

    return Scaffold(
      body: SafeArea(
        child: Material(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: GestureDetector(
                              onTap: () {
                               Navigator.of(context).pop();
                              },
                              child: new IconButton(
                                color: Theme.of(context).textSelectionColor,
                                icon: new Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).textSelectionColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10.0, 20.0, 0.0),
                        child: RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent

                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              height: 2.0,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                text: S.of(context).enter_verification_code,
                                // 'Enter Verification Code',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20.0),
                          Text(S.of(context).send_verification_codeto,
                              // "We have sent a verification code to ",
                              style: new TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20.0),
                          Text(
                            IConstants.countryCode + '  ' + routeArgs['mobileNum'],
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Row(children: [
                        SizedBox(
                          width: 21,
                        ),
                        // Auto Sms
                        Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 80 / 100,
                            padding: EdgeInsets.zero,
                            child:

                            // Pinfield controller
                            PinFieldAutoFill(
                              controller: controller,
                              onCodeChanged: (text) {
                                otpvalue = text;
                                SchedulerBinding.instance.addPostFrameCallback(
                                        (_) => setState(() {}));
                              },
                              onCodeSubmitted: (text) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) => setState(() {
                                  otpvalue = text;
                                }));
                              },
                              codeLength: 4,
                              currentCode: otpvalue,
                            ))
                      ]),
/*                      PinCodeTextField(
//                    autofocus: false,
                      pinBoxRadius: 5,
                      controller: controller,
                      highlight: true,
                      highlightColor: Theme.of(context).primaryColor,
                      defaultBorderColor: Colors.grey,
                      hasTextBorderColor: Colors.grey,
                      maxLength: 4,
                      pinBoxWidth: 70.0,
                      pinBoxHeight: 45.0,



                      onTextChanged: (text) {
                        setState(() {
                          //hasError = false;
                        });
                      },
                      onDone: (text){
                        setState(() {
                          otpvalue = text;
                        });
                      },
                      wrapAlignment: WrapAlignment.center,
                      ),*/
                      SizedBox(
                        height: 25,
                      ),
                      Row(children: [
                        SizedBox(
                          width: 21,
                        ),
                        _showCall == true
                            ? _timeRemaining == 0
                            ? Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width *
                              16 /
                              100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          padding: EdgeInsets.fromLTRB(12, 6, 2, 2),
                          child: GestureDetector(
                              onTap: () {
                                OtpCall();
                                _timeRemaining = 60;
                              },
                              child: Text(
                                S.of(context).call,

                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )),
                        )
                            : Container(
                          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                          child: new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: S.of(context).call_in,
                                  // 'Call in',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: ColorCodes.greenColor),
                                ),
                                new TextSpan(
                                  text: '   00:$_timeRemaining',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: ColorCodes.lightGreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : _timeRemaining == 0
                            ? Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width *
                              26 /
                              100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          padding: EdgeInsets.fromLTRB(2, 5, 2, 2),
                          child: GestureDetector(
                              onTap: () {
                                _showCall = true;
                                _timeRemaining += 30;
                                Otpin30sec();
                              },
                              child: Text(
                                S.of(context).resend_otp,
                                // 'Resend Otp',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.red),
                              )),
                        )
                            : Container(
                          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                          child: new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: S.of(context).resend_otp_in,
                                  // 'Resend Otp in',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: ColorCodes.greenColor),
                                ),
                                new TextSpan(
                                  text: '   00:$_timeRemaining',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: ColorCodes.lightGreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
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
                                _verifyOtp();
                              },
                              child: Container(
//                          padding: EdgeInsets.all(20),
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
                                      S.of(context).verify,
                                      // "Verify",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }
}
