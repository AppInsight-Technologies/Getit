import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';
import '../models/swap_product.dart';
import '../screens/notavailable_product_screen.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:location/location.dart' as loc;

import '../constants/IConstants.dart';
import '../screens/address_screen.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../providers/cartItems.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-screen';

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController _controller;
  Position position;
  Widget _child;
  double _lat, _lng;
  String _address = "",addressLine="";
  CameraPosition cameraposition;
  Timer timer;
  bool _serviceEnabled = false;
  bool _permissiongrant = false;
  bool _isinit = true;
  int count = 0;
  Box<Product> productBox;
  String currentBranch;
  String confirmSwap="";
  List<SwapProduct> listswapprod =[];
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: IConstants.googleApiKey);

  Future<void> initState()  {
    productBox = Hive.box<Product>(productBoxName);
    _child = Column(
      children: [
        _backbutton(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinKitPulse(
                color: Colors.grey,
                size: 100.0,
              ),
            ],
          ),
        ),
      ],
    );
    getCurrentLocation();
    super.initState();


    timer = Timer.periodic(
        Duration(seconds: 5),
            (Timer t) => _permissiongrant
            ? !_serviceEnabled ? getCurrentLocation() : closed()
            : "");
  }

  void closed() {
    timer?.cancel();
  }



  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _backbutton(){
    return  Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding:  EdgeInsets.only(top: 40),
        child: IconButton(
            icon: Icon(Icons.arrow_back, color:ColorCodes.blackColor),
            onPressed: () {
              /*SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home-screen', (Route<dynamic> route) => false);
              });
*/
              Navigator.of(context).pop();
              // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              return Future.value(false);
            }
        ),
      ),
    );
  }
  void getCurrentLocation() async {
    PermissionStatus permission =
    await LocationPermissions().requestPermissions();
    permission = await LocationPermissions().checkPermissionStatus();

    if (permission.toString() == "PermissionStatus.granted") {
      setState(() {
        _permissiongrant = true;

      });
      checkusergps();
    } else {
      setState(() {
        _permissiongrant = false;
      });

      // checkusergps();
      Prediction p = await PlacesAutocomplete.show(
          mode: Mode.overlay, context: context, apiKey:IConstants.googleApiKey);
      displayPrediction(p);
    }
  }

  checkusergps() async {

    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;

    });
    if (!_serviceEnabled) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        setState(() {
          count++;
        });
        if (count == 1)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(S.of(context).location_unavailable,//"Location unavailable"
                ),
                content: Text(
                  S.of(context).location_enable,//'Please enable the location from device settings.'
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(S.of(context).ok,//'Ok'
                    ),
                    onPressed: () async {
                      setState(() {
                        count = 0;
                      });
                      //await AppSettings.openLocationSettings();
                      Navigator.of(context, rootNavigator: true).pop();
                      //checkusergps();
                    },
                  ),
                ],
              );
            },
          );
      }
    } else {
      Position res = await Geolocator().getCurrentPosition();
      setState(() {
        position = res;
        _lat = position.latitude;
        _lng = position.longitude;
        cameraposition = CameraPosition(
          target: LatLng(_lat, _lng),
          zoom: 16.0,
        );
        _child = mapWidget();
      });
      await getAddress(_lat, _lng);
    }
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId(S.of(context).markerID,//"home"
          ),
          position: LatLng(_lat, _lng),
