import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/filtermutations.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../models/newmodle/filterModle.dart';
import '../../repository/filterdata/filter_repo.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../screens/shoppinglist_screen.dart';
import '../../screens/wishlist_screen.dart';
import '../../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/category_modle.dart';
import '../widgets/components/sellingitem_component.dart';
import '../widgets/simmers/ItemWeb_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../screens/cart_screen.dart';
import '../screens/searchitem_screen.dart';
import '../widgets/selling_items.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../widgets/expansion_drawer.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';


class ItemsScreen extends StatefulWidget {
  static const routeName = '/items-screen';
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int startItem = 0;
  bool isLoading = true;
  var load = true;
  bool _initLoad = true;
  // var itemslistData;
  int previndex = -1;
  var subcategoryData;
  ItemScrollController _scrollController = ItemScrollController();
  // ItemScrollController _scrollControllerCategory;
  String subCategoryId = "";
  int subcatType = 0;
  bool _isOnScroll = false;
  String maincategory = "";
  String subcatTitle="";
  // bool _isMaincategoryset = false;
  bool endOfProduct = false;
  bool _checkmembership = false;
  var parentcatid;
  var subcatidinitial;
  int indexvalue = 0;
  String indvalue;
  ScrollController _controller;
  MediaQueryData queryData;
  double wid;
  double maxwid;
  String subcatid;
  String catId;
  bool iphonex = false;
  int _groupValue = 1;
  ProductController productController = ProductController();
  Futurecontroller futurecontroller =Futurecontroller();
  List<CategoryData> nestedCategory=[];
  var subcatId;

  //filter var
  //bool visibleProduct =true;
  bool visibleColor =true;
  bool visibleSize =false;
  bool visibleFit =false;
  bool visiblePrices =false;

  List<bool> productvalue;
  List<bool> colorvalue;
  List<bool> sizevalue;
  List<bool> fitvalue;

  Future<List<ColorsFilter>> futurecolor;
  Future<List<SizeFilter>> futuresize;
  Future<List<FitFilter>> futurefit;
  FilterRepo _filter = FilterRepo();

  List<CategoryData> subcatData=[];

  RangeValues _currentRangeValues = const RangeValues(100, 500);

  void Function(VoidCallback fn) expansionState;

  /// initial == 0 if fetch is initial
  _displayitem(String catid, int index, int type, String initial) {
    print("cat click: $catid");
    setState(() {
      isLoading = true;
      subcatType = type;
    });
    productController.getCategoryprodutlist(catid, initial,type,(isendofproduct){
      setState(() {
        isLoading = false;
        indvalue =  index.toString();
        endOfProduct = false;
      });
      // _scrollController.jumpTo(
      //   index: index
      //   /*duration: Duration(seconds: 1)*/
      // );
    },isexpress: (_groupValue!=1));
    // productController.geSubtCategory(parentcatid);
    // productController.getNestedCategory(parentcatid, subCategoryId);
    // final routeArgs =
    // ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    //  subcatId = catid;
    // // final catId = routeArgs['catId'];
    // subcatidinitial=routeArgs['subcatId'];
    // parentcatid=routeArgs['catId'];
    // setState(() {
    //
    //   endOfProduct = false;
    //   load = true;
    //   startItem = 0;
    //   int _nestedIndex = 0;
    //   _dialogforProcessing();
    //   Provider.of<CategoriesItemsList>(context, listen: false).fetchNestedCategory(catid, "subitemScreen").then((value) {
    //     setState(() {
    //       //_initLoad = false;
    //
    //       for (int i = 0; i < subNestedcategoryData.length; i++) {
    //         if (subNestedcategoryData[i].id == subcatId.toString()) {
    //           _nestedIndex = i;
    //         }
    //       }
    //
    //       //..new subcategorynesteditems ........
    //       for (int i = 0; i < subNestedcategoryData.length; i++) {
    //         if (i != _nestedIndex) {
    //           subNestedcategoryData[i].textcolor = ColorCodes.blackColor;
    //           subNestedcategoryData[i].fontweight = FontWeight.normal;
    //         } else {
    //           subNestedcategoryData[i].textcolor = ColorCodes.indigo;
    //           subNestedcategoryData[i].fontweight = FontWeight.bold;
    //
    //         }
    //       }
    //
    //
    //     });
    //   });
    //   ////neww.............
    //   for (int i = 0; i < subNestedcategoryData.length; i++) {
    //     if (index != i) {
    //       subNestedcategoryData[i].textcolor = ColorCodes.blackColor;
    //       //subcategoryData.itemNested[i].fontweight = FontWeight.normal;
    //
    //     } else {
    //       subNestedcategoryData[i].textcolor = ColorCodes.indigo;
    //       //subcategoryData.itemNested[i].fontweight = FontWeight.bold;
    //
    //       //subNestedcategoryData[i].fontweight = FontWeight.w900;
    //     }
    //   }
    //   int Length = (_isAll && subcategoryData.itemNested.length <= 1) ? subcategoryData.length : subcategoryData.itemNested.length;
    //   var assign = (_isAll && subcategoryData.itemNested.length <= 1) ? subcategoryData : subcategoryData.itemNested;
    //   debugPrint("Index . .. . . . ." + index.toString());
    //   for (int i = 0; i < Length; i++) {
    //     if (index != i) {
    //       assign[i].boxbackcolor = Colors.transparent;
    //       assign[i].boxsidecolor = Colors.black54;
    //       assign[i].textcolor = Colors.black54;
    //       assign[i].fontweight = FontWeight.normal;
    //     } else {
    //       if (routeArgs['prev'] != "category_item") {
    //         if (!_isMaincategoryset)
    //           maincategory = assign[i].title;
    //       }
    //       assign[i].boxbackcolor = Colors.transparent;
    //       assign[i].boxsidecolor = ColorCodes.greenColor;
    //       assign[i].textcolor = ColorCodes.greenColor;
    //       assign[i].fontweight = FontWeight.bold;
    //
    //     }
    //   }
    //
    //   setState(() {
    //     subcatid = assign[index].catid;
    //     subCategoryId = assign[index].catid;
    //     subcatType = assign[index].type.toString();
    //   });
    //   // Provider.of<ItemsList>(context, listen: false)
    //   //     .fetchItems(subcatid, subcatType, startItem, "initialy")
    //   //     .then((_) {
    //   //   setState(() {
    //   //     if(_groupValue == 1){
    //   //       itemslistData = Provider.of<ItemsList>(context, listen: false);
    //   //       startItem = itemslistData.items.length;
    //   //       setState(() {
    //   //         load = false;
    //   //         if (itemslistData.items.length <= 0) {
    //   //           _checkitem = false;
    //   //         } else {
    //   //           _checkitem = true;
    //   //         }
    //   //       });
    //   //       Navigator.of(context).pop();
    //   //     }else{
    //   //       itemslistData = Provider.of<ItemsList>(context, listen: false).findByIdExpress();
    //   //       startItem = itemslistData.length;
    //   //       setState(() {
    //   //         load = false;
    //   //         if (itemslistData.length <= 0) {
    //   //           _checkitem = false;
    //   //         } else {
    //   //           _checkitem = true;
    //   //         }
    //   //       });
    //   //       Navigator.of(context).pop();
    //   //     }
    //   //   });
    //   // });
    // });
  }

