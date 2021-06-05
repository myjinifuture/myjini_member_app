import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/Providers/CartProvider.dart';
import 'package:smart_society_new/Mall_App/Screens/AddressScreen.dart';

import 'CheckPincode.dart';
import 'ThankyouScreen.dart';

class CheckoutPage extends StatefulWidget {
  var addressdata;

  CheckoutPage({this.addressdata});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String CustomerId,
      CustomerEmailId,
      CustomerName,
      Customerphone,
      AddressId,
      AddressHouseNo,
      AddressName,
      AddressAppartmentName,
      AddressStreet,
      AddressLandmark,
      AddressArea,
      AddressType,
      AddressPincode,
      City;
  bool isLoading = false;
  String PaymentMode = "Cash";
  SharedPreferences preferences;
  bool _usePoints = false;
  List priceList = [];
  bool isPincodeChecking = false;
  List specificationList = [];
  int amount;
  TextEditingController pincode = new TextEditingController();

  getlocaldata() async {
    preferences = await SharedPreferences.getInstance();
    CartProvider addressProvider =
        Provider.of<CartProvider>(context, listen: false);
    setState(() {
      CustomerId = preferences.getString(Session.customerId);
      CustomerName = preferences.getString(Session.CustomerName);
      Customerphone = preferences.getString(Session.CustomerPhoneNo);
      CustomerEmailId = preferences.getString(Session.CustomerEmailId);
      //From Provider
      AddressId = addressProvider.addressList[0]["AddressId"];
      AddressHouseNo = addressProvider.addressList[0]["AddressHouseNo"];
      AddressPincode = addressProvider.addressList[0]["AddressPincode"];
      AddressAppartmentName =
          addressProvider.addressList[0]["AddressAppartmentName"];
      AddressStreet = addressProvider.addressList[0]["AddressStreet"];
      AddressLandmark = addressProvider.addressList[0]["AddressLandmark"];
      AddressArea = addressProvider.addressList[0]["AddressArea"];
      AddressType = addressProvider.addressList[0]["AddressType"];
      City = addressProvider.addressList[0]["AddressCityName"];
    });
  }

