import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';

class CartProvider extends ChangeNotifier {
  int cartCount = 0;

  List settingList = [];
  List cartIdList = [];
  List addressList = [];

  CartProvider() {
    // log("Cart Provider");
    // getCartdata();
    // getSettingData();
    // getAdressData();
  }

  void setCartCount(int count) {
    cartCount = count;
    notifyListeners();
  }

  void increaseCart({int productId}) {
    cartCount++;
    cartIdList.add(productId);
    notifyListeners();
  }

  void decreaseCart({int productId}) {
    cartCount--;
    cartIdList.remove(productId);
    notifyListeners();
  }

  void removecart() {
    cartCount = 0;
    cartIdList.clear();
    notifyListeners();
  }

  Future<int> getCartdata() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData body = FormData.fromMap(
            {"CustomerId": preferences.getString(Session.customerId)});
        Services.postforlist(apiname: 'getCarttest', body: body).then(
            (responselist) async {
          if (responselist.length > 0) {
            setCartCount(responselist[0]["Cart"].length);
            cartIdList.clear();
            for (int i = 0; i < responselist[0]["Cart"].length; i++) {
              cartIdList
                  .add(int.parse(responselist[0]["Cart"][i]["ProductId"]));
            }
            print("Cart List" + "$cartIdList");
          } else
            return 0;
        }, onError: (e) {
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
          return 0;
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
      return 0;
    }
  }

  Future<int> getSettingData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.postforlist(apiname: 'getSetting').then((responselist) async {
          if (responselist.length > 0) {
            settingList = responselist;
            notifyListeners();
          }
          return 0;
        }, onError: (e) {
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
          return 0;
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
      return 0;
    }
  }

  Future<int> getAdressData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData body = FormData.fromMap(
            {"CustomerId": preferences.getString(Session.customerId)});
        Services.postforlist(apiname: 'getAddress', body: body).then(
            (responselist) async {
          if (responselist.length > 0) {
            addressList = responselist;
            notifyListeners();
            print(responselist);
          }
        }, onError: (e) {
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
          return 0;
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
      return 0;
    }
  }
}
