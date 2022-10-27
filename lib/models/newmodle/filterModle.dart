import 'package:flutter/material.dart';

class FilterData{
  List<ColorsFilter> colorItems;
  List<SizeFilter> sizeItems;
  List<FitFilter> fitItems;

  FilterData({this.colorItems,this.fitItems,this.sizeItems});

}
class ColorsFilter{
  String id;
  String colorName;
  String color;
  bool selected;

  ColorsFilter({this.id,this.color,this.colorName,this.selected});

  ColorsFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colorName = json['colourName']??"";
    color = json['colourCode']??"";
    selected = false;
  }
  Map<String, dynamic> toJson({bool selected}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['colourName'] = this.colorName;
    data['colourCode'] = this.color;
    data['selected'] = selected??this.selected;
    return data;
  }
}

class SizeFilter{
  String id;
  String size;
  bool selected;

  SizeFilter({this.id,this.size,this.selected});

  SizeFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size']??"";
    selected = false;
  }
  Map<String, dynamic> toJson({bool selected}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['selected'] = selected??this.selected;

    return data;
  }
}

class FitFilter{
  String id;
  String fit;
  bool selected;

  FitFilter({this.id,this.fit,this.selected});

  FitFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fit = json['fit']??"";
    selected = false;
  }
  Map<String, dynamic> toJson({bool selected}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fit'] = this.fit;
    data['selected'] = selected??this.selected;


    return data;
  }
}