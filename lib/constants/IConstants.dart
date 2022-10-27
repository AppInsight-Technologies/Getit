import 'package:flutter/foundation.dart';

class IConstants {
  // static String API_PATH = "https://login.kgcart.com/api/app-manager/get-functionality/";
  // static String API_IMAGE = "https://login.kgcart.com/uploads/";

   static String API_PATH = "https://login.trygetit.com/api/app-manager/get-functionality/";
    static String API_IMAGE = "https://login.trygetit.com/uploads/";

  /* static String API_PATH = "https://login.grocbay.com/api/app-manager/get-functionality/";
   static String API_IMAGE = "https://login.grocbay.com/uploads/";*/
  // static String API_PATH = "https://franchise.tokree.co.in/api/app-manager/get-functionality/";
  // static String API_IMAGE = "https://franchise.tokree.co.in/uploads/";


  static String APP_NAME = "Getit";
  static String API_PAYTM = "https://paytm.grocbay.com/";

  static String androidId/* = com.appinsight.gbay"*/;
  static String appleId/* = "1512751692"*/;
  static bool isEnterprise = true;
  static String websiteId = ""/*"7ada1ff4-e065-4e54-bb26-193defda73e2"*/;
  static String googleApiKey = ""/*"AIzaSyCe6evdOqGIOUMugiFHNEYq20ztqcNSZrc"*/;

  //social media links

  static String facebookUrl = "";
  static String instagramUrl = "";
  static String youtubeUrl = "";
  static String twitterUrl = "";

  static const paytm_mid = 'eJMBBa49929394152335';
  static var paytm_key = "JaSol8L6wh%26dOLYt";
   ///Used For Paytm
   static var currency = 'INR';
   // static var paymentisstagin = true;
   static String paymentGateway = "";
   static String webViewUrl = "";
   static String gatewayId = "";
   static String gateway_secret = "";
   static bool isPaymentTesting = false;
   static String languageId = "";
   static String countryCode = "";
   static String currencyFormat = "";
   static String minimumOrderAmount = "";
   static String maximumOrderAmount = "";
   static String restaurantName = "";
   static String giftWrapamount = "";
   static String returnsPolicy = "";
   static String refundPolicy = "";
   static String walletPolicy = "";
   static String numberFormat = "";
   static String primaryMobile = "";
   static String secondaryMobile = "";
   static String primaryEmail = "";
   static String secondaryEmail = "";
   static String restaurantTerms = "";
   static String categoryOneLabel = "";
   static String categoryTwoLabel = "";
   static String categoryThreeLabel = "";
   static String categoryOne = "";
   static String categoryTwo = "";
   static String categoryThree = "";
///CAsh Free
   static String CASHFREEAPPID = "214856bd68bc9ff2491910eb05658412";
   static var CASHFREEKEY='8f9402af29a1f21a1b0b186834c276722ab02108';

   static String holyday = "";
   static String holydayNote = "";

   static int decimaldigit = 2;

   //location change
   static final deliverylocationmain = ValueNotifier<String>("");
   static final currentdeliverylocation = ValueNotifier<String>("");
}
