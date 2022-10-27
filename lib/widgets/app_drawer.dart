import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/in_app_update_review.dart';
import '../models/VxModels/VxStore.dart';
import '../screens/MySubscriptionScreen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/refer_screen.dart';
import 'package:launch_review/launch_review.dart';
import "package:http/http.dart" as http;

import '../screens/edit_screen.dart';
import '../constants/IConstants.dart';
import '../screens/myorder_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../screens/about_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/addressbook_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/help_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../screens/wallet_screen.dart';
import '../constants/features.dart';
import 'CoustomeDailogs/slectlanguageDailogBox.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var name = "", email = "", photourl = "", phone = "";
//  bool  !PrefUtils.prefs.containsKey("apikey") = false;
  bool _isIOS = false;
  bool _isWeb =true;
  GroceStore store = VxState.store;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isIOS = true;
        });
      } else {
        setState(() {
          _isIOS = false;
        });
      }
    } catch (e) {
      setState(() {
        _isIOS = false;
      });
    }

    Future.delayed(Duration.zero, () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // setState(() {
      //   if (PrefUtils.prefs.getString('FirstName') != null) {
      //     if (PrefUtils.prefs.getString('LastName') != null) {
      //       name = PrefUtils.prefs.getString('FirstName') +
      //           " " +
      //           PrefUtils.prefs.getString('LastName');
      //     } else {
      //       name = PrefUtils.prefs.getString('FirstName');
      //     }
      //   } else {
      //     name = "";
      //   }
      //
      //   if (PrefUtils.prefs.getString('Email') != null) {
      //     email = PrefUtils.prefs.getString('Email');
      //   } else {
      //     email = "";
      //   }
      //
      //   if (PrefUtils.prefs.getString('mobile') != null) {
      //     phone = PrefUtils.prefs.getString('mobile');
      //   } else {
      //     phone = "";
      //   }
      //
      //   if (PrefUtils.prefs.getString('photoUrl') != null) {
      //     photourl = PrefUtils.prefs.getString('photoUrl');
      //   } else {
      //     photourl = "";
      //   }
      //   // if (!PrefUtils.prefs.containsKey("apikey")) {
      //   //    !PrefUtils.prefs.containsKey("apikey") = true;
      //   // } else {
      //   //    !PrefUtils.prefs.containsKey("apikey") = false;
      //   // }
      // });
      name = store.userData.username;
      email = store.userData.email;
      photourl = store.userData.path;
      phone =store.userData.mobileNumber;
    });
    //initPlatformState();
    super.initState();
  }

  /*Future<void> initPlatformState() async {
    SharedPreferences PrefUtils.prefs = await SharedPreferences.getInstance();
    String firstname = PrefUtils.prefs.getString("FirstName");
    String lastname = PrefUtils.prefs.getString("LastName");
    String email = PrefUtils.prefs.getString("Email");
    String countrycode = PrefUtils.prefs.getString("country_code");
    String phone = PrefUtils.prefs.getString("mobile");

    var response = await FlutterFreshchat.init(
      appID: "80f986ff-2694-4894-b0c5-5daa836fef5c",
      appKey: "b1f41ae0-f004-43c2-a0a1-79cb4e03658a",
      */ /*appID: "457bd17f-5f76-4fa7-9a6a-081ab1a2eb77",
      appKey: "cc0dd1c4-25b0-4b8c-8d32-e1c360b7f469",*/ /*
      cameraEnabled: true,
      gallerySelectionEnabled: false,
      teamMemberInfoVisible: false,
      responseExpectationEnabled: false,
      showNotificationBanner: true,
    );
    FreshchatUser user = FreshchatUser.initail();
    user.email = email;
    user.firstName = firstname;
    user.lastName = lastname;
    user.phoneCountryCode = countrycode;
    user.phone = phone;

    await FlutterFreshchat.updateUserInfo(user: user);
    // Custom properties can be set by creating a Map<String, String>
    Map<String, String> customProperties = Map<String, String>();
    customProperties["loggedIn"] = "true";

    await FlutterFreshchat.updateUserInfo(user: user, customProperties: customProperties);



    //await FlutterFreshchat.updateUserInfo(user: FreshchatUser);
  }*/

  void launchWhatsapp({@required number,@required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }

  @override
  Widget build(BuildContext context) {
    print("emailapp drawer"+email.toString());
    // TODO: implement build
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /*AppBar(
              title: Text('Hello Friend!'),
              automaticallyImplyLeading: false, // it shouldnt add back button
            ),*/
            Container(
              color: ColorCodes.whiteColor,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  !PrefUtils.prefs.containsKey("apikey")
                      ?
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                          arguments: {
                            "prev": "signupSelectionScreen",
                          } );
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Image.asset(Images.appLogin,
                            height: 25.0, width: 25.0),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          S.of(context).login_register,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                       Spacer(),
                        Icon(Icons.keyboard_arrow_right,
                            color: ColorCodes.greyColor,
                            size: 30),
                        SizedBox(
                          width: 25.0,
                        ),
                      ],
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 5.0),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left,
                            color: ColorCodes.greyColor,
                            size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // if(photourl != null) CircleAvatar(radius: 30.0, backgroundColor: Color(0xffD3D3D3), backgroundImage: NetworkImage(photourl),),
                      //  if(photourl == null) CircleAvatar(radius: 30.0, backgroundColor: Color(0xffD3D3D3),),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              store.userData.username??"",
                              maxLines: 2,
                              /*overflow: TextOverflow.ellipsis,*/ style:
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                            color: ColorCodes.blackColor),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              store.userData.mobileNumber??"",
                              /*overflow: TextOverflow.ellipsis,*/ style:
                            TextStyle(fontSize: 14.0, color: ColorCodes.greyColor),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(EditScreen.routeName);
                        },
                        child: Text(
                          S.of(context).edit,
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.greyColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              color:  ColorCodes.appdrawerColor,
              height: 15,
            ),
            Container(
              color: ColorCodes.whiteColor,
              padding: EdgeInsets.only(left: 20, right: 20, top:10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(store.language.languages.length > 1)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showDialog(context: context, builder: (BuildContext context) => LanguageselectDailog(context));
                      },
                      child: Column(
                        children: <Widget>[
                          Image.asset(Images.appBar_lang, width: 25, height: 25,
                              color:  !PrefUtils.prefs.containsKey("apikey")
                                  ? ColorCodes.greyColor
                                  : ColorCodes.mediumBlackColor),
                          SizedBox(height: 3),
                          Text(
                            S.current.language,
                            style: TextStyle(
                                fontSize: 15,
                                color:  !PrefUtils.prefs.containsKey("apikey")
                                    ? ColorCodes.greyColor
                                    : ColorCodes.mediumBlackColor),
                          ),
                        ],
                      ),
                    ),
                  if(store.language.languages.length > 1)
                  Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                       !PrefUtils.prefs.containsKey("apikey")
                          ? Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                           arguments: {
                             "prev": "signupSelectionScreen",
                           }
                      )
                          : Navigator.of(context).pushNamed(
                        HelpScreen.routeName,
                      );
                    },
                    child: Column(
                          children: <Widget>[
                            Image.asset(Images.appbar_help,
                                color:  !PrefUtils.prefs.containsKey("apikey")
                                    ? ColorCodes.greyColor
                                    : ColorCodes.mediumBlackColor,
                                height: 25.0, width: 25.0),
                            SizedBox(height: 3),
                            Text(S.of(context).ordering_help,
                              //S.of(context).help,
                              style: TextStyle(
                                  fontSize: 14,
                                  color:  !PrefUtils.prefs.containsKey("apikey")
                                      ? ColorCodes.greyColor
                                      : ColorCodes.mediumBlackColor),
                            ),
                      ],
                    ),
                  ),
                  (store.language.languages.length > 1) ?
                  Spacer() :
                      SizedBox(width: 25),
                  if(Features.isWallet)
                    GestureDetector(
                      onTap: () {
                         !PrefUtils.prefs.containsKey("apikey")
                            ? Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                             arguments: {
                               "prev": "signupSelectionScreen",
                             }
                        )
                            : Navigator.of(context).pushNamed(
                            WalletScreen.routeName,
                            arguments: {"type": "wallet"});
                      },
                      child: Column(
                        children: <Widget>[
                          Image.asset(Images.walletImg,
                              color:  !PrefUtils.prefs.containsKey("apikey")
                                  ? ColorCodes.greyColor
                                  : ColorCodes.mediumBlackColor,
                              height: 25.0, width: 25.0),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                              S.of(context).wallet,//"Wallet",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color:  !PrefUtils.prefs.containsKey("apikey")
                                      ? ColorCodes.greyColor
                                      : ColorCodes.mediumBlackColor)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: ColorCodes.appdrawerColor,
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              child: Text(
                S.of(context).order_more,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorCodes.blackColor,
                  )
              )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                color: ColorCodes.whiteColor,
                padding: EdgeInsets.only(left: 18, right: 20, top: 15, bottom: 15),
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                         !PrefUtils.prefs.containsKey("apikey")
                            ? Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                             arguments: {
                               "prev": "signupSelectionScreen",
                             }
                        )
                            : Navigator.of(context).pushNamed(
                          MyorderScreen.routeName,arguments: {
                          "orderhistory": ""
                        }
                        );
                        //Navigator.of(context).pop();
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset(Images.appbar_myorder, height: 28.0, width: 28.0,
                          color: ColorCodes.greyColor),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            S.of(context).my_orders,
                            style: TextStyle(
                                fontSize: 15,
                                color:  !PrefUtils.prefs.containsKey("apikey") ? Colors.grey : ColorCodes.greyColor),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    if(Features.isSubscription)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                           !PrefUtils.prefs.containsKey("apikey")
                              ? Navigator.of(context).pushNamed(
                            SignupSelectionScreen.routeName,
                               arguments: {
                                 "prev": "signupSelectionScreen",
                               }
                          )
                              : Navigator.of(context).pushNamed(
                            MySubscriptionScreen.routeName,
                          );
                          //Navigator.of(context).pop();
                        },
                        child: Row(
                          children: <Widget>[
                            Image.asset(Images.appbar_subscription, height: 28.0, width: 28.0,
                                color: ColorCodes.greyColor),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              S.of(context).my_subscription,
                              style: TextStyle(
                                  fontSize: 15,
                                  color:  !PrefUtils.prefs.containsKey("apikey") ? Colors.grey : ColorCodes.greyColor),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    if(Features.isSubscription)
                    SizedBox(height: 15),
                    if(Features.isShoppingList)
                      GestureDetector(
                        onTap: () {
                           !PrefUtils.prefs.containsKey("apikey")
                              ? Navigator.of(context).pushNamed(
                            SignupSelectionScreen.routeName,
                               arguments: {
                                 "prev": "signupSelectionScreen",
                               }
                          )
                              : Navigator.of(context).pushNamed(
                            ShoppinglistScreen.routeName,
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Image.asset(Images.appbar_shopping, height: 28.0, width: 28.0,
                                color: ColorCodes.greyColor),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                                S.of(context).shopping_list,//"Shopping list",
                                style: TextStyle(
                                    color:  !PrefUtils.prefs.containsKey("apikey") ? Colors.grey : ColorCodes.greyColor, fontSize: 15.0)),
                          ],
                        ),
                      ),
                    SizedBox(height: 15),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                         !PrefUtils.prefs.containsKey("apikey")
                            ? Navigator.of(context).pushReplacementNamed(
                          SignupSelectionScreen.routeName,
                             arguments: {
                               "prev": "signupSelectionScreen",
                             }
                        )
                            : Navigator.of(context).pushNamed(
                          AddressbookScreen.routeName,
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset(Images.appbar_address, height: 28.0, width: 28.0,
                              color: ColorCodes.greyColor),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            S.of(context).address_book,
                            style: TextStyle(
                                fontSize: 15,
                                color:  !PrefUtils.prefs.containsKey("apikey")
                                    ? ColorCodes.grey
                                    : ColorCodes.greyColor),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            if(PrefUtils.prefs.getString('myreffer') != 'null' && ! !PrefUtils.prefs.containsKey("apikey") && Features.isReferEarn)
            Container(
              color:  ColorCodes.appdrawerColor,
              height: 20,
            ),
            if(PrefUtils.prefs.getString('myreffer') != 'null' && ! !PrefUtils.prefs.containsKey("apikey") && Features.isReferEarn)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    ReferEarn.routeName,
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 24.0,
                      ),
                      RichText(
                        text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                              text:S.of(context).refer_earn,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400, color: ColorCodes.blackColor),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Image.asset(Images.appbar_refer, width: 30, height: 30),
                      // Image.asset(Images.appHome, height: 15.0, width: 15.0),
                      SizedBox(
                        width: 25.0,
                      ),
                    ],
                  ),
                ),
              ) ,
            if(PrefUtils.prefs.getString('myreffer') != 'null' && ! !PrefUtils.prefs.containsKey("apikey") && Features.isReferEarn)
              Container(
                color:  ColorCodes.appdrawerColor,
                height: 20,
              ),
            // SizedBox(height: (PrefUtils.prefs.getString('myreffer') != 'null' && ! !PrefUtils.prefs.containsKey("apikey") && Features.isReferEarn) ? 5.0 : 10),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pushNamed(
            //       CategoryScreen.routeName,
            //     );
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[
            //       Row(
            //         children: [
            //           SizedBox(
            //             width: 25.0,
            //           ),
            //           (IConstants.isEnterprise)? Image.asset(Images.appCategory,
            //               height: 15.0, width: 15.0):SizedBox.shrink(),
            //           SizedBox(
            //             width: 15.0,
            //           ),
            //           Text(S.of(context).shop_by_category,
            //               style: TextStyle(
            //                   fontSize: 14,
            //                   color: (IConstants.isEnterprise)?Theme.of(context).primaryColor:ColorCodes.blackColor)),
            //           SizedBox(
            //             width: 40.0,
            //           ),
            //           Icon(Icons.keyboard_arrow_right,
            //               color:  (IConstants.isEnterprise)?Theme.of(context).primaryColor:ColorCodes.blackColor, size: 24),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 5),
            // (IConstants.isEnterprise)? Divider(
            //   color: ColorCodes.lightColor,
            //   thickness: 2,
            // ):Divider(),
            (Features.isMembership)?
            SizedBox(height: 15):SizedBox.shrink(),
            (Features.isMembership)? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
                 !PrefUtils.prefs.containsKey("apikey")
                    ? Navigator.of(context).pushNamed(
                  SignupSelectionScreen.routeName,
                     arguments: {
                       "prev": "signupSelectionScreen",
                     }
                )
                    : Navigator.of(context).pushNamed(
                  MembershipScreen.routeName,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.lightBlueColor),
                  color: ColorCodes.lightBlueColor,
                ),
                margin: EdgeInsets.only(right: 25, left: 20),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      S.of(context).membership,
                      style: TextStyle(
                          fontSize: 18,
                          color:  !PrefUtils.prefs.containsKey("apikey")
                              ? ColorCodes.lightblue
                              : ColorCodes.lightblue),
                    ),
                    Spacer(),
                    ! !PrefUtils.prefs.containsKey("apikey") ?
                    (PrefUtils.prefs.getString("membership") == "1") ?
                    Row(
                      children: [
                        Text(
                          S.of(context).active,
                          style: TextStyle(
                              fontSize: 15,
                              color:  ColorCodes.lightblue),
                        ),SizedBox(width: 5),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                            border: Border.all(
                              color: ColorCodes.greenColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check,
                                color: ColorCodes.greenColor,
                                size: 15.0),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ) :
                    Row(
                      children: [
                        Text(
                          S.of(context).buy,
                          style: TextStyle(
                              fontSize: 15,
                              color:  ColorCodes.lightblue),
                         ),
                          // SizedBox(width: 5),
                        // Container(
                        //   width: 20.0,
                        //   height: 20.0,
                        //   decoration: BoxDecoration(
                        //     color: ColorCodes.whiteColor,
                        //     border: Border.all(
                        //       color: ColorCodes.greenColor,
                        //     ),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: Container(
                        //     margin: EdgeInsets.all(1.5),
                        //     decoration: BoxDecoration(
                        //       color: ColorCodes.whiteColor,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Icon(Icons.check,
                        //         color: ColorCodes.whiteColor,
                        //         size: 15.0),
                        //   ),
                        // ),
                        SizedBox(width: 10),
                      ],
                    ) : Row(
                      children: [
                        Text(
                        S.of(context).buy,
                          style: TextStyle(
                              fontSize: 15,
                              color:  ColorCodes.lightblue),
                        ),
                        // SizedBox(width: 5),
                        // Container(
                        //   width: 20.0,
                        //   height: 20.0,
                        //   decoration: BoxDecoration(
                        //     color: ColorCodes.whiteColor,
                        //     border: Border.all(
                        //       color: ColorCodes.greenColor,
                        //     ),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: Container(
                        //     margin: EdgeInsets.all(1.5),
                        //     decoration: BoxDecoration(
                        //       color: ColorCodes.whiteColor,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Icon(Icons.check,
                        //         color: ColorCodes.whiteColor,
                        //         size: 15.0),
                        //   ),
                        // ),
                        SizedBox(width: 10),
                      ],
                    ),

                  ],
                ),
              ),
            ):SizedBox.shrink(),

            (Features.isLoyalty)?SizedBox(height: 10):SizedBox.shrink(),
            (Features.isLoyalty)? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
                 !PrefUtils.prefs.containsKey("apikey")
                    ? Navigator.of(context).pushNamed(
                  SignupSelectionScreen.routeName,
                     arguments: {
                       "prev": "signupSelectionScreen",
                     }
                )
                    : Navigator.of(context).pushNamed(WalletScreen.routeName,
                    arguments: {'type': "loyalty"});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.appdrawerColor),
                  color: ColorCodes.appdrawerColor,
                ),
                margin: EdgeInsets.only(right: 25, left: 20),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      S.of(context).loyalty,
                      style: TextStyle(
                          fontSize: 18,
                          color:  !PrefUtils.prefs.containsKey("apikey")
                              ? ColorCodes.greyColor
                              : ColorCodes.greyColor),
                    ),
                    Spacer(),
                     !PrefUtils.prefs.containsKey("apikey")?
                    Text("0",
                      style: TextStyle(
                          color: ColorCodes.greyColor, fontSize: 16.0),
                    ) :
                    Text(PrefUtils.prefs.containsKey("loyalty_balance") ? PrefUtils.prefs.getString("loyalty_balance") : "",
                      style: TextStyle(
                          color: ColorCodes.greyColor, fontSize: 16.0),
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      Images.coinImg,
                      height: 20.0,
                      width: 20.0,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ):SizedBox.shrink(),
            SizedBox(height: 15),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AboutScreen.routeName,
                );
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25.0,
                  ),
                  Container(
                      width: 150.0,
                      child: Row(
                        children: <Widget>[
                          // Image.asset(Images.appAbout,
                          //     height: 15.0, width: 15.0),
                          // SizedBox(width: 15.0),
                          Text(
                            S.of(context).about_us,
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorCodes.greyColor),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    PrivacyScreen.routeName,
                  );
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).privacy_others,
                        style: TextStyle(
                            fontSize: 15,
                            color: ColorCodes.greyColor),
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 15),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
                try {
                  // if (Platform.isIOS) {
                  //   LaunchReview.launch(
                  //       writeReview: false, iOSAppId: IConstants.appleId);
                  // } else {
                  //   LaunchReview.launch();
                  // }
                  inappreview.requestReview();
                }catch(e){};
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25.0,
                  ),
                  Text(

                    _isIOS
                        ? S.of(context).rate_us
                        : S.of(context).rate_us,
                    style: TextStyle(
                        fontSize: 15, color: ColorCodes.greyColor),


                  ),

                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 15),
            if (! !PrefUtils.prefs.containsKey("apikey"))
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  //SharedPreferences prefs = await SharedPreferences.getInstance();
                  PrefUtils.prefs.remove('LoginStatus');
                  PrefUtils.prefs.remove("apikey");
                  store.CartItemList.clear();
                  store.homescreen.data = null;
                  if (PrefUtils.prefs.getString('prevscreen') == 'signingoogle') {
                    PrefUtils.prefs.setString("photoUrl", "");
                    await _googleSignIn.signOut();
                    String countryCode = PrefUtils.prefs.getString("country_code");
                    String branch = PrefUtils.prefs.getString("branch");
                    String tokenId = PrefUtils.prefs.getString('tokenid');
                    String _mapFetch = "null";
                    String _isDelivering = "false";
                    String defaultLocation = "null";
                    String deliverylocation = "null";
                    String _latitude = "null";
                    String _longitude = "null";
                    String currentdeliverylocation = IConstants
                        .currentdeliverylocation.value;
                    if (PrefUtils.prefs.containsKey("ismapfetch")) {
                      _mapFetch = PrefUtils.prefs.getString("ismapfetch");
                    }
                    if (PrefUtils.prefs.containsKey("isdelivering")) {
                      _isDelivering =
                          PrefUtils.prefs.getString("isdelivering");
                    }
                    if (PrefUtils.prefs.containsKey("defaultlocation")) {
                      defaultLocation =
                          PrefUtils.prefs.getString("defaultlocation");
                    }
                    if (PrefUtils.prefs.containsKey("deliverylocation")) {
                      deliverylocation =
                          PrefUtils.prefs.getString("deliverylocation");
                    }
                    if (PrefUtils.prefs.containsKey("latitude")) {
                      _latitude = PrefUtils.prefs.getString("latitude");
                    }

                    if (PrefUtils.prefs.containsKey("longitude")) {
                      _longitude = PrefUtils.prefs.getString("longitude");
                    }
                    PrefUtils.prefs.clear();
                    PrefUtils.prefs.setBool('introduction', true);
                    PrefUtils.prefs.setString('country_code', countryCode);
                    PrefUtils.prefs.setString("branch", branch);
                    PrefUtils.prefs.setString("tokenid", tokenId);
                    PrefUtils.prefs.setString("ismapfetch", _mapFetch);
                    PrefUtils.prefs.setString(
                        "isdelivering", _isDelivering);
                    PrefUtils.prefs.setString(
                        "defaultlocation", defaultLocation);
                    PrefUtils.prefs.setString(
                        "deliverylocation", deliverylocation);
                    PrefUtils.prefs.setString("longitude", _longitude);
                    PrefUtils.prefs.setString("latitude", _latitude);
                    IConstants.currentdeliverylocation.value =
                        currentdeliverylocation;

                    Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName,
                            (route) => false,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        });
                    //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
                  } else if (PrefUtils.prefs.getString('prevscreen') ==
                      'signinfacebook') {
                    PrefUtils.prefs.getString("FBAccessToken");
                   // var facebookSignIn = FacebookLogin();

                    final graphResponse = await http.delete(
                        'https://graph.facebook.com/v2.12/me/permissions/?access_token=${PrefUtils.prefs.getString("FBAccessToken")}&httpMethod=DELETE&ref=logout&destroy=true');

                    PrefUtils.prefs.setString("photoUrl", "");
                    // await facebookSignIn.logOut().then((value) {
                    //   String countryCode = PrefUtils.prefs.getString("country_code");
                    //   String branch = PrefUtils.prefs.getString("branch");
                    //   String tokenId = PrefUtils.prefs.getString('tokenid');
                    //   String code = PrefUtils.prefs.getString('referCodeDynamic');
                    //
                    //   String _mapFetch = "null";
                    //   String _isDelivering = "false";
                    //   String defaultLocation = "null";
                    //   String deliverylocation = "null";
                    //   String _latitude = "null";
                    //   String _longitude = "null";
                    //   String currentdeliverylocation = IConstants
                    //       .currentdeliverylocation.value;
                    //   if (PrefUtils.prefs.containsKey("ismapfetch")) {
                    //     _mapFetch = PrefUtils.prefs.getString("ismapfetch");
                    //   }
                    //   if (PrefUtils.prefs.containsKey("isdelivering")) {
                    //     _isDelivering = PrefUtils.prefs.getString(
                    //         "isdelivering");
                    //   }
                    //   if (PrefUtils.prefs.containsKey("defaultlocation")) {
                    //     defaultLocation = PrefUtils.prefs.getString(
                    //         "defaultlocation");
                    //   }
                    //   if (PrefUtils.prefs.containsKey("deliverylocation")) {
                    //     deliverylocation = PrefUtils.prefs.getString(
                    //         "deliverylocation");
                    //   }
                    //   if (PrefUtils.prefs.containsKey("latitude")) {
                    //     _latitude = PrefUtils.prefs.getString("latitude");
                    //   }
                    //
                    //   if (PrefUtils.prefs.containsKey("longitude")) {
                    //     _longitude = PrefUtils.prefs.getString("longitude");
                    //   }
                    //
                    //   PrefUtils.prefs.clear();
                    //   PrefUtils.prefs.setBool('introduction', true);
                    //   PrefUtils.prefs.setString('country_code', countryCode);
                    //   PrefUtils.prefs.setString("branch", branch);
                    //   PrefUtils.prefs.setString("tokenid", tokenId);
                    //   PrefUtils.prefs.setString("referCodeDynamic", code);
                    //   PrefUtils.prefs.setString("ismapfetch", _mapFetch);
                    //   PrefUtils.prefs.setString(
                    //       "isdelivering", _isDelivering);
                    //   PrefUtils.prefs.setString(
                    //       "defaultlocation", defaultLocation);
                    //   PrefUtils.prefs.setString(
                    //       "deliverylocation", deliverylocation);
                    //   PrefUtils.prefs.setString("longitude", _longitude);
                    //   PrefUtils.prefs.setString("latitude", _latitude);
                    //   IConstants.currentdeliverylocation.value =
                    //       currentdeliverylocation;
                    //
                    //   Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false,
                    //       arguments: {
                    //         "prev": "signupSelectionScreen",
                    //       });
                    //   //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
                    // });
                  } else {
                    String countryCode = PrefUtils.prefs.getString("country_code");
                    String branch = PrefUtils.prefs.getString("branch");
                    String tokenId = PrefUtils.prefs.getString('tokenid');
                    String _mapFetch = "null";
                    String _isDelivering = "false";
                    String defaultLocation = "null";
                    String deliverylocation = "null";
                    String _latitude = "null";
                    String _longitude = "null";
                    String currentdeliverylocation = IConstants
                        .currentdeliverylocation.value;
                    if (PrefUtils.prefs.containsKey("ismapfetch")) {
                      _mapFetch = PrefUtils.prefs.getString("ismapfetch");
                    }
                    if (PrefUtils.prefs.containsKey("isdelivering")) {
                      _isDelivering =
                          PrefUtils.prefs.getString("isdelivering");
                    }
                    if (PrefUtils.prefs.containsKey("defaultlocation")) {
                      defaultLocation =
                          PrefUtils.prefs.getString("defaultlocation");
                    }
                    if (PrefUtils.prefs.containsKey("deliverylocation")) {
                      deliverylocation =
                          PrefUtils.prefs.getString("deliverylocation");
                    }
                    if (PrefUtils.prefs.containsKey("latitude")) {
                      _latitude = PrefUtils.prefs.getString("latitude");
                    }

                    if (PrefUtils.prefs.containsKey("longitude")) {
                      _longitude = PrefUtils.prefs.getString("longitude");
                    }
                    PrefUtils.prefs.clear();
                    PrefUtils.prefs.setBool('introduction', true);
                    PrefUtils.prefs.setString('country_code', countryCode);
                    PrefUtils.prefs.setString("branch", branch);
                    PrefUtils.prefs.setString("tokenid", tokenId);
                    PrefUtils.prefs.setString("ismapfetch", _mapFetch);
                    PrefUtils.prefs.setString(
                        "isdelivering", _isDelivering);
                    PrefUtils.prefs.setString(
                        "defaultlocation", defaultLocation);
                    PrefUtils.prefs.setString(
                        "deliverylocation", deliverylocation);
                    PrefUtils.prefs.setString("longitude", _longitude);
                    PrefUtils.prefs.setString("latitude", _latitude);
                    IConstants.currentdeliverylocation.value =
                        currentdeliverylocation;

                    Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        });
                    //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
                  }
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Text(
                      S.of(context).log_out,
                      style: TextStyle(
                          fontSize: 15, color: ColorCodes.greyColor),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            SizedBox(height: 15),

            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //      !PrefUtils.prefs.containsKey("apikey")
            //         ? Navigator.of(context).pushNamed(
            //       SignupSelectionScreen.routeName,
            //     )
            //         : Navigator.of(context).popUntil(ModalRoute.withName(
            //       HomeScreen.routeName,
            //     ));
            //     //Navigator.of(context).pop();
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Image.asset(Images.appHome, height: 15.0, width: 15.0),
            //       SizedBox(
            //         width: 15.0,
            //       ),
            //       Text(
            //         S.of(context).home,
            //         style: TextStyle(
            //             fontSize: 15, color: ColorCodes.mediumBlackColor),
            //       ),
            //       Spacer(),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 15),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //      !PrefUtils.prefs.containsKey("apikey")
            //         ? Navigator.of(context).pushNamed(
            //       SignupSelectionScreen.routeName,
            //     )
            //         : Navigator.of(context).pushNamed(
            //       MyorderScreen.routeName,
            //     );
            //     //Navigator.of(context).pop();
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Image.asset(Images.appMyorder, height: 15.0, width: 15.0),
            //       SizedBox(
            //         width: 15.0,
            //       ),
            //       Text(
            //         S.of(context).my_orders,
            //         style: TextStyle(
            //             fontSize: 15,
            //             color:  !PrefUtils.prefs.containsKey("apikey") ? Colors.grey : Colors.black),
            //       ),
            //       Spacer(),
            //     ],
            //   ),
            // ),
            // if(Features.isSubscription)
            //   SizedBox(height: 15,),
            // if(Features.isSubscription)
            //   GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () {
            //       Navigator.of(context).pop();
            //        !PrefUtils.prefs.containsKey("apikey")
            //           ? Navigator.of(context).pushNamed(
            //         SignupSelectionScreen.routeName,
            //       )
            //           : Navigator.of(context).pushNamed(
            //           MySubscriptionScreen.routeName,
            //       );
            //       //Navigator.of(context).pop();
            //     },
            //     child: Row(
            //       children: <Widget>[
            //         SizedBox(
            //           width: 25.0,
            //         ),
            //         Image.asset(Images.appMyorder, height: 15.0, width: 15.0),
            //         SizedBox(
            //           width: 15.0,
            //         ),
            //         Text(
            //           S.of(context).my_subscription,
            //           style: TextStyle(
            //               fontSize: 15,
            //               color:  !PrefUtils.prefs.containsKey("apikey") ? Colors.grey : Colors.black),
            //         ),
            //         Spacer(),
            //       ],
            //     ),
            //   ),
            // if(Features.isShoppingList)
            //   SizedBox(height: 15),
            // if(Features.isShoppingList)
            //   GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () {
            //       Navigator.of(context).pop();
            //        !PrefUtils.prefs.containsKey("apikey")
            //           ? Navigator.of(context).pushNamed(
            //         SignupSelectionScreen.routeName,
            //       )
            //           : Navigator.of(context).pushNamed(
            //         ShoppinglistScreen.routeName,
            //       );
            //     },
            //     child: Row(
            //       children: <Widget>[
            //         SizedBox(
            //           width: 25.0,
            //         ),
            //         Image.asset(Images.appShop, height: 15.0, width: 15.0),
            //         SizedBox(
            //           width: 15.0,
            //         ),
            //         Text(
            //           S.of(context).my_shopping_list,
            //           style: TextStyle(
            //               fontSize: 15,
            //               color:  !PrefUtils.prefs.containsKey("apikey")
            //                   ? ColorCodes.greyColor
            //                   : ColorCodes.mediumBlackColor),
            //         ),
            //         Spacer(),
            //       ],
            //     ),
            //   ),
            // SizedBox(height: 15),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //      !PrefUtils.prefs.containsKey("apikey")
            //         ? Navigator.of(context).pushReplacementNamed(
            //       SignupSelectionScreen.routeName,
            //     )
            //         : Navigator.of(context).pushNamed(
            //       AddressbookScreen.routeName,
            //     );
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Image.asset(Images.appAddress, height: 15.0, width: 15.0),
            //       SizedBox(
            //         width: 15.0,
            //       ),
            //       Text(
            //         S.of(context).address_book,
            //         style: TextStyle(
            //             fontSize: 15,
            //             color:  !PrefUtils.prefs.containsKey("apikey")
            //                 ? ColorCodes.greyColor
            //                 : ColorCodes.mediumBlackColor),
            //       ),
            //       Spacer(),
            //     ],
            //   ),
            // ),
            //
            // // (Features.isMembership || Features.isLoyalty) ? SizedBox(height: 20) : SizedBox.shrink(),
            // // (Features.isMembership || Features.isLoyalty) ?
            // // Container(
            // //   height: 40.0,
            // //   color: ColorCodes.lightColor,
            // //   child: Row(
            // //     children: <Widget>[
            // //       SizedBox(
            // //         width: 25.0,
            // //       ),
            // //       Container(
            // //           width: 150.0,
            // //           child: Row(
            // //             children: <Widget>[
            // //               Image.asset(Images.appOffer,
            // //                   height: 15.0, width: 15.0),
            // //               SizedBox(
            // //                 width: 15.0,
            // //               ),
            // //               Text(S.of(context).offers,
            // //                   style: TextStyle(
            // //                       fontSize: 14,
            // //                       color: Theme.of(context).primaryColor)),
            // //             ],
            // //           )),
            // //     ],
            // //   ),
            // // ) :
            // // SizedBox.shrink(),
            //
            //
            // SizedBox(height: 15),
            // (IConstants.isEnterprise)?Container(
            //   height: 40.0,
            //   color: ColorCodes.lightColor,
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Container(
            //           width: 150.0,
            //           child: Row(
            //             children: <Widget>[
            //               Image.asset(Images.appMore,
            //                   height: 15.0, width: 15.0),
            //               SizedBox(
            //                 width: 15.0,
            //               ),
            //               Text(S.of(context).more,
            //                   style: TextStyle(
            //                       fontSize: 14,
            //                       color: Theme.of(context).primaryColor)),
            //             ],
            //           )),
            //     ],
            //   ),
            // ):Divider(),
            // SizedBox(height: 15),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pushNamed(
            //       AboutScreen.routeName,
            //     );
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Container(
            //           width: 150.0,
            //           child: Row(
            //             children: <Widget>[
            //               Image.asset(Images.appAbout,
            //                   height: 15.0, width: 15.0),
            //               SizedBox(width: 15.0),
            //               Text(
            //                 S.of(context).about_us,
            //                 style: TextStyle(
            //                     fontSize: 15,
            //                     color: ColorCodes.mediumBlackColor),
            //               ),
            //             ],
            //           )),
            //       SizedBox(width: 50),
            //       Icon(Icons.keyboard_arrow_right,
            //           color: ColorCodes.greyColor, size: 24),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).pushNamed(
            //       PrivacyScreen.routeName,
            //     );
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Container(
            //           width: 150.0,
            //           child: Row(
            //             children: <Widget>[
            //               Image.asset(Images.appPrivacy,
            //                   height: 15.0, width: 15.0),
            //               SizedBox(
            //                 width: 15.0,
            //               ),
            //               Expanded(
            //                 child: Text(
            //                   S.of(context).privacy_others,
            //                   style: TextStyle(
            //                       fontSize: 15,
            //                       color: ColorCodes.mediumBlackColor),
            //                 ),
            //               ),
            //             ],
            //           )),
            //
            //       SizedBox(width: 50),
            //       Icon(Icons.keyboard_arrow_right,
            //           color: ColorCodes.greyColor, size: 24),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            // if(store.language.languages.length > 1)
            //   GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     showDialog(context: context, builder: (BuildContext context) => LanguageselectDailog(context));
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Container(
            //           width: 150.0,
            //           child: Row(
            //             children: <Widget>[
            //               Icon(Icons.language,size: 15,),
            //               SizedBox(
            //                 width: 15.0,
            //               ),
            //               Text(
            //                 S.current.language,
            //                 style: TextStyle(
            //                     fontSize: 15,
            //                     color:  !PrefUtils.prefs.containsKey("apikey")
            //                         ? ColorCodes.greyColor
            //                         : ColorCodes.mediumBlackColor),
            //               ),
            //             ],
            //           )),
            //       SizedBox(width: 50),
            //       Icon(Icons.keyboard_arrow_right,
            //           color: ColorCodes.greyColor, size: 24),
            //     ],
            //   ),
            // ),
            // if(store.language.languages.length > 1)
            //   SizedBox(height: 10),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     Navigator.of(context).pop();
            //      !PrefUtils.prefs.containsKey("apikey")
            //         ? Navigator.of(context).pushNamed(
            //       SignupSelectionScreen.routeName,
            //     )
            //         : Navigator.of(context).pushNamed(
            //       HelpScreen.routeName,
            //     );
            //   },
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 25.0,
            //       ),
            //       Container(
            //           width: 150.0,
            //           child: Row(
            //             children: <Widget>[
            //               Image.asset(Images.appHelp,
            //                   height: 15.0, width: 15.0),
            //               SizedBox(
            //                 width: 15.0,
            //               ),
            //               Text(
            //                 S.of(context).help,
            //                 style: TextStyle(
            //                     fontSize: 15,
            //                     color:  !PrefUtils.prefs.containsKey("apikey")
            //                         ? ColorCodes.greyColor
            //                         : ColorCodes.mediumBlackColor),
            //               ),
            //             ],
            //           )),
            //       SizedBox(width: 50),
            //       Icon(Icons.keyboard_arrow_right,
            //           color: ColorCodes.greyColor, size: 24),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            // (IConstants.isEnterprise)?SizedBox.shrink():Divider(),
            // if(Features.isLiveChat || Features.isWhatsapp)
            //   GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () async {
            //       Navigator.of(context).pop();
            //        !PrefUtils.prefs.containsKey("apikey")
            //           ? Navigator.of(context).pushNamed(
            //         SignupSelectionScreen.routeName,
            //       )
            //           :
            //       (Features.isLiveChat && Features.isWhatsapp)?
            //       Navigator.of(context)
            //           .pushNamed(CustomerSupportScreen.routeName, arguments: {
            //         'name': name,
            //         'email': email,
            //         'photourl': photourl,
            //         'phone': phone,
            //       }):
            //       Features.isWhatsapp?launchWhatsapp(number:'+91'+ PrefUtils.prefs.getString('secondary_mobile'),message:"I want to order Grocery"):
            //       Navigator.of(context)
            //           .pushNamed(CustomerSupportScreen.routeName, arguments: {
            //         'name': name,
            //         'email': email,
            //         'photourl': photourl,
            //         'phone': phone,
            //       });
            //     },
            //     child: Row(
            //       children: <Widget>[
            //         SizedBox(
            //           width: 25.0,
            //         ),
            //         Image.asset(Images.appCustomer, height: 15.0, width: 15.0),
            //         SizedBox(
            //           width: 15.0,
            //         ),
            //         Text(
            //           S.of(context).customer_support,
            //           style: TextStyle(
            //               fontSize: 15,
            //               color:  !PrefUtils.prefs.containsKey("apikey")
            //                   ? ColorCodes.greyColor
            //                   : ColorCodes.mediumBlackColor),
            //         ),
            //         Spacer(),
            //       ],
            //     ),
            //   ),
            // if(Features.isLiveChat || Features.isWhatsapp)
            //   SizedBox(height: 15),
            // if(Features.isShare)
            //   GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () {
            //       Navigator.of(context).pop();
            //       try {
            //         if (Platform.isIOS) {
            //           Share.share('Download ' +
            //               IConstants.APP_NAME +
            //               ' from App Store https://apps.apple.com/us/app/id' + IConstants.appleId);
            //         } else {
            //           Share.share('Download ' +
            //               IConstants.APP_NAME +
            //               ' from Google Play Store https://play.google.com/store/apps/details?id=' + IConstants.androidId);
            //         }
            //       }catch(e){
            //
            //       }
            //     },
            //     child: Row(
            //       children: <Widget>[
            //         SizedBox(
            //           width: 25.0,
            //         ),
            //         Image.asset(Images.appShare, height: 15.0, width: 15.0),
            //         SizedBox(
            //           width: 15.0,
            //         ),
            //         Text(
            //           "Share",
            //           style: TextStyle(
            //               fontSize: 15, color: ColorCodes.mediumBlackColor),
            //         ),
            //         Spacer(),
            //       ],
            //     ),
            //   ),
            // if(Features.isShare)
            //   SizedBox(height: 15),
            //
            // SizedBox(height: 15),
            // if (! !PrefUtils.prefs.containsKey("apikey"))
            //   GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () async {
            //       //SharedPreferences prefs = await SharedPreferences.getInstance();
            //       PrefUtils.prefs.remove('LoginStatus');
            //       if (PrefUtils.prefs.getString('prevscreen') == 'signingoogle') {
            //         PrefUtils.prefs.setString("photoUrl", "");
            //         await _googleSignIn.signOut();
            //         String countryCode = PrefUtils.prefs.getString("country_code");
            //         String branch = PrefUtils.prefs.getString("branch");
            //         String tokenId = PrefUtils.prefs.getString('tokenid');
            //         PrefUtils.prefs.clear();
            //         PrefUtils.prefs.setBool('introduction', true);
            //         PrefUtils.prefs.setString('country_code', countryCode);
            //         PrefUtils.prefs.setString("branch", branch);
            //         PrefUtils.prefs.setString("tokenid", tokenId);
            //         Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false);
            //         //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
            //       } else if (PrefUtils.prefs.getString('prevscreen') ==
            //           'signinfacebook') {
            //         PrefUtils.prefs.getString("FBAccessToken");
            //         var facebookSignIn = FacebookLogin();
            //
            //         final graphResponse = await http.delete(
            //             'https://graph.facebook.com/v2.12/me/permissions/?access_token=${PrefUtils.prefs.getString("FBAccessToken")}&httpMethod=DELETE&ref=logout&destroy=true');
            //
            //         PrefUtils.prefs.setString("photoUrl", "");
            //         await facebookSignIn.logOut().then((value) {
            //           String countryCode = PrefUtils.prefs.getString("country_code");
            //           String branch = PrefUtils.prefs.getString("branch");
            //           String tokenId = PrefUtils.prefs.getString('tokenid');
            //           String code = PrefUtils.prefs.getString('referCodeDynamic');
            //           PrefUtils.prefs.clear();
            //           PrefUtils.prefs.setBool('introduction', true);
            //           PrefUtils.prefs.setString('country_code', countryCode);
            //           PrefUtils.prefs.setString("branch", branch);
            //           PrefUtils.prefs.setString("tokenid", tokenId);
            //           PrefUtils.prefs.setString("referCodeDynamic", code);
            //           Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false);
            //           //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
            //         });
            //       } else {
            //         String countryCode = PrefUtils.prefs.getString("country_code");
            //         String branch = PrefUtils.prefs.getString("branch");
            //         String tokenId = PrefUtils.prefs.getString('tokenid');
            //         PrefUtils.prefs.clear();
            //         PrefUtils.prefs.setBool('introduction', true);
            //         PrefUtils.prefs.setString('country_code', countryCode);
            //         PrefUtils.prefs.setString("branch", branch);
            //         PrefUtils.prefs.setString("tokenid", tokenId);
            //         Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false);
            //         //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
            //       }
            //     },
            //     child: Row(
            //       children: <Widget>[
            //         SizedBox(
            //           width: 25.0,
            //         ),
            //         Image.asset(Images.appLogout, height: 15.0, width: 15.0),
            //         SizedBox(
            //           width: 15.0,
            //         ),
            //         Text(
            //           S.of(context).log_out,
            //           style: TextStyle(
            //               fontSize: 15, color: ColorCodes.mediumBlackColor),
            //         ),
            //         Spacer(),
            //       ],
            //     ),
            //   ),
            // SizedBox(
            //   height: 20.0,
            // ),
          ],
        ),
      ),
    );
  }
}
