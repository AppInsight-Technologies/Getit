import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../helper/custome_calculation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/newmodle/user.dart';
import '../../widgets/components/login_web.dart';
import '../../widgets/item_badge.dart';
import '../../widgets/item_variation.dart';
import '../../widgets/simmers/singel_item_of_list_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../blocs/cart_item_bloc.dart';
import '../../constants/api.dart';
import '../../generated/l10n.dart';
import '../../screens/signup_selection_screen.dart';
import '../../screens/subscribe_screen.dart';
import '../../services/firebaseAnaliticsService.dart';
import '../../constants/IConstants.dart';
import '../../screens/bloc.dart';
import '../../screens/cart_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/map_screen.dart';
import '../../screens/policy_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../providers/cartItems.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/features.dart';
import '../../main.dart';
import '../../widgets/badge_discount.dart';
import '../../providers/branditems.dart';
import '../../providers/itemslist.dart';
import '../../providers/sellingitems.dart';
import '../../screens/singleproduct_screen.dart';
import '../../screens/membership_screen.dart';
import '../../widgets/badge_ofstock.dart';
import '../../data/hiveDB.dart';
import '../../assets/images.dart';
import '../../utils/prefUtils.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../assets/ColorCodes.dart';
import '../../data/calculations.dart';
import 'package:http/http.dart' as http;

import '../custome_stepper.dart';

