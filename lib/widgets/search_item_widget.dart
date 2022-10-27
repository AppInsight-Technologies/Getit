import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import '../blocs/search_item_bloc.dart';
import '../models/sellingitemsfields.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/badge_ofstock.dart';
import '../utils/ResponsiveLayout.dart';
import '../data/calculations.dart';
import '../screens/membership_screen.dart';
import '../screens/singleproduct_screen.dart';
import '../constants/features.dart';
import '../utils/prefUtils.dart';
import '../providers/sellingitems.dart';
import '../providers/cartItems.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../screens/bloc.dart';

class SearchedItems extends StatefulWidget {
  final String _fromScreen;
  final String id;
  final String title;
  final String imageUrl;
  final String brand;
  final String shoppinglistid;
  final String veg_type;
  final String type;
  final String eligible_for_express;
  final String delivery;
  final String duration;
  final String durationType;
  final String note;

  SearchedItems(this._fromScreen, this.id, this.title, this.imageUrl, this.brand, this.shoppinglistid, this.veg_type , this.type,this.eligible_for_express
      ,this.delivery,this.duration,this.durationType,this.note);

  @override
  _SearchedItemsState createState() => _SearchedItemsState();
}

class _SearchedItemsState extends State<SearchedItems> {
  Box<Product> productBox;

  var _varlength = false;
  int varlength = 0;

  var dialogdisplay = false;
  var membershipdisplay = true;
  var _checkmembership = false;
  var colorRight = 0xff3d8d3c;
  var colorLeft = 0xff8abb50;
  var _checkmargin = true;
  Color varcolor;

  String varid;
  String varname;
  String varmrp;
  String varprice;
  String varmemberprice;
  String varminitem;
  String varmaxitem;
  int varLoyalty;
  int varQty;
  String varstock;
  String varimageurl;
  bool discountDisplay;
  bool memberpriceDisplay;
  var margins;

  List variationdisplaydata = [];
  List variddata = [];
  List varnamedata = [];
  List varmrpdata = [];
  List varpricedata = [];
  List varmemberpricedata = [];
  List varminitemdata = [];
  List varmaxitemdata = [];
  List varLoyaltydata = [];
  List varQtyData = [];
  List varstockdata = [];
  List vardiscountdata = [];
  List discountDisplaydata = [];
  List memberpriceDisplaydata = [];

  List checkBoxdata = [];
  var containercolor = [];
  var textcolor = [];
  var iconcolor = [];
  bool _isLoading = true;
  bool _isWeb = false;
  bool _isAddToCart = false;
  HomeDisplayBloc _bloc;

  List<SellingItemsFields> itemvarData;

