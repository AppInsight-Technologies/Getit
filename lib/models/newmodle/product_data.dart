import 'package:flutter/cupertino.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';

class ItemData {
  String id;
  String eligibleForExpress;
  var deliveryDuration;
  String eligibleForSubscription;
  List<SubscriptionSlot> subscriptionSlot;
  //var subscriptionSlot;
  String paymentMode;
  String duration;
  String categoryId;
  String itemName;
  String itemSlug;
  String vegType;
  String itemFeaturedImage;
  String regularPrice;
  String salePrice;
  String isActive;
  String salesTax;
  String totalQty;
  String brand;
  String type;

  int wishlist;
  List<PriceVariation> priceVariation;
  int replacement;
  // var deliveryDuration;
  String delivery;
  String mode;
  bool isSelect;
  ItemData(
      {this.id,
        this.eligibleForExpress,
        this.deliveryDuration,
        this.eligibleForSubscription,
        this.subscriptionSlot,
        this.paymentMode,
        this.duration,
        this.categoryId,
        this.itemName,
        this.itemSlug,
        this.vegType,
        this.itemFeaturedImage,
        this.regularPrice,
        this.salePrice,
        this.isActive,
        this.salesTax,
        this.totalQty,
        this.brand,
        this.type,
        this.replacement,
        this.wishlist,
        this.priceVariation,
        this.delivery,
        this.mode,
        this.isSelect
      });

  ItemData.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    eligibleForExpress = Features.isExpressDelivery? Features.isSplit? json['eligible_for_express'] : "0" : "1";
    deliveryDuration = json['delivery_duration'];
    eligibleForSubscription = json['eligible_for_subscription'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = new List<SubscriptionSlot>();
      json['subscription_slot'].forEach((v) {
        subscriptionSlot.add(new SubscriptionSlot.fromJson(v));
      });
    }

    deliveryDuration = (json['delivery_duration'] == "slot" || json['delivery_duration'] == ""|| json['delivery_duration'] == null)
        ?new DeliveryDurationData(duration: "",durationType: "",note: ""):new DeliveryDurationData.fromJson(json['delivery_duration']is List<dynamic> ?json['delivery_duration'][0]:json['delivery_duration']);
    paymentMode = json['payment_mode'];
    duration = json['duration'];
    categoryId = json['category_id'];
    itemName = json['item_name'];
    itemSlug = json['item_slug'];
    vegType = json['veg_type'];
    itemFeaturedImage =  IConstants.API_IMAGE + "items/images/" +/*json['item_featured_image']!=null?*/json['item_featured_image']/*:json["itemFeaturedImage"]*/;
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    isActive = json['is_active'];
    salesTax = json['sales_tax'];
    totalQty = json['total_qty'];
    replacement = json['replacement'];
    brand = json['brand'];
    wishlist = json['wishlist'];
    type = json['type'];
    delivery = (json['delivery']??"0");
    mode=(json['mode']??"0");
    if (json['price_variation'] != null) {
      priceVariation = new List<PriceVariation>();
      json['price_variation'].forEach((v) {
        priceVariation.add(new PriceVariation.fromJson(v));
      });
    }

    if(json['wishlist'] ==1) {
      isSelect = true;
    } else {
      isSelect = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eligible_for_express'] = this.eligibleForExpress;
    data['delivery_duration'] = this.deliveryDuration;
    data['eligible_for_subscription'] = this.eligibleForSubscription;
    if (this.subscriptionSlot != null) {
      data['subscription_slot'] =
          this.subscriptionSlot.map((v) => v.toJson()).toList();
    }
    data['payment_mode'] = this.paymentMode;
    data['duration'] = this.duration;
    data['category_id'] = this.categoryId;
    data['item_name'] = this.itemName;
    data['item_slug'] = this.itemSlug;
    data['veg_type'] = this.vegType;
    data['item_featured_image'] = this.itemFeaturedImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['is_active'] = this.isActive;
    data['sales_tax'] = this.salesTax;
    data['total_qty'] = this.totalQty;
    data['brand'] = this.brand;
    data['replacement'] = this.replacement;
    data['wishlist'] = this.wishlist;
    data['type'] = this.type;
    data['mode'] =this.mode;
    if (this.priceVariation != null) {
      data['price_variation'] =
          this.priceVariation.map((v) => v.toJson()).toList();
    }
    if (this.deliveryDuration != null) {
      data['delivery_duration'] = this.deliveryDuration.toJson();
    }
    return data;
  }
}

class SubscriptionSlot {
  String id;
  String name;
  String cronTime;
  String deliveryTime;
  String branch;
  String status;

  SubscriptionSlot(
      {this.id,
        this.name,
        this.cronTime,
        this.deliveryTime,
        this.branch,
        this.status});

  SubscriptionSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cronTime = json['cronTime'];
    deliveryTime = json['deliveryTime'];
    branch = json['branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cronTime'] = this.cronTime;
    data['deliveryTime'] = this.deliveryTime;
    data['branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}

class PriceVariation {
  int loyalty;
  String netWeight;
  String id;
  String menuItemId;
  String variationName;
  double price;
  String priority;
  double mrp;
  int stock;
  String maxItem;
  String size;
  String unit;
  String fit;
  String status;
  String minItem;
  double membershipPrice;
  int loyaltys;
  List<ImageDate> images;
  String weight;
  int quantity;
  bool discointDisplay = false;
  bool membershipDisplay = false;
  String mode;

  PriceVariation(
      {this.loyalty,
        this.netWeight,
        this.id,
        this.menuItemId,
        this.variationName,
        this.price,
        this.priority,
        this.mrp,
        this.stock,
        this.maxItem,
        this.size,
        this.unit,
        this.fit,
        this.status,
        this.minItem,
        this.membershipPrice,
        this.loyaltys,
        this.images,
        this.weight,
        this.quantity,
        this.membershipDisplay,
        this.discointDisplay,
        this.mode
      });

  PriceVariation.fromJson(Map<String, dynamic> json) {
    debugPrint("json['size']....xxx....."+json['size']);
    loyalty = json['loyalty'];
    netWeight = json['net_weight'];
    id = json['id'];
    menuItemId = json['menu_item_id'];
    variationName = json['variation_name'];
    price = double.parse(json['price'].toString());
    priority = json['priority'];
    mrp = double.parse(json['mrp'].toString());
    stock = json['stock'];
    maxItem = json['max_item'];
    size = json['size'];
    fit = json['fit'];
    unit = json['unit'];
    status = json['status'];
    minItem = json['min_item'];
    membershipPrice = double.parse(json['membership_price'].toString());
    loyaltys = json['loyaltys'];
    if (json['images'] != null) {
      images = new List<ImageDate>();
      json['images'].forEach((v) {
        images.add(new ImageDate.fromJson(v));
      });
    }
    if(json['price'] <= 0 || json['price'] == "" || json['price'] == json['mrp']){
      discointDisplay = false;
    } else {
      discointDisplay = true;
    }

    if(json['membership_price'] == '-' || json['membership_price'] == "0" || json['membership_price'] == json['mrp']
        || json['membership_price'] == json['price']) {
      membershipDisplay = false;
    } else {
      membershipDisplay = true;
    }
    weight = json['weight'];
    quantity = int.parse(json['quantity'].toString());
    mode= json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loyalty'] = this.loyalty;
    data['net_weight'] = this.netWeight;
    data['id'] = this.id;
    data['menu_item_id'] = this.menuItemId;
    data['variation_name'] = this.variationName;
    data['price'] = this.price;
    data['priority'] = this.priority;
    data['mrp'] = this.mrp;
    data['stock'] = this.stock;
    data['max_item'] = this.maxItem;
    data['size'] = this.size;
    data['unit'] = this.unit;
    data['fit'] = this.fit;
    data['status'] = this.status;
    data['min_item'] = this.minItem;
    data['membership_price'] = this.membershipPrice;
    data['loyaltys'] = this.loyaltys;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['weight'] = this.weight;
    data['quantity'] = this.quantity;
    data['mode']=this.mode;
    return data;
  }
}

class DeliveryDurationData {
  String id;
  String durationType;
  String duration;
  String status;
  String branch;
  String note;
  String blockFor;

  DeliveryDurationData(
      {this.id="",
        this.durationType="",
        this.duration="",
        this.status="",
        this.branch="",
        this.note="'",
        this.blockFor=""});

  DeliveryDurationData.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    durationType = json['durationType'].toString();
    duration = json['duration']??"";
    status = json['status'].toString()??"";
    branch = json['branch']??"";
    note = json['note'];
    blockFor = json['blockFor']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['durationType'] = this.durationType;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['branch'] = this.branch;
    data['note'] = this.note;
    data['blockFor'] = this.blockFor;
    return data;
  }
}


class ImageDate {
  String id;
  String image;
  String ref;

  ImageDate({this.id, this.image, this.ref});

  ImageDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image =  IConstants.API_IMAGE+"items/images/" +json['image'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['ref'] = this.ref;
    return data;
  }
}

class Promocode {
  String id;
  String promocode;
  String description;
  String appliedFor;

  Promocode({this.id, this.promocode, this.description, this.appliedFor});

  Promocode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promocode = json['promocode'];
    description = json['description'];
    appliedFor = json['appliedFor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['promocode'] = this.promocode;
    data['description'] = this.description;
    data['appliedFor'] = this.appliedFor;
    return data;
  }
}