import 'dart:io';
import 'package:flutter_html/style.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../widgets/components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/features.dart';
import '../generated/l10n.dart';
import '../widgets/bottom_navigation.dart';


import '../services/firebaseAnaliticsService.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import '../blocs/search_item_bloc.dart';
import '../blocs/sliderbannerBloc.dart';
import '../models/sellingitemsfields.dart';
import '../widgets/search_item_widget.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/hiveDB.dart';
import '../main.dart';
import '../providers/sellingitems.dart';
import '../providers/itemslist.dart';
import '../screens/cart_screen.dart';
import '../widgets/selling_items.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import 'singleproduct_screen.dart';

class SearchitemScreen extends StatefulWidget {
  static const routeName = '/searchitem-screen';

  @override
  _SearchitemScreenState createState() => _SearchitemScreenState();
}

class _SearchitemScreenState extends State<SearchitemScreen> {
  bool shimmereffect = true;
  var notificationData;
  int unreadCount = 0;
  bool checkskip = false;
  var popularSearch;
  bool _isSearchShow = false;
  bool _issearchloading = false;
  List searchDispaly = [];
  var searchData;
  String searchValue = "";
  bool _isShowItem = false;
  bool _isLoading = false;
  FocusNode _focus = new FocusNode();
  bool _isNoItem = false;
  bool _checkmembership = false;
  bool _isWeb = false;
  var _address = "";
  var _membership = "";
  ProductRepo _searshproductrepo = ProductRepo();
  var itemname;
  var itemid;
  var itemimg;
  bool iphonex = false;

  var searchDispalyvar = [];

  bool issearchloading = true;

  Future<List<ItemData>> future;

  StateSetter setstate;