//          icon: BitmapDescriptor.,
          infoWindow:
          InfoWindow(title: S.of(context).product_delivered_here,//"Your Products will be delivered here"
          )),
    ].toSet();
  }

  List<Placemark> placemark;

  void getAddress(double latitude, double longitude) async {
    debugPrint("maplat"+latitude.toString());
    debugPrint("maplong"+longitude.toString());
    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;
    });
    if (!_serviceEnabled) {
      checkusergps();
    }
    placemark =
    await Geolocator().placemarkFromCoordinates(latitude, longitude);

    setState(() async {
      // _address=_deliverylocation;

      if (placemark[0].subLocality.toString() == "") {
        if (placemark[0].locality.toString() == "") {
          _address = "";
          addressLine="";
          _child = mapWidget();
        } else {
          // _address = placemark[0].locality.toString();
          final coordinates = new Coordinates(_lat, _lng);
          var addresses;
          addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

          var first = addresses.first;

          //print("${first.featureName} :${first.subLocality}: ${first.locality}:${first.adminArea}:${first.adminArea}:${first.postalCode}:");
          setState(() {
            // _address = (first.featureName!=null)?(first.featureName):first.locality;
            addressLine = (first.subLocality != null) ? (first.subLocality + "," +
                first.locality + "," + first.adminArea)
                : (first.locality + "," + first.adminArea);
            _address = /*(first.featureName!=null)?(first.featureName):first.featureName;*/(first.subLocality != null) ? (first.subLocality) : (first.locality);
            addressLine=first.addressLine;
            print("address...."+_address.toString());
            debugPrint("addressline"+addressLine);
          });

          _child = mapWidget();
        }
      } else {
        // _address = final coordinates = new Coordinates(_lat, _lng);
        var addresses;
        addresses = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(_lat, _lng));

        var first = addresses.first;
        // print("${first.featureName} :${first.subLocality}: ${first.locality}:${first.adminArea}:${first.postalCode}");
        setState(() {
          //  _address = (first.featureName!=null)?(first.featureName):first.locality;
          addressLine = (first.subLocality != null) ? (first.subLocality + "," +
              first.locality + "," + first.adminArea)
              : (first.locality + "," + first.adminArea);
          _address = /*(first.featureName!=null)?(first.featureName):first.featureName;*/(first.subLocality != null) ? (first.subLocality) : (first.locality);
          addressLine=first.addressLine;
          print("address...."+_address.toString());
          debugPrint("addressline"+addressLine);
        });
        _child = mapWidget();
      }
    });
  }

  Future<void> _onCameraMove(CameraPosition position) async {
    setState(() {
      _lat = position.target.latitude;
      _lng = position.target.longitude;
      _createMarker();
    });
  }

  Future<void> _onCameraIdle() async {
    await getAddress(_lat, _lng);
  }

  changelocation(Place place) async {
    Navigator.of(context).pop();

    var addresses =
    await Geocoder.local.findAddressesFromQuery(place.description);
    var first = addresses.first;

    setState(() {
      _lat = first.coordinates.latitude;
      _lng = first.coordinates.longitude;
    });
    await getAddress(first.coordinates.latitude, first.coordinates.longitude);

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        _lat = detail.result.geometry.location.lat;
        _lng = detail.result.geometry.location.lng;
        if (_controller == null) {
          _child = mapWidget();
        } else {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
            ),
          );
          _child = mapWidget();
        }
      });
      await getAddress(_lat, _lng);
    }
  }

  checkusergps1() async {
    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;
    });

    if (!_serviceEnabled) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        setState(() {
          count++;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).location_unavailable,//"Location unavailable"
              ),
              content: Text(
                S.of(context).location_enable,//'Please enable the location from device settings.'
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).ok,//'Ok'
                  ),
                  onPressed: () async {
                    setState(() {
                      count = 0;
                    });
                    //await AppSettings.openLocationSettings();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      await getAddress(_lat, _lng);

      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
        ),
      );
    }
  }

  _dialogforProcessing() {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AbsorbPointer(
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false, key: _scaffoldKey, body: _child),
    );
  }

  Widget mapWidget() {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 7,
            child:   Stack(children: <Widget>[
              GoogleMap(
                  mapType: MapType.normal,
                  // markers: _createMarker(),
                  mapToolbarEnabled: true,
                  onCameraIdle: _onCameraIdle,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  padding: (Platform.isAndroid)?EdgeInsets.only(bottom: 85, top: 110/*MediaQuery.of(context).size.height/3*/, right: 0, left: 0) : null,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_lat, _lng),
                    zoom: 16.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  }
              ),
              //This is your marker
              Container(
                padding: (Platform.isAndroid)?EdgeInsets.only(bottom: 85, top: 110/*MediaQuery.of(context).size.height/3*/, right: 0, left: 0) : null,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.location_pin,color: Colors.redAccent,size: 30,),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:  EdgeInsets.only(top: 30),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back, color:ColorCodes.blackColor),
                      onPressed: () {
                        Navigator.of(context).pop();

                      }
                  ),
                ),
              ),
            ])

        ),
        Expanded(
          flex: 3,
          child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        S.of(context).select_delivery_location,//'Select delivery location',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        S.of(context).your_location,//'YOUR LOCATION',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
//                    _settingModalBottomSheet(context);

                      Prediction p = await PlacesAutocomplete.show(
                          mode: Mode.overlay,
                          context: context,
                          apiKey: IConstants.googleApiKey);
                      displayPrediction(p);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 16.0,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          _address,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                            S.of(context).change_caps,//'CHANGE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor)),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () async {
                      _dialogforProcessing();
                      checkLocation();
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        margin: EdgeInsets.only(
                            left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border(
                              top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).confirm_location_proceed,//'Confirm location & Proceed',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ],
                        )),
                  ),
                ],
              )),
        ),
      ],
    );
  }


  Future<void> checkLocation() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'check-location';
    debugPrint("Location params......"+url.toString()+{
    // await keyword is used to wait to this operation is complete.
    "lat": _lat.toString(),
    "long": _lng.toString(),
    }.toString());
    try {
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "lat": _lat.toString(),
        "long": _lng.toString(),
      });
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseJson = json.decode(response.body);
      debugPrint("checkLocation . . . .");
      debugPrint(responseJson.toString());
      debugPrint("checkLocation........");
      debugPrint(_lat.toString());
      debugPrint(_lng.toString());
      debugPrint(responseJson.toString());
      bool _isCartCheck = false;
      if (responseJson['status'].toString() == "yes") {
        PrefUtils.prefs.setString('defaultlocation', "true");
        PrefUtils.prefs.setString("isdelivering","true");
        currentBranch = responseJson['branch'].toString();
        if(PrefUtils.prefs.getString("branch") == responseJson['branch'].toString()) {
          IConstants.deliverylocationmain.value = addressLine;
          IConstants.currentdeliverylocation.value = S.of(context).location_available;
          if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
            debugPrint("Yes..............");
            debugPrint(_address);
            final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
              'addresstype': "new",
              'addressid': "",
              'delieveryLocation': _address,
              'latitude': _lat.toString(),
              'longitude': _lng.toString(),
              'branch': responseJson['branch'].toString(),
              'houseNo' : routeArgs['houseNo'],
              'apartment' : routeArgs['apartment'],
              'street' :  routeArgs['street'],
              'landmark' : routeArgs['landmark'],
              'area' : routeArgs['area'],
              'pincode' : routeArgs['pincode'],
            });
          } else {
            PrefUtils.prefs.setString('branch', responseJson['branch'].toString());
            PrefUtils.prefs.setString('deliverylocation', addressLine);
            PrefUtils.prefs.setString("latitude", _lat.toString());
            PrefUtils.prefs.setString("longitude", _lng.toString());
            if (PrefUtils.prefs.getString("skip") == "no") {
              addprimarylocation("","");
            } else {
              Navigator.of(context).pop();
              if (PrefUtils.prefs.getString("formapscreen") == "" ||
                  PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                if (PrefUtils.prefs.containsKey("fromcart")) {
                  if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                    PrefUtils.prefs.remove("fromcart");
                    debugPrint("cart....17");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MapScreen.routeName,
                        ModalRoute.withName(CartScreen.routeName),arguments: {
                      "after_login": ""
                    });
                    debugPrint("cart....18");
                    Navigator.of(context).pushReplacementNamed(
                        CartScreen.routeName,arguments: {
                      "after_login": ""
                    }
                    );
                  } else {
                    debugPrint("location 1 . . . . .");
                    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  }
                } else {
                  debugPrint("location 2 . . . . .");
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                }
              }
            }
          }
        } else {
          if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
            debugPrint("No...........");
            debugPrint(_address);
            final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
              'addresstype': "new",
              'addressid': "",
              'delieveryLocation': _address,
              'latitude': _lat.toString(),
              'longitude': _lng.toString(),
              'branch': responseJson['branch'].toString(),
              'houseNo' : routeArgs['houseNo'],
              'apartment' : routeArgs['apartment'],
              'street' :  routeArgs['street'],
              'landmark' : routeArgs['landmark'],
              'area' : routeArgs['area'],
              'pincode' : routeArgs['pincode'],
            });
          } else {
            if (productBox.length > 0) { //Suppose cart is not empty
              debugPrint("current branch...."+currentBranch);

              /* Provider.of<SellingItemsList>(context, listen: false).fetchSwapProduct(currentBranch, val).then((value) {
                listswapprod =  value;
              });*/

              _dialogforAvailability(
                  PrefUtils.prefs.getString("branch"),
                  responseJson['branch'].toString(),
                  PrefUtils.prefs.getString("deliverylocation"),
                  PrefUtils.prefs.getString("latitude"),
                  PrefUtils.prefs.getString("longitude"));
            } else {
              PrefUtils.prefs.setString('branch', responseJson['branch'].toString());
              PrefUtils.prefs.setString('deliverylocation', addressLine);
              PrefUtils.prefs.setString("latitude", _lat.toString());
              PrefUtils.prefs.setString("longitude", _lng.toString());
              if (PrefUtils.prefs.getString("skip") == "no") {
                addprimarylocation("","");
              } else {
                Navigator.of(context).pop();
                if (PrefUtils.prefs.getString("formapscreen") == "" ||
                    PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                  if (PrefUtils.prefs.containsKey("fromcart")) {
                    if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                      PrefUtils.prefs.remove("fromcart");
                      debugPrint("cart....19");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MapScreen.routeName,
                          ModalRoute.withName(CartScreen.routeName),arguments: {
                        "after_login": ""
                      });
                      debugPrint("cart....20");
                      Navigator.of(context).pushReplacementNamed(
                          CartScreen.routeName,arguments: {
                        "after_login": ""
                      }
                      );
                    } else {
                      debugPrint("location 3 . . . . .");
                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    }
                  } else {
                    debugPrint("location 4 . . . . .");
                    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  }
                } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                  Navigator.of(context)
                      .pushReplacementNamed(
                      AddressScreen.routeName, arguments: {
                    'addresstype': "new",
                    'addressid': "",
                  });
                }
              }
            }
          }
        }
      } else {
        Navigator.of(context).pop();
        PrefUtils.prefs.setString("isdelivering","false");
        IConstants.currentdeliverylocation.value = S.of(context).not_available_location;
        showInSnackBar();
      }
    } catch (error) {
      throw error;
    }
  }

  _dialogforAvailability(String prevBranch, String currentBranch, String deliveryLocation, String latitude, String longitude) async {
    String itemCount = "";
    itemCount = "   " + productBox.length.toString() + " " + S.of(context).items;//"items"
    var similarlistData;
    var _checkitem = false;
    bool _checkMembership = false;
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    if(PrefUtils.prefs.getString("membership") == "1"){
      _checkMembership = true;
    } else {
      _checkMembership = false;
    }

    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  insetPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 85 / 100,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10.0,),
                          new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: S.of(context).Availability_Check,//"Availability Check",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),),
                                new TextSpan(text: itemCount, style: TextStyle(color: Colors.grey, fontSize: 12.0)
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(S.of(context).changing_area,//"Changing area",
                            style: TextStyle(color: Colors.red, fontSize: 12.0,),),
                          SizedBox(height: 10.0,),
                          Text(S.of(context).product_price_availability,//"Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.",
                            style: TextStyle(fontSize: 12.0),),
                          Spacer(),
                          SizedBox(height: 5.0,),
                          Divider(),
                          SizedBox(height: 5.0,),

                          Row(
                            children: <Widget>[
                              Container(
                                width: 53.0,
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(S.of(context).items,//"Items",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),),

                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 15.0,),
                                    Text(S.of(context).reason,//"Reason",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 30 / 100,
                            child: new ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productBox.length,
                                itemBuilder: (_, i)
                                {

                                  return Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          FadeInImage(
                                            image: NetworkImage(productBox.values
                                                .elementAt(i)
                                                .itemImage),
                                            placeholder: AssetImage(
                                                Images.defaultProductImg),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    productBox.values
                                                        .elementAt(i)
                                                        .itemName,
                                                    style:
                                                    TextStyle(fontSize: 12.0)),
                                                SizedBox(
                                                  height: 3.0,
                                                ),
                                                _checkMembership
                                                    ? (productBox.values
                                                    .elementAt(i)
                                                    .membershipPrice ==
                                                    '-' ||
                                                    productBox.values
                                                        .elementAt(i)
                                                        .membershipPrice ==
                                                        "0")
                                                    ? (productBox.values.elementAt(i).itemPrice <= 0 ||
                                                    productBox.values.elementAt(i).itemPrice.toString() ==
                                                        "" ||
                                                    productBox.values.elementAt(i).itemPrice ==
                                                        productBox.values
                                                            .elementAt(
                                                            i)
                                                            .varMrp)
                                                    ? Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).varMrp.toString(),
                                                    style: TextStyle(
                                                        fontSize: 12.0))
                                                    : Text(
                                                    IConstants.currencyFormat +
                                                        " " +
                                                        productBox.values
                                                            .elementAt(i)
                                                            .itemPrice
                                                            .toString(),
                                                    style: TextStyle(fontSize: 12.0))
                                                    : Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).membershipPrice, style: TextStyle(fontSize: 12.0))
                                                    : (productBox.values.elementAt(i).itemPrice <= 0 || productBox.values.elementAt(i).itemPrice.toString() == "" || productBox.values.elementAt(i).itemPrice == productBox.values.elementAt(i).varMrp)
                                                    ? Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).varMrp.toString(), style: TextStyle(fontSize: 12.0))
                                                    : Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).itemPrice.toString(), style: TextStyle(fontSize: 12.0))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                  S
                                                      .of(context)
                                                      .not_available, //"Not available",
                                                  style:
                                                  TextStyle(fontSize: 12.0))),
                                        ],
                                      ),
                                      /*  Column(
                                        children: [
                                          Items(
                                            "home_screen",
                                            snapshot.data[i].id,
                                            snapshot.data[i].title,
                                            snapshot.data[i].imageUrl,
                                            snapshot.data[i].brand,
                                            snapshot.data[i].veg_type,
                                            snapshot.data[i].type,
                                            snapshot
                                                .data[i].eligible_for_express,
                                            snapshot.data[i].delivery,
                                            snapshot.data[i].duration,
                                            snapshot.data[i].durationType,
                                            snapshot.data[i].note,
                                            snapshot.data[i].subscribe,
                                            snapshot.data[i].paymentmode,
                                            snapshot.data[i].cronTime,
                                            snapshot.data[i].name,

                                            //sellingitemData.items[i].brand,
                                          ),
                                        ],
                                      )*/
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(height: 10.0,),
                          Divider(),
                          SizedBox(height: 20.0,),
                          new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                new TextSpan(text: S.of(context).note,//'Note: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, )),
                                new TextSpan(text: S.of(context).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  if (PrefUtils.prefs.getString("formapscreen") == "" ||
                                      PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                                    if (PrefUtils.prefs.containsKey("fromcart")) {
                                      if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                                        PrefUtils.prefs.remove("fromcart");
                                        debugPrint("cart....21");
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                            MapScreen.routeName,
                                            ModalRoute.withName(CartScreen.routeName),arguments: {
                                          "after_login": ""
                                        });
                                        debugPrint("cart....22");
                                        Navigator.of(context).pushReplacementNamed(
                                            CartScreen.routeName,arguments: {
                                          "after_login": ""
                                        }
                                        );
                                      } else {
                                        debugPrint("location 5 . . . . .");
                                        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                      }
                                    } else {
                                      debugPrint("location 6 . . . . .");
                                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                    }
                                  } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                                    Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
                                      'addresstype': "new",
                                      'addressid': "",
                                    });
                                  }                               },
                                child: new Container(
                                  width: MediaQuery.of(context).size.width * 35 / 100,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: new Center(
                                    child: Text(S.of(context).map_cancel,//"CANCEL"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0,),
                              GestureDetector(
                                onTap: () async {

                                  PrefUtils.prefs.setString('branch', currentBranch);
                                  PrefUtils.prefs.setString('deliverylocation', addressLine);
                                  PrefUtils.prefs.setString("latitude", _lat.toString());
                                  PrefUtils.prefs.setString("longitude", _lng.toString());

                                  if (PrefUtils.prefs.getString("skip") == "no") {
                                    var com ="";
                                    String val = "";
                                    for(int i = 0; i < productBox.length; i++){
                                      val = val+com+productBox.values.elementAt(i).varId.toString();
                                      debugPrint("var id.. ${productBox.values.elementAt(i).varId.toString()}");
                                      com = ",";
                                    }
                                    debugPrint("val... $val");
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                                      //Hive.box<Product>(productBoxName).deleteFromDisk();
                                      Hive.box<Product>(productBoxName).clear();
                                      try {
                                        if (Platform.isIOS || Platform.isAndroid) {
                                          //Hive.openBox<Product>(productBoxName);
                                        }
                                      } catch (e) {
                                        Hive.registerAdapter(ProductAdapter());
                                        //Hive.openBox<Product>(productBoxName);
                                      }
                                      setState(() {
                                        confirmSwap = "confirmSwap";
                                        debugPrint("confirmSwap..ss"+confirmSwap);
                                      });
                                      addprimarylocation(currentBranch,val);
                                    });

                                  } else {
                                    var com ="";
                                    String val = "";
                                    for(int i = 0; i < productBox.length; i++){
                                      val = val+com+productBox.values.elementAt(i).varId.toString();
                                      debugPrint("var id.. ${productBox.values.elementAt(i).varId.toString()}");
                                      com = ",";
                                    }
                                    debugPrint("val... $val");
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                                      //Hive.box<Product>(productBoxName).deleteFromDisk();
                                      Hive.box<Product>(productBoxName).clear();
                                      try {
                                        if (Platform.isIOS || Platform.isAndroid) {
                                          //await Hive.openBox<Product>(productBoxName);

                                          debugPrint("Opening box . . . .  . . . ");
                                        }
                                      } catch (e) {
                                        //await Hive.openBox<Product>(productBoxName);
                                      }
                                      Navigator.of(context).pop();
                                      if (PrefUtils.prefs.getString("formapscreen") == "" ||
                                          PrefUtils.prefs.getString("formapscreen") == "homescreen") {
                                        if (PrefUtils.prefs.containsKey("fromcart")) {
                                          if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
                                            PrefUtils.prefs.remove("fromcart");
                                            debugPrint("cart....23");
                                            Navigator.of(context).pushNamedAndRemoveUntil(
                                                MapScreen.routeName,
                                                ModalRoute.withName(CartScreen.routeName),arguments: {
                                              "after_login": ""
                                            });
                                            debugPrint("cart....23");
                                            Navigator.of(context).pushReplacementNamed(
                                                CartScreen.routeName,arguments: {
                                              "after_login": ""
                                            }
                                            );
                                          } else {
                                            debugPrint("location 7 . . . . .");
                                            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                          }
                                        } else {
                                          debugPrint("location 8 . . . . .");
                                          // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                          Navigator.of(context)
                                              .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
                                            "currentBranch": currentBranch,
                                            "val" : val
                                          });
                                          ///hello
                                        }
                                      } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
                                        Navigator.of(context)
                                            .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                          'addresstype': "new",
                                          'addressid': "",
                                        });
                                      }
                                    });
                                  }
                                },
                                child: new Container(
                                    height: 30.0,
                                    width: MediaQuery.of(context).size.width * 35 / 100,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(color: Theme.of(context).primaryColor,)
                                    ),
                                    child: new Center(
                                      child: Text(S.of(context).confirm,//"CONFIRM",
                                        style: TextStyle(color: Colors.white),),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                        ],
                      )
                  ),
                );
              }
          );
        });
  }

  Future<void> addprimarylocation(String currentBranch, String val) async {
    debugPrint("A d d p r i m r y ....." + val);

    var url = IConstants.API_PATH + 'add-primary-location';
    debugPrint("value,,,"+{
      // await keyword is used to wait to this operation is complete.
      "id": PrefUtils.prefs.getString("apikey"),
      "latitude": _lat.toString(),
      "longitude": _lng.toString(),
      "area": _address,
      "branch": PrefUtils.prefs.getString('branch'),
    }.toString());
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs.getString("apikey"),
        "latitude": _lat.toString(),
        "longitude": _lng.toString(),
        "area": _address,
        "branch": PrefUtils.prefs.getString('branch'),
      });
      final responseJson = json.decode(response.body);
      print("response add primary..."+responseJson.toString());
      debugPrint("confirmSwap..."+ confirmSwap);
      if (responseJson["data"].toString() == "true") {
        Navigator.of(context).pop();
        if (PrefUtils.prefs.getString("formapscreen") == "" ||
            PrefUtils.prefs.getString("formapscreen") == "homescreen") {
          if (PrefUtils.prefs.containsKey("fromcart")) {
            if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs.remove("fromcart");
              debugPrint("cart....24");
              Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                  ModalRoute.withName(CartScreen.routeName),arguments: {
                    "after_login": ""
                  });
              debugPrint("cart....25");
              Navigator.of(context).pushReplacementNamed(
                  CartScreen.routeName,arguments: {
                "after_login": ""
              }
              );
            } else {
              debugPrint("location 9 . . . . .");
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            }
          } else if(confirmSwap == "confirmSwap" ){
            debugPrint("confirm swap....entered");
            Navigator.of(context)
                .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
              "currentBranch": currentBranch,
              "val": val
            });
          }else {
            debugPrint("location 10 . . . . .");
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          }
        }
        else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
          Navigator.of(context)
              .pushReplacementNamed(AddressScreen.routeName, arguments: {
            'addresstype': "new",
            'addressid': "",
          });
        }

      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  void showInSnackBar() {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(IConstants.APP_NAME +
            S.of(context).not_yet_available,//" is not yet available at you current location!!!"
        )));
  }
}




