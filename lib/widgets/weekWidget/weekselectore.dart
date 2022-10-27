import 'dart:io';

import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/weekmodels.dart';
import 'package:velocity_x/velocity_x.dart';

class WeekSelector extends StatefulWidget {
  WeekSelector({Key key,this.onclick}) : super(key: key);
  Function(List<Weeks>,String) onclick;

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  final List<Weeks> weekslist = Weeks().getweeks();
  var _daily = ColorCodes.mediumgren;
  var _weekdays = Colors.transparent;
  var _weekends = Colors.transparent;
  double _dailyWidth = 2.0;
  double _weekdaysWidth = 1.0;
  double _weekendsWidth = 1.0;
   bool isSelected = true;
  String type=S.current.daily;
  bool _isWeb =false;
  bool iphonex = false;
  @override
  Widget build(BuildContext context) {
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

    String activelang =  ( VxState.store as GroceStore).language.language.code;
    return Column(
      children: [
        Row(
          children: [
            Text(
              S.of(context).repeat,//"Repeat",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(width: 10,),
            Text(
              type,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            /*Spacer(),
                            Icon(Icons.arrow_forward_ios, color: Colors.black,size: 10,),
                            SizedBox(width: 12,),*/
          ],
        ),
        SizedBox(height: 10,),

        Row(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            GestureDetector(
              onTap: (){

                for(int i=0; i<weekslist.length;i++)
                setState((){
                  weekslist[i].isselected = true;
                  type= S.current.daily;
                  widget.onclick(weekslist,type);
                });
                _daily = ColorCodes.mediumgren;
                 _dailyWidth = 2.0;
                 _weekdaysWidth = 1.0;
                 _weekendsWidth = 1.0;
                _weekdays = Colors.white;
                _weekends = Colors.white;
                debugPrint("hihihi.."+weekslist.toList.toString());
              },
              child: Container(
                padding: EdgeInsets.only(left: 10),
                width: _isWeb ? MediaQuery.of(context).size.width/7 :MediaQuery.of(context).size.width/3.5 ,
                height: (activelang == "en") ? 40 :70,
               // color: _daily,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide( color: ColorCodes.mediumgren,width: _dailyWidth),
                    bottom: BorderSide(  color: ColorCodes.mediumgren,width: _dailyWidth),
                    left: BorderSide(  color: ColorCodes.mediumgren,width: _dailyWidth),
                    right: BorderSide(  color: ColorCodes.mediumgren,width: _dailyWidth),
                  ),
                  color: _daily,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Center(child: Text(
                    S.of(context).daily,//"Daily"
                  style: TextStyle(
                      color: ColorCodes.greenColor,
                      fontWeight: FontWeight.bold
                  ),
                )),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                //debugPrint("hello..."+"  "+(weekslist.length-2).toString());

                for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
                for(int i=0; i< weekslist.length-2;i++)
                  setState((){
                    type= S.current.weekdays;

                    weekslist[i].isselected = true;
                    debugPrint("hello..."+weekslist[i].toString());
                  });
                widget.onclick(weekslist,type);
                _daily = Colors.white;
                _weekdays = ColorCodes.mediumgren;
                _weekends = Colors.white;
                 _dailyWidth = 1.0;
                 _weekdaysWidth = 2.0;
                 _weekendsWidth = 1.0;
              },
              child: Container(
                width: (activelang == "en") ?  _isWeb ? MediaQuery.of(context).size.width/7 :MediaQuery.of(context).size.width/3.5:90,
                height: (activelang == "en") ? 40 :70,
               // color: _weekdays,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(  color: ColorCodes.mediumgren,width: _weekdaysWidth),
                    bottom: BorderSide(  color: ColorCodes.mediumgren,width: _weekdaysWidth),
                    left: BorderSide(  color: ColorCodes.mediumgren,width: _weekdaysWidth),
                    right: BorderSide(  color: ColorCodes.mediumgren,width: _weekdaysWidth),
                  ),
                  color: _weekdays,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Center(child: Text(
                  S.of(context).weekdays,//"Weekdays"
                  style: TextStyle(
                      color: ColorCodes.greenColor,
                      fontWeight: FontWeight.bold
                  ),
                )),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
                for(int i=0; i< weekslist.length-2;i++)weekslist[i].isselected = false;
                for(int i=0; i<weekslist.length;i++)
                  setState((){
                    weekslist[5].isselected = true;
                    weekslist[6].isselected = true;
                    type= S.current.weekends;

                  });
                widget.onclick(weekslist,type);
                _daily = Colors.white;
                _weekdays = Colors.white;
                _weekends = ColorCodes.mediumgren;
                _dailyWidth = 1.0;
                 _weekdaysWidth = 1.0;
                 _weekendsWidth = 2.0;
              },
              child: Container(
               width:(activelang == "en") ?_isWeb ? MediaQuery.of(context).size.width/7 : MediaQuery.of(context).size.width/3.5 :90,
               height: (activelang == "en") ? 40 :70,
                padding: EdgeInsets.only(left: 2,right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(  color: ColorCodes.mediumgren,width: _weekendsWidth),
                    bottom: BorderSide(  color: ColorCodes.mediumgren,width: _weekendsWidth),
                    left: BorderSide(  color: ColorCodes.mediumgren,width: _weekendsWidth),
                    right: BorderSide(  color: ColorCodes.mediumgren,width: _weekendsWidth),

                  ),
                  color: _weekends,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              //  color: _weekends,
                child: Center(child: Text(
                  S.of(context).weekends,//"Weekends"
                  style: TextStyle(
                    color: ColorCodes.greenColor,
                    fontWeight: FontWeight.bold
                  ),
                )),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           // SizedBox(width: 20,),
            ...weekslist.map((e) =>  GestureDetector(
              onTap: (){
                setState(() {
                  if(e.isselected)
                    e.isselected = false;
                  else
                    e.isselected = true;
                });
                widget.onclick(weekslist,S.of(context).custom);
              },
              child: Container(
               //padding: EdgeInsets.only(left: 10),
                width:45,
                height: 30,
                decoration: BoxDecoration(
                  color: e.isselected?ColorCodes.mediumgren:Colors.transparent,
                  border: Border.all(color:e.isselected? ColorCodes.mediumgren: ColorCodes.mediumgren),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Center(child: Text(e.weekname,style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
              ),
            )),

          ],
        ),

      ],
    );

  }
}
