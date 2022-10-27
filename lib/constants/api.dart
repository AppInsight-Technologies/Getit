import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';

class Api {
  static String baseURL = IConstants.API_PATH;


  static String getRestaurant = baseURL + 'get-resturant';

  //Signup and Logins API's
  static String preRegister = baseURL + 'customer/pre-register';
  static String register = baseURL + 'customer/register';
  static String updateMobileNumber = baseURL + 'update-mobile-number';
  static String resendOtp30 = baseURL + 'customer/resend-otp-30';
  static String resendOtpCall = baseURL + 'customer/resend-otp-call';
  static String productNotify = baseURL + 'customer/notify';
  static String getProfile = baseURL + 'customer/get-profile';
  static String updateCustomerProfile = baseURL + 'profile/update-customer-profile';
  static String emailLogin = baseURL + 'customer/email-login';
  static String mobileCheck = baseURL + 'customer/mobile-check';
  static String emailCheck = baseURL + 'customer/email-check';
  static String checkLocation = baseURL + 'check-location';
  static String addPrimaryLocation = baseURL + 'add-primary-location';
  static String getNotification = baseURL + 'get-notification/';
  static String updateNotification = baseURL + 'update-notification/';
  static String getMembership = baseURL + 'get-membership';
  static String getMembershipDetail = baseURL + 'get-membership_detail';

  static String getAdsFifteen = baseURL + 'restaurant/get-ads/15/' ; //Above Main Slider
  static String getAdsOne = baseURL + 'restaurant/get-ads/1/' ; //Main Slider
  static String getFeaturedCategories = baseURL + 'get-language-categories'; //Fetch category one
  // static String getFeaturedCategories = baseURL + 'get-categories/'; //Fetch category one
  static String getAdsTwo = baseURL + 'restaurant/get-ads/2/' ; //Below Featured categories 1
  static String getAdsFive = baseURL + 'restaurant/get-ads/5/' ; //Below featured items 1
  static String getAdsNine = baseURL + 'restaurant/get-ads/9/'; //Below Featured categories 2
  static String getAdsTen = baseURL + 'restaurant/get-ads/10/' ; //Below Featured categories 3
  static String getAdsEleven = baseURL + 'restaurant/get-ads/11/' ; //Below vertical slider
  static String getAdsThree = baseURL + 'restaurant/get-ads/3/' ; //Website slider
  static String getFooter = baseURL + 'restaurant/get-ads/4/' ; //Footer image
  static String pageDetails = baseURL + 'get-page-details/'; //page details

  static String getCategories = baseURL + 'restaurant/get-categories'; //Fetch categories
  static String getSubCategories = baseURL + 'restaurant/get-sub-category/'; //Fetch subcategory
  static String getShoppingList = baseURL + 'get-shopping-list/';
  static String getShoppingListItem = baseURL + 'get-shopping-list-item/';
  static String getRefereal = baseURL + 'get-refercountdetails/';

  //Related to orders
  static String getCustomerOrder = baseURL + 'get-customer-order/';
  static String getCustomerOrderBranch = baseURL + 'get-customer-order-branch/';
  static String getCustomerRefOrderBranch = baseURL + 'get-customer-ref-order-branch';
  static String mySubscriptionList = baseURL + 'my-subscription-list/';
  static String viewCustomerOrderDetails = baseURL + 'view-customer-order-details/';
  static String viewSubscriptionList = baseURL + 'view-subscription-list/';
  static String getRefundProduct = baseURL + 'get-refund-product';
  static String newReturn = baseURL + 'return/new-return';
  static String cancelOrder = baseURL + 'cancel-order';
  static String addRatings = baseURL + 'add-ratings';
  static String subscriptionCreate = baseURL + 'subscription-create';
  static String getSubscriptionPaymentStatus = baseURL + 'get-subscription-payment-status/';
  static String checkPromocode = baseURL + 'check-promocode';
  static String getPromocode = baseURL + 'get-coupans';
  static String createTicket = baseURL + 'create-ticket';
  static String removeSubscription = baseURL + 'subscription-order-delete';
  static String pauseSubscription = baseURL + 'subscription-order-pause';
  static String resumeSubscription = baseURL + 'subscription-order-resume';

