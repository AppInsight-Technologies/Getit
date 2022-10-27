import 'dart:io';
import '../../models/VxModels/VxStore.dart';
import '../../models/myordersfields.dart';
import '../../models/newmodle/user.dart';
import '../../screens/CodReturnScreen.dart';
import '../../screens/ReturnConfirmation.dart';
import '../../widgets/flutter_flow/flutter_flow_theme.dart';
import 'package:velocity_x/velocity_x.dart';

import '../generated/l10n.dart';

import '../constants/IConstants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/addressitems.dart';
import '../providers/myorderitems.dart';
import '../providers/deliveryslotitems.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../screens/address_screen.dart';
import '../screens/myorder_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import 'orderhistory_screen.dart';

class ReturnScreen extends StatefulWidget {
  static const routeName = '/return-screen';

  @override
  ReturnScreenState createState() => ReturnScreenState();
}

class ReturnScreenState extends State<ReturnScreen> {
  int _groupValue = 0;
  //SharedPreferences prefs;
  var _checkaddress = false;
  List popupItems = [];
  var addressitemsData;
  var deliveryslotData;
  var addtype;
  var address;
  IconData addressicon;
  var _checkslots = false;
  var date, qty;
  MyorderList orderitemData;
  bool _isLoading = true;
  var box_color = ColorCodes.lightColor;
  bool _isWeb = false;
  MediaQueryData queryData;
  bool _selectitem = false;
  double wid;
  double maxwid;
  List<String> namesSplit;
  UserData addressdata;
  bool w = true;
  bool x = false;
  bool y = false;
  bool z = false;
  var note = TextEditingController();
  bool _showCheck=false;
  //var deliverytime=0;
  var returntime=0;
 String reason ;
 String issue ;
  List<String> _issuelist=[];
  String paymentType;
  String amount ="0";
  bool value = false;
  bool exchangevalue = false;
  String finalDate;
  StateSetter exchangeState;
  DateTime orderAdd;
  String month;
  String Date;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
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
    note.text = "";
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      addressdata = (VxState.store as GroceStore).userData;

      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      final orderid = routeArgs['orderid'];
      finalDate      = routeArgs['returnValid'];
      final title = routeArgs['title'];
      debugPrint("esdfgvhbjn"+routeArgs['orderid']);


