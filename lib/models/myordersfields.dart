import 'package:flutter/foundation.dart';

class MyordersFields with ChangeNotifier {
  final String reference_id;
  final String paymentType;
  final String oid;
  final String odate;
  final String ototal;
  final String odelcharge;
  final String promocode;
  final double loyalty;
  final double wallet;
  final String totalDiscount;
  final String opaytype;
  final String orderType;
  final String ostatus;
  final String ostatustext;
  final String odeltime;
  final String odelivery;
  final bool isdeltime;
  final String oaddress;
  final String itemname;
  final String varname;
  final String price;
  final String qty;
  final String subtotal;
  final String itemorderid;
  final String loyalty_earned;
  final String membership_earned;
  final String promocode_discount;
  final String itemid;
  final String customerorderitemsid;
  final String itemoactualamount;
  final String itemodelcharge;
  final String itemototalamount;
  final String omobilenum;
  final String fit;

  bool checkboxval;
  String qtychange;

  final String returnref;
  final String returnitemname;
  final String returnaddress;
  final String returndate;
  final String returnreason;
  final String returnvarname;
  final String returnitemqty;

  final String itemImage;
  final String itemQuantity;
  final String itemPrice;

  final String totalTax;
  final String customerName;
  final String paymentStatus;
  final String restPay;
  final String itemLeftCount;
  final String id;
  final String discount;
  final String menuid;
  final String barcode;
  final String deliveryOn;
  final String returnTime;
  final String isTray;
  final String trayQty;
  final String ofdate;
  final String itemsCount;
  final String items;
  final String extraAmount;
  final String returnStatus;
  final String giftWrapamount;
  final String size;

  //subscription

  final String subid;
  final String userid;
  final String varid;
  final String createdtime;
  final String quantity;
  final String delivery;
  final String startdate;
  final String enddate;
  final String addres;
  final String  addressid;
  final String addresstype;
  final String amount;
  final String branch;
  final String slot;
  final String paymenttype;
  final String crontime;
  final String status;
  final String channel;
  final String type;
  final String name;
  final String image;
  final String dueamount;
  final String reason;
  final String edited;
  final String refund;
  final String vegtype;
  final String refundqty;
  final String invoice;
  final String variation_name;
  final String houseno;
  final String landmark;
  final String area;
  final String state;
  final String city;
  final String pincode;
  final String mobile;
  final String title;
  final List<String> available_size;
  final List<String> options;



  MyordersFields(  {
    this.reference_id,
    this.paymentType,
    this.oid,
    this.odate,
    this.ototal,
    this.odelcharge,
    this.promocode,
    this.loyalty,
    this.wallet,
    this.totalDiscount,
    this.opaytype,
    this.orderType,
    this.ostatus,
    this.ostatustext,
    this.odeltime,
    this.odelivery,
    this.isdeltime,
    this.oaddress,
    this.itemname,
    this.varname,
    this.fit,
    this.price,
    this.qty,
    this.subtotal,
    this.itemorderid,
    this.itemid,
    this.customerorderitemsid,
    this.itemoactualamount,
    this.itemodelcharge,
    this.itemototalamount,
    this.omobilenum,
    this.checkboxval,
    this.qtychange,
    this.returnref,
    this.returnitemname,
    this.returnaddress,
    this.returndate,
    this.returnreason,
    this.returnvarname,
    this.returnitemqty,
    this.itemImage,
    this.itemQuantity,
    this.itemPrice,
    this.totalTax,
    this.customerName,
    this.paymentStatus,
    this.restPay,
    this.itemLeftCount,
    this.id,
    this.discount,
    this.menuid,
    this.barcode,
    this.returnTime,
    this.deliveryOn,
    this.isTray,
    this.trayQty,
    this.ofdate,
    this.itemsCount,
    this.items,
    this.extraAmount,
    this.returnStatus,
    this.giftWrapamount,
    this.size,
    this.loyalty_earned,
    this. membership_earned,
    this. promocode_discount,

    //subscription

    this.subid,
    this.userid,
    this.varid,
    this.createdtime,
    this.quantity,
    this.delivery,
    this.startdate,
    this.enddate,
    this.addres,
    this.addressid,
    this.addresstype,
    this.amount,
    this.branch,
    this.slot,
    this.paymenttype,
    this.crontime,
    this.status,
    this.channel,
    this.type,
    this.name,
    this.image,
    this.dueamount,
    this.reason,
    this.edited,
    this.refund,
    this.vegtype,
    this.refundqty,
    this.invoice,
    this.variation_name,
    this.houseno,
    this.landmark,
    this.area,
    this.state,
    this.city,
    this.pincode,
    this.mobile,
    this.title,
    this.available_size,
    this.options,

  });
}