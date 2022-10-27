import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../controller/mutations/login.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../models/newmodle/user.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../screens/edit_screen.dart';
import '../../screens/profile_screen.dart';
import '../../widgets/badge.dart';
import '../../widgets/components/item_component.dart';
import '../../widgets/simmers/home_screen_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/in_app_update_review.dart';
import '../blocs/cart_item_bloc.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../widgets/websiteSmallbanner.dart';
import '../screens/searchitem_screen.dart';
import '../screens/customer_support_screen.dart';
import '../services/firebaseAnaliticsService.dart';
import '../blocs/category_bloc.dart';
import '../blocs/sliderbannerBloc.dart';
import '../models/brandFiledModel.dart';
import '../models/brandfieldsModel.dart';
import '../models/sellingitemsfields.dart';
import '../providers/cartItems.dart';
import '../screens/bloc.dart';
import '../widgets/CarouselSliderimageWidget.dart';
import '../widgets/simmers/singel_item_of_list_shimmer.dart';


import '../screens/MultipleImagePicker_screen.dart';
import '../screens/cart_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/categoryOne.dart';
import '../widgets/categoryThree.dart';
import '../widgets/expandable_categories.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/websiteSlider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../widgets/items.dart';
import '../widgets/app_drawer.dart';
import '../widgets/brands_items.dart';
import '../widgets/advertise1_items.dart';
import '../constants/features.dart';
import '../providers/featuredCategory.dart';
import '../widgets/floatbuttonbadge.dart';
import '../providers/carouselitems.dart';
import '../providers/branditems.dart';
import '../providers/categoryitems.dart';
import '../providers/advertise1items.dart';
import '../providers/sellingitems.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../assets/images.dart';
import '../screens/map_screen.dart';
import '../screens/sellingitem_screen.dart';
import '../screens/category_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/wallet_screen.dart';
import '../constants/IConstants.dart';
import '../screens/membership_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../assets/ColorCodes.dart';
import '../widgets/categoryTwo.dart';
import '../data/calculations.dart';
import '../data/hiveDB.dart';
import '../utils/prefUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'myorder_screen.dart';

enum SingingCharacter { english, arabic }

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Box<Product> productBox;
  var _address = "";
  bool iphonex = false;
  bool _isDelivering = true;

  bool _isinternet = true;
  bool checkskip = false;

  bool _isInit = true;
  HomeDisplayBloc _bloc;
  var _carauselslider = false;

  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool _isRestaurant = false;

  GroceStore store = VxState.store;
  var name = "", email = "", photourl = "", phone = "";

  // HomePageData homedata;
  Future<void> _refreshProducts(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        _isinternet = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _isinternet = true;
      });
    } else {
      Fluttertoast.showToast(msg: "No internet connection!!!", fontSize: MediaQuery.of(context).textScaleFactor *13,);
      setState(() {
        _isinternet = false;
      });
    }
   // await Provider.of<Advertise1ItemsList>(context,listen: false).fetchMainBanner1();
    blocinit();
    auth.getuserProfile(onerror: (){
      HomeScreenController(branch: PrefUtils.prefs.getString("branch"),user:PrefUtils.prefs.getString("tokenid"));
    },onsucsess: (value){
      // /  print("resp:1 ${(value.toJson())}");
      HomeScreenController(branch: value.branch,user:value.id);
    });

  }

  @override
  void initState() {

    fas.setScreenName("Home");
   /* if(PrefUtils.prefs.getString("userID")!=null)
      if(PrefUtils.prefs.getString("userID").isEmpty)
      {
        var uuid = Uuid();
        uuid.v4();
        PrefUtils.prefs.setString("tokenid", uuid.v4());

      }*/
    inappreview.initialize();
    // Auth _auth;
    cartcontroller.fetch(onload: (onload){

    });

    Future.delayed(Duration.zero, () async {

 /*     try {
        if (Platform.isIOS) {
          setState(() {
            Vx.isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        } else {
          setState(() {
            Vx.isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          Vx.isWeb = true;

         // PrefUtils.prefs.setString("tokenid", uuid.v4());
        });

      }*/
      if(!Vx.isWeb) {
        debugPrint("PrefUtils.prefs.getString" + PrefUtils.prefs.getString("tokenid").toString());
        HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
            PrefUtils.prefs.getString("tokenid"),
            branch: PrefUtils.prefs.getString("branch"),
            rows: "0");
      }else{
        var uuid = Uuid();
        uuid.v4();
        PrefUtils.prefs.setString("ftokenid", uuid.v4());
        auth.getuserProfile(onerror: (){
          HomeScreenController(branch: PrefUtils.prefs.getString("branch"),user:PrefUtils.prefs.getString("tokenid"));
        },onsucsess: (value){
          // /  print("resp:1 ${(value.toJson())}");
          HomeScreenController(branch: value.branch,user:value.id);
        });
      }
      //(Vx.isWeb)?null:await Permission.camera.request();
      setState(() {
        /*if (PrefUtils.prefs.getString('FirstName') != null) {
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

      });
     // ProductController productController = ProductController();
     // await productController.getCategory();

      await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
        setState(() {
          _isRestaurant = true;
        });
        if (!PrefUtils.prefs.containsKey("deliverylocation")) {
          PrefUtils.prefs.setString("deliverylocation", PrefUtils.prefs.getString("restaurant_location"));
          PrefUtils.prefs.setString("latitude", PrefUtils.prefs.getString("restaurant_lat"));
          PrefUtils.prefs.setString("longitude", PrefUtils.prefs.getString("restaurant_long"));
        }

        if(IConstants.holyday =="1"){
          ShowpopupforHoliday();
          print("holidya...");
        //  HolidayNote();
        }
      });
      //await Provider.of<BrandItemsList>(context, listen: false).fetchDeliveryMode();
     // await Provider.of<CartItems>(context, listen: false).fetchCartItems();

      PrefUtils.prefs.setString("addressbook", "");
      setState(() {
        if(!PrefUtils.prefs.containsKey("apikey")) {
          checkskip = true;
        } else {
          checkskip = false;
        }
      });

     /* if (!checkskip) {
        await Provider.of<BrandItemsList>(context,listen: false).userDetails();
      }*/
      _bloc = HomeDisplayBloc();
      //await Provider.of<Advertise1ItemsList>(context,listen: false).fetchMainBanner1();
      blocinit();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        _apiCalls();
        setState(() {
          _isinternet = true;
        });
        // I am connected to a mobile network.
      } else {
        Fluttertoast.showToast(msg: "No internet connection!!!", fontSize: MediaQuery.of(context).textScaleFactor *13,);
        setState(() {
          _isinternet = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // bloc.dispose();
  }

  _apiCalls() async {
   // homedata = (VxState.store as GroceStore).homescreen;
  }

  Future<void> paymentStatus(String orderId) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getOrderStatus + orderId;
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs.getString('branch'),
          }
      );
      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "yes") {
        PrefUtils.prefs.remove("orderId");
      } else {
        await _cancelOrder();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _cancelOrder() async {
    try {
      final response = await http.post(Api.cancelOrder, body: {
        "id": PrefUtils.prefs.getString('orderId'),
        "note": "Payment cancelled by user",
        "branch": PrefUtils.prefs.getString('branch'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == "200") {
        PrefUtils.prefs.remove("orderId");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Something went wrong!!!", fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }

  Widget _sliderShimmer() {
    return Vx.isWeb ?
    SizedBox.shrink()
        :
    Shimmer.fromColors(
        baseColor: /*Color(0xffd3d3d3)*/Colors.grey[200],
        highlightColor: ColorCodes.lightGreyWebColor,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              height: 150.0,
              width: MediaQuery.of(context).size.width - 20.0,
              color: Colors.white,
            ),
          ],
        ));
  }

  Widget _bannerMain1(HomePageData homedata){
    // final banner1Data = Provider.of<Advertise1ItemsList>(context,listen: false);
   // debugPrint('slider....'+homedata.data.mainslideradd.length.toString());
    if(homedata.data.mainslideradd!=null)
      if (homedata.data.mainslideradd.length >= 0) {
        _carauselslider = true;
      } else {
        _carauselslider = false;
      }

    return _carauselslider ?Row(
      children: <Widget>[
        Expanded(
            child: SizedBox(
             // height:ResponsiveLayout.isSmallScreen(context)? MediaQuery.of(context).size.height*0.28:150.0,
              child: new ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.only(right: 10),
                itemCount: homedata.data.mainslideradd.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    Advertise1Items(
                      homedata.data.mainslideradd[i],
                      "home",
                    ),
                  ],
                ),
              ),
            )),
      ],
    ):SizedBox.shrink();
  }

  Widget _advertiseCategoryOne(homedata) {
    if(Features.isAdsCategoryOne)if(MediaQuery.of(context).size.width <= 600)
      return (homedata.data.featuredCategories1.length > 0) ?Row(
        children: <Widget>[
          Expanded(
              child: SizedBox(
                height: 135.0,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0.0),
                  itemCount: homedata.data.featuredCategories1.length,
                  itemBuilder: (_, i) => Column(
                    children: [Advertise1Items(
                      homedata.data.featuredCategories1[i],
                      "top",),],
                  ),
                ),
              )),
        ],
      ):SizedBox.shrink(); else return SizedBox.shrink();
  }