      await Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
        addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
        debugPrint("qwesdrcfgvh"+addressitemsData.items.length.toString());
      });
      Provider.of<MyorderList>(context,listen: false).Vieworders(orderid).then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(
            context,
            listen: false,
          );
          print("OrderitemData length"+orderitemData.vieworder1.length.toString());
          for(int i=0;i<orderitemData.vieworder1.length;i++){
          //  paymentType = orderitemData.vieworder1[i].opaytype;  //did not get data
            paymentType = orderitemData.items[i].opaytype;
            if (orderitemData.vieworder1[i].deliveryOn != "") {
              debugPrint('test..paymenttype'+orderitemData.vieworder1[i].orderType.toString()+paymentType.toString());
              print("orderitemData.vieworder1[i].returnTime"+orderitemData.vieworder1[i].returnTime);
              DateTime today = new DateTime.now();
              DateTime orderAdd = DateTime.parse(
                  orderitemData.vieworder1[i].deliveryOn).add(Duration(
                  hours: int.parse(orderitemData.vieworder1[i].returnTime)));

              final input = orderitemData.vieworder1[i].available_size.toString();//'[name 1, name2, name3, ...]';
              final removedBrackets = input.substring(1, input.length - 1);
              final parts = removedBrackets.split(', ');

              var joined = parts.map((part) => "$part").join(', ');

              namesSplit = joined.split(", ");

              for(var i=0;i<namesSplit.length;i++) {
                for (var j = 0; j < namesSplit[i].length; j++) {
                  print(namesSplit[i][j]);
                }
              }
              if ((orderAdd.isAtSameMomentAs(today) || orderAdd.isAfter(today)) &&
                  (orderitemData.vieworder[0].ostatus.toLowerCase() ==
                      "delivered" ||
                      orderitemData.vieworder[0].ostatus.toLowerCase() ==
                          "completed")) {
                debugPrint('test1..');
                if (orderitemData.vieworder1[i].returnTime != "")
                  setState(() {
                    _showCheck = true;
                  });
                if (orderitemData.vieworder1[i].returnTime == "0" ) {
                  setState(() {
                    _showCheck = false;
                  });
                } else {
                  setState(() {
                    _showCheck = false;
                  });
                }
              }
            }
          }
         /*
        //  returntime= orderitemData.vieworder1[0].returnTime;
        // int deliverytime=int.parse(orderitemData.vieworder1[0].deliveryOn);
        //  int del=int.parse(orderitemData.vieworder1[0].deliveryOn);
          DateTime today = new DateTime.now();
         // DateTime orderdate=orderitemData.vieworder1[0].deliveryOn;
          DateTime orderplustime =DateTime.parse(orderitemData.vieworder1[0].deliveryOn).add(Duration(hours:int.parse (orderitemData.vieworder1[0].returnTime)));
         DateTime fourtyDaysAgo =today.add(Duration(hours: 7));
          DateTime fiftyDaysAgo = today.subtract(new Duration(hours: 18));
          */
          _isLoading = false;
        });
      });

      setState(() {
//        PrefUtils.prefs.setString("returning_reason", "");
        PrefUtils.prefs.setString("returning_reason", "Quality not adequate");
      });
    //  addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      addressitemsData =(VxState.store as GroceStore).userData;
      if (addressitemsData.billingAddress.length > 0) {
        _checkaddress = true;
        PrefUtils.prefs.setString("addressId", addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].id.toString());
        addtype = addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].addressType;
        address = addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].address;
        addressicon = addressitemsData.billingAddress[addressitemsData.billingAddress.length - 1].addressicon;
        calldeliverslots("1");
      } else {
        _checkaddress = false;
      }

    });
    super.initState();
  }

  Future<void> calldeliverslots(String addressid) async {
    print("checkslot...."
    +addressid.toString());
    Provider.of<DeliveryslotitemsList>(context,listen: false)
        .fetchDeliveryslots(PrefUtils.prefs.getString("addressId"))
        .then((_) {
      deliveryslotData =
          Provider.of<DeliveryslotitemsList>(context, listen: false);
      if (deliveryslotData.items.length <= 0) {

        setState(() {
          _isLoading = false;
          _checkslots = false;
        });

      } else {
        setState(() {
          _isLoading = false;
          _checkslots = true;
          date = deliveryslotData.items[0].dateformat;
          PrefUtils.prefs.setString("fixdate", date);
        });

      }
    });
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      controlAffinity: ListTileControlAffinity.trailing,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
    ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final orderid = routeArgs['orderid'];
    final title = routeArgs['title'];

    final itemLeftCount = routeArgs['itemLeftCount'];

    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SingleChildScrollView(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      color: ColorCodes.lightColor,
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                S.of(context).choose_pickup_address,//"Choose a pickup address",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      child: new ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: /*addressitemsData.items.length*/ addressdata.billingAddress.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLoading = true;
                                  PrefUtils.prefs.setString("addressId",
                                      addressdata.billingAddress[i].id.toString());
                                  addtype =
                                      addressdata.billingAddress[i].addressType;
                                  address =
                                      addressdata.billingAddress[i].address;
                                  addressicon =
                                      addressdata.billingAddress[i].addressicon;
                                  calldeliverslots(
                                      addressdata.billingAddress[i].id.toString());
                                });

                               Navigator.of(context).pop();


                               /* Navigator.of(context).pushReplacementNamed(ReturnScreen.routeName, arguments: {
                                  'orderid': routeArgs['orderid'],
                                  'title':routeArgs['title'],
                                });*/

                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(addressdata.billingAddress[i].addressicon),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          addressdata.billingAddress[i].addressType,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          addressdata.billingAddress[i].houseno + ", " +  addressdata.billingAddress[i].area ,
                                          style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          addressdata.billingAddress[i].landmark + ", " +  addressdata.billingAddress[i].city ,
                                          style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          addressdata.billingAddress[i].state + ", " +  addressdata.billingAddress[i].pincode ,
                                          style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Mobile: " +  addressdata.billingAddress[i].mobile ,
                                          style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Divider(color: Colors.black,),
                    GestureDetector(
                      onTap: () {
                        PrefUtils.prefs.setString("formapscreen", "returnscreen");
                        Navigator.of(context)
                            .pushNamed(AddressScreen.routeName, arguments: {
                          'addresstype': "new",
                          'addressid': "",
                          'delieveryLocation': "",
                          'orderid': routeArgs['orderid'],
                          'title':routeArgs['title'],
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  S.of(context).add_new_address,//"Add new Address",
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            );
          });
    }




    gradientappbarmobile() {
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
          elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
            onPressed: () {
              final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
              Navigator.of(context).pushReplacementNamed(
                  OrderhistoryScreen.routeName,
                  arguments: {
                    'orderid':routeArgs['orderid'],
                    'orderStatus': routeArgs['orderStatus'],
                    'fromScreen': routeArgs['fromScreen'],
                  });
            }),
        title: Text(
          title,
          style: TextStyle(color: ColorCodes.menuColor),
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorCodes.accentColor,
                    ColorCodes.primaryColor
              ])),
        ),
      );
    }
    Widget _bodyWeb(){

       Widget itemsExchange() {
      return Container(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 20,
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( S.of(context).choose_item_to//"Choose Items to "
                  + title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: int.parse(orderitemData.vieworder[0].itemsCount),
                  itemBuilder: (_, i) => Column(
                        children: [
                          Row(
                          children: <Widget>[
                            Container(
                                child: CachedNetworkImage(
                              imageUrl: orderitemData.vieworder1[i].itemImage,
                              placeholder: (context, url) => Image.asset(
                                Images.defaultProductImg,
                                width: 50,
                                height: 50,
                              ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.defaultProductImg,
                                    width: 50,
                                    height: 50,
                                  ),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width *0.30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          orderitemData
                                                  .vieworder1[i].itemname +
                                              " , " +
                                              orderitemData
                                                  .vieworder1[i].varname,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    S.of(context).price//"Price: "
                                        + IConstants.currencyFormat + double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: PopupMenuButton(
                                      onSelected: (selectedValue) {
                                        setState(() {
                                          orderitemData.vieworder1[i]
                                              .qtychange = selectedValue;
//                                                        PrefUtils.prefs.setString("fixdate", date);
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            S.of(context).qty +//"Qty: " +
                                                orderitemData
                                                    .vieworder1[i].qtychange,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      /*icon: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Qty: " + orderitemData.vieworder1[i].qtychange,style: TextStyle(fontSize: 12),),
                                                      Icon(Icons.arrow_drop_down,size: 12,),
                                                    ],
                                                  ),*/
                                      itemBuilder: (_) =>
                                          <PopupMenuItem<String>>[
                                        for (int j = int.parse(orderitemData
                                                .vieworder1[i].qty);
                                            j >= 1;
                                            j--)
                                          new PopupMenuItem<String>(
                                              child: Text(j.toString()),
                                              value: j.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            (_showCheck||orderitemData.vieworder1[i].returnTime!= "0")?
                            Checkbox(
                              value: orderitemData.vieworder1[i].checkboxval,
                              onChanged: (bool value) {
                                setState(() {
                                  orderitemData.vieworder1[i].checkboxval =
                                      value;
                                });
                              },
                            ):IconButton(onPressed: (){
                              Fluttertoast.showToast(msg: "$title " +S.of(context).option_expired//option expired for this product"
                              );
                            },
                                icon: Icon(Icons.check_box_outline_blank_sharp,size:22,color: Colors.grey[600],)),
                          ],
                            ),
                          Divider(),
                        ],
                      )),
            ),
//                              SizedBox(height: 10.0,),
          ],
        ),
      );
    }
       Widget proceed() {
      return Column(
        children: [
           Container(
                width: MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                      height: 50,
                          child: Text( S.of(context).why_returning,//"Why are you returning this?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
//                      SizedBox(height: 10.0,),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs.setString("returning_reason",
                                              "Quality not adequate");
                                          w = true;
                                          x = false;
                                          y = false;
                                          z = false;
                                        });
                                      },
                                      child: w
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S.of(context).qty_not_adequate,//"Quality not adequate",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text( S.of(context).qty_not_adequate,//"Quality not adequate"
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                       child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            PrefUtils.prefs.setString("returning_reason",
                                                "Wrong item was sent");
                                            w = false;
                                            x = true;
                                            y = false;
                                            z = false;
                                          });
                                        },
                                        child: x
                                            ? Container(
                                                padding: EdgeInsets.all(10),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    12,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width*0.20,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      new Radius.circular(5.0)),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  S.of(context).wrong_item_sent,// "Wrong item was sent",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(10),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    12,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width*0.20,
                                                decoration: BoxDecoration(
                                                  color: box_color,
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      new Radius.circular(5.0)),
                                                ),
                                                alignment: Alignment.center,
                                                child:
                                                    Text( S.of(context).wrong_item_sent,//"Wrong item was sent"
                                                    ),
                                              )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                     child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs.setString("returning_reason",
                                              "Item defective");
                                          w = false;
                                          x = false;
                                          y = true;
                                          z = false;
                                        });
                                      },
                                      child: y
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *0.20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S.of(context).item_defective,//"Item defective",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text( S.of(context).item_defective,//"Item defective"
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs.setString("returning_reason",
                                              "Product damaged");
                                          w = false;
                                          x = false;
                                          y = false;
                                          z = true;
                                        });
                                      },
                                      child: z
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S.of(context).product_damaged,//"Product damaged",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text( S.of(context).product_damaged,//"Product damaged"
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
//                                        Text(PrefUtils.prefs.getString('returning_reason')),
                            ],
                          ),
                        ),

                        Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).pickup_address,//"Pickup address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
