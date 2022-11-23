

import '../../models/newmodle/category_store_modle.dart';
import '../../models/newmodle/home_store_modle.dart';
import '../../models/newmodle/repeateToppings.dart';
import '../../models/newmodle/search_data.dart';
import '../../models/newmodle/shoppingModel.dart';
import '../../models/newmodle/store_banner.dart';
import '../../models/newmodle/store_data.dart';
import '../../models/newmodle/subscription_data.dart';
import '../../models/newmodle/upcomingsubscription.dart';
import '../../repository/fetchdata/shopping_list.dart';

import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/newmodle/user.dart';

import '../../models/sellingitemsfields.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../repository/fetchdata/shopping_list.dart';
import '../../repository/fetchdata/shopping_list.dart';
import '../language.dart';
import '../newmodle/shoppingModel.dart';
import '../newmodle/user.dart';

class GroceStore extends VxStore{
  /// contain list of languages
final language = LanguagesList();
///contain login user data if user has logged in
UserData userData = UserData();
int? notificationCount = UserModle().notificationCount;
Prepaid prepaid = Prepaid();
//ShoppingList shoppingList = ShoppingList();
HomePageData homescreen = HomePageData();
Home_Store homestore = Home_Store();
CategoryStore categoryStore = CategoryStore();
List<ItemData> productlist = [];
List<CartItem> CartItemList = [];
List<ShoppingListData> ShoppingList = [];
List<RepeatTopping> RepeatToppings = [];
// List<CategoryData> categorydatalist = [];
ItemData? singelproduct = ItemData();
StoreSearch storesearch = StoreSearch();
StoreData storedata = StoreData();
StoreOfferbanner storeofferbanner = StoreOfferbanner();
  SubscriptionBoxData subscriptionBoxData = SubscriptionBoxData();
SellingItemsFields OffersCartItemsFields= SellingItemsFields();
  List<SubscriptionBoxData> subscriptionboxlist = [];
  List<UpcomingSubscription> upcomingsubscriptionlist = [];
List<SellingItemsFields> OfferCartList = []; //store and add to cart
List<SellingItemsFields> CartOfferList=[]; //update to cart
}