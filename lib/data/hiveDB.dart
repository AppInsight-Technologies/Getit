import 'package:hive/hive.dart';

part 'hiveDB.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int itemId;

  @HiveField(1)
  int varId;

  @HiveField(2)
  String varName;

  @HiveField(3)
  int varMinItem;

  @HiveField(4)
  int varMaxItem;

  @HiveField(5)
  int varStock;

  @HiveField(6)
  double varMrp;

  @HiveField(7)
  String itemName;

  @HiveField(8)
  int itemQty;

  @HiveField(9)
  double itemPrice;

  @HiveField(10)
  String membershipPrice;

  @HiveField(11)
  double itemActualprice;

  @HiveField(12)
  String itemImage;

  @HiveField(13)
  double itemWeight;

  @HiveField(14)
  int itemLoyalty;

  @HiveField(15)
  int membershipId;

  @HiveField(16)
  int mode;

  @HiveField(17)
  String veg_type;

  @HiveField(18)
  String type;

  @HiveField(19)
  String eligible_for_express;

  @HiveField(20)
  String delivery;

  @HiveField(21)
  String duration;

  @HiveField(22)
  String durationType;

  @HiveField(23)
  String note;

  Product({this.itemId, this.varId, this.varName, this.varMinItem,
      this.varMaxItem, this.varStock, this.varMrp, this.itemName,
      this.itemQty, this.itemPrice, this.membershipPrice, this.itemActualprice, this.itemImage,
    this.itemWeight, this.itemLoyalty, this.membershipId, this.mode, this.veg_type, this.type,
    this.eligible_for_express,this.delivery,this.duration,this.durationType,this.note
  });

}