import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../assets/ColorCodes.dart';
import '../../constants/features.dart';
import '../../providers/myorderitems.dart';
import '../../screens/return_screen.dart';
import '../../utils/prefUtils.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import '../assets/images.dart';

class OrderhistoryDisplay extends StatefulWidget {
  final String itemname;
  final String varname;
  final String fit;
  final String price;
  final String qty;
  final String subtotal;
  final String itemImage;
  final String extraAmount;
  final String orderid;
  final String size;

  OrderhistoryDisplay(
      this.itemname,
      this.varname,
      this.fit,
      this.price,
      this.qty,
      this.subtotal,
      this.itemImage,
      this.extraAmount,
      this.orderid,
      this.size,
      );

  @override
  _OrderhistoryDisplayState createState() => _OrderhistoryDisplayState();
}

class _OrderhistoryDisplayState extends State<OrderhistoryDisplay> {
  var extraAmount;
  bool _showReturn = false;
  var orderitemData;
  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      print("return exchange"+Features.isReturnOrExchange.toString());

      Provider.of<MyorderList>(context, listen: false).Vieworders(widget.orderid).then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(context, listen: false,);

          print("due amount..."+orderitemData.vieworder[0].dueamount.toString());
          if(orderitemData.vieworder1[0].deliveryOn != ""){
            DateTime today = new DateTime.now();
            for(int i = 0; i < orderitemData.vieworder1.length; i++) {
              DateTime orderAdd = DateTime.parse(orderitemData.vieworder1[i].deliveryOn).add(Duration(hours:int.parse (orderitemData.vieworder1[i].returnTime)));
              if((orderAdd.isAtSameMomentAs(today) || orderAdd.isAfter(today))&&
                  (orderitemData.vieworder[0].returnStatus == "" || orderitemData.vieworder[0].returnStatus == "null") &&
                  (orderitemData.vieworder1[i].ostatus.toLowerCase() == "delivered" || orderitemData.vieworder1[i].ostatus.toLowerCase() == "completed")) {
                if (orderitemData.vieworder1[i].returnTime != "" && orderitemData.vieworder1[i].returnTime != "0") {
                  setState(() {
                    _showReturn = true;
                  });
                  break;
                }
              }

            }
          }

        });
      });

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).buttonColor),
      child:
        Column(
          children: [

            Row(
              children: [
                Container(
                    child:widget.extraAmount == "888"? Image.asset(Images.membershipImg,
                      color: Theme.of(context).primaryColor,
                      width: 95,
                      height: 110,
                      fit: BoxFit.cover,
                    ): ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: widget.itemImage,
                        placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                          width: 95,
                          height: 110,),
                        errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                          width: 95,
                          height: 110,),
                        width: 95,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    )
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/1.7,
                      child: Text(
                        widget.itemname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      widget.fit,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13,color: ColorCodes.greyColor,fontWeight: FontWeight.w700),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Size: " + widget.size, style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("|", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text( S.of(context).qty
                          //"Qty:"
                              +" " +widget.qty, style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                      ],
                    ),
                    /*Text( S.of(context).price
                     // "Price:"
                        +" " +double.parse(widget.price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), style: TextStyle(color: Color(0xffCCCCCC),fontSize: 9),),
                    */
                    SizedBox(height: 10,),
                    Text(IConstants.currencyFormat + " " + double.parse(widget.subtotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    SizedBox(height: 10,),

                  ],
                ),

            ],
            ),
          ],
        ),

    );
  }
}