  @override
  void initState() {
    print("item screen");
    // _scrollControllerCategory = ItemScrollController();

    Future.delayed(Duration.zero, () async {

      setState(() {
        futurecolor = _filter.getFilterColor();
        futuresize = _filter.getFilterSize();
        futurefit = _filter.getFilterFit();
      });
   //   productvalue = List<bool>.filled(10, false);
      // colorvalue = List<bool>.filled(10, false);
      //  sizevalue = List<bool>.filled(10, false);
      //fitvalue = List<bool>.filled(10, false);

      setState(() {
        if (PrefUtils.prefs.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      print("fbvfbv" + routeArgs['catId'].toString()  + routeArgs['subcatId']);
      subcatId = routeArgs['subcatId'];
      catId = routeArgs['catId'].toString();
      subcatidinitial=routeArgs['subcatId'];
      subCategoryId=routeArgs['subcatId'];
      parentcatid=routeArgs['catId'];
      indexvalue = int.parse(routeArgs['indexvalue']??"0");
      indvalue = (routeArgs['indexvalue']??"0");
      Future.delayed(Duration.zero, () async {
        _scrollController.jumpTo(
          index: int.parse(indvalue),
          /*duration: Duration(seconds: 1)*/
        );
      });
      if (routeArgs['prev'] == "category_item") {
        maincategory = routeArgs['maincategory'];


      }
      print("parenytcat: $parentcatid and subcat $subCategoryId");
      _initLoad =false;
      if((VxState.store as GroceStore).homescreen.data.allCategoryDetails.where((element) => element.id==parentcatid).length<0);
      productController.geSubtCategory(parentcatid);
        productController.getNestedCategory(parentcatid, subCategoryId,(isexist){
          if(isexist) indvalue = "1";
          _displayitem(subCategoryId, int.parse(indvalue),0,"0");
        });

      productController.getCategoryprodutlist(subCategoryId, "0",subcatType,(isendofproduct){
        setState(() {
          isLoading =false;
        });
        Future.delayed(Duration.zero, () async {
          _scrollController.jumpTo(
            index: indexvalue,
            /*duration: Duration(seconds: 1)*/
          );
        });
      },isexpress: _groupValue==1?false:true);

      futurecontroller.setAll();
      /* Provider.of<CategoriesItemsList>(context, listen: false).fetchNestedCategory(subcatId.toString(), "itemScreen").then((_) {
        setState(() {
          subcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);
          debugPrint("Length . . . .. . . . . . ." + subcategoryData.itemNested.length.toString());

          if (routeArgs['prev'] != "category_item") {
            debugPrint("subcategoryData . . . ." + (subcategoryData.itemNested.length - 1).toString());
            final parentId = subcategoryData.itemNested[subcategoryData.itemNested.length - 1].parentId;
            final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
            for (int i = 0; i < categoriesData.items.length; i++) {
              if (categoriesData.items[i].catid == parentId) {
                maincategory = categoriesData.items[i].title;
                _isMaincategoryset = true;
                _isNested = true;
              } else {
                _isMaincategoryset = false;
              }
            }
          }

          int index = 0;

          int count = 0;

          for (int i = 0; i < subcategoryData.itemNested.length; i++) {
            debugPrint("Comparing .. . . .." + subcategoryData.itemNested[i].catid + "............" + subcatId.toString());
            if (subcategoryData.itemNested[i].catid == subcatId.toString()) {
              count++;
              index = i;
              subcatid = subcategoryData.itemNested[index].catid;
              subCategoryId = subcategoryData.itemNested[index].catid;
              subcatType = subcategoryData.itemNested[index].type;

            } else {
              //subcatid = subcategoryData.itemNested[int.parse("0")].catid;
            }
            if(subcategoryData.itemNested[i].title == "all" || subcategoryData.itemNested[i].title == "All") {
              _isAll = true;
            }
          }
          debugPrint("Count . . .. . . . " + count.toString() + "  " +subcategoryData.itemNested.length.toString());
          debugPrint("subcatid: $subcatid : $subCategoryId : $subcatType " );
          if (count <= 1) {
            // debugPrint("hahahahah . . . .. " + count.toString() +"  " + _isAll.toString() + "   ...." + subNestedcategoryData.length.toString());
            if(_isAll && subcategoryData.itemNested.length <= 1){
              for (int i = 0; i < subNestedcategoryData.length; i++) {
                debugPrint("Comparing .. . . ..111" + subNestedcategoryData[i].catid + "............" + subcatId.toString());
                if (subNestedcategoryData[i].catid == subcatId.toString()) {
                  index = i;
                  subcatid = subNestedcategoryData[i].catid;
                  subCategoryId = subNestedcategoryData[i].catid;
                  subcatType = "0";

                } else {
                  //subcatid = subcategoryData.itemNested[int.parse("0")].catid;
                }
              }
            } else if (routeArgs['prev'] == "category_item") {
              maincategory = routeArgs['catTitle'];
              _isNested = true;
            }
          }
          /*//..new subcategorynesteditems ........
          for (int i = 0; i < subNestedcategoryData.length; i++) {
            if (i != index) {
              subNestedcategoryData[i].textcolor = Colors.black;
            } else {
              subNestedcategoryData[i].textcolor = Colors.indigo;
            }
          }*/
          for (int i = 0; i < subcategoryData.itemNested.length; i++) {
            if (i != index) {
              subcategoryData.itemNested[i].boxbackcolor = Colors.transparent;
              subcategoryData.itemNested[i].boxsidecolor = Colors.black54;
              subcategoryData.itemNested[i].textcolor = Colors.black54;
              subcategoryData.itemNested[i].fontweight = FontWeight.normal;
            } else {
              if (routeArgs['prev'] != "category_item") {
                if (!_isMaincategoryset)
                  maincategory = subcategoryData.itemNested[i].title;
                _isNested = true;
              }
              subcategoryData.itemNested[i].boxbackcolor = Colors.transparent;
              subcategoryData.itemNested[i].boxsidecolor = ColorCodes.greenColor;
              subcategoryData.itemNested[i].textcolor = ColorCodes.greenColor;
              subcategoryData.itemNested[i].fontweight = FontWeight.bold;
            }
          }

          _initLoad = false;
         // _dialogforProcessing();
         // productController.getCategoryprodutlist(subcatid, "initialy", () => null)
   /*       Provider.of<ItemsList>(context, listen: false).fetchItems(subcatid, subcatType, startItem, "initialy").then((_) {
            if(_groupValue == 1){
              itemslistData = Provider.of<ItemsList>(context, listen: false);
              startItem = itemslistData.items.length;
              setState(() {
                load = false;
                Navigator.of(context).pop();
                if (itemslistData.items.length <= 0) {
                  _checkitem = false;
                } else {
                  _checkitem = true;
                }
              });
            }else{
              print("_groupValue: $_groupValue");
              itemslistData = Provider.of<ItemsList>(context, listen: false).findByIdExpress();
              startItem = itemslistData.length;
              setState(() {
                load = false;
                if (itemslistData.length <= 0) {
                  _checkitem = false;
                } else {
                  _checkitem = true;
                }
              });
              Navigator.of(context).pop();
            }
            Future.delayed(Duration.zero, () async {
              _scrollControllerCategory.jumpTo(
                index: _nestedIndex - 1,
                *//*duration: Duration(seconds: 1)*//*
              );
            });
            Future.delayed(Duration.zero, () async {
              _scrollController.jumpTo(
                index: index,
                *//*duration: Duration(seconds: 1)*//*
              );
            });
          });*/
        });
      });*/
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget itemsWidget() {


    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow =  (kIsWeb && !ResponsiveLayout.isSmallScreen(context)) ? 2 : 2;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio =   (kIsWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 480:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 410 :
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 282.2;
    // do {
    //   setState(() {
    //     (_groupValue == 1) ?
    //     startItem = itemslistData.items.length ?? 0 :
    //     startItem = itemslistData.length ?? 0
    //     ;
    //   });
    //   Provider.of<ItemsList>(context, listen: false)
    //       .fetchItems(
    //       subCategoryId,
    //       subcatType,
    //       startItem,
    //       "scrolling")
    //       .then((_) {
    //     setState(() {
    //       // startItem = itemslistData.items.length;
    //       debugPrint("startItem........"+subCategoryId.toString()+"  "+startItem.toString());
    //      // itemslistData = Provider.of<ItemsList>(context, listen: false);
    //       if (_groupValue == 1){
    //         itemslistData = Provider.of<ItemsList>(context, listen: false);
    //       }else{
    //         itemslistData = Provider.of<ItemsList>(context, listen: false).findByIdExpress();
    //       }
    //     });
    //     if (PrefUtils.prefs
    //         .getBool("endOfProduct")) {
    //       setState(() {
    //         startItem = 0;
    //         _isOnScroll = false;
    //         endOfProduct = true;
    //       });
    //     } else {
    //       setState(() {
    //         _isOnScroll = false;
    //         endOfProduct = false;
    //       });
    //
    //     }
    //   });
    // }while(PrefUtils.prefs.getBool("endOfProduct"));

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Divider(),
        // SizedBox(height: 15,),

        VxBuilder(
          mutations: {ProductMutation},
          builder: (ctx, store,VxStatus state){

            //load = false;

            final productlist = store.productlist;
            return    (isLoading) ?
            Center(
              child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                  ? ItemListShimmerWeb()
                  : ItemListShimmer(), //CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),

            ) :
            /* _checkitem*/(productlist.length>0)
                ? ResponsiveLayout.isExtraLargeScreen(context) ?
            Column(
              children: <Widget>[
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GridView.builder(
                      shrinkWrap: true,
                      // controller: new ScrollController(keepScrollOffset:true,initialScrollOffset: 10),
                      itemCount: productlist.length,/*(_groupValue == 1)
                           ? *//*itemslistData.items.length*//*productlist.length
                           : itemslistData.length,*/
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widgetsInRow,
                        crossAxisSpacing: 3,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder:
                          (BuildContext context,
                          int index) {
                        final routeArgs =
                        ModalRoute
                            .of(context)
                            .settings
                            .arguments as Map<String, dynamic>;
                        print("data to singel product1: ${{
                          'maincategory': routeArgs['maincategory'],
                          'catId': routeArgs['catId'],
                          'catTitle': routeArgs['catTitle'],
                          'subcatId': subcatId,
                          'indexvalue': routeArgs['indexvalue'],
                          'prev': routeArgs['prev'],
                        }.toString()}");
                        return /*(_groupValue == 1) ?*/
                          SellingItems(
                            "item_screen",
                            productlist[index].id,//itemslistData.items[index].id,
                            productlist[index].itemName,//title,
                            productlist[index].itemFeaturedImage,//imageUrl,
                            productlist[index].brand,
                            "",
                            productlist[index].vegType,//veg_type,
                            productlist[index].type,
                            productlist[index].eligibleForExpress,
                            productlist[index].delivery,
                            productlist[index].duration,
                            productlist[index].deliveryDuration.durationType,
                            productlist[index].deliveryDuration.note,
                            productlist[index].eligibleForSubscription,
                            productlist[index].paymentMode,
                            productlist[index].subscriptionSlot[index].cronTime,
                            productlist[index].subscriptionSlot[index].name,

                            returnparm: {
                              'maincategory': routeArgs['maincategory'],
                              'catId': parentcatid,
                              'catTitle': routeArgs['catTitle'],
                              'subcatId': subcatId,
                              'indexvalue': routeArgs['indexvalue'],
                              'prev': routeArgs['prev'],
                            },
                          ) ;
                        //    SellingItemsv2(
                        //                             "item_screen",
                        //                            "",//itemslistData.items[index].id,
                        //                             productlist[index],
                        //                             returnparm: {
                        //                               'maincategory': routeArgs['maincategory'],
                        //                               'catId': parentcatid,
                        //                               'catTitle': routeArgs['catTitle'],
                        //                               'subcatId': subcatId,
                        //                               'indexvalue': routeArgs['indexvalue'],
                        //                               'prev': routeArgs['prev'],
                        //                             },
                        //                           ) ;
                        /*      :
                         SellingItems(
                           "item_screen",
                           itemslistData[index].id,
                           itemslistData[index].title,
                           itemslistData[index].imageUrl,
                           itemslistData[index].brand,
                           "",
                           itemslistData[index].veg_type,
                           itemslistData[index].type,
                           itemslistData[index].eligible_for_express,
                           itemslistData[index].delivery,
                           itemslistData[index].duration,
                           itemslistData[index].durationType,
                           itemslistData[index].note,
                           itemslistData[index].subscribe,
                           itemslistData[index].paymentmode,
                           itemslistData[index].cronTime,
                           itemslistData[index].name,

                           returnparm: {
                             'maincategory': routeArgs['maincategory'],
                             'catId': routeArgs['catId'],
                             'catTitle': routeArgs['catTitle'],
                             'subcatId': subcatId,
                             'indexvalue': routeArgs['indexvalue'],
                             'prev': routeArgs['prev'],
                           },
                         );*/
                      }),
                ),
                if (endOfProduct)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    margin: EdgeInsets.only(top: 10.0, bottom: 70),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Text(
                      S.of(context).thats_all_folk,
                      // "That's all folks!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            )
                : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child:
                    GridView.builder(
                        shrinkWrap: true,
                        controller: new ScrollController(
                            keepScrollOffset: false),
                        itemCount: /*(_groupValue == 1) ? itemslistData.items
                               .length : itemslistData.length*/productlist.length,
                        gridDelegate:
                        new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widgetsInRow,
                          crossAxisSpacing: 3,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: 3,
                        ),
                        itemBuilder:
                            (BuildContext context,
                            int index) {
                          final routeArgs =
                          ModalRoute
                              .of(context)
                              .settings
                              .arguments as Map<String, dynamic>;
                          print("data to singel product3: ${{
                            'maincategory': maincategory,
                            'catId': subcatId,
                            'catTitle': subcatTitle,
                            'subcatId': subcatId,
                            'indexvalue': index.toString(),
                            'prev': routeArgs['prev'],
                          }.toString()}");
                          /* return (_groupValue == 1) ?*/ return SellingItemsv2(
                            "item_screen",
                            "",
                            productlist[index],
                            /*   productlist[index].id,//itemslistData.items[index].id,
                               productlist[index].itemName,//title,
                               productlist[index].itemFeaturedImage,//imageUrl,
                               productlist[index].brand,
                               "",
                               productlist[index].vegType,//veg_type,
                               productlist[index].type,
                               productlist[index].eligibleForExpress,
                               productlist[index].delivery,
                               productlist[index].duration,
                               productlist[index].deliveryDuration.durationType,
                               productlist[index].deliveryDuration.note,
                               productlist[index].eligibleForSubscription,
                               productlist[index].paymentMode,
                               (productlist[index].subscriptionSlot.length>0)?productlist[index].subscriptionSlot[0].cronTime:"",
                               (productlist[index].subscriptionSlot.length>0)?productlist[index].subscriptionSlot[0].name:"",*/

                            returnparm: {
                              'maincategory': maincategory,
                              'catId': subcatId,
                              'catTitle': subcatTitle,
                              'subcatId': subcatId,
                              'indexvalue': index.toString(),
                              'prev': routeArgs['prev'],
                            },
                          ) ;
                          /*    : SellingItems(
                               "item_screen",
                               itemslistData[index].id,
                               itemslistData[index].title,
                               itemslistData[index].imageUrl,
                               itemslistData[index].brand,
                               "",
                               itemslistData[index].veg_type,
                               itemslistData[index].type,
                               itemslistData[index].eligible_for_express,
                               itemslistData[index].delivery,
                               itemslistData[index].duration,
                               itemslistData[index].durationType,
                               itemslistData[index].note,
                               itemslistData[index].subscribe,
                               itemslistData[index].paymentmode,
                               itemslistData[index].cronTime,
                               itemslistData[index].name,

                               returnparm: {
                                 'maincategory': routeArgs['maincategory'],
                                 'catId': routeArgs['catId'],
                                 'catTitle': routeArgs['catTitle'],
                                 'subcatId': subcatId,
                                 'indexvalue': routeArgs['indexvalue'],
                                 'prev': routeArgs['prev'],
                               },
                             );*/
                        }),

                  ),
                  if (endOfProduct)
                    Container(
                      decoration: BoxDecoration(
                        color: ColorCodes.lightGreyWebColor,
                      ),
                      margin: EdgeInsets.only(top: 10.0,bottom: 80),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                      child: Text(
                        S
                            .of(context)
                            .thats_all_folk,
                        // "That's all folks!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorCodes.darkGrey, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                ],
              ),
            )
                : Container(
              /* height: MediaQuery
                 .of(context)
                 .size
                 .height,*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 150,),
                    Align(
                      // heightFactor: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: new Image.asset(
                        Images.noItemImg,
                        fit: BoxFit.fill,
                        height: 250.0,
                        width: 200.0,
//                    fit: BoxFit.cover
                      ),
                    ),
                  ],
                )

            );
          },
        ),

        if(!kIsWeb) Container(
          height: _isOnScroll ? 50 : 0,
          child: Center(
            child: new CircularProgressIndicator(),
          ),
        ),
        //if(kIsWeb && ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
      ],
    );
  }

  // _displayCategory(String subcatId) {
  //   Provider.of<CategoriesItemsList>(context, listen: false).fetchNestedCategory(subcatId, "itemScreen").then((_) {
  //     setState(() {
  //       subcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);
  //       int index = 0;
  //       String subcatid;
  //       int count = 0;
  //       for (int i = 0; i < subcategoryData.itemNested.length; i++) {
  //         if (subcategoryData.itemNested[i].catid == subcatId) {
  //           count++;
  //           index = i;
  //           subcatid = subcategoryData.itemNested[index].catid;
  //           subCategoryId = subcategoryData.itemNested[index].catid;
  //           subcatType = subcategoryData.itemNested[index].type;
  //         } else {
  //         }
  //       }
  //       for (int i = 0; i < subcategoryData.itemNested.length; i++) {
  //         if (i != index) {
  //           subcategoryData.itemNested[i].boxbackcolor = Colors.transparent;
  //           subcategoryData.itemNested[i].boxsidecolor = Colors.black54;
  //           subcategoryData.itemNested[i].textcolor = Colors.black54;
  //         } else {
  //           subcategoryData.itemNested[i].boxbackcolor = Colors.transparent;
  //           subcategoryData.itemNested[i].boxsidecolor = ColorCodes.greenColor;
  //           subcategoryData.itemNested[i].textcolor = ColorCodes.greenColor;
  //         }
  //       }
  //       _initLoad = false;
  //       startItem = 0;
  //       // itembloc.fetchitems(subcatid, subcatType, startItem, "initialy");
  //       Future.delayed(Duration.zero, () async {
  //         _scrollController.jumpTo(
  //           index: index,
  //           /*duration: Duration(seconds: 1)*/
  //         );
  //       });
  //     });
  //   });
  // }

  Widget _myRadioButton({int value, Function onChanged}) {
    //prefs.setString('fixtime', timeslotsData[_groupValue].time);
    return Radio(
      activeColor: Theme.of(context).primaryColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
    );
  }

  _dialogsetExpress() async{
    Navigator.of(context).pop(true);
    setState(() {
      load = false;
    });

  }

  ShowpopupForRadioButton(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Container(
                    child: Text(S.current.select_option, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                    dense: true,
                    leading:  Container(

                      child: _myRadioButton(
                        value: 1,
                        onChanged: (newValue) {
                          setState(() {
                            _groupValue = newValue;
                            setState(() {
                              load = true;

                              _dialogsetExpress();
                            });
                          });
                        },
                      ),
                    ),
                    contentPadding: EdgeInsets.all(0.0),
                    title:  Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 50 /100,
                          child: Text(
                              S.current.all_product,
                              style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  fontSize: 16, fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Container(
                      child: _myRadioButton(
                        value: 2,
                        onChanged: (newValue) {
                          setState(() {
                            _groupValue = newValue;
                            setState(() {
                              load = true;

                              _dialogsetExpress();

                            });
                          });
                        },
                      ),
                    ),
                    title:
                    Row(
                      children: [
                        Container(

                          child: Text(
                              S.current.express_delivery,
                              style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  fontSize: 16, fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Text(S.current.cancel, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        });

      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    _buildBottomNavigationBar() {
      return BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
        title: S.current.view_cart,
        total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            :
        (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          setState(() {
            Navigator.of(context)
                .pushNamed(CartScreen.routeName, arguments: {
              "after_login": ""
            });
          });
        },
      );

      /*if(Calculations.itemCount > 0) {
        return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height:50,
                width:MediaQuery.of(context).size.width * 35/100,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    _checkmembership
                        ?
                    Text(IConstants.currencyFormat + (Calculations.totalMember).toString(), style: TextStyle(color: Colors.black),)
                        :
                    Text(IConstants.currencyFormat + (Calculations.total).toString(), style: TextStyle(color: Colors.black),),
                    Text(Calculations.itemCount.toString() + " item", style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 9),)
                  ],
                ),),
              GestureDetector(
                  onTap: () =>
                  {
                    setState(() {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    })
                  },
                  child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
                      child:Column(children:[
                        SizedBox(height: 17,),
                        Text('VIEW CART', style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ]
                      )
                  )
              ),
            ],
          ),
        );
      }*/
    }


    void showsort(){
      int Sort=0;
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft: Radius.circular(20.0)),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (context, setStates) {
                  return Container(
                    height: MediaQuery.of(context).size.height*0.35,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  Images.appsortImg,
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 5,),
                                Text('Sort',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                                child: Image.asset(Images.cancelImg,height: 20,width: 20,)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap:(){
                            setStates((){
                              Sort=1;
                            });
                            ProductController().getSortproduct(1, subcatId, (value) {

                            });
                            //  ProductRepo().getFilterProductLists((VxState.store as GroceStore).filterData,_currentRangeValues.start.round(),_currentRangeValues.end.round());
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price - High to Low',style: TextStyle(color:Colors.black54,fontWeight: FontWeight.bold,fontSize: 16),),
                                Sort==1? Container(
                                  width: 18.0,
                                  height: 18.0,
                                  decoration: BoxDecoration(
                                    color: ColorCodes.discountoff,
                                    border: Border.all(
                                      color: ColorCodes.discountoff,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: ColorCodes.discountoff,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: ColorCodes.whiteColor,
                                        size: 12.0),
                                  ),
                                ):
                                Icon(
                                  Icons.radio_button_off_outlined,
                                  color: Colors.black54,size: 20,),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 2,color: Colors.grey[200],),
                        GestureDetector(
                          onTap:(){
                            setStates((){
                              Sort=2;
                            });
                            ProductController().getSortproduct(2, subcatId, (value) {

                            });
                            //  ProductRepo().getFilterProductLists((VxState.store as GroceStore).filterData,_currentRangeValues.start.round(),_currentRangeValues.end.round());
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price - Low to High',style: TextStyle(color:Colors.black54,fontWeight: FontWeight.bold,fontSize: 16),),
                                Sort==2? Container(
                                  width: 18.0,
                                  height: 18.0,
                                  decoration: BoxDecoration(
                                    color: ColorCodes.discountoff,
                                    border: Border.all(
                                      color: ColorCodes.discountoff,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: ColorCodes.discountoff,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: ColorCodes.whiteColor,
                                        size: 12.0),
                                  ),
                                ):
                                Icon(
                                  Icons.radio_button_off_outlined,
                                  color: Colors.black54,size: 20,),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 2,color: Colors.grey[200],),
                        GestureDetector(
                          onTap:(){
                            setStates((){
                              Sort=3;
                            });
                            ProductController().getSortproduct(3, subcatId, (value) {

                            });
                            //  ProductRepo().getFilterProductLists((VxState.store as GroceStore).filterData,_currentRangeValues.start.round(),_currentRangeValues.end.round());
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Newest',style: TextStyle(color:Colors.black54,fontWeight: FontWeight.bold,fontSize: 16),),
                                Sort==3? Container(
                                  width: 18.0,
                                  height: 18.0,
                                  decoration: BoxDecoration(
                                    color: ColorCodes.discountoff,
                                    border: Border.all(
                                      color: ColorCodes.discountoff,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: ColorCodes.discountoff,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: ColorCodes.whiteColor,
                                        size: 12.0),
                                  ),
                                ):
                                Icon(
                                  Icons.radio_button_off_outlined,
                                  color: Colors.black54,size: 20,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
      );
    }


    void showFilter(){

      //PRODUCTS LIST
      Widget productsList(BuildContext context,setState1){
        return SizedBox(
            width: MediaQuery.of(context).size.width*0.66,
            height: MediaQuery.of(context).size.height*0.56,
            child:  VxBuilder(
                mutations: {ProductMutation},
                builder: (ctx,store,VxStatus state){
                  if((store as GroceStore).homescreen.data.allCategoryDetails[0].subCategory!=null&&(store as GroceStore).homescreen.data.allCategoryDetails[0].subCategory.length>0)
                    subcatData = (store as GroceStore).homescreen.data.allCategoryDetails[0].subCategory.where((element) => element.categoryName.toLowerCase().trim() != "all").toList();
                  productvalue = List<bool>.filled(subcatData.length, false);
                  return (subcatData.length > 0)?ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(0.0),
                      itemCount: subcatData.length,
                      itemBuilder: (_, i) {
                        return StatefulBuilder(
                            builder: (context, setState2) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(subcatData[i].categoryName,
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      fontSize: 18),),
                                Checkbox(
                                  checkColor: ColorCodes.whiteColor,
                                  activeColor: ColorCodes.discountoff,
                                  value: productvalue[i],
                                  onChanged: (
                                      bool value) { // This is where we update the state when the checkbox is tapped
                                    setState2(() {
                                      productvalue[i] = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                      }):SizedBox.shrink();
                })
        );
      }

      //COLOR LIST
      Widget colorList(BuildContext context,setState1){

        return SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.66,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.46,
          child:  VxBuilder(
            mutations: {filterMutation},
              builder: (BuildContext context, store, VxStatus status) {
              final colorData = store.filterData.colorItems;
                if(colorData!=null) colorvalue = List<bool>.filled(colorData.length, false);
                if(colorData.length>0)
                  return  ListView.separated(
                      separatorBuilder: (context, index) =>  Container(
                        height: 2,
                        color: Colors.grey[200],
                        //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      ),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(0.0),
                      itemCount: colorData.length,
                      itemBuilder: (_, i) {
                        return StatefulBuilder(
                            builder: (context, setState2) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Color(int.parse(colorData[i].color)).withOpacity(0.7)),
                                        ),
                                        SizedBox(width: 12,),
                                        Text(colorData[i].colorName,
                                          style: TextStyle(
                                            color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),),
                                      ],
                                    ),
                                    Checkbox(
                                      checkColor: ColorCodes.whiteColor,
                                      activeColor: ColorCodes.discountoff,
                                      value: colorData[i].selected,
                                      onChanged: (
                                          bool value) { // This is where we update the state when the checkbox is tapped
                                        setState2(() {
                                          //colorData[i].toJson(selected: value);
                                          futurecontroller.setColor(colorData[i].id, value);
                                          debugPrint('value...' + value.toString());

                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                else
                  return SizedBox.shrink();
              }),
        );

      }

      //SIZE LIST
      Widget sizeList(BuildContext context,setState1){
        return SizedBox(
          width: MediaQuery.of(context).size.width*0.66,
          height: MediaQuery.of(context).size.height*0.46,
          child: VxBuilder(
              mutations: {filterMutation},
              builder: (BuildContext context, store, VxStatus status) {
                final sizeData = store.filterData.sizeItems;
                if(sizeData!=null) sizevalue = List<bool>.filled(sizeData.length, false);
                if(sizeData.length>0)
                  return ListView.separated(
                      separatorBuilder: (context, index) =>  Container(
                        height: 2,
                        color: Colors.grey[200],
                        //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      ),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(0.0),
                      itemCount: sizeData.length,
                      itemBuilder: (_, i) {
                        return StatefulBuilder(
                            builder: (context, setState2)
                            {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(sizeData[i].size, style: TextStyle(
                                      color: Colors.black54,
                                        fontWeight: FontWeight.bold, fontSize: 16),),
                                    Checkbox(
                                      checkColor: ColorCodes.whiteColor,
                                      activeColor: ColorCodes.discountoff,
                                      value: sizeData[i].selected,
                                      onChanged: (
                                          bool value) { // This is where we update the state when the checkbox is tapped
                                        setState2(() {
                                        //  sizevalue[i] = value;
                                          futurecontroller.setSize(sizeData[i].id, value);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                else
                  return SizedBox.shrink();
              }),
        );
      }

      //FIT LIST
      Widget fitList(BuildContext context,setState1){
        return SizedBox(
          width: MediaQuery.of(context).size.width*0.66,
          height: MediaQuery.of(context).size.height*0.46,
          child: VxBuilder(
              mutations: {filterMutation},
              builder: (BuildContext context, store, VxStatus status) {
                final fitData = store.filterData.fitItems;
                if(fitData!=null)fitvalue = List<bool>.filled(fitData.length, false);
                if(fitData.length>0)
                  return ListView.separated(
                      separatorBuilder: (context, index) =>  Container(
                        height: 2,
                        color: Colors.grey[200],
                        //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      ),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(0.0),
                      itemCount: fitData.length,
                      itemBuilder: (_, i) {
                        return StatefulBuilder(
                            builder: (context, setState2) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(fitData[i].fit, style: TextStyle(
                                      color: Colors.black54,
                                        fontWeight: FontWeight.bold, fontSize: 16),),
                                    Checkbox(
                                      checkColor: ColorCodes.whiteColor,
                                      activeColor: ColorCodes.discountoff,
                                      value: fitData[i].selected,
                                      onChanged: (
                                          bool value) { // This is where we update the state when the checkbox is tapped
                                        setState2(() {
                                          // fitvalue[i] = value;
                                          futurecontroller.setFit(fitData[i].id, value);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                else
                  return SizedBox.shrink();
              }),
        );
      }

      //PRICE SLIDER
      Widget priceSlider(BuildContext context,setState1){

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15,),
              Text(IConstants.currencyFormat+_currentRangeValues.start.round().toString()+"  -  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
            Text(IConstants.currencyFormat+_currentRangeValues.end.round().toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
            ],),
            Container(
              width: MediaQuery.of(context).size.width*0.66,
              child: RangeSlider(
                values: _currentRangeValues,
                activeColor: ColorCodes.discountoff,
                max: 10000,
                min: 100,
                //divisions: 5,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState1(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ),
            Container(
              height: 2,
              color: Colors.grey[200],
              //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            ),
          ],
        );
      }

      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft: Radius.circular(20.0)),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (context, setState1) {
                  return Container(
                    height: MediaQuery.of(context).size.height*0.61,
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15,right: 15,bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Images.filterImg,
                                    width: 17,
                                    height: 17,
                                  ),
                                  SizedBox(width: 5,),
                                  Text('Filter',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              GestureDetector(
                                onTap: (){

                                },
                                  child: Text('Clear All',style: TextStyle(decoration: TextDecoration.underline,fontSize: 15,fontWeight: FontWeight.bold,color: ColorCodes.discountoff),)),
                            ],
                          ),
                        ),
                        Container(
                          height: 5,
                          color: Colors.grey[200],
                          //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        ),
                       // SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.grey[100],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                            /*      GestureDetector(
                                    onTap:(){
                                      setState1((){
                                        visibleProduct =true;
                                        visibleColor =false;
                                        visibleSize =false;
                                        visibleFit =false;
                                        visiblePrices =false;
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 120,
                                      padding: EdgeInsets.all(20),
                                      color: visibleProduct?Colors.white:Colors.grey[300],
                                      child: Text('Products',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                    ),
                                  ),
                                  SizedBox(height: 3,),*/
                                  GestureDetector(
                                    onTap:(){
                                      setState1((){
                                        visibleColor =true;
                                       // visibleProduct =false;
                                        visibleSize =false;
                                        visibleFit =false;
                                        visiblePrices =false;
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 120,
                                      padding: EdgeInsets.all(20),
                                      color: visibleColor?Colors.white:Colors.grey[200],
                                      child: Text('Colors',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  GestureDetector(
                                    onTap:(){
                                      setState1((){
                                        visibleSize =true;
                                        visibleColor =false;
                                        //visibleProduct =false;
                                        visibleFit =false;
                                        visiblePrices =false;
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 120,
                                      padding: EdgeInsets.all(20),
                                      color: visibleSize?Colors.white:Colors.grey[200],
                                      child: Text('Size',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  GestureDetector(
                                    onTap:(){
                                      setState1((){
                                        visibleFit =true;
                                        visibleSize =false;
                                        visibleColor =false;
                                        //visibleProduct =false;
                                        visiblePrices =false;
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 120,
                                      padding: EdgeInsets.all(20),
                                      color: visibleFit?Colors.white:Colors.grey[200],
                                      child: Text('Fit',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  GestureDetector(
                                    onTap:(){
                                      setState1((){
                                        visiblePrices =true;
                                        visibleFit =false;
                                        visibleSize =false;
                                        visibleColor =false;
                                       // visibleProduct =false;
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 120,
                                      padding: EdgeInsets.all(20),
                                      color: visiblePrices?Colors.white:Colors.grey[200],
                                      child: Text('Prices',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                             /*     Visibility(
                                    visible: visibleProduct,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child:productsList(context, setState1),
                                      ),
                                    ),
                                  ),*/
                                  Visibility(
                                    visible: visibleColor,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child:colorList(context, setState1),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visibleSize,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child:sizeList(context, setState1),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visibleFit,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child:fitList(context, setState1),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visiblePrices,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child:priceSlider(context, setState1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                    child: Text('CLOSE',style: TextStyle(fontWeight: FontWeight.bold,fontSize:17),)),
                                VerticalDivider(width: 2,indent: 4,endIndent: 4,),
                                GestureDetector(
                                  onTap: (){
                                    ProductController().getfilterproduct(_currentRangeValues.start.round(), _currentRangeValues.end.round(), subcatId, (value) {

                                    });
                                  //  ProductRepo().getFilterProductLists((VxState.store as GroceStore).filterData,_currentRangeValues.start.round(),_currentRangeValues.end.round());
                                    Navigator.of(context).pop();
                                  },
                                    child: Text('APPLY',style: TextStyle(fontWeight: FontWeight.bold,fontSize:17,color: ColorCodes.discountoff),)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
      );
    }

    _bottomNavigationBar(){
      return Container(
       // margin: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: 53,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorCodes.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorCodes.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: (){
                    showsort();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        Images.appsortImg,
                        width: 19,
                        height: 19,
                      ),
                      SizedBox(width: 8,),
                      Text('SORT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  )),
              VerticalDivider(thickness: 1,),
              GestureDetector(
                  onTap: (){
                    showFilter();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        Images.filterImg,
                        width: 19,
                        height: 19,
                      ),
                      SizedBox(width: 8,),
                      Text('FILTER',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  )),
            ],
          ),
        ),
      );
    }
    Widget _appBarMobile() {
      return AppBar(
      toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        title: Text(maincategory,style: TextStyle(color:ColorCodes.menuColor, fontWeight: FontWeight.w800 ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // GestureDetector(
          //   onTap: (){
          //     ShowpopupForRadioButton(context);
          //   },
          // child: Container(
          //     width: 80,
          //    // height: 20,
          //     margin: EdgeInsets.all(12),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       border: Border.all(color: Colors.white),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Icon(Icons.filter_alt_outlined),
          //         Text('Filters'),
          //       ],
          //     ),
          //   )),
          SizedBox(width: 10),
          GestureDetector(
            onTap:(){
              Navigator.of(context).pushNamed(SearchitemScreen.routeName);
            },
            child: Container(
              margin:  EdgeInsets.only(top:11, bottom: 12, left: 10, right: 10,),
              child: Image.asset(
                Images.icon_search,
                height: 20,
                width: 20,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                WishListScreen.routeName,
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 11, left: 10, right: 10, bottom: 12),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                /*color: Theme.of(context).buttonColor*/),
              child: /*Icon(
                          Icons.shopping_cart_outlined,
                          size: IConstants.isEnterprise ? 24: 21,
                          color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                        ),*/
              Image.asset(
                Images.wish,
                height: 23,
                width: 23,
                color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: IConstants.currentdeliverylocation,
              builder: (context, value, widget){
                return VxBuilder(
                  // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                  builder: (context,  box, index) {
                    // if (CartCalculations.itemCount<=0)
                    //   return GestureDetector(
                    //     onTap: () {
                    //       if (value != S.of(context).not_available_location)
                    //       Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                    //         "after_login": ""
                    //       });
                    //     },
                    //     child: Container(
                    //       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                    //       width: 28,
                    //       height: 28,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(100),
                    //         /* color: Theme.of(context).buttonColor*/),
                    //       child: /*Icon(
                    //       Icons.shopping_cart_outlined,
                    //       size: IConstants.isEnterprise ? 24: 21,
                    //       color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                    //     ),*/
                    //       Image.asset(
                    //         Images.header_cart,
                    //         height: 28,
                    //         width: 28,
                    //         color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                    //       ),
                    //     ),
                    //   );
                    return Consumer<CartCalculations>(
                      builder: (_, cart, ch) => Badge(
                        child: ch,
                        color: ColorCodes.darkgreen,
                        value: CartCalculations.itemCount.toString(),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
                            Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                              "after_login": ""
                            });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:18, bottom: 12, left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            /*color: Theme.of(context).buttonColor*/),
                          child: /*Icon(
                          Icons.shopping_cart_outlined,
                          size: IConstants.isEnterprise ? 24: 21,
                          color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                        ),*/
                          Image.asset(
                            Images.header_cart,
                            height: 23,
                            width: 23,
                            color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                          ),
                        ),
                      ),);
                  },mutations: {SetCartItem},
                );
              }),
          /*  ValueListenableBuilder(
                valueListenable: Hive.box<Product>(productBoxName).listenable(),
                builder: (context, Box<Product> box, index) {
                  if (box.values.isEmpty)
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      child:  Container(
                        margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).buttonColor),

                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 17,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  int cartCount = 0;
                  for (int i = 0;
                  i < Hive.box<Product>(productBoxName).length;
                  i++) {
                    cartCount = cartCount +
                        Hive.box<Product>(productBoxName)
                            .values
                            .elementAt(i)
                            .itemQty;
                  }
                  return Consumer<Calculations>(
                    builder: (_, cart, ch) => Badge(
                      child: ch,
                      color: Colors.green,
                      value: cartCount.toString(),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                        width: 25,
                        height: 25,
                        //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).buttonColor),

                        child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 17
                        ),
                      ),
                    ),
                  );
                },
              ),*/
          SizedBox(width: 10),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    ColorCodes.accentColor,
                    ColorCodes.primaryColor
                  ])
          ),
        ),
      )

      /*  Container(
          decoration: BoxDecoration(
          boxShadow: [
          BoxShadow(
          color: ColorCodes.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3),
         )
        ],
      gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
          ColorCodes.accentColor,
          ColorCodes.primaryColor
         ],
        ),
      ),
      //color: Theme.of(context).primaryColor,
      height: 120,
      child:Column(
      children: [
        Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 0.0),
              icon: Icon(
                Icons.arrow_back,
                color: IConstants.isEnterprise ? ColorCodes.menuColor : ColorCodes.darkgreen,
                size: IConstants.isEnterprise ? 25.0 : 30,
              ),
              onPressed: () {
               // HomeScreen.scaffoldKey.currentState.openDrawer();
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10,),
            Text(maincategory,style: TextStyle(color:ColorCodes.menuColor )),
            Spacer(),
            SizedBox(
              width: 10,
            ),
            SizedBox(width: 5),
          ],
        ),
       ],
      ))*/;
    }
    Widget _body(){
      return _initLoad
          ? Center(child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))?ItemListShimmerWeb():ItemListShimmer(),)
          :  itemsWidget();
    }

    _bodyweb(){
      print(" sub cate for web: $subcatidinitial and parentcat $parentcatid");
      return
        NotificationListener<
            ScrollNotification>(
          // ignore: missing_return
          onNotification:
              (ScrollNotification scrollInfo) {
            if (!endOfProduct) if (!_isOnScroll &&
                // ignore: missing_return
                scrollInfo.metrics.pixels ==
                    scrollInfo
                        .metrics.maxScrollExtent) {
              setState(() {
                _isOnScroll = true;
              });
              productController.getCategoryprodutlist(subCategoryId, (VxState.store as GroceStore).productlist.length,subcatType,(isendofproduct){
                endOfProduct = isendofproduct;
                if(endOfProduct){

                  setState(() {
                    isLoading = false;
                    _isOnScroll = false;
                    endOfProduct = true;
                  });
                }else {
                  setState(() {
                    isLoading = false;
                    _isOnScroll = false;
                    endOfProduct = false;

                  });
                }
              },isexpress: _groupValue==1?false:true);
              /*     Provider.of<ItemsList>(context, listen: false)
                  .fetchItems(
                  subCategoryId,
                  subcatType,
                  startItem,
                  "scrolling")
                  .then((_) {
                setState(() {
                  //itemslistData = Provider.of<ItemsList>(context, listen: false);
                  startItem = itemslistData.items.length;
                  if (PrefUtils.prefs
                      .getBool("endOfProduct")) {
                    _isOnScroll = false;
                    endOfProduct = true;
                  } else {
                    _isOnScroll = false;
                    endOfProduct = false;
                  }
                });
              });*/

              // start loading data
              setState(() {
                isLoading = false;
              });
            }
          },
          child: SingleChildScrollView(
              child:
              Column(
                children: [
                  if(kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                    Header(false, false),
                  /* if(isLoading)*/ Container(
                    padding: EdgeInsets.only(left:(kIsWeb&& !ResponsiveLayout.isSmallScreen(context))?28:0 ),
                    //constraints: BoxConstraints(maxWidth: 1200),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        if(kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                          if(subcatidinitial!=null&& parentcatid!=null)
                            ExpansionDrawer(parentcatid,subcatidinitial),
                        SizedBox(width: 15,),
                        Flexible(
                            child:
                            _body()
                        ),
                      ],
                    ),
                  ),
                  // ),
                  if (kIsWeb) Footer(address: PrefUtils.prefs.getString("restaurant_address")),
                ],
              )
          ),
        );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?_appBarMobile():null,
      backgroundColor: ColorCodes.whiteColor,
      body:
      (kIsWeb )?
      _bodyweb():
      Column(
        children: [
          //SizedBox(height: 5),
          if(!kIsWeb)
//             VxBuilder(
//                 mutations: {ProductMutation},
//                 builder: (ctx,GroceStore store,VxStatus state) {
//                   // nestedCategory.clear();
//                   // CategoryData data = store.homescreen.data.allCategoryDetails
//                   //     .where((element) => element.id == parentcatid).length>0?store.homescreen.data.allCategoryDetails
//                   //     .where((element) => element.id == parentcatid)
//                   //     .first:store.homescreen.data.allCategoryDetails[0];
//                   // final subCategoryData = ;
//                   // final subcatdata = productController.geSubtCategory(catId);
//                   // subnestdata = productController.getNestedCategory(parentcatid, catId);
//                   nestedCategory = store.homescreen.data.allCategoryDetails.where((element) => element.id == parentcatid).first.subCategory;
//                   if( nestedCategory.length>0) {
//                     //
//                     // if (nestedCategory == null && nestedCategory.length <= 0) {
//                     //   nestedCategory = store.homescreen.data.allCategoryDetails
//                     //       .where((element) => element.id == catId)
//                     //       .first
//                     //       .subCategory;
//                     // }
//                     return isLoading?SizedBox.shrink():Container(
//                       padding: EdgeInsets.only(top: 15),
//                       color: Colors.white,
//                       child: SizedBox(
//                         height: 60,
//                         child: ScrollablePositionedList.builder(
//                           itemScrollController: _scrollController,
//                           scrollDirection: Axis.horizontal,
//                           itemCount:
//                           nestedCategory.length /*snapshot.data.length*/,
//                           itemBuilder: (_, i) => Column(
//                             children: [
//                               SizedBox(
//                                 width: 10.0,
//                               ),
//                               MouseRegion(
//                                 cursor: SystemMouseCursors.click,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Future.delayed(Duration.zero, () async {
//                                       _scrollController.jumpTo(
//                                         index: i,
//                                         /*duration: Duration(seconds: 1)*/
//                                       );
//                                     });
//
//                                     print("display:" + nestedCategory[i].id);
//                                     _displayitem(nestedCategory[i].id, i,nestedCategory[i].type,"0");
//                                   },
//                                   child: Container(
//                                     height: 45,
//                                     margin:
//                                     EdgeInsets.only(left: 5.0, right: 5.0),
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(6),
//                                         border: Border.all(
//                                           width: 1.0,
//                                           color: i.toString() !=indvalue.toString()? ColorCodes.grey:ColorCodes.greenColor /*snapshot.data[i]
//                                                  .boxsidecolor ?? Colors.black54*/
//                                           ,
//                                           /* bottom: BorderSide(
//                                       width: 2.0,
//                                       color: snapshot.data[i].boxsidecolor??Colors.transparent,
//                                     ),*/
//                                         )),
//                                     child: Padding(
//                                       padding:
//                                       EdgeInsets.only(left: 5.0, right: 5.0),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           CachedNetworkImage(
//                                             imageUrl: nestedCategory[i].iconImage,
//                                             placeholder: (context, url) =>
//                                                 Image.asset(
//                                                   Images.defaultCategoryImg,
//                                                   height: 40,
//                                                   width: 40,
//                                                 ),
//                                             errorWidget: (context, url, error) =>
//                                                 Image.asset(
//                                                   Images.defaultCategoryImg,
//                                                   width: 40,
//                                                   height: 40,
//                                                 ),
//                                             height: 40,
//                                             width: 40,
//                                             fit: BoxFit.cover,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             nestedCategory[i].categoryName,
// //                            textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontWeight: /*snapshot.data[i]
//                                                        .fontweight*/
//                                                 FontWeight.bold,
//                                                 color:(i.toString() !=indvalue.toString())? ColorCodes.grey:ColorCodes.greenColor),
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10.0,
//                               ),
//                             ],
//                           ),
//                         ),
//                         // else if (snapshot.hasError)
//                         //   return SizedBox.shrink();
//                         // else
//                         //   return SizedBox.shrink();
//                         //   },
//                         // ),
//                       ),
//                     );
//                   }
//                   else{
//                     return SizedBox.shrink();
//                   }
//                 }
//             ),

            Expanded(
              child: NotificationListener<
                  ScrollNotification>(
                // ignore: missing_return
                  onNotification:
                      (ScrollNotification scrollInfo) {
                    if (!endOfProduct) if (!_isOnScroll &&
                        // ignore: missing_return
                        scrollInfo.metrics.pixels ==
                            scrollInfo
                                .metrics.maxScrollExtent) {

                      setState(() {
                        _isOnScroll = true;
                      });
                      productController.getCategoryprodutlist(subCategoryId, (VxState.store as GroceStore).productlist.length,subcatType,(isendofproduct){
                        startItem = (VxState.store as GroceStore).productlist.length;
                        endOfProduct = isendofproduct;
                        if(endOfProduct){
                          print("endof product");
                          setState(() {
                            _isOnScroll = false;
                            endOfProduct = true;
                          });
                        }else {
                          setState(() {
                            _isOnScroll = false;
                            endOfProduct = false;
                          });

                        }
                      },isexpress: _groupValue==1?false:true);
                      /*   Provider.of<ItemsList>(context, listen: false)
                            .fetchItems(
                            subCategoryId,
                            subcatType,
                            startItem,
                            "scrolling")
                            .then((_) {
                          setState(() {
                            //itemslistData = Provider.of<ItemsList>(context, listen: false);
                            startItem = itemslistData.items.length;
                            if (PrefUtils.prefs
                                .getBool("endOfProduct")) {
                              _isOnScroll = false;
                              endOfProduct = true;
                            } else {
                              _isOnScroll = false;
                              endOfProduct = false;
                            }
                          });
                        });*/

                      // start loading data
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      padding: EdgeInsets.only(left:6 , right: 6),
                      child: _body()))),
            ),
        ],
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: kIsWeb ? SizedBox.shrink() :_bottomNavigationBar(),
    );
  }

}