
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../assets/ColorCodes.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/category_modle.dart';
import '../../models/newmodle/home_page_modle.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/IConstants.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../utils/ResponsiveLayout.dart';
import '../providers/categoryitems.dart';
import './categories_item.dart';
import 'package:shimmer/shimmer.dart';


class CategoriesGrid extends StatefulWidget {
  CategoryData allCategoryDetail;
  CategoriesGrid(this.allCategoryDetail);

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  //bool _isLoading = true;
  bool _isCategory = false;
  bool _isCategoryShimmer = false;
  var subcategoryData;

  CategoriesItemsList subNestedcategoryData;

  List<CategoryData> subcatData=[];

  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      ProductController productController = ProductController();
      productController.geSubtCategory(widget.allCategoryDetail.id);

  /*    await Provider.of<CategoriesItemsList>(context, listen: false).fetchNestedCategory(widget.allCategoryDetail.id, "categoriesGrid").then((_) {
        subNestedcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);

        setState(() {
          _isCategory = true;
          _isCategoryShimmer = false;
        });
      });*/
    });


  }
  Widget _sliderShimmer() {
    return Vx.isWeb ?
    Center(
      child: CircularProgressIndicator(),
    )
        :
    Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: ColorCodes.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: ColorCodes.baseColor,
          highlightColor: ColorCodes.lightGreyWebColor,

          child: ListView.builder(
            shrinkWrap: true,
            controller: new ScrollController(keepScrollOffset: false),
            padding: ResponsiveLayout.isSmallScreen(context)? const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0):
            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
            itemCount: 3,
            itemBuilder: (ctx, i) => Card(
              color: Color(0xFFD0F0DE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
              margin: EdgeInsets.all(5),

              child: Container(),
            ),

          ),
          // )),
        ));
  }

  Widget _category() {

    //  final subNestedcategoryData = Provider.of<CategoriesItemsList>(context,listen: false);

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 165;

    // ProductController productController = ProductController();
    // productController.geSubtCategory(widget.allCategoryDetail.id);
print("id....click....");
 /*  Vx.isWeb?
     subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    ).findByIdweb(widget.allCategoryDetail.id):
     subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    ).findById(widget.allCategoryDetail.id);*/
    //print("sub cat length......"+subNestedcategoryData.itemsubNested.length.toString());


    if (deviceWidth > 1200) {
      widgetsInRow = 9;
      aspectRatio =
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 190:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 968) {
      widgetsInRow = 8;
      aspectRatio =
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    } else if (deviceWidth > 768) {
      widgetsInRow = 6;
      aspectRatio =
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }
    return  VxBuilder(
        mutations: {ProductMutation},
        builder: (ctx,store,VxStatus state)
    {
      if(widget.allCategoryDetail.subCategory!=null&&widget.allCategoryDetail.subCategory.length>0)
        subcatData = widget.allCategoryDetail.subCategory.where((element) => element.categoryName.toLowerCase().trim() != "all").toList();
      print("subcat length..."+subcatData.length.toString());
      return subcatData.length > 0?
        (subcatData!=null||subcatData.length>0)
          ? (IConstants.isEnterprise) ?
      Column(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GridView.builder(
                shrinkWrap: true,
                controller: new ScrollController(keepScrollOffset: false),
                /*  padding: ResponsiveLayout.isSmallScreen(context)? const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0):
              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),*/
                itemCount: /*subNestedcategoryData.itemsubNested.length*/subcatData.length,
                itemBuilder: (ctx, i) {
                  return Card(
                    color: /*Color(0xFFD0F0DE)*/Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                    //  margin: EdgeInsets.all(5),

                    child: CategoriesItem(
                        "SubcategoryScreen",
                        widget.allCategoryDetail.categoryName,
                        widget.allCategoryDetail.id,
                        subcatData[i].id,
                        subcatData[i].categoryName,
                        i,
                        subcatData[i].iconImage,
                    subcatData[i].catBanner),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
              ),
            ),
          )
        ],
      ) :
      Column(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          GridView.builder(
            gridDelegate:  new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widgetsInRow,
                    crossAxisSpacing: 4,
                    childAspectRatio: aspectRatio
                    ),
              shrinkWrap: true,
              controller: new ScrollController(keepScrollOffset: false),
              scrollDirection: Axis.vertical,
              itemCount: subcatData.length,
              itemBuilder: (ctx, i) {
                debugPrint("subcat..." + subcatData.length.toString());
                debugPrint("ecsfdsfv" + subcatData[i].iconImage.toString() + "  " + subcatData[i].catBanner.toString());
                return CategoriesItem(
                    "SubcategoryScreen",
                    widget.allCategoryDetail.categoryName,
                    widget.allCategoryDetail.id,
                    subcatData[i].id,
                    subcatData[i].categoryName,
                    i,
                    subcatData[i].iconImage,
                    subcatData[i].catBanner
                    //subcatData[i].catBanner
                  /* "SubcategoryScreen",
                widget.catTitle,
                widget.catId,
                subNestedcategoryData.itemsubNested[i].catid,
                subNestedcategoryData.itemsubNested[i].title,
                i,
                subNestedcategoryData.itemsubNested[i].imageUrl*/);
              }
          ),
        ],
      )
          :
      _sliderShimmer():
      _sliderShimmer();

    });
  }
  @override
  Widget build(BuildContext context) {

    return _category();

  }
}