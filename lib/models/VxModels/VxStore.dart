import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/category_modle.dart';
import '../../models/newmodle/filterModle.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/newmodle/user.dart';

import '../../models/sellingitemsfields.dart';
import 'package:velocity_x/velocity_x.dart';
import '../language.dart';

class GroceStore extends VxStore{
  /// contain list of languages
  final language = LanguagesList();
  ///contain login user data if user has logged in
  UserData userData = UserData();
  Prepaid prepaid = Prepaid();
  HomePageData homescreen = HomePageData();
  List<ItemData> productlist = [];
  List<CartItem> CartItemList = [];
// List<CategoryData> categorydatalist = [];
  ItemData singelproduct = ItemData();
  FilterData filterData = FilterData();

  SellingItemsFields OffersCartItemsFields= SellingItemsFields();
  List<SellingItemsFields> OfferCartList = []; //store and add to cart
  List<SellingItemsFields> CartOfferList=[]; //update to cart
}