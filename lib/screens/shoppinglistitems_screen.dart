import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/fetchdata/shopping_list.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';

import '../generated/l10n.dart';

import '../widgets/simmers/item_list_shimmer.dart';

import '../constants/IConstants.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../providers/branditems.dart';
import '../widgets/selling_items.dart';
import '../screens/cart_screen.dart';
import '../data/calculations.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';

class ShoppinglistitemsScreen extends StatefulWidget {
  static const routeName = '/shoppinglistitems-screen';

  @override
  ShoppinglistitemsScreenState createState() => ShoppinglistitemsScreenState();
}

class ShoppinglistitemsScreenState extends State<ShoppinglistitemsScreen> {
  bool _checkmembership = false;
  bool _isLoading = true;
  //SharedPreferences prefs;
  bool _isWeb = false;
  String shoppinglistname="";
  String shoppinglistid="";
  ScrollController controller;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool iphonex = false;
  Future<List<ItemData>> _future;
  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

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
        });
      }
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      shoppinglistid = routeArgs['shoppinglistid'];
      debugPrint("shopping id....."+shoppinglistid);
      ShoppingList().get(shoppinglistid).then((value) {
        debugPrint("shopping list...."+value[0].toJson().toString());
        setState(() {
          _future = Future.value(value);
          _isLoading = false;
          // Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglistItem(shoppinglistid).then((_) {
          //   setState(() {
          //     _isLoading = false;
          //   });
          // });
        });
      });
      if (PrefUtils.prefs.getString("membership") == "1") {
        _checkmembership = true;
      } else {
        _checkmembership = false;
      }


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    shoppinglistid = routeArgs['shoppinglistid'];
    shoppinglistname = routeArgs['shoppinglistname'];


    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      body: _isLoading ? _isWeb?Center(
        child: CircularProgressIndicator(),
      ):ItemListShimmer()
          :
      _body(),
      bottomNavigationBar:  _isWeb ? SizedBox.shrink() :Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child:_buildBottomNavigationBar(),
      ),
    );
  }
  _buildBottomNavigationBar() {
    return VxBuilder(
      mutations: {SetCartItem},
      // valueListenable: Hive.box<Product>(productBoxName).listenable(),
      builder: (context, store, index) {
        final box = (VxState.store as GroceStore).CartItemList;
        if (box.isEmpty) return SizedBox.shrink();
        return BottomNaviagation(
          itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
          title: S.current.view_cart,
          total: _checkmembership ? (IConstants.numberFormat == "1")
              ?(CartCalculations.totalMember).toStringAsFixed(0):(CartCalculations.totalMember).toStringAsFixed(IConstants.decimaldigit)
              :
          (IConstants.numberFormat == "1")
              ?(CartCalculations.total).toStringAsFixed(0):(CartCalculations.total).toStringAsFixed(IConstants.decimaldigit),
          onPressed: (){
            setState(() {
              Navigator.of(context)
                  .pushNamed(CartScreen.routeName,arguments: {
                "after_login": ""
              });
            });
          },
        );
        // return Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: 50.0,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       Container(
        //         height:50,
        //         width:MediaQuery.of(context).size.width * 35/100,
        //         color: Theme.of(context).primaryColor,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: <Widget>[
        //             /*SizedBox(
        //               height: 15.0,
        //             ),*/
        //             _checkmembership
        //                 ?
        //             Text(S.of(context).total
        //       //'Total: '
        //   + IConstants.currencyFormat + (Calculations.totalMember).toStringAsFixed(IConstants.decimaldigit), style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
        //                 :
        //             Text(S.of(context).total
        //               //'Total: '
        //                   + IConstants.currencyFormat + (Calculations.total).toStringAsFixed(IConstants.decimaldigit), style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
        //             Text(Calculations.itemCount.toString() + S.of(context).item
        //              //   " item"
        //               , style: TextStyle(color:Colors.green,fontWeight: FontWeight.w400,fontSize: 9),)
        //           ],
        //         ),),
        //       MouseRegion(
        //         cursor: SystemMouseCursors.click,
        //         child: GestureDetector(
        //             onTap: () =>
        //             {
        //               setState(() {
        //                 Navigator.of(context).pushNamed(CartScreen.routeName);
        //               })
        //             },
        //             child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
        //                 child:Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children:[
        //                   SizedBox(height: 17,),
        //                   Text(S.of(context).view_cart
        //                     //'VIEW CART'
        //                     , style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        //                   Icon(
        //                     Icons.arrow_right,
        //                     color: ColorCodes.whiteColor,
        //                   ),
        //                 ]
        //                 )
        //
        //             )
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }
/*  _buildBottomNavigationBar() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Product>(productBoxName).listenable(),
      builder: (context, Box<Product> box, index) {
        if (box.values.isEmpty) return SizedBox.shrink();
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              VxBuilder(builder: (context,GroceStore store,state){
                return Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  decoration:
                  BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      _checkmembership
                          ? Text(  S.of(context).total
                          //"Total: "
                          + IConstants.currencyFormat +
                          (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                          : Text(  S.of(context).total
                          //"Total: "
                          + IConstants.currencyFormat +
                          (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      *//*Text(
                          Calculations.itemCount.toString() + " item",
                          style: TextStyle( final itemsData = Provider.of<BrandItemsList>(
      context,
      listen: false,
    ).findByIdlistitem(shoppinglistid);

                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 9),
                        ),*//*
                      Text(  S.of(context).saved

                          // "Saved: "
                          + IConstants.currencyFormat + CartCalculations.discount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(
                            color: ColorCodes.discount,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ],
                  ),
                );
              }, mutations: {SetCartItem}),
              GestureDetector(
                onTap: () => {
                  setState(() {
                    Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                      "after_login": ""
                    });
                  })
                },
                child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 65 / 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                          ),
                          Text(  S.of(context).view_cart,
                           // 'VIEW CART',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: ColorCodes.whiteColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.arrow_right,
                            color: ColorCodes.whiteColor,
                          ),
                        ])),
              ),
            ],
          ),
        );
      },
    );
  }*/


  _body(){
    final itemsData = Provider.of<BrandItemsList>(context, listen: false,).listitem();

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow =(_isWeb && !ResponsiveLayout.isSmallScreen(context))?2:1;

    if (deviceWidth > 1200) {
      widgetsInRow = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?5:1;
    }
    else if (deviceWidth > 768) {
      widgetsInRow = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?3:1;
    }
    double aspectRatio =(_isWeb && !ResponsiveLayout.isSmallScreen(context))?
     (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 440:
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return  SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            FutureBuilder<List<ItemData>>(
              future: _future,
              builder: (BuildContext context,AsyncSnapshot<List<ItemData>> snapshot){
                final itemsData = snapshot.data;
                //debugPrint("itemsData....."+itemsData.length.toString());
                if(itemsData!=null)
                return Expanded(
                  child: _isWeb?
                  SingleChildScrollView(
                      child:
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                              height: _isWeb?MediaQuery.of(context).size.height*0.60
                                  :MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: ColorCodes.searchwebbackground,
                              child: new GridView.builder(
                                  itemCount: itemsData.length,
                                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: widgetsInRow,
                                    crossAxisSpacing: 2,
                                    childAspectRatio: aspectRatio,
                                    mainAxisSpacing: 2,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return SellingItemsv2(
                                      "shoppinglistitem_screen",
                                      "",
                                      itemsData[index],
                                    ) ;
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //footer
                          if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
                        ],
                      )
                  ) : Container(
                    width: MediaQuery.of(context).size.width,
                    color: ColorCodes.searchwebbackground,
                    child: new GridView.builder(
                        itemCount: itemsData.length,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widgetsInRow,
                          crossAxisSpacing: 2,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return SellingItemsv2(
                            "shoppinglistitem_screen",
                            "",
                            itemsData[index],
                          ) ;
                        }),
                  ),
                );
                else return SizedBox.shrink();
              },
            ),
          ],));
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: ()=>Navigator.of(context).pop(),),
      title: Text(shoppinglistname,
        style: TextStyle(color: ColorCodes.menuColor),
              ),

      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
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