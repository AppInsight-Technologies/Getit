/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/ResponsiveLayout.dart';
import '../providers/addressitems.dart';
import '../screens/address_screen.dart';
import '../constants/ColorCodes.dart';
import '../screens/map_screen.dart';
import '../screens/home_screen.dart';
import '../constants/images.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';

enum FilterOptions {
  Edit,
  Delete,
}

class AddressbookScreen extends StatefulWidget {
  static const routeName = '/addressbook-screen';

  @override
  _AddressbookScreenState createState() => _AddressbookScreenState();
}

class _CustomRadioButton {
  bool buttonLables;
  bool buttonValues;
  bool radioButtonValue;
  bool buttonWidth;
  bool buttonList;

  _CustomRadioButton({
    this.buttonLables,
    this.buttonValues,
    this.radioButtonValue,
    this.buttonWidth,
    // this.buttonColor,
    // this.selectedColor,
    // this.buttonHeight,
    // this.horizontal,
    // this.enableShape,
    // this.elevation,
    // this.customShape,
    // this.fontSize,
    // this.lineSpace,
    // this.buttonSpace,
    // this.buttonBorderColor,
    // this.textColor,
    // this.selectedTextColor,
    // this.initialSelection,
    // this.unselectedButtonBorderColor
  });
}

class _AddressbookScreenState extends State<AddressbookScreen> {
  AddressItemsList addressitemsData;
  //SharedPreferences prefs;
  bool _addresscheck = false;
  int _groupValue = 0;
  String singleAddress = '1';
  int value = 0;
  bool _isWeb = false;
  var _address = "";
  bool _isLoading = true;
  MediaQueryData queryData;
  double wid;
  double maxwid;

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
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      _address = PrefUtils.prefs.getString("restaurant_address");
      PrefUtils.prefs.getString("deliverylocation");
      PrefUtils.prefs.getString("lati");
      PrefUtils.prefs.getString("long");
      Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
        setState(() {
          addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
          if (addressitemsData.items.length <= 0) {
            _addresscheck = false;
            _isLoading = false;
          } else {
            _addresscheck = true;
            _isLoading = false;
          }
        });
      });
    });
    super.initState();
  }

  void deleteaddress(String addressid) {
    Provider.of<AddressItemsList>(context,listen: false).deleteAddress(addressid).then((_) {
      Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
        setState(() {
          addressitemsData =
              Provider.of<AddressItemsList>(context, listen: false);
          if (addressitemsData.items.length <= 0) {
            _addresscheck = false;
            _isLoading = false;
          } else {
            _addresscheck = true;
            _isLoading = false;
          }
        });
      });
    });
  }

  void setDefaultAddress(String addressid) {
    Provider.of<AddressItemsList>(context,listen: false)
        .setDefaultAddress(addressid)
        .then((_) {
      */
/*Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {*//*

      setState(() {
        addressitemsData =
            Provider.of<AddressItemsList>(context, listen: false);
        if (addressitemsData.items.length <= 0) {
          _addresscheck = false;
          _isLoading = false;
        } else {
          _addresscheck = true;
          _isLoading = false;
        }
      });
    });
  }

  Widget printAddress(BuildContext context, i, String addressid) {
    if (addressitemsData.items[i].addressdefault == '1') {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: Container(
          //height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.radio_button_checked,
                      size: 18, color: ColorCodes.mediumBlueColor)),
              Padding(padding: EdgeInsets.only(left: 10)),
              Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          S.of(context).default_address,//'Default Address:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: ColorCodes.mediumBlackWebColor,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        addressitemsData.items[i].useraddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.greyColor,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          setDefaultAddress(addressid);
          //UpdateAddress(addressid,latitude,longitude,branch);
          // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          //Navigator.of(context).pop(true);
        },
        child: Container(
          // height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.radio_button_unchecked,
                      size: 18, color: ColorCodes.mediumBlueColor)),
              Padding(padding: EdgeInsets.only(left: 10)),
              Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    children: [
                      Text(
                        addressitemsData.items[i].useraddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.greyColor,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    }
  }

  Widget _myRadioButton({int value, Function onChanged}) {
    return Radio(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
    );
  }

  _dialogforDeleteAdd(BuildContext context, String addressid) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          S.of(context).are_sure_delete,//'Are you sure you want to delete this address?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                S.of(context).no,//'NO',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(true);
                                deleteaddress(addressid);
                              },
                              child: Text(
                                S.of(context).yes,//'YES',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      )
                    ],
                  )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    return Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: Colors.white,
        body: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _isLoading ?
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  :
              _body(),
            ]
        )
    );


  }

  _body(){
    return _isWeb ? _bodyweb():
    _bodymobile();
  }
  _bodymobile(){
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !_addresscheck
                  ? Column(
                children: <Widget>[
                  Image.asset(
                    Images.noAddressImg,
                    fit: BoxFit.fill,
                    width: 200.0,
                    height: 200.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                      child: Text(
                        S.of(context).save_address_convenient,//"Save addresses to make home delivery more convenient.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        PrefUtils.prefs.setString("addressbook", "AddressbookScreen");
                        Navigator.of(context)
                            .pushReplacementNamed(AddressScreen.routeName, arguments: {
                          'addresstype': "new",
                          'addressid': "",
                          'delieveryLocation': "",
                          'latitude': "",
                          'longitude': "",
                          'branch': ""
                        });
                      },
                      child: Text(
                        S.of(context).add_address,//"Add Address",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              )
                  : Expanded(child:Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: RaisedButton(
                        onPressed: () {},
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              PrefUtils.prefs.setString(
                                  "formapscreen", "addressbook_screen");
                              Navigator.of(context)
                                  .pushNamed(MapScreen.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.gps_fixed),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  'Choose Current Location',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: ColorCodes.mediumBlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).saved_address,//'Saved Addresses',
                          style: TextStyle(
                            fontSize: 19,
                            color: ColorCodes.greyColor,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              PrefUtils.prefs.setString("addressbook", "AddressbookScreen");
                              Navigator.of(context)
                                  .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': ""
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.add,
                                  color: ColorCodes.mediumBlueColor,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  S.of(context).add_address,//"Add Address",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                      fontSize: 19.0,
                                      color: ColorCodes.mediumBlueColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Divider(),
                  //Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                  ),
                  Expanded(
                    child: new ListView.builder(
                      itemCount: addressitemsData.items.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            //padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Container(
                              //height: 50,
                              margin: EdgeInsets.only(right: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          printAddress(context, i,
                                              addressitemsData.items[i].userid),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //SizedBox(width: 20.0),
                                  //Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(left: 90),
                                  ),

                                  Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.edit, size: 20),
                                        color: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            PrefUtils.prefs.setString("addressbook",
                                                "AddressbookScreen");
                                            Navigator.of(context).pushNamed(
                                                AddressScreen.routeName,
                                                arguments: {
                                                  'addresstype': "edit",
                                                  'addressid': addressitemsData
                                                      .items[i].userid
                                                      .toString(),
                                                  'delieveryLocation': addressitemsData.items[i].useraddress,
                                                  'latitude': addressitemsData..items[i].userlat,
                                                  'longitude': addressitemsData..items[i].userlong,
                                                  'branch': "",
                                                });
                                          });
                                        },
                                      ),
                                      Container(
                                        height: 12,
                                        width: 1,
                                        child: VerticalDivider(
                                            color: Colors.black),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(Icons.delete_outline,
                                              size: 20),
                                          color: Colors.grey,
                                          onPressed: () {
                                            _dialogforDeleteAdd(
                                                context,
                                                addressitemsData
                                                    .items[i].userid);
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //Divider(color: Colors.grey,),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ]
        )
    );
  }
  _bodyweb(){
    return  Expanded(
      child: !_addresscheck?SingleChildScrollView(
          child: Column(
              children: <Widget>[
                _isLoading
                    ? Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                    height: MediaQuery.of(context).size.height*/
/**0.8*//*
,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Images.noAddressImg,
                          fit: BoxFit.fill,
                          width: 200.0,
                          height: 200.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                            child: Text(
                              S.of(context).save_address_convenient,//"Save addresses to make home delivery more convenient.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 14.0),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              PrefUtils.prefs.setString("addressbook", "AddressbookScreen");
                              Navigator.of(context)
                                  .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': ""
                              });
                            },
                            child: Text(
                              S.of(context).add_address,//"Add Address",
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                if(_isWeb) Footer(address: _address),
              ]
          )
      ) :
      SingleChildScrollView(
        child: Column(
            children:[
              _isLoading
                  ? Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  :
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {},
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  PrefUtils.prefs.setString(
                                      "formapscreen", "addressbook_screen");
                                  Navigator.of(context).pushNamed(MapScreen.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Text(
                                      'Choose Current Location',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: ColorCodes.mediumBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25.0,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).saved_address,//'Saved Addresses',
                              style: TextStyle(
                                fontSize: 19,
                                color: ColorCodes.greyColor,
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  PrefUtils.prefs.setString("addressbook", "AddressbookScreen");
                                  Navigator.of(context).pushReplacementNamed(MapAddressScreen.routeName, arguments: {
                                    'addresstype': "new",
                                    'addressid': "",
                                    'delieveryLocation': "",
                                    'latitude': "",
                                    'longitude': "",
                                    'branch': ""
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: ColorCodes.mediumBlueColor,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      S.of(context).add_address,//"Add Address",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                          fontSize: 19.0,
                                          color: ColorCodes.mediumBlueColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Divider(),
                      //Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                      ),
                      Flexible(
                        // height: MediaQuery.of(context).size.height,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: new ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: addressitemsData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  //padding: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    //height: 50,
                                    margin: EdgeInsets.only(right: 10, bottom: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 15, bottom: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                printAddress(context, i, addressitemsData.items[i].userid),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //SizedBox(width: 20.0),
                                        //Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(left: 90),
                                        ),

                                        Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(Icons.edit, size: 20),
                                              color: Colors.grey,
                                              onPressed: () {
                                                setState(() {
                                                  PrefUtils.prefs.setString("addressbook",
                                                      "AddressbookScreen");
                                                  String adress =addressitemsData.items[i].useraddress;
                                                  String userlat =addressitemsData.items[i].userlat;
                                                  String userlong =addressitemsData.items[i].userlong;
                                                  String userid =addressitemsData.items[i].userid.toString();
                                                 PrefUtils.prefs.setString("delieveryLocation", addressitemsData.items[i].useraddress.toString());
                                                 PrefUtils.prefs.setString("lati", addressitemsData.items[i].userlat.toString());
                                                 PrefUtils.prefs.setString("longi", addressitemsData.items[i].userlong.toString());
                                                  Navigator.of(context).pushNamed(
                                                      MapAddressScreen.routeName,
                                                      arguments: {
                                                        'addresstype': "edit",
                                                        'addressid': addressitemsData
                                                            .items[i].userid
                                                            .toString(),
                                                        'delieveryLocation': adress,
                                                        'latitude': userlat,
                                                        'longitude':userlong,
                                                        'branch': "",
                                                      });
                                                });
                                              },
                                            ),
                                            Container(
                                              height: 12,
                                              width: 1,
                                              child: VerticalDivider(
                                                  color: Colors.black),
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(Icons.delete_outline,
                                                    size: 20),
                                                color: Colors.grey,
                                                onPressed: () {
                                                  _dialogforDeleteAdd(
                                                      context,
                                                      addressitemsData
                                                          .items[i].userid);
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                //Divider(color: Colors.grey,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              if(_isWeb) Footer(address: _address),
            ]
        ),
      ),
    );
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: ()=>Navigator.of(context).pop()),
      title: Text(S.of(context).my_address,//'My Addresses'
      ,style: TextStyle(color: ColorCodes.menuColor),),
      titleSpacing: 0,
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
}
*/
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../constants/IConstants.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/login.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/user.dart';
import '../../models/newmodle/user.dart';
import '../../models/newmodle/user.dart';
import '../../screens/addinfo_screen.dart';
import '../../screens/profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../blocs/adress_bloc.dart';
import '../utils/prefUtils.dart';
import '../widgets/simmers/order_screen_shimmer.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/ResponsiveLayout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/addressitems.dart';
import '../screens/address_screen.dart';
import '../assets/ColorCodes.dart';
import '../screens/home_screen.dart';
import '../assets/images.dart';

enum FilterOptions {
  Edit,
  Delete,
}

class AddressbookScreen extends StatefulWidget {
  static const routeName = '/addressbook-screen';

  @override
  _AddressbookScreenState createState() => _AddressbookScreenState();
}

class _CustomRadioButton {
  bool buttonLables;
  bool buttonValues;
  bool radioButtonValue;
  bool buttonWidth;
  bool buttonList;

  _CustomRadioButton({
    this.buttonLables,
    this.buttonValues,
    this.radioButtonValue,
    this.buttonWidth,
    // this.buttonColor,
    // this.selectedColor,
    // this.buttonHeight,
    // this.horizontal,
    // this.enableShape,
    // this.elevation,
    // this.customShape,
    // this.fontSize,
    // this.lineSpace,
    // this.buttonSpace,
    // this.buttonBorderColor,
    // this.textColor,
    // this.selectedTextColor,
    // this.initialSelection,
    // this.unselectedButtonBorderColor
  });
}

class _AddressbookScreenState extends State<AddressbookScreen> {
  var addressitemsData;
  var addressdata;
  SharedPreferences prefs;
  var deliverylocation;
  bool _addresscheck = true;
  int _groupValue = 0;
  String singleAddress = '1';
  int value = 0;
  bool _isWeb = false;
  var _address = "";
  bool _isLoading = false;
  MediaQueryData queryData;
  double wid;
  double maxwid;

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
   addresscontroller.get();
    super.initState();
  }


  Widget printAddress(BuildContext context, i, String addressid) {
    debugPrint("is default...."+addressdata.billingAddress[i].isdefault.toString());
    if (addressdata.billingAddress[i].isdefault == '1') {
      debugPrint("ddjhbfvv" + addressdata.billingAddress[i].fullName.toString());
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new RichText(textAlign: TextAlign.start,
                    text: new TextSpan(

                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: ColorCodes.blackColor,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: addressdata.billingAddress[i].fullName + " " + " " + " " + " ",
                          style:new TextStyle(fontSize: 20,fontWeight: FontWeight.w800, color: ColorCodes.blackColor), ),
                        new TextSpan(text: addressdata.billingAddress[i].addressType +"\n\n",
                          style:new TextStyle(fontSize: 12, color: ColorCodes.greyColor, background: Paint()..color = ColorCodes.searchwebbackground
                            ..strokeWidth = 10
                            ..style = PaintingStyle.stroke, ), ),
                        new TextSpan(
                            text: addressdata.billingAddress[i].houseno + ", " + addressdata.billingAddress[i].area +  " " + addressdata.billingAddress[i].landmark + ", " + addressdata.billingAddress[i].city + ", " + addressdata.billingAddress[i].state +  "\n",
                            style:new TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                          // style: new TextStyle(color: ColorCodes.darkgreen),
                        ),
                        new TextSpan(
                            text: "Pin Code: " + addressdata.billingAddress[i].pincode +  "\n",
                            style:new TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                          // style: new TextStyle(color: ColorCodes.darkgreen),
                        ),
                        new TextSpan(
                            text: "Mobile: " + addressdata.billingAddress[i].mobile +  "\n",
                            style:new TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                          // style: new TextStyle(color: ColorCodes.darkgreen),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5,
              child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.radio_button_checked,
                      size: 22, color: ColorCodes.blackColor)),
            ),

          ],
        ),
      );
    }
    else {
      debugPrint("is defa...."+addressdata.billingAddress[i].fullName.toString());
      return GestureDetector(
        onTap: () async {
          //setDefaultAddress(addressid);
          AddressController addressController = AddressController();
          await addressController.setdefult(addressId: addressid,branch: PrefUtils.prefs.getString('branch'));
          //UpdateAddress(addressid,latitude,longitude,branch);
          // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        //  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          //Navigator.of(context).pop(true);
        },
        child: Container(
          // height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new RichText(
                      textAlign: TextAlign.start,
                      text: new TextSpan(

                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: ColorCodes.blackColor,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: addressdata.billingAddress[i].fullName + " " + " " + " " + " ",
                            style:new TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: ColorCodes.blackColor), ),
                          new TextSpan(text: addressdata.billingAddress[i].addressType +"\n\n",
                            style:new TextStyle(fontSize: 12, color: ColorCodes.greyColor, background: Paint()..color = ColorCodes.searchwebbackground
                              ..strokeWidth = 10
                              ..style = PaintingStyle.stroke, ), ),
                          new TextSpan(
                              text: addressdata.billingAddress[i].houseno + ", " + addressdata.billingAddress[i].area +  ", " + addressdata.billingAddress[i].landmark + " " + addressdata.billingAddress[i].city + ", " + addressdata.billingAddress[i].state +  "\n",
                              style:new TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                            // style: new TextStyle(color: ColorCodes.darkgreen),
                          ),
                          new TextSpan(
                              text: "Pin Code: " + addressdata.billingAddress[i].pincode +  "\n",
                              style:new TextStyle(fontSize: 13, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                            // style: new TextStyle(color: ColorCodes.darkgreen),
                          ),
                          new TextSpan(
                              text: "Mobile: " + addressdata.billingAddress[i].mobile +  "\n",
                              style:new TextStyle(fontSize: 14, height: 1.5, color: ColorCodes.darkGrey, fontWeight: FontWeight.normal,)
                            // style: new TextStyle(color: ColorCodes.darkgreen),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5.1,
                child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.radio_button_unchecked,
                        size: 22, color: ColorCodes.blackColor)),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _myRadioButton({int value, Function onChanged}) {
    return Radio(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
    );
  }

  _dialogforDeleteAdd(BuildContext context, String addressid) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          S.of(context).are_sure_delete,//'Are you sure you want to delete this address?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                S.of(context).no,//'NO',
                                style: TextStyle(
                                    color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                              onTap: () async{
                                Navigator.of(context).pop(true);

                                //deleteaddress(addressid);
                                AddressController addressController = AddressController();
                                await addressController.remove(addressId: addressid, apiKey: (VxState.store as GroceStore).userData.id, branch:PrefUtils.prefs.getString('branch') );
                              },
                              child: Text(
                                S.of(context).yes,//'YES',
                                style: TextStyle(
                                    color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      )
                    ],
                  )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    return Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) || !_isWeb ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.backgroundcolor,
        body: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false, false),
              _isLoading ?
              (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
              Center(
                child: OrderScreenShimmer(),
              ) :
              Center(
                child: OrderScreenShimmer(),
              )
                  :
              _body(),
            ]
        ),
      bottomNavigationBar: _bottomNavigationBar(),
    );


  }

  _dialogforSaveadd(BuildContext context) {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: 100.0,
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OrderScreenShimmer(),
                          SizedBox(width: 40.0,),
                          Text(
                            S.of(context).deleting, // 'Deleting...'
                          ),
                        ],
                      )
                  ),
                );
              }
          );
        });
  }
  _bottomNavigationBar(){
    return  Container(
      height: 53.0,
      margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).primaryColor,
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: GestureDetector(
        onTap: () {
          PrefUtils.prefs.setString("addressbook", "AddressbookScreen");
          Navigator.of(context)
              .pushReplacementNamed(AddInfo.routeName, arguments: {
            'addresstype': "new",
            'addressid': "",
            'title': "addressbook",
            'delieveryLocation': "",
            'latitude': "",
            'longitude': "",
            'branch': "",
          "prev": "",
          });
        },
        child: Center(
          child: Text(
            S.of(context).add_address,//"Add Address",
            style: TextStyle(
              //fontWeight: FontWeight.bold,
                color: ColorCodes.whiteColor,
                fontSize: 19,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
  _body(){
    return _isWeb?_bodyweb():
    _bodymobile();
  }
  _bodymobile(){
    return VxBuilder(
       mutations: {SetAddress,SetUserData},
      builder: (ctx, store,VxStatus state){
          addressdata = store.userData;
          return Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (addressdata.billingAddress.length<=0)
                      ?  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        Images.noAddressImg,
                        fit: BoxFit.fill,
                        width: 200.0,
                        height: 200.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                          child: Text(
                            S.of(context).save_address_convenient,//"Save addresses to make home delivery more convenient.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 15.0),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      /*MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            PrefUtils.prefs.setString("addressbook", "AddressbookScreen");
                            Navigator.of(context)
                                .pushReplacementNamed(AddressScreen.routeName, arguments: {
                              'addresstype': "new",
                              'addressid': "",
                              'delieveryLocation': "",
                              'latitude': "",
                              'longitude': "",
                              'branch': ""
                            });
                          },
                          child: Text(
                            S.of(context).add_address,//"Add Address",
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),*/
                    ],
                  )
                      : Expanded(
                        child:
                              ListView.builder(
                                itemCount: addressdata.billingAddress.length,/*snapshot.data.length*/
                                itemBuilder: (_, i)
                                {
                                  debugPrint("name....."+addressdata.billingAddress[i].fullName+"  "+addressdata.billingAddress[i].houseno);
                                     return Container(
                                       decoration: new BoxDecoration(
                                         boxShadow: [
                                           BoxShadow(
                                             color: ColorCodes.grey
                                                 .withOpacity(0.2),
                                             spreadRadius: 4,
                                             blurRadius: 5,
                                             offset: Offset(0, 2),
                                           )
                                         ],
                                         color: ColorCodes.whiteColor,
                                       ),
                                       width: MediaQuery.of(context)
                                           .size
                                           .width,
                                       margin: EdgeInsets.only(
                                         top: 6,
                                       ),
                                       padding: EdgeInsets.all(15),
                                       //padding: EdgeInsets.only(right: 10),
                                       child: Container(
                                         //height: 50,
                                         child: Column(
                                           mainAxisAlignment:
                                               MainAxisAlignment.start,
                                           children: [
                                             printAddress(
                                                 context,
                                                 i,
                                                 addressdata
                                                     .billingAddress[
                                                         i]
                                                     .id
                                                     .toString()),
                                             SizedBox(height: 0),
                                             Container(
                                               height: 45,
                                               decoration: BoxDecoration(
                                                 //color: ColorCodes.cyanColor,
                                                 border: Border.all(
                                                     width: 1.5,
                                                     color: ColorCodes
                                                         .lightGreyColor),
                                                 borderRadius:
                                                     BorderRadius.circular(
                                                         10),
                                               ),
                                               child: Row(
                                                 //crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Container(
                                                     width: MediaQuery.of(
                                                                 context)
                                                             .size
                                                             .width /
                                                         2.5,
                                                     child: Center(
                                                       child: FlatButton(
                                                         child: Text(
                                                           "Changes/Edit ",
                                                           //"EDIT",
                                                           style:
                                                               TextStyle(
                                                             color: ColorCodes
                                                                 .blackColor,
                                                             fontWeight:
                                                                 FontWeight
                                                                     .w700,
                                                             fontSize:
                                                                 14.0,
                                                           ),
                                                         ),
                                                         padding:
                                                             EdgeInsets
                                                                 .all(0),
                                                         //  icon: Icon(Icons.edit, size: 20),
                                                         // color: Colors.grey,
                                                         onPressed: () {
                                                           debugPrint("id addrss...."+addressdata
                                                               .billingAddress[i]
                                                               .id
                                                               .toString());
                                                           setState(() {
                                                             PrefUtils
                                                                 .prefs
                                                                 .setString(
                                                                     "addressbook",
                                                                     "AddressbookScreen");
                                                             Navigator.of(
                                                                     context)
                                                                 .pushReplacementNamed(
                                                                     AddInfo
                                                                         .routeName,
                                                                     arguments: {
                                                                   'addresstype': "edit",
                                                                   'addressid': addressdata
                                                                       .billingAddress[i]
                                                                       .id
                                                                       .toString(),
                                                                   'delieveryLocation': deliverylocation,
                                                                   'latitude': addressdata
                                                                       .billingAddress[i]
                                                                       .lattitude
                                                                       .toString(),
                                                                   //"",
                                                                   'longitude': addressdata
                                                                       .billingAddress[i]
                                                                       .logingitude
                                                                       .toString(),
                                                                   //"",
                                                                   'branch':
                                                                       "",
                                                                   'fullName': addressdata
                                                                       .billingAddress[i]
                                                                       .fullName,
                                                                   'houseno': addressdata
                                                                       .billingAddress[i]
                                                                       .houseno,
                                                                   'area': addressdata
                                                                       .billingAddress[i]
                                                                       .area,
                                                                   'landmark': addressdata
                                                                       .billingAddress[i]
                                                                       .landmark,
                                                                   'city': addressdata
                                                                       .billingAddress[i]
                                                                       .city,
                                                                   'state': addressdata
                                                                       .billingAddress[i]
                                                                       .state,
                                                                   'pincode': addressdata
                                                                       .billingAddress[i]
                                                                       .pincode,
                                                                   'mobile': addressdata
                                                                       .billingAddress[i]
                                                                       .mobile,
                                                                       'addresstag': addressdata
                                                                           .billingAddress[i]
                                                                           .type,
                                                                       "prev": "",
                                                                       'title': "addressbook",
                                                                 });
                                                           });
                                                         },
                                                       ),
                                                     ),
                                                   ),
                                                   Container(
                                                     height: 45.0,
                                                     child:
                                                         VerticalDivider(
                                                       color: ColorCodes
                                                           .lightGreyColor,
                                                       thickness: 1,
                                                     ),
                                                   ),
                                                   Container(
                                                     width: MediaQuery.of(
                                                                 context)
                                                             .size
                                                             .width /
                                                         2.4,
                                                     child: Center(
                                                       child: FlatButton(
                                                           child: Text(
                                                             S
                                                                 .of(context)
                                                                 .remove,
                                                             //"DELETE",
                                                             style:
                                                                 TextStyle(
                                                               color: ColorCodes
                                                                   .discountoff,
                                                               fontWeight:
                                                                   FontWeight
                                                                       .w700,
                                                               fontSize:
                                                                   14.0,
                                                             ),
                                                           ),
                                                           padding:
                                                               EdgeInsets
                                                                   .all(0),
                                                           /*icon: Icon(Icons.delete_outline,
                                         size: 20),*/
                                                           // color: Colors.grey,
                                                           onPressed: () {
                                                             // _dialogforSaveadd(context);
                                                             _dialogforDeleteAdd(
                                                                 context,
                                                                 addressdata
                                                                     .billingAddress[
                                                                         i]
                                                                     .id
                                                                     .toString());
                                                           }),
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     );
                                    }),
                            // }else if(snapshot.hasError){
                            //
                            //   return SizedBox.shrink();
                            // }else if(!snapshot.hasData){
                            //
                            //   return SizedBox.shrink();
                            // }
                            // return  OrderScreenShimmer();
                        //   },
                        //
                        // ),
                      ),
                ]
            )
        );
      }
    );

  }
  _bodyweb(){
    return VxBuilder(
        mutations: {SetAddress,SetUserData},
        builder: (ctx, store,VxStatus state) {
      addressdata = store.userData;
      return Expanded(
        child: !_addresscheck ? SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  _isLoading
                      ? Container(
                    height: 100,
                    child: Center(
                      child: OrderScreenShimmer(
                      ),
                    ),
                  )
                      :
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      constraints: (_isWeb &&
                          !ResponsiveLayout.isSmallScreen(context))
                          ? BoxConstraints(maxWidth: maxwid)
                          : null,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height /**0.8*/,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Images.noAddressImg,
                            fit: BoxFit.fill,
                            width: 200.0,
                            height: 200.0,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                              child: Text(
                                S
                                    .of(context)
                                    .save_address_convenient,
                                //"Save addresses to make home delivery more convenient.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            height: 20.0,
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                PrefUtils.prefs.setString(
                                    "addressbook", "AddressbookScreen");
                                Navigator.of(context)
                                    .pushReplacementNamed(
                                    AddressScreen.routeName, arguments: {
                                  'addresstype': "new",
                                  'addressid': "",
                                  'delieveryLocation': "",
                                  'latitude': "",
                                  'longitude': "",
                                  'branch': ""
                                });
                              },
                              child: Text(
                                S
                                    .of(context)
                                    .add_address, //"Add Address",
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  if(_isWeb) Footer(
                      address: PrefUtils.prefs.getString("restaurant_address")),
                ]
            )
        ) : SingleChildScrollView(
          child: Column(
              children: [
                _isLoading
                    ? Container(
                  height: 100,
                  child: Center(
                    child: OrderScreenShimmer(
                    ),
                  ),
                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: (_isWeb &&
                        !ResponsiveLayout.isSmallScreen(context))
                        ? BoxConstraints(maxWidth: maxwid)
                        : null,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        /*   Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          prefs.setString(
                              "formapscreen", "addressbook_screen");
                          Navigator.of(context).pushNamed(MapScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.gps_fixed),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                              'Choose Current Location',
                              style: TextStyle(
                                fontSize: 19,
                                color: ColorCodes.mediumBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25.0,
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S
                                    .of(context)
                                    .saved_address, //'Saved Addresses',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    PrefUtils.prefs.setString(
                                        "addressbook", "AddressbookScreen");
                                    Navigator.of(context).pushReplacementNamed(
                                        AddressScreen.routeName, arguments: {
                                      'addresstype': "new",
                                      'addressid': "",
                                      'delieveryLocation': "",
                                      'latitude': "",
                                      'longitude': "",
                                      'branch': ""
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: ColorCodes.mediumBlueColor,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        S
                                            .of(context)
                                            .add_address, //"Add Address",
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                            fontSize: 19.0,
                                            color: ColorCodes.mediumBlueColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Divider(),
                        //Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                        ),
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child: new ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: addressdata.billingAddress.length,
                            itemBuilder: (_, i) =>
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10),
                                      //padding: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        //height: 50,
                                        margin: EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,

                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 15, bottom: 10),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    printAddress(context, i,
                                                        addressdata.billingAddress[i].id.toString()),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //SizedBox(width: 20.0),
                                            //Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 90),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),


                                    Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 60,),
                                        FlatButton(
                                          child: Text(
                                            S
                                                .of(context)
                                                .edit, //"Edit",
                                            style: TextStyle(
                                                color: ColorCodes.whiteColor),
                                          ),

                                          // padding: EdgeInsets.only(left: 20),
                                          //  icon: Icon(Icons.edit, size: 20),
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          onPressed: () {
                                            setState(() {
                                              PrefUtils.prefs.setString(
                                                  "addressbook",
                                                  "AddressbookScreen");
                                              Navigator.of(context).pushReplacementNamed(
                                                  AddressScreen.routeName,
                                                  arguments: {
                                                    'addresstype': "edit",
                                                    'addressid': addressdata.billingAddress[i].id
                                                        .toString(),
                                                    'delieveryLocation': deliverylocation,
                                                    'latitude': addressdata.billingAddress[i].lattitude
                                                        .toString(),//"",
                                                    'longitude': addressdata.billingAddress[i].logingitude
                                                        .toString(),//"",
                                                    'branch': ""
                                                  });
                                            });
                                          },
                                        ),
                                        SizedBox(width: 50,),
                                        Container(
                                          height: 12,
                                          width: 1,
                                          child: VerticalDivider(
                                              color: Colors.black),
                                        ),
                                        FlatButton(
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .delete, //"Delete",
                                              style: TextStyle(
                                                  color: ColorCodes
                                                      .whiteColor),
                                            ),
                                            padding: EdgeInsets.all(0),
                                            /*icon: Icon(Icons.delete_outline,
                                  size: 20),*/
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                            onPressed: () {
                                              // _dialogforSaveadd(context);
                                              _dialogforDeleteAdd(
                                                  context,
                                                  addressdata.billingAddress[i].id.toString());
                                            }),
                                      ],
                                    ),
                                    //Divider(color: Colors.grey,),
                                  ],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                if(_isWeb) Footer(
                    address: PrefUtils.prefs.getString("restaurant_address")),
              ]
          ),
        ),
      );
    });
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back,size: 20, color: ColorCodes.menuColor),onPressed: ()=>  Navigator.of(context).popUntil(ModalRoute.withName(
          HomeScreen.routeName))),
      title: Text(S.of(context).my_address,//'My Addresses',
        style: TextStyle(color: ColorCodes.menuColor, fontWeight: FontWeight.w800),
      ),
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  )
                ],
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
}