import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../../screens/home_screen.dart';
import '../../screens/profile_screen.dart';
import '../generated/l10n.dart';
import '../utils/prefUtils.dart';
import '../screens/refer_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../assets/ColorCodes.dart';
import '../screens/about_screen.dart';
import '../screens/privacy_screen.dart';
import '../constants/IConstants.dart';
import 'dart:io';

class PolicyScreen extends StatefulWidget {
  static const routeName = '/policy-screen';
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool _iscontactus = false;
  bool _isWeb =false;
  MediaQueryData queryData;
  double wid;
  double maxwid;
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
    // Future.delayed(Duration.zero, () async{
    //   prefs = await SharedPreferences.getInstance();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, String>;

    final title = routeArgs['title'];
    final body = routeArgs['body'];
    String businessname;
    String address;
    String contactnum;
    String pemail;
    String semail;

    if(title == "Contact Us") {
      _iscontactus = true;
      businessname = routeArgs['businessname'];
      address = routeArgs['address'];
      contactnum = routeArgs['contactnum'];
      pemail = routeArgs['pemail'];
      semail = routeArgs['semail'];
    }
    else if(title == "Profile") {
      _iscontactus = true;
      businessname = routeArgs['businessname'];
      address = routeArgs['address'];
      contactnum = routeArgs['contactnum'];
      pemail = routeArgs['pemail'];
      semail = routeArgs['semail'];
    } else {
      _iscontactus = false;
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
              if(title == "Contact Us" || title == "About Us") {
                Navigator.of(context).popUntil(
                    ModalRoute.withName(AboutScreen.routeName,));
              }else if(title == "Refer" ){
                Navigator.of(context).popUntil(
                    ModalRoute.withName(ReferEarn.routeName,));
              }else if(title == "Privacy"){
                Navigator.of(context).popUntil(
                    ModalRoute.withName(PrivacyScreen.routeName,));
              }
              else if(title == "Profile"){
                Navigator.of(context).pushNamed(HomeScreen.routeName,);
              }
              else{
               // Navigator.of(context).pop();
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              }
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(title,
        style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),),
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
    _body() {
       /*_isloading ?
      Center(
        child: CircularProgressIndicator(),
      ) :*/
      queryData = MediaQuery.of(context);
      wid= queryData.size.width;
      maxwid=wid*0.90;
     return Expanded(
        child: SingleChildScrollView(
          child: Container(
            constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,

            child: Column(
              children: <Widget>[
                _iscontactus ?
                Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                            S.of(context).business_name,
                          // "Business Name",
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(businessname, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                          S.of(context).address,
                          // "Address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Expanded(child: Text(
                          address, style: TextStyle(fontSize: 14.0),)),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                            S.of(context).contactnumber,
                          // "Contact Number",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(contactnum, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                          S.of(context).email,
                          // "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(pemail, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(semail, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                  ],
                )
                    :
                Row(
                  children: <Widget>[
                    SizedBox(width: 5.0,),
//                  Expanded(child: Text(privacy)),
                    Expanded(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1.0),
                          child: Html(data: body,
                            style: {
                              "span": Style(
                                fontSize: FontSize(12.0),
                                fontWeight: FontWeight.normal,
                              )
                            },
                          ),
                        )
                    ),
                    // SizedBox(width: 5.0,),
                  ],
                ),
                  if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Column(
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false, false),
          _body(),
        ],
      ),
    );
  }
}
