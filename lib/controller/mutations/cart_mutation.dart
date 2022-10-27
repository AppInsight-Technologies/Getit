import 'package:flutter/cupertino.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/cart/cart_repo.dart';
import '../../services/firebaseAnaliticsService.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
enum CartTask{
  add,update,fetch
}
enum CartStatus{
  increment,remove,decrement
}
class CartController{
  final store = VxState.store as GroceStore;
  CartRepo _cart = CartRepo();
  update(Function(bool) onload,{String price,String quantity,String var_id}){
    debugPrint("update...");
    _cart.updateCart({
      "user":PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("ftokenid"),
      "var_id":var_id,
      "quantity":quantity,
      "price":price,
      "branch":PrefUtils.prefs.getString("branch")
    }).then((value) {
      if(value){
        SetCartItem(CartTask.update,quantity: quantity,varid: var_id,onloade: (value){
          onload(true);
        });
        if(quantity!="0")
        fas.LogAddtoCart(itemId:var_id, itemName: store.CartItemList.where((element) => element.varId == var_id ).first.itemName, itemCategory: store.CartItemList.where((element) => element.varId == var_id ).first.id, quantity:1,
            amount:double.parse(price), value: Cart.ADD);
      }else{
        SetCartItem(CartTask.add ,onloade: (value){
          onload(true);
        });
      }
    });
    // SetCartItem(CartTask.update,quantity: quantity,varid: var_id,onloade: (value){});
  }
  clear(Function(bool) status){
    _cart.emptyCart().then((value) {
      if(value){
        (VxState.store as GroceStore).CartItemList.clear();
        status(value);
        /*SetCartItem(CartTask.add,onloade: (value){
          status(value);
        });*/
      }
    });
  }
  fetch({Function(bool) onload}){
    onload(false);
    SetCartItem(CartTask.fetch ,onloade: (value){
      onload(true);
    });
  }
  addtoCart(PriceVariation itembody,ItemData itemdata,Function(bool) onload){
    onload(true);
    fas.LogAddtoCart(itemId:itembody.id, itemName: itembody.variationName, itemCategory: itembody.menuItemId, quantity:1,
        amount:itembody.price, value: Cart.ADD);
    // debugPrint("add...single"+itembody.variationName.toString()+".."+itembody.unit.toString());
    debugPrint("add...single"+itembody.stock.toString()+".."+itembody.status.toString()+"mode.."+itemdata.mode.toString());

    Map<String,String> body =  {
      "user":PrefUtils.prefs.containsKey("apikey")?PrefUtils.prefs.getString("apikey"):PrefUtils.prefs.getString("ftokenid"),
      "var_id":itembody.id,
      "itemId": itemdata.id,
      "stock":itembody.stock.toString()??"0",
      "varName":itembody.variationName+itembody.unit,
      "varMinItem":itembody.minItem??"0",
      "varMaxItem":itembody.maxItem??"0",
      "itemLoyalty":itembody.loyalty.toString(),
      "varStock":itembody.stock.toString()??"0",
      "varMrp":itembody.mrp.toString()??"0",
      "itemName":itemdata.itemName,
      "quantity":"1",
      "price":itembody.price.toString()??"0",
      "membershipPrice":itembody.membershipPrice.toString()??"",
      "itemActualprice":itembody.mrp.toString(),
      "itemImage":itembody.images!=null?itembody.images.length>0?itembody.images[0].image:itemdata.itemFeaturedImage??"":itemdata.itemFeaturedImage??"",
      "membershipId":"0",
      "mode":itemdata.mode??"0",
      "membership":(VxState.store as GroceStore).userData.membership??"0",
      "veg_type":itemdata.vegType??"",
      "eligible_for_express":itemdata.eligibleForExpress??"0",
      "delivery":itemdata.delivery,
      "duration":itemdata.deliveryDuration.duration,
      "duration_type":itemdata.deliveryDuration.durationType,
      "note":itemdata.deliveryDuration.note,
      "type":itemdata.type,
      "status":itembody.status,
      "branch":PrefUtils.prefs.getString("branch")
    };
if(store.CartItemList.where((element) => element.varId.toString() ==itembody.id.toString()).length>0) {
  update((done){
    // setState(() {
    //   _isAddToCart = !done;
    // });
    onload(false);
  },
      price: itembody.price.toString(),
      var_id: itembody.id.toString(),
      quantity: "1");
} else
    _cart.addtoCart(body).then((value) {
print("datamodle"+value["data"][0].toString());
      if(value["status"])
      SetCartItem(CartTask.add,data: CartItem.fromJson(value["data"][0]),onloade: (value){ onload(value);});
onload(false);
    });

  }
}
final cartcontroller = CartController();
class SetCartItem extends VxMutation<GroceStore>{
  CartRepo _cart = CartRepo();
  CartTask type;
  String varid;
  String quantity;
  Function(bool) onloade;
  CartItem data;
  SetCartItem(this.type, {this.quantity, this.varid,this. onloade,this.data});
  @override
  perform() async{
    status = VxStatus.loading;
    // TODO: implement perform
    switch(type){
      case CartTask.add:
        store.CartItemList.add(data);
        onloade(false);
        // TODO: Handle this case.
        break;
      case CartTask.update:
        if(int.parse(quantity)>0)
        store.CartItemList.where((element) => element.varId == varid ).first.quantity = quantity;
        else
          store.CartItemList.removeAt(store.CartItemList.indexWhere((element) => element.varId == varid));
        onloade(false);
        // TODO: Handle this case.
        break;
      case CartTask.fetch:
        store.CartItemList = await _cart.getCart((value){
          onloade(value);
        });
        // TODO: Handle this case.
        break;
    }
  }
}