  @override
  void initState() {
    bloc.SearcheditemBloc();
    sbloc.searchItemsBloc();
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        } else {
          setState(() {
            _isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          _isWeb = true;
          _isShowItem = _isWeb;
          _isLoading = !_isWeb;
        });
      }
      _address = PrefUtils.prefs.getString("restaurant_address");
      setState(() {
        _membership = PrefUtils.prefs.getString("membership");
        if (_membership == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      //Provider.of<CartItems>(context,listen: false).fetchCartItems();
    });

    (_isWeb)
        ? _focus.addListener(_onFocusChangeWeb)
        : _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChangeWeb() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
        _isShowItem = true;
        _isLoading = false;
        search(itemname);
      } else {
        _isShowItem = true;
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
        _isShowItem = false;
        _isLoading = false;
      } else {
        //_isShowItem = false;
      }
    });
  }

  search(String value) async {
    //sbloc.searchiemsof.add(value);
    /*StreamBuilder<List<SellingItemsFields>>(
      stream: sbloc.serchItems,
      builder: (context,AsyncSnapshot<List<SellingItemsFields>> snapshot){
        return ;
      },
    );*/
    _issearchloading = true;
    await Provider.of<ItemsList>(context,listen: false).fetchsearchItems(value,true).then((isdone) {

      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _issearchloading = false;
          _isSearchShow = true;
          searchData = Provider.of<ItemsList>(context,listen: false);
          //searchDispaly = searchData.searchitems.title;
          searchDispaly = searchData.searchitems.toList();
          if (searchDispaly.length <= 0) {
            _isNoItem = true;
            // _issearchloading = false;
          } else {
            _isNoItem = false;

          }
          /*searchData = Provider.of<ItemsList>(context,listen: false);
        searchDispaly = searchData.searchitems
            .where((elem) =>
            elem.title
                .toString()
                .toLowerCase()
                .contains(searchValue.toLowerCase()))
            .toList();
        _isSearchShow = true;*/
        });

      });

    });
    setstate(() {
     future = _searshproductrepo.getSearchQuery(value);
   });
  }

  onSubmit(String value) async {
    fas.LogSearchItem(search: value);
    //FocusScope.of(context).requestFocus(_focus);
    /*_focus = new FocusNode();
    FocusScope.of(context).requestFocus(_focus);*/
    setState(() {
      _isShowItem = true;
      _isLoading = true;
    });
    setstate(() {

      future = _searshproductrepo.getSearchQuery(value);
    });

    // sbloc.searchiemsof.add(value);
/*    await Provider.of<ItemsList>(context,listen: false).fetchsearchItems(value).then((_) {
      searchData = Provider.of<ItemsList>(context,listen: false);
      searchDispaly = searchData.searchitems.toList();
      if (searchDispaly.length <= 0) {
        _isNoItem = true;
      } else {
        _isNoItem = false;
      }
      _isShowItem = true;
      _isLoading = false;
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focus.dispose();
    /*sbloc.dispose();
    bloc.dispose();*/
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    try {
      if (_isWeb) {
        var routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
        itemname = routeArgs['itemname'];
        itemid = routeArgs['itemid'];
        itemimg = routeArgs['itemimg'];
      }
    } catch (e) {}

    final popularSearch = Provider.of<SellingItemsList>(context,listen: false);

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 370:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 330
        : (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;

    _buildBottomNavigationBar() {
      return ValueListenableBuilder(
        valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context, Box<Product> box, index) {
          if (box.values.isEmpty) return SizedBox.shrink();

          return /*Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  height: 50,
                  width: MediaQuery.of(context).size.width * 40 / 100,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      _checkmembership
                          ? Text(S.of(context).total//'Total: '
                          + IConstants.currencyFormat + " " + (Calculations.totalMember).toStringAsFixed(IConstants.decimaldigit),
                        style:
                        TextStyle(color: Colors.white, fontSize: 15),
                      )
                          : Text(S.of(context).total//'Total: '
                          + IConstants.currencyFormat + " " + (Calculations.total).toStringAsFixed(IConstants.decimaldigit),
                        style:
                        TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        Calculations.itemCount.toString() + S.of(context).item,//" item",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w400,
                            fontSize: 11),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () => {
                      setState(() {
                        Navigator.of(context)
                            .pushNamed(CartScreen.routeName);
                      })
                    },
                    child: Container(
                        color: Theme.of(context).primaryColor,
                        height: 50,
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                            S.of(context).view_cart,//'VIEW CART',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                              )
                            ]))),
              ],
            ),
          );*/
            BottomNaviagation(
              itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
              title: S.current.view_cart,
              total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                  :
              (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
              onPressed: (){
                setState(() {
                  Navigator.of(context)
                      .pushNamed(CartScreen.routeName, arguments: {
                    "after_login": ""
                  });
                });
              },
            );
        },
      );

      /*if(Calculations.itemCount > 0) {
        return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height:50,
                width:MediaQuery.of(context).size.width * 35/100,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    _checkmembership
                        ?
                    Text(_currencyFormat + (Calculations.totalMember).toString(), style: TextStyle(color: Colors.black),)
                        :
                    Text(_currencyFormat + (Calculations.total).toString(), style: TextStyle(color: Colors.black),),
                    Text(Calculations.itemCount.toString() + " item", style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 9),)
                  ],
                ),),
              GestureDetector(
                  onTap: () =>
                  {
                    setState(() {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    })
                  },
                  child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
                      child:Column(children:[
                        SizedBox(height: 17,),
                        Text('VIEW CART', style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ]
                      )
                  )
              ),
            ],
          ),
        );
      }*/
    }

    return Scaffold(
      backgroundColor: ColorCodes.whiteColor,
      body: Column(children: <Widget>[
        if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false, false),
        //     :
        // if (_isWeb) onSubmit(itemname),
        _searchContainermobile(),
        StatefulBuilder(
         builder: (context,setState){
           setstate = setState;
          return Expanded(
               child: SingleChildScrollView(
                 child: Column(children: [
                   /// display list of search item
                   if (_isShowItem)//Show Searched Items
                   /*   if(_isSearchShow)*/
                     FutureBuilder<List<ItemData>> (
                       future: future,
                       builder: (context,  snapshot){
                         print("data ${snapshot.error}");
                         switch(snapshot.connectionState){

                           // case ConnectionState.none:
                           //   print("non");
                           //   // TODO: Handle this case.
                           //   break;
                           case ConnectionState.waiting:
                             print("waiting");
                             return Container(
                               height: MediaQuery.of(context).size.height - 130.0,
                               child: Center(child: ItemListShimmer()),
                             );
                             // TODO: Handle this case.
                             break;
                           // case ConnectionState.active:
                           //   print("Active");
                           //   // TODO: Handle this case.
                           //   break;
                           case ConnectionState.done:
                             print("Done");
                             if(!snapshot.hasData) return SizedBox.shrink();
                             if (snapshot.data.length <= 0) {
                               return Container(
                                 height: MediaQuery
                                     .of(context)
                                     .size
                                     .height * 0.65,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   // crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Align(
                                       alignment: Alignment.center,
                                       child: new Image.asset(
                                         Images.noItemImg,
                                         fit: BoxFit.fill,
                                         height: 250.0,
                                         width: 200.0,
//                    fit: BoxFit.cover
                                       ),
                                     ),
                                   ],
                                 ),
                               );//ItemListShimmer();
                             }else{
                               return  GridView.builder(
                                   padding: EdgeInsets.only(top: 10.0),
                                   shrinkWrap: true,
                                   physics: ScrollPhysics(),
                                   itemCount: snapshot.data.length,
                                   gridDelegate:
                                   new SliverGridDelegateWithFixedCrossAxisCount(
                                     crossAxisCount: widgetsInRow,
                                     childAspectRatio: aspectRatio,
                                   ),
                                   itemBuilder: (BuildContext context, int index) {
                                     return SellingItemsv2("search_item", "", snapshot.data[0]);
                                     // return SellingItems(
                                     //   "searchitem_screen",
                                     //   snapshot.data[index].id,
                                     //   snapshot.data[index].title,
                                     //   snapshot.data[index].imageUrl,
                                     //   snapshot.data[index].brand,
                                     //   "",
                                     //   snapshot.data[index].veg_type,
                                     //   snapshot.data[index].type,
                                     //   snapshot.data[index].eligible_for_express,
                                     //   "",
                                     //   snapshot.data[index].duration,
                                     //   snapshot.data[index].durationType,
                                     //   snapshot.data[index].note,
                                     //   snapshot.data[index].subscribe,
                                     //   snapshot.data[index].paymentmode,
                                     //   snapshot.data[index].cronTime,
                                     //   snapshot.data[index].name,
                                     //
                                     // );
                                     // return SearchedItems(
                                     //   "searchitem_screen",
                                     //   snapshot.data[index].id,
                                     //   snapshot.data[index].title,
                                     //   snapshot.data[index].imageUrl,
                                     //   snapshot.data[index].brand,
                                     //   "",
                                     //   snapshot.data[index].veg_type,
                                     //   snapshot.data[index].type,
                                     //   snapshot.data[index].eligible_for_express,
                                     //  "",
                                     //   snapshot.data[index].duration,
                                     //   snapshot.data[index].durationType,
                                     //   snapshot.data[index].note,
                                     //
                                     // );
                                   });
                             }
                             // TODO: Handle this case.
                             break;
                           default:
                             return SizedBox.shrink();
                         }
//                          if (snapshot.hasData) {
//                            print(" has data");
//                            if (snapshot.data.length <= 0) {
//                              return Container(
//                                height: MediaQuery
//                                    .of(context)
//                                    .size
//                                    .height * 0.65,
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  // crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: [
//                                    Align(
//                                      alignment: Alignment.center,
//                                      child: new Image.asset(
//                                        Images.noItemImg,
//                                        fit: BoxFit.fill,
//                                        height: 250.0,
//                                        width: 200.0,
// //                    fit: BoxFit.cover
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              );//ItemListShimmer();
//                            }else{
//                              return  GridView.builder(
//                                  padding: EdgeInsets.only(top: 10.0),
//                                  shrinkWrap: true,
//                                  physics: ScrollPhysics(),
//                                  itemCount: snapshot.data.length,
//                                  gridDelegate:
//                                  new SliverGridDelegateWithFixedCrossAxisCount(
//                                    crossAxisCount: widgetsInRow,
//                                    childAspectRatio: aspectRatio,
//                                  ),
//                                  itemBuilder: (BuildContext context, int index) {
//                                    return SellingItemsv2("search_item", "", snapshot.data[0]);
//                                    // return SellingItems(
//                                    //   "searchitem_screen",
//                                    //   snapshot.data[index].id,
//                                    //   snapshot.data[index].title,
//                                    //   snapshot.data[index].imageUrl,
//                                    //   snapshot.data[index].brand,
//                                    //   "",
//                                    //   snapshot.data[index].veg_type,
//                                    //   snapshot.data[index].type,
//                                    //   snapshot.data[index].eligible_for_express,
//                                    //   "",
//                                    //   snapshot.data[index].duration,
//                                    //   snapshot.data[index].durationType,
//                                    //   snapshot.data[index].note,
//                                    //   snapshot.data[index].subscribe,
//                                    //   snapshot.data[index].paymentmode,
//                                    //   snapshot.data[index].cronTime,
//                                    //   snapshot.data[index].name,
//                                    //
//                                    // );
//                                    // return SearchedItems(
//                                    //   "searchitem_screen",
//                                    //   snapshot.data[index].id,
//                                    //   snapshot.data[index].title,
//                                    //   snapshot.data[index].imageUrl,
//                                    //   snapshot.data[index].brand,
//                                    //   "",
//                                    //   snapshot.data[index].veg_type,
//                                    //   snapshot.data[index].type,
//                                    //   snapshot.data[index].eligible_for_express,
//                                    //  "",
//                                    //   snapshot.data[index].duration,
//                                    //   snapshot.data[index].durationType,
//                                    //   snapshot.data[index].note,
//                                    //
//                                    // );
//                                  });
//                            }
//                          }else if(!snapshot.hasData){
//                            print("dont has data");
//                            return Container(
//                              height: MediaQuery.of(context).size.height - 130.0,
//                              child: Center(child: ItemListShimmer()),
//                            );
//                            /* Container(
//                          // height: MediaQuery.of(context).size.height,
//                           child: Center(child: Expanded(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: new Image.asset(
//                                 Images.noItemImg,
//                                 fit: BoxFit.fill,
//                                 height: 200.0,
//                                 width: 200.0,
// //                    fit: BoxFit.cover
//                               ),
//                             ),
//                           ),),
//                         );*/
//                          }
//                          else{
//                            return Container(
//                              height: MediaQuery.of(context).size.height - 130.0,
//                              child: Center(child: ItemListShimmer()),
//                            );
//                          }
                       },)
                   /*else
                      StreamBuilder(stream: bloc.featureditems,builder: (context, AsyncSnapshot<List<SellingItemsFields>> snapshot){
                        if (snapshot.hasData) {
                          if (snapshot.data.length<0) {
                            return ItemListShimmer();
                          }else{
                            return  GridView.builder(
                                padding: EdgeInsets.only(top: 10.0),
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.length,
                                gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widgetsInRow,
                                  childAspectRatio: aspectRatio,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return SellingItems(
                                    "searchitem_screen",
                                    snapshot.data[index].id,
                                    snapshot.data[index].title,
                                    snapshot.data[index].imageUrl,
                                    snapshot.data[index].brand,
                                    "",
                                  );
                                  return SearchedItems(
                                    "searchitem_screen",
                                    snapshot.data[index].id,
                                    snapshot.data[index].title,
                                    snapshot.data[index].imageUrl,
                                    snapshot.data[index].brand,
                                    "",
                                  );
                                });
                          }
                        }else if(snapshot.connectionState == ConnectionState.waiting){
                          return Container(
                            height: MediaQuery.of(context).size.height - 130.0,
                            child: Center(child: ItemListShimmer()),
                          );
                        }
                        else{
                          return Container(
                            height: MediaQuery.of(context).size.height - 130.0,
                            child: Center(child: ItemListShimmer()),
                          );
                        }
                      },)*/
                   else
                   /// display dropdown of  search item
                   //Search item list Ui
                     Container(

                       // searchin...
                       width: MediaQuery.of(context).size.width,
                       //height: MediaQuery.of(context).size.height,
                       margin: EdgeInsets.all(8.0),
                       color: Theme.of(context).backgroundColor,

                       child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             /*  if (_isSearchShow)*/
                             SizedBox(
                               child:  StreamBuilder(
                                   stream: sbloc.serchitemstream,
                                   builder: (context, AsyncSnapshot<List<SellingItemsFields>> snapshot) {

                                     return Column(
                                       children: [
                                         if(snapshot.hasData)
                                           if (snapshot.data.isNotEmpty)
                                             if(_isSearchShow)
                                               new ListView.builder(
                                                 shrinkWrap: true,
                                                 physics:
                                                 NeverScrollableScrollPhysics(),
                                                 itemCount: snapshot.data.length,
                                                 padding: EdgeInsets.zero,
                                                 itemBuilder: (_, i) => Column(
                                                   children: [
                                                     GestureDetector(
                                                       onTap: () {
                                                         Navigator.of(context)
                                                             .pushNamed(
                                                             SingleproductScreen
                                                                 .routeName,
                                                             arguments: {
                                                               "itemid": snapshot
                                                                   .data[i].id
                                                                   .toString(),
                                                               "itemname": snapshot
                                                                   .data[i].title
                                                                   .toString(),
                                                               "itemimg": snapshot
                                                                   .data[i].imageUrl
                                                                   .toString(),
                                                               "eligibleforexpress":
                                                               snapshot.data[i]
                                                                   .eligible_for_express
                                                                   .toString(),
                                                               "delivery": snapshot
                                                                   .data[i].delivery
                                                                   .toString(),
                                                               "duration": snapshot
                                                                   .data[i].duration
                                                                   .toString(),
                                                               "durationType": snapshot
                                                                   .data[i]
                                                                   .durationType
                                                                   .toString(),
                                                               "note": snapshot
                                                                   .data[i].note
                                                                   .toString(),
                                                               "fromScreen":
                                                               "searchitem_screen",
                                                             });
                                                         // _isShowItem = true;
                                                         _isLoading = true;
                                                         FocusScope.of(context)
                                                             .requestFocus(
                                                             new FocusNode());
                                                         // onSubmit(searchValue);
                                                       },
                                                       child: Container(
                                                         padding: EdgeInsets.all(12.0),
                                                         decoration: BoxDecoration(
                                                             color: Colors.white,
                                                             border: Border(
                                                               bottom: BorderSide(
                                                                 width: 2.0,
                                                                 color: Theme.of(
                                                                     context)
                                                                     .backgroundColor,
                                                               ),
                                                             )),
                                                         width: MediaQuery.of(context)
                                                             .size
                                                             .width,
                                                         child: Text(
                                                           snapshot.data[i].title,
                                                           style: TextStyle(
                                                               color: Colors.black,
                                                               fontSize: 12.0),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                         if(_issearchloading) LinearProgressIndicator(
                                           // color: ColorCodes.primaryColor,
                                           minHeight: 5,
                                         ),
                                         Column(
                                           children: [
                                             if (ResponsiveLayout.isSmallScreen(
                                                 context))
                                               Container(
                                                 margin: EdgeInsets.all(14.0),
                                                 child: Text(
                                                   S
                                                       .of(context)
                                                       .popular_search, //"Popular Searches"
                                                 ),
                                                 width: double.maxFinite,
                                               ),
                                             if (ResponsiveLayout.isSmallScreen(
                                                 context))
                                               SizedBox(
                                                 child: VxBuilder(
                                                   mutations: {HomeScreenController},
                                                   builder: (ctx, store,VxStatus state){
                                                     final snapshot =store.homescreen.data.featuredByCart;
                                                     //stream: bloc.featureditems,

                                                     if (snapshot!=null) {
                                                       return new ListView.builder(
                                                         shrinkWrap: true,
                                                         physics:
                                                         NeverScrollableScrollPhysics(),
                                                         itemCount:
                                                         snapshot.data.length,
                                                         padding: EdgeInsets.zero,
                                                         itemBuilder: (_, i) =>
                                                             Column(
                                                               children: [
                                                                 GestureDetector(
                                                                   onTap: () {

                                                                     Navigator.of(context).pushNamed(
                                                                         SingleproductScreen.routeName,
                                                                         arguments: {
                                                                           "itemid": snapshot.data[i].id.toString(),
                                                                           "itemname": snapshot.data[i].itemName.toString(),
                                                                           "itemimg": snapshot.data[i].itemFeaturedImage.toString(),
                                                                           "eligibleforexpress": snapshot.data[i].eligibleForExpress.toString(),
                                                                           "delivery": snapshot.data[i].delivery.toString(),
                                                                           "duration": snapshot.data[i].duration.toString(),
                                                                           "durationType": snapshot.data[i].deliveryDuration.durationType.toString(),
                                                                           "note": snapshot.data[i].deliveryDuration.note.toString(),
                                                                           "fromScreen": "searchitem_screen",
                                                                         });
                                                                     /*                                        _isShowItem = true;

                                                                     _isLoading = true;
                                                                     FocusScope.of(
                                                                         context)
                                                                         .requestFocus(
                                                                         new FocusNode());
                                                                     */
                                                                   },
                                                                   child: Container(
                                                                     padding:
                                                                     EdgeInsets.all(
                                                                         14.0),
                                                                     decoration:
                                                                     BoxDecoration(
                                                                         color: Colors
                                                                             .white,
                                                                         border:
                                                                         Border(
                                                                           bottom:
                                                                           BorderSide(
                                                                             width:
                                                                             2.0,
                                                                             color: Theme.of(context)
                                                                                 .backgroundColor,
                                                                           ),
                                                                         )),
                                                                     width:
                                                                     MediaQuery.of(
                                                                         context)
                                                                         .size
                                                                         .width,
                                                                     child: Text(
                                                                       snapshot.data[i]
                                                                           .itemName,
                                                                       style: TextStyle(
                                                                           color: Colors
                                                                               .black,
                                                                           fontSize:
                                                                           12.0),
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ],
                                                             ),
                                                       );
                                                     } else {
                                                       return SizedBox.shrink();
                                                     }
                                                   },
                                                 ),
                                               ),
                                           ],
                                         )
                                       ],
                                     );
                                     if(snapshot.hasData)
                                     {
                                       if(_isSearchShow)
                                         //searched Items
                                           {
                                         if (snapshot.data.isNotEmpty)
                                           return Column(
                                             children: [
                                               new ListView.builder(
                                                 shrinkWrap: true,
                                                 physics:
                                                 NeverScrollableScrollPhysics(),
                                                 itemCount: snapshot.data.length,
                                                 padding: EdgeInsets.zero,
                                                 itemBuilder: (_, i) => Column(
                                                   children: [
                                                     GestureDetector(
                                                       onTap: () {
                                                         Navigator.of(context)
                                                             .pushNamed(
                                                             SingleproductScreen
                                                                 .routeName,
                                                             arguments: {
                                                               "itemid": snapshot
                                                                   .data[i].id
                                                                   .toString(),
                                                               "itemname": snapshot
                                                                   .data[i].title
                                                                   .toString(),
                                                               "itemimg": snapshot
                                                                   .data[i].imageUrl
                                                                   .toString(),
                                                               "eligibleforexpress":
                                                               snapshot.data[i]
                                                                   .eligible_for_express
                                                                   .toString(),
                                                               "delivery": snapshot
                                                                   .data[i].delivery
                                                                   .toString(),
                                                               "duration": snapshot
                                                                   .data[i].duration
                                                                   .toString(),
                                                               "durationType": snapshot
                                                                   .data[i]
                                                                   .durationType
                                                                   .toString(),
                                                               "note": snapshot
                                                                   .data[i].note
                                                                   .toString(),
                                                               "fromScreen":
                                                               "searchitem_screen",
                                                             });
                                                         // _isShowItem = true;
                                                         _isLoading = true;
                                                         FocusScope.of(context)
                                                             .requestFocus(
                                                             new FocusNode());
                                                         // onSubmit(searchValue);
                                                       },
                                                       child: Container(
                                                         padding: EdgeInsets.all(12.0),
                                                         decoration: BoxDecoration(
                                                             color: Colors.white,
                                                             border: Border(
                                                               bottom: BorderSide(
                                                                 width: 2.0,
                                                                 color: Theme.of(
                                                                     context)
                                                                     .backgroundColor,
                                                               ),
                                                             )),
                                                         width: MediaQuery.of(context)
                                                             .size
                                                             .width,
                                                         child: Text(
                                                           snapshot.data[i].title,
                                                           style: TextStyle(
                                                               color: Colors.black,
                                                               fontSize: 12.0),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                               Column(
                                                 children: [
                                                   if (ResponsiveLayout.isSmallScreen(
                                                       context))
                                                     Container(
                                                       margin: EdgeInsets.all(14.0),
                                                       child: Text(
                                                         S
                                                             .of(context)
                                                             .popular_search, //"Popular Searches"
                                                       ),
                                                       width: double.maxFinite,
                                                     ),
                                                   if (ResponsiveLayout.isSmallScreen(
                                                       context))
                                                     SizedBox(
                                                       child: StreamBuilder(
                                                         stream: bloc.featureditems,
                                                         builder: (context,
                                                             AsyncSnapshot<
                                                                 List<
                                                                     SellingItemsFields>>
                                                             snapshot) {
                                                           if (snapshot.hasData) {
                                                             return new ListView
                                                                 .builder(
                                                               shrinkWrap: true,
                                                               physics:
                                                               NeverScrollableScrollPhysics(),
                                                               itemCount: snapshot
                                                                   .data.length,
                                                               padding:
                                                               EdgeInsets.zero,
                                                               itemBuilder: (_, i) =>
                                                                   Column(
                                                                     children: [
                                                                       GestureDetector(
                                                                         onTap: () {
                                                                           /*Navigator.of(context).pushNamed(
                                              SingleproductScreen.routeName,
                                              arguments: {
                                                "itemid" : popularSearch.items[i].id.toString(),
                                                "itemname" : snapshot.data.data[i].itemName.toString(),
                                                "itemimg" : popularSearch.items[i].imageUrl.toString(),
                                              }
                                          );
                                                              _isShowItem = true;

                                                              _isLoading = true;
                                                              FocusScope.of(context)
                                                                  .requestFocus(new FocusNode());
                                                              onSubmit( snapshot.data[i].title);*/

                                                                           Navigator.of(
                                                                               context)
                                                                               .pushNamed(
                                                                               SingleproductScreen
                                                                                   .routeName,
                                                                               arguments: {
                                                                                 "itemid": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .id
                                                                                     .toString(),
                                                                                 "itemname": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .title
                                                                                     .toString(),
                                                                                 "itemimg": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .imageUrl
                                                                                     .toString(),
                                                                                 "eligibleforexpress": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .eligible_for_express
                                                                                     .toString(),
                                                                                 "delivery": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .delivery
                                                                                     .toString(),
                                                                                 "duration": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .duration
                                                                                     .toString(),
                                                                                 "durationType": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .durationType
                                                                                     .toString(),
                                                                                 "note": snapshot
                                                                                     .data[
                                                                                 i]
                                                                                     .note
                                                                                     .toString(),
                                                                                 "fromScreen":
                                                                                 "searchitem_screen",
                                                                               });

                                                                           _isLoading =
                                                                           true;
                                                                           FocusScope.of(
                                                                               context)
                                                                               .requestFocus(
                                                                               new FocusNode());
                                                                           // onSubmit( snapshot.data[i].title);
                                                                         },
                                                                         child: Container(
                                                                           padding:
                                                                           EdgeInsets
                                                                               .all(
                                                                               14.0),
                                                                           decoration:
                                                                           BoxDecoration(
                                                                               color: Colors
                                                                                   .white,
                                                                               border:
                                                                               Border(
                                                                                 bottom:
                                                                                 BorderSide(
                                                                                   width:
                                                                                   2.0,
                                                                                   color:
                                                                                   Theme.of(context).backgroundColor,
                                                                                 ),
                                                                               )),
                                                                           width: MediaQuery.of(
                                                                               context)
                                                                               .size
                                                                               .width,
                                                                           child: Text(
                                                                             snapshot
                                                                                 .data[i]
                                                                                 .title,
                                                                             style: TextStyle(
                                                                                 color: Colors
                                                                                     .black,
                                                                                 fontSize:
                                                                                 12.0),
                                                                           ),
                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                             );
                                                           } else {
                                                             return SizedBox.shrink();
                                                           }
                                                         },
                                                       ),
                                                     ),
                                                 ],
                                               )
                                             ],
                                           );
                                         else
                                           return Column(
                                             children: [
                                               if (ResponsiveLayout.isSmallScreen(
                                                   context))
                                                 Container(
                                                   margin: EdgeInsets.all(14.0),
                                                   child: Text(
                                                     S
                                                         .of(context)
                                                         .popular_search, //"Popular Searches"
                                                   ),
                                                   width: double.maxFinite,
                                                 ),
                                               if (ResponsiveLayout.isSmallScreen(
                                                   context))
                                                 SizedBox(
                                                   child: StreamBuilder(
                                                     stream: bloc.featureditems,
                                                     builder: (context,
                                                         AsyncSnapshot<
                                                             List<
                                                                 SellingItemsFields>>
                                                         snapshot) {
                                                       if (snapshot.hasData) {
                                                         return new ListView.builder(
                                                           shrinkWrap: true,
                                                           physics:
                                                           NeverScrollableScrollPhysics(),
                                                           itemCount:
                                                           snapshot.data.length,
                                                           padding: EdgeInsets.zero,
                                                           itemBuilder: (_, i) =>
                                                               Column(
                                                                 children: [
                                                                   GestureDetector(
                                                                     onTap: () {
/*                                      Navigator.of(context).pushNamed(
                                              SingleproductScreen.routeName,
                                              arguments: {
                                                "itemid" : popularSearch.items[i].id.toString(),
                                                "itemname" : snapshot.data.data[i].itemName.toString(),
                                                "itemimg" : popularSearch.items[i].imageUrl.toString(),
                                              }
                                          );*/
                                                                       _isShowItem = true;

                                                                       _isLoading = true;
                                                                       FocusScope.of(
                                                                           context)
                                                                           .requestFocus(
                                                                           new FocusNode());
                                                                       onSubmit(snapshot
                                                                           .data[i].title);
                                                                     },
                                                                     child: Container(
                                                                       padding:
                                                                       EdgeInsets.all(
                                                                           14.0),
                                                                       decoration:
                                                                       BoxDecoration(
                                                                           color: Colors
                                                                               .white,
                                                                           border:
                                                                           Border(
                                                                             bottom:
                                                                             BorderSide(
                                                                               width:
                                                                               2.0,
                                                                               color: Theme.of(context)
                                                                                   .backgroundColor,
                                                                             ),
                                                                           )),
                                                                       width:
                                                                       MediaQuery.of(
                                                                           context)
                                                                           .size
                                                                           .width,
                                                                       child: Text(
                                                                         snapshot.data[i]
                                                                             .title,
                                                                         style: TextStyle(
                                                                             color: Colors
                                                                                 .black,
                                                                             fontSize:
                                                                             12.0),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                         );
                                                       } else {
                                                         return SizedBox.shrink();
                                                       }
                                                     },
                                                   ),
                                                 ),
                                             ],
                                           );
                                       } else
                                         return  Column(children: [
                                           if (ResponsiveLayout.isSmallScreen(context))
                                             Container(

                                               margin: EdgeInsets.all(14.0),
                                               child: Text(S.of(context).popular_search,//"Popular Searches"
                                               ),
                                               width: double.maxFinite,
                                             ),
                                           if (ResponsiveLayout.isSmallScreen(context))
                                             SizedBox(
                                               child: StreamBuilder(
                                                 stream: bloc.featureditems,
                                                 builder: (context, AsyncSnapshot<List<SellingItemsFields>> snapshot){
                                                   if(snapshot.hasData){
                                                     return new ListView.builder(
                                                       shrinkWrap: true,
                                                       physics: NeverScrollableScrollPhysics(),
                                                       itemCount: snapshot.data.length,
                                                       padding: EdgeInsets.zero,
                                                       itemBuilder: (_, i) => Column(
                                                         children: [
                                                           GestureDetector(
                                                             onTap: () {
                                                               Navigator.of(context).pushNamed(SingleproductScreen.routeName,
                                                                   arguments: {
                                                                     "itemid" : snapshot.data[i].id.toString(),
                                                                     "itemname" : snapshot.data[i].title.toString(),
                                                                     "itemimg" : snapshot.data[i].imageUrl.toString(),
                                                                     "eligibleforexpress": snapshot.data[i].eligible_for_express.toString(),
                                                                     "delivery":snapshot.data[i].delivery.toString(),
                                                                     "duration":snapshot.data[i].duration.toString(),
                                                                     "durationType": snapshot.data[i].durationType.toString(),
                                                                     "note": snapshot.data[i].note.toString(),
                                                                     "fromScreen":"searchitem_screen",
                                                                   }
                                                               );
                                                               _isShowItem = true;
                                                               _isLoading = true;
                                                               FocusScope.of(context)
                                                                   .requestFocus(new FocusNode());
                                                               // onSubmit( snapshot.data[i].title);
                                                             },
                                                             child: Container(
                                                               padding: EdgeInsets.all(14.0),
                                                               decoration: BoxDecoration(
                                                                   color: Colors.white,
                                                                   border: Border(
                                                                     bottom: BorderSide(
                                                                       width: 2.0,
                                                                       color: Theme.of(context)
                                                                           .backgroundColor,
                                                                     ),
                                                                   )),
                                                               width:
                                                               MediaQuery.of(context).size.width,
                                                               child: Text(
                                                                 snapshot.data[i].title,
                                                                 style: TextStyle(
                                                                     color: Colors.black,
                                                                     fontSize: 12.0),
                                                               ),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     );
                                                   }else{
                                                     return SizedBox.shrink();
                                                   }
                                                 },
                                               ),
                                             ),
                                         ],);
                                     }
                                     else{
                                       //Popular items(featured items)
                                       return Column(children: [
                                         if (ResponsiveLayout.isSmallScreen(context))
                                           Container(

                                             margin: EdgeInsets.all(14.0),
                                             child: Text(S.of(context).popular_search,//"Popular Searches"
                                             ),
                                             width: double.maxFinite,
                                           ),
                                         if (ResponsiveLayout.isSmallScreen(context))
                                           SizedBox(
                                             child: StreamBuilder(
                                               stream: bloc.featureditems,
                                               builder: (context, AsyncSnapshot<List<SellingItemsFields>> snapshot){
                                                 if(snapshot.hasData){
                                                   return new ListView.builder(
                                                     shrinkWrap: true,
                                                     physics: NeverScrollableScrollPhysics(),
                                                     itemCount: snapshot.data.length,
                                                     padding: EdgeInsets.zero,
                                                     itemBuilder: (_, i) => Column(
                                                       children: [
                                                         GestureDetector(
                                                           onTap: () {
                                                             Navigator.of(context).pushNamed(
                                                                 SingleproductScreen.routeName,
                                                                 arguments: {
                                                                   "itemid" : snapshot.data[i].id.toString(),
                                                                   "itemname" : snapshot.data[i].title.toString(),
                                                                   "itemimg" : snapshot.data[i].imageUrl.toString(),
                                                                   "eligibleforexpress": snapshot.data[i].eligible_for_express.toString(),
                                                                   "delivery":snapshot.data[i].delivery.toString(),
                                                                   "duration":snapshot.data[i].duration.toString(),
                                                                   "durationType": snapshot.data[i].durationType.toString(),
                                                                   "note": snapshot.data[i].note.toString(),
                                                                   "fromScreen":"searchitem_screen",
                                                                 }
                                                             );

                                                             _isLoading = true;
                                                             FocusScope.of(context)
                                                                 .requestFocus(new FocusNode());
                                                             // onSubmit( snapshot.data[i].title);
                                                           },
                                                           child: Container(
                                                             padding: EdgeInsets.all(14.0),
                                                             decoration: BoxDecoration(
                                                                 color: Colors.white,
                                                                 border: Border(
                                                                   bottom: BorderSide(
                                                                     width: 2.0,
                                                                     color: Theme.of(context)
                                                                         .backgroundColor,
                                                                   ),
                                                                 )),
                                                             width:
                                                             MediaQuery.of(context).size.width,
                                                             child: Text(
                                                               snapshot.data[i].title,
                                                               style: TextStyle(
                                                                   color: Colors.black,
                                                                   fontSize: 12.0),
                                                             ),
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   );
                                                 }else{
                                                   return SizedBox.shrink();
                                                 }
                                               },
                                             ),
                                           ),
                                       ],);
                                     }
                                   }
                               ),
                             ),

                           ]),
                     ),

                   if (_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
                 ]),
               ));
         },
        )
      ]),
      bottomNavigationBar: (_isWeb && !ResponsiveLayout.isSmallScreen(context))
          ? SizedBox.shrink()
          : Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  _searchContainermobile() {
    return (_isWeb&&!ResponsiveLayout.isSmallScreen(context))?
    Opacity(
        opacity: 0.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.topRight,
                colors:(_isWeb&&!ResponsiveLayout.isSmallScreen(context)) ?[Colors.transparent,Colors.transparent]:[
                Theme.of(context).primaryColor,
            Theme.of(context).accentColor
            ],
          ),
        ),
        //color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color:(_isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Theme.of(context).buttonColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                S.of(context).search_product,//"Search Products",
                style: TextStyle(color:(_isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Colors.white, fontSize: 18.0),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height:2,

            //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(
                      color: (_isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent:Colors.grey.withOpacity(0.5), width: 1.0),
                  color:(_isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: ColorCodes.whiteColor,
                ),
                child: Row(children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color:(_isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Colors.grey,
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.only(bottom: 30.0),
                      width: MediaQuery.of(context).size.width * 50 / 100,
                      child: TextField(
                          autofocus: true,
                          //controller: (_isWeb)?TextEditingController(text:itemname):null,
                          textInputAction: TextInputAction.search,
                          focusNode: _focus,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                            EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                            hintText: S.of(context).type_to_search_product,//"Type to search products",
                          ),
                          onSubmitted: (value) {
                            searchValue = value;
                            _isShowItem = true;
                            _isLoading = true;
                            if (_isWeb) onSubmit(itemname);
                            else{
                              if(!_issearchloading)

                              onSubmit(value);
                              else{
                                FocusScope.of(context).requestFocus(_focus);
                              }
                            }
                          },
                          onChanged: (String newVal) {
                            setState(() {
                              searchValue = newVal;

                              if (newVal.length == 0) {
                                _isSearchShow = false;
                              } else if (newVal.length == 2) {
                                //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                                //search(newVal);
                              } else if (newVal.length >= 3) {
                                search(newVal);
                              }
                            });
                          })),
                ])),
          ),
        ]),
    )):
    Material(
      elevation: (IConstants.isEnterprise)?0:1,
      child: Container(
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
              begin: Alignment.topCenter,
              end: Alignment.topRight,
              colors:[
                ColorCodes.accentColor,
                ColorCodes.primaryColor
              ],
            ),
          ),

          //color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          height: 130.0,
          child: Column(children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color:ColorCodes.menuColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  S.of(context).search_product,//"Search Products",
                  style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800, fontSize: 18.0),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,

              //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                    color:(_isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: ColorCodes.whiteColor,
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.only(bottom: 30.0),
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: TextField(
                            autofocus: true,
                            maxLines: 1,
                            //controller: (_isWeb)?TextEditingController(text:itemname):null,
                            textInputAction: TextInputAction.search,
                            focusNode: _focus,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                            //cursorHeight: 20,
                            // style: TextStyle(
                            //   //fontSize: 40.0,
                            //   height: 0.0,
                            //   //color: Colors.black
                            // ),
                            onTap: (){
                              _isShowItem = false;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 14.0),
                              hintText: S.of(context).type_to_search_product,//"Type to search products",
                            ),
                            onSubmitted: (value) {
                              //searchValue = value;

                              if (_isWeb) onSubmit(itemname);
                              else{
                                if(!_issearchloading)
                                onSubmit(value);
                              else{
                                FocusScope.of(context).requestFocus(_focus);
                              }
                              }
                            },
                            onChanged: (String newVal) {
                              setState(() {
                                searchValue = newVal;

                                if (newVal.length == 0) {
                                  _isSearchShow = false;
                                } else if (newVal.length == 2) {
                                  //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                                  //search(newVal);
                                } else if (newVal.length >= 3) {
                                  search(newVal);
                                  /*searchDispaly = searchData.searchitems
                                                      .where((elem) =>
                                                      elem.title
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(newVal.toLowerCase()))
                                                      .toList();
                                                  _isSearchShow = true;*/
                                }
                              });
                            })),
                  ])),
            ),
          ])),
    );
  }
}
