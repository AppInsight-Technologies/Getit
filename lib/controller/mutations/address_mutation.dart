import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/IConstants.dart';
import '../../generated/l10n.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/address.dart';
import '../../repository/address_repo.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:location/location.dart' as loc;

class AddressController{
  AddressRepo _addressRepo = AddressRepo();
  get() async {
    SetAddress(await _addressRepo.getAddress());
  }
  add(Address body,sucsess)async{
    Map<String, String> bodymap ={
      "apiKey":body.customer.toString(),
      "addressType":body.addressType,
      "fullName":body.fullName,
      "address":"fjnvjg",
      "latitude":body.lattitude,
      "longitude":body.logingitude,
      "branch":PrefUtils.prefs.getString("branch"),
      "default":"1",
      "pincode":body.pincode,
      "area":body.area,
      "houseno":body.houseno,
      "street": "",
      "landmark":body.landmark,
      "state":body.state,
      "city":body.city,
      "apartment":body.apartment,
      "mobile":body.mobile,
      "mobileno": "",
      "type": body.addressType,
      "apartment": "",
    };
    //
    // bodymap.addAll({
    //   "latitude":body.lattitude,
    //   "longitude":body.logingitude,
    //   'apiKey': "1",
    //   'branch':PrefUtils.prefs.getString("branch")
    // });
    print("bodyaddadress: "+bodymap.toString());
    _addressRepo.addupdateAddress(bodymap).then((value) {
      print('enter...');
      SetAddress(value);
      sucsess(true);
      // return Future.value(true);
    }).onError((error, stackTrace) {
      sucsess(false);
    });
  }
  update(Address body ,sucsess) async{
    _addressRepo.addupdateAddress({
      'apiKey': body.customer,
      'addressType': body.addressType,
      'fullName': body.fullName,
      'address': body.address,
      'longitude': body.logingitude,
      'latitude': body.lattitude,
      'branch': PrefUtils.prefs.getString("branch"),
      'addressId': body.id.toString()??"",
      "area":body.area,
      "houseno":body.houseno,
      "street":body.street,
      "landmark":body.landmark,
      "state":body.state,
      "city":body.city,
      "apartment":body.apartment,
      "mobile":body.mobile,
      "mobileno":body.mobileno,
      "type":body.type,
      "pincode":body.pincode,
    }).then((value){
      print('enter1...');
      SetAddress(value);
      sucsess(true);
    }).onError((error, stackTrace) {
      sucsess(false);
    });
  }
  remove({String addressId,String apiKey,String branch}) async{
    SetAddress(await _addressRepo.removeAddress({
      'addressId': addressId,
      'apiKey': apiKey,
      'branch': branch
    }));
  }
  setdefult({addressId,branch})async{
    debugPrint("id..."+addressId.toString()+"  "+branch.toString());
    List<Address> list = await _addressRepo.setDefultAddress(addressId:addressId ,branch:branch ).then((value) {
      print("list........"+value.toString());
      SetAddress(value);
    });

  }
 _fetchPrimerylocation(Function(CurrentLocation) value)async {
    List<gc.Address> _addresses;
    Position _position = await _fetchPrimary();
    print("latlong:${_position.latitude},${_position.longitude}");
   // final  placemark =  await Geolocator().placemarkFromCoordinates(_position.latitude, _position.longitude);
   //
   // if(/*placemark[0].subLocality.toString() == ""||*/placemark[0].locality.toString() == ""){
   //   value(await _addressRepo.getcurentlocation(_position.latitude, _position.longitude));
   //   // return _addressRepo.getcurentlocation(_position.latitude, _position.longitude);
   // } else{
   //   _addresses = await gc.Geocoder.local.findAddressesFromCoordinates(new gc.Coordinates(_position.latitude,  _position.longitude));
   //   var first = _addresses.first;
   //   print("${first.featureName} : ${first.addressLine}");
   //   // PrefUtils.prefs.setString("deliverylocation",first.addressLine);
   //   value(await _addressRepo.getcurentlocation(_position.latitude, _position.longitude,first.addressLine,first.featureName));
   // }
  }
  Future<Position>  _fetchPrimary()async{
    loc.Location location = new loc.Location();
    if (! await location.serviceEnabled()) {
      if(Vx.isAndroid)
      location.requestService();
     return _fetchPrimary();
    }else{
      return await Geolocator().getCurrentPosition();
    }
  }
}
final addresscontroller = AddressController();
class SetAddress extends VxMutation<GroceStore>{
  List<Address> address;
  SetAddress(this.address);
  @override
  perform() {
    // TODO: implement perform
    store.userData.billingAddress = address;
  }

}


