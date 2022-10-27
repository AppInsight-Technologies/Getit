import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/ColorCodes.dart';
import '../../constants/features.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../providers/branditems.dart';
import '../../screens/home_screen.dart';
import '../../screens/signup_selection_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'components/login_web.dart';

class CustomeStepper extends StatefulWidget {
  PriceVariation priceVariation;
  String from;
  ItemData itemdata;
  CustomeStepper({Key key,this.priceVariation,this.itemdata,this.from}) : super(key: key);

  @override
  State<CustomeStepper> createState() => _CustomeStepperState();
}

class _CustomeStepperState extends State<CustomeStepper> {

  bool _isAddToCart = false;

  bool _isNotify = false;

  @override
  Widget build(BuildContext context) {
    updateCart(int qty,CartStatus cart,String varid){
      switch(cart){

        case CartStatus.increment:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.priceVariation.price.toString(),quantity:( qty+1).toString(),var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.priceVariation.price.toString(),quantity:"0",var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.decrement:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.priceVariation.price.toString(),quantity:((qty)<= int.parse(widget.priceVariation.minItem))?"0":(qty-1).toString(),var_id: varid);

          // TODO: Handle this case.
          break;
      }
    }

    // addToCart() async {
    //   debugPrint("add to cart......");
    //   cartcontroller.addtoCart(widget.priceVariation,widget.itemdata,(isloading){
    //     setState(() {
    //       debugPrint("add to cart......1");
    //       _isAddToCart = isloading;
    //     });
    //   });
    // }
    //
    // _notifyMe() async {
    //   setState(() {
    //     _isNotify = true;
    //   });
    //   //_notifyMe();
    //   debugPrint("resposne........1");
    //   int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(widget.itemdata.id.toString(),widget.priceVariation.id.toString(),widget.itemdata.type);
    //   debugPrint("resposne........"+resposne.toString());
    //   if(resposne == 200) {
    //     setState(() {
    //       _isNotify = false;
    //     });
    //     //_isWeb?_Toast("You will be notified via SMS/Push notification, when the product is available"):
    //     Fluttertoast.showToast(msg: S.of(context).you_will_notify,//"You will be notified via SMS/Push notification, when the product is available" ,
    //         fontSize: MediaQuery.of(context).textScaleFactor *13,
    //         backgroundColor:
    //         Colors.black87,
    //         textColor: Colors.white);
    //
    //   } else {
    //     Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong" ,
    //         fontSize: MediaQuery.of(context).textScaleFactor *13,
    //         backgroundColor:
    //         Colors.black87,
    //         textColor: Colors.white);
    //     setState(() {
    //       _isNotify = false;
    //     });
    //   }
    // }

//     return (widget.priceVariation.stock > 0)
//         ? VxBuilder( mutations: {SetCartItem},
//         builder: (context,GroceStore store,state){
//           final item =store.CartItemList;
//           int itemCount = 0;
//           if (item == null) {
//             return SizedBox(height: 0);
//           }
//           else{
//             item.forEach((element) {
//               if(element.varId == widget.priceVariation.id) {
//                 {
//                   itemCount = int.parse(element.quantity);
//                 }
//               }
//             });
//           }
//           widget.priceVariation.quantity = itemCount;
//
//           if(itemCount <= 0)
//             return MouseRegion(
//               cursor: SystemMouseCursors.click,
//               child: GestureDetector(
//                 onTap: () {
//                   debugPrint("add to cart......2");
//                   addToCart();
//                 },
//                 child: Row(
//                   children: [
//                     if(widget.from =="selling_item")
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: (Features.isSubscription)?40.0:30.0,
//                         decoration: new BoxDecoration(
//                             color: (Features.isSubscription)?/*ColorCodes.subscribeColor*/Theme.of(context).primaryColor :ColorCodes.greenColor,
//                             borderRadius: new BorderRadius.only(
//                               topLeft: const Radius.circular(2.0),
//                               topRight:
//                               const Radius.circular(2.0),
//                               bottomLeft:
//                               const Radius.circular(2.0),
//                               bottomRight:
//                               const Radius.circular(2.0),
//                             )),
//                         child: _isAddToCart ?
//                         Center(
//                           child: SizedBox(
//                               width: 20.0,
//                               height: 20.0,
//                               child: new CircularProgressIndicator(
//                                 strokeWidth: 2.0,
//                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                         )
//                             :  (Features.isSubscription)?
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Center(
//                               child: Text(
//                                 S.of(context).buy_once,//'BUY ONCE',
//                                 style: TextStyle(
//                                     color: ColorCodes.whiteColor,
//                                     fontSize: 12, fontWeight: FontWeight.bold),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ],
//                         ) :
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               S.of(context).add,//'ADD',
//                               style: TextStyle(
//                                   color: Theme.of(context)
//                                       .buttonColor,
//                                   fontSize: 12, fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.center,
//                             ),
//                             Spacer(),
//                             Container(
//                               decoration: BoxDecoration(
//                                   color:ColorCodes.cartgreenColor,
//                                   borderRadius:
//                                   new BorderRadius.only(
//                                     topLeft:
//                                     const Radius.circular(
//                                         2.0),
//                                     bottomLeft:
//                                     const Radius.circular(
//                                         2.0),
//                                     topRight:
//                                     const Radius.circular(
//                                         2.0),
//                                     bottomRight:
//                                     const Radius.circular(
//                                         2.0),
//                                   )),
//                               height: 30,
//                               width: 25,
//                               child: Icon(
//                                 Icons.add,
//                                 size: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if(widget.from=="item_screen")
//                     SizedBox(
//                       width: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           else
//             return Container(
//               child: Row(
//                 children: <Widget>[
//                   //SizedBox(width: 10),
//                   MouseRegion(
//                     cursor: SystemMouseCursors.click,
//                     child: GestureDetector(
//                       onTap: () async {
//                         updateCart(widget.priceVariation.quantity, CartStatus.decrement, widget.priceVariation.id.toString());
//                       },
//                       child: Container(
//                           width: 40,
//                           height: (Features.isSubscription)?40:30,
//                           decoration: new BoxDecoration(
//                               color: (Features.isSubscription)?/*ColorCodes.subscribeColor*/ Theme.of(context).primaryColor:ColorCodes.greenColor,
//                               borderRadius: new BorderRadius.only(
//                                 topLeft:
//                                 const Radius.circular(2.0),
//                                 bottomLeft:
//                                 const Radius.circular(2.0),
//                               )),
//                           child: Center(
//                             child: Text(
//                               "-",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color:(Features.isSubscription)?ColorCodes.whiteColor:
//                                 Theme.of(context).buttonColor,
//                               ),
//                             ),
//                           )),
//                     ),
//                   ),
//                   Spacer(),
//                   _isAddToCart ?
//                   Center(
//                     child: SizedBox(
//                         width: 20.0,
//                         height: 20.0,
//                         child: new CircularProgressIndicator(
//                           strokeWidth: 2.0,
//                           valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
//                   )
//                       :
//                   Container(
// //                                width: 40,
//                       height: (Features.isSubscription)?40:30,
//                       child: Center(
//                           child: /*Text(varQty.toString(),
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: ColorCodes.greenColor,
//                                       ),
//                                     )*/Text(itemCount.toString()/*+" "+unit.toString()*/,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: (Features.isSubscription)?Theme.of(context).primaryColor:ColorCodes.greenColor,
//                             ),
//                           )
//                       )),
//                   Spacer(),
//                   MouseRegion(
//                     cursor: SystemMouseCursors.click,
//                     child: GestureDetector(
//                       onTap: () {
//                         if (widget.priceVariation.quantity < widget.priceVariation.stock) {
//                           if (widget.priceVariation.quantity < int.parse(widget.priceVariation.maxItem)) {
//                             updateCart(widget.priceVariation.quantity, CartStatus.increment, widget.priceVariation.id.toString());
//                           } else {
//                             Fluttertoast.showToast(
//                                 msg:
//                                 S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
//                                 fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                 backgroundColor: Colors.black87,
//                                 textColor: Colors.white);
//                           }
//                         } else {
//                           Fluttertoast.showToast(
//                               msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
//                               fontSize: MediaQuery.of(context).textScaleFactor *13,
//                               backgroundColor: Colors.black87,
//                               textColor: Colors.white);
//                         }
//                       },
//                       child: Container(
//                           width: 40,
//                           height:(Features.isSubscription)?40:30,
//                           decoration: new BoxDecoration(
//                               color:(Features.isSubscription)?/*ColorCodes.subscribeColor*/Theme.of(context).primaryColor :ColorCodes.greenColor,
//                               borderRadius: new BorderRadius.only(
//                                 topRight:
//                                 const Radius.circular(2.0),
//                                 bottomRight:
//                                 const Radius.circular(2.0),
//                               )),
//                           child: Center(
//                             child: Text(
//                               "+",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color:(Features.isSubscription)?ColorCodes.whiteColor:
//                                 Theme.of(context).buttonColor,
//                               ),
//                             ),
//                           )),
//                     ),
//                   ),
//                   if(widget.from =="item_screen")
//                   SizedBox(width: 10),
//                 ],
//               ),
//             );
//         })
//         : MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () {
//
//           if(!PrefUtils.prefs.containsKey("apikey"))
//             if(kIsWeb&&  !ResponsiveLayout.isSmallScreen(context)){
//               LoginWeb(context,result: (sucsess){
//                 if(sucsess){
//                   Navigator.of(context).pop();
//                   Navigator.pushNamedAndRemoveUntil(
//                       context, HomeScreen.routeName, (route) => false);
//                 }else{
//                   Navigator.of(context).pop();
//                 }
//               });
//             }else{
//               Navigator.of(context).pushNamed(
//                 SignupSelectionScreen.routeName,
//               );
//             }
//           else {
//             _notifyMe();
//           }
//         },
//         child: (Features.isSubscription)?
//         Row(
//           children: [
//             if(widget.from == "selling_item")
//               SizedBox(
//                 width: 10,
//               ),
//             Expanded(
//               child: Container(
//                 height: 40.0,
// //                      width: MediaQuery.of(context).size.width,
//
//                 decoration: new BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: new BorderRadius.only(
//                       topLeft: const Radius.circular(2.0),
//                       topRight: const Radius.circular(2.0),
//                       bottomLeft: const Radius.circular(2.0),
//                       bottomRight: const Radius.circular(2.0),
//                     )),
//                 child:
//                 _isNotify ?
//                 Center(
//                   child: SizedBox(
//                       width: 20.0,
//                       height: 20.0,
//                       child: new CircularProgressIndicator(
//                         strokeWidth: 2.0,
//                         valueColor: new AlwaysStoppedAnimation<
//                             Color>(Colors.white),)),
//                 )
//                     :
//                 Row(
//                   children: [
//                     //if(widget.from == "selling_item")
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       S.of(context).notify_me,//'Notify Me',
//                       /*'ADD',*/
//                       style: TextStyle(
//                           color: Theme.of(context).buttonColor,
//                           fontSize: 12),
//                       textAlign: TextAlign.center,
//                     ),
//                     Spacer(),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: new BorderRadius.only(
//                             topRight: const Radius.circular(2.0),
//                             bottomRight:
//                             const Radius.circular(2.0),
//                           )),
//                       height: 40,
//                       width: 25,
//                       child: Icon(
//                         Icons.add,
//                         size: 12,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if(widget.from=="item_screen")
//             SizedBox(
//               width: 10,
//             )
//           ],
//         )
//             :Row(
//           children: [
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Container(
//                 height: 30.0,
// //                      width: MediaQuery.of(context).size.width,
//
//                 decoration: new BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: new BorderRadius.only(
//                       topLeft: const Radius.circular(2.0),
//                       topRight: const Radius.circular(2.0),
//                       bottomLeft: const Radius.circular(2.0),
//                       bottomRight: const Radius.circular(2.0),
//                     )),
//                 child:
//                 _isNotify ?
//                 Center(
//                   child: SizedBox(
//                       width: 20.0,
//                       height: 20.0,
//                       child: new CircularProgressIndicator(
//                         strokeWidth: 2.0,
//                         valueColor: new AlwaysStoppedAnimation<
//                             Color>(Colors.white),)),
//                 )
//                     :
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       S.of(context).notify_me, //'Notify Me',
//                       /*'ADD',*/
//                       style: TextStyle(
//                           color: Theme.of(context).buttonColor,
//                           fontSize: 12),
//                       textAlign: TextAlign.center,
//                     ),
//                     Spacer(),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: new BorderRadius.only(
//                             topRight: const Radius.circular(2.0),
//                             bottomRight:
//                             const Radius.circular(2.0),
//                           )),
//                       height: 30,
//                       width: 25,
//                       child: Icon(
//                         Icons.add,
//                         size: 12,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             )
//           ],
//         ),
//       ),
//     );
  }
}
