import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';

class SettingProviderData extends ChangeNotifier {
  List settingList = [];

  SettingProviderData() {
    log("Calledddd");
    getSettingData();
  }

  Future<int> getSettingData() async {
    try {
      log("------------------------");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.postforlist(apiname: 'getSetting').then((responselist) async {
          if (responselist.length > 0) {
            settingList = responselist;
            notifyListeners();
            log("->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
                responselist.toString());
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
}
