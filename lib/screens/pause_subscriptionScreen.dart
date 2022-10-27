import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/footer.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../screens/MySubscriptionScreen.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import 'package:http/http.dart' as http;

import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';

import '../widgets/header.dart';
import 'package:intl/intl.dart';

class PauseSubscriptionScreen extends StatefulWidget {
  static const routeName = '/pauseSubscription-screen';
  @override
  _PauseSubscriptionScreenState createState() => _PauseSubscriptionScreenState();
}

class _PauseSubscriptionScreenState extends State<PauseSubscriptionScreen> {
  bool _isWeb =false;
  bool iphonex = false;
  var orderid ;
  var image ;
  var  name;
  var quantity ;
  var price ;

  final now = new DateTime.now();
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  DateTime _selectedDate1 = DateTime.now().add(Duration(days: 1));

  final TextEditingController datecontroller = new TextEditingController();
  final TextEditingController datecontroller1 = new TextEditingController();
  bool loading =true;

  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      //  productBoxSub = Hive.box<Subscription>(productBoxNameSub);
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

    });

    datecontroller.text = DateFormat("dd-MM-yyyy").format(_selectedDate);
    super.initState();

  }


  Future<void> pauseSubscription(String subId, String date) async {
    debugPrint("date...."+date);
    PrefUtils.prefs.setString('pauseStartDate',date);
    try {
      final response = await http.post(Api.pauseSubscription, body: {
        "id": subId,
        "date": date,
        "user": PrefUtils.prefs.getString('userID')
      });
      debugPrint("response...."+{
        "id": subId,
        "date": date,
        "user": PrefUtils.prefs.getString('userID')
      }.toString());
      final responseJson = json.decode(response.body);
      Navigator.pop(context);
      Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
        Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
      } else {
        return Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong!!!", 
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: S.of(context).something_went_wrong,//"Something went wrong!!!", 
        fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    orderid = routeArgs["orderid"];
    image = routeArgs["image"];
    name = routeArgs["name"];
    quantity = routeArgs["quantity"];
    price = routeArgs["price"];

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,

        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(S.of(context).pause_subscription,//"Pause Subscription",
          style: TextStyle(color: ColorCodes.menuColor),),
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

    bottomNavigationbar() {

      return Container(
          width: MediaQuery.of(context).size.width,
          height: 54.0,
          child: Row(
            children: <Widget>[
              Container (
                color: Theme.of(context).primaryColor,
                height: 54,
                width: MediaQuery.of(context).size.width * 50 / 100,
                child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          S.of(context).subscription_resume_on,//"SubsScription Resumes on" ,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          DateFormat("dd-MM-yyyy").format(_selectedDate1).toString() ,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                    ]
                ),
              ),
              GestureDetector(
                onTap: (){
                  pauseSubscription(orderid,DateFormat("yyyy-MM-dd").format(_selectedDate));
                },
                child: Container (
                  color: Theme.of(context).primaryColor,
                  height: 54,
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                                S.of(context).pause_subscription,//"Pause Subscription",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center)),
                        SizedBox(
                          height: 10,
                        ),
                      ]
                  ),
                ),
              ),

            ],
          )
      );
    }

    Widget _bodyMobile() {

      return SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(color: Theme.of(context).buttonColor),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 55.0,
                      backgroundColor: ColorCodes.whiteColor,
                      backgroundImage: AssetImage(Images.defaultProductImg),
                      child: Image.network(image,height: 80,width: 80,fit: BoxFit.fill,),
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
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
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
                                      S.of(context).qty//"Qty: "
                                          + quantity,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
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
                                      S.of(context).subscribe_mrp//"MRP: " +
                                     + IConstants.currencyFormat + " " + double.parse(price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),

                            ])),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(S.of(context).select_dates,//"Select Dates",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(color: Theme.of(context).buttonColor),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          _selectDate(context,setState);
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  child: Text(S.of(context).from_dates,//"From Date",
                                    style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),)
                              ),
                              Spacer(),
                              Icon(Icons.calendar_today_outlined, color: Colors.black54,size: 20,),
                              SizedBox(width: 12,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(children: [

                            Container(
                                child: Text(DateFormat("dd-MM-yyyy").format(_selectedDate), style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.blackColor,
                                ),)
                            ),
                          ],)
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 10,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          _selectDate1(context,setState);
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  child: Text(
                                    S.of(context).to_date,//"To Date",
                                    style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),)
                              ),
                              Spacer(),
                              Icon(Icons.calendar_today_outlined, color: Colors.black54,size: 20,),
                              SizedBox(width: 12,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(children: [
                            Container(
                                child: Text(DateFormat("dd-MM-yyyy").format(_selectedDate1), style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.blackColor,
                                ),)
                            ),
                          ],)
                        ],
                      ),
                    ),
                    (_isWeb)? SizedBox(height: 20,) : SizedBox.shrink(),
                    (_isWeb)?
                    Container(
                        height: 54.0,
                        child: Row(
                          children: <Widget>[
                            Container (
                              color: Theme.of(context).primaryColor,
                              height: 54,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        S.of(context).subscription_resume_on,//"SubsScription Resumes on" ,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        DateFormat("dd-MM-yyyy").format(_selectedDate1).toString() ,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center)
                                  ]
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                pauseSubscription(orderid,DateFormat("yyyy-MM-dd").format(_selectedDate));
                              },
                              child: Container (
                                color: Theme.of(context).primaryColor,
                                height: 54,
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(
                                              S.of(context).pause_subscription,//"Pause Subscription",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]
                                ),
                              ),
                            ),

                          ],
                        )
                    ):
                        SizedBox.shrink(),
                    if(_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
        return Future.value(false);
      },
      child: Scaffold (
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false, false),
            /*_isWeb? _bodyWeb():*/Flexible(child: _bodyMobile()),
          ],
        ),
        bottomNavigationBar:(_isWeb)?SizedBox.shrink():
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child:bottomNavigationbar(),
          ),
        ),
      ),
    );

    }

  Future<void> _selectDate( BuildContext context, setState ) async {
    var now = new DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(), // Refer step 1
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: new DateTime(now.year, now.month + 10, now.day),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Theme.of(context).accentColor,//Head background
            accentColor: Theme.of(context).accentColor,//selection color
          ),// This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {

        _selectedDate = picked;
        datecontroller
          ..text = DateFormat("dd-MM-yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller.text.length,
              affinity: TextAffinity.upstream));
      });
  }
  Future<void> _selectDate1( BuildContext context, setState ) async {


    var now = new DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(), // Refer step 1
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: new DateTime(now.year, now.month + 10, now.day),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Theme.of(context).accentColor,//Head background
            accentColor: Theme.of(context).accentColor,//selection color
          ),// This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDate1)
      setState(() {
        _selectedDate1 = picked;
        datecontroller1
          ..text = DateFormat("dd-MM-yyyy").format(_selectedDate1)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller1.text.length,
              affinity: TextAffinity.upstream));
      });


  }


}
