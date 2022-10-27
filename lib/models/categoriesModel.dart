import 'package:flutter/material.dart';
import '../constants/IConstants.dart';

class CategoriesModel {
  String subcatid;
  String title;
  String imageUrl;
  String catBanner;
  String catid;
  Color _featuredCategoryBColor;

  CategoriesModel({String id, String categoryName, String iconImage, String catBanner, String parentId, Color featuredCategoryBColor}) {
    this.subcatid = id;
    this.title = categoryName;
    this.imageUrl = iconImage;
    this.catBanner = catBanner;
    this.catid = parentId;
    this._featuredCategoryBColor = featuredCategoryBColor;
  }

  String get id => subcatid;
  set id(String id) => subcatid = id;
  String get categoryName => title;
  set categoryName(String categoryName) => title = categoryName;
  String get iconImage => imageUrl;
  set iconImage(String iconImage) => imageUrl = iconImage;
  String get catBanner1 => catBanner;
  set catBanner1(String iconImage) => catBanner = catBanner;
  String get parentId => catid;
  set parentId(String parentId) => catid = parentId;
  Color get featuredCategoryBColor => _featuredCategoryBColor;
  set branch(Color featuredCategoryBColor) => _featuredCategoryBColor = featuredCategoryBColor;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    print("json" + json.toString());
    subcatid = json['id'];
    title = json['category_name'];
    imageUrl = IConstants.API_IMAGE + "sub-category/icons/" + json['icon_image'];
    catBanner = IConstants.API_IMAGE + "sub-category/banners/" + json['bannerImage'];
    catid = json['parentId'];
    _featuredCategoryBColor = json['featuredCategoryBColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.subcatid;
    data['category_name'] = this.title;
    data['icon_image'] = this.imageUrl;
    //data['bannerImage'] = this.catBanner;
    data['parentId'] = this.catid;
    data['featuredCategoryBColor'] = this._featuredCategoryBColor;
    return data;
  }
}
