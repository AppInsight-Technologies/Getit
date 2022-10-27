import 'dart:convert';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/cashfree_model.dart';
import '../../screens/paytm_screen.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../screens/subscription_confirm_screen.dart';
import '../../constants/IConstants.dart';
import '../../models/paytm_tocken_modle.dart';
import '../../screens/orderconfirmation_screen.dart';
import '../../screens/payment_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../../constants/api.dart';
import '../../utils/prefUtils.dart';
// import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import 'paytm_web.dart';

class Payment {
  String mid,_orderId,_amount,_usenam;
  bool _restrictAppInvoke = true;
  var _context;
  var _routeArgs;
  String _prev;
  bool _isweb;
  //Razorpay _razorpay;
  String _name;
  GroceStore store = VxState.store;
  String get name => _name;

  /// Paytm Token Generate
  Future<PaytmTocken> _getPaytmOrderTocken() async {
    // var staging;
    String url;
    if(IConstants.isPaymentTesting ==true){
      url = Api.paytmteckenapi +'orderid=$_orderId&m_key=plcc0aPkvbE4n@f@&mid=xexqsh45840354978392&t_amt=$_amount&currency=INR&isstaging=1&custId=$_usenam';
    }else{
      url = Api.paytmteckenapi +'orderid=$_orderId&m_key=${IConstants.gateway_secret}&mid=${IConstants.gatewayId}&t_amt=$_amount&currency=INR&isstaging=0&custId=$_usenam';
    }
    try {
      // _sellingitems.clear();
      final response = await http
          .get(
        kIsWeb?  "https://groce-bay.herokuapp.com/"+url:""+url,
        /* body: {
          "rows": "2",
          "branch": PrefUtils.prefs.getString('branch'),
          "user": user,
          // await keyword is used to wait to this operation is complete.
        }*/
      );
      // SellingItemModel result;
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("resp ${responseJson}");
      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        resdata = responseJson as Map<String, dynamic>;
        // resdata["featuredCategoryBColor"] = list[_random.nextInt(list.length)];
        return  PaytmTocken.fromJson(resdata);
      }else{
        return null;
      }
    } catch (error) {
      throw error;
    }
  }
  /// Paytm Token Generate
  Future<CashFreeTocken> _getCashFreeOrderTocken() async {
    print("jcjbc");
    // var staging;
    String url;
    if(IConstants.isPaymentTesting==true){
      url = 'https://test.cashfree.com/api/v2/cftoken/order/';
    }else{
      url = 'https://api.cashfree.com/api/v2/cftoken/order/';
    }
    print("heojd" + {
      'x-client-id': IConstants.gatewayId,
      'x-client-secret': IConstants.gateway_secret,
      'Content-Type': 'application/json'
    }.toString());
    try {
      var headers = {
        'x-client-id': IConstants.gatewayId,
        'x-client-secret': IConstants.gateway_secret,
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = '''{"orderId": "$_orderId","orderAmount":$_amount, "orderCurrency": "INR" }''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print("grvfvfv..response.."+response.statusCode.toString());
      if (response.statusCode == 200) {
        print("grvfvfv");
        return  CashFreeTocken.fromJson(json.decode(await response.stream.bytesToString()));
      }
      else {
        return  CashFreeTocken.fromJson(json.decode(await response.stream.bytesToString()));
      }


    } catch (error) {
      throw error;
    }
  }

  Future<void> startPaytmTransaction(context, isweb,{@required orderId, @required username, amount = "1.00",@required routeArgs, String prev}) async {
    this._orderId =orderId;
    this._amount =amount;
    this._amount =amount;
    this._usenam = username;
    this._context = context;
    this._routeArgs = routeArgs;
    this._prev = prev;
    this._isweb = isweb;
    // if (PrefUtils.prefs.getString('FirstName') != null) {
    //   if (PrefUtils.prefs.getString('LastName') != null) {
    //     this._name =  PrefUtils.prefs.getString('FirstName') + " " + PrefUtils.prefs.getString('LastName');
    //   } else {
    //     this._name =  PrefUtils.prefs.getString('FirstName');
    //   }
    // } else {
    //   this._name = "";
    // }
    this._name = store.userData.username;
    switch(IConstants.paymentGateway){
    //  case "paytm": _paytmTransaction(); break;

      //case "razorpay": _razorpayTransaction();break;
      case "cashfree": _cashFreeTransaction();break;
      case "webview": _webViewTransaction();break;
    }
  }


  /// Transaction Through PayTm
/*  _paytmTransaction() async {
    await _getPaytmOrderTocken().then((value) {
      if(value!=null)
        if (value.body.resultInfo.resultStatus == "S") {
          try {
            if(_isweb) WebPaytmSdk.startTransaction(value.body.txnToken, _orderId, _amount,IConstants.isPaymentTesting
                ,IConstants.gatewayId,(value)=>_onresponse(value)).onError((error, stackTrace) => _catchError(error));
            else
              AllInOneSdk.startTransaction(IConstants.isPaymentTesting
                  ? "xexqsh45840354978392" : IConstants.gatewayId, _orderId, _amount, value.body.txnToken, IConstants.isPaymentTesting
                  ?"https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$_orderId":"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$_orderId", IConstants.isPaymentTesting
                  , _restrictAppInvoke).then((value) => _onresponse(value)).onError((error, stackTrace) => _catchError(error));
          } catch (err) {
            return err.toString();
          }
        } else {
          return value.body.resultInfo.resultMsg;
        }
    });

  }*/

  /// Transaction Through RazorPay
  // _razorpayTransaction() {
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response){
  //     if (_prev == "SubscribeScreen")
  //       _subscriptionstatus("paid", response.paymentId.toString(), "Payment done through Razorpay");
  //     else
  //       _paymentstatus("paid", response.paymentId.toString(), "Payment done through Razorpay");
  //   });
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response){
  //     if (_prev == "SubscribeScreen")
  //       _subscriptionstatus("cancelled", "", response.message);
  //     else _paymentstatus("cancelled", "", response.message);
  //   });
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,(ExternalWalletResponse response){
  //     Fluttertoast.showToast(
  //         msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  //     if (_prev == "SubscribeScreen")
  //       _subscriptionstatus("paid", response.walletName, "Payment done through Razorpay");
  //     else _paymentstatus("paid", response.walletName, "Payment done through Razorpay");
  //   });
  //   var options = {
  //     'key': IConstants.gatewayId,
  //     'amount': double.parse(_amount) * 100 ,
  //     'name': name,
  //     //'description': 'Fine T-Shirt',
  //     'prefill': {
  //       'contact': PrefUtils.prefs.getString('mobile'),
  //       'email': PrefUtils.prefs.containsKey("Email") ? PrefUtils.prefs.getString('Email') : "",
  //     }
  //   };
  //   try {
  //     _razorpay.open(options);
  //     // Navigator.of(context).pop();
  //   } catch (e) {
  //   }
  // }
  /// Transaction Through CashFree
  _cashFreeTransaction() async{
    print("helloo" );
    String stage;
    await _getCashFreeOrderTocken().then((value) {
      if(IConstants.isPaymentTesting) stage = "TEST";else stage = "PROD";
      if(value.status =="OK"){
        Map<String, dynamic> inputParams = {
          "orderId": _orderId,
          "orderAmount": _amount,
          "customerName": name,
          "orderNote": "Payment through Cash Free",
          "orderCurrency": "INR",
          "appId": IConstants.gatewayId,
          "customerPhone": store.userData.mobileNumber,
          "customerEmail": store.userData.email != ""
              ? store.userData.email
              : "${IConstants.primaryEmail}",
          "stage": stage,
          "tokenData": value.cftoken,
          "notifyUrl": "https://test.gocashfree.com/notify"
        };

        CashfreePGSDK.doPayment(inputParams)
            .then((value) {
          if(value["txStatus"]=="SUCCESS"){
            _paymentstatus("paid", value['referenceId'], value['txMsg']);
            if (_prev == "SubscribeScreen")
              _subscriptionstatus("paid", value['referenceId'], value['txMsg']);
            else
              _paymentstatus("paid", value['referenceId'], value['txMsg']);

          }else if(value["txStatus"]=="FAILED"){
            _paymentstatus("cancelled", value['referenceId'], value['txMsg']);
            if (_prev == "SubscribeScreen")
              _subscriptionstatus("failed", value['referenceId'], value['txMsg']);
            else _paymentstatus("failed", value['referenceId'], value['txMsg']);
          }else{
            if (_prev == "SubscribeScreen")
              _subscriptionstatus("cancelled", value['orderId'], value['txStatus']);
            else _paymentstatus("cancelled", value['orderId'], value['txStatus']);}
        });
      }else{

      }
    });
  }
  /// Transaction Through WebView
  _webViewTransaction(){
    _routeArgs["orderId"]=_orderId;
    _routeArgs["amount"]=_amount;
    Navigator.of(_context).pushReplacementNamed(PaytmScreen.routeName, arguments: _routeArgs);
  }

  Future<void> _paymentstatus(String status, String tansactionid, String note) async { // imp feature in adding async is the it automatically wrap into Future.
/*    *//* = ModalRoute.of(context).settings.arguments as Map<String, String>;*//*;
    String minimumOrderAmountNoraml = _routeArgs["minimumOrderAmountNoraml"];
    String deliveryChargeNormal = _routeArgs["deliveryChargeNormal"];
    String minimumOrderAmountPrime = _routeArgs["deliveryChargePrime"];
    String deliveryChargePrime = _routeArgs["deliveryChargePrime"];
    String minimumOrderAmountExpress = _routeArgs["minimumOrderAmountExpress"];
    String deliveryChargeExpress = _routeArgs["deliveryChargeExpress"];
    String deliveryType = _routeArgs["deliveryType"];
    String note = _routeArgs["note"];
    String prev =_routeArgs['prev'];*/
    try{
      final response = await http.post(Api.updatePaymentStatusSplit, body: { // await keyword is used to wait to this operation is complete.
        "status": status,
        "transction": tansactionid,
        "refid": _orderId,
        "mobile": PrefUtils.prefs.getString('mobile'),
        "name": name,
        "note": note,
      });

      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "200") {
        if(status == "paid") {

          PrefUtils.prefs.remove("orderId");
          Navigator.of(_context).pushReplacementNamed(
              OrderconfirmationScreen.routeName,
              arguments: {
                'orderstatus' : "success",
                'orderid': _orderId

              }
          );
        }
        else if(status == "cancelled"){
          final routeArgs = ModalRoute.of(_context).settings.arguments as Map<String, String>;
          String minimumOrderAmountNoraml=routeArgs["minimumOrderAmountNoraml"];
          String deliveryChargeNormal = routeArgs["deliveryChargeNormal"];
          String minimumOrderAmountPrime = routeArgs["deliveryChargePrime"];
          String deliveryChargePrime = routeArgs["deliveryChargePrime"];
          String minimumOrderAmountExpress = routeArgs["minimumOrderAmountExpress"];
          String deliveryChargeExpress = routeArgs["deliveryChargeExpress"];
          String deliveryType =routeArgs["deliveryType"];
          String note =routeArgs["note"];
          String prev =routeArgs['prev'];

          Navigator.of(_context).pop();
          Navigator.of(_context).pushReplacementNamed(
              PaymentScreen.routeName,
              arguments: {
                'minimumOrderAmountNoraml': minimumOrderAmountNoraml,
                'deliveryChargeNormal': deliveryChargeNormal,
                'minimumOrderAmountPrime': minimumOrderAmountPrime,
                'deliveryChargePrime': deliveryChargePrime,
                'minimumOrderAmountExpress': minimumOrderAmountExpress,
                'deliveryChargeExpress':deliveryChargeExpress ,
                'deliveryType': deliveryType,
                'note': note,
                'responsejson':"",
                'fromScreen':'',
              }
          );

        }
        else {

          Navigator.of(_context).pushReplacementNamed(
              OrderconfirmationScreen.routeName,
              arguments: {
                'orderstatus': "failure",
                'orderId':  PrefUtils.prefs.containsKey("subscriptionorderId")?PrefUtils.prefs.getString("subscriptionorderId"):_orderId
              }
          );
        }
      }
      else {
      }

    } catch (error) {
      throw error;
    }
  }
  Future<void> _subscriptionstatus(String status, String tansactionid, String note) async { // imp feature in adding async is the it automatically wrap into Future.
    debugPrint("subscription status.....");
    try {
      final response = await http.post(
          Api.updateSubscriptionPayment,
          body: { // await keyword is used to wait to this operation is complete.
            "user_id": PrefUtils.prefs.getString('apikey').toString(),
            "payment_status": status,
            "transaction_id": tansactionid,
            "order": _orderId,
            "amount": _amount,
            "payment_note": note,
          }
      );
      print("update subscription....."+{
        "user_id": PrefUtils.prefs.getString('apikey').toString(),
        "payment_status": status,
        "transaction_id": tansactionid,
        "order": _orderId,
        "amount": _amount,
        "payment_note": note,
      }.toString());
      final responseJson = json.decode(response.body);
      print("update sub response......"+responseJson.toString());
      if(responseJson['status'].toString() == "200") {
        print("response status 200....");
        if(status == "paid") {

         // PrefUtils.prefs.remove("subscriptionorderId");
          debugPrint("subscription success.....");
          Navigator.of(_context).pushReplacementNamed(
              SubscriptionConfirmScreen.routeName,
              arguments: {
                'orderstatus' : "success",
                'sorderId': PrefUtils.prefs.getString("subscriptionorderId")
              }
          );
        }
        else {
          debugPrint("subscription failure id.....");
          Navigator.of(_context).pushReplacementNamed(
              SubscriptionConfirmScreen.routeName,
              arguments: {
                'orderstatus': "failure",
                'sorderId': PrefUtils.prefs.getString("subscriptionorderId")
              }
          );
        }/*else{
          final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(
              PaymenSubscriptionScreen.routeName,
              arguments: {
                "addressid":routeArgs['addressid'].toString(),
                "useraddtype": routeArgs['useraddtype'].toString(),
                "startDate":routeArgs['startDate'].toString(),
                "endDate": routeArgs['endDate'].toString(),
                "itemCount":routeArgs['itemCount'].toString(),
                "deliveries": routeArgs['deliveries'].toString(),
                "total": routeArgs['total'].toString(),
                //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
                "schedule": routeArgs['schedule'].toString(),
                "itemid": routeArgs['itemid'].toString(),
                "itemimg": routeArgs['itemimg'].toString(),
                "itemname":routeArgs['itemname'].toString(),
                "varprice":routeArgs['varprice'].toString(),
                "varname":routeArgs['varname'].toString(),
                "address":routeArgs['address'].toString(),
                "paymentMode": routeArgs['paymentMode'].toString(),
                "cronTime": routeArgs['cronTime'].toString(),
                "name": routeArgs['name'].toString(),
                "varid": routeArgs['varid'].toString(),
                "varmrp":routeArgs['varmrp'].toString(),
              }
          );

        }*/

      }
      else {
      }

    } catch (error) {
      throw error;
    }
  }

  /// On Response For Paytm Transaction
  _onresponse(value){
    if(value["RESPCODE"]=="01") {
      if (_prev == "SubscribeScreen") {
        debugPrint("subscription paid.....");
        _subscriptionstatus("paid", value['TXNID'], value['RESPMSG']);
      } else {
        _paymentstatus("paid", value['TXNID'], value['RESPMSG']);
      }
    }
    else {
      if (_prev == "SubscribeScreen") {
        debugPrint("subscription failed.....");
        _subscriptionstatus("failed", value['TXNID'], value['RESPMSG']);
      } else {
        _paymentstatus("cancelled", value['TXNID'], value['RESPMSG']);
      }
    }
    return  value.toString();
  }
  /// On Error For Paytm Transaction
  _catchError(onError) {
    if (onError is PlatformException) {
      if(_prev == "PaymentScreen")
        /* Navigator.of(context)
                    .pushReplacementNamed(PaymentScreen.routeName, arguments: {
                  'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'].toString(),
                  'deliveryChargeNormal': routeArgs['deliveryChargeNormal'].toString(),
                  'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'].toString(),
                  'deliveryChargePrime': routeArgs['deliveryChargePrime'].toString(),
                  'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'].toString(),
                  'deliveryChargeExpress': routeArgs['deliveryChargeExpress'].toString(),
                  'deliveryType': routeArgs['deliveryType'].toString(),
                  'note': routeArgs['note'].toString(),
                  'deliveryCharge': routeArgs['deliveryCharge'].toString(),
                  'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'].toString(),
                });*/
        Navigator.of(_context).pushReplacementNamed(
            OrderconfirmationScreen.routeName,
            arguments: {
              'orderstatus': "failure",
              'orderId': PrefUtils.prefs.getString("orderId")
            }
        );
      else if(_prev == "SubscribeScreen"){
        /*Navigator.of(context)
                      .pushReplacementNamed(PaymenSubscriptionScreen.routeName, arguments: {
                    "addressid":routeArgs['addressid'].toString(),
                    "useraddtype": routeArgs['useraddtype'].toString(),
                    "startDate":routeArgs['startDate'].toString(),
                    "endDate": routeArgs['endDate'].toString(),
                    "itemCount":routeArgs['itemCount'].toString(),
                    "deliveries": routeArgs['deliveries'].toString(),
                    "total":routeArgs['total'].toString(),
                    "schedule": routeArgs['schedule'].toString(),
                    "itemid": routeArgs['itemid'].toString(),
                    "itemimg": routeArgs['itemimg'].toString(),
                    "itemname":routeArgs['itemname'].toString(),
                    "varprice":routeArgs['varprice'].toString(),
                    "varname":routeArgs['varname'].toString(),
                    "address":routeArgs['address'].toString(),
                    "paymentMode":routeArgs['paymentMode'].toString(),
                    "cronTime": routeArgs['cronTime'].toString(),
                    "name": routeArgs['name'].toString(),
                    "varid": routeArgs['varid'].toString(),
                    "varmrp":routeArgs['varmrp'].toString(),

                  });*/
        debugPrint("subscription failure.....");
        Navigator.of(_context).pushReplacementNamed(
            SubscriptionConfirmScreen.routeName,
            arguments: {
              'orderstatus': "failure",
              'sorderId': PrefUtils.prefs.getString("subscriptionorderId")
            }
        );
      }
      return  onError.message.toString() + " \n  " + onError.details.toString();
    } else {
      return  onError.toString();
    }
  }
  dispose(){
    // if(_razorpay!=null)
    //   _razorpay.clear();
  }
}

final payment = Payment();