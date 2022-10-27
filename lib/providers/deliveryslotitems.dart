import 'dart:convert';
import 'package:flutter/material.dart';
import '../assets/ColorCodes.dart';
import '../constants/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../utils/prefUtils.dart';
import '../models/deliveryslotfields.dart';

class DeliveryslotitemsList with ChangeNotifier {
 static DateTime date = DateTime.now();
 var date1 = DateTime.now();

 static final now = DateTime.now();
 static final today = DateTime(now.year, now.month, now.day);
 static final tomorrow = DateTime(now.year, now.month, now.day + 1);
 static final dayaftertomorrow = DateTime(now.year, now.month, now.day + 2);

 var prevMonth = new DateTime(date.year, date.month, date.day + 1);

 List<DeliveryslotFields> _items = [ ];
 List<DeliveryslotFields> _time = [];
 List<DeliveryslotFields> _itemsPickup = [ ];

 Future<void> fetchDeliveryslots (String addressid) async { // imp feature in adding async is the it automatically wrap into Future.

  _items.clear();
  _time.clear();

   try {
   _items.clear();
   _time.clear();
   final response = await http.post(
   Api.getDeliverySlots,
       body: { // await keyword is used to wait to this operation is complete.
        "address": addressid,
        "branch": PrefUtils.prefs.getString('branch'),
       }
   );

   final responseJson = json.decode(utf8.decode(response.bodyBytes));
   debugPrint("response...."+responseJson.toString());
   if(responseJson.toString() == "[]") {

   } else {
    List data = [];

    responseJson.asMap().forEach((index, value) =>
        data.add(responseJson[index] as Map<String, dynamic>)
    );
    var prevdate = "";
    var index = "";
    for (int i = 0; i < data.length; i++) {
     if (prevdate != data[i]['date'].toString()) {
      String date = data[i]['date'].toString();
      final f = new DateFormat('dd-MM-yyyy',"en");
      var parsedDate = f.parse(date.trim());
      var width = 3.0;
      if (i == 0) {
       width = 3.0;
      } else {
       width = 1.0;
      }
      index = i.toString();

      _items.add(DeliveryslotFields(
       id: i.toString(),
       day: DateFormat('EEEEEEE').format(parsedDate).toUpperCase(),
       date: DateFormat('d MMM, EEE').format(parsedDate),
       dateformat: data[i]['date'],
       width: width,
      ));


      prevdate = data[i]['date'].toString();
     }

     Color selectedColor;
     bool isSelect;
     if(i == 0) {
      selectedColor = ColorCodes.mediumgren;
      isSelect = true;
     } else {
      selectedColor = ColorCodes.whiteColor;
      isSelect = false;
     }
     _time.add(DeliveryslotFields(
      time: data[i]['time'],
      id: index,
      index: i.toString(),
      /*selectedColor: selectedColor,
      isSelect: isSelect,*/
     ));
    }
   }

   notifyListeners();
  } catch (error) {
   throw error;
  }
 }

 List<DeliveryslotFields> get items {
  return [..._items];
 }

 List<DeliveryslotFields> findById(String timeslotsid) {
  // ignore: unrelated_type_equality_checks
  debugPrint("print..."+timeslotsid);
  return [..._time.where((id) => id.id == timeslotsid)];
 }

 List<DeliveryslotFields> get times {
  return [..._time];
 }

 Future<void> fetchPickupslots (String addressid) async { // imp feature in adding async is the it automatically wrap into Future.
  _itemsPickup.clear();
  try {
   _itemsPickup.clear();
   final response = await http.get(Api.getPickupSlot+addressid);
   final responseJson = json.decode(utf8.decode(response.bodyBytes));
   debugPrint("getpickup..."+responseJson.toString());
   if(responseJson.toString() == "[]") {

   } else {
    List data = [];

    responseJson.asMap().forEach((index, value) =>
        data.add(responseJson[index] as Map<String, dynamic>)
    );

    for (int i = 0; i < data.length; i++) {
     Color selectedColor;
     bool isSelect;
     if(i == 0) {
      selectedColor = ColorCodes.mediumgren;
      isSelect = true;
     } else {
      selectedColor = ColorCodes.whiteColor;
      isSelect = false;
     }

     String date = data[i]['date'].toString();
     final f = new DateFormat('dd-MM-yyyy',"en");
     var parsedDate = f.parse(date.trim());


     _itemsPickup.add(DeliveryslotFields(
      date: /*data[i]['date'].toString()*/DateFormat('d MMM, EEE').format(parsedDate),
      time: data[i]['time'].toString(),
     ));
    }
   }

   notifyListeners();
  } catch (error) {
   throw error;
  }
 }

 List<DeliveryslotFields> get itemsPickup {
  return [..._itemsPickup];
 }

}