  _changeAddress(BuildContext context) async {
    Map<String, dynamic> _addressData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddressScreen(fromwehere: "Checkout")),
    );
    print(_addressData);
    setState(() {
      CustomerId = _addressData["CustomerId"];
      AddressId = _addressData["AddressId"];
      AddressHouseNo = _addressData["AddressHouseNo"];
      AddressAppartmentName = _addressData["AddressAppartmentName"];
      AddressStreet = _addressData["AddressStreet"];
      AddressLandmark = _addressData["AddressLandmark"];
      AddressArea = _addressData["AddressArea"];
      AddressPincode = _addressData["AddressPincode"];
      AddressType = _addressData["AddressType"];
      City = _addressData["AddressCityName"];
    });
    print(AddressId);
  }

  Razorpay _razorpay;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _placeOrder(transactionId: response.paymentId);
    Fluttertoast.showToast(
        msg: "Payment Successfully " + response.paymentId, timeInSecForIos: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  void openPaymentGateway(var amount) async {
    print("---------------------*******-------${amount}");
    int finalamount = amount * 100;
    var options = {
      'key': 'rzp_live_XCxat4CzDhDGNj',
      'amount': finalamount,
      'name': '${CustomerName}',
      'description': '-Shopping',
      'prefill': {'contact': '${Customerphone}', 'email': '${CustomerEmailId}'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getlocaldata();
    beforPlaceOrder();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: CheckPincode(PlaceOrder: () {
              _placeOrder();
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Check out",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: AddressId == null
                  ? FlatButton(
                      onPressed: () {
                        _changeAddress(context);
                      },
                      child: Text("+ Add Address"))
                  : Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 18),
                                  Text("Deliver to: ${AddressType}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  _changeAddress(context);
                                },
                                child: Container(
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("Change",
                                        style: TextStyle(fontSize: 13)),
                                  )),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4.0)),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 6.0, left: 4.0, bottom: 4.0),
                            child: Text(
                                "${AddressHouseNo}-" +
                                    "${AddressAppartmentName}" +
                                    "," +
                                    "${AddressStreet}" +
                                    "\n${AddressLandmark}, " +
                                    "${AddressArea} ," +
                                    "${City}-" +
                                    "${AddressPincode}",
                                style: TextStyle(color: Colors.grey[700])),
                          ),
                        ],
                      ),
                    ),
            ),
            provider.settingList[0]["SettingShowReedemPoints"] == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: _usePoints,
                                      onChanged: (value) {
                                        setState(() {
                                          _usePoints = value;
                                        });
                                        beforPlaceOrder();
                                        print(value);
                                      }),
                                  Image.asset("assets/assets/coin.png",
                                      width: 25),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Redeem Points",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("100 Points ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  )
                : Container(),
            provider.settingList[0]["SettingShowPromocode"] == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Text("Apply Promocode",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.8, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, bottom: 5.0, top: 5.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "Enter Coupon Code",
                                            hintStyle: TextStyle(fontSize: 12),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 6.0, left: 6.0),
                                  child: FlatButton(
                                    color: appPrimaryMaterialColor,
                                    onPressed: () {},
                                    child: Text("APPLY",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            provider.settingList[0]["SettingShowOnlinePayment"] == true
                ? Column(
                    children: [
                      Container(
                        color: Colors.grey[300],
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8),
                              child: Text("Payment Mode",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          PaymentMode = "Cash";
                                        });
                                      },
                                      child: Text("COD",
                                          style: TextStyle(
                                              color: PaymentMode == "Cash"
                                                  ? Colors.white
                                                  : Colors.black54)),
                                      color: PaymentMode == "Cash"
                                          ? appPrimaryMaterialColor
                                          : Colors.grey[200]),
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          PaymentMode = "Online";
                                        });
                                      },
                                      child: Text("Online",
                                          style: TextStyle(
                                              color: PaymentMode != "Cash"
                                                  ? Colors.white
                                                  : Colors.black54)),
                                      color: PaymentMode != "Cash"
                                          ? appPrimaryMaterialColor
                                          : Colors.grey[200]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text("Payment Detail",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Column(
                            children: [
                              specificationList[index]["Key"] == "Total"
                                  ? Divider()
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${specificationList[index]["Text1"]}"),
                                  Text("${specificationList[index]["Text3"]}"),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: specificationList.length,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 45,
                        child: FlatButton(
                          color: appPrimaryMaterialColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.grey[200])),
                          onPressed: () {
                            if (PaymentMode == "Online") {
                              openPaymentGateway(amount);
                            } else {
                              _placeOrder();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: isLoading == true
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        "Confirm Order",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            // color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _placeOrder({String transactionId}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        FormData body = FormData.fromMap({
          "CustomerId": "${CustomerId}",
          "AddressId": "${AddressId}",
          "OrderPaymentMethod": "${PaymentMode}",
          "OrderTransactionNo": "${transactionId}",
          "OrderPromoCode": "",
          "OrderBonusPoint": ""
        });
        print(body.fields);
        Services.postForSave(apiname: 'placeOrder', body: body).then(
            (responseremove) async {
          if (responseremove.IsSuccess == true && responseremove.Data == "1") {
            Provider.of<CartProvider>(context, listen: false).removecart();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => ThankyouScreen()),
                (route) => false);
            setState(() {
              isLoading = false;
            });

            Fluttertoast.showToast(msg: "Order Place Successfully");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }

  beforPlaceOrder() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        FormData body = FormData.fromMap({
          "CustomerId": "${CustomerId}",
          "Promocode": "",
          "Points": "",
        });
        Services.postforlist(apiname: 'beforePlaceOrderTest', body: body).then(
            (responselist) async {
          if (responselist.length > 0) {
            setState(() {
              isLoading = false;
              priceList = responselist;
              specificationList = responselist[2]["tot"];
              amount = responselist[2]["Total"][0]["total"];
              log("----------------------->${amount}");
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(msg: "Error : $e");
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }
}
