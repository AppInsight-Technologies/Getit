import 'package:flutter/cupertino.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../data/calculations.dart';
import 'package:provider/provider.dart';

import '../badge_discount.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class VarintWidget extends StatefulWidget {
  Function onTap;

  var singleitemvar;
  var varid;

  int i;

  bool checkmargin = false;
  var varMarginList;
  var discountDisplay;
  bool checkmembership;
  var memberpriceDisplay;
  var sing;

  VarintWidget({Key key, this.onTap,this.singleitemvar,this.varid,this.i,this.checkmargin,this.varMarginList,
  this. discountDisplay,
  this. checkmembership,
  this. memberpriceDisplay, this.sing}) : super(key: key);

  @override
  _VarintWidgetState createState() => _VarintWidgetState();
}

class _VarintWidgetState extends State<VarintWidget> {
  String radioButtonValue;

  List<String> _varMarginList = List<String>();

  @override
  Widget build(BuildContext context) {
    print("i colot....."+widget.sing[widget.i].size.toString()+"  "+widget.varid.toString());
    return GestureDetector(
      onTap: ()=>setState((){
        widget.onTap();
      }),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
          //  color:(widget.sing[widget.i].size==widget.singleitemvar?Colors.white:Colors.white),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: int.parse(widget.sing[widget.i].varstock) > 0?
              (widget.i==widget.varid)?
              ColorCodes.discountoff:
              ColorCodes.noselection:ColorCodes.outofstock,//widget.sing[widget.i].varcolor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              /*widget.singleitemvar[widget.i].varname+" "+ widget.singleitemvar[widget.i].unit,*/
            widget.singleitemvar,
              style: FlutterFlowTheme.bodyText1.override(
                fontSize: 14,
                fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                color: int.parse(widget.sing[widget.i].varstock) > 0?
                (widget.i==widget.varid)?
                      ColorCodes.discountoff:
                      ColorCodes.noselection:ColorCodes.outofstock
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget displayPrice({varianrt,discountDisplay,memberpriceDisplay, bool checkmembership}){
  //varianrt=singleitemvar[i]
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          checkmembership ? Image.asset(
            Images.starImg,
          )
              :
          SizedBox.shrink(),
          Text(IConstants.currencyFormat + (checkmembership ? memberpriceDisplay ? varianrt.varmemberprice : varianrt.varprice : varianrt.varprice), style: new TextStyle(fontWeight: FontWeight.bold, color: int.parse(varianrt.varstock) > 0?Color(0xff012961):Colors.grey, fontSize: 14.0)),
        ],
      ),
      if(discountDisplay || (checkmembership && memberpriceDisplay))
      Text(IConstants.currencyFormat + varianrt.varmrp, style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.0)),
    ],
  );
}
