import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controller/mutations/login.dart';
import '../../models/newmodle/user.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';
import "package:http/http.dart" as http;
import 'package:sms_autofill/sms_autofill.dart';
import 'package:velocity_x/velocity_x.dart';

class Auth {
  var _authresponse;

  Future<AuthData> facebookLogin(returns) async {
    // final _facebookLogin = FacebookLogin();
    //
    // _facebookLogin.loginBehavior =
    // Platform.isIOS ? FacebookLoginBehavior.webViewOnly : FacebookLoginBehavior
    //     .nativeOnly; //FacebookLoginBehavior.webViewOnly; _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // final result = await _facebookLogin.logIn(['email']);
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final response = await http.get(
    //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${result
    //             .accessToken}');
    //
    //     Map<String, dynamic> map = json.decode(response.body);
    //
    //     _isnewUser(map["email"]).then((value) {
    //       _authresponse = returns(AuthData(code: response.statusCode,
    //           messege: "Login Success",
    //           status: true,
    //           data: SocialAuthUser.fromJson(SocialAuthUser.fromJson(map).toJson(newuser: value.type=="old"?false:true,id: value.apikey))));
    //     });
    //     // TODO: Handle this case.
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     _authresponse = returns(AuthData(
    //         code: 200, messege: "Login Canceled by User", status: false));
    //     // TODO: Handle this case.
    //     break;
    //   case FacebookLoginStatus.error:
    //     _authresponse = returns(
    //         AuthData(code: 200, messege: result.errorMessage, status: false));
    //     // TODO: Handle this case.
    //     break;
    // }
    // return Future.value(_authresponse);
    return Future.value(_authresponse);
  }

  Future<AuthData> googleLogin(returns) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email', /*'https://www.googleapis.com/auth/contacts.readonly',*/
      ],
    );
    final response = await _googleSignIn.signIn();
    response.authentication.then((value) {
      _isnewUser(response.email).then((value) =>
          returns(AuthData(code: 200,
              messege: "Login Success",
              status: true,
              data: SocialAuthUser(email: response.email,
                  firstName: response.displayName,
                  id: value.apikey,
                  lastName: "",
                  name: response.displayName,
                  picture: Picture(data: Data(url: response.photoUrl)),
                  newuser: value.type=="old"?false:true))));
    }).onError((error, stackTrace) {
      _authresponse =
          AuthData(code: 200, messege: error.toString(), status: false);
      returns(_authresponse);
    });
    return Future.value(_authresponse);
  }

  Future<AuthData> phoneNumberAuth(mobile, Function(LoginData, AuthData) otp) async {
    final response = json.decode(
        await api.Geturl("customer/pre-register?mobileNumber=$mobile&signature=${Vx.isWeb? "":await SmsAutoFill().getAppSignature??""}&tokenId=${PrefUtils.prefs.getString('ftokenid')}"));
    debugPrint("sp........"+PrefUtils.prefs.getString('ftokenid').toString());
    debugPrint("response..." + response["type"].toString() + " " +
        response["data"].toString());
    if (response["type"] == "new") {
      _authresponse = AuthData(code: 200,
          messege: "Login Success",
          status: true,
          data: SocialAuthUser(newuser: true));
      otp(LoginData.fromJson(response["data"]), _authresponse);
    } else {
      PrefUtils.prefs.setString("apikey", response["userID"].toString());
      getuserProfile(onsucsess: (value) {
        _authresponse = AuthData(code: 200,
            messege: "Login Success",
            status: true,
            data: SocialAuthUser(newuser: false, id: value.id));
        otp(LoginData.fromJson(response["data"]), _authresponse);
      });
    }
  }
 /* Future<void> appleLogIn() async {
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
                  // PrefUtils.prefs.setString('apikey', data['userID'].toString());
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
                if (PrefUtils.prefs.getString('FirstName') != null) {
                  if (PrefUtils.prefs.getString('LastName') != null) {
                    name = PrefUtils.prefs.getString('FirstName') +
                        " " +
                        PrefUtils.prefs.getString('LastName');
                  } else {
                    name = PrefUtils.prefs.getString('FirstName');
                  }
                } else {
                  name = "";
                }

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
                *//*Navigator.of(context).pushReplacementNamed(
                  LoginScreen.routeName,);*//*
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
              fontSize: atextScaleFactor *13,
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
  }*/
  userRegister(RegisterAuthBodyParm body, { Function onSucsess, onError}) async {
    api.body = body.toJson();
    final regresp = json.decode(await api.Posturl("customer/register"));
    PrefUtils.prefs.setString("apikey", regresp["userId"].toString());
    debugPrint("status.." + regresp["status"].toString());
    if (regresp["status"]) {
      getuserProfile(onsucsess: (UserData data) => onSucsess(data),
          onerror: (messege) => onError(messege));
    } else {
      onError(regresp["message"]);
    }
  }