  @override
  void initState() {

    _bloc = HomeDisplayBloc();
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
    productBox = Hive.box<Product>(productBoxName);

    Future.delayed(Duration.zero, () async {
      //await Provider.of<BrandItemsList>(context, listen: false).getLoyalty();
      //prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoading = false;
        if (PrefUtils.prefs.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
          for (int i = 0; i < productBox.length; i++) {
            if (productBox.values.elementAt(i).mode == 1) {
              _checkmembership = true;
            }
          }
        }
        dialogdisplay = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isStock = false;
    sbloc.searchsubitemsof.add(widget.id);
    return StreamBuilder(
        stream: sbloc.serchsubitemstream,
        builder: (context,AsyncSnapshot<List<SellingItemsFields>> snapshot){
          if(snapshot.hasData){
            itemvarData = snapshot.data;
            varlength = itemvarData.length;
            if (varlength > 1) {
              _varlength = true;
              variddata.clear();
              variationdisplaydata.clear();
              for (int i = 0; i < varlength; i++) {
                variddata.add(itemvarData[i].id);
                variationdisplaydata.add(variddata[i]);
                varnamedata.add(itemvarData[i].varname);
                varmrpdata.add(itemvarData[i].varmrp);
                varpricedata.add(itemvarData[i].varprice);
                varmemberpricedata.add(itemvarData[i].varmemberprice);
                varminitemdata.add(itemvarData[i].varminitem);
                varmaxitemdata.add(itemvarData[i].varmaxitem);
                varLoyaltydata.add(itemvarData[i].varLoyalty);
                varQtyData.add(itemvarData[i].varQty);
                varstockdata.add(itemvarData[i].varstock);
                discountDisplaydata.add(itemvarData[i].discountDisplay);
                memberpriceDisplaydata.add(itemvarData[i].membershipDisplay);

                if (i == 0) {
                  checkBoxdata.add(true);
                  containercolor.add(0xffffffff);
                  textcolor.add(0xFF2966A2);
                  iconcolor.add(0xFF2966A2);
                } else {
                  checkBoxdata.add(false);
                  containercolor.add(0xffffffff);
                  textcolor.add(0xff060606);
                  iconcolor.add(0xFFC1C1C1);
                }

                /*var difference = (double.parse(itemvarData[i].varmrp) - int.parse(itemvarData[i].varprice));
        var profit = (difference / double.parse(itemvarData[0].varmrp)) * 100;
        vardiscountdata.add("$profit");*/

              }
            }
            if (varlength <= 0) {
            }
            else {if (!dialogdisplay) {
                varid = itemvarData[0].id;
                varname = itemvarData[0].varname;
                varmrp = itemvarData[0].varmrp.toString();
                varprice = itemvarData[0].varprice.toString();
                varmemberprice = itemvarData[0].varmemberprice.toString();
                varminitem = itemvarData[0].varminitem;
                varmaxitem = itemvarData[0].varmaxitem;
                varLoyalty = itemvarData[0].varLoyalty;
                varQty = itemvarData[0].varQty;
                varstock = itemvarData[0].varstock.toString();
                discountDisplay = itemvarData[0].discountDisplay;
                memberpriceDisplay = itemvarData[0].membershipDisplay;
                //varimageurl = itemvarData[0].imageUrl;

                if (_checkmembership) {
                  if (varmemberprice.toString() == '-' ||
                      double.parse(varmemberprice) <= 0) {
                    if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                      margins = "0";
                    } else {
                      var difference = (double.parse(varmrp) - double.parse(varprice));
                      var profit = difference / double.parse(varmrp);
                      margins = profit * 100;

                      //discount price rounding
                      margins = num.parse(margins.toStringAsFixed(0));
                      margins = margins.toString();
                    }
                  } else {
                    var difference =
                    (double.parse(varmrp) - double.parse(varmemberprice));
                    var profit = difference / double.parse(varmrp);
                    margins = profit * 100;

                    //discount price rounding
                    margins = num.parse(margins.toStringAsFixed(0));
                    margins = margins.toString();
                  }
                } else {
                  if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                    margins = "0";
                  } else {
                    var difference = (double.parse(varmrp) - double.parse(varprice));
                    var profit = difference / double.parse(varmrp);
                    margins = profit * 100;

                    //discount price rounding
                    margins = num.parse(margins.toStringAsFixed(0));
                    margins = margins.toString();
                  }
                }
              }
            }
            addToCart(int _itemCount) async {
              final s = await Provider.of<CartItems>(context, listen: false).addToCart(
                  widget.id, varid, varname, varminitem, varmaxitem, varLoyalty.toString(), varstock, varmrp, widget.title,
                  _itemCount.toString(), varprice, varmemberprice, widget.imageUrl, "0", "0", widget.veg_type, widget.type,widget.eligible_for_express,widget.delivery,widget.duration,widget.durationType,widget.note).then((_) {


                setState(() {
                  _isAddToCart = false;
                  varQty = _itemCount;
                });
                final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
                for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
                  if(sellingitemData.featuredVariation[i].varid == varid) {
                    sellingitemData.featuredVariation[i].varQty = _itemCount;
                    break;
                  }
                }
                for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
                  if(sellingitemData.discountedVariation[i].varid == varid) {
                    sellingitemData.discountedVariation[i].varQty = _itemCount;
                    break;
                  }
                }
                _bloc.setFeaturedItem(sellingitemData);
                Product products = Product(
                    itemId: int.parse(widget.id),
                    varId: int.parse(varid),
                    varName: varname,
                    varMinItem: int.parse(varminitem),
                    varMaxItem: int.parse(varmaxitem),
                    itemLoyalty: varLoyalty,
                    varStock: int.parse(varstock),
                    varMrp: double.parse(varmrp),
                    itemName: widget.title,
                    itemQty: _itemCount,
                    itemPrice: double.parse(varprice),
                    membershipPrice: varmemberprice,
                    itemActualprice: double.parse(varmrp),
                    itemImage: widget.imageUrl,
                    membershipId: 0,
                    mode: 0);

                productBox.add(products);
              });
            }

            incrementToCart(_itemCount) async {
              final s = await Provider.of<CartItems>(context, listen: false).updateCart(varid, _itemCount.toString(), varprice).then((_) {
                setState(() {
                  _isAddToCart = false;
                  varQty = _itemCount;
                });
                if (_itemCount + 1 == int.parse(varminitem)) {
                  for (int i = 0; i < productBox.values.length; i++) {
                    if (productBox.values.elementAt(i).varId == int.parse(varid)) {
                      productBox.deleteAt(i);
                      break;
                    }
                  }
                  final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
                  for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
                    if(sellingitemData.featuredVariation[i].varid == varid) {
                      sellingitemData.featuredVariation[i].varQty = _itemCount;
                    }
                  }
                  for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
                    if(sellingitemData.discountedVariation[i].varid == varid) {
                      sellingitemData.discountedVariation[i].varQty = _itemCount;
                      break;
                    }
                  }
                  _bloc.setFeaturedItem(sellingitemData);
                } else {
                  final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
                  for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
                    if(sellingitemData.featuredVariation[i].varid == varid) {
                      sellingitemData.featuredVariation[i].varQty = _itemCount;
                      break;
                    }
                  }
                  for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
                    if(sellingitemData.discountedVariation[i].varid == varid) {
                      sellingitemData.discountedVariation[i].varQty = _itemCount;
                      break;
                    }
                  }
                  _bloc.setFeaturedItem(sellingitemData);

                  Product products = Product(
                      itemId: int.parse(widget.id),
                      varId: int.parse(varid),
                      varName: varname,
                      varMinItem: int.parse(varminitem),
                      varMaxItem: int.parse(varmaxitem),
                      itemLoyalty: varLoyalty,
                      varStock: int.parse(varstock),
                      varMrp: double.parse(varmrp),
                      itemName: widget.title,
                      itemQty: _itemCount,
                      itemPrice: double.parse(varprice),
                      membershipPrice: varmemberprice,
                      itemActualprice: double.parse(varmrp),
                      itemImage: widget.imageUrl,
                      membershipId: 0,
                      mode: 0);

                  var items = Hive.box<Product>(productBoxName);

                  for (int i = 0; i < items.length; i++) {
                    if (Hive.box<Product>(productBoxName).values.elementAt(i).varId == int.parse(varid)) {
                      Hive.box<Product>(productBoxName).putAt(i, products);
                    }
                  }
                }
              });
            }

            if (_checkmembership) {
              //membershipdisplay = false;
              colorRight = 0xffffffff;
              colorLeft = 0xffffffff;
            } else {
              if (varmemberprice == '-' || varmemberprice == "0") {
                setState(() {
                  membershipdisplay = false;
                  colorRight = 0xffffffff;
                  colorLeft = 0xffffffff;
                });
              } else {
                membershipdisplay = true;
                colorRight = 0xff3d8d3c;
                colorLeft = 0xff8abb50;
              }
            }

            /*if(double.parse(varprice) <= 0 || varprice.toString() == "" || double.parse(varprice) == double.parse(varmrp)){
      discountedPriceDisplay = false;
    } else {
      discountedPriceDisplay = true;
    }*/

            if (margins == null) {
              _checkmargin = false;
            } else {
              if (int.parse(margins) <= 0) {
                _checkmargin = false;
              } else {
                _checkmargin = true;
              }
            }
            setState(() {
              if (int.parse(varstock) <= 0) {
                _isStock = false;
              } else {
                _isStock = true;
              }
            });

            Widget handler( int i) {
              if (int.parse(varstock) <= 0) {
                return (varid == itemvarData[i].id) ?
                Icon(
                    Icons.radio_button_checked_outlined,
                    color: ColorCodes.grey)
                    :
                Icon(
                    Icons.radio_button_off_outlined,
                    color: ColorCodes.blackColor);

              } else {
                return (varid == itemvarData[i].id) ?
                Icon(
                    Icons.radio_button_checked_outlined,
                    color: Color(0xFF2966A2))
                    :
                Icon(
                    Icons.radio_button_off_outlined,
                    color: ColorCodes.blackColor);
              }
            }

            Widget showoptions() {
              showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        StatefulBuilder(builder: (context, setState) {
                          return Container(
                            // height: 400,
                            child: Padding(

                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 28),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(widget.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Image(
                                            height: 40,
                                            width: 40,
                                            image: AssetImage(
                                                Images.bottomsheetcancelImg),
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    // height: 200,
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: variationdisplaydata.length,
                                          itemBuilder: (_, i) {
                                            return GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () async {
                                                setState(() {
                                                  varid = itemvarData[i].id;
                                                  varname = itemvarData[i].varname;
                                                  varmrp = itemvarData[i].varmrp.toString();
                                                  varprice = itemvarData[i].varprice.toString();
                                                  varmemberprice =
                                                      itemvarData[i].varmemberprice.toString();
                                                  varminitem =
                                                      itemvarData[i].varminitem;
                                                  varmaxitem =
                                                      itemvarData[i].varmaxitem;
                                                  varLoyalty =
                                                      itemvarData[i].varLoyalty;
                                                  varQty = itemvarData[i].varQty;
                                                  varstock = itemvarData[i].varstock.toString();
                                                  discountDisplay =
                                                      itemvarData[i].discountDisplay;
                                                  memberpriceDisplay =
                                                      itemvarData[i].membershipDisplay;

                                                  if (_checkmembership) {
                                                    if (varmemberprice.toString() ==
                                                        '-' ||
                                                        double.parse(varmemberprice) <=
                                                            0) {
                                                      if (double.parse(varmrp) <= 0 ||
                                                          double.parse(varprice) <= 0) {
                                                        margins = "0";
                                                      } else {
                                                        var difference =
                                                        (double.parse(varmrp) -
                                                            double.parse(varprice));
                                                        var profit = difference /
                                                            double.parse(varmrp);
                                                        margins = profit * 100;

                                                        //discount price rounding
                                                        margins = num.parse(
                                                            margins.toStringAsFixed(0));
                                                        margins = margins.toString();
                                                      }
                                                    } else {
                                                      var difference =
                                                      (double.parse(varmrp) -
                                                          double.parse(varmemberprice));
                                                      var profit =
                                                          difference /
                                                              double.parse(varmrp);
                                                      margins = profit * 100;

                                                      //discount price rounding
                                                      margins = num.parse(
                                                          margins.toStringAsFixed(0));
                                                      margins = margins.toString();
                                                    }
                                                  } else {
                                                    if (double.parse(varmrp) <= 0 ||
                                                        double.parse(varprice) <= 0) {
                                                      margins = "0";
                                                    } else {
                                                      var difference =
                                                      (double.parse(varmrp) -
                                                          double.parse(varprice));
                                                      var profit =
                                                          difference /
                                                              double.parse(varmrp);
                                                      margins = profit * 100;

                                                      //discount price rounding
                                                      margins = num.parse(
                                                          margins.toStringAsFixed(0));
                                                      margins = margins.toString();
                                                    }
                                                  }

                                                  Future.delayed(
                                                      Duration(seconds: 0), () {
                                                    dialogdisplay = true;
                                                    for (int j = 0; j <
                                                        variddata.length; j++) {
                                                      if (i == j) {
                                                        checkBoxdata[i] = true;
                                                        containercolor[i] = 0xFFFFFFFF;
                                                        textcolor[i] = 0xFF2966A2;
                                                        iconcolor[i] = 0xFF2966A2;
                                                      } else {
                                                        checkBoxdata[j] = false;
                                                        containercolor[j] = 0xFFFFFFFF;
                                                        iconcolor[j] = 0xFFC1C1C1;
                                                        textcolor[j] = 0xFF060606;
                                                      }
                                                    }
                                                  });
                                                  // Navigator.of(context).pop(true);
                                                });
                                              },
                                              child: Container(
                                                height: 50,

                                                padding: EdgeInsets.only(right: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    _checkmembership
                                                        ? //membered usesr
                                                    itemvarData[i].membershipDisplay
                                                        ? RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: itemvarData[i]
                                                              .varcolor,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: varnamedata[i] +
                                                                " - ",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    textcolor[i]),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                            text: IConstants.currencyFormat +
                                                                varmemberpricedata[
                                                                i] +
                                                                " ",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    textcolor[i]),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                              text:
                                                              IConstants.currencyFormat +
                                                                  varmrpdata[
                                                                  i],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    textcolor[i]),
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                        : itemvarData[i].discountDisplay
                                                        ? RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                          itemvarData[i]
                                                              .varcolor,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: varnamedata[
                                                            i] +
                                                                " - ",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    textcolor[
                                                                    i]),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                            text: IConstants.currencyFormat +
                                                                varpricedata[
                                                                i] +
                                                                " ",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    textcolor[
                                                                    i]),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                              text: IConstants.currencyFormat +
                                                                  varmrpdata[
                                                                  i],
                                                              style:
                                                              TextStyle(
                                                                color: Color(
                                                                    textcolor[
                                                                    i]),
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                        : new RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                          itemvarData[i]
                                                              .varcolor,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                            text: varnamedata[
                                                            i] +
                                                                " - ",
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Color(
                                                                  textcolor[
                                                                  i]),
                                                            ),
                                                          ),
                                                          new TextSpan(
                                                            text:
                                                            IConstants.currencyFormat +
                                                                " " +
                                                                varmrpdata[
                                                                i],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Color(
                                                                  textcolor[
                                                                  i]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                        : itemvarData[i].discountDisplay
                                                        ? RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: itemvarData[i]
                                                              .varcolor,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: varnamedata[i] +
                                                                " - ",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    textcolor[i]),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                            IConstants.currencyFormat +
                                                                varpricedata[
                                                                i] +
                                                                " ",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    textcolor[i]),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                              text:
                                                              IConstants.currencyFormat +
                                                                  varmrpdata[
                                                                  i],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    textcolor[i]),
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                        : new RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: itemvarData[i]
                                                              .varcolor,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                            text: varnamedata[i] +
                                                                " - ",
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Color(
                                                                  textcolor[i]),
                                                            ),
                                                          ),
                                                          new TextSpan(
                                                            text:
                                                            IConstants.currencyFormat +
                                                                " " +
                                                                varmrpdata[i],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Color(
                                                                  textcolor[i]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),


                                                    handler(i),

                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      (int.parse(varstock) <= 0) ?
                                      GestureDetector(
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg: /*"You will be notified via SMS/Push notification, when the product is available"*/ S.of(context).out_of_stock,//"Out Of Stock",
                                              fontSize: MediaQuery.of(context).textScaleFactor *13,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white);
                                        },
                                        child: Container(
                                          height: 40.0,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width - 76,
                                          decoration: new BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              color: Colors.grey,
                                              borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(2.0),
                                                topRight: const Radius.circular(2.0),
                                                bottomLeft: const Radius.circular(2.0),
                                                bottomRight: const Radius.circular(2.0),
                                              )),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Center(
                                                  child: Text(
                                                    S.of(context).notify_me,// 'Notify Me',
                                                    /*"ADD",*/
                                                    style: TextStyle(
                                                      /*fontWeight: FontWeight.w700,*/
                                                        color:
                                                        Colors
                                                            .white /*Colors.black87*/),
                                                    textAlign: TextAlign.center,
                                                  )),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius: new BorderRadius.only(
                                                      topRight:
                                                      const Radius.circular(2.0),
                                                      bottomRight:
                                                      const Radius.circular(2.0),
                                                    )),
                                                height: 40,
                                                width: 25,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          : Container(
                                        height: 40.0,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width - 76,
                                        /*(MediaQuery.of(context).size.width / 3) + 18,*/
                                        child: ValueListenableBuilder(
                                          valueListenable:
                                          Hive.box<Product>(productBoxName)
                                              .listenable(),
                                          builder: (context, Box<Product> box, _) {
                                            /*if (box.values.length <= 0)*/ if (varQty <=
                                                0)
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isAddToCart = true;
                                                  });
                                                  addToCart(int.parse(
                                                      itemvarData[0].varminitem));
                                                },
                                                child: Container(
                                                  height: 40.0,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .accentColor,
                                                    borderRadius:
                                                    BorderRadius.circular(3),
                                                  ),
                                                  child: _isAddToCart ?
                                                  Center(
                                                    child: SizedBox(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        child: new CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          valueColor: new AlwaysStoppedAnimation<
                                                              Color>(Colors.white),)),
                                                  )
                                                      :
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                            S.of(context).add,//'ADD',
                                                            style: TextStyle(
                                                              color: Theme
                                                                  .of(context)
                                                                  .buttonColor,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          )),
                                                      Spacer(),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Theme
                                                              .of(context)
                                                              .primaryColor,
                                                          borderRadius:
                                                          new BorderRadius.only(
                                                            bottomRight:
                                                            const Radius.circular(3),
                                                            topRight:
                                                            const Radius.circular(3),
                                                          ),
                                                        ),
                                                        height: 40,
                                                        width: 30,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            else
                                              return Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          _isAddToCart = true;
                                                          incrementToCart(varQty - 1);
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: new BoxDecoration(
                                                            border: Border.all(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                            ),
                                                            borderRadius:
                                                            new BorderRadius.only(
                                                              bottomLeft:
                                                              const Radius.circular(
                                                                  3),
                                                              topLeft:
                                                              const Radius.circular(
                                                                  3),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "-",
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Theme
                                                                    .of(context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: _isAddToCart ?
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Theme
                                                              .of(context)
                                                              .primaryColor,
                                                        ),
                                                        height: 40,
                                                        width: 30,
                                                        padding: EdgeInsets.only(
                                                            left: 5.0,
                                                            top: 10.0,
                                                            right: 5.0,
                                                            bottom: 10.0),
                                                        child: Center(
                                                          child: SizedBox(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              child: new CircularProgressIndicator(
                                                                strokeWidth: 2.0,
                                                                valueColor: new AlwaysStoppedAnimation<
                                                                    Color>(
                                                                    Colors.white),)),
                                                        ),
                                                      )
                                                          :
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: Theme
                                                                .of(context)
                                                                .primaryColor,
                                                          ),
                                                          height: 40,
                                                          width: 30,
                                                          child: Center(
                                                            child: Text(
                                                              varQty.toString(),
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (varQty <
                                                            int.parse(varstock)) {
                                                          if (varQty <
                                                              int.parse(varmaxitem)) {
                                                            setState(() {
                                                              _isAddToCart = true;
                                                            });
                                                            incrementToCart(varQty + 1);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                                fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                                backgroundColor:
                                                                Colors.black87,
                                                                textColor: Colors
                                                                    .white);
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                              fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                              backgroundColor:
                                                              Colors.black87,
                                                              textColor: Colors.white);
                                                        }
                                                      },
                                                      child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: new BoxDecoration(
                                                            border: Border.all(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                            ),
                                                            borderRadius:
                                                            new BorderRadius.only(
                                                              bottomRight:
                                                              const Radius.circular(
                                                                  3),
                                                              topRight:
                                                              const Radius.circular(
                                                                  3),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "+",
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Theme
                                                                    .of(context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 10)
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  })
                  .then((_) => setState(() {
                variddata.clear();
                variationdisplaydata.clear();
              }));
            }
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context)) {
              return Container(
                // width: MediaQuery
                //     .of(context)
                //     .size
                //     .width/2,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: Color(0xFFCFCFCF)),),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5),
                child: Column(
                  children: [
                    Container(
                        width: (MediaQuery.of(context).size.width / 4) + 15,
                        child: Column(
                          children: [
                            if (_checkmargin)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    padding: EdgeInsets.all(3.0),
                                    // color: Theme.of(context).accentColor,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          3.0),
                                      color: ColorCodes.checkmarginColor,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 28,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      margins + S.of(context).off,//"% OFF",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Theme
                                              .of(context)
                                              .buttonColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 10,
                            ),

                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      // width: (MediaQuery
                      //     .of(context)
                      //     .size
                      //     .width / 2) - 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !_isStock
                              ? Consumer<CartCalculations>(
                            builder: (_, cart, ch) =>
                                BadgeOfStock(
                                  child: ch,
                                  value: margins,
                                  singleproduct: false,
                                ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SingleproductScreen.routeName,
                                    arguments: {
                                      "itemid": widget.id,
                                      "itemname": widget.title,
                                      "itemimg": widget.imageUrl,
                                    });
                              },
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                placeholder: (context, url) =>
                                    Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                errorWidget: (context, url, error) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  SingleproductScreen.routeName,
                                  arguments: {
                                    "itemid": widget.id,
                                    "itemname": widget.title,
                                    "itemimg": widget.imageUrl,
                                  });
                            },
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                              errorWidget: (context, url, error) => Image.asset(
                                Images.defaultProductImg,
                                width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              ),
                              width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding:EdgeInsets.only(left: 10),
                          // width: (MediaQuery
                          //     .of(context)
                          //     .size
                          //     .width / 2) + 60,
                          child: Column(
                            children: [
                              Container(
                                // width: (MediaQuery
                                //     .of(context)
                                //     .size
                                //     .width / 4) + 15,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.brand,
                                                style: TextStyle(
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 12, color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if(Features.isMembership)
                                        Container(
                                            child: Row(
                                              children: <Widget>[
                                                _checkmembership
                                                    ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 25.0,
                                                      height: 25.0,
                                                      child: Image.asset(
                                                        Images.starImg,
                                                      ),
                                                    ),
                                                    memberpriceDisplay
                                                        ? new RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                                          new TextSpan(
                                                              text:
                                                             // S.of(context).membership_price//"Membership Price "
                                                                  IConstants.currencyFormat +
                                                                  varmemberprice,
                                                              style: new TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color:
                                                                Colors.black,
                                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                          new TextSpan(
                                                              text:
                                                              IConstants.currencyFormat +
                                                                  '$varmrp ',
                                                              style: TextStyle(
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                        : discountDisplay
                                                        ? new RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text: IConstants.currencyFormat +
                                                                  '$varprice ',
                                                              style: new TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                          new TextSpan(
                                                              text:
                                                              IConstants.currencyFormat +
                                                                  '$varmrp ',
                                                              style: TextStyle(
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                        : new RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text:
                                                              IConstants.currencyFormat +
                                                                  '$varmrp ',
                                                              style: new TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                                    : discountDisplay
                                                    ? new RichText(
                                                  text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varprice ',
                                                          style: new TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: TextStyle(
                                                            decoration: TextDecoration
                                                                .lineThrough,
                                                          )),
                                                    ],
                                                  ),
                                                )
                                                    : new RichText(
                                                  text: new TextSpan(
                                                    style: new TextStyle(
                                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text: IConstants.currencyFormat +
                                                              '$varmrp ',
                                                          style: new TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                if(double.parse(varLoyalty.toString()) > 0)
                                                  Container(
                                                    padding: EdgeInsets.only(right: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Image.asset(Images.coinImg,
                                                          height: 15.0,
                                                          width: 20.0,),
                                                        SizedBox(width: 4),
                                                        Text(varLoyalty.toString()),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            )),
                                      SizedBox(
                                        height: 10,
                                      ),


                                    ],
                                  )),
                              SizedBox(
                                width: 10,
                              ),

                            ],
                          ),
                        ),
//                SizedBox(height: 10,),
                        Column(
                          children: [
                            Container(
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2) + 40,

                              child: Column(
                                children: [
                                  Container(

                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 4) + 15,
                                    padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                                    child: _varlength
                                        ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showoptions();
                                        });

                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    topLeft:
                                                    const Radius.circular(2.0),
                                                    bottomLeft:
                                                    const Radius.circular(2.0),
                                                  )),
                                              height: 30,
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 4.5, 0.0, 4.5),
                                              child: Text(
                                                "$varname",
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: ColorCodes.greenColor,
                                                borderRadius: new BorderRadius.only(
                                                  topRight:
                                                  const Radius.circular(2.0),
                                                  bottomRight:
                                                  const Radius.circular(2.0),
                                                )),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorCodes.greenColor,),
                                                borderRadius: new BorderRadius.only(
                                                  topLeft:
                                                  const Radius.circular(2.0),
                                                  topRight:
                                                  const Radius.circular(2.0),
                                                  bottomLeft:
                                                  const Radius.circular(2.0),
                                                  bottomRight:
                                                  const Radius.circular(2.0),
                                                )),
                                            height: 30,
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 4.5, 0.0, 4.5),
                                            child: Text(
                                              "$varname",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _isStock
                                      ? Container(
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    height: 30.0,
                                    width: (MediaQuery.of(context).size.width / 4) + 15,
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                      Hive.box<Product>(productBoxName)
                                          .listenable(),
                                      builder: (context, Box<Product> box, _) {
                                        if (varQty <= 0)
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isAddToCart = true;
                                              });
                                              addToCart(int.parse(itemvarData[0].varminitem));
                                            },
                                            child: Container(
                                              height: 30.0,
                                              width: (MediaQuery.of(context).size.width / 4) + 15,
                                              decoration: new BoxDecoration(
                                                  color: ColorCodes.greenColor,
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    topLeft:
                                                    const Radius.circular(2.0),
                                                    topRight:
                                                    const Radius.circular(2.0),
                                                    bottomLeft:
                                                    const Radius.circular(2.0),
                                                    bottomRight:
                                                    const Radius.circular(2.0),
                                                  )),
                                              child: _isAddToCart ?
                                              Center(
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                              )
                                                  :
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Center(
                                                      child: Text(
                                                        S.of(context).add,//'ADD',
                                                        style: TextStyle(
                                                          color: Theme
                                                              .of(context)
                                                              .buttonColor,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                  Spacer(),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: ColorCodes.cartgreenColor,
                                                        borderRadius:
                                                        new BorderRadius.only(
                                                          topLeft:
                                                          const Radius.circular(
                                                              2.0),
                                                          bottomLeft:
                                                          const Radius.circular(
                                                              2.0),
                                                          topRight:
                                                          const Radius.circular(
                                                              2.0),
                                                          bottomRight:
                                                          const Radius.circular(
                                                              2.0),
                                                        )),
                                                    height: 30,
                                                    width: 25,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        else
                                          return Container(
                                            child: Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      _isAddToCart = true;
                                                      incrementToCart(varQty - 1);
                                                    });
                                                  },
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: new BoxDecoration(
                                                          border: Border.all(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                          borderRadius:
                                                          new BorderRadius.only(
                                                            bottomLeft: const Radius
                                                                .circular(2.0),
                                                            topLeft: const Radius
                                                                .circular(2.0),
                                                          )),
                                                      child: Center(
                                                        child: Text(
                                                          "-",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: _isAddToCart ?
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: ColorCodes.greenColor,
                                                    ),
                                                    height: 30,
                                                    padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                                                    child: Center(
                                                      child: SizedBox(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          child: new CircularProgressIndicator(
                                                            strokeWidth: 2.0,
                                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                                    ),
                                                  )
                                                      :
                                                  Container(
//                                            width: 40,
                                                      decoration: BoxDecoration(
                                                        color: ColorCodes.greenColor,
                                                      ),
                                                      height: 30,
                                                      child: Center(
                                                        child: Text(
                                                          varQty.toString(),
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme
                                                                .of(context)
                                                                .buttonColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (varQty < int.parse(varstock)) {
                                                      if (varQty < int.parse(varmaxitem)) {
                                                        setState(() {
                                                          _isAddToCart = true;
                                                        });
                                                        incrementToCart(varQty + 1);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                            fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                            backgroundColor:
                                                            Colors.black87,
                                                            textColor:
                                                            Colors.white);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                          S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                          fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                          backgroundColor:
                                                          Colors.black87,
                                                          textColor: Colors.white);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: new BoxDecoration(
                                                          border: Border.all(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                          borderRadius:
                                                          new BorderRadius.only(
                                                            bottomRight:
                                                            const Radius
                                                                .circular(2.0),
                                                            topRight: const Radius
                                                                .circular(2.0),
                                                          )),
                                                      child: Center(
                                                        child: Text(
                                                          "+",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          );

                                        /*try {
                                  Product item = Hive
                                      .box<Product>(
                                      productBoxName)
                                      .values
                                      .firstWhere((value) =>
                                  value.varId == int.parse(varid));
                                  return Container(
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _isAddToCart = true;
                                              incrementToCart(item.itemQty - 1);
                                            });
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: new BoxDecoration(
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    bottomLeft: const Radius
                                                        .circular(2.0),
                                                    topLeft: const Radius
                                                        .circular(2.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  "-",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child: _isAddToCart ?
                                          Container(
                                            decoration: BoxDecoration(
                                              color: ColorCodes.greenColor,
                                            ),
                                            height: 30,
                                            padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                                            child: Center(
                                              child: SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child: new CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                            ),
                                          )
                                              :
                                          Container(
//                                            width: 40,
                                              decoration: BoxDecoration(
                                                color: ColorCodes.greenColor,
                                              ),
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  item.itemQty.toString(),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Theme
                                                        .of(context)
                                                        .buttonColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (item.itemQty < int.parse(varstock)) {
                                              if (item.itemQty < int.parse(varmaxitem)) {
                                                setState(() {
                                                  _isAddToCart = true;
                                                });
                                                incrementToCart(item.itemQty + 1);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                    backgroundColor:
                                                    Colors.black87,
                                                    textColor:
                                                    Colors.white);
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                  backgroundColor:
                                                  Colors.black87,
                                                  textColor: Colors.white);
                                            }
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: new BoxDecoration(
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    bottomRight:
                                                    const Radius
                                                        .circular(2.0),
                                                    topRight: const Radius
                                                        .circular(2.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  "+",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (e) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isAddToCart = true;
                                      });
                                      addToCart(int.parse(itemvarData[0].varminitem));
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          4) +
                                          15,
                                      decoration: new BoxDecoration(
                                          color: ColorCodes.greenColor,
                                          borderRadius:
                                          new BorderRadius.only(
                                            topLeft:
                                            const Radius.circular(2.0),
                                            topRight:
                                            const Radius.circular(2.0),
                                            bottomLeft:
                                            const Radius.circular(2.0),
                                            bottomRight:
                                            const Radius.circular(2.0),
                                          )),
                                      child: _isAddToCart ?
                                      Center(
                                        child: SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: new CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                      )
                                          : Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Center(
                                              child: Text(
                                                S.of(context).add,//'ADD',
                                                style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .buttonColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: ColorCodes.cartgreenColor,
                                                borderRadius:
                                                new BorderRadius.only(
                                                  topLeft:
                                                  const Radius.circular(
                                                      2.0),
                                                  bottomLeft:
                                                  const Radius.circular(
                                                      2.0),
                                                  topRight:
                                                  const Radius.circular(
                                                      2.0),
                                                  bottomRight:
                                                  const Radius.circular(
                                                      2.0),
                                                )),
                                            height: 30,
                                            width: 25,
                                            child: Icon(
                                              Icons.add,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }*/
                                      },
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg: /*"You will be notified via SMS/Push notification, when the product is available"*/  S.of(context).out_of_stock,//"Out Of Stock",
                                          fontSize: MediaQuery.of(context).textScaleFactor *13,
                                          backgroundColor: Colors.black87,
                                          textColor: Colors.white);
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width:
                                      (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 4) +
                                          15,
                                      decoration: new BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          color: Colors.grey,
                                          borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(2.0),
                                            topRight: const Radius.circular(2.0),
                                            bottomLeft: const Radius.circular(2.0),
                                            bottomRight: const Radius.circular(2.0),
                                          )),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Center(
                                              child: Text(
                                                S.of(context).notify_me,//'Notify Me',
                                                /*"ADD",*/
                                                style: TextStyle(
                                                  /*fontWeight: FontWeight.w700,*/
                                                    color:
                                                    Colors
                                                        .white /*Colors.black87*/),
                                                textAlign: TextAlign.center,
                                              )),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: new BorderRadius.only(
                                                  topRight:
                                                  const Radius.circular(2.0),
                                                  bottomRight:
                                                  const Radius.circular(2.0),
                                                )),
                                            height: 30,
                                            width: 25,
                                            child: Icon(
                                              Icons.add,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        !_checkmembership
                            ? membershipdisplay
                            ? SizedBox(
                          height: 10,
                        )
                            : SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        if(Features.isMembership)
                          Row(
                            children: [
                              !_checkmembership
                                  ? membershipdisplay
                                  ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    MembershipScreen.routeName,
                                  );
                                },
                                child: Container(
                                  height: 25,
                                  width: (MediaQuery.of(context).size.width/6.1) ,
                                  decoration: BoxDecoration(color: Color(0xffefef47)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10),
                                      Image.asset(
                                        Images.starImg,
                                        height: 12,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                          IConstants.currencyFormat +
                                              varmemberprice,
                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,)),
                                      Spacer(),
                                      Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      SizedBox(width: 2),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                //)



                              )
                                  : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }
            else{
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Color(0xFFCFCFCF)),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5),
                child: Row(
                  children: [
                    //image
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !_isStock
                              ? Consumer<CartCalculations>(
                            builder: (_, cart, ch) =>
                                BadgeOfStock( value: margins, singleproduct: false,
                                  child: ch,
                                ),
                            child: GestureDetector(onTap: () {Navigator.of(context).pushNamed(SingleproductScreen.routeName, arguments: {
                              "itemid": widget.id,
                              "itemname": widget.title,
                              "itemimg": widget.imageUrl,
                            });},
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                placeholder: (context, url) =>
                                    Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                errorWidget: (context, url, error) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  SingleproductScreen.routeName,
                                  arguments: {
                                    "itemid": widget.id,
                                    "itemname": widget.title,
                                    "itemimg": widget.imageUrl,
                                  });
                            },
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                              errorWidget: (context, url, error) => Image.asset(
                                Images.defaultProductImg,
                                width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              ),
                              width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) + 60,
                          child: Row(
                            children: [
                              Container(
                                  width: (MediaQuery.of(context).size.width / 4) + 15,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.brand,
                                                style: TextStyle(
                                                    fontSize: 10, color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  //fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                          child: Row(
                                            children: <Widget>[
                                              _checkmembership
                                                  ? Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 10.0,
                                                    height: 9.0,
                                                    margin: EdgeInsets.only(right: 3.0),
                                                    child: Image.asset(
                                                      Images.starImg,
                                                    ),
                                                  ),
                                                  memberpriceDisplay
                                                      ? new RichText(
                                                    text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                                        new TextSpan(
                                                            text: IConstants.currencyFormat +
                                                                varmemberprice,
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color:
                                                                Colors.black,
                                                                fontSize: 18.0)),
                                                        new TextSpan(
                                                            text:
                                                            IConstants.currencyFormat + '$varmrp ',
                                                            style: TextStyle(
                                                              decoration: TextDecoration.lineThrough,
                                                            )),
                                                      ],
                                                    ),
                                                  )
                                                      : discountDisplay
                                                      ? new RichText(
                                                    text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                            text: IConstants.currencyFormat + '$varprice ',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 18.0)),
                                                        new TextSpan(
                                                            text:
                                                            IConstants.currencyFormat + '$varmrp ',
                                                            style: TextStyle(
                                                              decoration:
                                                              TextDecoration.lineThrough,
                                                            )),
                                                      ],
                                                    ),
                                                  )
                                                      : new RichText(
                                                    text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                            text:
                                                            IConstants.currencyFormat + '$varmrp ',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 18.0)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                                  : discountDisplay
                                                  ? new RichText(
                                                text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: IConstants.currencyFormat + '$varprice ',
                                                        style: new TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 18.0)),
                                                    new TextSpan(
                                                        text: IConstants.currencyFormat + '$varmrp ',
                                                        style: TextStyle(
                                                          decoration: TextDecoration.lineThrough,
                                                        )),
                                                  ],
                                                ),
                                              )
                                                  : new RichText(
                                                text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: IConstants.currencyFormat + '$varmrp ',
                                                        style: new TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 18.0)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: (MediaQuery.of(context).size.width / 4) + 15,
                                  child: Column(
                                    children: [
                                      if (_checkmargin)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5.0),
                                              padding: EdgeInsets.all(3.0),
                                              // color: Theme.of(context).accentColor,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    3.0),
                                                color: ColorCodes.checkmarginColor,
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 28,
                                                minHeight: 18,
                                              ),
                                              child: Text(
                                                margins + S.of(context).off,//"% OFF",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context).buttonColor,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      if(double.parse(varLoyalty.toString()) > 0)
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Image.asset(Images.coinImg,
                                                height: 15.0,
                                                width: 20.0,),
                                              SizedBox(width: 4),
                                              Text(varLoyalty.toString()),
                                            ],
                                          ),
                                        ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
