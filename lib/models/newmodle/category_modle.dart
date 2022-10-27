
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import '../../constants/IConstants.dart';

class CategoryData {
  String id;
  String categoryName;
  String iconImage;
  String description;
  String catBanner;
  String parentId;
  String heading;
  int type;
  List<CategoryData> subCategory = [];
  Color textcolor;
  FontWeight fontweight;

  CategoryData({this.id, this.categoryName, this.iconImage, this.catBanner, this.description});

  CategoryData.fromJson(Map<String, dynamic> json) {
    debugPrint("json['icon_image']..."+json['icon_image'].toString());
    id = json['id'];
    categoryName = json['category_name'];
    iconImage = IConstants.API_IMAGE+"sub-category/icons/" +json['icon_image'];
    catBanner = IConstants.API_IMAGE+"sub-category/banners/" + json['banner'].toString();
    description = json['description'];
    heading = json['heading'];
    parentId = json['parentId'];
    type = json['type']??0;
    if (json['SubCategory'] != null) {
      // debugPrint(".... " + json['SubCategory'].toString());
      subCategory = new List<CategoryData>();
      json['SubCategory'].forEach((v) {
        subCategory.add(new CategoryData.fromJson(v));
      });
    } else {
      debugPrint(".... 111" + json['SubCategory'].toString());

    }
  }

  Map<String, dynamic> toJson({List<CategoryData> subCategory}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon_image'] = this.iconImage;
    data['bannerImage'] = this.catBanner;
    data['description'] = this.description;
    data['parentId'] = this.parentId;
    data['heading'] = this.heading;
    data['type'] = this.type;
    if ((subCategory??this.subCategory) != null) {
      data['SubCategory'] = (subCategory??this.subCategory).map((v) => v.toJson()).toList();
    }
    return data;
  }
}