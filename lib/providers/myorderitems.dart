import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/features.dart';
import '../../data/calculations.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/sellingitemsfields.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../models/myordersfields.dart';
import '../utils/prefUtils.dart';

class MyorderList with ChangeNotifier {
  List<MyordersFields> _items = [];
  List<MyordersFields> _reasons = [];
  List<MyordersFields> _itemssub = [];
  List<SellingItemsFields> _wishlist = [];
  List<SellingItemsFields> _getpromo = [];
  List<SellingItemsFields> __wishlistvar = [];
  List<SellingItemsFields> _wishimage = [];
  List<MyordersFields> _subitemorder = [];
  List<MyordersFields> _orderitems = [];
  List<MyordersFields> _returnitems = [];
  List<MyordersFields> _addressitems = [];
  List<MyordersFields> _refunditems = [];
  List<CartItem> productBox=[];

  Future<void> Getordersold() async {
    var url = Api.getCustomerOrder + PrefUtils.prefs.getString('apiKey');
    try {
      _items.clear();

      final response = await http.get(
        url,
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]") {
      } else {
        final itemJson =
            json.encode(responseJson['items']); //fetching sub categories data
        final itemJsondecode = json.decode(itemJson);
        List data = [];
        itemJsondecode.asMap().forEach((index, value) =>
            data.add(itemJsondecode[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          var delivery = "";
          String orderstatustext;
          bool isdeltime = true;
          if (data[i]['orderStatus'].toString().toLowerCase() == "received" ||
              data[i]['orderStatus'].toString().toLowerCase() == "processing" ||
              data[i]['orderStatus'].toString().toLowerCase() == "ready" ||
              data[i]['orderStatus'].toString().toLowerCase() == "dispatched") {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERY ON";
            }
            isdeltime = true;
          } else if (data[i]['orderStatus'].toString().toLowerCase() ==
              "cancelled") {
            delivery = "";
            isdeltime = false;
          } else {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERED ON";
            }
            isdeltime = true;
          }
          _items.add(MyordersFields(
            id: data[i]['id'].toString(),
            oid: data[i]['order_d'].toString(),
            itemid: data[i]['itemId'].toString(),
            itemname: data[i]['itemName'].toString(),
            varname: data[i]['priceVariavtion'].toString(),
            price: data[i]['price'].toString(),
            qty: data[i]['quantity'].toString(),
            itemoactualamount: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['actualAmount'].toString()).toStringAsFixed(0):double.parse(data[i]['actualAmount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            discount: (IConstants.numberFormat == "1")
                ? double.parse(data[i]['discount'].toString()).toStringAsFixed(0):double.parse(data[i]['discount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            subtotal: (IConstants.numberFormat == "1")
                ? double.parse(data[i]['subTotal'].toString()).toStringAsFixed(0):double.parse(data[i]['subTotal'].toString()).toStringAsFixed(IConstants.decimaldigit),
            itemImage: data[i]['image'].toString(),
//              itemImage: IConstants.API_IMAGE + "items/images/" + data[i]['image'].toString(),

            menuid: data[i]['menuid'].toString(),
            odeltime: data[i]['fixtime'].toString(),
            odate: data[i]['fixdate'].toString(),
            itemPrice: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['itemPrice'].toString()).toStringAsFixed(0):double.parse(data[i]['itemPrice'].toString()).toStringAsFixed(IConstants.decimaldigit),
            itemQuantity: data[i]['itemQuantity'].toString(),
            itemLeftCount: data[i]['itemLeftCount'].toString(),
            ostatustext: orderstatustext,
            odelivery: delivery,
            isdeltime: isdeltime,
            ototal: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['orderAmount'].toString()).toStringAsFixed(0):double.parse(data[i]['orderAmount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            orderType: data[i]['orderType'].toString(),
            ostatus: data[i]['orderStatus'].toString(),
            extraAmount: data[i]['extraAmount'].toString(),
          ));
        }
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> Getorders() async {
    var url = Api.getCustomerOrderBranch + PrefUtils.prefs.getString('apiKey')+ "/"+ PrefUtils.prefs.getString('branch');
    try {
      _items.clear();

      final response = await http.get(
        url,
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]") {
      } else {
        final itemJson =
        json.encode(responseJson['items']); //fetching sub categories data
        final itemJsondecode = json.decode(itemJson);
        List data = [];
        itemJsondecode.asMap().forEach((index, value) =>
            data.add(itemJsondecode[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          var delivery = "";
          String orderstatustext;
          bool isdeltime = true;
          if (data[i]['orderStatus'].toString().toLowerCase() == "received" ||
              data[i]['orderStatus'].toString().toLowerCase() == "processing" ||
              data[i]['orderStatus'].toString().toLowerCase() == "ready" ||
              data[i]['orderStatus'].toString().toLowerCase() == "dispatched") {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERY ON";
            }
            isdeltime = true;
          } else if (data[i]['orderStatus'].toString().toLowerCase() ==
              "cancelled") {
            delivery = "";
            isdeltime = false;
          } else {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERED ON";
            }
            isdeltime = true;
          }
          _items.add(MyordersFields(
            id: data[i]['id'].toString(),
            oid: data[i]['order_d'].toString(),
            itemid: data[i]['itemId'].toString(),
            itemname: data[i]['itemName'].toString(),
            varname: data[i]['priceVariavtion'].toString(),
            price: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['price'].toString()).toStringAsFixed(0):double.parse(data[i]['price'].toString()).toStringAsFixed(IConstants.decimaldigit),
            qty: data[i]['quantity'].toString(),
            itemoactualamount: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['actualAmount'].toString()).toStringAsFixed(0):double.parse(data[i]['actualAmount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            discount: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['discount'].toString()).toStringAsFixed(0):double.parse(data[i]['discount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            subtotal: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['subTotal'].toString()).toStringAsFixed(0):double.parse(data[i]['subTotal'].toString()).toStringAsFixed(IConstants.decimaldigit),
            itemImage: data[i]['image'].toString(),
//              itemImage: IConstants.API_IMAGE + "items/images/" + data[i]['image'].toString(),

            menuid: data[i]['menuid'].toString(),
            odeltime: data[i]['fixtime'].toString(),
            odate: data[i]['fixdate'].toString(),
            itemPrice: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['itemPrice'].toString()).toStringAsFixed(0):double.parse(data[i]['itemPrice'].toString()).toStringAsFixed(IConstants.decimaldigit),
            itemQuantity: data[i]['itemQuantity'].toString(),
            itemLeftCount: data[i]['itemLeftCount'].toString(),
            ostatustext: orderstatustext,
            odelivery: delivery,
            isdeltime: isdeltime,
            ototal: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['orderAmount'].toString()).toStringAsFixed(0):double.parse(data[i]['orderAmount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            orderType: data[i]['orderType'].toString(),
            ostatus: data[i]['orderStatus'].toString(),
            extraAmount: data[i]['extraAmount'].toString(),
              returnStatus:data[i]['returnStatus'].toString(),
          ));
        }
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> GetSplitorders(String startitem,String checkinitialy) async {
   // int startitem = 0;
    PrefUtils.prefs.setBool("endOfOrder", false);
    try {
      if(checkinitialy == "initialy") {
        _items.clear();

      } else {
      }


      final response = await http.post(Api.getCustomerRefOrderBranch, body: {
        "id": PrefUtils.prefs.getString('apikey'),
        "branch": PrefUtils.prefs.getString('branch'),
        "start": startitem.toString(),
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]") {
        PrefUtils.prefs.setBool("endOfOrder", true);
      } else {
        if (checkinitialy == "initialy") {
          _items.clear();

        } else {}
        final itemJson =
        json.encode(responseJson['items']); //fetching sub categories data
        final itemJsondecode = json.decode(itemJson);
        List data = [];
        itemJsondecode.asMap().forEach((index, value) =>
            data.add(itemJsondecode[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          var delivery = "";
          String orderstatustext;
          bool isdeltime = true;
          if (data[i]['orderStatus'].toString().toLowerCase() == "received" ||
              data[i]['orderStatus'].toString().toLowerCase() == "processing" ||
              data[i]['orderStatus'].toString().toLowerCase() == "ready" ||
              data[i]['orderStatus'].toString().toLowerCase() == "dispatched") {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERY ON";
            }
            isdeltime = true;
          } else if (data[i]['orderStatus'].toString().toLowerCase() ==
              "cancelled") {
            delivery = "";
            isdeltime = false;
          } else {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERED ON";
            }
            isdeltime = true;
          }
          _items.add(MyordersFields(
            reference_id: data[i]['referenceID'].toString(),
            paymentType: data[i]['paymentType'].toString(),
            id: data[i]['id'].toString(),
            oid: data[i]['order_d'].toString(),
            itemid: data[i]['itemId'].toString(),
            itemname: data[i]['itemName'].toString(),
            varname: data[i]['priceVariavtion'].toString(),
            price: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['price'].toString()).toStringAsFixed(0):double.parse(data[i]['price'].toString()).toStringAsFixed(IConstants.decimaldigit),
            qty: data[i]['quantity'].toString(),
            itemoactualamount: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['actualAmount'].toString()).toStringAsFixed(0):double.parse(data[i]['actualAmount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            discount: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['discount'].toString()).toStringAsFixed(0):double.parse(data[i]['discount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            subtotal: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['subTotal'].toString()).toStringAsFixed(0):double.parse(data[i]['subTotal'].toString()).toStringAsFixed(IConstants.decimaldigit),
            itemImage: data[i]['image'].toString(),
//              itemImage: IConstants.API_IMAGE + "items/images/" + data[i]['image'].toString(),
            itemodelcharge: data[i]['deliveryCharge'].toString(),
            menuid: data[i]['menuid'].toString(),
            odeltime: data[i]['fixtime'].toString(),
            odate: data[i]['fixdate'].toString(),
            itemPrice: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['itemPrice'].toString()).toStringAsFixed(0):double.parse(data[i]['itemPrice'].toString()).toStringAsFixed(IConstants.decimaldigit),
            itemQuantity: data[i]['itemQuantity'].toString(),
            itemLeftCount: data[i]['itemLeftCount'].toString(),
            loyalty: (data[i]['loyalty'].toString() != "null" &&
                double.parse(data[i]['loyalty'].toString()) > 0)
                ? double.parse(data[i]['loyalty'].toString())
                : 0,
            totalDiscount: data[i]['totalDiscount'].toString(),
            ostatustext: orderstatustext,
            odelivery: delivery,
            isdeltime: isdeltime,
            ototal: (IConstants.numberFormat == "1")
                ?double.parse(data[i]['orderAmount'].toString()).toStringAsFixed(0):double.parse(data[i]['orderAmount'].toString()).toStringAsFixed(IConstants.decimaldigit),
            orderType: data[i]['orderType'].toString(),
            ostatus: data[i]['orderStatus'].toString(),
            extraAmount: data[i]['extraAmount'].toString(),
            returnStatus:data[i]['returnStatus'].toString(),
            dueamount: data[i]['refund'].toString(),
          ));
        }

        List<MyordersFields> finalList = [];
        finalList = _items.where((i) => i.reference_id == i.reference_id ).toList();
        Map<String, List<MyordersFields>> newMap2= groupBy(finalList, (obj) => obj.reference_id);


        var groupByDate = groupBy(_items, (obj) => obj.reference_id);
        groupByDate.forEach((referid, list) {
          // Header
          // Group
          list.forEach((listItem) {
            // List item
          });
          // day section divider
        });



      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> GetSubscriptionorders() async {
    debugPrint("api key...."+PrefUtils.prefs.getString('apikey'));
    var url = Api.mySubscriptionList + PrefUtils.prefs.getString('apikey')+ "/"+ PrefUtils.prefs.getString('branch');
    try {
      _itemssub.clear();

      final response = await http.get(
        url,
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]") {
      } else {
        for (int i = 0; i < responseJson.length; i++) {
          debugPrint("var name..."+responseJson[i]['variation_name'].toString());
          _itemssub.add(MyordersFields(
            subid: responseJson[i]['id'].toString(),
            userid: responseJson[i]['user_id'].toString(),
            varid: responseJson[i]['var_id'].toString(),
            createdtime: responseJson[i]['created_time'].toString(),
            quantity: responseJson[i]['quantity'].toString(),
            delivery: responseJson[i]['deliveries'].toString(),
            startdate: responseJson[i]['start_date'].toString(),
            enddate: responseJson[i]['end_date'].toString(),
            addres: responseJson[i]['address'].toString(),
            addressid: responseJson[i]['address_id'].toString(),
            addresstype: responseJson[i]['address_type'].toString(),
            amount: responseJson[i]['amount'].toString(),
            branch: responseJson[i]['branch'].toString(),
            slot: responseJson[i]['slot'].toString(),
            paymenttype: responseJson[i]['payment_type'].toString(),
            crontime: responseJson[i]['cron_time'].toString(),
            status: responseJson[i]['status'].toString(),
            channel: responseJson[i]['channel'].toString(),
            type: responseJson[i]['type'].toString(),
            name: responseJson[i]['name'].toString(),
            image: responseJson[i]['image'].toString(),
            variation_name: responseJson[i]['variation_name'].toString(),
          )
          );
        }


          }


      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  Future<void> Vieworders(String orderId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.viewCustomerOrderDetails + orderId;
   // try {
      _items.clear();
      _orderitems.clear();
      _reasons.clear();
      _addressitems.clear();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
print("response json....view return"+responseJson.toString());
      if (responseJson.toString() == "[]") {
      } else {
        var delivery = "";
        String orderstatustext;
        bool isdeltime = true;
        if (['orderStatus'].toString().toLowerCase() == "received" ||
            responseJson['orderStatus'].toString().toLowerCase() ==
                "processing" ||
            responseJson['orderStatus'].toString().toLowerCase() == "ready" ||
            responseJson['orderStatus'].toString().toLowerCase() ==
                "dispatched") {
          if (responseJson['orderType'].toString().toLowerCase() == "pickup") {
            delivery = "PICKUP ON";
          } else {
            delivery = "DELIVERY ON";
          }
          isdeltime = true;
        } else if (responseJson['orderStatus'].toString().toLowerCase() ==
            "cancelled") {
          delivery = "";
          isdeltime = false;
        } else {
          if (responseJson['orderType'].toString().toLowerCase() == "pickup") {
            delivery = "PICKUP ON";
          } else {
            delivery = "DELIVERED ON";
          }
          isdeltime = true;
        }
        _items.add(MyordersFields(
          promocode: (responseJson['promocode'].toString() != "null" &&
              responseJson['promocode'] != "")
              ? responseJson['promocode'].toString()
              : "",
          wallet: (responseJson['wallet'].toString() != "null" &&
                  double.parse(responseJson['wallet'].toString()) > 0)
              ? double.parse(responseJson['wallet'].toString())
              : 0,
          loyalty: (responseJson['loyalty'].toString() != "null" &&
                  double.parse(responseJson['loyalty'].toString()) > 0)
              ? double.parse(responseJson['loyalty'].toString())
              : 0,
          itemorderid: responseJson['id'].toString(),
          customerorderitemsid: responseJson['id'].toString(),
          odate: responseJson['orderDate'].toString(),
          itemoactualamount: responseJson['actualAmount'].toString(),
          totalTax: responseJson['totalTax'].toString(),
          totalDiscount: responseJson['totalDiscount'].toString(),
          itemototalamount: responseJson['orderAmount'].toString(),
          customerName: responseJson['customerName'].toString(),
          oaddress: responseJson['address'].toString(),
          orderType: responseJson['orderType'].toString(),
          opaytype: responseJson['paymentType'].toString(),
          paymentStatus: responseJson['paymentStatus'].toString(),
          restPay: responseJson['restPay'].toString(),
          odeltime: responseJson['fixtime'].toString(),
          ofdate: responseJson['fixdate'].toString(),
          ostatus: responseJson['orderStatus'].toString(),
          itemodelcharge: responseJson['deliveryCharge'].toString(),
          itemsCount: responseJson['itemsCount'].toString(),
          extraAmount: responseJson['items'][0]['extraAmount'].toString(),
          returnStatus:responseJson['returnStatus'].toString(),
          loyalty_earned:responseJson['loyalty_earned'].toString(),
          membership_earned:responseJson['membership_earned'].toString(),
          promocode_discount:responseJson['promocode_discount'].toString(),
          dueamount: responseJson['refund'].toString(),
          invoice : responseJson['invoice'].toString(),
          giftWrapamount: responseJson['gift_wrap_amount'].toString(),
        ));
   print("items after assign"+{"promocode": (responseJson['promocode'].toString() != "null" &&
   responseJson['promocode'] != "")
   ? responseJson['promocode'].toString()
       : "",
   "wallet": (responseJson['wallet'].toString() != "null" &&
   double.parse(responseJson['wallet'].toString()) > 0)
   ? double.parse(responseJson['wallet'].toString())
       : 0,
   "loyalty": (responseJson['loyalty'].toString() != "null" &&
   double.parse(responseJson['loyalty'].toString()) > 0)
   ? double.parse(responseJson['loyalty'].toString())
       : 0,
   "itemorderid": responseJson['id'].toString(),
   "customerorderitemsid": responseJson['id'].toString(),
   "odate": responseJson['orderDate'].toString(),
   "itemoactualamount": responseJson['actualAmount'].toString(),
   "totalTax": responseJson['totalTax'].toString(),
   "totalDiscount": responseJson['totalDiscount'].toString(),
   "itemototalamount": responseJson['orderAmount'].toString(),
   "customerName": responseJson['customerName'].toString(),
   "oaddress": responseJson['address'].toString(),
   "orderType": responseJson['orderType'].toString(),
   "opaytype": responseJson['paymentType'].toString(),
   "paymentStatus": responseJson['paymentStatus'].toString(),
   "restPay": responseJson['restPay'].toString(),
   "odeltime": responseJson['fixtime'].toString(),
   "ofdate": responseJson['fixdate'].toString(),
   "ostatus": responseJson['orderStatus'].toString(),
   "itemodelcharge": responseJson['deliveryCharge'].toString(),
   "itemsCount": responseJson['itemsCount'].toString(),
   "extraAmount": responseJson['items'][0]['extraAmount'].toString(),
   "returnStatus":responseJson['returnStatus'].toString(),
   "loyalty_earned":responseJson['loyalty_earned'].toString(),
   "membership_earned":responseJson['membership_earned'].toString(),
   "promocode_discount":responseJson['promocode_discount'].toString(),
   "dueamount": responseJson['refund'].toString(),
   "invoice" : responseJson['invoice'].toString(),
   "giftWrapamount": responseJson['gift_wrap_amount'].toString(),}.toString());

        final itemJson = json.encode(responseJson['items']);
        final itemJsondecode = json.decode(itemJson);
        List data = [];

        itemJsondecode.asMap().forEach((index, value) =>
            data.add(itemJsondecode[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          var delivery = "";
          String orderstatustext;
          bool isdeltime = true;
          if (data[i]['orderStatus'].toString().toLowerCase() == "received" ||
              data[i]['orderStatus'].toString().toLowerCase() == "processing" ||
              data[i]['orderStatus'].toString().toLowerCase() == "ready" ||
              data[i]['orderStatus'].toString().toLowerCase() == "dispatched") {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERY ON";
            }
            isdeltime = true;
          } else if (data[i]['orderStatus'].toString().toLowerCase() ==
              "cancelled") {
            delivery = "";
            isdeltime = false;
          } else {
            if (data[i]['orderType'].toString().toLowerCase() == "pickup") {
              delivery = "PICKUP ON";
            } else {
              delivery = "DELIVERED ON";
            }
            isdeltime = true;
          }
          _orderitems.add(MyordersFields(
            id: data[i]['id'].toString(),
            customerorderitemsid: data[i]['id'].toString(),
            itemorderid: responseJson['id'].toString(),
            oid: data[i]['order_d'].toString(),
            itemid: data[i]['itemId'].toString(),
            itemname: data[i]['itemName'].toString(),
            varname: data[i]['priceVariavtion'].toString(),
            price: data[i]['price'].toString(),
            qty: data[i]['quantity'].toString(),
            itemoactualamount: data[i]['actualAmount'].toString(),
            discount: data[i]['discount'].toString(),
            subtotal: data[i]['subTotal'].toString(),
            fit: data[i]['fit'].toString(),
            size: data[i]['size'].toString(),
            itemImage: data[i]['image'].toString(),
            menuid: data[i]['menuid'].toString(),
            barcode: data[i]['barcode'].toString(),
            returnTime: data[i]['return_time'].toString(),
            deliveryOn: (responseJson['orderStatus'].toString() == "DELIVERED") ? responseJson['deliveryOn'].toString() : "",
            ostatustext: orderstatustext,
            ostatus: responseJson['orderStatus'].toString(),
            odelivery: delivery,
            isdeltime: isdeltime,
            checkboxval: false,
            qtychange: data[i]['quantity'].toString(),
            extraAmount: data[i]['extraAmount'].toString(),
            returnStatus:data[i]['returnStatus'].toString(),
            giftWrapamount: data[i]['gift_wrap_amount'].toString(),
            loyalty_earned:responseJson['loyalty_earned'].toString(),
            membership_earned:responseJson['membership_earned'].toString(),
            promocode_discount:responseJson['promocode_discount'].toString(),
            available_size: data[i]['available_sizes'].cast<String>(),

          )
          );
          debugPrint("availablesize...."+data[i]['available_sizes'].toString());
        }

        final addressJson = json.encode(responseJson['address']);
        final addressJsondecode = json.decode(addressJson);
        List addressdata = [];

        addressJsondecode.asMap().forEach((index, value) =>
            addressdata.add(addressJsondecode[index] as Map<String, dynamic>));

        for (int i = 0; i < addressdata.length; i++) {
          _addressitems.add(MyordersFields(
            houseno:  addressdata[i]['house_no'].toString(),
            landmark: addressdata[i]['landmark'].toString(),
            area: addressdata[i]['area'].toString(),
            state: addressdata[i]['state'].toString(),
            city: addressdata[i]['city'].toString(),
            pincode: addressdata[i]['pincode'].toString(),
              mobile: addressdata[i]['mobile'].toString(),
          ));
        }

        final reasonJson = json.encode(responseJson['reason']);
        final reasonJsondecode = json.decode(reasonJson);
        List reasondata = [];

        reasonJsondecode.asMap().forEach((index, value) =>
            reasondata.add(reasonJsondecode[index] as Map<String, dynamic>));

        for (int i = 0; i < reasondata.length; i++) {
          _reasons.add(MyordersFields(
            title:  reasondata[i]['title'].toString(),
            options: reasondata[i]['options'].cast<String>(),
          ));

          debugPrint("options...."+reasondata[i]['options'].toString());
        }


      }
      notifyListeners();
   /* } catch (error) {
      throw error;
    }*/
  }

  Future<void> AddWishList(String itemId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    print("jhbv" + itemId);
    var url = Api.addwishlist;
    // try {
      final response = await http.post(url, body: {
        "user": PrefUtils.prefs.getString("apikey"),
        "itemId": itemId,
        "branch": PrefUtils.prefs.getString("branch"),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
        print("responseJson...add.." + responseJson.toString());
        if (responseJson["status"] == 200) {
              Fluttertoast.showToast(
              msg: "Product Added to Wishlist",
              // "Something went wrong",
              fontSize: 13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        } else {
          Fluttertoast.showToast(
          msg: "Something went wrong",
          // "Something went wrong",
          fontSize: 13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
      }
      notifyListeners();
    // } catch (error) {
    //   throw error;
    // }
  }

  Future<List<ItemData>> GetWishList() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getwishlist;
     debugPrint("apikey....token..."+PrefUtils.prefs.getString("apikey"));
      final response = await http.post(url, body: {
        "user": PrefUtils.prefs.getString("apikey"),
        "branch": PrefUtils.prefs.getString("branch"),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("responseJson....wish.."+responseJson.toString());

      if (responseJson.toString() != "[]") {
        List<ItemData> data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(
                ItemData.fromJson(value)
            )
        );
        return Future.value(data);

      }
      else {

      }
      notifyListeners();

  }

  Future<void> RemoveWishList(String itemId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    print("jhbv" + itemId);
    var url = Api.removewishlist;
    // try {
    final response = await http.post(url, body: {
      "user": PrefUtils.prefs.getString("apikey"),
      "itemId": itemId,
      "branch": PrefUtils.prefs.getString("branch"),
    });
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    print("responseJson remove...." + responseJson.toString());
    if (responseJson["status"] == 200) {
      Fluttertoast.showToast(
          msg: "Product Removed from Wishlist",
          // "Something went wrong",
          fontSize: 13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          // "Something went wrong",
          fontSize: 13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
    notifyListeners();
    // } catch (error) {
    //   throw error;
    // }
  }

  Future<List<Promocode>> GetPromoCode() async {
    // imp feature in adding async is the it automatically wrap into Future.
    productBox = (VxState.store as GroceStore).CartItemList;
    double cartTotal = 0.0;
    if ((VxState.store as GroceStore).userData.membership == "1") {
      debugPrint("totalMember...."+ CartCalculations.totalMember.toString());
      cartTotal = CartCalculations.totalMember;
    } else {
      debugPrint("total...."+CartCalculations.total.toString());
      cartTotal = CartCalculations.total;
    }
    String promovarprice;
    var item = [];
    for (int i = 0; i < productBox.length; i++) {
        if (double.parse(productBox[i].membershipPrice) <=
            0 ||
            productBox[i].membershipPrice == "" ||
            double.parse(productBox[i].membershipPrice) ==
                productBox[i].varMrp) {
          promovarprice = productBox[i].varMrp.toString();
        } else {
          promovarprice = productBox[i].membershipPrice;
        }

      var item1 = {};
      item1["\"itemid\""] =
          "\"" + productBox[i].varId.toString() + "\"";
      item1["\"qty\""] = productBox[i].quantity.toString();
      item1["\"price\""] = promovarprice;
      item.add(item1);
    }
    var url = Api.getPromocode;
    debugPrint("body promo relevant...."+{
      "user": PrefUtils.prefs.getString("apikey"),
      "branch": PrefUtils.prefs.getString("branch"),
      "price": cartTotal,
      "items": item.toString(),

    }.toString());
    final response = await http.post(url, body: {
      "user": PrefUtils.prefs.getString("apikey"),
      "branch": PrefUtils.prefs.getString("branch"),
      "price": cartTotal.toString(),
      "items": item.toString(),

    });
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    debugPrint("responseJson....promo.."+responseJson.toString());

    if (responseJson.toString() != "[]") {
      List<Promocode> data = [];

      responseJson.asMap().forEach((index, value) =>
          data.add(
              Promocode.fromJson(value)
          )
      );
      return Future.value(data);
    }
    else {

    }
    notifyListeners();

  }

  Future<void> Viewsubscriptionorders(String orderId) async {
    debugPrint("orderId...."+orderId.toString());
  try {
      _subitemorder.clear();
      final response = await http.get(Api.viewSubscriptionList + orderId, /*body: {

      }*/);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
     debugPrint("responseJson...."+responseJson.toString());
      if (responseJson.toString() == "[]") {
      } else {
        for (int i = 0; i < responseJson.length; i++) {
          _subitemorder.add(MyordersFields(
            subid: responseJson[i]['id'].toString(),
            //userid: responseJson['user_id'].toString(),
            //varid: responseJson['var_id'].toString(),
            // createdtime: responseJson['created_time'].toString(),
            quantity: responseJson[i]['quantity'].toString(),
            delivery: responseJson[i]['deliveries'].toString(),
            startdate: responseJson[i]['start_date'].toString(),
            enddate: responseJson[i]['end_date'].toString(),
            addres: responseJson[i]['address'].toString(),
            addressid: responseJson[i]['address_id'].toString(),
            addresstype: responseJson[i]['address_type'].toString(),
            amount: responseJson[i]['amount'].toString(),
            branch: responseJson[i]['branch'].toString(),
            slot: responseJson[i]['slot'].toString(),
            paymenttype: responseJson[i]['payment_type'].toString(),
            crontime: responseJson[i]['cron_time'].toString(),
            status: responseJson[i]['status'].toString(),
            channel: responseJson[i]['channel'].toString(),
            type: responseJson[i]['type'].toString(),
            name: responseJson[i]['name'].toString(),
            image: responseJson[i]['image'].toString(),
          )
          );
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> Refund(String orderId) async {
   try {
    _refunditems.clear();
    final response = await http.post(Api.getRefundProduct, body: {
      "id": orderId,
    });
    final responseJson = json.decode(utf8.decode(response.bodyBytes));

    if (responseJson.toString() == "[]") {
    } else {
      for (int i = 0; i < responseJson.length; i++) {
        _refunditems.add(MyordersFields(
          reason: responseJson[i]['reason'].toString(),
          edited: responseJson[i]['edited'].toString(),
          vegtype: responseJson[i]['veg_type'].toString(),
          id: responseJson[i]['id'].toString(),
          totalTax: responseJson[i]['tax'].toString(),
          customerorderitemsid: responseJson[i]['id'].toString(),
          itemorderid: responseJson[i]['id'].toString(),
          oid: responseJson[i]['order_d'].toString(),
          itemid: responseJson[i]['itemId'].toString(),
          itemname: responseJson[i]['itemName'].toString(),
          varname: responseJson[i]['priceVariavtion'].toString(),
          price: responseJson[i]['price'].toString(),
          qty: responseJson[i]['quantity'].toString(),
          itemoactualamount: responseJson[i]['actualAmount'].toString(),
          discount: responseJson[i]['discount'].toString(),
          subtotal: responseJson[i]['subTotal'].toString(),
          itemImage: responseJson[i]['image'].toString(),
          menuid: responseJson[i]['menuid'].toString(),
          barcode: responseJson[i]['barcode'].toString(),
          returnTime: responseJson[i]['return_time'].toString(),
          deliveryOn: (responseJson[i]['orderStatus'].toString() == "DELIVERED") ? responseJson[i]['deliveryOn'].toString() : "",
          ostatus: responseJson[i]['orderStatus'].toString(),
          checkboxval: false,
          qtychange: responseJson[i]['quantity'].toString(),
          extraAmount: responseJson[i]['extraAmount'].toString(),
            refund: (responseJson[i]['refund'] ?? 0).toString(),
          returnStatus:responseJson[i]['returnStatus'].toString(),
          loyalty_earned:responseJson[i]['loyalty_earned'].toString(),
          membership_earned:responseJson[i]['membership_earned'].toString(),
          promocode_discount:responseJson[i]['promocode_discount'].toString(),
          odate: responseJson[i]['orderDate'].toString(),
          paymentType: responseJson[i]['refund_mode'].toString(),
          refundqty: responseJson[i]['refund_quantity'].toString()


        )
        );
      }
    }
    notifyListeners();
     } catch (error) {
      throw error;
    }
  }

  Future<void> ReturnItem(String array, String orderid, String itemname, String reason, String issue, String text) async {
    try {
      final response = await http.post(Api.newReturn, body: {
        "customerId": PrefUtils.prefs.getString('apikey'),
        "orderid": orderid,
       // "date": PrefUtils.prefs.getString('fixdate'),
        "note": text??"",
        "reason": reason,
        "issue": issue,
        "mode": PrefUtils.prefs.getString('return_type'),
        "address": PrefUtils.prefs.getString('addressId'),
        "itemId": array.toString(),
        "branch": PrefUtils.prefs.getString('branch'),
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == '200') {}
    } catch (error) {
      throw error;
    }
  }

  List<MyordersFields> get items {
    return [..._items];
  }

  List<MyordersFields> get itemssub {
    return [..._itemssub];
  }


  List<MyordersFields> findById(String orderid) {
    return [..._orderitems.where((myorder) => myorder.itemorderid == orderid)];
  }

  List<MyordersFields> findBySubId(String orderid) {
    return [..._orderitems.where((myorder) => myorder.itemorderid == orderid)];
  }

  List<MyordersFields> findByreturnId(String orderid) {
    return [..._returnitems.where((myorder) => myorder.itemorderid == orderid)];
  }

  List<MyordersFields> get vieworder {
    return [..._items];
  }
  List<MyordersFields> get viewordersubscription {
    return [..._subitemorder];
  }
  List<SellingItemsFields> get getwishlist{
    return [..._wishlist];
  }
  List<SellingItemsFields> get getpromo{
    return [..._getpromo];
  }
  List<MyordersFields> get vieworder1 {

    return [..._orderitems];
  }
  List<MyordersFields> get addressitems {
    return [..._addressitems];
  }
  List<MyordersFields> get reasons {
    return [..._reasons];
  }

  List<MyordersFields> get refundorder {
    return [..._refunditems];
  }

}