//TODO Feautured Item Not Proper
  Widget featuredItem(homedata) {
    if(Features.isSellingItems)  return  Container(
      padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
      color: Color(0xFFFFE8E8).withOpacity(0.7),
      child: Container(
       // padding: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 20,right: 35):null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data.featuredByCart.label,
                  style: TextStyle(
                      fontSize:ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(SellingitemScreen.routeName, arguments: {
                        'seeallpress': "featured",
                        'title':homedata.data.featuredByCart.label
                      });
                    },
                    child: Text(
                     S.of(context).view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            new Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: ResponsiveLayout.isSmallScreen(context) ? (Features.isSubscription)?350:310 : ResponsiveLayout.isMediumScreen(context) ? (Features.isSubscription)?330:360 : (Features.isSubscription)?380:350,

                    child: new ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: homedata.data.featuredByCart.data.length,
                      itemBuilder: (_, i)
                      {
                             return   Column(
                                  children: [
                                    Items(
                                      "home_screen",
                                      homedata.data.featuredByCart.data[i].id,
                                      homedata.data.featuredByCart.data[i].itemName,
                                      homedata.data.featuredByCart.data[i].itemFeaturedImage,
                                      homedata.data.featuredByCart.data[i].brand,
                                      homedata.data.featuredByCart.data[i].vegType,
                                      homedata.data.featuredByCart.data[i].type,
                                      homedata.data.featuredByCart.data[i].eligibleForExpress,
                                      homedata.data.featuredByCart.data[i].delivery,
                                      homedata.data.featuredByCart.data[i].duration,
                                      homedata.data.featuredByCart.data[i].deliveryDuration.durationType,
                                      homedata.data.featuredByCart.data[i].deliveryDuration.note,
                                      homedata.data.featuredByCart.data[i].eligibleForSubscription,
                                      homedata.data.featuredByCart.data[i].paymentMode,
                                      homedata.data.featuredByCart.data[i].subscriptionSlot[0].cronTime,
                                      homedata.data.featuredByCart.data[i].subscriptionSlot[0].deliveryTime,

                                      //sellingitemData.items[i].brand,
                                    ),
                                  ],
                                );
                              },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ) ;
  }

  Widget _featuredItemweb(HomePageData homedata) {
    // final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    homedata.data.featuredByCart.data.forEach((element) {
      print("Data:" +element.toJson().toString());
    });
    if(Features.isSellingItems)  return
      Container(
        // padding: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 20,right: 20):null,
        padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
        color:/* Color(0xFFFFE8E8).withOpacity(0.7)*/ColorCodes.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data.featuredByCart.label,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(SellingitemScreen.routeName, arguments: {
                        'seeallpress': "featured",
                        'title': homedata.data.featuredByCart.label,
                      });
                    },
                    child: Text(
                      S.of(context).view_all,//'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Container(
              //  padding: EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:null,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:null ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: ResponsiveLayout.isSmallScreen(context) ? (Features.isSubscription)?365:316 : ResponsiveLayout.isMediumScreen(context) ? (Features.isSubscription)?330:360 : (Features.isSubscription)?388:350,

                        child: new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: homedata.data.featuredByCart.data.length,
                            itemBuilder: (_, i)
                            {
                              return  Column(
                                children: [
                                  Itemsv2(
                                    "home_screen",
                                    homedata.data.featuredByCart.data[i],
                                    homedata.data.customerDetails.length>0?homedata.data.customerDetails.first:UserData(membership: "0"),
                                    // homedata.data.featuredByCart.data[i].itemFeaturedImage,
                                    // homedata.data.featuredByCart.data[i].brand,
                                    // homedata.data.featuredByCart.data[i].vegType,
                                    // homedata.data.featuredByCart.data[i].type,
                                    // homedata.data.featuredByCart
                                    //     .data[i].eligibleForExpress,
                                    // homedata.data.featuredByCart.data[i].delivery,
                                    // homedata.data.featuredByCart.data[i].duration,
                                    // homedata.data.featuredByCart.data[i].deliveryDuration.durationType,
                                    // homedata.data.featuredByCart.data[i].deliveryDuration.note,
                                    // homedata.data.featuredByCart.data[i].eligibleForSubscription,
                                    // homedata.data.featuredByCart.data[i].paymentMode,
                                    // homedata.data.featuredByCart.data[i].subscriptionSlot[0].cronTime,
                                    // homedata.data.featuredByCart.data[i].subscriptionSlot[0].deliveryTime,

                                    //sellingitemData.items[i].brand,
                                  ),
                                ],
                              );
                            }
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
//continue
  Widget _featuredItemMobile(HomePageData homedata) {
    // final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    if(Features.isSellingItems)  return
      Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                homedata.data.featuredByCart.label,
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?17.0:24.0,
                    fontWeight: FontWeight.bold,
                    color: ColorCodes.blackColor),
              ),
            ),
            SizedBox(height: 2.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ? (Features.isSubscription)?210:210 : ResponsiveLayout.isMediumScreen(context) ? (Features.isSubscription)?340:360 : (Features.isSubscription)?388:360,

                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data.featuredByCart.data.length,
                  itemBuilder: (_, i)
                  {
                    return Column(
                      children: [
                        Itemsv2(
                          "home_screen",
                            homedata.data.featuredByCart.data[i],
                          homedata.data.customerDetails.length>0?homedata.data.customerDetails.first:UserData(membership: "0"),
                          //sellingitemData.items[i].brand,
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
  }

  Widget _featuredAdsOne(HomePageData homedata) {
   /* return StreamBuilder(
      stream: bloc.featuredAdsOne,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/

      /*  if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {*/
      if(homedata.data.featureditems1.length > 0) {
        double deviceWidth = MediaQuery
            .of(context)
            .size
            .width;
        int widgetsInRow = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
        if (deviceWidth > 1200) {
          widgetsInRow = 2;
        } else if (deviceWidth < 768) {
          widgetsInRow = 1;
        }
        double aspectRatio = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            400 :
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            70;
        return GridView.builder(

          //scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widgetsInRow,
            crossAxisSpacing: 3,
            childAspectRatio: aspectRatio,

          ),
          shrinkWrap: true,
          controller: new ScrollController(keepScrollOffset: false),
          itemCount: homedata.data.featureditems1.length,
          itemBuilder: (_, i) =>
              Advertise1Items(
                homedata.data.featureditems1[i],
                "horizontal",
              ),
        );
      }else{
        return /*_sliderShimmer()*/SizedBox.shrink();
      }

         /* }
          else return SizedBox.shrink();
        }else if (snapshot.hasError) {
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else if(!snapshot.hasData) {
          return SizedBox.shrink();
        }*/

     /* },
    );*/


  }

  Widget _featuredAdsTwo(HomePageData homedata) {

    if(Features.isAdsCategoryTwo)
      /*return StreamBuilder(
      stream: bloc.featuredAdsTwo,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
       /* if (snapshot.hasData) {*/
          if(homedata.data.featuredCategories2.length > 0) {

            double deviceWidth = MediaQuery
                .of(context)
                .size
                .width;
            int widgetsInRow = (Vx.isWeb &&
                !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
            if (deviceWidth > 1200) {
              widgetsInRow = 2;
            } else if (deviceWidth < 768) {
              widgetsInRow = 1;
            }
            double aspectRatio = (Vx.isWeb &&
                !ResponsiveLayout.isSmallScreen(context)) ?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
                400 :
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
                210;
            return GridView.builder(


              gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  crossAxisSpacing: 4,
                  childAspectRatio: aspectRatio

              ),
              shrinkWrap: true,
              controller: new ScrollController(keepScrollOffset: false),
              itemCount: homedata.data.featuredCategories2.length,
              padding: EdgeInsets.zero,
              itemBuilder: (_, i) =>
                  Column(
                    children: [
                      Advertise1Items(
                        homedata.data.featuredCategories2[i],
                        "horizontal",
                      ),
                    ],
                  ),
            );
          }
          else /*return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else {
        }
        Platform platform;*/
        return /*_sliderShimmer()*/SizedBox.shrink();
      /*},
    );*/


 }

  Widget _categoryThree(HomePageData homedata) {
    if(Features.isCategoryThree) return /*isCategoryThree
        ? */CategoryThree(homedata);else
       /* : _isCategoryThreeShimmer
        ? _horizontalshimmerslider()*/
      return SizedBox.shrink();
  }

  Widget _featuredAdsVertical(HomePageData homedata) {
    if(Features.isVerticalSlider)
      if(MediaQuery.of(context).size.width <= 600)
     /* return StreamBuilder(
      stream: bloc.featuredAdsThree,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
       /* if (snapshot.hasData) {*/
          if(homedata.data.verticalSlider.length > 0)
            return new SizedBox(
              height: 290.0,
              child: new ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: homedata.data.verticalSlider.length,
                itemBuilder: (_, i) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Advertise1Items(
                      homedata.data.verticalSlider[i],
                      "bottom"),
                ),
              ),
            );
          else
            return SizedBox.shrink();
       else /*if (snapshot.hasError) {
          //return _sliderShimmer();
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else {
          return _sliderShimmer();
        }
        Platform platform;*/
        return _sliderShimmer();
     /* },
    );*/else SizedBox.shrink();

    /*return _isFeaturedAdsVertical
      ? SizedBox(
          height: 290.0,
          child: new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: advertise1Data.item3.length,
            itemBuilder: (_, i) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Advertise1Items(
                  advertise1Data.item3[i].imageUrl,
                  advertise1Data.item3[i].bannerFor,
                  advertise1Data.item3[i].bannerData,
                  advertise1Data.item3[i].clickLink,
                  advertise1Data.item3[i].displayFor,
                  "bottom"),
            ),
          ),
        )
      : _isFeaturedAdsVerticalShimmer
          ? _sliderShimmer()
          : SizedBox.shrink();*/
  }

  Widget _featuredAdsThree(HomePageData homedata) {
    if(Features.isFeatureAdsThree)
      /*return StreamBuilder(
      stream: bloc.featuredAdsFour,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
        /*if (snapshot.hasData) {*/
          if(homedata.data.featuredCategories3.length > 0) {
            double deviceWidth = MediaQuery
                .of(context)
                .size
                .width;
            int widgetsInRow = (Vx.isWeb &&
                !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
            if (deviceWidth > 1200) {
              widgetsInRow = 2;
            } else if (deviceWidth < 768) {
              widgetsInRow = 1;
            }
            double aspectRatio = (Vx.isWeb &&
                !ResponsiveLayout.isSmallScreen(context)) ?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
                400 :
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
                170;
            return GridView.builder(

              shrinkWrap: true,
              controller: new ScrollController(keepScrollOffset: false),
              gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  crossAxisSpacing: 4,
                  childAspectRatio: aspectRatio

              ),
              itemCount: homedata.data.featuredCategories3.length,
              padding: EdgeInsets.zero,
              itemBuilder: (_, i) =>
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Column(
                      children: [
                        Advertise1Items(
                          homedata.data.featuredCategories3[i],
                          "horizontal",
                        ),
                      ],
                    ),
                  ),
            );
          }
          /*else return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else {
        }
        Platform platform;*/
        return /*_sliderShimmer()*/SizedBox.shrink();
     /* },
    );*/

  }

  Widget _category(HomePageData homedata) {
    if(Features.isCategory)  return Container(
      padding: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 20,right: 20):null,
      child: Column(
        children: [
          /*(IConstants.isEnterprise)?*/Container(
            margin: EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 3.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                S.of(context).explore_by_cat,//"Explore by Category",
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                    color: /*Theme.of(context).primaryColor*/ColorCodes.blackColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )/*:SizedBox.shrink()*/,
          SizedBox(
            height: 5,
          ),
          //TODO:Expandable Cat Bloc
          ExpansionCategory(homedata),
        ],
      ),
    );
  }

  Widget _categoryweb(HomePageData homedata) {
    return  Container(
      padding:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 18,right: 18):null,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 3.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                S.of(context).explore_by_cat,//"Explore by Category",
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ExpansionCategory(homedata),
        ],
      ),
    );
  }

  Widget _brands(HomePageData homedata) {
    if(Features.isBrands)
      // return StreamBuilder(
      //     stream: bloc.brandfiledBloc,
      //     builder: (context, AsyncSnapshot<List<BrandsFieldModel>> snapshot) {

          //  if(snapshot.hasData) {
              if (homedata.data.allBrands.length > 0)
                return Container(
                  color: /*Color(0xffE1EFFC)*/Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                  child: Container(
                    padding:
                        (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                            ? EdgeInsets.only(left: 20, right: 20)
                            : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).shop_by_brands,//"Shop by Brands",
                          style: TextStyle(
                              fontSize: ResponsiveLayout.isSmallScreen(context)
                                  ? 18.0
                                  : 24.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          height: 70,
                          child: new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: homedata.data.allBrands.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                BrandsItems(
                                  homedata.data.allBrands[i],
                                  i,
                                ),
                              ],
                            ),
                          ),
                        ),
                        //SizedBox(height: 15.0,),
                      ],
                    ),
                  ),
                );
              else  return SizedBox.shrink();
            // } else if(snapshot.hasError)return SizedBox.shrink();
            // else{
            //   return _sliderShimmer();
            // }
          // });
  }

  Widget _discountItem(HomePageData homedata) {
    // final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
  debugPrint("length...."+homedata.data.discountByCart.data.length.toString());

  if(homedata.data.discountByCart.data.length >0 ){
     return Container(
      //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
      padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
      color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              Text(
                homedata.data.discountByCart.label,
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(SellingitemScreen.routeName, arguments: {
                      'seeallpress': "discount",
                      'title': homedata.data.discountByCart.label,
                    });
                  },
                  child: Text(
                    S.of(context).view_all,//'View All',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          SizedBox(
              height: ResponsiveLayout.isSmallScreen(context) ? (Features.isSubscription)?365:316 : ResponsiveLayout.isMediumScreen(context) ? (Features.isSubscription)?340:360 : (Features.isSubscription)?388:360,
              child: new ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: homedata.data.discountByCart.data.length,
                itemBuilder: (_, i)
                {
                  return Column(
                    children: [
                      Itemsv2(
                        "Discount",
                        homedata.data.discountByCart.data[i],
                        homedata.data.customerDetails.length>0?homedata.data.customerDetails.first:UserData(membership: "0"),
                      ),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }else{
    return SizedBox.shrink();
  }

  }

  Widget _offersItem(HomePageData homedata) {
  //  final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    debugPrint("lengthoff..."+homedata.data.offerByCart.data.length.toString());
  /* return  StreamBuilder<List<SellingItemsFields>>(
     stream: bloc.offerItemStream,
     builder: (context,  snapshot){*/

       if(homedata.data.offerByCart.data.length > 0 ){
         return  Container(
           //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
           padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
           color:/* Color(0xFFFFE8E8).withOpacity(0.7)*/Colors.white,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               new Row(
                 children: <Widget>[
                   SizedBox(
                     width: 10.0,
                   ),
                   Text(
                     homedata.data.offerByCart.label,
                     style: TextStyle(
                         fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                         color: Theme.of(context).primaryColor,
                         fontWeight: FontWeight.bold),
                   ),
                   Spacer(),
                   MouseRegion(
                     cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                       onTap: () {
                         Navigator.of(context)
                             .pushNamed(SellingitemScreen.routeName, arguments: {
                           'seeallpress': "offers",
                           'title': homedata.data.offerByCart.label,
                         });
                       },
                       child: Text(
                         S.of(context).view_all,//'View All',
                         textAlign: TextAlign.center,
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 14,
                             color: Theme.of(context).primaryColor),
                       ),
                     ),
                   ),
                   SizedBox(
                     width: 10,
                   ),
                 ],
               ),
               SizedBox(height: 8.0),
               SizedBox(
                   height: ResponsiveLayout.isSmallScreen(context) ? (Features.isSubscription)?365:316 : ResponsiveLayout.isMediumScreen(context) ? (Features.isSubscription)?340:360 : (Features.isSubscription)?388:360,
                   child: new ListView.builder(
                     shrinkWrap: true,
                     scrollDirection: Axis.horizontal,
                     itemCount: homedata.data.offerByCart.data.length,
                     itemBuilder: (_, i)
                     {
                       return Column(
                         children: [
                           Itemsv2(
                             "offers",
                             homedata.data.offerByCart.data[i],
                            // homedata.data.customerDetails[0],
                             homedata.data.customerDetails.length>0?homedata.data.customerDetails.first:UserData(membership: "0"),
                           ),
                         ],
                       );
                     },
                   )),
             ],
           ),
         );
       }
       /*else if(snapshot.hasError){
         return SizedBox.shrink();
       }else {
         return _horizontalshimmerslider();
       }*/
    else{
         return SizedBox.shrink();
       }

     /*},

   );*/
  }

 Widget _footer(HomePageData homedata) {
    /*return StreamBuilder(
      stream: bloc.footer,

      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
        if (homedata.data.footerImage.length > 0) {
          return new ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: homedata.data.footerImage.length,
            itemBuilder: (_, i) => Container(
              child: CachedNetworkImage(imageUrl: homedata.data.footerImage[i].bannerImage, fit: BoxFit.fill, width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
                errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
     /* },
    );*/

  }

  Widget _body() {
    return  VxBuilder(
      mutations: {HomeScreenController},
      builder: (ctx,store,VxStatus state){

     final homedata = (store as GroceStore).homescreen;
     if(homedata.data!=null)
        return SingleChildScrollView(
          child: _isinternet
              ?
             ValueListenableBuilder(
                 valueListenable: IConstants.currentdeliverylocation,
                 builder: (context,value,widget){
                   return value == S.of(context).not_available_location ?
                   SingleChildScrollView(
                     child: Center(
                       child: Container(
                         height: MediaQuery.of(context).size.width,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Container(
                                 alignment: Alignment.center,
                                 margin: EdgeInsets.only(
                                     left: 80.0, right: 80.0),
                                 width:
                                 MediaQuery.of(context).size.width,
                                 height: 200.0,
                                 child: new Image.asset(
                                     Images.notDeliveringImg)),
                             SizedBox(
                               height: 10.0,
                             ),
                             Text(
                                 S.of(context).sorry_wedidnt_deliever+
                                     // "Sorry, we don't deliver in " +
                                     PrefUtils.prefs.getString("deliverylocation")),
                             GestureDetector(
                               onTap: () {
                                 PrefUtils.prefs.setString(
                                     "formapscreen", "homescreen");
                                 Navigator.of(context)
                                     .pushNamed(MapScreen.routeName);
                               },
                               child: Container(
                                 width: 100.0,
                                 height: 40.0,
                                 margin: EdgeInsets.only(top: 20.0),
                                 decoration: BoxDecoration(
                                   color: Theme.of(context).accentColor,
                                   borderRadius:
                                   BorderRadius.circular(3.0),
                                 ),
                                 child: Center(
                                     child: Text(
                                       S.of(context).change_location,//'Change Location',
                                       textAlign: TextAlign.center,
                                       style: TextStyle(color: Colors.white),
                                     )),
                               ),
                             ),
                             if (Vx.isWeb)Footer(
                               address: PrefUtils.prefs.getString("restaurant_address"),
                             ),
                           ],
                         ),
                       ),
                     ),
                   )
                       :
                   _isDelivering
                       ?homedata!=null?
                   Column(
                     children: [
                       if (!PrefUtils.prefs.containsKey("apikey") && !Vx.isWeb)(Features.isMembership)? Container(
                         height: 35,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(2),
                             color: Colors.green),
                         width:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
                         margin: EdgeInsets.all(5.0),
                         child: Row(
                           children: [
                             SizedBox(width: 10),
                             Text(
                               S.of(context).get_membership_and_other,//"Get membership & other benefits",
                               style: TextStyle(
                                   fontSize: 12,
                                   color: Colors.white),
                             ),
                             Spacer(),
                             GestureDetector(
                                 onTap: () {
                                   Navigator.of(context).pushNamed(
                                     SignupSelectionScreen.routeName,
                                       arguments: {
                                         "prev": "signupSelectionScreen",
                                       }
                                   );
                                 },
                                 child: Text(
                                   S.of(context).login_register,//"LOGIN / REGISTER",
                                   style: TextStyle(
                                       fontSize: 12,
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold),
                                 )),
                             SizedBox(width: 10),
                           ],
                         ),
                       ):SizedBox.shrink(),
                       if(Features.isWebsiteSlider) if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) WebsiteSlider(homedata),
                       if(Vx.isWeb && !ResponsiveLayout.isLargeScreen(context))_bannerMain1(homedata),
                       if(!Vx.isWeb)_bannerMain1(homedata),
                       SizedBox(height: 8),
                       if(Features.isCarousel) if (ResponsiveLayout.isSmallScreen(context)) CarouselSliderimage(homedata),
                       SizedBox(height: 5),
                       //TODO: Pending Mutation Intigration
                       if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) WebsiteSmallbanner(homedata),
                       SizedBox(
                         height: 10,
                       ),

                       Container(
                         //  constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             //TODO:Category one mutation i pending due its linked with another page
                             if(Features.isCategoryOne)CategoryOne(homedata),
                             SizedBox(
                               height: 10,
                             ),
                             if(Features.isAdsCategoryOne)
                               (MediaQuery.of(context).size.width <= 600)
                                   ? _advertiseCategoryOne(homedata)
                                   : SizedBox.shrink(),
                             if(Features.isBulkUpload)(MediaQuery.of(context).size.width <= 600) ?
                             Container(
                                 width: MediaQuery.of(context).size.width,
                                 padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
                                 child: Text(
                                   S.of(context).for_your_convenience,
                                   //"For Your Convenience",
                                   style: TextStyle(
                                       fontSize: 18,
                                       color: Theme.of(context).primaryColor,
                                       fontWeight: FontWeight.bold),
                                 )
                             )
                                 :
                             SizedBox.shrink(),
                             if(Features.isBulkUpload)(MediaQuery.of(context).size.width <= 600) ? Container(
                               width: MediaQuery.of(context).size.width,
                               margin: EdgeInsets.only(left: 10.0, top: 8.0, right: 10.0, bottom: 15.0),
                               child: Row(
                                 children: [
                                   GestureDetector(
                                     onTap: () {
                                       // checkskip ?
                                       !PrefUtils.prefs.containsKey("apikey") ?
                                       Navigator.of(context).pushNamed(SignupSelectionScreen.routeName,
                                           arguments: {
                                             "prev": "signupSelectionScreen",
                                           })
                                           :
                                       Navigator.of(context).pushNamed(MultipleImagePicker.routeName,
                                           arguments: {
                                             'subject' : "Click & Send",
                                             'type' : "click",
                                           });
                                     },
                                     child: Image.asset(
                                       Images.bulkImg,
                                       width: (MediaQuery.of( context).size.width / 2) - 15,
                                     ),

                                   ),
                                   SizedBox(width: 10),
                                   GestureDetector(
                                     onTap: () {
                                       launch("tel: " + IConstants.primaryMobile);
                                     },
                                     child: Image.asset(
                                       Images.supportImg,
                                       width: (MediaQuery.of(context).size.width / 2) - 15,
                                     ),
                                   )

                                 ],
                               ),
                             ) : SizedBox.shrink(),
                             if(Features.isAdsItemsOne)// Advertisement for Featured Items 1_featuredAdsOne(),
                               _featuredAdsOne(homedata),
                             if(Features.isSellingItems)
                               Vx.isWeb ? _featuredItemweb(homedata) :_featuredItemMobile(homedata),
                             if(Features.isCategoryTwo)
                               CategoryTwo(homedata),
                             /*if(Features.isCategoryTwo)SizedBox(
                      height: 5,
                    ),*/
                             if(Features.isAdsCategoryTwo)
                               _featuredAdsTwo(homedata),
                             if(Features.isAdsCategoryTwo)
                             // SizedBox(
                             //   height: 10,
                             // ),

                               if(Features.isCategoryThree)
                                 _categoryThree(homedata),
                             // SizedBox(
                             //   height: 10,
                             // ),
                             if(Features.isVerticalSlider)
                               (MediaQuery.of(context).size.width <= 600)
                                   ? _featuredAdsVertical(homedata)
                                   : SizedBox.shrink(),
                             // if(Features.isFeatureAdsThree)
                             //   _featuredAdsThree(homedata),
                             if(Features.isOffersForHomepage)
                               _offersItem(homedata),
                             if(Features.isCategory)
                               (Vx.isWeb)?_categoryweb(homedata): _category(homedata),
                             //Categories
                             SizedBox(
                               height: 5,
                             ),
                             // Brands items

                             if(Features.isBrands)
                               _brands(homedata),
                             if(Features.isDiscountItems)
                               _discountItem(homedata),
                           ],
                         ),
                       ),
                       if(Features.isFooter)
                         if (!Vx.isWeb)
                           _footer(homedata),
                       if (Vx.isWeb && _isRestaurant) Footer(address: _address),
                     ],):SizedBox.shrink()
                       :
                   SingleChildScrollView(
                     child: Center(
                       child: Container(
                         height: MediaQuery.of(context).size.width,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Container(
                                 alignment: Alignment.center,
                                 margin: EdgeInsets.only(
                                     left: 80.0, right: 80.0),
                                 width:
                                 MediaQuery.of(context).size.width,
                                 height: 200.0,
                                 child: new Image.asset(
                                     Images.notDeliveringImg)),
                             SizedBox(
                               height: 10.0,
                             ),
                             Text(
                                 S.of(context).sorry_wedidnt_deliever+
                                     // "Sorry, we don't deliver in " +
                                     PrefUtils.prefs.getString("deliverylocation")),
                             GestureDetector(
                               onTap: () {
                                 PrefUtils.prefs.setString(
                                     "formapscreen", "homescreen");
                                 Navigator.of(context)
                                     .pushNamed(MapScreen.routeName);
                               },
                               child: Container(
                                 width: 100.0,
                                 height: 40.0,
                                 margin: EdgeInsets.only(top: 20.0),
                                 decoration: BoxDecoration(
                                   color: Theme.of(context).accentColor,
                                   borderRadius:
                                   BorderRadius.circular(3.0),
                                 ),
                                 child: Center(
                                     child: Text(
                                       S.of(context).change_location,//'Change Location',
                                       textAlign: TextAlign.center,
                                       style: TextStyle(color: Colors.white),
                                     )),
                               ),
                             ),
                             if (Vx.isWeb)Footer(
                               address: PrefUtils.prefs.getString("restaurant_address"),
                             ),
                           ],
                         ),
                       ),
                     ),
                   );

             }):
          SingleChildScrollView(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 80.0, right: 80.0),
                        width:
                        MediaQuery.of(context).size.width,
                        height: 200.0,
                        child: new Image.asset(
                            Images.notDeliveringImg)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        S.of(context).sorry_wedidnt_deliever+
                            // "Sorry, we don't deliver in " +
                            PrefUtils.prefs.getString("deliverylocation")),
                    GestureDetector(
                      onTap: () {
                        PrefUtils.prefs.setString(
                            "formapscreen", "homescreen");
                        Navigator.of(context)
                            .pushNamed(MapScreen.routeName);
                      },
                      child: Container(
                        width: 100.0,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius:
                          BorderRadius.circular(3.0),
                        ),
                        child: Center(
                            child: Text(
                              S.of(context).change_location,//'Change Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    if (Vx.isWeb)Footer(
                      address: PrefUtils.prefs.getString("restaurant_address"),
                    ),
                  ],
                ),
              ),
            ),
          )

        );
     else return  HomeScreenShimmer();
      },
    );
  }

  void launchWhatsapp({@required number,@required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }

  @override
  Widget build(BuildContext context) {

    /*IConstants.isEnterprise? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorCodes.primaryColor,//Theme.of(context).accentColor, // status bar color
    )):*/
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    bottomNavigationbar() {
      return _isDelivering
          ? SingleChildScrollView(
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
              Column(
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
                      color:ColorCodes.redColor,

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
                          color:ColorCodes.redColor,
                        //  color: ColorCodes.greenColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.0,)),
                ],
              ),
              Spacer(),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context,value,widget){
                    return GestureDetector(
                      onTap: () {
                        if (value != S.of(context).not_available_location)
                        Navigator.of(context).pushNamed(
                          CategoryScreen.routeName,
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
                            child: Image.asset(Images.categoriesImg,
                              color: ColorCodes.blackColor ,
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
                                  color: ColorCodes.blackColor, fontSize: 11.0)),
                        ],
                      ),
                    );
                  }),
              if(Features.isWallet)
              Spacer(),
              // if(Features.isWallet)
              //   ValueListenableBuilder(
              //       valueListenable: IConstants.currentdeliverylocation,
              //       builder: (context,value,widget){
              //         return GestureDetector(
              //           onTap: () {
              //             if (value != S.of(context).not_available_location)
              //               !PrefUtils.prefs.containsKey("apikey")
              //                 ? Navigator.of(context).pushNamed(
              //               SignupSelectionScreen.routeName,
              //             )
              //                 : Navigator.of(context).pushNamed(
              //                 WalletScreen.routeName,
              //                 arguments: {"type": "wallet"});
              //           },
              //           child: Column(
              //             children: <Widget>[
              //               SizedBox(
              //                 height: 7.0,
              //               ),
              //               CircleAvatar(
              //                 radius: 13.0,
              //                 backgroundColor: Colors.transparent,
              //                 child: Image.asset(Images.walletImg,
              //                   color: ColorCodes.blackColor,
              //                   width: 50,
              //                   height: 30,),
              //               ),
              //               SizedBox(
              //                 height: 5.0,
              //               ),
              //               Text(
              //                   S.of(context).wallet,//"Wallet",
              //                   style: TextStyle(
              //                       color: ColorCodes.blackColor, fontSize: 10.0)),
              //             ],
              //           ),
              //         );
              //       }),
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
                              width: 32,
                              height: 22,),
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
                              height: 7.0,
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
                              :
                              HomeScreen.scaffoldKey.currentState.openDrawer();

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
                          height: 7.0,
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
              // if(!Features.isShoppingList)
              //   Spacer(),
              // if(!Features.isShoppingList)
              //   ValueListenableBuilder(
              //       valueListenable: IConstants.currentdeliverylocation,
              //       builder: (context, value, widget){
              //           return GestureDetector(
              //             onTap: () {
              //               if (value != S.of(context).not_available_location)
              //                 !PrefUtils.prefs.containsKey("apikey") && Features.isLiveChat
              //                   ? Navigator.of(context).pushNamed(
              //                 SignupSelectionScreen.routeName,
              //               )
              //                   : (Features.isLiveChat && Features.isWhatsapp)?
              //               Navigator.of(context)
              //                   .pushNamed(CustomerSupportScreen.routeName, arguments: {
              //                 'name': name,
              //                 'email': email,
              //                 'photourl': photourl,
              //                 'phone': phone,
              //               }):
              //               (!Features.isLiveChat && !Features.isWhatsapp)?
              //               Navigator.of(context).pushNamed(SearchitemScreen.routeName)
              //                   :
              //               Features.isWhatsapp?launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery"):
              //               Navigator.of(context)
              //                   .pushNamed(CustomerSupportScreen.routeName, arguments: {
              //                 'name': name,
              //                 'email': email,
              //                 'photourl': photourl,
              //                 'phone': phone,
              //               });
              //             },
              //             child: Column(
              //               children: <Widget>[
              //                 SizedBox(
              //                   height: 7.0,
              //                 ),
              //                 CircleAvatar(
              //                   radius: 13.0,
              //                   backgroundColor: Colors.transparent,
              //                   child: (!Features.isLiveChat && !Features.isWhatsapp)?
              //                   Icon(
              //                     Icons.search,
              //                     color: ColorCodes.blackColor,
              //
              //                   )
              //                       :
              //                   Image.asset(
              //                     Features.isLiveChat?Images.chat : Images.whatsapp,
              //                     width: 50,
              //                     height: 30,
              //                     color: Features.isLiveChat?ColorCodes.blackColor:null,
              //
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: 5.0,
              //                 ),
              //                 Text((!Features.isLiveChat && !Features.isWhatsapp)?S.of(context).search: S.of(context).chat,
              //                     style: TextStyle(
              //                         color: ColorCodes.blackColor, fontSize: 10.0)),
              //               ],
              //             ),
              //           );
              //       }),
              SizedBox(width: 20),
            ],
          ),
        ),
      )
          : SingleChildScrollView(child: Container());
    }

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final sliderData = Provider.of<Advertise1ItemsList>(context, listen: false);
    return Scaffold(
      key: HomeScreen.scaffoldKey,
      drawer: ResponsiveLayout.isSmallScreen(context)
          ?
      ProfileScreen()
          : SizedBox.shrink(),
      backgroundColor: ColorCodes.backgroundcolor/*Theme.of(context).primaryColor*/,
      extendBody: true,
      body: SafeArea(bottom: true,
        child: Container(
          color: ColorCodes.backgroundcolor,
          child: Column(
            children: <Widget>[
              if(_isRestaurant || !Vx.isWeb)
                Header(true, false),
              if (sliderData.websiteItems.length <= 0) //SizedBox(height: 5),
              Expanded(
                child: Vx.isWeb ? Align(child: _body()) : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: _body(),
                ),
              ),

            ],
          )
        ),
      ),
      //bottomNavigationBar: Vx.isWeb ? SizedBox.shrink() : bottomNavigationbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(

          width: MediaQuery.of(context).size.width,

          child: bottomNavigationbar()),
    );
  }

  customfloatingbutton() {
    return VxBuilder(builder: (context,store,state){
      if(CartCalculations.itemCount<=0)
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
              "after_login": ""
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 80.0, top: 80.0, bottom: 10.0),
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color:  Theme.of(context).primaryColor,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                  "after_login": ""
                });
              },
              child: Image.asset(
                Images.fcartImg,
                height: 12,
                fit: BoxFit.contain,
                // width: 3,
              ),
            ),
          ),
        );

      return Consumer<CartCalculations>(
        builder: (_, cart, ch) => FloatButtonBadge(
          child: ch,
          color: Colors.green,
          value: CartCalculations.itemCount.toString(),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
              "after_login": ""
            });
          },
          child: Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).primaryColor,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                  "after_login": ""
                });
              },
              child: Image.asset(
                Images.fcartImg,
                height: 12,
                fit: BoxFit.contain,
                color: ColorCodes.blackColor,
                // width:3,
                // fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      );
    }, mutations: {SetCartItem});
  }

  void blocinit() async{
    HomeScreenController(user:  PrefUtils.prefs.getString("apikey")??PrefUtils.prefs.getString("tokenid"),branch: PrefUtils.prefs.getString("branch"),rows: "0",);
   // await Provider.of<Advertise1ItemsList>(context,listen: false).fetchMainBanner1();
   //  if(Features.isCategory)catbloc.fetchCaegory();
   //  bloc.sellingitemBloc();
   //  bloc.featuredItems();
   // // bloc.featuredItemshome();
   //  if(Features.isCarousel)
   //    bloc.fetchBanner();
   //  if(Features.isCategoryOne)
   //    bloc.CategoryOne();
   //  if(Features.isAdsCategoryOne)
   //    bloc.fetchAdvertiseOne();
   //  if(Features.isAdsItemsOne)
   //    bloc.featureAdsOne();
   //  if(Features.isAdsCategoryTwo)
   //    bloc.featureAdsTwo();
   //  if(Features.isVerticalSlider)
   //    bloc.featureAdsThree();
   //  if(Features.isFeatureAdsThree)
   //    bloc.featureAdsFour();
   //
   //  if(Features.isCategoryTwo)
   //    bloc.CategoryTwo();
   //  if(Features.isCategoryThree)
   //    bloc.fetchCategoryThree();
   //  if(Features.isBrands)
   //    bloc.BrandfiledBloc();
   //  if(Features.isFooter)
   //  bloc.fetchFooter();
  }

