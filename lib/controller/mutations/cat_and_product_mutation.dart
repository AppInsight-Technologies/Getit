import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/productandCategory/category_or_product.dart';
import 'package:velocity_x/velocity_x.dart';
enum Productof{
  category,productlist,singleProduct,subcategory,nestedcategory
}
class ProductController {
  ProductRepo _product = ProductRepo();
  final store = VxState.store as GroceStore;
  getCategory()async{
    ProductMutation(Productof.category,await _product.getCategory());
  }
  geSubtCategory(catid)async{
    _product.getSubcategory(catid, (value) {
      print("getting sub category");
      ProductMutation(Productof.subcategory,value,catid: catid);
      // value.forEach((element) {
      //   getNestedCategory(catid,element.id);
      // });
    });
  }
  getNestedCategory(parentid,catid,Function(bool) isexist)async{

    await _product.getSubcategory(catid, (value)
    {
      isexist(value.isEmpty);
      print("getting nested category pid $parentid cid $catid ${value.length}");
      ProductMutation(Productof.nestedcategory,value,parentid: parentid,catid: catid);
    });
  }
  getCategoryprodutlist(categoryId,initial,type,Function(bool) isendofproduct,
      {isexpress =false})async{
    print("catid: $categoryId");
    print("start: $initial");
    print("stype: $type");
    if(initial == "0") store.productlist.clear();
    await _product.getCartProductLists(categoryId,start: initial,type:type).then((value) {
      if(value!=null) {
        store.productlist.clear();
        isendofproduct(false);
        ProductMutation(Productof.productlist, isexpress?value.where((element) => element.eligibleForExpress == isexpress).toList():value);
      } else {
        isendofproduct(true);
      }
    });
  }
  getcategoryitemlist(categoryId)async{
    await _product.getcategoryitemlist(categoryId).then((value) {
      store.productlist.clear();
      ProductMutation(Productof.productlist,value);
    });
  }
  ///fetching filter product list..
  getfilterproduct(int minprice, int maxprice,String subcatId,Function(bool) isendofproduct,
      {isexpress =false}){
    store.productlist.clear();
    _product.getFilterProductLists(store.filterData,minprice,maxprice,subcatId).then((value) {
      if(value!=null) {
        isendofproduct(false);
        ProductMutation(Productof.productlist, isexpress?value.where((element) => element.eligibleForExpress == isexpress).toList():value);
      } else {
        isendofproduct(true);
      }
    });
  }

  ///fetching sort product list...
  getSortproduct(int sort, String subcatId, Function(bool) isendofproduct,
      {isexpress =false}){
    store.productlist.clear();
    _product.getSortProductLists(sort, subcatId).then((value) {
      if(value!=null) {
        isendofproduct(false);
        ProductMutation(Productof.productlist, isexpress?value.where((element) => element.eligibleForExpress == isexpress).toList():value);
      } else {
        isendofproduct(true);
      }
    });
  }
  getbrandprodutlist(categoryId,int initial,Function(bool) isendofproduct)async{
    if(initial.toString() == "0")
      store.productlist.clear();
    await _product.getBrandProductLists(categoryId,start: initial).then((value){
      if(value!=null) {
        store.productlist.clear();
        isendofproduct(false);
        ProductMutation(Productof.productlist, value);
      } else {
        isendofproduct(true);
      }
    });
  }
  getprodut(productid,initial)async{
    store.singelproduct = null;
    ProductMutation(Productof.singleProduct,await _product.getProduct(productid));
  }

}
class ProductMutation  extends VxMutation<GroceStore> {
  Productof productof;
  List<dynamic> list;
  String catid;
  String parentid;

  ProductMutation(this. productof,this. list,{this.catid,this.parentid});

  @override
  perform() async{
    // TODO: implement perform
    switch(productof){

      case Productof.category:
        store.homescreen.data.allCategoryDetails = list;
        // TODO: Handle this case.
        break;
      case Productof.productlist:
        final productlist = store.productlist;
        productlist.addAll(list as List<ItemData>);
        store.productlist = productlist;
        // TODO: Handle this case.
        break;
      case Productof.singleProduct:
        store.singelproduct = list[0];
        // TODO: Handle this case.
        break;

      case Productof.subcategory:
      // List<CategoryData> catdata =[];
      // store.homescreen.data.allCategoryDetails.forEach((element) {
      //   print("ele : ${ element.id }== $catid}");
      //   if(element.id == catid) {
      //         element.subCategory = list;
      //         catdata.add(element);
      //       }
      //     });
        store.homescreen.data.allCategoryDetails.where((element) {
          // print("subcat ${element.id} == $catid");
          return element.id == catid;
        }).first.subCategory = list;
        // TODO: Handle this case.
        break;
      case Productof.nestedcategory:
      // List<CategoryData> subcatdata =[];
      // store.homescreen.data.allCategoryDetails.where((element) => element.id==parentid).first.subCategory.forEach((element) {
      //   print("ele : sub ${ element.id }== $catid}");
      //   if(element.id == catid){
      //     element.subCategory = list;
      //     subcatdata.add(element);
      //   }
      // });
        print("nested: ${list.length}");
        store.homescreen.data.allCategoryDetails.where((element) {print("parentid ${element.id} == $parentid");return element.id == parentid;}).first.
        subCategory.where((element) {print("chiledid ${element.id} == $catid");return element.id == catid;}).length>0?
        store.homescreen.data.allCategoryDetails.where((element) => element.id==parentid).first.subCategory.where((element) => element.id == catid).first.subCategory = list:[];
        // TODO: Handle this case.
        break;
    }
  }
}