class PrimeryLocation{
  AddressRepo _addressRepo = AddressRepo();
  fetchPrimarylocation() async{
    if(!PrefUtils.prefs.containsKey("deliverylocation")){
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      if (statuses[Permission.location].isGranted) {
        print("Primary location is Granted");

        addresscontroller._fetchPrimerylocation((location) {
          PrefUtils.prefs.setString("isdelivering", "${location.status}");
          print("satus: ${location.status} ${location.area}");
          if (location.status) {
            /// Location Status True: User Current Location is In Delivery Range
            /// And We Can Make Delivery To His Current Location
            ///
            print("delivery duration Current Location");
            SetPrimeryLocation(location);
          } else {
            // if (!PrefUtils.prefs.containsKey("deliverylocation")) {
              ///if ther is no deliverylocation key in SharedPreference than user is opening an app for the first time
              /// and will let User know that we are not delivering to Current location
              ///
              print("delevery location not not Exist");
              // IConstants.currentdeliverylocation.value =
              //     S.current.not_available_location;
              // IConstants.deliverylocationmain.value = location.area;
              // PrefUtils.prefs.setString("deliverylocation", location.address);
              // PrefUtils.prefs.setString("deliverylocation",
              //     PrefUtils.prefs.getString("restaurant_location"));
              // PrefUtils.prefs.setString(
              //     "latitude", PrefUtils.prefs.getString("restaurant_lat"));
              // PrefUtils.prefs.setString(
              //     "longitude", PrefUtils.prefs.getString("restaurant_long"));
              // PrefUtils.prefs.setString("isdelivering","false");
              // PrefUtils.prefs.setString("nopermission","yes");
              SetPrimeryLocation(CurrentLocation(location.latlng,
                  location.address, location.area, false, location.branch));
            // } else {
            //   ///if User Alredy Set his location Than App Wil Use his Already Set Location
            //   /// And Wont Change Anything.
            //   ///
            //   print("delevery location alredy Exist");
            //   IConstants.currentdeliverylocation.value =
            //       S.current.location_available;
            //   IConstants.deliverylocationmain.value =
            //       PrefUtils.prefs.getString("deliverylocation");
            //   IConstants.currentdeliverylocation.notifyListeners();
            //   IConstants.currentdeliverylocation.notifyListeners();
            // }
          }
        });
      } else {
        print("Primary location is Denied");
        SetPrimeryLocation(CurrentLocation(
            LatLng(double.parse(PrefUtils.prefs.getString("restaurant_lat")),
                double.parse(PrefUtils.prefs.getString("restaurant_long"))),
            PrefUtils.prefs.getString("restaurant_location"),
            PrefUtils.prefs.getString("restaurant_location"),
            true,
            PrefUtils.prefs.getString("branch")));
      }
    }/*else{
      SetPrimeryLocation(CurrentLocation(
          LatLng(double.parse(PrefUtils.prefs.getString("restaurant_lat")),
              double.parse(PrefUtils.prefs.getString("restaurant_long"))),
          PrefUtils.prefs.getString("restaurant_location"),
          PrefUtils.prefs.getString("restaurant_location"),
          true,
          PrefUtils.prefs.getString("branch")));
    }*/
  }
 Future<bool> setDeleveryLocation(LatLng latLng)async {
   CurrentLocation resp;
   final  placemark =  await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);

   if(/*placemark[0].subLocality.toString() == ""||*/placemark[0].locality.toString() == ""){
     resp = (await _addressRepo.getcurentlocation(latLng.latitude, latLng.longitude));
     // return _addressRepo.getcurentlocation(_position.latitude, _position.longitude);
   } else{
    final _addresses = await gc.Geocoder.local.findAddressesFromCoordinates(new gc.Coordinates(latLng.latitude,  latLng.longitude));
     var first = _addresses.first;
     print("ssssss,,,,,,,${first.featureName} : ${first.addressLine}");

     // PrefUtils.prefs.setString("deliverylocation",first.addressLine);
     resp = (await _addressRepo.getcurentlocation(latLng.latitude, latLng.longitude,/*first.addressLine*/(first.subLocality != null) ? (first.subLocality + "," +
         first.locality /*+ "," + first.adminArea*/)
         : (first.locality /*+ "," + first.adminArea*/),first.featureName));
   }
    // final  resp = await _addressRepo.getcurentlocation(latLng.latitude, latLng.longitude);
    if(resp.status) {
      print("resparea:${resp.area}");
      PrefUtils.prefs.setString("deliverylocation",resp.area);
      IConstants.currentdeliverylocation.value = S.current.location_available;
      IConstants.deliverylocationmain.value = PrefUtils.prefs.getString("deliverylocation");
      SetPrimeryLocation(resp);
      return Future.value(true);
    }
    else
      return Future.value(false);
  }
}
class SetPrimeryLocation  extends VxMutation<GroceStore>{
  CurrentLocation location;
  AddressRepo _addressRepo = AddressRepo();
  SetPrimeryLocation(this.location);
  @override
  perform() async{
    // TODO: implement perform
    _addressRepo.addPrimeryLocation(LatLng(location.latlng.latitude, location.latlng.longitude),location.address).then((value) {
     if(value) {
       print("delevery exist: ${ location.status}");
        store.userData.longitude = location.latlng.longitude.toString();
        store.userData.latitude = location.latlng.latitude.toString();
        store.userData.area = location.address;
        store.userData.branch =location.status? location.branch:PrefUtils.prefs.getString("branch");
        store.userData.delevrystatus = location.status;
       PrefUtils.prefs.setString("branch",  store.userData.branch);
       PrefUtils.prefs.setString("latitude", location.latlng.latitude.toString());
       PrefUtils.prefs.setString("longitude", location.latlng.longitude.toString());
       PrefUtils.prefs.setString("deliverylocation", location.area.toString());
       IConstants.deliverylocationmain.value = location.address;
       IConstants.currentdeliverylocation.value = location.status?S.current.location_available:S.current.not_available_location;
       IConstants.deliverylocationmain.value = location.address;
       IConstants.currentdeliverylocation.notifyListeners();
       IConstants.currentdeliverylocation.notifyListeners();
      }
    });
    // PrefUtils.prefs.setString("deliverylocation",store.userData.area);
  }
}

class CurrentLocation{
LatLng latlng;
String address;
bool status;
String area;
String branch;
CurrentLocation(this.latlng,this.address,this.area,this.status,this.branch);
}