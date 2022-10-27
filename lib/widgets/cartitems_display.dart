import 'dart:io';

import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../controller/mutations/cart_mutation.dart';
import '../generated/l10n.dart';

import '../constants/IConstants.dart';

import '../blocs/cart_item_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../providers/myorderitems.dart';
import '../screens/bloc.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/hiveDB.dart';
import '../main.dart';
import '../assets/images.dart';
import '../screens/signup_selection_screen.dart';
import '../utils/prefUtils.dart';

class CartitemsDisplay extends StatefulWidget {


  Function isdbonprocess ;

  var onempty;

  CartItem snapshot;

  CartitemsDisplay(this.snapshot,
      {this.onempty});

  @override
  _CartitemsDisplayState createState() => _CartitemsDisplayState();
}

class _CartitemsDisplayState extends State<CartitemsDisplay> {
  // Box<Product> productBox;
  bool _isAddToCart = false;
  var checkmembership = false;
  String _itemPrice = "";
  String _itemPrice1 = "";
  String _itemPrice2 = "";
  bool _checkMembership = false;
  //SharedPreferences prefs;
  bool _isLoading = true;
  HomeDisplayBloc _bloc;
  bool iphonex = false;
  bool _isaddOn = false;

  bool isSelect = true;


  @override
  void initState() {
    _bloc = HomeDisplayBloc();

    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

      if(widget.snapshot.addOn.toString() == "0"){
        _isaddOn = true;
      }
      else{
        _isaddOn = false;
      }
      debugPrint("wishlist....."+widget.snapshot.wishlist.toString());
      if(widget.snapshot.wishlist == 1) {
        isSelect = true;
      } else {
        isSelect = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.snapshot.mode == "1") {
    //   checkmembership = true;
    // } else {
    //   checkmembership = false;
    // }

    if (!_isLoading) if (/*PrefUtils.prefs.getString("membership")*/(VxState.store as GroceStore).userData.membership == "1") {
      _checkMembership = true;
    } else {
      _checkMembership = false;
    }


    if (_checkMembership) {
      if (widget.snapshot.membershipPrice == '-' || widget.snapshot.membershipPrice == "0") {
        if (double.parse(widget.snapshot.price) <= 0 ||
            widget.snapshot.price.toString() == "") {
          _itemPrice = widget.snapshot.varMrp;
        } else {
          _itemPrice = widget.snapshot.price;
        }
      } else {
        _itemPrice = widget.snapshot.membershipPrice;
      }
    } else {
      if (double.parse(widget.snapshot.price) <= 0 ||
          widget.snapshot.price.toString() == "") {
        _itemPrice = widget.snapshot.varMrp;
      } else {
        _itemPrice = widget.snapshot.price;
      }
    }

    updateCart(int qty,CartStatus cart,String varid){
      switch(cart){

        case CartStatus.increment:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:( qty+1).toString(),var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:"0",var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.decrement:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:((qty)<= int.parse(widget.snapshot.varMinItem))?"0":(qty-1).toString(),var_id: varid);

          // TODO: Handle this case.
          break;
      }
    }
    debugPrint("kcn gv" + widget.snapshot.itemImage.toString());
    debugPrint("stock status"+widget.snapshot.status.toString()+"and stock var:${widget.snapshot.varStock}");
    return
      //_isaddOn?
      Container(
        // color: Colors.white,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorCodes.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12)
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  checkmembership
                      ? Image.asset(
                    Images.membershipImg,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    color: Theme.of(context).primaryColor,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Container(
                      width: 100,
                      height: 120,
                      child: FadeInImage(
                        image: NetworkImage(widget.snapshot.itemImage??""),
                        placeholder: AssetImage(
                          Images.defaultProductImg,
                        ),
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.snapshot.itemName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      widget.snapshot.fit,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: ColorCodes.grey),
                                    )),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: ColorCodes.greyColor
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Spacer(),
                                      Text(
                                        "Size :",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: ColorCodes.grey),
                                      ),
                                      //SizedBox(width: 5),
                                      Text(
                                        widget.snapshot.varName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: ColorCodes.blackColor),
                                      ),
                                      SizedBox(width: 5),
                                      //Spacer(),
                                    ],
                                  ),
                                ),
                                Spacer(),

                                // SizedBox(
                                //   width: 5,
                                // ),
                                Container(
                                  // padding: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: ColorCodes.greyColor
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                                    children: [
                                      (double.parse(widget.snapshot.varStock) == 0 || widget.snapshot.status == "1") ? Text(
                                        double.parse(widget.snapshot.varStock) == 0 ? S.of(context).out_of_stock/*"Out Of Stock"*/ : S.of(context).unavailable,/*"Unavailable"*/
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                      )
                                          :
                                      VxBuilder(builder: (context, store,state){
                                        final box = store.CartItemList;
                                        if(box.isNotEmpty){
                                          if(box.isNotEmpty){

                                            return Row(

                                              children: <Widget>[
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () async {
                                                    if (int.parse(widget.snapshot.quantity) <= int.parse(widget.snapshot.varMinItem)) {
                                                      setState(() {
                                                        updateCart(int.parse(widget.snapshot.quantity), CartStatus.decrement, widget.snapshot.varId.toString());

                                                      });
                                                    } else {
                                                      setState(() {
                                                        updateCart(int.parse(widget.snapshot.quantity), CartStatus.decrement, widget.snapshot.varId.toString());
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                      width: 30,
                                                      height: 35,
                                                      child: Center(
                                                        child: Text(
                                                          "-",
                                                          textAlign: TextAlign.center,
                                                          style:
                                                          TextStyle(fontSize: 20, color: ColorCodes.blackColor),
                                                        ),
                                                      )),
                                                ),

                                                _isAddToCart ?
                                                Container(
                                                  width: 35,
                                                  height: 25,
                                                  padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                                  child: SizedBox(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      child: new CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
                                                )
                                                    :
                                                Container(
                                                    width: 35,
                                                    height: 30,
                                                    // decoration: BoxDecoration(color: Colors.green,border: Border.),
                                                    child: Center(
                                                      child: Text(
                                                        widget.snapshot.quantity.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: ColorCodes.blackColor,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    )),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {
                                                    if (double.parse(widget.snapshot.quantity) < int.parse(widget.snapshot.varStock)) {
                                                      if (double.parse(widget.snapshot.quantity) < int.parse(widget.snapshot.varMaxItem)) {

                                                        updateCart(int.parse(widget.snapshot.quantity), CartStatus.increment, widget.snapshot.varId);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                                                            fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                            backgroundColor: Colors.black87,
                                                            textColor: Colors.white);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                                                          fontSize: MediaQuery.of(context).textScaleFactor *13,
                                                          backgroundColor: Colors.black87,
                                                          textColor: Colors.white);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "+",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle( fontSize: 20,
                                                              color: ColorCodes.blackColor
                                                            //color: Theme.of(context).buttonColor,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            );
                                          }else{
                                            widget.onempty;
                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: ColorCodes.greenColor,
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: ColorCodes.greenColor),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: ColorCodes.greenColor),
                                                        left: BorderSide(
                                                            width: 1.0, color: ColorCodes.greenColor),
                                                      ),
                                                    ),
                                                    width: 30,
                                                    height: 25,
                                                    child: Center(
                                                      child: Text(
                                                        "-",
                                                        textAlign: TextAlign.center,
                                                        style:
                                                        TextStyle(color: ColorCodes.whiteColor),
                                                      ),
                                                    )),
                                                Container(
                                                  width: 35,
                                                  height: 25,
                                                  padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                                  child: SizedBox(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      child: new CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
                                                ),
                                                Container(
                                                    width: 30,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      color: ColorCodes.greenColor,
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: ColorCodes.greenColor),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: ColorCodes.greenColor),
                                                        right: BorderSide(
                                                            width: 1.0, color: ColorCodes.greenColor),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "+",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: ColorCodes.whiteColor
                                                          //color: Theme.of(context).buttonColor,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            );
                                          }
                                        }else if(box.isEmpty){
                                          widget.onempty;
                                          return Row(
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      bottom: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      left: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                    ),
                                                  ),
                                                  width: 30,
                                                  height: 25,
                                                  child: Center(
                                                    child: Text(
                                                      "-",
                                                      textAlign: TextAlign.center,
                                                      style:
                                                      TextStyle(color: ColorCodes.whiteColor),
                                                    ),
                                                  )),
                                              Container(
                                                width: 35,
                                                height: 25,
                                                padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
                                              ),
                                              Container(
                                                  width: 30,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      bottom: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      right: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "+",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: ColorCodes.whiteColor
                                                        //color: Theme.of(context).buttonColor,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          );
                                        }else {
                                          Future.delayed(Duration.zero).then((value) => widget.onempty);
                                          return Row(
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      bottom: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      left: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                    ),
                                                  ),
                                                  width: 30,
                                                  height: 25,
                                                  child: Center(
                                                    child: Text(
                                                      "-",
                                                      textAlign: TextAlign.center,
                                                      style:
                                                      TextStyle(color: ColorCodes.whiteColor),
                                                    ),
                                                  )),
                                              Container(
                                                width: 35,
                                                height: 25,
                                                padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
                                              ),
                                              Container(
                                                  width: 30,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      bottom: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                      right: BorderSide(
                                                          width: 1.0, color: ColorCodes.greenColor),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "+",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: ColorCodes.whiteColor
                                                        //color: Theme.of(context).buttonColor,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          );
                                        }
                                      }, mutations: {SetCartItem}),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text((double.parse(widget.snapshot.quantity) == 0 || widget.snapshot.status.toString() == "0") ?
                                IConstants.numberFormat == "1"?IConstants.currencyFormat  + ' ' + (double.parse(widget.snapshot.price)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(0):
                                IConstants.currencyFormat  + ' ' + (double.parse(widget.snapshot.price)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(IConstants.decimaldigit)
                                    :
                                IConstants.numberFormat == "1"?IConstants.currencyFormat  + ' ' + (double.parse(widget.snapshot.price)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(0):IConstants.currencyFormat + ' ' + (double.parse(widget.snapshot.price)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(IConstants.decimaldigit),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 17)),
                                SizedBox(width: 10),
                                Text((double.parse(widget.snapshot.quantity) == 0 || widget.snapshot.status.toString() == "0") ?
                                IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + (double.parse(widget.snapshot.varMrp)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(0):
                                IConstants.currencyFormat + ' ' + (double.parse(widget.snapshot.varMrp)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(IConstants.decimaldigit)
                                    :
                                IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + (double.parse(widget.snapshot.varMrp)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(0):IConstants.currencyFormat + ' ' + ' ' + (double.parse(widget.snapshot.varMrp)*(double.parse(widget.snapshot.quantity))).toStringAsFixed(IConstants.decimaldigit),
                                    style: TextStyle(
                                        decoration:
                                        TextDecoration.lineThrough,
                                        color: ColorCodes.grey,
                                        fontWeight: FontWeight.w800, fontSize: 13)),
                              ],
                            ),


                          ])),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  //color: ColorCodes.cyanColor,
                  border: Border.all(
                      width: 1.5,
                      color: ColorCodes.lightGreyColor
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: GestureDetector(
                            onTap: (){
                              // cartBloc.cartItems();
                              updateCart(int.parse(widget.snapshot.quantity), CartStatus.remove, widget.snapshot.varId.toString());
                            },
                            child: Text(
                              S.of(context).remove,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: ColorCodes.discountoff),
                            )),
                      ),
                    ),

                    Container(
                      height: 50.0,
                      child: VerticalDivider(
                        color: ColorCodes.lightGreyColor,
                        thickness: 1,
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width / 2.4,
                      child: Center(
                        child: GestureDetector(
                            onTap: (){
                              debugPrint("id...."+widget.snapshot.itemId.toString());
                              setState(() {
                                if (!PrefUtils.prefs.containsKey("apikey"))
                                {
                                  Navigator.of(context).pushNamed(
                                      SignupSelectionScreen.routeName,
                                      arguments: {
                                        "prev": "signupSelectionScreen",
                                      });
                                }
                                else {
                                  if (!isSelect) {
                                    Provider.of<MyorderList>(
                                        context, listen: false).AddWishList(
                                        widget.snapshot.itemId).then((value) {
                                      setState(() {
                                        isSelect = true;
                                      });
                                    });
                                    updateCart(int.parse(widget.snapshot.quantity),
                                        CartStatus.remove,
                                        widget.snapshot.varId.toString());
                                  }
                                  else {
                                    Provider.of<MyorderList>(
                                        context, listen: false).RemoveWishList(
                                        widget.snapshot.itemId).then((value) {
                                      setState(() {
                                        isSelect = false;
                                      });
                                    });
                                  }
                                }
                              });
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                (!PrefUtils.prefs.containsKey("apikey"))?S.of(context).move_to_list:(!isSelect)? S.of(context).move_to_list :"Added to Wishlist",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorCodes.blackColor),
                              ),
                            )),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      );
    //:SizedBox.shrink();

  }
}