import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../repository/authenticate/AuthRepo.dart';

import '../utils/prefUtils.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  int count = 0;
  GlobalKey<ScaffoldState> scaffoldKey;


  void setUpFirebase() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

/*  FirebaseNotifications() {

    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }*/

  // ignore: non_constant_identifier_names
  void firebaseCloudMessaging_Listeners() {

    try{
      if(Platform.isIOS) {
        iOS_Permission();
      }
    } catch(e){
    }

    _firebaseMessaging.getToken().then((token) async {

      PrefUtils.prefs.setString("ftokenid", token);
      debugPrint("tocken id: "+ token.toString());
      auth.getuserProfile(onsucsess: (value){},onerror: (){});
    });

/*    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Navigator.of(context).pushNamed(
          HomeScreen.routeName,
        );
        setState(() {
          count++;
        });
        addNotification(message);
        return Fluttertoast.showToast(msg: "onMessage!!!");
        },
      onResume: (Map<String, dynamic> message) async {
        Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder: (_) => HomeScreen()));
        Navigator.of(context).pushNamed(
          HomeScreen.routeName,
        );
        setState(() {
          count++;
        });
        addNotification(message);
        return Fluttertoast.showToast(msg: "onResume!!!");
        },
      onLaunch: (Map<String, dynamic> message) async {
        //Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder: (_) => HomeScreen()));
        Navigator.of(context).pushNamed(
          CategoryScreen.routeName,
        );
        setState(() {
          count++;
        });
        addNotification(message);
        return Fluttertoast.showToast(msg: "onLaunch!!!");
      },
    );*/
  }


  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
    });
  }
}
