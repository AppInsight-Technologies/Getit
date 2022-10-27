import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import './assets/ColorCodes.dart';
import './screens/CodReturnScreen.dart';
import './screens/ReturnConfirmation.dart';
import './screens/addinfo_screen.dart';
import './screens/profile_screen.dart';
import './screens/promocode_screen.dart';
import './screens/wishlist_screen.dart';
import './screens/notavailable_product_screen.dart';
import './screens/pause_subscriptionScreen.dart';
import './screens/rate_order_screen.dart';
import './screens/refund_screen.dart';
import './screens/Payment_SubscriptionScreen.dart';
import './screens/View_Subscription_Details.dart';
import './screens/introduction_screen.dart';
import './utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import './screens/MySubscriptionScreen.dart';
import './screens/SubscriptionWalletScreen.dart';
import './screens/subscribe_screen.dart';
import './screens/subscription_confirm_screen.dart';

import './services/firebaseAnaliticsService.dart';
import './screens/refer_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './data/hiveDB.dart';

import './screens/edit_screen.dart';
import './screens/splash_screen.dart';
import './screens/policy_screen.dart';
import './screens/login_screen.dart';
import './screens/otpconfirm_screen.dart';
import './screens/home_screen.dart';
import './screens/subcategory_screen.dart';
import './screens/items_screen.dart';
import './screens/signup_selection_screen.dart';
import './screens/signup_screen.dart';
import './screens/login_credential_screen.dart';
import './screens/category_screen.dart';
import './screens/brands_screen.dart';
import './screens/cart_screen.dart';
import './screens/searchitem_screen.dart';
import './screens/sellingitem_screen.dart';
import './screens/confirmorder_screen.dart';
import './screens/payment_screen.dart';
import './screens/orderconfirmation_screen.dart';
import './screens/address_screen.dart';
import './screens/location_screen.dart';
import './screens/myorder_screen.dart';
import './screens/orderhistory_screen.dart';
import './screens/map_screen.dart';
import './screens/subscription_screen.dart';
import './screens/wallet_screen.dart';
import './screens/shoppinglist_screen.dart';
import './screens/membership_screen.dart';
import './screens/about_screen.dart';
import './screens/addressbook_screen.dart';
import './screens/shoppinglistitems_screen.dart';
import './screens/return_screen.dart';
import './screens/help_screen.dart';
import './screens/privacy_screen.dart';
import './screens/singleproduct_screen.dart';
import './screens/notification_screen.dart';
import './screens/paytm_screen.dart';
import './screens/not_product_screen.dart';
import './screens/not_subcategory_screen.dart';
import './screens/customer_support_screen.dart';
// import './screens/introduction_screen.dart';
import './screens/pickup_screen.dart';
import './screens/pages_screen.dart';
import './screens/singleproductimage_screen.dart';
import './data/calculations.dart';
import './screens/MultipleImagePicker_screen.dart';
import './screens/unavailablity_screen.dart';
import './screens/not_brand_screen.dart';
import './screens/banner_product_screen.dart';
import './screens/editOtp_screen.dart';
import './screens/offer_screen.dart';

import 'controller/mutations/languagemutations.dart';
import 'generated/l10n.dart';
import 'models/VxModels/VxStore.dart';
import 'models/unavailabilityfield.dart';
import './providers/carouselitems.dart';
import './providers/branditems.dart';
import './providers/categoryitems.dart';
import './providers/advertise1items.dart';
import './providers/sellingitems.dart';
import './providers/itemslist.dart';
import './providers/addressitems.dart';
import './providers/deliveryslotitems.dart';
import './providers/myorderitems.dart';
import './providers/membershipitems.dart';
import './providers/notificationitems.dart';
import 'models/categoriesfields.dart';
import 'models/sellingitemsfields.dart';
import './models/unavailableproducts_field.dart';
import './providers/featuredCategory.dart';
import './providers/cartItems.dart';

import './constants/IConstants.dart';

const String productBoxName = "product";
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await PrefUtils.init();
    if (Platform.isIOS || Platform.isAndroid) {
      final document = await getApplicationDocumentsDirectory();
      Hive.init(document.path);
      Hive.registerAdapter(ProductAdapter());
      await Hive.openBox<Product>(productBoxName);

    }

  } catch (e) {
    Hive.registerAdapter(ProductAdapter());
    await Hive.openBox<Product>(productBoxName);
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {

    runApp(
        VxState(store: GroceStore(),
            child: MyApp()));
  });
}


class MyApp extends StatelessWidget {
  static const Color black = Color(0xff2b6838);

