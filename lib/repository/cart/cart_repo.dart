import 'dart:convert';

import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class CartRepo{
  List<CartItem> cartlist = [];

  Future<CartFetch> getSudgetstedCart()async {
    return CartFetch.fromJson(json.decode(await api.Geturl("restaurant/get-items-data-by-cart?rows=0&branch=${PrefUtils.prefs.getString("branch")}&user=${PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("ftokenid")}&language_id=${PrefUtils.prefs.getString("language_id")??"0"}",isv2: false)));
  }
  Future<bool> reorder(String orderid)async{
    //print("orderid...."+orderid.toString()+PrefUtils.prefs.getString("branch").toString() +"..."+PrefUtils.prefs.containsKey("apikey").toString() +"..."+PrefUtils.prefs.getString("tokenid").toString());
    if(json.decode(await api.Geturl("reorder/$orderid/${PrefUtils.prefs.getString("branch")}/${PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("ftokenid")}",isv2: false))["status"]==200){
      return Future.value(true);
    }else  return Future.value(false);
  }
  Future<bool>  updateCart(Map<String,String> body)async{
    api.body = body;
    if(json.decode(await api.Posturl("update-cart",isv2: false))["status"]==200)
    return Future.value(true);
    else  return Future.value(false);
  }

  Future<Map<String,dynamic>>  addtoCart(Map<String,String> body)async{
    api.body = body;
    Map<String,dynamic> _map = {};
    var resp = await api.Posturl("add-to-cart",isv2: false);
    print("resp atc $resp");

    if(resp!=null&&json.decode(resp)["status"]==200) {
      _map["status"] = true;
      _map["data"] = json.decode(resp)["cart"];
      return Future.value(_map);
    } else {
      _map["status"] = true;
      return Future.value(_map);
    }
  }
  ///{
  ///       "user":
  ///       "var_id":3
  ///       "quantity":3
  ///       "price":240
  ///      "branch":999
  ///     }
  Future<bool>  emptyCart()async{
    if(json.decode(await api.Geturl("empty-cart/${PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("ftokenid")}",isv2: false))["status"]==200){
      return Future.value(true);
    }else  return Future.value(false);
  }

  Future<bool> awailiblityCheck(String itemid)async{
    if(json.decode(await api.Geturl("cart-check/${PrefUtils.prefs.getString("branch")}/$itemid",isv2: false))["status"]==0){
      return Future.value(true);
    }else  return Future.value(false);
  }

  Future<List<CartItem>> getCart(Function(bool) loading) async{
    loading(true);
   var jsonresp = json.decode(await api.Geturl("get-cart-items/${PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("ftokenid")}/${PrefUtils.prefs.getString("branch")}",isv2: false));
   print("cartitem:"+jsonresp.toString());
   jsonresp.asMap().forEach((index, value){
      cartlist.add(CartItem.fromJson(jsonresp[index] as Map<String,dynamic>));
    });
   loading(false);
   return cartlist;
  }
}
class CartFetch {
  List<ItemData> data;
  String label;

  CartFetch({this.data, this.label});

  CartFetch.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ItemData>();
      json['data'].forEach((v) {
        data.add(new ItemData.fromJson(v));
      });
    }
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    return data;
  }
}