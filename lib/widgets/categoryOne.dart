import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../assets/ColorCodes.dart';
import '../../models/newmodle/home_page_modle.dart';

import '../constants/IConstants.dart';

import '../blocs/sliderbannerBloc.dart';
import '../models/categoriesModel.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';

class CategoryOne extends StatefulWidget {
  HomePageData homedata;
  CategoryOne(this.homedata);

  @override
  _CategoryOneState createState() => _CategoryOneState();
}

class _CategoryOneState extends State<CategoryOne> {
  var subcategoryData;
  bool _isWeb = false;
  var _categoryOne = false;
  int perPageItem = 2;
  int pageCount;
  int selectedIndex = 0;
  int lastPageItemLength;
  PageController pageController;
  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
        });
      } else {
        setState(() {
          _isWeb = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWeb = true;
      });
    }
    var num = (widget.homedata.data.category1Details.length / perPageItem);
    pageCount = num.isInt ? num.toInt() : num.toInt() + 1;

    var reminder = widget.homedata.data.category1Details.length.remainder(perPageItem);
    lastPageItemLength = reminder == 0 ? perPageItem : reminder;
    super.initState();
  }

  Widget _horizontalshimmerslider() {

    return _isWeb ?
    SizedBox.shrink()
        :
    Row(
      children: <Widget>[
        Expanded(
            child: Card(
              child: SizedBox(
                height: 100,
                child: Container(
                  padding:EdgeInsets.only(left: 28,right: 28),
                  child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (_, i) => Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Shimmer.fromColors(
                              baseColor: /*Color(0xffd3d3d3)*/Colors.grey[200],
                              highlightColor: /*Color(0xffeeeeee)*/Colors.grey[200],
                              child:   Container(
                                width: 250.0,
                                height: 20.0,
                                color:/* Theme.of(context).buttonColor*/Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.homedata.data.category1Details.length > 0) {
      _categoryOne = true;
    } else {
      _categoryOne = false;
    }
    // return StreamBuilder(
    //   stream: bloc.categoryOne,
    //   builder: (context, AsyncSnapshot<List<CategoriesModel>> snapshot) {
        if (_categoryOne) {
          double deviceWidth = MediaQuery.of(context).size.width;
          int widgetsInRow = 2;
          double aspectRatio =
              (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 250;


          if (deviceWidth > 1200) {
            widgetsInRow = 9;
            aspectRatio =
            (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 140:
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
          } else if (deviceWidth > 968) {
            widgetsInRow = 6;
            aspectRatio =
            (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
          } else if (deviceWidth > 768) {
            widgetsInRow = 6;
            aspectRatio =
            (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
          }
          return Container(
            color: ColorCodes.whiteColor,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                   //padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:10,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:10 ),
                  child: Text(
                    widget.homedata.data.categoryLabel,
                    style: TextStyle(
                        fontSize: ResponsiveLayout.isSmallScreen(context)?19.0:24.0,
                        fontWeight: FontWeight.bold,
                        color: ColorCodes.blackColor),
                  ),
                ),
                SizedBox(height: 5),

                SizedBox(
                  height: 250,
                  child:  PageView.builder(
                      controller: pageController,
                      itemCount: pageCount,
                      onPageChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      itemBuilder: (_, pageIndex) {
                        return GridView.count(
                            shrinkWrap: true,
                           // scrollDirection: Axis.horizontal,
                            physics: ScrollPhysics(),
                          //  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: widgetsInRow,
                              crossAxisSpacing: 3,
                              childAspectRatio: aspectRatio,
                              mainAxisSpacing: 3,
                          //  ),
                           // itemCount: widget.homedata.data.category1Details.length,
                         //   itemBuilder: (_, i) =>
                          children: List.generate( (pageCount - 1) != pageIndex
                              ? perPageItem
                              : lastPageItemLength, (index) {
                            return  MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  print("fromcatone: "+{'maincategor': widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].categoryName,
                                    'catId': widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].id,
                                    'catTitle': widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].categoryName,
                                    'indexvalue': (index + (pageIndex * perPageItem)).toString(),
                                    'prev': "category_item"}.toString());
                                  Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                                    'maincategory': widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].categoryName,
                                    'catId':  widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].parentId,
                                    'catTitle': widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].categoryName,
                                    'indexvalue': (index + (pageIndex * perPageItem)).toString(),
                                    'subcatId':  widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].id,
                                    'prev': "category_item"
                                  });
                                },
                                child: Container(
                                  width: ResponsiveLayout.isSmallScreen(context)?180:150,
                                  child:  Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    elevation: 0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].iconImage,
                                              placeholder: (context, url) => /*Image.asset(Images.defaultCategoryImg)*/_horizontalshimmerslider(),
                                              errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                              fit: BoxFit.cover,
                                              height: ResponsiveLayout.isSmallScreen(context)?200:100,
                                              width: ResponsiveLayout.isSmallScreen(context)?200:150,
                                              //fit: BoxFit.fill,
                                            )
                                        ),
                                        // Spacer(),
                                        SizedBox(height: 0,),
                                        Container(height: 30,
                                          child: Center(
                                            child: Text(widget.homedata.data.category1Details[index + (pageIndex * perPageItem)].categoryName,
                                                overflow: TextOverflow.visible,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:15.0)),
                                          ),
                                        ),
                                        //SizedBox(height: 5.0,),
                                      ],
                                    ),
                                  ) ,
                                  // )
                                ),
                              ),
                            );
                          })
                        );
                      }
                      ),
                ),
                Center(
                  child: SizedBox(
                    height: 8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: pageCount,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                                borderRadius:  BorderRadius.circular(100.0),
                                color: ColorCodes.blackColor
                                    .withOpacity(selectedIndex == index ? 1 : 0.2)),
                           // margin: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 3, right: 3),
                            width: 8,
                            height: 8,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } /*else if (snapshot.hasError) {
          return SizedBox.shrink();
        } else if(snapshot.data.toString() == "null") {
          return SizedBox.shrink();
        }*/ else {
          return SizedBox.shrink()/*_horizontalshimmerslider()*/;
        }
    //     },
    // );
  }
}
extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
