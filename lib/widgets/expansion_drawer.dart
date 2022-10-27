import 'package:flutter/material.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/category_modle.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../screens/items_screen.dart';
import '../providers/categoryitems.dart';

import 'package:provider/provider.dart';

class ExpansionDrawer extends StatefulWidget {

  final String parentcatId;
  final String subcatID;
  ExpansionDrawer(this.parentcatId, this.subcatID);

  @override
  _ExpansionDrawerState createState() => _ExpansionDrawerState();
}

class _ExpansionDrawerState extends State<ExpansionDrawer> {
  List variddata = [];
  var subcategoryData;
  var varlength;
  int selected = -1;
  final categoriesData = (VxState.store as GroceStore).homescreen.data.allCategoryDetails;
@override
  void initState() {
    // TODO: implement initState
  // setState(() {
  //   categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
  // });
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    ProductController productController = ProductController();
    debugPrint("maincatidexpansion" + widget.parentcatId);
    debugPrint("subcatidexpansion" + widget.subcatID);

    if(categoriesData.length>0)
    return Container(
      width: 200,
      height:MediaQuery.of(context).size.height,
      constraints: BoxConstraints(
        minHeight: 500,
        maxHeight:double.infinity,
        // maxWidth: 30.0,
      ),
      child: ListView.builder(
        key: Key('lbuilder ${selected.toString()}'),
        itemCount: categoriesData.length,
        itemBuilder: (_, index) {
          // if(index>0)
          // productController.geSubtCategory(categoriesData[index].id);
          return ListTileTheme(
              key: Key(index.toString()),
              contentPadding: EdgeInsets.all(0),
              child: ExpansionTile(
                onExpansionChanged: (val){
                  if (val)
                    setState(() {
                      Duration(seconds: 20000);
                      selected = index;
                    });
                  else
                    setState(() {
                      selected = -1;
                    });
                },
                  initiallyExpanded: selected<0?(widget.parentcatId ==
                      categoriesData[index].id) ? true : false:index==selected,
                  title: Text(categoriesData[index].categoryName),
                  children: [
                 if(widget.subcatID!=null&& widget.parentcatId!=null) SubCategoriesGrid(categoriesData[index],widget.subcatID),
                  ]
              ));
        },
      ),
    );
    else
      return CircularProgressIndicator();
  }

}
class SubCategoriesGrid extends StatefulWidget {
  CategoryData categoriesData ;
  String subcatID;

  SubCategoriesGrid(this.categoriesData, this.subcatID);

  @override
  _SubCategoriesGridState createState() => _SubCategoriesGridState();
}

class _SubCategoriesGridState extends State<SubCategoriesGrid> {

  // CategoriesItemsList subcategoryData;
  var _isloading = true;
  @override
  void initState() {
    // Provider.of<CategoriesItemsList>(context, listen: false)
    //     .fetchNestedCategory(widget.catId,"subitemScreen")
    //     .then((_) {
    //   setState(() {
    //     subcategoryData = Provider.of<CategoriesItemsList>(
    //       context,
    //       listen: false,
    //     );
    //     _isloading = subcategoryData.itemsubNested.isEmpty? true:!true;
    //   });
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    );*/
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 768) {
      widgetsInRow = 4;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }

    return  Column(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            //color: Colors.white,
          ),

          child: /*_isloading? Center(
            child: CircularProgressIndicator(),
          ) :*/
          widget.categoriesData.subCategory .length<=1?Padding(
            padding: EdgeInsets.only(bottom: 10),
            child:  Text("No Item Found",),
          ):
          ListView.builder(
            shrinkWrap: true,
            controller: new ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            itemCount: widget.categoriesData.subCategory.length,
            itemBuilder: (ctx, i) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("clickforid: "+{
                  'maincategory':  widget.categoriesData.categoryName,
                  'catId':  widget.categoriesData.id,
                  'catTitle':  widget.categoriesData.categoryName,
                  'subcatId': widget.categoriesData.subCategory[i].id,
                  'indexvalue': i.toString(),
                  'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                  'prev': "category_item"}.toString());
                Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                  'maincategory': widget.categoriesData.categoryName,
                  'catId': widget.categoriesData.id,
                  'catTitle': widget.categoriesData.categoryName,
                  'subcatId': widget.categoriesData.subCategory[i].id,
                  'indexvalue': i.toString(),
                  'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                  'prev': "category_item"});
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:  Text(widget.categoriesData.subCategory[i].categoryName,
                  style: TextStyle(
                      color: (widget.subcatID==widget.categoriesData.subCategory[i].id)?ColorCodes.discount:Colors.black
                  ),
                ),
              ),
            ),

          ),
        )
      ],
    );
  }
}



