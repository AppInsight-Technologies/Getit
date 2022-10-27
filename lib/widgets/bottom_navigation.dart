import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../data/calculations.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';

class BottomNaviagation extends StatefulWidget {
  final String itemCount;
  final String title;
  String total;
  final GestureTapCallback onPressed;
  String adonamount;

   BottomNaviagation({Key key, this.itemCount, this.title, this.total, this.onPressed,this.adonamount = "0"}) : super(key: key);
  @override
  _BottomNaviagationState createState() => _BottomNaviagationState();
}

class _BottomNaviagationState  extends State<BottomNaviagation> {
  CartCalculation _calculation = CartCalculation();

  @override
  Widget build(BuildContext context) {
    debugPrint("ghjk...."+widget.total);
    return VxBuilder(
        mutations: {SetCartItem},
        builder: (context,  store, state){
          if(CartCalculations.itemCount>0)
      return ((widget.title==S.current.subscribe)?widget.itemCount:CartCalculations.itemCount.toString()) == "0"?
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: EdgeInsets.all(10.0),
          height: 53,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              widget.onPressed();
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text("",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Text(widget.title,
                        style: TextStyle(
                          fontSize: 18,

                          color: ColorCodes.lightblue,
                          //color: ColorCodes.discount,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child:  Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.lightblue,),
                      ),
                    )),
              ],
            ),
          ),
        ),
      )
          :MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: EdgeInsets.all(10.0),
          height: 53,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              widget.onPressed();
            },
            child: Container(
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
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: ColorCodes.whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                      ),
                    ),
                    padding: EdgeInsets.all(7),
                    height: 82,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Row(
                      children: [
                        Image.asset(
                          Images.bag, height: 32, width: 35, color: ColorCodes.blackColor,),
                        SizedBox(width: 5,),
                        (_calculation.getTotal() == "0")? Text(_calculation.getItemCount(),  style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.blackColor,
                          fontWeight: FontWeight.w800,
                        ),
                        ):Column(
                          mainAxisAlignment: (widget.total=="1")?MainAxisAlignment.center:MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_calculation.getItemCount(),  style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.w800,
                            ),
                            ),
                            SizedBox(height: 1,),
                            (widget.total=="1")?SizedBox.shrink():(widget.title == S.current.place_order)?Text(IConstants.currencyFormat+widget.total,
                              style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.w800,
                            ),)
                            :Text(widget.title==S.current.select_address?IConstants.currencyFormat+widget.total:IConstants.currencyFormat +
                               ( double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toString(),  style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.w800,
                            ),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                    ),
                    height: 82,
                    width: MediaQuery.of(context).size.width / 2.03,
                    child: Center(
                      child: Text(widget.title,
                        style: TextStyle(
                          fontSize: 19,
                          color: ColorCodes.blackColor,
                          //color: ColorCodes.discount,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
          else
          return  SizedBox.shrink();
    }
  );
  }
}
class CartCalculation{
 String getTotal(){
    return CartCalculations.checkmembership ? (IConstants.numberFormat == "1")
        ?(CartCalculations.totalMember).toStringAsFixed(0):(CartCalculations.totalMember).toStringAsFixed(IConstants.decimaldigit)
        :
    (IConstants.numberFormat == "1")
        ?(CartCalculations.total).toStringAsFixed(0):(CartCalculations.total).toStringAsFixed(IConstants.decimaldigit);
  }
  String getItemCount() {
    return CartCalculations.itemCount.toString() + " " + S.current.items;
  }
}