import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/user.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/bottom_navigation.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../models/weekmodels.dart';
import '../providers/addressitems.dart';
import '../screens/Payment_SubscriptionScreen.dart';
import '../screens/address_screen.dart';
import '../screens/home_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/subscription_shimmer.dart';
import '../widgets/weekWidget/weekselectore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class SubscribeScreen extends StatefulWidget {
  static const routeName = '/subscribe-screen';
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  DateRangePickerController _datecontroller  = DateRangePickerController();

  bool _isWeb =false;
  bool iphonex = false;
  var itemid;
  var itemimg;
  var itemname;
  var brand;
  var varprice;
  var varname;
  var paymentMode;

  var cronTime;
  var name ;
  var varid ;
  var varmrp;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  bool _isAddToCart = false;
  var displaydate = "";
  List<Weeks> weeklydisplaydata = [];
  List<int> deliveries = [6,15,30,60];
  final now = new DateTime.now();
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  var _selectedDate1 ;
  var endDate;
 DateTime initialdate;
  DateTime finaldate;
  final TextEditingController datecontroller = new TextEditingController();
  final TextEditingController datecontroller1 = new TextEditingController();
  List<bool> _isChecked;
  bool isCheck=false;
  String address = "";
  String Customername = "";
  List selectedweeklydata = ['mon','tue','wed','thu','fri','sat','sun'];
  String pickSchedule="";
  var _daily = ColorCodes.darkthemeColor;
  var _weekdays = Colors.grey;
  var _weekends = Colors.grey;
  IconData addressicon;
  var addtype;
  final user_data = (VxState.store as GroceStore).userData;
  bool checkaddress = false;
  int _itemCount = 1;
  bool loading =true;

  List<DateTime> datelist1 =[];
  List<DateTime> list =[];
  int _selectedIndex = 0;
  // String delivery="6";
  int deliveryNum=6;

  final List<Weeks> SelectedWeek =[];
  final List SelectedDaily =[];
  String typeselected;
  int count = 0;
  int i=0;
  DateTime finalDate;
  UserData addressdata;

  @override
  void initState() {
    typeselected = S.current.daily;
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
      addressdata =(VxState.store as GroceStore).userData;
      if(addressdata.billingAddress.length<0){
        setState(() {
          checkaddress = true;
          loading=false;
        });
      }else{
        setState(() {
                     address =addressdata.billingAddress[0].address.toString();
                    Customername = addressdata.billingAddress[0].fullName.toString();
                     debugPrint("address..."+address +" "+ Customername);
                    loading=false;
                   });
      }
      // Provider.of<AddressItemsList>(context, listen: false,).fetchAddress().then((_) {
      //   setState(() {
      //     addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      //       debugPrint("asdf....."+addressitemsData.items.length.toString());
      //       if(addressitemsData.items.length <= 0){
      //         debugPrint("length less than 0...");
      //         setState(() {
      //           checkaddress = true;
      //           loading=false;
      //         });
      //
      //       }else{
      //         setState(() {
      //           address =addressitemsData.items[0].useraddress.toString();
      //           Customername = addressitemsData.items[0].username.toString();
      //           debugPrint("address..."+address +" "+ Customername);
      //           loading=false;
      //         });
      //       }
      //
      //   });
      // });

      SelectedDaily.addAll(selectedweeklydata);
      typeselected = S.current.daily;
    });

    datecontroller.text = DateFormat("yyyy-MM-dd").format(_selectedDate);
    super.initState();
    _isChecked = List<bool>.filled(weeklydisplaydata.length, false);
  }


  _onSelected(int index, setState) {
    setState(() {
      _selectedIndex = index;
      debugPrint("selectedindex..."+_selectedIndex.toString());
    });
  }

  /*Widget showweekly( BuildContext context , setState ) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context1) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                return Container(

                  child: Padding(

                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 28),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text("Select Delivery Days",
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
                                onTap: () {
                                  Navigator.pop(context);
                                  },
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
                                itemCount: weeklydisplaydata.length,
                                itemBuilder: (_, i) {
                                  return CheckboxListTile(
                                    title: Text(weeklydisplaydata[i]),
                                    value: _isChecked[i],
                                    onChanged: (val) {
                                      setState1(
                                            () {
                                              isCheck = true;
                                          _isChecked[i] = val;
                                              selectedweeklydata.add(weeklydisplaydata[i]);
                                          debugPrint("value...."+i.toString() +"  "+isCheck.toString()+"  "+ selectedweeklydata.toString());
                                        },
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Theme.of(context).buttonColor,
                            ),
                            child:
                            Row(
                              children: [
                                SizedBox(width: 20,),
                                Column(
                                  children: [
                                    Container(
                                        child: Text("Subscription Start Date", style: TextStyle(
                                          fontSize: 16,
                                          color: ColorCodes.blackColor,
                                        ),)
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                        child: Text(DateFormat("dd-MM-yyyy").format(_selectedDate), style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorCodes.blackColor,
                                        ),)
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    setState1(() {
                                            _selectDate(context,setState1);
                                      },
                                    );

                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Icon(Icons.calendar_today, color: Colors.grey,),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                           *//* for(int i=0;i<weeklydisplaydata.length;i++){*//*
                              if(!isCheck){
                                Fluttertoast.showToast(msg: "Please Select delivery days",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white
                                );
                              }
                              else{
                                setState(() {
                                 datecontroller.text= DateFormat("dd-MM-yyyy").format(_selectedDate);
                                 Navigator.of(context).popUntil(ModalRoute.withName(SubscribeScreen.routeName,));
                               });

                                debugPrint("date.."+datecontroller.text);
                            //    Navigator.pop(context);

                              }
                           // }


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 40,

                              alignment: Alignment.center,
                              child: Text("Submit", style: TextStyle(
                                  color: ColorCodes.whiteColor
                              ),)
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        });
  }*/
  Widget showMonthly( setState) {

    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
                list = args.value;
                debugPrint("list....."+ list.toString());
                if(list.length>5) {
                  _datecontroller.selectedDates = datelist1;
                  Fluttertoast.showToast(
                      msg: S.current.you_cannot_add_more_than_5_dates);
                }
                else {
                  _datecontroller.selectedDates = list;
                }
                datelist1 = _datecontroller.selectedDates;
                }
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
                              child: Text(S.current.select_delivery_dates,
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
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child:
                          SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.multiple,
                            view: DateRangePickerView.month,
                            headerHeight: 0,

                            controller: _datecontroller,
                            initialSelectedDates: _datecontroller.selectedDates,
                            minDate: DateTime(DateTime.now().year,DateTime.now().month,1),
                            maxDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime(DateTime.now().year,DateTime.now().month + 1, 0).day),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).buttonColor,
                          ),
                          child:
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Column(
                                children: [
                                  Container(
                                      child: Text(S.current.subscription_starts_date, style: TextStyle(
                                        fontSize: 16,
                                        color: ColorCodes.blackColor,
                                      ),)
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                      child: Text(DateFormat("dd-MM-yyyy").format(_selectedDate), style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorCodes.blackColor,
                                      ),)
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  _selectDate(context,setState1);
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Icon(Icons.calendar_today, color: Colors.grey,),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            if(list.length<= 0){
                              Fluttertoast.showToast(msg: S.current.select_delivery_dates);
                            }else{
                              setState(() {
                                debugPrint("date controller..."+_datecontroller.selectedDates .toString());
                                datecontroller.text= DateFormat("yyyy-MM-dd").format(_selectedDate);
                                Navigator.of(context).pop();
                              });
                            }


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 40,

                              alignment: Alignment.center,
                              child: Text(S.current.submit, style: TextStyle(
                                color: ColorCodes.whiteColor
                              ),)
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                );

              }),
            ],
          );
        });
  }
  Widget showRepeat(BuildContext context , setState) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),
        ),
        builder: (context) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
                  list = args.value;
                  debugPrint("list....."+ list.toString());
                  if(list.length>5) {
                    _datecontroller.selectedDates = datelist1;
                    Fluttertoast.showToast(
                        msg: S.current.you_cannot_add_more_than_5_dates);
                  }
                  else {
                    _datecontroller.selectedDates = list;
                  }
                  datelist1 = _datecontroller.selectedDates;
                }
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

                          children: [
                            Flexible(
                              child: Text(S.current.choose_days,
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
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:40,
                              height: 40,

                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("M")),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("T")),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("W")),
                            ),
                            Container(
                              width:40,
                              height: 40,

                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("T")),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("F")),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("S")),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text("S")),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width:80,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                top: BorderSide( color: _daily,),
                                bottom: BorderSide( color: _daily,),
                                left: BorderSide( color: _daily),
                                right: BorderSide( color: _daily),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Center(child: Text(S.current.daily)),
                            ),
                            Container(
                              width:80,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCodes.primaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Center(child: Text(S.current.weekdays)),
                            ),
                            Container(
                              width:80,
                              height: 50,

                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCodes.primaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Center(child: Text(S.current.weekends)),
                            ),
                          ],
                        ),

                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            if(list.length<= 0){
                              Fluttertoast.showToast(msg: S.current.please_select_days);
                            }else{
                              setState(() {
                                debugPrint("date controller..."+_datecontroller.selectedDates .toString());
                                datecontroller.text= DateFormat("yyyy-MM-dd").format(_selectedDate);
                                Navigator.of(context).pop();
                              });
                            }


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(S.current.confirm, style: TextStyle(
                                  color: ColorCodes.whiteColor
                              ),)
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                );

              }),
            ],
          );
        });
  }

  Widget showDeliveries( BuildContext context , setState ) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),
        ),
        builder: (context1) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                return Container(

                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Flexible(
                            child: Text(S.current.chose_delivery,
                                style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //separatorBuilder: (BuildContext context, int i) => const Divider(),
                            itemCount: deliveries.length,
                            itemBuilder: (_, i) {
                              return Column(
                                children: [
                                  Container(
                                    color: _selectedIndex != null && _selectedIndex == i
                                        ? ColorCodes.lightColor
                                        : Colors.transparent,
                                    child: ListTile(
                                      title: Text(deliveries[i].toString() + " " + S.current.deliveries),
                                      onTap: () {
                                        setState((){
                                          _onSelected(i,setState1);
                                        });

                                      },
                                    ),
                                  ),

                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                deliveryNum = deliveries[_selectedIndex];
                              });

                              Navigator.of(context).pop();
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width-24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                height: 40,

                                alignment: Alignment.center,
                                child: Text(S.current.select_deliveries, style: TextStyle(
                                    color: ColorCodes.whiteColor
                                ),)
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    itemname = routeArgs["itemname"];
    itemid = routeArgs["itemid"];
    itemimg = routeArgs["itemimg"];
    varname = routeArgs["varname"];
    varprice = routeArgs["varprice"];
    paymentMode = routeArgs["paymentMode"];
     cronTime= routeArgs['cronTime'];
     name = routeArgs['name'];
     varid = routeArgs['varid'];
     varmrp = routeArgs['varmrp'];
    brand = routeArgs['brand'];

/*    var finalDa;
    if(typeselected == "Daily"){
      DateTime weekdayOf(DateTime time, int weekday) => time.add(Duration(days: weekday - time.weekday));
      debugPrint("weekdays..."+ weekdayOf(now, 5).toString());
      finalDa = now.add(Duration(days: deliveryNum));
      _selectedDate1=DateFormat("dd-MM-yyyy").format(finalDa);
    }
    else if(typeselected == "Weekdays") {
      deliveryNum =6;
      debugPrint("selected...");
      //  setState(() {
      debugPrint("selected...weekdays");
      initialdate = _selectedDate;
      List<int> availableTime = [];

      debugPrint("SelectedWeek...."+SelectedWeek.length.toString());
      for (int i = 0; i < SelectedWeek.length; i++) {
        debugPrint("SelectedWeekweekname...."+SelectedWeek[i].weekname);
        availableTime.add(SelectedWeek[i].weekname == 'Mon'
            ? 1
            : SelectedWeek[i].weekname == 'Tue'
            ? 2
            : SelectedWeek[i].weekname == 'Wed'
            ? 3
            : SelectedWeek[i].weekname == 'Thu'
            ? 4
            : SelectedWeek[i].weekname == 'Fri' ? 5
            : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

      }
      debugPrint("selected...initial...weekdays"+deliveryNum.toString());
      for (int i = 0; i <= deliveryNum; i++) {
        debugPrint("selected...initial...for..loop"+SelectedWeek.toList().toString());
        availableTime.map((e) {
          debugPrint("selected...inside.."+e.toString()+"  "+initialdate.weekday.toString());
          if (e != initialdate.weekday) {
            debugPrint("selected...name...");
            // deliveryNum++;
          }
        }).toList();
        initialdate = initialdate.add(Duration(days: 1));
      }
      finalDate = initialdate;
      _selectedDate1=DateFormat("dd-MM-yyyy").format(finalDate);
      debugPrint("selected...finalDate..."+ finalDate.toString()+"  "+_selectedDate1.toString());

      //  });
    }
    else if(typeselected == "Weekends"){
      deliveryNum =6;
      debugPrint("selected...");
      setState(() {
        debugPrint("selected...weekdays");
        initialdate = _selectedDate;
        List<int> availableTime = [];

        debugPrint("SelectedWeek...."+SelectedWeek.length.toString());
        for (int i = 0; i < SelectedWeek.length; i++) {
          debugPrint("SelectedWeekweekname...."+SelectedWeek[i].weekname);
          availableTime.add(SelectedWeek[i].weekname == 'Mon'
              ? 1
              : SelectedWeek[i].weekname == 'Tue'
              ? 2
              : SelectedWeek[i].weekname == 'Wed'
              ? 3
              : SelectedWeek[i].weekname == 'Thu'
              ? 4
              : SelectedWeek[i].weekname == 'Fri' ? 5
              : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

        }

        debugPrint("selected...initial...weekdays"+deliveryNum.toString());
        for (int i = 0; i <= deliveryNum; i++) {
          debugPrint("selected...initial...for..loop"+SelectedWeek.toList().toString());
          availableTime.map((e) {
            debugPrint("selected...inside.."+e.toString()+"  "+initialdate.weekday.toString());
            if (e != initialdate.weekday) {
              debugPrint("selected...name...");
              // deliveryNum++;
            }
          }).toList();
          initialdate = initialdate.add(Duration(days: 1));
        }
        finalDate = initialdate;
        _selectedDate1=DateFormat("dd-MM-yyyy").format(finalDate);
        debugPrint("selected...finalDate..."+ finalDate.toString()+"  "+_selectedDate1.toString());
      });
    }*/
    debugPrint("var..."+routeArgs['varprice'].toString()+"  "+routeArgs['varname'].toString());
    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,

        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(S.current.subscribe,
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
      debugPrint("date time...."+datecontroller.text);
      String channel = "";
      try {
        if (Platform.isIOS) {
          channel = "IOS";
        } else {
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }
      return  loading?
      BottomNaviagation(
        itemCount: "0",
        title: S.current.subscribe,
        total: "0",
        onPressed: (){
          setState(() {

          });
        },
      ):
      BottomNaviagation(
        itemCount: "0",
        title: S.current.subscribe,
        total: "0",
        onPressed: (){
          setState(() {
            if(typeselected == S.current.daily){
              print("weeklist...Daily.."+SelectedDaily.toString()+"  "+ deliveryNum.toString());
            }else{
              print("weeklist...else.."+SelectedWeek.toString());
            }

            if(address == ""){
              Fluttertoast.showToast(msg: S.current.please_add_delivery_address);
            }else if(SelectedWeek.length == 0 && typeselected != S.current.daily){
              Fluttertoast.showToast(msg: S.current.please_select_repeat_type);
            }
            else{


              print("weeklist..."+SelectedDaily.toString()+"  "+SelectedWeek.toString()+"  "+user_data.id.toString());
              print("type..: "+typeselected+"  "+ user_data.billingAddress[0].addressType.toString()+"  "+PrefUtils.prefs.getString('userID').toString());
              print("no of days..."+SelectedDaily.length.toString()+"  "+SelectedWeek.length.toString());
              double total= ((_itemCount * double.parse(varprice)) * (deliveryNum));
              List<String> weeks  = [];
              SelectedWeek.map((e) => weeks.add(e.weekname)).toList();
              debugPrint("SelectedWeek.."+weeks.toString());

              Navigator.of(context)
                  .pushReplacementNamed(PaymenSubscriptionScreen.routeName,arguments: {
                "addressid":user_data.id.toString(),
                "useraddtype":user_data.billingAddress[0].addressType.toString(),
                "startDate":datecontroller.text,
                "endDate": _selectedDate1.toString(),
                "itemCount": _itemCount.toString(),
                "deliveries": deliveryNum.toString(),
                "total": total.toString(),
                "schedule": typeselected,
                "itemid": routeArgs['itemid'].toString(),
                "itemimg": routeArgs['itemimg'].toString(),
                "itemname":itemname.toString(),
                "varprice":routeArgs['varprice'].toString(),
                "varname":routeArgs['varname'].toString(),
                "address":address.toString(),
                "paymentMode": paymentMode.toString(),
                "cronTime": cronTime.toString(),
                "name": name.toString(),
                "varid": varid.toString(),
                "varmrp":routeArgs['varmrp'].toString(),
                "brand" :brand.toString(),
                "weeklist":(typeselected == S.current.daily)?SelectedDaily.toString():weeks.toString(),
                "no_of_days":(typeselected == S.current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString()
              });
            }
          });
        },
      );
    }

    Widget _bodyWeb() {
      final addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      debugPrint("asdf....."+addressitemsData.items.length.toString());
      if(addressitemsData.items.length > 0) {
        address = addressitemsData.items[0].useraddress.toString();
        Customername = addressitemsData.items[0].username.toString();
      }
      debugPrint("address................"+ address);
      // deliveryNum = int.parse( delivery);
    //_selectedDate1 = _selectedDate.add( Duration(days:  deliveryNum));
      debugPrint("address................"+ address + "  "+typeselected);
      debugPrint("date time...."+datecontroller.text);
      String channel = "";
      try {
        if (Platform.isIOS) {
          channel = "IOS";
        } else {
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }
      var finalDa;
      if(typeselected == S.current.daily){
        DateTime weekdayOf(DateTime time, int weekday) => time.add(Duration(days: weekday - time.weekday));
        debugPrint("weekdays..."+ weekdayOf(now, 5).toString());
        finalDa = now.add(Duration(days: deliveryNum));
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDa);
        debugPrint("_selectedDate1..."+ _selectedDate1.toString());
      }
      else {
        //deliveryNum =6;
        //  int delivFinal = deliveryNum;
        debugPrint("selected...");
        //  setState(() {
        debugPrint("selected...weekdays");
        initialdate = _selectedDate;
        List<int> availableTime = [];

        debugPrint("SelectedWeek...."+SelectedWeek.length.toString());
        for (int i = 0; i < SelectedWeek.length; i++) {
          debugPrint("SelectedWeekweekname...."+SelectedWeek[i].weekname);
          availableTime.add(SelectedWeek[i].weekname == 'Mon'
              ? 1
              : SelectedWeek[i].weekname == 'Tue'
              ? 2
              : SelectedWeek[i].weekname == 'Wed'
              ? 3
              : SelectedWeek[i].weekname == 'Thu'
              ? 4
              : SelectedWeek[i].weekname == 'Fri' ? 5
              : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

        }

        debugPrint("selected...initial...weekdays"+deliveryNum.toString());
        try{
          for (int i = 0; i <= deliveryNum; i++) {
            debugPrint("selected...initial...for..loop"+SelectedWeek.toList().toString());
            availableTime.map((e) {
              debugPrint("selected...inside.."+e.toString()+"  "+initialdate.weekday.toString());
              if (e == initialdate.weekday) {
                debugPrint("selected...name...");
                // delivFinal ++;
              }
            }).toList();
            initialdate = initialdate.add(Duration(days: 1));
          }
        }catch(e){
          debugPrint("e......."+e.toString());
        }

        finalDate = initialdate;
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDate);
        debugPrint("selected...finalDate..."+ finalDate.toString()+"  "+_selectedDate1.toString());

        //  });
      }
      queryData = MediaQuery.of(context);
      wid= queryData.size.width;
      maxwid=wid*0.90;
      return loading?
      SubscriptionShimmer()
          :checkaddress?
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                padding:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
                color: ColorCodes.whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,

                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          Container(
                           // color: ColorCodes.mediumgren,
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: ColorCodes.whiteColor,
                              backgroundImage: AssetImage(Images.defaultProductImg),
                              child: Image.network(itemimg,height: 100,width: 100,fit: BoxFit.fill,),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            brand,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),

                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
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
                                            varname,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: 2,),
                                        Text(
                                          IConstants.currencyFormat + " " + double.parse(varmrp).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),

                                  ])),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 80,
                      child: Row(
                        children: <Widget>[

                          Text(
                            S.current.quantity_per_day,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),

                          Spacer(),
                          Row(
                            children: [
                              _itemCount!=0?
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount==1? _itemCount:_itemCount--);
                                },
                                child: new  Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child:Center(
                                    child: Text(
                                      "-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  :
                              new Container(),
                              Container(
                                  color: ColorCodes.primaryColor,
                                  width: 40,
                                  height: 40,
                                  child:
                                  Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.whiteColor, fontSize: 14, fontWeight: FontWeight.bold),))
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount++);
                                },
                                child: Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),

                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125,
                      child: WeekSelector(onclick: (weeklist,type){
                        SelectedWeek.clear();
                        SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                        typeselected = type;
                        print("weeklist..wee"+SelectedWeek.toString());
                        print("type: "+typeselected);
                      },),
                    ),

                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        showDeliveries(context, setState);
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              S.current.recharge_or_topup,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              /*decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    deliveryNum.toString() + " " + S.of(context).deliveries,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          _selectDate(context,setState);
                        });
                      },
                      child:
                      Container(
                        height: 50,

                        child: Row(
                          children: [
                            Text(
                              S.current.start_dat,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              /*decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),

                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        PrefUtils.prefs.setString("addressbook",
                            "SubscriptionScreen");

                        Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                            arguments: {
                              'addresstype': "new",
                              'addressid': "",
                              'delieveryLocation': "",
                              'latitude': "",
                              'longitude': "",
                              'branch': "",
                              "itemname": itemname.toString(),
                              "itemid": itemid.toString(),
                              "itemimg":itemimg.toString(),
                              "varname": varname.toString(),
                              "varprice": varprice.toString(),
                              "paymentMode":paymentMode.toString(),
                              "cronTime": routeArgs['cronTime'].toString(),
                              "name": routeArgs['name'].toString(),
                              "varmrp":routeArgs['varmrp'].toString(),
                              "varid": routeArgs['varid'].toString(),
                              "brand" :brand.toString()
                            });
                      },
                      child: Column(
                        children: [
                          Row(

                            children: [
                              Container(
                                  child: Text(S.current.address, style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),)
                              ),
                              Spacer(),
                              Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                      bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                      left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                      right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                                    )),
                                child: Center(child:
                                Text(S.current.add_address,style: TextStyle(color: ColorCodes.whiteColor),
                                  textAlign: TextAlign.center,)),
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),

            ],
          ),
        ),
      )

          :Expanded(
            child: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                padding:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
                //height: MediaQuery.of(context).size.height,
                color: ColorCodes.whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,

                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          Container(
                            color: ColorCodes.whiteColor,
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: ColorCodes.whiteColor,
                              backgroundImage: AssetImage(Images.defaultProductImg),
                              child: Image.network(itemimg,height: 100,width: 100,fit: BoxFit.fill,),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            brand,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),

                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
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
                                            varname,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: 2,),
                                        Text(
                                          IConstants.currencyFormat + " " + double.parse(varmrp.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),

                                  ])),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 80,
                      child: Row(
                        children: <Widget>[

                          Text(
                            S.current.quantity_per_day,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),

                          Spacer(),
                          Row(
                            children: [
                              _itemCount!=0?
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount==1? _itemCount:_itemCount--);
                                },
                                child: new  Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child:Center(
                                    child: Text(
                                      "-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  :
                              new Container(),
                              Container(
                                  color: ColorCodes.primaryColor,
                                  width: 40,
                                  height: 40,
                                  child:
                                  Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.whiteColor, fontSize: 14, fontWeight: FontWeight.bold),))
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount++);
                                },
                                child: Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),

                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125,
                      child: WeekSelector(onclick: (weeklist,type){
                        SelectedWeek.clear();
                        SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                        typeselected = type;
                        print("weeklist..wee"+SelectedWeek.toString());
                        print("type: "+typeselected);
                      },),
                    ),

                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        showDeliveries(context, setState);
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              S.current.recharge_or_topup,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                             /* decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    deliveryNum.toString() + " " + S.of(context).deliveries,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          _selectDate(context,setState);
                        });
                      },
                      child:
                      Container(
                        height: 50,

                        child: Row(
                          children: [
                            Text(
                              S.current.start_dat,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                             /* decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          PrefUtils.prefs.setString("addressbook",
                              "SubscriptionScreen");

                          Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                              arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                                "itemname": itemname.toString(),
                                "itemid": itemid.toString(),
                                "itemimg":itemimg.toString(),
                                "varname": varname.toString(),
                                "varprice": varprice.toString(),
                                "paymentMode":paymentMode.toString(),
                                "cronTime": routeArgs['cronTime'].toString(),
                                "name": routeArgs['name'].toString(),
                                "varmrp":routeArgs['varmrp'].toString(),
                                "varid": routeArgs['varid'].toString(),
                                "brand" :brand.toString()
                              });
                        });
                      },
                      child: Column(

                        children: [
                          Row(
                            children: [
                              Container(
                                  child: Text(S.current.address, style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),)
                              ),


                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    Customername,
                                    style: TextStyle(
                                      color: ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(

                                    child: Text(
                                      S.of(context).edit,//"CHANGE",
                                      style: TextStyle(
                                          color: ColorCodes.greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Flexible(

                                child: Text(
                                  address,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 60.0,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  debugPrint("subscribe....");
                  setState(() {
                    // if(typeselected == S.current.daily){
                    //   print("weeklist...Daily.."+SelectedDaily.toString()+"  "+ deliveryNum.toString());
                    // }else{
                    //   print("weeklist...else.."+SelectedWeek.toString());
                    // }

                    if(address == ""){
                      Fluttertoast.showToast(msg: S.current.please_add_delivery_address);
                    }else if(SelectedWeek.length == 0 && typeselected != S.current.daily){
                      Fluttertoast.showToast(msg: S.current.please_select_repeat_type);
                    }
                    else{
                      debugPrint("subscribe....2");

                     // print("weeklist..."+SelectedDaily.toString()+"  "+SelectedWeek.toString()+"  "+addressitemsData.items[0].userid.toString());
                     // print("type..: "+typeselected+"  "+ addressitemsData.items[0].useraddtype.toString()+"  "+PrefUtils.prefs.getString('userID').toString());
                     // print("no of days..."+SelectedDaily.length.toString()+"  "+SelectedWeek.length.toString());
                      double total= ((_itemCount * double.parse(varprice)) * (deliveryNum));
                      List<String> weeks  = [];
                      SelectedWeek.map((e) => weeks.add(e.weekname)).toList();
                      debugPrint("SelectedWeek.."+weeks.toString());
                      Navigator.of(context)
                          .pushReplacementNamed(PaymenSubscriptionScreen.routeName,arguments: {
                        "addressid":addressitemsData.items[0].userid.toString(),
                        "useraddtype": addressitemsData.items[0].useraddtype.toString(),
                        "startDate":datecontroller.text,
                        "endDate": _selectedDate1.toString(),
                        "itemCount": _itemCount.toString(),
                        "deliveries": deliveryNum.toString(),
                        "total": total.toString(),
                        "schedule": typeselected,
                        "itemid": routeArgs['itemid'].toString(),
                        "itemimg": routeArgs['itemimg'].toString(),
                        "itemname":itemname.toString(),
                        "varprice":routeArgs['varprice'].toString(),
                        "varname":routeArgs['varname'].toString(),
                        "address":address.toString(),
                        "paymentMode": paymentMode.toString(),
                        "cronTime": cronTime.toString(),
                        "name": name.toString(),
                        "varid": varid.toString(),
                        "varmrp":routeArgs['varmrp'].toString(),
                        "brand" :brand.toString(),
                        "weeklist":(typeselected == S.current.daily)?SelectedDaily.toString():weeks.toString(),
                        "no_of_days":(typeselected == S.current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString()
                      });
                    }
                  });
                },
                child: Container(
                  height: 50,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: ColorCodes.primaryColor,
                    border: Border.all(color: ColorCodes.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Center(
                      child: Text(S.of(context).subscribe,textAlign: TextAlign.center,style: TextStyle(
                        color: ColorCodes.whiteColor, fontSize: 20, fontWeight: FontWeight.bold
                      ),)
                  ),
                ),
              ),
              if (_isWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),

            ],
        ),
      ),
          );

    }

    Widget _bodyMobile() {

      debugPrint("address................"+ address + "  "+typeselected);
      debugPrint("date time...."+datecontroller.text);
      String channel = "";
      try {
        if (Platform.isIOS) {
          channel = "IOS";
        } else {
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }
      var finalDa;
      if(typeselected == S.current.daily){
        DateTime weekdayOf(DateTime time, int weekday) => time.add(Duration(days: weekday - time.weekday));
        debugPrint("weekdays..."+ weekdayOf(now, 5).toString());
        finalDa = now.add(Duration(days: deliveryNum));
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDa);
        debugPrint("_selectedDate1..."+ _selectedDate1.toString());
      }
      else {

     /*   int initialDelivery = deliveryNum;
        List<String> weeks  = [];
        SelectedWeek.map((e) => weeks.add(e.weekname)).toList();
        for(int i =0; i <=  initialDelivery ; i++){
          for(int j=0; j <= selectedweeklydata.length ;j++){
            if(weeks.contains(selectedweeklydata[j])){
              initialDelivery = initialDelivery+1;
              finaldate = _selectedDate.add(Duration(days:  initialDelivery));
            }
          }
        }
        debugPrint("final date...."+ finaldate.toString());*/
        debugPrint("selected...");
        debugPrint("selected...weekdays");
        initialdate = _selectedDate;
        List<int> availableTime = [];

        debugPrint("SelectedWeek...."+SelectedWeek.length.toString());
        for (int i = 0; i < SelectedWeek.length; i++) {
          debugPrint("SelectedWeekweekname...."+SelectedWeek[i].weekname);
          availableTime.add(SelectedWeek[i].weekname == 'Mon'
              ? 1
              : SelectedWeek[i].weekname == 'Tue'
              ? 2
              : SelectedWeek[i].weekname == 'Wed'
              ? 3
              : SelectedWeek[i].weekname == 'Thu'
              ? 4
              : SelectedWeek[i].weekname == 'Fri' ? 5
              : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

        }

        debugPrint("selected...initial...weekdays"+deliveryNum.toString());
        try{
          for (int i = 0; i <= deliveryNum; i++) {
            debugPrint("selected...initial...for..loop"+SelectedWeek.toList().toString());
            availableTime.map((e) {
              debugPrint("selected...inside.."+e.toString()+"  "+initialdate.weekday.toString());
              if (e == initialdate.weekday) {
                debugPrint("selected...name...");
               // delivFinal ++;
              }
            }).toList();
            initialdate = initialdate.add(Duration(days: 1));
          }
        }catch(e){
          debugPrint("e......."+e.toString());
        }

        finalDate = initialdate;
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDate);
        debugPrint("selected...finalDate..."+ finalDate.toString()+"  "+_selectedDate1.toString());

      }

      return loading?
      SubscriptionShimmer()
        :checkaddress?
      Container(
        padding:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
        color: ColorCodes.whiteColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,

                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Center(
                      child: Container(
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: itemimg,
                          placeholder: (context, url) => Image.asset(
                            Images.defaultProductImg,
                            width: 100,
                            height: 100,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            Images.defaultProductImg,
                            width: 100,
                            height: 100,
                          ),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      brand,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemname,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                                      varname,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 2,),
                                  Text(
                                    IConstants.currencyFormat + " " + double.parse(varmrp).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey),
                                  )
                                ],
                              ),

                            ])),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 80,
                child: Row(
                  children: <Widget>[

                    Text(
                      S.current.quantity_per_day,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),

                    Spacer(),
                    Row(
                      children: [
                        _itemCount!=0?
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount==1? _itemCount:_itemCount--);
                          },
                          child: new  Container(
                            color: ColorCodes.accentColor,
                            width: 40,
                            height: 40,
                            child:Center(
                              child: Text(
                                "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        )
                            :
                        new Container(),
                        Container(
                            color: ColorCodes.primaryColor,
                            width: 40,
                            height: 40,
                            child:
                            Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.whiteColor, fontSize: 14, fontWeight: FontWeight.bold),))
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount++);
                          },
                          child: Container(
                            color: ColorCodes.accentColor,
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),

              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 125,
                child: WeekSelector(onclick: (weeklist,type){
                  SelectedWeek.clear();
                  SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                  typeselected = type;
                  print("weeklist..wee"+SelectedWeek.toString());
                  print("type: "+typeselected);
                },),
              ),

              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  showDeliveries(context, setState);
                },
                child: Container(

                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.recharge_or_topup,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(10),
                      /*  decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              deliveryNum.toString() + " " + S.of(context).deliveries,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  setState(() {
                    _selectDate(context,setState);
                  });
                },
                child:
                Container(
                  height: 50,

                  child: Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.start_dat,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                       /* decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              DateFormat("dd-MM-yyyy").format(_selectedDate),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  PrefUtils.prefs.setString("addressbook",
                      "SubscriptionScreen");

                  Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                      arguments: {
                        'addresstype': "new",
                        'addressid': "",
                        'delieveryLocation': "",
                        'latitude': "",
                        'longitude': "",
                        'branch': "",
                        "itemname": itemname.toString(),
                        "itemid": itemid.toString(),
                        "itemimg":itemimg.toString(),
                        "varname": varname.toString(),
                        "varprice": varprice.toString(),
                        "paymentMode":paymentMode.toString(),
                        "cronTime": routeArgs['cronTime'].toString(),
                        "name": routeArgs['name'].toString(),
                        "varmrp":routeArgs['varmrp'].toString(),
                        "varid": routeArgs['varid'].toString(),
                        "brand" :brand.toString()
                      });
                },
                child: Column(
                  children: [
                    Row(

                      children: [
                        Container(
                            child: Text(S.current.address, style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),)
                        ),
                     Spacer(),
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              )),
                          child: Center(child:
                          Text(S.current.add_address,style: TextStyle(color: ColorCodes.whiteColor),
                            textAlign: TextAlign.center,)),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      :Container(
        padding:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
        height: MediaQuery.of(context).size.height,
        color: ColorCodes.whiteColor,
        child: SingleChildScrollView(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(

                height: 130,

                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                Center(
                  child: Container(
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl: itemimg,
                      placeholder: (context, url) => Image.asset(
                        Images.defaultProductImg,
                        width: 100,
                        height: 100,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        Images.defaultProductImg,
                        width: 100,
                        height: 100,
                      ),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      brand,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemname,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                                      varname,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 2,),
                                  Text(
                                    IConstants.currencyFormat + " " + double.parse(varmrp.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey),
                                  )
                                ],
                              ),

                            ])),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 80,
                child: Row(
                  children: <Widget>[

                      Text(
                       S.current.quantity_per_day,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),

                    Spacer(),
                    Row(
                      children: [
                        _itemCount!=0?
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount==1? _itemCount:_itemCount--);
                          },
                          child: new  Container(
                            color: ColorCodes.accentColor,
                            width: 40,
                            height: 40,
                            child:Center(
                              child: Text(
                                "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        )
                            :
                        new Container(),
                        Container(
                            color: ColorCodes.primaryColor,
                            width: 40,
                            height: 40,
                            child:
                            Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.whiteColor, fontSize: 14, fontWeight: FontWeight.bold),))
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount++);
                          },
                          child: Container(
                            color: ColorCodes.accentColor,
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),

              SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
                  child: WeekSelector(onclick: (weeklist,type){
                    SelectedWeek.clear();
                    SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                    typeselected = type;
                 print("weeklist..wee"+SelectedWeek.toString());
                 print("type: "+typeselected);
                  },),
                ),

              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  showDeliveries(context, setState);
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        S.current.recharge_or_topup,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                       /* decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              deliveryNum.toString() + " " + S.of(context).deliveries,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  setState(() {
                    _selectDate(context,setState);
                  });
                },
                child:
                Container(
                  height: 50,

                  child: Row(
                    children: [
                      Text(
                        S.current.start_dat,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                       /* decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              DateFormat("dd-MM-yyyy").format(_selectedDate),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
             GestureDetector(
               onTap: (){
                 setState(() {
                   PrefUtils.prefs.setString("addressbook",
                       "SubscriptionScreen");

                   Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                       arguments: {
                         'addresstype': "new",
                         'addressid': "",
                         'delieveryLocation': "",
                         'latitude': "",
                         'longitude': "",
                         'branch': "",
                         "itemname": itemname.toString(),
                         "itemid": itemid.toString(),
                         "itemimg":itemimg.toString(),
                         "varname": varname.toString(),
                         "varprice": varprice.toString(),
                         "paymentMode":paymentMode.toString(),
                         "cronTime": routeArgs['cronTime'].toString(),
                         "name": routeArgs['name'].toString(),
                         "varmrp":routeArgs['varmrp'].toString(),
                         "varid": routeArgs['varid'].toString(),
                         "brand" :brand.toString()
                       });
                 });
               },
                 child: Container(
                   padding: EdgeInsets.only(top: 10),
                   child: Column(
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                           Text(
                             Customername,
                             style: TextStyle(
                               color: ColorCodes.blackColor,
                               fontWeight: FontWeight.bold,
                               fontSize: 16.0,
                             ),
                           ),
                           Spacer(),
                           Container(

                             child: Text(
                               S.of(context).edit,//"CHANGE",
                               style: TextStyle(
                                   color: ColorCodes.greenColor,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 13.0),
                             ),
                           ),
                           SizedBox(
                             width: 10.0,
                           ),
                         ],
                       ),
                       SizedBox(height: 5,),
                       Row(
                         children: [

                           Flexible(

                             child: Text(
                               address,
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 14.0,
                               ),
                             ),
                           ),

                           SizedBox(
                             width: 60.0,
                           ),
                         ],
                       ),

                     ],
                   ),
                 ),
               ),

            ],
          ),
        ),
      );

    }
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
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
            (_isWeb && !ResponsiveLayout.isSmallScreen(context))? _bodyWeb():Flexible(child: _bodyMobile()),

          ],
        ),
        bottomNavigationBar:(_isWeb)?SizedBox.shrink():
        (datecontroller.text == "")? SizedBox.shrink():bottomNavigationbar(),
      ),
    );
  }

  Future<void> _selectDate( BuildContext context, setState ) async {
    if(SelectedWeek == "M"){

    }


    var now = new DateTime.now();
    debugPrint("date time friday...."+DateTime.friday.toString());
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
          ..text = DateFormat("yyyy-MM-dd").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller.text.length,
              affinity: TextAffinity.upstream));
      });
  }

  bool _dateAvailable(DateTime day) {
    List<int> weeks = [1, 2, 3, 4, 5, 6, 7];
    List<int> availableTime = [];

    debugPrint("SelectedWeek...."+SelectedWeek.length.toString());
    for (int i = 0; i < SelectedWeek.length; i++) {
      debugPrint("SelectedWeekweekname...."+SelectedWeek[i].weekname);
      availableTime.add(SelectedWeek[i].weekname == 'Mon'
          ? 1
          : SelectedWeek[i].weekname == 'Tue'
          ? 2
          : SelectedWeek[i].weekname == 'Wed'
          ? 3
          : SelectedWeek[i].weekname == 'Thu'
          ? 4
          : SelectedWeek[i].weekname == 'Fri' ? 5
          : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

    }
    debugPrint("availableTime.."+availableTime.toString());
    List<int> difference = weeks.toSet().difference(availableTime.toSet()).toList();
    debugPrint("difference.."+difference.toString() + "  "+difference.length.toString());

    // bool _dateAvailable(DateTime day) {
    //   int count =0;
    //   for (int i = 0; i < difference.length; i++) {
    //     debugPrint("difference length...." + day.weekday.toString() + "  " + difference[i].toString());
    //     if(day.weekday == 6 || day.weekday == 7){
    //
    //       count++;
    //       debugPrint("count..."+count.toString());
    //       return true;
    //     }
    //   }
    //
    //   return false;
    // }

    for (int i = 0; i < difference.length; i++) {
      debugPrint("difference length...." + day.weekday.toString() + "  " + difference[i].toString());
      if (day.weekday == difference[i]) {
        debugPrint("difference if loop....");
        return false;
      }
    }
    debugPrint("count...."+count.toString());
    return true;
  }

  Future<void> _selectDate1( BuildContext context, setState ) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2021, 11, 30),
      selectableDayPredicate: _dateAvailable,

    );
 /*   if (picked != null && picked != _selectedDate1)
      setState(() {
        _selectedDate1 = picked;
        datecontroller1
          ..text = DateFormat("dd-MM-yyyy").format(_selectedDate1)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller1.text.length,
              affinity: TextAffinity.upstream));
      });*/

  }



}