class Itemsv2 extends StatefulWidget {
  final String _fromScreen;
  final ItemData _itemdata;
  final UserData _customerDetail;
  Itemsv2(this._fromScreen, this._itemdata, this._customerDetail);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Itemsv2> {
  int itemindex = 0;
  var textcolor;
  bool _isNotify = false;
  bool _checkmembership = false;
  List<CartItem> productBox=[];

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    // if(widget._itemdata.priceVariation==null)
      print("item components of ${widget._itemdata.toJson().toString()}");

    super.initState();
  }
  Widget showoptions1() {
    (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return  Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                width: 800,
                //height: 200,
                padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                child: ItemVariation(widget._itemdata,ismember: widget._customerDetail.membership =="1",selectedindex: itemindex,onselect: (i){
                  setState(() {
                    itemindex = i;
                    // Navigator.of(context).pop();
                  });
                },),
              ),
            );
          });
        })
        .then((_) => setState(() { }))
    :showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ItemVariation(widget._itemdata,ismember: widget._customerDetail.membership =="1",selectedindex: itemindex,onselect: (i){
            setState(() {
              itemindex = i;
              // Navigator.of(context).pop();
            });
          },);
        })
        .then((_) => setState(() { }));
  }
  @override
  Widget build(BuildContext context) {
  double margins =  Calculate().getmargin(widget._itemdata.priceVariation[itemindex].mrp,widget._itemdata.priceVariation[itemindex].membershipDisplay? widget._itemdata.priceVariation[itemindex].membershipPrice: widget._itemdata.priceVariation[itemindex].price);
    // print("stock..."+widget._itemdata.priceVariation[itemindex].stock.toString());
    return Expanded(
      child: Container(
        width: 125.0,
        //height: MediaQuery.of(context).size.height,//aaaaaaaaaaaaaaaaaa
        child:Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 2.0, bottom: 5.0),
        /*  decoration: new BoxDecoration(
              color: Colors.white,
              //border: Border.all(color: Colors.black26),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10.0,
                    offset: Offset(0.0, 0.50)),
              ],
              borderRadius: new BorderRadius.only(
                topRight: const Radius.circular(2.0),
                topLeft: const Radius.circular(2.0),
                bottomLeft: const Radius.circular(2.0),
                bottomRight: const Radius.circular(2.0),
              )),*/
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Column(
                children: [
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.center,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          debugPrint("single product...."+{
                            "itemid": widget._itemdata.id,
                            "itemname": widget._itemdata.itemName,
                            "itemimg": widget._itemdata.itemFeaturedImage,
                            "eligibleforexpress": widget._itemdata.eligibleForExpress,
                            "delivery": widget._itemdata.delivery,
                            "duration": widget._itemdata.duration,
                            "durationType":widget._itemdata.deliveryDuration.durationType,
                            "note":widget._itemdata.deliveryDuration.note,
                            "fromScreen":widget._fromScreen,
                          }.toString());
                          Navigator.of(context).pushNamed(
                              SingleproductScreen.routeName,
                              arguments: {
                                "itemid": widget._itemdata.id,
                                "itemname": widget._itemdata.itemName,
                                "itemimg": widget._itemdata.itemFeaturedImage,
                                "eligibleforexpress": widget._itemdata.eligibleForExpress,
                                "delivery": widget._itemdata.delivery,
                                "duration": widget._itemdata.duration,
                                "durationType":widget._itemdata.deliveryDuration.durationType,
                                "note":widget._itemdata.deliveryDuration.note,
                                "fromScreen":widget._fromScreen,
                              });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: widget._itemdata.priceVariation[itemindex].images.length<=0?widget._itemdata.itemFeaturedImage:widget._itemdata.priceVariation[itemindex].images[0].image,
                            errorWidget: (context, url, error) => Image.asset(
                              Images.defaultProductImg,
                              width: ResponsiveLayout.isSmallScreen(context) ? 130 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              height: ResponsiveLayout.isSmallScreen(context) ? 145 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            ),
                            placeholder: (context, url) => Image.asset(
                              Images.defaultProductImg,
                              width: ResponsiveLayout.isSmallScreen(context) ? 130 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              height: ResponsiveLayout.isSmallScreen(context) ? 145 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            ),
                            width: ResponsiveLayout.isSmallScreen(context) ? 130 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            height: ResponsiveLayout.isSmallScreen(context) ? 145 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            //  fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              /*SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget._itemdata.brand,
                      style: TextStyle(
                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: Text(
                        widget._itemdata.itemName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                        TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),*/
              // Spacer(),
              SizedBox(height: 5,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 5.0,
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<Product>(productBoxName).listenable(),
                    builder: (context, Box<Product> box, index) {
                      if(PrefUtils.prefs.getString("membership") == "1"){
                        _checkmembership = true;
                      } else {
                        _checkmembership = false;
                        for (int i = 0; i < productBox.length; i++) {
                          if (productBox[i].mode == "1") {
                            _checkmembership = true;
                          }
                        }
                      }
                      return  Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if(Features.isMembership)
                            _checkmembership?Container(
                              width: 10.0,
                              height: 9.0,
                              margin: EdgeInsets.only(right: 3.0),
                              child: Image.asset(
                                Images.starImg,
                                color: ColorCodes.starColor,
                              ),
                            ):SizedBox.shrink(),

                          Center(
                            child: new RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                  new TextSpan(
                                      text: IConstants.currencyFormat + '${_checkmembership?widget._itemdata.priceVariation[itemindex].membershipPrice.toStringAsFixed(0):widget._itemdata.priceVariation[itemindex].price.toStringAsFixed(0)} ' +  " " ,
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 17 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                  new TextSpan(
                                      text: widget._itemdata.priceVariation[itemindex].membershipPrice!=widget._itemdata.priceVariation[itemindex].mrp.toStringAsFixed(0)?
                                      IConstants.currencyFormat + '${widget._itemdata.priceVariation[itemindex].mrp.toStringAsFixed(0)} ':"",
                                      style: TextStyle(
                                        decoration:
                                        TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w700,
                                        color: ColorCodes.greyColor,
                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  // Spacer(),
                  // if(Features.isLoyalty)
                  //   if(double.parse(widget._itemdata.priceVariation[itemindex].loyalty.toString()) > 0)
                  //     Container(
                  //       child: Row(
                  //         children: [
                  //           Image.asset(Images.coinImg,
                  //             height: 15.0,
                  //             width: 20.0,),
                  //           SizedBox(width: 4),
                  //           Text(widget._itemdata.priceVariation[itemindex].loyalty.toString()),
                  //         ],
                  //       ),
                  //     ),
                  // SizedBox(width: 10)
                ],
              ),
              SizedBox(
                height: 5,
              ),
             // ( widget._itemdata.priceVariation.length > 1)
             //      ? MouseRegion(
             //    cursor: SystemMouseCursors.click,
             //    child: GestureDetector(
             //      onTap: () {
             //         showoptions1();
             //      },
             //      child: Row(
             //        children: [
             //          SizedBox(
             //            width: 10.0,
             //          ),
             //          Expanded(
             //            child: Container(
             //              decoration: BoxDecoration(
             //                // border: Border.all(color: ColorCodes.greenColor),
             //                  color: ColorCodes.varcolor,
             //                  borderRadius: new BorderRadius.only(
             //                    topLeft: const Radius.circular(2.0),
             //                    bottomLeft: const Radius.circular(2.0),
             //                  )),
             //              height: 30,
             //              padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
             //              child: Text(
             //                "${widget._itemdata.priceVariation[itemindex].variationName}"+" "+"${widget._itemdata.priceVariation[itemindex].unit}",
             //                style: TextStyle(color: ColorCodes.darkgreen/*Colors.black*/,fontWeight: FontWeight.bold),
             //              ),
             //            ),
             //          ),
             //          Container(
             //            height: 30,
             //            decoration: BoxDecoration(
             //                color: ColorCodes.varcolor,
             //                borderRadius: new BorderRadius.only(
             //                  topRight: const Radius.circular(2.0),
             //                  bottomRight: const Radius.circular(2.0),
             //                )),
             //            child: Icon(
             //              Icons.keyboard_arrow_down,
             //              color: ColorCodes.darkgreen,
             //            ),
             //          ),
             //          SizedBox(
             //            width: 10.0,
             //          ),
             //        ],
             //      ),
             //    ),
             //  ) :
             //  Row(
             //    children: [
             //      SizedBox(
             //        width: 10.0,
             //      ),
             //      Expanded(
             //        child: Container(
             //          decoration: BoxDecoration(
             //              color: ColorCodes.varcolor,
             //              // border: Border.all(color: ColorCodes.greenColor),
             //              borderRadius: new BorderRadius.only(
             //                topLeft: const Radius.circular(2.0),
             //                topRight: const Radius.circular(2.0),
             //                bottomLeft: const Radius.circular(2.0),
             //                bottomRight: const Radius.circular(2.0),
             //              )),
             //          height: 30,
             //          padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
             //          child: Text(
             //            "${widget._itemdata.priceVariation[itemindex].variationName}"+" "+"${widget._itemdata.priceVariation[itemindex].unit}",
             //            style: TextStyle(color:ColorCodes.darkgreen,fontWeight: FontWeight.bold),
             //          ),
             //        ),
             //      ),
             //      SizedBox(
             //        width: 10.0,
             //      ),
             //    ],
             //  ),
             //  SizedBox(height: 5),

              (Features.isSubscription)?(widget._itemdata.eligibleForSubscription == "0")?
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: (widget._itemdata.priceVariation[itemindex].stock <= 0) ?
                SizedBox(height: 30,)
                    :GestureDetector(
                  onTap: () {
             //TODO: on click subscribe
                    if(!PrefUtils.prefs.containsKey("apikey"))
                    if(kIsWeb&&  !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.routeName, (route) => false);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }else{
                      Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                          arguments: {
                            "prev": "signupSelectionScreen",
                          }
                      );
                    }else{
                      Navigator.of(context).pushNamed(
                          SubscribeScreen.routeName,
                          arguments: {
                            "itemid": widget._itemdata.id,
                            "itemname": widget._itemdata.itemName,
                            "itemimg": widget._itemdata.itemFeaturedImage,
                            "varname": widget._itemdata.priceVariation[itemindex].variationName+widget._itemdata.priceVariation[itemindex].unit,
                            "varmrp":widget._itemdata.priceVariation[itemindex].mrp,
                            "varprice":  widget._customerDetail.membership=="1" ? widget._itemdata.priceVariation[itemindex].membershipPrice.toString():widget._itemdata.priceVariation[itemindex].discointDisplay ?widget._itemdata.priceVariation[itemindex].price.toString():widget._itemdata.priceVariation[itemindex].mrp.toString(),
                            "paymentMode": widget._itemdata.paymentMode,
                            "cronTime": widget._itemdata.subscriptionSlot[0].cronTime,
                            "name": widget._itemdata.subscriptionSlot[0].name,
                            "varid":widget._itemdata.priceVariation[itemindex].id,
                            "brand": widget._itemdata.brand
                          }
                      );
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 30.0,
                          decoration: new BoxDecoration(
                              color: ColorCodes.whiteColor,
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight:
                                const Radius.circular(2.0),
                                bottomLeft:
                                const Radius.circular(2.0),
                                bottomRight:
                                const Radius.circular(2.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text(
                                S.of(context).subscribe,//'SUBSCRIBE',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ) ,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ):SizedBox(height: 30,):SizedBox.shrink(),
              SizedBox(
                height: 8,
              ),
              /*Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomeStepper(priceVariation:widget._itemdata.priceVariation[itemindex],itemdata: widget._itemdata,from:"item_screen"),
              ),
              (widget._itemdata.priceVariation[itemindex].membershipDisplay)?
              (Features.isSubscription)? SizedBox(height: 13):SizedBox(height: 5): Spacer(),
              if(widget._itemdata.priceVariation[itemindex].membershipDisplay) Spacer(),
              VxBuilder(
                mutations: {SetCartItem},
                builder: (context, GroceStore box, index) {
                  return Column(
                    children: [
                      if(Features.isMembership)
                        Row(
                          children: <Widget>[
                            !_checkmembership
                                ? widget._itemdata.priceVariation[itemindex].membershipDisplay
                                ? GestureDetector(
                              onTap: () {
                                if( PrefUtils.prefs.containsKey("apikey"))
                                  if(kIsWeb&&  !ResponsiveLayout.isSmallScreen(context)){
                                    LoginWeb(context,result: (sucsess){
                                      if(sucsess){
                                        Navigator.of(context).pop();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, HomeScreen.routeName, (route) => false);
                                      }else{
                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }else{
                                    Navigator.of(context).pushNamed(
                                      MembershipScreen.routeName,
                                    );
                                  }
                              },
                              child: Container(
                                height: 25,
                                width: 188,
                                decoration:
                                BoxDecoration(color: ColorCodes.membershipColor),
                                child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    Image.asset(
                                      Images.starImg,
                                      width: 12,
                                      height: 11,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                       // S.of(context).membership_price+ " " +//"Membership Price "
                                             IConstants.currencyFormat +
                                        widget._itemdata.priceVariation[itemindex].membershipPrice.toString(),
                                        style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold)),
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
                      !_checkmembership
                          ? widget._itemdata.priceVariation[itemindex].membershipDisplay
                          ? SizedBox(
                        height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                      )
                          : SizedBox(
                        height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                      )
                          : SizedBox(
                        height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                      )
                    ],
                  );
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }

}