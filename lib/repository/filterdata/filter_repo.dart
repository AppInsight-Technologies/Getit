
import 'dart:convert';

import '../../models/newmodle/filterModle.dart';
import '../../repository/api.dart';

class FilterRepo{

  List<ColorsFilter> colorfilter=[];
  List<SizeFilter> sizefilter =[];
  List<FitFilter> fitfilter =[];

  Future<List<ColorsFilter>> getFilterColor()async{
    var resp = await api.Geturl("customer/ecommerce/color/list");
    print("colorlist..."+resp.toString());
    if(resp.toString() != "[]"){
      json.decode(resp).asMap().forEach((index, value) {
      colorfilter.add(ColorsFilter.fromJson(value));
      });
      return colorfilter;
      }
    else
      return [];
  }

  Future<List<SizeFilter>> getFilterSize()async{
    var resp = await api.Geturl("customer/ecommerce/size/list");
    if(resp.toString() != "[]"){
      json.decode(resp).asMap().forEach((index, value) {
        sizefilter.add(SizeFilter.fromJson(value));
      });
      return sizefilter;
    } else {
      return [];
    }
  }

  Future<List<FitFilter>> getFilterFit()async{
    var resp = await api.Geturl("customer/ecommerce/fit/list");
    if(resp.toString() != "[]"){
      json.decode(resp).asMap().forEach((index, value) {
        fitfilter.add(FitFilter.fromJson(value));
      });
      return fitfilter;
    } else {
      return [];
    }
  }
}