import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../generated/l10n.dart';
import 'package:provider/provider.dart';
import '../screens/searchitem_screen.dart';
import '../providers/notificationitems.dart';
import '../widgets/categories_item.dart';
import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../assets/ColorCodes.dart';
import 'notification_screen.dart';

class NotSubcategoryScreen extends StatefulWidget {
  static const routeName = '/not-subcategory-screen';
  @override
  _NotSubcategoryScreenState createState() => _NotSubcategoryScreenState();
}

class _NotSubcategoryScreenState extends State<NotSubcategoryScreen> {
  bool _isLoading = true;
  var subcategoryData;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      final subcategoryId = routeArgs['subcategoryId'];

      if(routeArgs['fromScreen'] == "ClickLink") {
        Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(routeArgs['notificationId'], "1" );
      } else {
        if(routeArgs['notificationStatus'] == "0"){
          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(routeArgs['notificationId'], "1" ).then((value){
          });
        }
      }

      Provider.of<NotificationItemsList>(context,listen: false).fetchCategoryItems(subcategoryId).then((_) {
        subcategoryData = Provider.of<NotificationItemsList>(context,listen: false);
        if (subcategoryData.catitems.length <= 0) {
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }); // only create the future once.
    });
  }

  @override
  didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });


      Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglist();
      Provider.of<BrandItemsList>(context,listen: false).GetRestaurant().then((value) async {
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    bool _isNotification = false;
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    if(routeArgs['fromScreen'] == "ClickLink") {
      _isNotification = false;
    } else {
      _isNotification = true;
    }

    return _isNotification ?
    WillPopScope(
      onWillPop: (){
        if(routeArgs['fromScreen'] == "ClickLink"){
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        }
        else {
          Navigator.of(context).pushReplacementNamed(
              NotificationScreen.routeName);
        }
        //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        return Future.value(false);
      },
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
          elevation: (IConstants.isEnterprise)?0:1,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color:ColorCodes.menuColor),
              onPressed: () {
                if(routeArgs['fromScreen'] == "ClickLink"){
                  Navigator.of(context).pop();
                }
                else {
                  Navigator.of(context).pushReplacementNamed(
                      NotificationScreen.routeName);
                }
                //Navigator.of(context).pop();
               // Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
              }
          ),
          title: Text(
            S.of(context).categories, // "Categories",
            style: TextStyle(color: ColorCodes.menuColor),

          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  SearchitemScreen.routeName,
                );
              },
              child: Icon(
                Icons.search,
                size: 30.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),

        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :
        GridView.builder(
          shrinkWrap: true,
          controller: new ScrollController(
              keepScrollOffset: false
          ),
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          itemCount: subcategoryData.catitems.length,
          itemBuilder: (BuildContext context, int index) {
            return  Card(
              color: subcategoryData
                    .catitems[index].featuredCategoryBColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),

                   ),
              ),
              elevation: 4,
              margin: EdgeInsets.all(5),
              child: CategoriesItem(
                  "NotSubcategoryScreen", "Offers", "", "", "", index,
                  subcategoryData.catitems[index].imageUrl, subcategoryData.catitems[index].catBanner),
            // backgroundColor: Colors.transparent
            );
          },
/*            itemBuilder: (ctx, i) => ChangeNotifierProvider.value (
                value: subcategoryData.catitems[i],
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.all(5),
                  child: CategoriesItem("SubcategoryScreen", "Offers", i),
                ),
              ),*/
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
        ),
      ),
    )
        :
    WillPopScope(
      onWillPop: () { // this is the block you need
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     '/home-screen', (Route<dynamic> route) => false);
        if(routeArgs['fromScreen'] == "ClickLink"){
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        }
        else {
          Navigator.of(context).pushReplacementNamed(
              NotificationScreen.routeName);
        }
        //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        return Future.value(false);
      },
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
            title: Text(
              S.of(context).categories,//"Categories",
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    SearchitemScreen.routeName,
                  );
                },
                child: Icon(
                  Icons.search,
                  size: 30.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),

          body: _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              :
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            controller: new ScrollController(
                keepScrollOffset: false
            ),
            itemCount: subcategoryData.catitems.length,
            itemBuilder: (BuildContext context, int index) {
              return  Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.all(5),
                child: CategoriesItem("NotSubcategoryScreen", "Offers", "", "", "", index, subcategoryData.catitems[index].imageUrl,subcategoryData.catitems[index].catBanner),
              );
            },
/*            itemBuilder: (ctx, i) => ChangeNotifierProvider.value (
              value: subcategoryData.catitems[i],
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.all(5),
                child: CategoriesItem("SubcategoryScreen", "Offers", i),
              ),
            ),*/
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
          ),
      ),
    );
  }
}