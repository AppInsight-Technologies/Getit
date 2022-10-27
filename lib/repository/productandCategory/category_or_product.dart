import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../models/newmodle/category_modle.dart';
import '../../models/newmodle/filterModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class ProductRepo {

Future<List<CategoryData>>  getCategory()async {
   var resp = json.decode(await api.Geturl(
      "restaurant/get-categories?branch=${PrefUtils.prefs.getString("branch") ??
          "999"}&language_id=${PrefUtils.prefs.getString("language_id") ??
          "0"}",isv2: false));
  if (resp["status"]) {
    List<CategoryData> caatdata;
   return CategoryDataModle.fromJson(resp).data/*.data.forEach((element) =>
        getSubcategory(element, (p0) {
          element.subCategory.addAll(p0);
          caatdata.add(element);
        }))*/;
    // return caatdata;
  }
}
Future<List<ItemData>> getcategoryitemlist(categoryId) async {
  api.body = {
    "branch": PrefUtils.prefs.getString("branch"),
    "language_id": "0",
  };
  final response = await api.Posturl("get-items-by-cart/$categoryId/${PrefUtils.prefs.getString("apiKey") ?? "1"}",isv2: false);
  List<ItemData> data =[];
  if((json.decode(response)).toString()=="[]")
    return null;
  else{
    json.decode(response).asMap().forEach((index, value){
      data.add(ItemData.fromJson(value));
    });
    return Future.value(data);
  }

}
getSubcategory(String catid,
      Function(List<CategoryData>) response) async {
    if(catid!=null) {
      var resp =
          await api.Geturl("restaurant/get-sub-category/${catid}");
      if (resp != "[]") {
        debugPrint("sub category...." + catid.toString() + "..."  + resp.toString());
        if (SubCatModle.fromJson(json.decode(resp)).status) {
         response( SubCatModle.fromJson(json.decode(resp)).data);
        } else {
          response(null);
        }
      } else {
        response(null);
      }
    }
    else{
      response(null);
    }
  }

  Future<List<ItemData>> getCartProductLists(categoryId, {start = 0, end = 0, type=0,}) async {
    print("menu by...."+{
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs.getString("branch"),
      "user": PrefUtils.prefs.getString("apikey") ?? "1",
      "language_id": "0",
      "type" : type.toString(),
    }.toString());

  api.body = {
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs.getString("branch"),
      "user": PrefUtils.prefs.getString("apikey") ?? "1",
      "language_id": "0",
      "type" : type.toString(),
    };
    print("sss...."+api.body.toString());
 final response = await api.Posturl("restaurant/get-menuitem-by-cart");
 print("menu..."+response.toString());
if((json.decode(response)["data"]).toString()=="[]")
  return null;
else
    return Future.value(ItemModle.fromJson(json.decode(response)).data);
  }
  Future<List<ItemData>> getBrandProductLists(categoryId, {start = 0, end = 0,}) async {
    api.body = {
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs.getString("branch"),
      "user": PrefUtils.prefs.getString("apiKey") ?? "1",
      "language_id": "0"
    };
    final response = await api.Posturl("restaurant/get-menuitem-by-brand-by-cart");
    print("brand length.."+response.toString());
    if((json.decode(response)["data"]).toString()=="[]")
      return null;
    else
    return Future.value(ItemModle
        .fromJson(json.decode(response))
        .data);
  }
  Future<List<ItemData>> getProduct(prodid) async {
    api.body = {
      'id': prodid,
      'branch': PrefUtils.prefs.getString("branch"),
      'user': PrefUtils.prefs.getString("apikey"),
      'language_id': '0'
    };
    return Future.value(ItemModle
        .fromJson(json.decode(await api.Posturl("single-product-by-cart")))
        .data);
  }
  Future<List<ItemData>> getSearchQuery(query) async {
    api.body = {
      'branch': PrefUtils.prefs.getString("branch"),
      'user': PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("tokenid"),
      'language_id': '0',
      'item_name': '$query',
    };
  final resp =  await api.Posturl("restaurant/search-items-by-cart",isv2: false);
    return Future.value(ItemModle
        .fromJson(json.decode(resp))
        .data);
  }
  Future<ItemModle> getRecentProduct(prodid) async{
  print("productid: $prodid");
    return Future.value(ItemModle
        .fromJson(json.decode(await api.Posturl("restaurant/get-recent-products-by-cart/$prodid/${PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("tokenid")}/${PrefUtils.prefs.getString("branch")}",isv2: false)))
        );
  }
  Future<List<ItemData>> getFilterProductLists(FilterData filterData,int minprice, int maxprice, String subcatId) async {

  final _colorlist = filterData.colorItems.where((element) => element.selected).toList();
  final _fitlist = filterData.fitItems.where((element) => element.selected).toList();
  final _sizelist = filterData.sizeItems.where((element) => element.selected).toList();

  String colorString = '';
  String fitString = '';
  String sizeString = '';
  String coma = '';
  String coma1 = '';
  String coma2 = '';

   _colorlist.forEach((element) {
     colorString = colorString + coma + "\'" + element.color + "\'";
     //colorString.add("\'" + element.color + "\'");
     print("color.."+colorString.toString());
     coma=",";
   });

  _fitlist.forEach((element) {
    fitString = fitString + coma1 + "\'" + element.fit + "\'";
    //fitString.add("\'" + element.fit + "\'");
    coma1=",";
  });

  _sizelist.forEach((element) {
    sizeString = sizeString + coma2 + "\'" + element.size + "\'";
    //sizeString.add("\'" + element.size + "\'");
    coma2=",";
  });
  print("color1.."+colorString.toString() + " bfhv" + {
    "fit":fitString.toString(),
    "branch":PrefUtils.prefs.getString("branch"),
    "color":colorString.toString(),
    "minprice":minprice.toString(),
    "maxprice":maxprice.toString(),
    "size":sizeString.toString(),
    "category": subcatId.toString(),
    'language_id': '0',
  }.toString());
  api.body = {
    "fit":fitString.toString(),
    "branch":PrefUtils.prefs.getString("branch"),
    "color":colorString.toString(),
    "minprice":minprice.toString(),
    "maxprice":maxprice.toString(),
    "size":sizeString.toString(),
    "category": subcatId.toString(),
    'language_id': '0',
  };

  final response = await api.Posturl("filter/product");
  print("filter..."+response.toString());
  if((json.decode(response)).toString()=="[]")
    return null;
  else
    {
      List<ItemData> data= [];
      json.decode(response).asMap().forEach((index, value) =>
          data.add(ItemData.fromJson(value))
      );
      return Future.value(data);
    }

 }

Future<List<ItemData>> getSortProductLists(int sort, String subcatId) async {
  print("kjevbvbiuv" + {
    "sort":sort.toString(),
    "category": subcatId.toString(),
    "branch":PrefUtils.prefs.getString("branch"),
  }.toString());
  api.body = {
    "sort":sort.toString(),
    "category": subcatId.toString(),
    "branch":PrefUtils.prefs.getString("branch"),
  };

  final response = await api.Posturl("sort/product");
  print("sort..."+response.toString());
  if((json.decode(response)).toString()=="[]")
    return null;
  else
  {
    List<ItemData> data= [];
    json.decode(response).asMap().forEach((index, value) =>
        data.add(ItemData.fromJson(value))
    );
    return Future.value(data);
  }

}
}
class CategoryDataModle {
  bool status;
  List<CategoryData> data;

  CategoryDataModle({this.status, this.data});

  CategoryDataModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<CategoryData>();
      json['data'].forEach((v) {
        data.add(new CategoryData.fromJson(v));
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
class ItemModle {
  bool status;
  List<ItemData> data;

  ItemModle({this.status, this.data});

  ItemModle.fromJson(Map<String, dynamic> json) {
    status = json['status']??true;
    if (json['data'] != null) {
      data = new List<ItemData>();
      json['data'].forEach((v) {
        print("productdata:"+v.toString());
        data.add(new ItemData.fromJson(v));
      });
      print(" data length${data.length}");
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
class SubCatModle {
  bool status;
  List<CategoryData> data;

  SubCatModle({this.status, this.data});

  SubCatModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<CategoryData>();
      json['data'].forEach((v) {
        data.add(new CategoryData.fromJson(v));
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