  getuserProfile({Function(UserData) onsucsess, onerror}) async {
    if(PrefUtils.prefs.containsKey("apikey")) {
      print("log...."+PrefUtils.prefs.getString("apikey").toString());
      final resp = UserModle.fromJson(json.decode(await api.Geturl("customer/get-profile?apiKey=${PrefUtils.prefs.getString("apikey")}")));
      if (resp.status) {
        print('status...' + {resp.data[0]}.toString());
        SetUserData(resp);
        onsucsess(UserData.fromJson(resp.data[0].toJson()));
        // return Future.value(UserData.fromJson(resp["data"][0]));
      } else {
        api.body={
          "token":PrefUtils.prefs.getString("ftokenid"),
          "device":"android"
        };
        PrefUtils.prefs.setString(
            "tokenid", json.decode(await api.Posturl("customer/register/guest/user",isv2: false))["guestUserId"]);
        onerror();
        return null;
      }
    }
    else{
      debugPrint("ftokenid..."+PrefUtils.prefs.getString("ftokenid"));
      api.body={
        "token":PrefUtils.prefs.getString("ftokenid"),
        "device":"android"
      };
      PrefUtils.prefs.setString("tokenid", json.decode(await api.Posturl("customer/register/guest/user",isv2: false))["guestUserId"]);
   //  debugPrint("tokenid1111..." + PrefUtils.prefs.getString("tokenid"));
      onerror();
      return null;
    }
    // else {
    //   PrefUtils.prefs.setString("tokenid", json.decode(await api.Geturl("url"))["guestUserId"]);
    //  }
  }

  Future<String> getuserNotificationCount(apikey) async {
    print("userid $apikey");
    return Future.value(json.decode(await api.Geturl(
        "customer/get-profile?apiKey=$apikey"))["notification_count"]);
  }

  Future<EmailResponse> _isnewUser(email) async {
    return EmailResponse.fromJson(json.decode(
        await api.Posturl("customer/email-check?email=$email")));
  }
}
class EmailResponse {
  bool status;
  String type;
  String apikey;

  EmailResponse({this.status, this.type, this.apikey});

  EmailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    apikey = json['apikey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['type'] = this.type;
    data['apikey'] = this.apikey;
    return data;
  }
}

final auth = Auth();
class AuthData {
  bool status;
  String messege;
  int code;
  SocialAuthUser data;

  AuthData({this.status, this.messege, this.code, this.data});

  AuthData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messege = json['messege'];
    code = json['code'];
    data = json['data'] != null ? new SocialAuthUser.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messege'] = this.messege;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
class RegisterAuthBodyParm {
  String username;
  String email;
  String path;
  String tokenId;
  String guestUserId;
  String branch;
  String referralid;
  String device;
  String mobileNumber;

  RegisterAuthBodyParm(
      {this.username,
        this.email,
        this.path,
        this.guestUserId,
        this.tokenId,
        this.branch,
        this.referralid,
        this.mobileNumber,
        this.device});

  RegisterAuthBodyParm.fromJson(Map<String, String> json) {
    username = json['username'];
    email = json['email'];
    path = json['path'];
    tokenId = json['tokenId'];
    guestUserId = json['guestUserId'];
    branch = json['branch'];
    referralid = json['referralid'];
    device = json['device'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['path'] = this.path;
    data['guestUserId'] = this.guestUserId;
    data['tokenId'] = this.tokenId;
    data['branch'] = this.branch;
    data['referralid'] = this.referralid;
    data['device'] = this.device;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}
class LoginData {
  int otp;
  int apiKey;

  LoginData({this.otp,this.apiKey});

  LoginData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    apiKey = json['apiKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['apiKey'] = this.apiKey;
    return data;
  }
}