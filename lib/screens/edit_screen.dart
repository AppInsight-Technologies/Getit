import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../screens/otpconfirm_screen.dart';
import '../../screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../screens/editOtp_screen.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/prefUtils.dart';
import '../screens/home_screen.dart';
import '../constants/IConstants.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  final _lnameFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String fn = "";
  String ln = "";
  String ea = "";
  String mb = "";
  int _groupvalue = 0;
  DateTime _selectedDate;
  var name = "", email = "", phone = "", dob ="",gender ="";
  bool _isWeb = false;
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController mobileNumberController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController dobController = new TextEditingController();
  bool iphonex = false;
  GroceStore store = VxState.store;
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
    }
    auth.getuserProfile(onsucsess: (value){},onerror: (){});
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
      setState(() {
        name = store.userData.username;
        phone = store.userData.mobileNumber;
        email = store.userData.email;
        dob = store.userData.dob;
        gender = store.userData.sex;

      //  debugPrint("phone..."+store.userData.mobileNumber+"  "+store.userData.email + " " + store.userData.dob);

       /* if (PrefUtils.prefs.getString('dob') != null) {
          dob = PrefUtils.prefs.getString('dob');
        } else {
          dob = "";
        }
        if (PrefUtils.prefs.getString('sex') != null) {
          sex = PrefUtils.prefs.getString('sex');
        } else {
          sex = "0";
          PrefUtils.prefs.setString("sex", "0");
        }*/
        firstnamecontroller.text = name;
        mobileNumberController.text = phone;
        emailController.text = email;
        DateTime dt = DateTime.parse(dob);
        dobController.text =  DateFormat("dd-MM-yyyy").format(dt);
        _groupvalue = int.parse(gender);
        //dobController.text = dob;
      });
    });
   // setState(() {
     // PrefUtils.prefs.getString('dob');
      // gender = PrefUtils.prefs.getString("gender");
   //   _groupvalue = int.parse(PrefUtils.prefs.getString("sex"));
   //   debugPrint("group..."+_groupvalue.toString());
   // });
    super.initState();
  }
  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primaryColorDark: Colors.black,
              accentColor: Colors.black,
              textSelectionColor: Colors.black,
              colorScheme: ColorScheme.dark(
               // primary: ColorCodes.primaryColor,
                onPrimary: Colors.black,
                surface: ColorCodes.primaryColor,
                onSurface: Colors.black,
                onSecondary: Colors.black,
                secondary: Colors.black,
                secondaryVariant: Colors.black,

              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dobController
        ..text = DateFormat("dd-MM-yyyy").format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dobController.text.length,
            affinity: TextAffinity.upstream));
    }
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

  Future<void> UpdateProfile() async {
    String gender;
    if(_groupvalue == 0){
      gender = "0";
    }else if(_groupvalue == 1){
      gender = "1";
    }else if(_groupvalue == 2){
      gender = "2";
    }
    try {
      debugPrint("body...profile.."+{
        "id": PrefUtils.prefs.getString('apikey'),
        "name": firstnamecontroller.text,
        "mobile": mobileNumberController.text,
        "email": emailController.text,
        "dob":dobController.text,
        'sex': gender,
      }.toString());
      final response = await http.post(Api.updateCustomerProfile, body: {
        "id": PrefUtils.prefs.getString('apikey'),
        "name": firstnamecontroller.text,
        "mobile": mobileNumberController.text,
        "email": emailController.text,
        "dob":dobController.text,
        'sex': gender,
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("responseJson profile...."+responseJson.toString());
      if (responseJson["status"] == 200) {
     /*   PrefUtils.prefs.setString('FirstName', firstnamecontroller.text);
        PrefUtils.prefs.setString('LastName', "");
        PrefUtils.prefs.setString('mobileNumber', mobileNumberController.text);
        PrefUtils.prefs.setString('Email', emailController.text);
        PrefUtils.prefs.setString('dob', dobController.text);
        PrefUtils.prefs.setString('sex', gender);*/
        Navigator.of(context).pop();
       // Navigator.of(context).pop();
        auth.getuserProfile(onsucsess: (value){},onerror: (){});
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,);
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
          msg:S.of(context).something_went_wrong,
          // "Something went wrong",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
      throw error;
    }
  }

  @override
  void dispose() {
    firstnamecontroller.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    super.dispose();
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

  _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState.save();

    if(mobileNumberController.text == store.userData.mobileNumber) {
      _dialogforProcessing();
      UpdateProfile();
    } else {
      _dialogforProcessing();
      _getOtp(mobileNumberController.text);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child:_bottomNavigationBar(),
      ),
    );
  }
  _bottomNavigationBar() {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          _saveForm();
        },
        child: Container(
          margin: EdgeInsets.only(top: 15,bottom: 15,left: 25,right: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorCodes.discountoff,
          ),
          height: 55,
          width: double.infinity,
          child: Center(
            child: Text(
              "SAVE CHANGES",
              // 'UPDATE PROFILE',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorCodes.whiteColor),
            ),
          ),
        ),
      ),
    );
  }
  _body(){
    return Expanded(
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
                color: ColorCodes.backgroundcolor,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                color: ColorCodes.whiteColor,
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text(
                        "First Name",
                       // '* What should we call you?',
                        style: TextStyle(fontSize: 16, color: ColorCodes.mediumBlackWebColor),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                        controller: firstnamecontroller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                          hoverColor: ColorCodes.greenColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_lnameFocusNode);
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
                      SizedBox(height: 3.0),
                      Text(
                        "Mobile No.",
                        // 'Mobile number',
                        style: TextStyle(fontSize: 16, color: ColorCodes.mediumBlackWebColor),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        controller: mobileNumberController,
                        style: new TextStyle(
                            color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 18,),
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        decoration: InputDecoration(
                           contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                          hintText: "+91",
                          hintStyle: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w700, fontSize: 16,),
                          // 'Your number',
                          fillColor: ColorCodes.greenColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
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
                      SizedBox(height: 7.0),
                      Text(
                        mb,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        "Email",
                        // 'Tell us your e-mail',
                        style: TextStyle(fontSize: 16, color: ColorCodes.mediumBlackWebColor),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        style: new TextStyle(
                          color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 18,),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                          hintText: 'xyz@gmail.com',
                          hintStyle: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w700, fontSize: 16,),
                          fillColor: ColorCodes.greenColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: ColorCodes.borderColor, width: 0.5),
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
                              ea = ' Please enter a valid email address';
                            });
                            return '';
                          }
                          setState(() {
                            ea = "";
                          });
                          return null; //it means user entered a valid input
                        },
                        onSaved: (value) {
                          // addEmailToSF(value);
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
                      SizedBox(height: 3.0),
                      Text(
                        "Birthdate",
                        // 'Tell us your e-mail',
                        style: TextStyle(fontSize: 16, color: ColorCodes.mediumBlackWebColor),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        textAlign: TextAlign.left,
                        focusNode: AlwaysDisabledFocusNode(),
                        // keyboardType: TextInputType.datetime,
                        controller: dobController,
                        style: new TextStyle(
                          color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 18,),
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                          hintText: 'DD-MM-YYYY',
                          hintStyle: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w700, fontSize: 16,),
                          fillColor: ColorCodes.accentColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color:  ColorCodes.lightGreyColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color:  ColorCodes.lightGreyColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color:  ColorCodes.lightGreyColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color:  ColorCodes.lightGreyColor),
                          ),
                        ),
                        onSaved: (value) {
                          //addEmailToSF(value);
                        },
                        onTap: (){
                          _selectDate(context);
                        },
                      ),
                      SizedBox(height: 15.0),
                      Text('Gender',
                        style: TextStyle(fontSize: 16, color: ColorCodes.mediumBlackWebColor),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorCodes.lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Radio(
                                value: 0,
                                activeColor: ColorCodes.blackColor,

                                groupValue: _groupvalue,
                                onChanged: (value) =>
                                    setState(() {
                                      _groupvalue = value;
                                      debugPrint("111"+_groupvalue.toString());
                                    }),
                              ),
                              Text('Male', style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17),),
                            ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 1,
                                  activeColor: ColorCodes.blackColor,
                                  groupValue: _groupvalue,
                                  onChanged: (value) =>
                                      setState(() {
                                        _groupvalue = value;
                                        debugPrint("222"+_groupvalue.toString());
                                      }),
                                ),
                                Text('Female', style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 2,
                                  activeColor: ColorCodes.blackColor,
                                  groupValue: _groupvalue,
                                  onChanged: (value) =>
                                      setState(() {
                                        _groupvalue = value;
                                        debugPrint("33"+_groupvalue.toString());
                                      }),
                                ),
                                Text('Other', style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17),),
                              ],
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              if(_isWeb)
                _bottomNavigationBar(),
              SizedBox(height: 30,),
              if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
            ],

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
    leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: (){
      Navigator.of(context).pop();
    },
    ),
    title: Text(
    "Edit Profile",

    // 'Edit your info',
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
    begin: Alignment
    .topRight,
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
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
