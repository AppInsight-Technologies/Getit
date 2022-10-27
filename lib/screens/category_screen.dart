import 'dart:io';
import 'package:flutter/material.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../data/calculations.dart';
import '../../models/VxModels/VxStore.dart';
import '../../screens/cart_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/wishlist_screen.dart';
import '../../widgets/badge.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/newmodle/home_page_modle.dart';
import '../generated/l10n.dart';
import '../screens/searchitem_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../providers/categoryitems.dart';
import '../widgets/expandable_categories.dart';
import '../constants/IConstants.dart';
import 'customer_support_screen.dart';
import 'myorder_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category-screen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isWeb = false;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool checkskip = false;
  bool iphonex = false;
  var name = "", email = "", photourl = "", phone = "";
  GroceStore store = VxState.store;
 // HomePageData homedata;
  @override
  void initState() {
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
       /* if (PrefUtils.prefs.getString('FirstName') != null) {
          if (PrefUtils.prefs.getString('LastName') != null) {
            name = PrefUtils.prefs.getString('FirstName') +
                " " +
                PrefUtils.prefs.getString('LastName');
          } else {
            name = PrefUtils.prefs.getString('FirstName');
          }
        } else {
          name = "";
        }*/
        name = store.userData.username;
        if (PrefUtils.prefs.getString('Email') != null) {
          email = PrefUtils.prefs.getString('Email');
        } else {
          email = "";
        }

        if (PrefUtils.prefs.getString('mobile') != null) {
          phone = PrefUtils.prefs.getString('mobile');
        } else {
          phone = "";
        }
        if (!PrefUtils.prefs.containsKey("apikey")) {
          checkskip = true;
        } else {
          checkskip = false;
        }

      });
    });
    super.initState();
  }


  void launchWhatsapp({@required number,@required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }


  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid = queryData.size.width;
    maxwid = wid * 0.90;

    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          height: 53,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                    Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      // minRadius: 50,
                      // maxRadius: 50,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(Images.homeImg,
                        //  color:ColorCodes.greenColor,
                        color:ColorCodes.blackColor,

                        width: 32,
                        height: 23,
                      ),

                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                        S.of(context).home,
                        // "Home",
                        style: TextStyle(
                          color:ColorCodes.blackColor,
                          //  color: ColorCodes.greenColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.0,)),
                  ],
                ),
              ),
              Spacer(),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context,value,widget){
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.categoriesImg,
                            color: ColorCodes.redColor ,
                            width: 32,
                            height: 22,),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                            S.of(context).categories,//"Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: ColorCodes.redColor, fontSize: 11.0)),
                      ],
                    );
                  }),
              if(Features.isWallet)
                Spacer(),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context, value, widget){
                    return GestureDetector(
                      onTap: () {
                        if (value != S.of(context).not_available_location)
                          Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                            "after_login": ""
                          });
                      },
                      child: VxBuilder(
                        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                        builder: (context,  box, index) {
                          return Consumer<CartCalculations>(
                            builder: (_, cart, ch) => Badge(
                              child: ch,
                              color: ColorCodes.darkgreen,
                              value: CartCalculations.itemCount.toString(),
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                CircleAvatar(
                                  radius: 13.0,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    Images.header_cart,
                                    color: ColorCodes.blackColor,
                                    width: 27,
                                    height: 17,),
                                ),
                                SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                    S.of(context).my_bag,//"Membership",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: ColorCodes.blackColor, fontSize: 11.0)),
                              ],
                            ),);
                        },mutations: {SetCartItem},
                      ),
                    );
                  }),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget){
                      return GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
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
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                Images.bottomnavMembershipImg,
                                color: ColorCodes.blackColor,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S.of(context).membership,//"Membership",
                                style: TextStyle(
                                    color: ColorCodes.blackColor, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),


              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value ,widget){
                      return GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
                            !PrefUtils.prefs.containsKey("apikey")
                                ? Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                                arguments: {
                                  "prev": "signupSelectionScreen",
                                }
                            )
                                :  Navigator.of(context)
                                .pushNamed(ProfileScreen.routeName);
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                Images.Person,
                                color: ColorCodes.blackColor,
                                width: 17,
                                height: 17,),
                            ),

                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                                S.of(context).profile,//"My Orders",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: ColorCodes.blackColor, fontSize: 11.0)),
                          ],
                        ),
                      );
                    }),
              if(Features.isShoppingList)
                Spacer(),
              if(Features.isShoppingList)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value ,widget){
                      return GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
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
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(Images.shoppinglistsImg ,
                                color: ColorCodes.blackColor,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S.of(context).shopping_list,//"Shopping list",
                                style: TextStyle(
                                    color: ColorCodes.blackColor, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),

              SizedBox(width: 20),
            ],
          ),
        )
      );
    }

    Widget _appBar() {
      return AppBar(
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        title: Text( S.of(context).all_categories,
          //"All Categories",
          style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    ColorCodes.accentColor,
                    ColorCodes.primaryColor
              ])),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                WishListScreen.routeName,
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 11, left: 10, right: 10, bottom: 12),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                /*color: Theme.of(context).buttonColor*/),
              child: /*Icon(
                          Icons.shopping_cart_outlined,
                          size: IConstants.isEnterprise ? 24: 21,
                          color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                        ),*/
              Image.asset(
                Images.wish,
                height: 23,
                width: 23,
                color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: IConstants.currentdeliverylocation,
              builder: (context, value, widget){
                return VxBuilder(
                  // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                  builder: (context,  box, index) {
                    // if (CartCalculations.itemCount<=0)
                    //   return GestureDetector(
                    //     onTap: () {
                    //       if (value != S.of(context).not_available_location)
                    //       Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                    //         "after_login": ""
                    //       });
                    //     },
                    //     child: Container(
                    //       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                    //       width: 28,
                    //       height: 28,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(100),
                    //         /* color: Theme.of(context).buttonColor*/),
                    //       child: /*Icon(
                    //       Icons.shopping_cart_outlined,
                    //       size: IConstants.isEnterprise ? 24: 21,
                    //       color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                    //     ),*/
                    //       Image.asset(
                    //         Images.header_cart,
                    //         height: 28,
                    //         width: 28,
                    //         color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                    //       ),
                    //     ),
                    //   );
                    return Consumer<CartCalculations>(
                      builder: (_, cart, ch) => Badge(
                        child: ch,
                        color: ColorCodes.darkgreen,
                        value: CartCalculations.itemCount.toString(),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
                            Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                              "after_login": ""
                            });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:18, bottom: 5, left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            /*color: Theme.of(context).buttonColor*/),
                          child: /*Icon(
                          Icons.shopping_cart_outlined,
                          size: IConstants.isEnterprise ? 24: 21,
                          color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                        ),*/
                          Image.asset(
                            Images.header_cart,
                            height: 23,
                            width: 23,
                            color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                          ),
                        ),
                      ),);
                  },mutations: {SetCartItem},
                );
              }),
          SizedBox(width: 5),
        ],
      );
    }

    Widget _webbody() {
     // final categoriesData = Provider.of<CategoriesItemsList>(context,listen: false);
      return  VxBuilder(
          mutations: {HomeScreenController},
          builder: (ctx,store,VxStatus state)
      {
        final homedata = (store as GroceStore).homescreen;
        return Column(
          children: <Widget>[
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false, false),
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Container(
                  padding: EdgeInsets.all(10),
                  color: ColorCodes.lightGreyWebColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S
                          .of(context)
                          .all_categories,
                        // ' All Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if(Features.isFilter)
                        Row(
                          children: [
                            Text(S
                                .of(context)
                                .filter,
                                // "Filter",
                                style: TextStyle(
                                    color: ColorCodes.mediumBlackColor,
                                    fontSize: 14.0)),
                            Container(
                                height: 15.0,
                                child: VerticalDivider(
                                    color: ColorCodes.greyColor)),
                            Text(S
                                .of(context)
                                .sort,
                                //"Sort",
                                style: TextStyle(
                                    color: ColorCodes.mediumBlackColor,
                                    fontSize: 14.0)),
                            SizedBox(
                              width: 10.0,
                            ),
                            Image.asset(
                              Images.sortImg,
                              color: ColorCodes.mediumBlackColor,
                              width: 22,
                              height: 16.0,
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                    ],
                  )),
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Divider(),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        constraints: (_isWeb &&
                            !ResponsiveLayout.isSmallScreen(context))
                            ? BoxConstraints(maxWidth: maxwid)
                            : null,
                        child: Column(
                          children: [
                           /* if (categoriesData.items.length > 0)
                              SizedBox(
                                height: 10,
                              ),*/
                           /* if (categoriesData.items.length >
                                0) */
                              ExpansionCategory(homedata),
                            SizedBox(
                              height: 20,
                            ),

                          ],
                        ),
                      ),
                      if (_isWeb)
                        Footer(
                          address: PrefUtils.prefs.getString(
                              "restaurant_address"),
                        ),
                    ],
                  )
              ),
            ),
          ],
        );
      });
    }

    return ResponsiveLayout.isSmallScreen(context)
        ? Scaffold(
            appBar: ResponsiveLayout.isSmallScreen(context) ? _appBar() : SizedBox.shrink(),
            body: _webbody(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(

                width: MediaQuery.of(context).size.width,

                child: bottomNavigationbar()),
          )
        : Scaffold(
            body: _webbody(),
          );
  }
}
