import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../widgets/flutter_flow/flutter_flow_theme.dart';

class colorWidget extends StatefulWidget{
  Function onTap;
  var singleitemvar;
   int coloindex;
  int i;



  colorWidget({Key key, this.onTap,this.singleitemvar,this.i,this.coloindex}) : super(key: key);

  @override
  _colortWidgetState createState() => _colortWidgetState();

}

class _colortWidgetState extends State<colorWidget> {
  String radioButtonValue;

  List<String> _varMarginList = List<String>();
    @override
    Widget build(BuildContext context) {
      debugPrint("singleitemvar......"+widget.singleitemvar);
      return GestureDetector(
        onTap: ()=>setState((){
          widget.onTap();
        }),

        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (widget.i == widget.coloindex)?Colors.black:Colors.white,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Color(int.parse(widget.singleitemvar)),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(int.parse(widget.singleitemvar))== ColorCodes.whiteColor?ColorCodes.grey:
                  Color(int.parse(widget.singleitemvar)),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                 ".",
                  style: FlutterFlowTheme.bodyText1.override(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }



  }