/*  apirefreshe() async{
    await Provider.of<CarouselItemsList>(context, listen: false).fetchBanner();
    await Provider.of<BrandItemsList>(context, listen: false).fetchBrands();
    await Provider.of<SellingItemsList>(context, listen: false).fetchOffers();
    //await Provider.of<CategoriesItemsList>(context, listen: false).fetchCategory();
    if(Vx.isWeb)await Provider.of<CategoriesItemsList>(context, listen: false).fetchCategoryweb();
    await Provider.of<Advertise1ItemsList>(context, listen: false).fetchadvertisecategory1();
    await Provider.of<Advertise1ItemsList>(context, listen: false).fetchAdvertisecategory2();
    await Provider.of<Advertise1ItemsList>(context, listen: false).fetchAdvertisementVerticalslider();
    await Provider.of<Advertise1ItemsList>(context, listen: false).fetchAdvertisementItem1();
    await Provider.of<Advertise1ItemsList>(context, listen: false).fetchAdvertisecategory3();
    await Provider.of<BrandItemsList>(context, listen: false).fetchDeliveryMode();
    //await Provider.of<BrandItemsList>(context, listen: false).fetchPaymentMode();
    await Provider.of<SellingItemsList>(context, listen: false).fetchSellingItems();
    await Provider.of<SellingItemsList>(context, listen: false).fetchDiscountItems();

    if (!checkskip) {
      Provider.of<BrandItemsList>(context, listen: false).userDetails();
      await Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist();
    }
    await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
      if (!PrefUtils.prefs.containsKey("deliverylocation")) {
        setState(() {
          PrefUtils.prefs.setString(
              "deliverylocation", PrefUtils.prefs.getString("restaurant_location"));
          PrefUtils.prefs.setString("latitude", PrefUtils.prefs.getString("restaurant_lat"));
          PrefUtils.prefs.setString("longitude", PrefUtils.prefs.getString("restaurant_long"));
        });

      }
    });
    await Provider.of<NotificationItemsList>(context,listen: false)
        .fetchNotificationLogs(PrefUtils.prefs.getString('userID'));
  }*/

  ShowpopupforHoliday() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(

          onWillPop: (){
            SystemNavigator.pop();
            return Future.value(false);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(IConstants.holydayNote),
            actions: <Widget>[
              Vx.isWeb? SizedBox.shrink():FlatButton(
                child: Text(
                  S.of(context).ok,//'Ok'
                ),
                onPressed: () async {
                  SystemNavigator.pop();
                },
              ),
              FlatButton(
                child: Text(
                  S.of(context).change_location,//'Change'
                ),
                onPressed: () async {
                  PrefUtils.prefs.setString("formapscreen", "homescreen");
                  Navigator.of(context).pushNamed(MapScreen.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