//                      SizedBox(height: 10.0,),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              _checkaddress
                                  ? Container(
                                      height: 80,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.0),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
//                            SizedBox(width: 10.0,),
                                          Expanded(
                                              child: Text(
                                            address,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )),
                                          MouseRegion(
                                             cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                onTap: () {
                                                  _settingModalBottomSheet(
                                                      context);
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      S.of(context).change_caps,//"CHANGE",
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "---------",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
//                            SizedBox(width: 10.0,),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.0),
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Spacer(),
                                          FlatButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor:
                                                Theme.of(context).buttonColor,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      3.0),
                                            ),
                                            onPressed: ()  {
                                              PrefUtils.prefs.setString("addressbook",
                                                  "returnscreen");
                                              Navigator.of(context).pushNamed(
                                                  AddressScreen.routeName,
                                                  arguments: {
                                                    'addresstype': "new",
                                                    'addressid': "",
                                                    'delieveryLocation': "",
                                                    'orderid': routeArgs['orderid'],
                                                    'title':routeArgs['title'],
                                                  });
                                            },
                                            child: Text(
                                              S.of(context).add_address,// 'Add Address',
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                              Divider(),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Image.asset(
                                  Images.shoppinglistsImg,
                                  width: 25.0,
                                  height: 35.0,
                                ),
                                title: Transform(
                                  transform:
                                      Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: TextField(
                                    controller: note,
                                    decoration: InputDecoration.collapsed(
                                        hintText:
                                        S.of(context).any_store_request,//"Any store request? We will try our best to co-operate",
                                        hintStyle: TextStyle(fontSize: 12.0),
                                        //contentPadding: EdgeInsets.all(16),
                                        //border: OutlineInputBorder(),
                                        fillColor: ColorCodes.lightGreyColor),
                                    //minLines: 3,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

//                      SizedBox(height: 10.0,),
                        Container(

                          width: MediaQuery.of(context).size.width - 20,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).choose_date,//"Choose date",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ),
                        Container(
                          color : Colors.white,
                          child: Column(

                            children: [
//                            Text(PrefUtils.prefs.getString('fixdate')),
                              _checkslots
                                  ? new ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: deliveryslotData.items.length,
                                      itemBuilder: (_, i) => Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3,
                                                child: _myRadioButton(
                                                  title: deliveryslotData
                                                      .items[i].dateformat,
                                                  value: i,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _groupValue = i;
                                                      date = deliveryslotData
                                                          .items[i].dateformat;
                                                      PrefUtils.prefs.setString(
                                                          "fixdate", date);
                                                    });
                                                  },
                                                ),
                                              ),
//                                    Text(deliveryslotData.items[i].dateformat),
                                            ],
                                          ))

                                  : Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    1.3,
                                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                    child: Text(
                                      S.of(context).currently_no_slot,//"Currently there is no slots available",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ),

                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),

                        Row(
                          children: <Widget>[
                            Spacer(),
                            MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                onTap: () {
                                  List array = [];
                                  String orderid;
                                  String itemname;

                                  for (int i = 0;
                                      i <
                                          int.parse(orderitemData
                                              .vieworder[0].itemsCount);
                                      i++) {
                                    if (orderitemData.vieworder1[i].checkboxval) {
                                      setState(() {
                                        _selectitem = true;
                                        orderid = orderitemData
                                            .vieworder1[i].itemorderid;
                                        itemname = orderitemData
                                                .vieworder1[i].itemname +
                                            " - " +
                                            orderitemData.vieworder1[i].varname;
                                        //itemvar = orderitemData[i].varname;
                                      });
                                      var value = {};
//                                          value["\"itemId\""] = "\"" + orderitemData[i].itemid + "\"";
                                      value["\"itemId\""] = "\"" +
                                          orderitemData.vieworder1[i]
                                              .customerorderitemsid +
                                          "\"";
                                      value["\"qty\""] = "\"" +
                                          orderitemData.vieworder1[i].qty +
                                          "\"";
                                      //value["\"itemname\""] = "\"" + itemname + "\"";
                                      array.add(value.toString());
                                    }
                                  }
                                  if (_selectitem) {
                                    _dialogforReturning(context);
                                    Provider.of<MyorderList>(context,listen: false)
                                        .ReturnItem(
                                            array.toString(), orderid, itemname,reason,issue,note.text)
                                        .then((_) {
                                      Provider.of<MyorderList>(context,listen: false)
                                          .Vieworders(orderid)
                                          .then((_) {
                                        setState(() {
                                          Navigator.of(context).pop();
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                            MyorderScreen.routeName,
                                              arguments: {
                                                "orderhistory": ""
                                              }
                                          );
                                        });
                                      });
                                    });
                                  }
                                  else if(addressitemsData.items.length <= 0){
                                    Fluttertoast.showToast(
                                      msg: S.of(context).please_add_delivery_address,//"Please select the item!!!",
                                      fontSize: MediaQuery.of(context).textScaleFactor *13);
                                  }
                                  else {
                                    Fluttertoast.showToast(
                                        msg: S.of(context).please_select_item,//"Please select the item!!!",
                                      fontSize: MediaQuery.of(context).textScaleFactor *13,);
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.43,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                      child: Text(
                                        S.of(context).proceed,//'PROCEED',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
        ],
      );
    }
       queryData = MediaQuery.of(context);
       wid= queryData.size.width;
       maxwid=wid*0.90;
    return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
             child: SingleChildScrollView(
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                    child: Container(
                      constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,

                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        Flexible(child: itemsExchange()),
                        SizedBox(width: 30,),
                        Flexible(child: proceed()),
                        SizedBox(width: 20,),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10.0,),
              if (_isWeb)
                  Footer(
                      address: PrefUtils.prefs.getString("restaurant_address")),
              ],
            ),
            ),
          );
    }

    Widget _bodyMobile(){
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      orderAdd= DateTime.parse(routeArgs['orderStatus']);
      if(orderAdd.month == 1){
        month = "Jan";
      }else if(orderAdd.month == 2){
        month = "Feb";
      }else if(orderAdd.month == 3){
        month = "Mar";
      }else if(orderAdd.month == 4){
        month = "Apr";
      }else if(orderAdd.month == 5){
        month = "May";
      }else if(orderAdd.month == 6){
        month = "June";
      }else if(orderAdd.month == 7){
        month = "July";
      }else if(orderAdd.month == 8){
        month = "Aug";
      }else if(orderAdd.month == 9){
        month = "Sep";
      }else if(orderAdd.month == 10){
        month = "Oct";
      }else if(orderAdd.month == 11){
        month = "Nov";
      }else if(orderAdd.month == 12){
        month = "Dec";
      }
      var formattedDate = "${orderAdd.day} ${month}, ${orderAdd.year}";
      setState(() {
        Date = formattedDate.toString() ;
      });
       Widget itemsExchange() {
      return Container(
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorCodes.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12)
        ),
       // margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Text( "Order Id:"
                    + routeArgs['orderid'],

                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Spacer(),
                Text( Date,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(width: 5,),
              ],
            ),
            SizedBox(height: 10,),
            Text( S.of(context).choose_item_to//"Choose Items to "
                + title,

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             SizedBox(height: 20,),
             ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: int.parse(orderitemData.vieworder[0].itemsCount),
                itemBuilder: (_, i) => Column(
                      children: [
                        Row(
                        children: <Widget>[
                          Container(
                              child: orderitemData.vieworder1[i].extraAmount == "888"? Image.asset(Images.membershipImg,
                                color: Theme.of(context).primaryColor,
                                width: 90,
                                height: 110,
                                fit: BoxFit.cover,
                              ): ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: CachedNetworkImage(
                                  imageUrl: orderitemData.vieworder1[i].itemImage,
                                  placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                                    width: 90,
                                    height: 110,),
                                  errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                                    width: 90,
                                    height: 110,),
                                  width: 90,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              )
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/2.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        orderitemData.vieworder1[i].itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),
                                      )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  orderitemData.vieworder1[i].fit,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 12,color: ColorCodes.greyColor,fontWeight: FontWeight.w700),),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text("Size: " + orderitemData.vieworder1[i].varname, style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Text("|", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    PopupMenuButton(
                                      onSelected: (selectedValue) {
                                        setState(() {
                                          orderitemData.vieworder1[i]
                                              .qtychange = selectedValue;
//                                                        PrefUtils.prefs.setString("fixdate", date);
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            S.of(context).qty//"Qty: "
                                                + orderitemData
                                                .vieworder1[i].qtychange,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 16,
                                          ),
                                        ],
                                      ),

                                      itemBuilder: (_) =>
                                      <PopupMenuItem<String>>[
                                        for (int j = int.parse(orderitemData
                                            .vieworder1[i].qty);
                                        j >= 1;
                                        j--)
                                          new PopupMenuItem<String>(
                                              child: Text(j.toString()),
                                              value: j.toString()),
                                      ],
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                (title == "Return")? Text(
                                  "Refund Amount: "
                                      + IConstants.currencyFormat +
                                      double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ):
                                Text(
                                  IConstants.currencyFormat +
                                      double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                                ,

                              ],
                            ),
                          ),
                         // Spacer(),
                          (_showCheck||orderitemData.vieworder1[i].returnTime!= "0")?
                          Checkbox(
                            activeColor: ColorCodes.discountoff,
                            value: orderitemData.vieworder1[i].checkboxval,
                            onChanged: (bool value) {
                              setState(() {
                                amount =  orderitemData.vieworder1[i].price;
                                orderitemData.vieworder1[i].checkboxval =
                                    value;
                              });
                            },
                          ):IconButton(onPressed: (){
                            Fluttertoast.showToast(msg: "$title " + S.of(context).option_expired);//option expired for this product");
                          },
                              icon: Icon(Icons.check_box_outline_blank_sharp,size:20,color: Colors.grey[600],))
                        ],
                          ),
                        Divider(),
                      ],
                    )),
            SizedBox(height: 10,),
            Container(
              width:MediaQuery.of(context).size.width - 20,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                color: ColorCodes.returnColl,
                border: Border.all(
                    color: ColorCodes.discountoff
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Center(
                    child: (title == "Return")?Text(
                      "Return Valid Till "+ finalDate+".",
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ):
                    Text(
                      "Exchange Valid Till "+ finalDate+".",
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      );
    }
       Widget proceed() {
      return Column(
        children: [
          (title == "Return")?SizedBox.shrink() :
          Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text( "Enter Exchange Details",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),
                Text( "Select size to exchange",
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400,color: ColorCodes.grey)),
                SizedBox(height: 10,),
                // Container(
                //   margin: EdgeInsets.only(left: 20, right: 20),
                //   child: new GridView.builder(
                //     shrinkWrap: true,
                //     controller: new ScrollController(keepScrollOffset: false),
                //     itemCount: orderitemData.vieworder1.length,
                //     gridDelegate:
                //     new SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 7,
                //       crossAxisSpacing: 3,
                //       mainAxisSpacing: 3,
                //     ),
                //     itemBuilder: (_, i) {
                //
                //       final input = orderitemData.vieworder1[i].available_size.toString();//'[name 1, name2, name3, ...]';
                //       final removedBrackets = input.substring(1, input.length - 1);
                //       final parts = removedBrackets.split(', ');
                //
                //       var joined = parts.map((part) => "$part").join(', ');
                //
                //       print("final value...."+joined);
                //
                //
                //      return Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child: Container(
                //           width: 70,
                //           height: 70,
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(50),
                //             border: Border.all(
                //               color:
                //               ColorCodes.discountoff,
                //               width: 1,
                //             ),
                //           ),
                //           child: Center(
                //             child: Text(
                //               joined.toString(),
                //               style: FlutterFlowTheme.bodyText1.override(
                //                   fontSize: 14,
                //                   fontFamily: 'Poppins',
                //                   fontWeight: FontWeight.w600,
                //                   color:
                //                   ColorCodes.discountoff
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //
                //     }
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: new GridView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(keepScrollOffset: false),
                      itemCount: namesSplit.length,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                      ),
                      itemBuilder: (_, i) {




                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color:
                                ColorCodes.discountoff,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                namesSplit[i].toString(),
                                style: FlutterFlowTheme.bodyText1.override(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color:
                                    ColorCodes.discountoff
                                ),
                              ),
                            ),
                          ),
                        );

                      }
                  ),
                ),
              ],
            ),
          ),
          (title == "Return")?SizedBox.shrink() : SizedBox(height: 6,),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text( "Reason for "+title,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                Text( "Please tell us the reason for "+ title +" as it will help us serve you better in the future",
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400,color: ColorCodes.grey)),
                SizedBox(height: 10,),
                Container(
                  //padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 60,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorCodes.lightGreyColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: reason,
                              iconSize: 30,

                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: (title == "Return")?Text('Select '+title+' reason *',style:
                                TextStyle(fontWeight: FontWeight.bold),):Text('Select Reason *',style:
                              TextStyle(fontWeight: FontWeight.bold),),
                              onChanged: (String newValue) =>_getBrandsList(newValue),
                              items: orderitemData.reasons.map((item) {

                                return DropdownMenuItem(
                                  child: Text(item.title,style: TextStyle(color: ColorCodes.blackColor),),
                                  value: item.title.toString(),
                                );
                              })?.toList() ?? [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 60,
                  // padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorCodes.lightGreyColor,
                      width: 1,
                    ),
                  ),
                  // color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: issue,
                              iconSize: 30,
                             
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: (title == "Return")?Text('Select Issue',style:
                              TextStyle(fontWeight: FontWeight.bold),):Text('Select Sub Reasons',style:
                              TextStyle(fontWeight: FontWeight.bold),),
                              onChanged: (String newValue) {
                                setState(() {
                                  issue = newValue;
                                  print(issue);
                                });
                              },
                              items: _issuelist?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item.toString(),style: TextStyle(color: ColorCodes.blackColor),),
                                  value: item.toString(),
                                );
                              })?.toList() ?? [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // PopupMenuButton(
                //   offset: const Offset(0, 50),
                //   onSelected: (selectedValue) {
                //    setState(() {
                //      reason = selectedValue;
                //      PrefUtils.prefs.setString("returning_reason", selectedValue);
                //    });
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width - 50,
                //     height: 60,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ColorCodes.lightGreyColor,
                //         width: 1,
                //       ),
                //     ),
                //     child: Row(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.only(left: 10.0),
                //           child: Text(
                //             reason,
                //             style: TextStyle(
                //               color: ColorCodes.greyColor,
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold
                //             ),
                //           ),
                //         ),
                //         Spacer(),
                //         Icon(Icons.arrow_drop_down, color: ColorCodes.greyColor,),
                //       ],
                //     ),
                //   ),
                //   itemBuilder: (_)
                //   {
                //     debugPrint("orderitemData.reasons.length..."+orderitemData.reasons.length.toString());
                //         return <PopupMenuItem<String>>[
                //               for (int j = 0; j < orderitemData.reasons.length;
                //                   j++)
                //                 new PopupMenuItem<String>(
                //                   height: 28,
                //                   child: Text(
                //                     orderitemData.reasons[j].title,
                //                     style: TextStyle(fontSize: 18),
                //                   ),
                //                   value: orderitemData.reasons[j].title,
                //                 ),
                //             ];
                //           }),
                // SizedBox(height: 10,),
                // PopupMenuButton(
                //     offset: const Offset(0, 50),
                //     onSelected: (selectedValue) {
                //       setState(() {
                //         issue = selectedValue;
                //         PrefUtils.prefs.setString("returning_reason", selectedValue);
                //       });
                //     },
                //     child: Container(
                //       width: MediaQuery.of(context).size.width - 50,
                //       height: 60,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(
                //           color: ColorCodes.lightGreyColor,
                //           width: 1,
                //         ),
                //       ),
                //       child: Row(
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(left: 10.0),
                //             child: Text(
                //               issue,
                //               style: TextStyle(
                //                   color: ColorCodes.greyColor,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.bold
                //               ),
                //             ),
                //           ),
                //           Spacer(),
                //           Icon(Icons.arrow_drop_down, color: ColorCodes.greyColor,),
                //         ],
                //       ),
                //     ),
                //     itemBuilder: (_)
                //     {
                //       debugPrint("orderitemData.reasons.length..."+orderitemData.reasons.length.toString());
                //       return <PopupMenuItem<String>>[
                //         for (int j = 0; j < orderitemData.reasons.length; j++)
                //           new PopupMenuItem<String>(
                //             height: 28,
                //             child: Text(
                //               orderitemData.reasons[j].options,
                //               style: TextStyle(fontSize: 18),
                //             ),
                //             value: orderitemData.reasons[j].options,
                //           ),
                //       ];
                //     }),
                SizedBox(height: 10,),
                (title == "Return")?
                Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text( "Additional Remarks",
                       style: TextStyle(
                           color: ColorCodes.greyColor,
                           fontSize: 16,
                           fontWeight: FontWeight.bold
                       ),),
                     SizedBox(height: 5,),
                     TextFormField(
                       maxLines: 10,
                       minLines: 3,
                       textAlign: TextAlign.left,
                        controller: note,
                       decoration: InputDecoration(
                         hoverColor: ColorCodes.primaryColor,
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(6),
                           borderSide: BorderSide(color: Colors.grey),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(6),
                           borderSide: BorderSide(color: Colors.grey),
                         ),
                         focusedErrorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(6),
                           borderSide: BorderSide(color: Colors.grey),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(6),
                           borderSide: BorderSide(color: Colors.grey),
                         ),
                       ),
                       onFieldSubmitted: (_) {
                         // FocusScope.of(context).requestFocus(_lnameFocusNode);
                       },
                       validator: (value) {
                        return null;
                       },
                       onSaved: (value) {

                       },
                     ),
                   ],
                 )
                    :SizedBox.shrink(),

              ],
            ),
          ),
          (title == "Return")?SizedBox(height: 6,):SizedBox.shrink(),
          (title == "Return")?Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(8),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text( "Pickup Instruction",
                    style: TextStyle(
                        fontSize: 16, color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w900)),
                SizedBox(height: 10,),

                new ListTile(
                  minLeadingWidth: 3,
                  leading: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: new Text('Please ensure that the product is in good condition and tags are intact'),
                ),
                new ListTile(
                  minLeadingWidth: 3,
                  leading: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: new Text('The Product will be picked up from your address within 48 hours'),
                )
              ],
            ),
          ):SizedBox.shrink(),
          SizedBox(height: 6,),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            margin:(title == "Return")?EdgeInsets.only(bottom: 0) :EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).pickup_address,
                        style: TextStyle(
                            fontSize: 16,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w900)),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          _settingModalBottomSheet(
                              context);
                        },
                        child: Text(
                          "Change"+" / "+"Edit",//"CHANGE",
                          style: TextStyle(
                              color: ColorCodes.discountoff,
                              fontSize: 12.0,
                              fontWeight:
                              FontWeight.bold),
                        )),
                    SizedBox(width: 10,)
                  ],
                ),
                SizedBox(height: 10,),
                _checkaddress
                    ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderitemData.vieworder[0].customerName,
                      style: TextStyle(fontSize: 18, color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      orderitemData.addressitems[0].houseno + ", " +  orderitemData.addressitems[0].area ,
                      style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      orderitemData.addressitems[0].landmark + ", " +  orderitemData.addressitems[0].city ,
                      style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      orderitemData.addressitems[0].state + ", " +  orderitemData.addressitems[0].pincode ,
                      style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                       "Mobile: " +  orderitemData.addressitems[0].mobile ,
                      style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400),
                    ),
                  ],
                ):
                 Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5.0,
                      ),
                      Spacer(),
                      FlatButton(
                        color:
                        Theme.of(context).primaryColor,
                        textColor:
                        Theme.of(context).buttonColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(
                              3.0),
                        ),
                        onPressed: ()  {
                          PrefUtils.prefs.setString("addressbook",
                              "returnscreen");
                          Navigator.of(context).pushNamed(
                              AddressScreen.routeName,
                              arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'orderid': routeArgs['orderid'],
                                'title':routeArgs['title'],

                              });
                        },
                        child: Text(
                          S.of(context).add_address,//'Add Address',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 6,),
          (paymentType == "paytm" || paymentType =="wallet")?
          Container(
            width: MediaQuery.of(context).size.width - 20,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text(IConstants.currencyFormat +" "+ amount+ " will be refunded as in your Transaction Account within 48 hours after returning the product.",
                    style: TextStyle(
                        fontSize: 16,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w900)),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Checkbox(
                        value: this.value,
                        onChanged: (bool value) {
                          setState(() {
                            this.value = value;
                          });
                        }),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text("I agree that the product is unused with original tags intact.",

                          style: TextStyle(
                              fontSize: 14,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              ],
            ),
          )
             :
          SizedBox.shrink(),
          SizedBox(height: 30,),
        ],
      );
    }
    return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
             child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(15.0),
               child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  itemsExchange(),
                  SizedBox(height: 6.0,),
                  proceed(),
                  SizedBox(height: 6.0,),
                if (_isWeb)
                    Footer(
                        address: PrefUtils.prefs.getString("restaurant_address")),
                ],
            ),
             ),
            ),
          );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? gradientappbarmobile()
          : null,
     // backgroundColor: ColorCodes.whiteColor,
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false, false),
          (_isWeb && !ResponsiveLayout.isSmallScreen(context))?_bodyWeb():_bodyMobile(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isWeb ? SizedBox.shrink() : Container(
        child: _isLoading?
        SizedBox.shrink():
        Container(
          margin: EdgeInsets.all(10.0),
          height: 53,

          child: Row(
            children: [
              GestureDetector(
              onTap: (){
                final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
                Navigator.of(context).pushReplacementNamed(
                    OrderhistoryScreen.routeName,
                    arguments: {
                      'orderid':routeArgs['orderid'],
                      'orderStatus': routeArgs['orderStatus'],
                      'fromScreen': routeArgs['fromScreen'],
                    });
              },
               child: Container(
                  height:53,
                 width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(10.0),bottomLeft:Radius.circular(10.0) ),
                    color: ColorCodes.whiteColor,
                  ),
                  child: Center(
                    child: Text("Back",
                      style: TextStyle(
                        fontSize: 18,

                        color: ColorCodes.discountoff,
                        //color: ColorCodes.discount,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("Return13...");
                  if(title == "Return") {
                    if (paymentType == "paytm" ||
                        paymentType == "wallet") {
                      List array = [];
                      String orderid;
                      String itemname;
                      bool _selectitem = false;
                      if (addressitemsData.billingAddress.length <= 0) {
                        Fluttertoast.showToast(
                            msg: S
                                .of(context)
                                .please_add_delivery_address,
                            //"Please select the item!!!",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13);
                      } else if (!value) {
                        Fluttertoast.showToast(
                          msg:
                          "Please select the agree checkbox",
                          fontSize: MediaQuery
                              .of(context)
                              .textScaleFactor * 13,);
                      } else if (reason == "" || reason == null) {
                        Fluttertoast.showToast(
                            msg: "Please select reason for return",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13);
                      }
                      else {
                        for (int i = 0; i < int.parse(
                            orderitemData.vieworder[0]
                                .itemsCount); i++) {
                          if (orderitemData.vieworder1[i].checkboxval) {
                            setState(() {
                              _selectitem = true;
                              orderid = orderitemData
                                  .vieworder1[i].itemorderid;
                              itemname = orderitemData
                                  .vieworder1[i].itemname +
                                  " - " +
                                  orderitemData.vieworder1[i].varname;
                              //itemvar = orderitemData[i].varname;
                            });
                            var value = {};
//                                          value["\"itemId\""] = "\"" + orderitemData[i].itemid + "\"";
                            value["\"itemId\""] = "\"" +
                                orderitemData.vieworder1[i]
                                    .customerorderitemsid +
                                "\"";
                            value["\"qty\""] = "\"" +
                                orderitemData.vieworder1[i].qty +
                                "\"";
                            //value["\"itemname\""] = "\"" + itemname + "\"";
                            array.add(value.toString());
                          }
                        }
                        if (_selectitem) {
                          _dialogforReturning(context);
                          Provider.of<MyorderList>(
                              context, listen: false)
                              .ReturnItem(
                              array.toString(), orderid, itemname,
                              reason, issue, note.text)
                              .then((_) {
                            Provider.of<MyorderList>(
                                context, listen: false)
                                .Vieworders(orderid)
                                .then((_) {
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed(
                                  ReturnconfirmationScreen.routeName,arguments:
                                    {
                                    "title": "Return"
                                    }
                                );
                              });
                            });
                          });
                        }

                        else {
                          Fluttertoast.showToast(
                            msg: S
                                .of(context)
                                .please_select_item,
                            //"Please select the item!!!",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13,);
                        }
                      }
                    }
                    else {
                      List array = [];
                      String orderid;
                      String itemname;
                      String name;
                      String quantity;
                      String fit;
                      String size;
                      String amount;
                      String img;
                      bool _selectitem = false;
                      if (addressitemsData.billingAddress.length <= 0) {
                        Fluttertoast.showToast(
                            msg: S
                                .of(context)
                                .please_add_delivery_address,
                            //"Please select the item!!!",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13);
                      } else if (reason == "" || reason == null) {
                        Fluttertoast.showToast(
                            msg: "Please select reason for return",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13);
                      }
                      else {
                        for (int i = 0; i < int.parse(
                            orderitemData.vieworder[0]
                                .itemsCount); i++) {
                          if (orderitemData.vieworder1[i].checkboxval) {
                            setState(() {
                              _selectitem = true;
                              orderid = orderitemData
                                  .vieworder1[i].itemorderid;
                              itemname = orderitemData
                                  .vieworder1[i].itemname +
                                  " - " +
                                  orderitemData.vieworder1[i].varname;
                              name = orderitemData
                                  .vieworder1[i].itemname;
                              fit = orderitemData
                                  .vieworder1[i].fit;
                              size = orderitemData
                                  .vieworder1[i].size;
                              quantity = orderitemData
                                  .vieworder1[i].qty;
                              amount = orderitemData
                                  .vieworder1[i].price;
                              img = orderitemData
                                  .vieworder1[i].itemImage;
                              //itemvar = orderitemData[i].varname;
                            });
                            var value = {};
//                                          value["\"itemId\""] = "\"" + orderitemData[i].itemid + "\"";
                            value["\"itemId\""] = "\"" +
                                orderitemData.vieworder1[i]
                                    .customerorderitemsid +
                                "\"";
                            value["\"qty\""] = "\"" +
                                orderitemData.vieworder1[i].qty +
                                "\"";
                            //value["\"itemname\""] = "\"" + itemname + "\"";
                            array.add(value.toString());
                          }
                        }
                        if (_selectitem) {
                          debugPrint("array.." + array.toString());
                          // Navigator.of(context)
                          //     .pushReplacementNamed(
                          //     CodReturnScreen.routeName, arguments: {
                          //   'array': array.toString(),
                          //   'orderid': orderid,
                          //   "itemname": name,
                          //   "fit": fit,
                          //   "size": size,
                          //   "quantity": quantity,
                          //   "amount": amount,
                          //   "img": img,
                          //   "reason": reason,
                          //   "issue": issue,
                          //   "note": note.text,
                          //   "returnValid": finalDate,
                          //   "orderStatus": routeArgs['orderStatus'],
                          //   "Date":Date
                          // }
                          // );
                          _dialogforReturning(context);
                          Provider.of<MyorderList>(
                              context, listen: false)
                              .ReturnItem(
                              array.toString(), orderid, itemname,reason,issue,note.text)
                              .then((_) {
                            Provider.of<MyorderList>(
                                context, listen: false)
                                .Vieworders(orderid)
                                .then((_) {
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed(
                                    ReturnconfirmationScreen.routeName,arguments: {
                                  "title": "Return"
                                }
                                );
                              });
                            });
                          });
                        }
                        else {
                          Fluttertoast.showToast(
                            msg: S
                                .of(context)
                                .please_select_item,
                            //"Please select the item!!!",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13,);
                        }
                      }
                    }
                  }
                  else {
                    String name;
                    String quantity;
                    String fit;
                    String size;
                    String amount;
                    String img;

                      for (int i = 0; i < int.parse(
                          orderitemData.vieworder[0]
                              .itemsCount); i++) {
                        if (orderitemData.vieworder1[i].checkboxval) {
                          setState(() {
                            _selectitem = true;
                            name = orderitemData
                                .vieworder1[i].itemname;
                            fit = orderitemData
                                .vieworder1[i].fit;
                            size = orderitemData
                                .vieworder1[i].size;
                            quantity = orderitemData
                                .vieworder1[i].qty;
                            amount = orderitemData
                                .vieworder1[i].price;
                            img = orderitemData
                                .vieworder1[i].itemImage;
                            //itemvar = orderitemData[i].varname;
                          });
                        }
                      }
                    if (_selectitem) {
                      showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          //backgroundColor: ColorCodes.lightGreyWebColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                          ),
                          builder: (context) {
                            return _submitExchange(
                                context,
                                name,
                                fit,
                                size,
                                quantity,
                                amount,
                                img);
                          });
                    }else{
                      Fluttertoast.showToast(
                        msg: S
                            .of(context)
                            .please_select_item,
                        fontSize: MediaQuery
                            .of(context)
                            .textScaleFactor * 13,);
                    }
                    print("Paymenttype in return screen"+paymentType.toString());
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.02,
                  height: 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorCodes.discountoff,
                  ),
                  child: Center(
                      child: Text(
                        (paymentType =="paytm"|| paymentType == "wallet" ) ? "Return" :"Continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _submitExchange(BuildContext context, String name, String fit, String size, String quantity, String amount, String img) {
    return StatefulBuilder(
        builder: (context, setState1)
        {
          return SingleChildScrollView(
            child: Container(
              // color: ColorCodes.lightGreyWebColor,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    //decoration: BoxDecoration(color: Theme.of(context).buttonColor),
                    //color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

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
                                          "Submit Request",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width - 20,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorCodes.grey.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(12)
                                    ),
                                    // margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        Column(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(6.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: img,
                                                        placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                                                          width: 90,
                                                          height: 110,),
                                                        errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                                                          width: 90,
                                                          height: 110,),
                                                        width: 90,
                                                        height: 110,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width/2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:
                                                        MediaQuery.of(context).size.width /2,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                  name,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        fit,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(fontSize: 12,color: ColorCodes.greyColor,fontWeight: FontWeight.w700),),
                                                      SizedBox(height: 5,),
                                                      Text(
                                                        "Exchange with size : ",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(fontSize: 12,color: ColorCodes.greyColor,fontWeight: FontWeight.bold),),


                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: ColorCodes.discountoff,
                                          value: this.exchangevalue,
                                          onChanged: (bool value) {
                                            setState1(() {
                                              this.exchangevalue = value;
                                            });
                                          }),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Text("I agree that the product is unused with original tags intact.",

                                            style: TextStyle(
                                                fontSize: 14,color: ColorCodes.mediumBlackColor, fontWeight: FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
                                          Navigator.of(context).pushReplacementNamed(
                                              OrderhistoryScreen.routeName,
                                              arguments: {
                                                'orderid':routeArgs['orderid'],
                                                'orderStatus': routeArgs['orderStatus'],
                                                'fromScreen': routeArgs['fromScreen'],
                                              });
                                        },
                                        child: Container(
                                          height: 60,
                                          width:MediaQuery.of(context).size.width * 35/100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft:Radius.circular(10.0),bottomLeft:Radius.circular(10.0) ),
                                            color: ColorCodes.whiteColor,
                                          ),
                                          child: Center(
                                            child: Text("Back",
                                              style: TextStyle(
                                                fontSize: 18,

                                                color: ColorCodes.discountoff,
                                                //color: ColorCodes.discount,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print("Return14...");
                                          if(!exchangevalue){
                                            Fluttertoast.showToast(
                                                msg: "Please select the checkbox",
                                                fontSize: MediaQuery.of(context).textScaleFactor *13);
                                          }else {
                                            // Navigator.of(context)
                                            //     .pushReplacementNamed(
                                            //     ReturnconfirmationScreen
                                            //         .routeName, arguments: {
                                            //   "title": "Exchange"
                                            // }
                                            // );

                                          if(_selectitem) {
                                            List array = [];
                                            String orderid;
                                            String itemname;

                                            for (int i = 0;
                                            i <
                                                int.parse(orderitemData
                                                    .vieworder[0].itemsCount);
                                            i++) {
                                              if (orderitemData.vieworder1[i].checkboxval) {
                                                setState(() {
                                                  _selectitem = true;
                                                  orderid = orderitemData
                                                      .vieworder1[i].itemorderid;
                                                  itemname = orderitemData
                                                      .vieworder1[i].itemname +
                                                      " - " +
                                                      orderitemData.vieworder1[i].varname;
                                                  //itemvar = orderitemData[i].varname;
                                                });
                                                var value = {};
//                                          value["\"itemId\""] = "\"" + orderitemData[i].itemid + "\"";
                                                value["\"itemId\""] = "\"" +
                                                    orderitemData.vieworder1[i]
                                                        .customerorderitemsid +
                                                    "\"";
                                                value["\"qty\""] = "\"" +
                                                    orderitemData.vieworder1[i].qty +
                                                    "\"";
                                                //value["\"itemname\""] = "\"" + itemname + "\"";
                                                array.add(value.toString());
                                              }
        }
                                            exchangeProceed(array,orderid,itemname);
                                          }
                                          }
                                        },
                                        child: Container(
                                          width:MediaQuery.of(context).size.width * 52/100,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            color: ColorCodes.discountoff,
                                          ),
                                          child: Center(
                                              child: Text(
                                                "Continue"/*"Return"*/,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ])),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

  Future<MyordersFields> _getBrandsList(String newValue) async {
    _issuelist.clear();
    for (MyordersFields element in orderitemData.reasons) {
      if(element.title == newValue){
          setState(() {
            issue = null;
            reason = newValue;
            _issuelist = element.options;
          });
          print(reason);
      }
    }
  }

  void exchangeProceed(List array, String orderid, String itemname) {

      _dialogforReturning(context);
      Provider.of<MyorderList>(context,listen: false)
          .ReturnItem(
          array.toString(), orderid, itemname,reason,issue,note.text)
          .then((_) {
        Provider.of<MyorderList>(context,listen: false)
            .Vieworders(orderid)
            .then((_) {
          setState(() {
            Navigator.of(context).pop();
            // Navigator.of(context)
            //     .pushReplacementNamed(
            //     MyorderScreen.routeName,
            //     arguments: {
            //       "orderhistory": ""
            //     }
            // );
            Navigator.of(context)
                .pushReplacementNamed(
                ReturnconfirmationScreen
                    .routeName, arguments: {
              "title": "Exchange"
            }
            );
          });
        });
      });
    }


  _dialogforReturning(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 100.0,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 40.0,
                      ),
                      Text( S.of(context).processing,//'Processing...'
                      ),
                    ],
                  )),
            );
          });
        });
  }

}