  //Address api's
  static String addAddress = baseURL + 'customer/ecommerce/address/add-new';
  static String updateAddress = baseURL + 'customer/ecommerce/address/update';
  static String getAddress = baseURL + 'get-address';
  static String setDefaultAddress = baseURL + 'set-default-address';
  static String removeAddress = baseURL + 'customer/address/remove';
  static String getDeliveryCharges = baseURL + 'get-delivery-charges/';
  static String pickupLocation = baseURL + 'pickup-location';
  static String getDeliverySlots = baseURL + 'get-delivery-slots';
  static String getPickupSlot = baseURL + 'get-pickup-slot/';

  //Related to cart
  static String addToCart = baseURL + 'add-to-cart';
  static String updateCart = baseURL + 'update-cart';
  static String reorder = baseURL + 'reorder/';
  static String emptyCart = baseURL + 'empty-cart/';
  static String getCartItems = baseURL + 'get-cart-items/';
  static String cartCheck = baseURL + 'cart-check/';

  //brands related API's
  static String getBrands = baseURL + 'restaurant/get-brands';
  static String getBrandsData = baseURL + 'get-brands-data/';

  //Related to payments
  static String paymentModeBranch = baseURL + 'payment-mode-branch';
  static String getLoyalty = baseURL + 'get-loyalty';
  static String checkLoyalty = baseURL + 'check-loyalty/';

  //Related to wallet
  static String walletLogs = baseURL + 'wallet/get-logs';

  //Related to shopping list
  static String createShoppingList = baseURL + 'restaurant/create-shopping-list';
  static String addItemToList = baseURL + 'restaurant/add-item-to-list';
  static String removeShoppingList = baseURL + 'restaurant/remove-shopping-list';

  static String getOffers = baseURL + 'get-offers';

  //Not for live cart
  static String getFeatured = baseURL + 'restaurant/get-featured';
  static String getDiscounted = baseURL + 'restaurant/get-discount';
  static String getMenuitem = baseURL + 'restaurant/get-menuitem';
  static String getSerachitem = baseURL + 'restaurant/search-items';
  static String getSingleProduct = baseURL + 'single-product';
  static String getRecentProducts = baseURL + 'restaurant/get-recent-products/';
  static String getMenuitemByBrand = baseURL + 'restaurant/get-menuitem-by-brand';
  static String getItems = baseURL + 'get-items/';
  static String newOrder = baseURL + 'order/new-order';

  //For Live cart
  static String getFeaturedByCart = baseURL + 'restaurant/get-featured-by-cart';
  static String getDiscountedByCart = baseURL + 'restaurant/get-discount-by-cart';
  static String getForgetByCart = baseURL+ 'restaurant/get-items-data-by-cart';
  static String getMenuitemByCart = baseURL + 'restaurant/get-menuitem-by-cart';
  static String getSerachitemByCart = baseURL + 'restaurant/search-items-by-cart';
  static String getSingleProductByCart = baseURL + 'single-product-by-cart';
  static String getSingleProductvarIdByCart = baseURL + 'single-product-by-var';
  static String getRecentProductsByCart = baseURL + 'restaurant/get-recent-products-by-cart/';
  static String getMenuitemByBrandByCart = baseURL + 'restaurant/get-menuitem-by-brand-by-cart';
  static String getItemsByCart = baseURL + 'get-items-by-cart/';
  static String newOrderByCart = baseURL + 'order/new-order-by-cart';
  static String newOrderByCartSplit = baseURL + 'order/new-order/split';
  static String getOfferByCart = baseURL + 'restaurant/get-offer-by-cart';
  static String getSwapProduct = baseURL + 'get-swap-product';


  //Related to payment
  static String updatePaymentStatusSplit = baseURL + 'update-payment-status-split';
  static String updateSubscriptionPayment = baseURL + 'update-subscription-payment';
  static String getOrderStatus = baseURL + 'restaurant/get-order-status/';
  static String paytmteckenapi ='https://paytmsdk.grocbay.com/paytmtoken.php?';

  // Wish List
 static String addwishlist = baseURL + 'v2/customer/wishlist/add';
  static String getwishlist = baseURL + 'v2/customer/wishlist';
  static String removewishlist = baseURL + 'v2/customer/wishlist/remove';
}