//                SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2) + 40,
                              child: Row(
                                children: [
                                  Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 4) + 15,
                                    child: _varlength
                                        ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showoptions();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    topLeft:
                                                    const Radius.circular(2.0),
                                                    bottomLeft:
                                                    const Radius.circular(2.0),
                                                  )),
                                              height: 30,
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 4.5, 0.0, 4.5),
                                              child: Text(
                                                "$varname",
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: ColorCodes.greenColor,
                                                borderRadius: new BorderRadius.only(
                                                  topRight:
                                                  const Radius.circular(2.0),
                                                  bottomRight:
                                                  const Radius.circular(2.0),
                                                )),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorCodes.greenColor,),
                                                borderRadius: new BorderRadius.only(
                                                  topLeft:
                                                  const Radius.circular(2.0),
                                                  topRight:
                                                  const Radius.circular(2.0),
                                                  bottomLeft:
                                                  const Radius.circular(2.0),
                                                  bottomRight:
                                                  const Radius.circular(2.0),
                                                )),
                                            height: 30,
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 4.5, 0.0, 4.5),
                                            child: Text(
                                              "$varname",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _isStock
                                      ? Container(
                                    height: 30.0,
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 4) +
                                        15,
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                      Hive.box<Product>(productBoxName)
                                          .listenable(),
                                      builder: (context, Box<Product> box, _) {
                                        if (varQty <= 0)
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isAddToCart = true;
                                              });
                                              addToCart(int.parse(itemvarData[0].varminitem));
                                            },
                                            child: Container(
                                              height: 30.0,
                                              width: (MediaQuery.of(context).size.width / 4) + 15,
                                              decoration: new BoxDecoration(
                                                  color: ColorCodes.greenColor,
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    topLeft:
                                                    const Radius.circular(2.0),
                                                    topRight:
                                                    const Radius.circular(2.0),
                                                    bottomLeft:
                                                    const Radius.circular(2.0),
                                                    bottomRight:
                                                    const Radius.circular(2.0),
                                                  )),
                                              child: _isAddToCart ?
                                              Center(
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                              )
                                                  : Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Center(
                                                      child: Text(
                                                        S.of(context).add,//'ADD',
                                                        style: TextStyle(
                                                          color: Theme
                                                              .of(context)
                                                              .buttonColor,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                  Spacer(),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: ColorCodes.cartgreenColor,
                                                        borderRadius:
                                                        new BorderRadius.only(
                                                          topLeft:
                                                          const Radius.circular(
                                                              2.0),
                                                          bottomLeft:
                                                          const Radius.circular(
                                                              2.0),
                                                          topRight:
                                                          const Radius.circular(
                                                              2.0),
                                                          bottomRight:
                                                          const Radius.circular(
                                                              2.0),
                                                        )),
                                                    height: 30,
                                                    width: 25,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        else
                                          return Container(
                                            child: Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      _isAddToCart = true;
                                                      incrementToCart(varQty - 1);
                                                    });
                                                  },
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: new BoxDecoration(
                                                          border: Border.all(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                          borderRadius:
                                                          new BorderRadius.only(
                                                            bottomLeft: const Radius
                                                                .circular(2.0),
                                                            topLeft: const Radius
                                                                .circular(2.0),
                                                          )),
                                                      child: Center(
                                                        child: Text(
                                                          "-",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: _isAddToCart ?
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: ColorCodes.greenColor,
                                                    ),
                                                    height: 30,
                                                    padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                                                    child: Center(
                                                      child: SizedBox(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          child: new CircularProgressIndicator(
                                                            strokeWidth: 2.0,
                                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                                    ),
                                                  )
                                                      :
                                                  Container(
//                                            width: 40,
                                                      decoration: BoxDecoration(
                                                        color: ColorCodes.greenColor,
                                                      ),
                                                      height: 30,
                                                      child: Center(
                                                        child: Text(
                                                          varQty.toString(),
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme
                                                                .of(context)
                                                                .buttonColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (varQty < int.parse(varstock)) {
                                                      if (varQty < int.parse(varmaxitem)) {
                                                        setState(() {
                                                          _isAddToCart = true;
                                                        });
                                                        incrementToCart(varQty + 1);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                            fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                            backgroundColor:
                                                            Colors.black87,
                                                            textColor:
                                                            Colors.white);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                          S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                          fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                          backgroundColor:
                                                          Colors.black87,
                                                          textColor: Colors.white);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: new BoxDecoration(
                                                          border: Border.all(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                          borderRadius:
                                                          new BorderRadius.only(
                                                            bottomRight:
                                                            const Radius
                                                                .circular(2.0),
                                                            topRight: const Radius
                                                                .circular(2.0),
                                                          )),
                                                      child: Center(
                                                        child: Text(
                                                          "+",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          );

                                        /*try {
                                  Product item = Hive
                                      .box<Product>(
                                      productBoxName)
                                      .values
                                      .firstWhere((value) =>
                                  value.varId == int.parse(varid));
                                  return Container(
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _isAddToCart = true;
                                              incrementToCart(item.itemQty - 1);
                                            });
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: new BoxDecoration(
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    bottomLeft: const Radius
                                                        .circular(2.0),
                                                    topLeft: const Radius
                                                        .circular(2.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  "-",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child: _isAddToCart ?
                                          Container(
                                            decoration: BoxDecoration(
                                              color: ColorCodes.greenColor,
                                            ),
                                            height: 30,
                                            padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                                            child: Center(
                                              child: SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child: new CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                            ),
                                          )
                                              :
                                          Container(
//                                            width: 40,
                                              decoration: BoxDecoration(
                                                color: ColorCodes.greenColor,
                                              ),
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  item.itemQty.toString(),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Theme
                                                        .of(context)
                                                        .buttonColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (item.itemQty < int.parse(varstock)) {
                                              if (item.itemQty < int.parse(varmaxitem)) {
                                                setState(() {
                                                  _isAddToCart = true;
                                                });
                                                incrementToCart(item.itemQty + 1);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Sorry, you can\'t add more of this item!",
                                                    backgroundColor:
                                                    Colors.black87,
                                                    textColor:
                                                    Colors.white);
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                  backgroundColor:
                                                  Colors.black87,
                                                  textColor: Colors.white);
                                            }
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: new BoxDecoration(
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                  borderRadius:
                                                  new BorderRadius.only(
                                                    bottomRight:
                                                    const Radius
                                                        .circular(2.0),
                                                    topRight: const Radius
                                                        .circular(2.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  "+",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (e) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isAddToCart = true;
                                      });
                                      addToCart(int.parse(itemvarData[0].varminitem));
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: (MediaQuery.of(context).size.width / 4) + 15,
                                      decoration: new BoxDecoration(
                                          color: ColorCodes.greenColor,
                                          borderRadius:
                                          new BorderRadius.only(
                                            topLeft: const Radius.circular(2.0),
                                            topRight: const Radius.circular(2.0),
                                            bottomLeft: const Radius.circular(2.0),
                                            bottomRight: const Radius.circular(2.0),
                                          )),
                                      child: _isAddToCart ?
                                      Center(
                                        child: SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: new CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
                                      )
                                          :
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Center(
                                              child: Text(
                                                S.of(context).add,//'ADD',
                                                style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .buttonColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: ColorCodes.cartgreenColor,
                                                borderRadius:
                                                new BorderRadius.only(
                                                  topLeft:
                                                  const Radius.circular(
                                                      2.0),
                                                  bottomLeft:
                                                  const Radius.circular(
                                                      2.0),
                                                  topRight:
                                                  const Radius.circular(
                                                      2.0),
                                                  bottomRight:
                                                  const Radius.circular(
                                                      2.0),
                                                )),
                                            height: 30,
                                            width: 25,
                                            child: Icon(
                                              Icons.add,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }*/
                                      },
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg: /*"You will be notified via SMS/Push notification, when the product is available"*/  S.of(context).out_of_stock,//"Out Of Stock",
                                          fontSize: MediaQuery.of(context).textScaleFactor *13,
                                          backgroundColor: Colors.black87,
                                          textColor: Colors.white);
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width:
                                      (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 4) +
                                          15,
                                      decoration: new BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          color: Colors.grey,
                                          borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(2.0),
                                            topRight: const Radius.circular(2.0),
                                            bottomLeft: const Radius.circular(2.0),
                                            bottomRight: const Radius.circular(2.0),
                                          )),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Center(
                                              child: Text(
                                                S.of(context).notify_me,//'Notify Me',
                                               /* "ADD",*/
                                                style: TextStyle(
                                                  /*fontWeight: FontWeight.w700,*/
                                                    color:
                                                    Colors
                                                        .white /*Colors.black87*/),
                                                textAlign: TextAlign.center,
                                              )),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: new BorderRadius.only(
                                                  topRight:
                                                  const Radius.circular(2.0),
                                                  bottomRight:
                                                  const Radius.circular(2.0),
                                                )),
                                            height: 30,
                                            width: 25,
                                            child: Icon(
                                              Icons.add,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        !_checkmembership
                            ? membershipdisplay
                            ? SizedBox(
                          height: 8,
                        )
                            : SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        if(Features.isMembership)
                          Row(
                            children: [
                              !_checkmembership
                                  ? membershipdisplay
                                  ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    MembershipScreen.routeName,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 5, top: 5.0),
                                  width: (MediaQuery.of(context).size.width / 2) + 40,
                                  decoration:
                                  BoxDecoration(color: Color(0xffefef47)),
                                  child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10),
                                      Image.asset(
                                        Images.starImg,
                                        height: 12,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        IConstants.currencyFormat +
                                              varmemberprice,
                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,)),
                                      Spacer(),
                                      Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      SizedBox(width: 2),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              )
                                  : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }else{
            return SizedBox.shrink();
          };

        }

    );

  }
}


