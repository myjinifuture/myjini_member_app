import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/AddressComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/NoFoundComponent.dart';
import 'package:smart_society_new/Mall_App/Screens/Add_AddressScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

class AddressScreen extends StatefulWidget {
  var Address, fromwehere;
  AddressScreen({this.Address, this.fromwehere});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isgetaddressLoading = false;
  List getaddressList = [];

  @override
  void initState() {
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          getaddressList.length == 0 ? Colors.white : Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Address",
            style: TextStyle(fontSize: 18, color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("SAVED ADDRESS",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600])),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              SlideLeftRoute(page: UpdateProfileScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("+ ADD NEW ADDRESS",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
                isgetaddressLoading == true
                    ? LoadingComponent()
                    : getaddressList.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return AddressComponent(
                                addressData: getaddressList[index],
                                onremove: () {
                                  setState(() {
                                    getaddressList.removeAt(index);
                                  });
                                },
                                fromwhere: "${widget.fromwehere}",
                              );
                            },
                            itemCount: getaddressList.length,
                            shrinkWrap: true,
                          )
                        : NoFoundComponent(
                            ImagePath: 'assets/assets/address.png',
                            Title: "No Address Found")
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveDataToSession(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AddressSession.AddressId, data["AddressId"].toString());
    await prefs.setString(
        AddressSession.AddressHouseNo, data["AddressHouseNo"]);
    await prefs.setString(AddressSession.AddressName, data["AddressName"]);
    await prefs.setString(
        AddressSession.AddressAppartmentName, data["AddressAppartmentName"]);
    await prefs.setString(AddressSession.AddressStreet, data["AddressStreet"]);
    await prefs.setString(
        AddressSession.AddressLandmark, data["AddressLandmark"]);
    await prefs.setString(AddressSession.AddressArea, data["AddressArea"]);
    await prefs.setString(AddressSession.AddressType, data["AddressType"]);
    await prefs.setString(
        AddressSession.AddressPincode, data["AddressPincode"]);
    await prefs.setString(AddressSession.City, data["AddressCityName"]);
  }

  _getAddress() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isgetaddressLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();

        FormData body = FormData.fromMap({
          "CustomerId": prefs.getString(Session.customerId),
        });
        Services.postforlist(apiname: 'getAddress', body: body).then(
            (ResponseList) async {
          if (ResponseList.length > 0) {
            setState(() {
              getaddressList = ResponseList;
              isgetaddressLoading = false;
            });
            saveDataToSession(ResponseList[0]);
          } else {
            setState(() {
              isgetaddressLoading = false;
            });
            Fluttertoast.showToast(msg: "Address Not Found");
          }
        }, onError: (e) {
          setState(() {
            isgetaddressLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }
}
