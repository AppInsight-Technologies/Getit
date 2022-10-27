import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generated/l10n.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';

class SubscriptionScreen extends StatefulWidget {
  static const routeName = '/subscription-screen';
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return SafeArea(
      child: Scaffold(
          appBar: NewGradientAppBar(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.accentColor,
                  ColorCodes.primaryColor
                ]
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
                onPressed: () => Navigator.of(context).pop()),
            elevation: (IConstants.isEnterprise)?0:1,
            title: Text(
              S.of(context).subscription,//"Subscription",
              style: TextStyle(color: ColorCodes.menuColor),
            ),
          ),
//        drawer: AppDrawer(),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
            child: Text(
              S.of(context).coming_soon,//"Coming soon...",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
      ),
    );
  }
}
