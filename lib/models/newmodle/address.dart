import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressModle {
  bool status;
  List<Address> data;

  AddressModle({this.status, this.data});

  AddressModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Address>();
      json['data'].forEach((v) {
        data.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  int id;
  String customer;
  String addressType;
  String fullName;
  String address;
  String lattitude;
  String logingitude;
  String isdefault;
  String pincode;
  IconData addressicon;
  String addressId;
  String area;
  String houseno;
  String street;
  String landmark;
  String state;
  String city;
  String apartment;
  String mobile;
  String mobileno;
  String type;


  Address(
      {this.id,
        this.customer,
        this.addressType,
        this.fullName,
        this.address,
        this.lattitude,
        this.logingitude,
        this.isdefault,
        this.pincode,
        this.addressicon,
        this.addressId,
        this.area,
        this.houseno,
        this.street,
        this.landmark,
        this.state,
        this.city,
        this.apartment,
        this.mobile,
        this.mobileno,
        this.type
      });

  Address.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    customer = json['customer'];
    addressType = json['addressType'];
    fullName = json['customername']??"";
    debugPrint("json['customername']...."+json['customername'].toString());
    address = json['address']??"";
    lattitude = json['lattitude'];
    logingitude = json['logingitude'];
    isdefault = json['default'];
    debugPrint("json['isdefault']...."+json['default'].toString());
    pincode = json['pincode']??"";
    area = json['area']??"";
    houseno = json['houseno']??"";
    street = json['street']??"";
    landmark = json['landmark']??"";
    state = json['state']??"";
    city = json['city']??"";
    apartment = json['apartment']??"";
    mobile = json['mobile']??"";
    mobileno = json['mobileNo']??"";
    type = json['type']??"";

    addressicon= json['addressType'].toString().toLowerCase()=="home"? Icons.home:json['addressType'].toString().toLowerCase()=="work"?Icons.work:Icons.location_on;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['addressType'] = this.addressType;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['lattitude'] = this.lattitude;
    data['logingitude'] = this.logingitude;
    data['isdefault'] = this.isdefault;
    data['pincode'] = this.pincode;
    data['houseno'] = houseno;
    data['area'] = area;
    data['landmark'] = landmark;
    data['street'] = " ";
    data['state'] = state;
    data['city'] = city;
    data['apartment'] = apartment;
    data['mobile'] = mobile;
    data['mobileno'] = " ";
    data['type'] = " ";

    return data;
  }
}