// /AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E
// /web..............................................................
//

// import 'dart:async';
// import 'dart:convert';
// // import 'FakeUi.dart' if (dart.library.html) 'RealUi.dart' as ui;
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' hide Point, Events;
// import 'dart:io' as Platform;
//
// import '../generated/l10n.dart';
// import '../screens/notavailable_product_screen.dart';
//
// import '../providers/cartItems.dart';
//
// import 'package:flutter_google_places_web/flutter_google_places_web.dart';
// import 'package:google_maps/google_maps.dart' hide Icon;
// import 'package:hive/hive.dart';
// import 'dart:ui' as ui;
// import 'package:js/js.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../data/hiveDB.dart';
// import '../main.dart';
// import '../utils/ResponsiveLayout.dart';
// import '../constants/IConstants.dart';
// import '../screens/address_screen.dart';
// import '../screens/home_screen.dart';
// import '../screens/cart_screen.dart';
// import '../utils/prefUtils.dart';
// import '../assets/images.dart';
// import '../handler/locationJs.dart';
//
// class MapScreen extends StatefulWidget {
//   static const routeName = '/map-screen';
//
//   @override
//   MapScreenState createState() => MapScreenState();
// }
//
// class MapScreenState extends State<MapScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   Box<Product> productBox;
//   Widget _child;
//   double _lat, _lng;
//   String _address = "";
//   String _fullAddress = "";
//   bool _permissiongrant = false;
//   int count = 0;
//   //int htmlId = 1;
//   bool _isWeb =false;
//   bool _isSpinkit = true;
//   //SharedPreferences prefs;
//   static String kGoogleApiKey = IConstants.googleApiKey;//"AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E";
//   MediaQueryData queryData;
//   double wid;
//   double maxwid;
//   LatLng myLatlng ;
//
//   Marker marker;
//   String confirmSwap="";
//   GMap map;
//   void initState() {
//     productBox = Hive.box<Product>(productBoxName);
//     print("init....."+PrefUtils.prefs.getString('branch'));
//     print("fcgvh..."+ PrefUtils.prefs.setInt("htmlId", PrefUtils.prefs.containsKey("htmlId") ? PrefUtils.prefs.getInt("htmlId") : 1 + 1).toString());
//     //PrefUtils.prefs.setInt("htmlId", PrefUtils.prefs.getInt("htmlId") + 1);
//     PrefUtils.prefs.setInt("htmlId", PrefUtils.prefs.containsKey("htmlId") ? PrefUtils.prefs.getInt("htmlId") : 1 + 1);
//     print("init....."+PrefUtils.prefs.getString('branch'));
//     print("init2.....");
//     try {
//       // String os = Platform.operatingSystem;
//       if (Platform.Platform.isIOS) {
//         setState(() {
//           _isWeb = false;
//         });
//       } else {
//         setState(() {
//           _isWeb = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isWeb = true;
//       });
//
//     }
//
//     Future.delayed(Duration.zero, () async {
//       //prefs  = await SharedPreferences.getInstance();
//       PrefUtils.prefs.setInt("htmlId", PrefUtils.prefs.containsKey("htmlId") ? PrefUtils.prefs.getInt("htmlId") + 1 : 1 + 1);
//          debugPrint("child...");
//       setState(() {
//         _child = SpinKitPulse(
//           color: Colors.grey,
//           size: 100.0,
//         );
//         success1(
//
//             double.parse(PrefUtils.prefs.getString("latitude")),
//             double.parse(PrefUtils.prefs.getString("longitude"))
//         );
//       });
//
//
//     });
//
//
//     getCurrentLocation();
//     super.initState();
//   }
//   success(pos) {
//     try {
//       setState(() {
//         PrefUtils.prefs.setInt("htmlId", PrefUtils.prefs.getInt("htmlId") + 1);
//        // success1(_lat, _lng);
//         success1(pos.coords.latitude, pos.coords.longitude,);
//
//       });
//
//     } catch (ex) {}
//   }
// //AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E
//   Future<void> success1(
//       double latitude,
//       double longitude,
//       ) async {
//     const _host = 'https://maps.google.com/maps/api/geocode/json';
//     String apiKey =
//         IConstants.googleApiKey+"&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";
//
//     final uri =
//     await Uri.parse('$_host?key=$apiKey&latlng=$latitude,$longitude');
//     http.Response response = await http.get(uri);
//
//
//     final responseJson = json.decode(utf8.decode(response.bodyBytes));
//
//     final resultJson = json.encode(responseJson['results']);
//     final resultJsondecode = json.decode(resultJson);
//
//     List data = []; //list for categories
//
//     resultJsondecode.asMap().forEach((index, value) =>
//         data.add(resultJsondecode[index] as Map<String, dynamic>));
//
//     final addressJson = json.encode(data[0]['address_components']);
//     final addressJsondecode = json.decode(addressJson);
//
//     List dataAddress = []; //list for categories
//
//     addressJsondecode.asMap().forEach((index, value) =>
//         dataAddress.add(addressJsondecode[index] as Map<String, dynamic>));
//     setState(() {
//       for (int i = 0; i < dataAddress.length; i++) {
//         setState(() {
//           if (i == 0) {
//             if (i == dataAddress.length - 1) {
//               _fullAddress = dataAddress[i]["long_name"];
//             } else {
//               _fullAddress = dataAddress[i]["long_name"] + ", ";
//             }
//           } else {
//             if (i == dataAddress.length - 1) {
//               _fullAddress = _fullAddress + dataAddress[i]["long_name"];
//             } else {
//               _fullAddress = _fullAddress + dataAddress[i]["long_name"] + ", ";
//             }
//           }
//
//           setState(() {
//             _address = dataAddress[dataAddress.length - 4]["long_name"];
//
//           });
//           // _addresstoLatLong(_address);
//         });
//       }
//     });
//
//
//     setState(() {
//       _permissiongrant = true;
//       _lat = latitude;
//       _lng = longitude;
//       myLatlng = new LatLng(_lat, _lng);
//       _isSpinkit = false;
//       _child = mapWidget();
//     });
//   }
//
//
//
//   void getCurrentLocation() async {
//     //getCurrentPosition(allowInterop((pos) => success(pos.coords)));
//     getCurrentPosition(allowInterop((pos) => success(pos)));
//   }
//   Future<void> _addresstoLatLong(String address) async {
//     String createdViewUpdate = "7";
//
//     const _host = 'https://maps.google.com/maps/api/geocode/json';
//     String apiKey =
//         IConstants.googleApiKey + "&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";
//
//     final uri = Uri.parse('$_host?key=$apiKey&address=$address');
//     http.Response response = await http.get(uri);
//     final responseJson = json.decode(utf8.decode(response.bodyBytes));
//
//     final resultJson = json.encode(responseJson['results']);
//     final resultJsondecode = json.decode(resultJson);
//
//     final geometryJson = json.encode(resultJsondecode[0]["geometry"]);
//     final geometryJsondecode = json.decode(geometryJson);
//
//     final locationJson = json.encode(geometryJsondecode['location']);
//     final locationJsondecode = json.decode(locationJson);
//     Navigator.pop(context);
//     setState(() {
//       setState(() {
//         print("dxfgch"+ locationJsondecode["lat"].toString());
//         _lat = locationJsondecode["lat"];
//         _lng = locationJsondecode["lng"];
//       });
//
//       setState(() {
//         // ++htmlId;
//         PrefUtils.prefs.setInt("htmlId", PrefUtils.prefs.getInt("htmlId") + 1);
//       });
//       success1(_lat, _lng);
//       // _child = mapWidget();
//       myLatlng = new LatLng(_lat, _lng);
//       final mapOptions = new MapOptions()
//         ..zoom = 18
//         ..center = new LatLng(_lat, _lng);
//
//       final elem = DivElement()
//       // ..id = htmlId as String
//         ..id = PrefUtils.prefs.getInt("htmlId") as String
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';
//
//       final map = new GMap(elem, mapOptions);
//
//       final marker = Marker(MarkerOptions()
//         ..position = myLatlng
//         ..clickable = true
//         ..draggable = true
//         ..map = map
//         ..title = S.of(context).product_delivered_here,//'Your Products will be delivered here'
//       );
//
//       marker.onDragend.listen((position) async {
//         var latttt = position.latLng.lat;
//         var longgg = position.latLng.lng;
//         success1(position.latLng.lat, position.latLng.lng);
//       });
//       //this.htmlId = createdViewUpdate as int;
//       PrefUtils.prefs.setInt("htmlId", createdViewUpdate as int);
//       setState(() {
//         _lat = MapOptions().center.lat;
//         _lng = MapOptions().center.lng;
//         // myLatlng = MapOptions().center;
//       });
//       return elem;
//     }
//     );
//   }
//
//
//   _dialogforProcessing() {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AbsorbPointer(
//               child: Container(
//                 color: Colors.transparent,
//                 height: double.infinity,
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           });
//         });
//   }
//
//   _dialogforChangeLocation() {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(3.0)),
//               child: Container(
//                 height: 250.0,
//                 width: 300.0,
//                 margin: EdgeInsets.only(
//                     left: 50.0, top: 20.0, right: 50.0, bottom: 20.0),
//                 child: GestureDetector(
//                   onTap: () async {
//                     print("OnTap............ ");
//                     print(FlutterGooglePlacesWeb.showResults);
//                     print("name....." +
//                         FlutterGooglePlacesWeb.value[
//                         'name']); // '1600 Amphitheatre Parkway, Mountain View, CA, USA'
//                     print(FlutterGooglePlacesWeb
//                         .value['streetAddress']); // '1600 Amphitheatre Parkway'
//                     print(FlutterGooglePlacesWeb.value['city']); // 'CA'
//                     print(FlutterGooglePlacesWeb.value['country']);
//                     setState(() {
//                       _fullAddress = FlutterGooglePlacesWeb.value['name'];
//                       _address = FlutterGooglePlacesWeb.value['streetAddress'];
//                     });
//                     _addresstoLatLong(FlutterGooglePlacesWeb.value['name']);
//                   },
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         flex: 9,
//                         child: Container(
//                           height: 250.0,
//                           width: 300.0,
//                           margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
//                           child: FlutterGooglePlacesWeb(
//                             apiKey: kGoogleApiKey,
//                             proxyURL: "https://groce-bay.herokuapp.com/",
//                             // apiKey: "AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E",
//                             //proxyURL: 'https://cors-anywhere.herokuapp.com/',
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 5,),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         margin: EdgeInsets.only(top: 40,),
//                         height: 30,
//                         width: 60,
//                         child: Center(child: Text(S.of(context).submit,//'SUBMIT',
//                           style: TextStyle(fontSize: 13,color: Colors.white),)),
//                       )
//                       /* Flexible(
//                         flex: 1,
//                         child: Container(
//                           margin: EdgeInsets.only(
//                             top: 58,
//                           ),
//                           child: Icon(
//                             Icons.arrow_forward,
//                             size: 20.0,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),*/
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("build........ ");
//     print(FlutterGooglePlacesWeb.showResults);
//     debugPrint("After..............");
//     debugPrint(_lat.toString());
//     debugPrint(_lng.toString());
//     queryData = MediaQuery.of(context);
//     wid= queryData.size.width;
//     maxwid=wid*0.90;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       key: _scaffoldKey,
//       bottomNavigationBar: _bottemnavigation(),
//       body:   Stack(
//
//         children: [
//
//           //Text("Testing....."),
//           _isSpinkit ?
//           SpinKitPulse(
//             color: Colors.grey,
//             size: 100.0,
//           )
//               :
//           mapWidget(),
//           //_child,
//
//           //mapWidget(),
//           Positioned(
//               top: 50,
//               right: 5,
//               child: Column(
//                 children: [
//
//                   SizedBox(
//                     height: 5,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       print("dfGVHNJKM");
//                       getCurrentLocation();
//                     },
//                     child: Container(
//                       height: 40,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         color: Theme
//                             .of(context)
//                             .primaryColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                           child: Text(
//                             S.of(context).locate_me,//'Locate me',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           )),
//                     ),
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
//
//   Widget mapWidget() {
//     print("fullAddress..............");
//     print(_lat);
//     print(_lng);
//
//     // ignore: undefined_prefixed_name
//     bool val = ui.platformViewRegistry.registerViewFactory(String.fromCharCode(PrefUtils.prefs.getInt("htmlId")), (int viewId) {
//       myLatlng = new LatLng(_lat, _lng);
//       debugPrint("myLatlng........");
//       debugPrint(myLatlng.toString());
//       final mapOptions = new MapOptions()
//         ..zoom = 18
//         ..center = myLatlng;
//
//       final elem = DivElement()
//         ..id = String.fromCharCode(PrefUtils.prefs.getInt("htmlId"))
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';
//
//       map = new GMap(elem, mapOptions);
//       map.onCenterChanged.listen((event) {
//         success1(map.center.lat, map.center.lng);
//         setState(() {
//           myLatlng = map.center;
//         });
//         marker = Marker(MarkerOptions()
//           ..position = myLatlng
//           ..clickable = true
//           ..draggable = true
//           ..map = map
//           ..visible = false
//           ..title = S.of(context).product_delivered_here,//'Your Products will be delivered here'
//         );
//         marker.onDragend.listen((position) async {
//           var latttt = position.latLng.lat;
//           var longgg = position.latLng.lng;
//           print("check..........." +
//               latttt.toString() +
//               "     " +
//               longgg.toString());
//           success1(position.latLng.lat, position.latLng.lng);
//         });
//
//         debugPrint("mycenter latLang event : "+map.center.toString());
//       });
//       debugPrint("my Element : "+elem.toString());
//
//
//       return elem;
//     });
//
//     debugPrint("val..................... " + val.toString());
//
//     return Column(
//       children: <Widget>[
//         Container(
//           // flex: 7,
//           child: Expanded(
//             child: Stack(children: <Widget>[
//               HtmlElementView(
//                 viewType: String.fromCharCode(PrefUtils.prefs.getInt("htmlId")),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Icon(Icons.location_pin,color: Colors.redAccent,size: 30,),
//               ),
//             ]
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> checkLocation() async {
//     // imp feature in adding async is the it automatically wrap into Future.
//     var url = IConstants.API_PATH + 'check-location';
//     try {
//       final response = await http.post(url, body: {
//         // await keyword is used to wait to this operation is complete.
//         "lat": _lat.toString(),
//         "long": _lng.toString(),
//       });
//
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       final responseJson = json.decode(response.body);
//       debugPrint("checkLocation........");
//       debugPrint(_lat.toString());
//       debugPrint(_lng.toString());
//       debugPrint(responseJson.toString());
//       bool _isCartCheck = false;
//       if (responseJson['status'].toString() == "yes") {
//         if(PrefUtils.prefs.getString("branch") == responseJson['branch'].toString()) {
//           if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
//             debugPrint("Yes..............");
//             debugPrint(_address);
//             final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//             Navigator.of(context).pop();
//             Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
//               'addresstype': "new",
//               'addressid': "",
//               'delieveryLocation': _address,
//               'latitude': _lat.toString(),
//               'longitude': _lng.toString(),
//               'branch': responseJson['branch'].toString(),
//               'houseNo' : routeArgs['houseNo'],
//               'apartment' : routeArgs['apartment'],
//               'street' :  routeArgs['street'],
//               'landmark' : routeArgs['landmark'],
//               'area' : routeArgs['area'],
//               'pincode' : routeArgs['pincode'],
//             });
//           } else {
//             PrefUtils.prefs.setString('branch', responseJson['branch'].toString());
//             PrefUtils.prefs.setString('deliverylocation', _address);
//             PrefUtils.prefs.setString("latitude", _lat.toString());
//             PrefUtils.prefs.setString("longitude", _lng.toString());
//             if (PrefUtils.prefs.getString("skip") == "no") {
//               print("1....2....");
//               addprimarylocation("","");
//             } else {
//               Navigator.of(context).pop();
//               if (PrefUtils.prefs.getString("formapscreen") == "" ||
//                   PrefUtils.prefs.getString("formapscreen") == "homescreen") {
//                 if (PrefUtils.prefs.containsKey("fromcart")) {
//                   if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
//                     PrefUtils.prefs.remove("fromcart");
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                         MapScreen.routeName,
//                         ModalRoute.withName(CartScreen.routeName));
//
//                     Navigator.of(context).pushReplacementNamed(
//                       CartScreen.routeName,
//                     );
//                   } else {
//                     Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                   }
//                 } else {
//                   Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                 }
//               }
//             }
//           }
//         } else {
//           if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
//             debugPrint("No...........");
//             debugPrint(_address);
//             final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//             Navigator.of(context).pop();
//             Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
//               'addresstype': "new",
//               'addressid': "",
//               'delieveryLocation': _address,
//               'latitude': _lat.toString(),
//               'longitude': _lng.toString(),
//               'branch': responseJson['branch'].toString(),
//               'houseNo' : routeArgs['houseNo'],
//               'apartment' : routeArgs['apartment'],
//               'street' :  routeArgs['street'],
//               'landmark' : routeArgs['landmark'],
//               'area' : routeArgs['area'],
//               'pincode' : routeArgs['pincode'],
//             });
//           } else {
//             if (productBox.length > 0) { //Suppose cart is not empty
//               _dialogforAvailability(
//                   PrefUtils.prefs.getString("branch"),
//                   responseJson['branch'].toString(),
//                   PrefUtils.prefs.getString("deliverylocation"),
//                   PrefUtils.prefs.getString("latitude"),
//                   PrefUtils.prefs.getString("longitude"));
//             } else {
//               PrefUtils.prefs.setString('branch', responseJson['branch'].toString());
//               PrefUtils.prefs.setString('deliverylocation', _address);
//               PrefUtils.prefs.setString("latitude", _lat.toString());
//               PrefUtils.prefs.setString("longitude", _lng.toString());
//               if (PrefUtils.prefs.getString("skip") == "no") {
//
//                 final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//                 String val = "";
//                 val = routeArgs['valnext'];
//                 print("val 10 3..."+val);
//                 print("3....4....");
//                 addprimarylocation(responseJson['branch'].toString(),val);
//               } else {
//                 Navigator.of(context).pop();
//                 if (PrefUtils.prefs.getString("formapscreen") == "" ||
//                     PrefUtils.prefs.getString("formapscreen") == "homescreen") {
//                   if (PrefUtils.prefs.containsKey("fromcart")) {
//                     if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
//                       PrefUtils.prefs.remove("fromcart");
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           MapScreen.routeName,
//                           ModalRoute.withName(CartScreen.routeName));
//
//                       Navigator.of(context).pushReplacementNamed(
//                         CartScreen.routeName,
//                       );
//                     } else {
//                       Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                     }
//                   } else {
//                     Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                   }
//                 } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
//                   Navigator.of(context)
//                       .pushReplacementNamed(
//                       AddressScreen.routeName, arguments: {
//                     'addresstype': "new",
//                     'addressid': "",
//                   });
//                 }
//               }
//             }
//           }
//         }
//       } else {
//         Navigator.of(context).pop();
//         showInSnackBar();
//       }
//     } catch (error) {
//       throw error;
//     }
//   }
//
//   _dialogforAvailability(String prevBranch, String currentBranch, String deliveryLocation, String latitude, String longitude) async {
//     String itemCount = "";
//     itemCount = "   " + productBox.length.toString() + " " + S.of(context).items;//"items";
//     bool _checkMembership = false;
//     //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if(PrefUtils.prefs.getString("membership") == "1"){
//       _checkMembership = true;
//     } else {
//       _checkMembership = false;
//     }
//
//     return showDialog(context: context,
//         builder: (context) {
//           return StatefulBuilder(
//               builder: (context, setState) {
//                 return Dialog(
//                   insetPadding: EdgeInsets.only(left: 20.0, right: 20.0),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0)
//                   ),
//                   child: Container(
//                       height: MediaQuery.of(context).size.height * 85 / 100,
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.only(left: 10.0, right: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           SizedBox(height: 10.0,),
//                           new RichText(
//                             text: new TextSpan(
//                               // Note: Styles for TextSpans must be explicitly defined.
//                               // Child text spans will inherit styles from parent
//                               style: new TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(text: S.of(context).Availability_Check,//"Availability Check",
//                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),),
//                                 new TextSpan(text: itemCount, style: TextStyle(color: Colors.grey, fontSize: 12.0)
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10.0,),
//                           Text(S.of(context).changing_area,//"Changing area",
//                             style: TextStyle(color: Colors.red, fontSize: 12.0,),),
//                           SizedBox(height: 10.0,),
//                           Text(S.of(context).product_price_availability,//"Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.",
//                             style: TextStyle(fontSize: 12.0),),
//                           Spacer(),
//                           SizedBox(height: 5.0,),
//                           Divider(),
//                           SizedBox(height: 5.0,),
//
//                           Row(
//                             children: <Widget>[
//                               Container(
//                                 width: 53.0,
//                               ),
//                               Expanded(
//                                 flex: 4,
//                                 child: Text(S.of(context).items,//"Items",
//                                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),),
//
//                               Expanded(
//                                 flex: 4,
//                                 child: Row(
//                                   children: <Widget>[
//                                     SizedBox(width: 15.0,),
//                                     Text(S.of(context).reason,//"Reason",
//                                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5.0,),
//                           Divider(),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 30 / 100,
//                             child: new ListView.builder(
//                               //physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: productBox.length,
//                                 itemBuilder: (_, i) => Row(
//                                   children: <Widget>[
//                                     FadeInImage(
//                                       image: NetworkImage(productBox.values.elementAt(i).itemImage),
//                                       placeholder: AssetImage(Images.defaultProductImg),
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     SizedBox(
//                                       width: 3.0,
//                                     ),
//                                     Expanded(
//                                       flex: 4,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(productBox.values.elementAt(i).itemName, style: TextStyle(fontSize: 12.0)),
//                                           SizedBox(height: 3.0,),
//                                           _checkMembership ?
//                                           (productBox.values.elementAt(i).membershipPrice == '-' || productBox.values.elementAt(i).membershipPrice == "0")
//                                               ?
//                                           (productBox.values.elementAt(i).itemPrice <= 0 ||
//                                               productBox.values.elementAt(i).itemPrice.toString() == "" ||
//                                               productBox.values.elementAt(i).itemPrice == productBox.values.elementAt(i).varMrp)
//                                               ?
//                                           Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).varMrp.toString(), style: TextStyle(fontSize: 12.0))
//                                               :
//                                           Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).itemPrice.toString(), style: TextStyle(fontSize: 12.0))
//                                               :
//                                           Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).membershipPrice, style: TextStyle(fontSize: 12.0))
//                                               :
//
//                                           (productBox.values.elementAt(i).itemPrice <= 0 ||
//                                               productBox.values.elementAt(i).itemPrice.toString() == "" ||
//                                               productBox.values.elementAt(i).itemPrice == productBox.values.elementAt(i).varMrp)
//                                               ?
//                                           Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).varMrp.toString(), style: TextStyle(fontSize: 12.0))
//                                               :
//                                           Text(IConstants.currencyFormat + " " + productBox.values.elementAt(i).itemPrice.toString(), style: TextStyle(fontSize: 12.0))
//                                         ],
//                                       ),
//                                     ),
//
//                                     Expanded(
//                                         flex: 4,
//                                         child: Text(S.of(context).not_available,//"Not available",
//                                             style: TextStyle(fontSize: 12.0))),
//                                   ],
//                                 )
//                             ),
//                           ),
//                           SizedBox(height: 10.0,),
//                           Divider(),
//                           SizedBox(height: 20.0,),
//                           new RichText(
//                             text: new TextSpan(
//                               // Note: Styles for TextSpans must be explicitly defined.
//                               // Child text spans will inherit styles from parent
//                               style: new TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                               children: <TextSpan>[
//                                 new TextSpan(text: S.of(context).note,//'Note: ',
//                                     style: TextStyle(fontWeight: FontWeight.bold, )),
//                                 new TextSpan(text: S.of(context).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20.0,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).pop();
//                                   if (PrefUtils.prefs.getString("formapscreen") == "" ||
//                                       PrefUtils.prefs.getString("formapscreen") == "homescreen") {
//                                     if (PrefUtils.prefs.containsKey("fromcart")) {
//                                       if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
//                                         PrefUtils.prefs.remove("fromcart");
//                                         Navigator.of(context).pushNamedAndRemoveUntil(
//                                             MapScreen.routeName,
//                                             ModalRoute.withName(CartScreen.routeName));
//
//                                         Navigator.of(context).pushReplacementNamed(
//                                           CartScreen.routeName,
//                                         );
//                                       } else {
//                                         Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                       }
//                                     } else {
//                                       Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                     }
//                                   } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
//                                     Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
//                                       'addresstype': "new",
//                                       'addressid': "",
//                                     });
//                                   }                               },
//                                 child: new Container(
//                                   width: MediaQuery.of(context).size.width * 35 / 100,
//                                   height: 30.0,
//                                   decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey)
//                                   ),
//                                   child: new Center(
//                                     child: Text(S.of(context).map_cancel,//"CANCEL"
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 20.0,),
//                               GestureDetector(
//                                 onTap: () async {
//
//                                   PrefUtils.prefs.setString('branch', currentBranch);
//                                   PrefUtils.prefs.setString('deliverylocation', _address);
//                                   PrefUtils.prefs.setString("latitude", _lat.toString());
//                                   PrefUtils.prefs.setString("longitude", _lng.toString());
//                                   if (PrefUtils.prefs.getString("skip") == "no") {
//                                     //Hive.box<Product>(productBoxName).deleteFromDisk();
//
//                                     var com ="";
//                                     String val = "";
//                                     for(int i = 0; i < productBox.length; i++){
//                                       val = val+com+productBox.values.elementAt(i).varId.toString();
//                                       debugPrint("var id.. ${productBox.values.elementAt(i).varId.toString()}");
//                                       com = ",";
//                                     }
//                                     debugPrint("val... $val");
//                                     Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
//                                       Hive.box<Product>(productBoxName).clear();
//                                       setState(() {
//                                         confirmSwap = "confirmSwap";
//                                         debugPrint("confirmSwap..ss"+confirmSwap);
//                                       });
//                                       addprimarylocation(currentBranch,val);
//                                     });
//                                   } else {
//                                     var com ="";
//                                     String val = "";
//                                     for(int i = 0; i < productBox.length; i++){
//                                       val = val+com+productBox.values.elementAt(i).varId.toString();
//                                       debugPrint("var id.. ${productBox.values.elementAt(i).varId.toString()}");
//                                       com = ",";
//                                     }
//                                     debugPrint("val... $val");
//                                     Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
//                                       //Hive.box<Product>(productBoxName).deleteFromDisk();
//                                       Hive.box<Product>(productBoxName).clear();
//                                       Navigator.of(context).pop();
//                                       if (PrefUtils.prefs.getString("formapscreen") == "" ||
//                                           PrefUtils.prefs.getString("formapscreen") == "homescreen") {
//                                         debugPrint("location 10 . 10. . . .");
//                                         if (PrefUtils.prefs.containsKey("fromcart")) {
//                                           debugPrint("location 10 . 2. . . .");
//                                           if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
//                                             debugPrint("location 10 . 4. . . .");
//                                             PrefUtils.prefs.remove("fromcart");
//                                             Navigator.of(context).pushNamedAndRemoveUntil(
//                                                 MapScreen.routeName,
//                                                 ModalRoute.withName(CartScreen.routeName));
//
//                                             Navigator.of(context).pushReplacementNamed(
//                                               CartScreen.routeName,
//                                             );
//                                           } else {
//                                             debugPrint("location 10 . 5. . . .");
//                                             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                           }
//                                         } else {
//                                           debugPrint("location 10 . 6. . . .");
//                                           Navigator.of(context)
//                                               .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
//                                             "currentBranch": currentBranch,
//                                             "val" : val
//                                           });
//                                           // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                         }
//                                       } else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
//                                         Navigator.of(context)
//                                             .pushReplacementNamed(AddressScreen.routeName, arguments: {
//                                           'addresstype': "new",
//                                           'addressid': "",
//                                         });
//                                       }
//                                     });
//                                   }
//                                 },
//                                 child: new Container(
//                                     height: 30.0,
//                                     width: MediaQuery.of(context).size.width * 35 / 100,
//                                     decoration: BoxDecoration(
//                                         color: Theme.of(context).primaryColor,
//                                         border: Border.all(color: Theme.of(context).primaryColor,)
//                                     ),
//                                     child: new Center(
//                                       child: Text(S.of(context).confirm,//"CONFIRM",
//                                         style: TextStyle(color: Colors.white),),
//                                     )),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 20.0,),
//                         ],
//                       )
//                   ),
//                 );
//               }
//           );
//         });
//   }
//   Future<void> addprimarylocation(String currentBranch, String val) async {
//     debugPrint("A d d p r i m r y ....." + val);
//     // String moveNext = "";
//     // String valnext ;
//     // final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//     // debugPrint("sdf..."+routeArgs['moveNext'].toString());
//     // /*if(routeArgs['moveNext'] == null || routeArgs['moveNext'] == ""){
//     //   moveNext = "";
//     //   valnext = "";
//     // }else{
//     //   moveNext = routeArgs['moveNext'] ;
//     //   valnext = routeArgs['valnext'];
//     // }*/
//
//     var url = IConstants.API_PATH + 'add-primary-location';
//     try {
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//       final response = await http.post(url, body: {
//         // await keyword is used to wait to this operation is complete.
//         "id": PrefUtils.prefs.getString("userID"),
//         "latitude": _lat.toString(),
//         "longitude": _lng.toString(),
//         "area": _address,
//         "branch": PrefUtils.prefs.getString('branch'),
//       });
//       final responseJson = json.decode(response.body);
//       print("response add primary..."+responseJson.toString());
//       debugPrint("confirmSwap..."+ confirmSwap);
//       if (responseJson["data"].toString() == "true") {
//         Navigator.of(context).pop();
//         if (PrefUtils.prefs.getString("formapscreen") == "" ||
//             PrefUtils.prefs.getString("formapscreen") == "homescreen") {
//           if (PrefUtils.prefs.containsKey("fromcart")) {
//             debugPrint("location 11 . . . . .");
//             if (PrefUtils.prefs.getString("fromcart") == "cart_screen") {
//               debugPrint("location 12 . . . . .");
//               PrefUtils.prefs.remove("fromcart");
//               Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
//                   ModalRoute.withName(CartScreen.routeName));
//               Navigator.of(context).pushReplacementNamed(
//                 CartScreen.routeName,
//               );
//             } else {
//               debugPrint("location 9 . . . . .");
//               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//             }
//           } else if(confirmSwap == "confirmSwap" ){
//             debugPrint("location 13 . . . . .");
//             debugPrint("confirm swap....entered");
//             Navigator.of(context)
//                 .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
//               "currentBranch": currentBranch,
//               "val": val
//             });
//           }/*else if(moveNext == "confirmSwap" && PrefUtils.prefs.getString("formapscreen") == "homescreen"){
//             Navigator.of(context)
//                 .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
//               "currentBranch": currentBranch,
//               "val": valnext
//             });
//          }*/
//           else {
//             debugPrint("location 10 . 1. . . .");
//             print("currentBranch and val...."+ currentBranch +" "+val);
//             if( val == ""){
//               Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//             }else {
//
//               Navigator.of(context)
//                   .pushReplacementNamed(
//                   NotavailabilityProduct.routeName, arguments: {
//                 "currentBranch": currentBranch,
//                 "val": val
//               });
//             }
//           }
//         }
//         else if (PrefUtils.prefs.getString("formapscreen") == "addressscreen") {
//           Navigator.of(context)
//               .pushReplacementNamed(AddressScreen.routeName, arguments: {
//             'addresstype': "new",
//             'addressid': "",
//           });
//         }
//
//       }
//     } catch (error) {
//       Navigator.of(context).pop();
//       throw error;
//     }
//   }
//
//
//   void showInSnackBar() {
//     _scaffoldKey.currentState.showSnackBar(new SnackBar(
//         content: new Text(IConstants.APP_NAME +
//             S.of(context).not_yet_available,//" is not yet available at you current location!!!"
//         )));
//   }
//
//   _bottemnavigation() {
//     return Container(
//       // flex: 3,
//         constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
//         height: MediaQuery.of(context).size.height * 0.30,
//         //child: Container(
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 10.0,
//                 ),
//                 Text(
//                   S.of(context).select_delivery_location,//'Select delivery location',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//               ],
//             ),
//             Divider(),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 10.0,
//                 ),
//                 Text(
//                   S.of(context).your_location,//'YOUR LOCATION',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey, fontSize: 10.0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 3.0,
//             ),
//             GestureDetector(
//               onTap: () {
//                 _dialogforChangeLocation();
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Flexible(
//                     child: Row(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                         Icon(
//                           Icons.location_on,
//                           size: 20.0,
//                           color: Colors.green,
//                         ),
//                         SizedBox(
//                           width: 3.0,
//                         ),
//                         Flexible(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 _address,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 _fullAddress,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontSize: 14.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   //Spacer(),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Text(S.of(context).change_caps,//'CHANGE',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Theme.of(context).primaryColor)),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             GestureDetector(
//               onTap: () async {
//                 _dialogforProcessing();
//                 checkLocation();
//               },
//               child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 50.0,
//                   margin: EdgeInsets.only(
//                       left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).accentColor,
//                       borderRadius: BorderRadius.circular(3.0),
//                       border: Border(
//                         top: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         bottom: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         left: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         right: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                       )),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         S.of(context).confirm_location_proceed,//'Confirm location & Proceed',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: 18.0),
//                       ),
//                     ],
//                   )),
//             ),
//           ],
//         )
//       //  ),
//     );
//   }
// }