  String activelang = "ar";
  bool _isWeb = false;

  @override
  Widget build(BuildContext context) {
    /*//SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: Theme.of(context).primaryColor, // status bar color
    ));*/
    try {
      if (Platform.isIOS) {
        _isWeb = false;
      } else {
        _isWeb = false;
      }
    } catch (e) {
      _isWeb = true;
      print(e);
    }


    IConstants.isEnterprise?SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values):
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: ColorCodes.whiteColor,
    ));

    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: CarouselItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: BrandItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: CategoriesItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: Advertise1ItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: SellingItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: ItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: AddressItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: DeliveryslotitemsList(),
          ),
          ChangeNotifierProvider.value(
            value: MyorderList(),
          ),
          ChangeNotifierProvider.value(
            value: MembershipitemsList(),
          ),
          ChangeNotifierProvider.value(
            value: NotificationItemsList(),
          ),
          ChangeNotifierProvider.value(
            value: CategoriesFields(),
          ),
          ChangeNotifierProvider.value(
            value: SellingItemsFields(),
          ),
          ChangeNotifierProvider.value(
            value: CartCalculations(),
          ),
          ChangeNotifierProvider.value(
            value: unavailabilitiesfield(),
          ),
          ChangeNotifierProvider.value(
              value: unavailabilities()
          ),
          ChangeNotifierProvider.value(
              value: FeaturedCategoryList()
          ),
          ChangeNotifierProvider.value(
              value: CartItems()
          )
        ],
        child: VxBuilder<GroceStore>(
            mutations: {SetLanguage},
            builder: (BuildContext context, store, VxStatus status) {
              activelang = store.language.language.code;
              return MaterialApp(
                  builder: (context, child) {
                    print("alang:${activelang}");
                    return MediaQuery(
                      child:  Directionality(
                          textDirection:!_isWeb ? activelang =="ar" ? TextDirection.rtl : TextDirection.ltr : TextDirection.ltr ,child: child),
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

                    );
                  },
                  locale: Locale(activelang),
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  navigatorObservers: [
                    fas.getAnalyticsObserver(),
                  ],
                  debugShowCheckedModeBanner: false,
                  title: IConstants.APP_NAME,
                  theme: ThemeData(
                    primarySwatch: MaterialColor(0xffF9C41C, {
                      50: Color(0xffF9C41C),
                      100: Color(0xffF9C41C),
                      200: Color(0xffF9C41C),
                      300: Color(0xffF9C41C),
                      400: Color(0xffF9C41C),
                      500: Color(0xffF9C41C),
                      600: Color(0xffF9C41C),
                      700: Color(0xffF9C41C),
                      800: Color(0xffF9C41C),
                      900: Color(0xffF9C41C),
                    }),
                    accentColor: MaterialColor(0xffF9C41C, {
                      50: Color(0xffF9C41C),
                      100: Color(0xffF9C41C),
                      200: Color(0xffF9C41C),
                      300: Color(0xffF9C41C),
                      400: Color(0xffF9C41C),
                      500: Color(0xffF9C41C),
                      600: Color(0xffF9C41C),
                      700: Color(0xffF9C41C),
                      800: Color(0xffF9C41C),
                      900: Color(0xffF9C41C),
                    }),

                    buttonColor: Colors.white,
                    textSelectionTheme:
                    TextSelectionThemeData(selectionColor: Color(0xffe8e8e8)),
                    textSelectionColor: Colors.grey,
                    textSelectionHandleColor: Colors.grey,
                    backgroundColor: Color(0xffe8e8e8),
                    fontFamily: 'Lato',
                  ),
                  home: SplashScreenPage(),
                  navigatorKey: navigatorKey, // Setting a global key for navigator
                  routes: {
                    SignupSelectionScreen.routeName: (ctx) => SignupSelectionScreen(),
                    PolicyScreen.routeName: (ctx) => PolicyScreen(),
                    SignupScreen.routeName: (ctx) => SignupScreen(),
                    LocationScreen.routeName: (ctx) => LocationScreen(),
                    MapScreen.routeName: (ctx) => MapScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    LoginCredentialScreen.routeName: (ctx) => LoginCredentialScreen(),
                    OtpconfirmScreen.routeName: (ctx) => OtpconfirmScreen(),
                    HomeScreen.routeName: (ctx) => HomeScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    SearchitemScreen.routeName: (ctx) => SearchitemScreen(),
                    ConfirmorderScreen.routeName: (ctx) => ConfirmorderScreen(),
                    CategoryScreen.routeName: (ctx) => CategoryScreen(),
                    BrandsScreen.routeName: (ctx) => BrandsScreen(),
                    SellingitemScreen.routeName: (ctx) => SellingitemScreen(),
                    SubcategoryScreen.routeName: (ctx) => SubcategoryScreen(),
                    ItemsScreen.routeName: (ctx) => ItemsScreen(),
                    PaymentScreen.routeName: (ctx) => PaymentScreen(),
                    OrderconfirmationScreen.routeName: (ctx) => OrderconfirmationScreen(),
                    AddressScreen.routeName: (ctx) => AddressScreen(),
                    MyorderScreen.routeName: (ctx) => MyorderScreen(),
                    OrderhistoryScreen.routeName: (ctx) => OrderhistoryScreen(),
                    WalletScreen.routeName: (ctx) => WalletScreen(),
                    SubscriptionScreen.routeName: (ctx) => SubscriptionScreen(),
                    ShoppinglistScreen.routeName: (ctx) => ShoppinglistScreen(),
                    MembershipScreen.routeName: (ctx) => MembershipScreen(),
                    AboutScreen.routeName: (ctx) => AboutScreen(),
                    AddressbookScreen.routeName: (ctx) => AddressbookScreen(),
                    ReturnScreen.routeName: (ctx) => ReturnScreen(),
                    ShoppinglistitemsScreen.routeName: (ctx) => ShoppinglistitemsScreen(),
                    PrivacyScreen.routeName: (ctx) => PrivacyScreen(),
                    HelpScreen.routeName: (ctx) => HelpScreen(),
                    SingleproductScreen.routeName: (ctx) => SingleproductScreen(),
                    NotificationScreen.routeName: (ctx) => NotificationScreen(),
                    //TODO: Depreciating PaytmScreen
                    PaytmScreen.routeName: (ctx) => PaytmScreen(),
                    NotProductScreen.routeName: (ctx) => NotProductScreen(),
                    NotSubcategoryScreen.routeName: (ctx) => NotSubcategoryScreen(),
                    CustomerSupportScreen.routeName: (ctx) => CustomerSupportScreen(),
                    NotBrandScreen.routeName: (ctx) => NotBrandScreen(),
                    introductionscreen.routeName: (ctx) => introductionscreen(),
                    // ExampleScreen.routeName: (ctx) => ExampleScreen(),
                    PickupScreen.routeName: (ctx) => PickupScreen(),
                    //MapAddressScreen.routeName: (ctx) => MapAddressScreen(),
                    SingleProductImageScreen.routeName: (ctx) => SingleProductImageScreen(),
                    MultipleImagePicker.routeName: (ctx) => MultipleImagePicker(),
                    EditScreen.routeName: (ctx) => EditScreen(),
                    unavailability.routeName: (ctx) => unavailability(),
                    BannerProductScreen.routeName: (ctx) => BannerProductScreen(),
                    EditOtpScreen.routeName: (ctx) => EditOtpScreen(),
                    PagesScreen.routeName: (ctx) => PagesScreen(),
                    ReferEarn.routeName: (ctx) => ReferEarn(),
                    SubscribeScreen.routeName: (ctx) => SubscribeScreen(),
                    SubscriptionConfirmScreen.routeName: (ctx) => SubscriptionConfirmScreen(),
                    MySubscriptionScreen.routeName: (ctx) => MySubscriptionScreen(),
                    SubscriptionWalletScreen.routeName: (ctx) => SubscriptionWalletScreen(),
                    PaymenSubscriptionScreen.routeName: (ctx) => PaymenSubscriptionScreen(),
                    ViewSubscriptionDetails.routeName: (ctx) => ViewSubscriptionDetails(),
                    PauseSubscriptionScreen.routeName: (ctx) => PauseSubscriptionScreen(),
                    Refund_screen.routeName: (ctx) => Refund_screen(),
                    AddInfo.routeName: (ctx) => AddInfo(),

                    NotavailabilityProduct.routeName: (ctx) => NotavailabilityProduct(),

                    OfferScreen.routeName: (ctx) => OfferScreen(),
                    RateOrderScreen.routeName: (ctx) => RateOrderScreen(),
                    ProfileScreen.routeName: (ctx) => ProfileScreen(),
                    // ignore: equal_keys_in_map
                    WishListScreen.routeName: (ctx) => WishListScreen(),
                    PromocodeScreen.routeName: (ctx) => PromocodeScreen(),
                    ReturnconfirmationScreen.routeName: (ctx) => ReturnconfirmationScreen(),
                    CodReturnScreen.routeName: (ctx) => CodReturnScreen()
                  });
            }



        ));
  }
}
