import 'package:flutter/cupertino.dart';
import '../../constants/IConstants.dart';

import 'category_modle.dart';
import 'product_data.dart';
import 'user.dart';

class HomePageData {
  Data data;

  HomePageData({this.data});

  HomePageData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<UserData> customerDetails;
  OfferByCart offerByCart;
  OfferByCart featuredByCart;
  OfferByCart discountByCart;
  List<AllBrands> allBrands;
  List<CategoryData> allCategoryDetails;
  String categoryLabel;
  List<CategoryData> category1Details;
  String categoryTwoLabel;
  List<CategoryData> category2Details;
  String categoryThreeLabel;
  List<CategoryData> category3Details;
  List<BannerDetails> mainslider;
  List<BannerDetails> featuredCategories1;
  List<BannerDetails> featureditems1;
  List<BannerDetails> featuredCategories2;
  List<BannerDetails> featuredCategories3;
  List<BannerDetails> verticalSlider;
  List<BannerDetails> footerImage;
  List<BannerDetails> wesiteslider;
  List<BannerDetails> mainslideradd;

  Data(
      {this.customerDetails,
        this.offerByCart,
        this.featuredByCart,
        this.discountByCart,
        this.allBrands,
        this.allCategoryDetails,
        this.categoryLabel,
        this.category1Details,
        this.categoryTwoLabel,
        this.category2Details,
        this.categoryThreeLabel,
        this.category3Details,
        this.mainslider,
        this.featuredCategories1,
        this.featureditems1,
        this.featuredCategories2,
        this.featuredCategories3,
        this.verticalSlider,
        this.mainslideradd,
        this.wesiteslider,
        this.footerImage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['customerDetails'] != null) {
      customerDetails = new List<UserData>();
      json['customerDetails'].forEach((v) {
        customerDetails.add(new UserData.fromJson(json['customerDetails'][0]));
      });
    }
    offerByCart = json['OfferByCart'] != null
        ? new OfferByCart.fromJson(json['OfferByCart'])
        : null;
    featuredByCart = json['FeaturedByCart'] != null
        ? new OfferByCart.fromJson(json['FeaturedByCart'])
        : null;
    discountByCart = json['DiscountByCart'] != null
        ? new OfferByCart.fromJson(json['DiscountByCart'])
        : null;
    if (json['AllBrands'] != null) {
      allBrands = new List<AllBrands>();
      json['AllBrands'].forEach((v) {
        allBrands.add(new AllBrands.fromJson(v));
      });
    }
    if (json['AllCategoryDetails'] != null) {
      debugPrint("all,..,.,.," + json['AllCategoryDetails'].toString());
      allCategoryDetails = new List<CategoryData>();
      json['AllCategoryDetails'].forEach((v) {
        allCategoryDetails.add(new CategoryData.fromJson(v));
      });
    }
    categoryLabel = json['category_label'];
    if (json['Category1Details'] != null) {
      print("j fffvfv0" + json['Category1Details'].toString());
      category1Details = new List<CategoryData>();
      json['Category1Details'].forEach((v) {
        category1Details.add(new CategoryData.fromJson(v));
      });
    }
    categoryTwoLabel = json['category_two_label'];
    if (json['Category2Details'] != null) {
      category2Details = new List<CategoryData>();
      json['Category2Details'].forEach((v) {
        category2Details.add(new CategoryData.fromJson(v));
      });
    }
    categoryThreeLabel = json['category_three_label'];
    if (json['Category3Details'] != null) {
      category3Details = new List<CategoryData>();
      json['Category3Details'].forEach((v) {
        category3Details.add(new CategoryData.fromJson(v));
      });
    }
    if(json['MainSliderAdd']!=null){
      mainslideradd =new List<BannerDetails>();
      json['MainSliderAdd'].forEach((v){
        mainslideradd.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['mainslider'] != null) {
      mainslider = new List<BannerDetails>();
      json['mainslider'].forEach((v) {
        mainslider.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['FeaturedCategories1'] != null) {
      featuredCategories1 = new List<BannerDetails>();
      json['FeaturedCategories1'].forEach((v) {
        featuredCategories1.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['Featureditems1'] != null) {
      featureditems1 = new List<BannerDetails>();
      json['Featureditems1'].forEach((v) {
        featureditems1.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['FeaturedCategories2'] != null) {
      featuredCategories2 = new List<BannerDetails>();
      json['FeaturedCategories2'].forEach((v) {
        featuredCategories2.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['FeaturedCategories3'] != null) {
      featuredCategories3 = new List<BannerDetails>();
      json['FeaturedCategories3'].forEach((v) {
        featuredCategories3.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['VerticalSlider'] != null) {
      verticalSlider = new List<BannerDetails>();
      json['VerticalSlider'].forEach((v) {
        verticalSlider.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['FooterImage'] != null) {
      footerImage = new List<BannerDetails>();
      json['FooterImage'].forEach((v) {
        footerImage.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['WebsiteSlider'] != null) {
      wesiteslider = new List<BannerDetails>();
      json['WebsiteSlider'].forEach((v) {
        wesiteslider.add(new BannerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerDetails != null) {
      data['customerDetails'] =
          this.customerDetails.map((v) => v.toJson()).toList();
    }
    if (this.featuredByCart != null) {
      data['FeaturedByCart'] = this.featuredByCart.toJson();
    }
    if (this.discountByCart != null) {
      data['DiscountByCart'] = this.discountByCart.toJson();
    }
    if (this.offerByCart != null) {
      data['OfferByCart'] = this.offerByCart.toJson();
    }
    if (this.allBrands != null) {
      data['AllBrands'] = this.allBrands.map((v) => v.toJson()).toList();
    }
    if (this.allCategoryDetails != null) {
      data['AllCategoryDetails'] =
          this.allCategoryDetails.map((v) => v.toJson()).toList();
    }
    data['category_label'] = this.categoryLabel;
    if (this.category1Details != null) {
      data['Category1Details'] =
          this.category1Details.map((v) => v.toJson()).toList();
    }
    data['category_two_label'] = this.categoryTwoLabel;
    if (this.category2Details != null) {
      data['Category2Details'] =
          this.category2Details.map((v) => v.toJson()).toList();
    }
    data['category_three_label'] = this.categoryThreeLabel;
    if (this.category3Details != null) {
      data['Category3Details'] =
          this.category3Details.map((v) => v.toJson()).toList();
    }
    if (this.mainslider != null) {
      data['mainslider'] = this.mainslider.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories1 != null) {
      data['FeaturedCategories1'] =
          this.featuredCategories1.map((v) => v.toJson()).toList();
    }
    if (this.featureditems1 != null) {
      data['Featureditems1'] =
          this.featureditems1.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories2 != null) {
      data['FeaturedCategories2'] =
          this.featuredCategories2.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories3 != null) {
      data['FeaturedCategories3'] =
          this.featuredCategories3.map((v) => v.toJson()).toList();
    }
    if (this.verticalSlider != null) {
      data['VerticalSlider'] =
          this.verticalSlider.map((v) => v.toJson()).toList();
    }
    if (this.footerImage != null) {
      data['FooterImage'] = this.footerImage.map((v) => v.toJson()).toList();
    }
    if (this.mainslideradd != null) {
      data['MainSliderAdd'] = this.mainslideradd.map((v) => v.toJson()).toList();
    }
    if (this.wesiteslider != null) {
      data['WebsiteSlider'] = this.wesiteslider.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferByCart {
  List<ItemData> data;
  String label;

  OfferByCart({this.data, this.label});

  OfferByCart.fromJson(Map<String, dynamic> json) {
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


class AllBrands {
  String id;
  String categoryName;
  String iconImage;
  String catBanner;

  AllBrands({this.id, this.categoryName, this.iconImage});

  AllBrands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    iconImage = IConstants.API_IMAGE+"sub-category/icons/" +json['icon_image'];
    catBanner = IConstants.API_IMAGE+"sub-category/banners/" +json['banner'];
    print("image....."+iconImage.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon_image'] = this.iconImage;
    data['bannerImage'] = this.catBanner;
    return data;
  }
}

class BannerDetails {
  int id;
  String title;
  String branch;
  String bannerFor;
  bool isActive;
  String bannerImage;
  String advertisementType;
  String displayFor;
  String click_link;

  BannerDetails(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.bannerImage,
        this.advertisementType,
        this.click_link,
        this.displayFor});

  BannerDetails.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    isActive = (json['is_active']=="1");
    bannerImage = IConstants.API_IMAGE+"banners/banner/"+json['banner_image'];
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    click_link = json['click_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['branch'] = this.branch;
    data['banner_for'] = this.bannerFor;
    data['is_active'] = this.isActive;
    data['banner_image'] = this.bannerImage;
    data['advertisement_type'] = this.advertisementType;
    data['display_for'] = this.displayFor;
    data['click_link'] = this.click_link;
    return data;
  }
}

