import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../utils/prefUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/policy_screen.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';


class AboutScreen extends StatefulWidget {
  static const routeName = '/about-screen';
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isLoading = true;
  //SharedPreferences prefs;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: gradientappbarmobile(),
        backgroundColor: Colors.white,

        body: _isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0,),
              if(PrefUtils.prefs.getString("description")!="")
              GestureDetector(
                onTap: () async {
                  //SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.of(context).pushNamed(
                      PolicyScreen.routeName,
                      arguments: {
                        'title' : S.of(context).about_us,
                        'body' : PrefUtils.prefs.getString("description"),
                      }
                  );
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S.of(context).about_us
                      // "About Us"
                      , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(PrefUtils.prefs.getString("description")!="")
              SizedBox(height: 5.0,),
              if(PrefUtils.prefs.getString("description")!="")
              Divider(),
              SizedBox(height: 5.0,),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.of(context).pushNamed(
                      PolicyScreen.routeName,
                      arguments: {
                        'title' : S.of(context).contact_us,
                        'body' : "",
                        'businessname': IConstants.restaurantName,
                        'address': PrefUtils.prefs.getString("restaurant_address"),
                        'contactnum': IConstants.primaryMobile,
                        'pemail': IConstants.primaryEmail,
                        'semail': IConstants.secondaryEmail,
                      }
                  );
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S.of(context).contact_us,
                      // "Contact Us",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              SizedBox(height: 5.0,),
              Divider(),
              SizedBox(height: 5.0,),
            ],
          ),
        )
    );
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
          onPressed: () {
            Navigator.of(context).pop();
            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            return Future.value(false);
          }
      ),
      titleSpacing: 0,
      title: Text(
          S.of(context).about,
        // 'About',
        style: TextStyle(color: ColorCodes.menuColor,fontWeight: FontWeight.w800),
      ),
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
}
