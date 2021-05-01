import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/Screens/CheckOutPage.dart';
import 'package:smart_society_new/Mall_App/Screens/UpdateAddressScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/fade_route.dart';

class AddressComponent extends StatefulWidget {
  var addressData, fromwhere;
  Function onremove;

  AddressComponent({this.addressData, this.onremove, this.fromwhere});

  @override
  _AddressComponentState createState() => _AddressComponentState();
}

class _AddressComponentState extends State<AddressComponent> {
  bool isremoveaddLoading = false;

  String CustomerId;
  String CustomerName;
  String Customerphone;
  List data = [];

  getlocaldata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      CustomerId = preferences.getString(Session.customerId);
      CustomerName = preferences.getString(Session.CustomerName);
      Customerphone = preferences.getString(Session.CustomerPhoneNo);
    });
  }

  @override
  void initState() {
    getlocaldata();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () {
            print(widget.fromwhere);
            if (widget.fromwhere == "Checkout") {
              //print(widget.addressData);
              Navigator.pop(context, widget.addressData);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Defualt Address:",
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                    "${widget.addressData["AddressType"]}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/edit.png',
                                    width: 18, height: 18),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    FadeRoute(
                                        page: UpdateAddress(
                                      updateaddress: widget.addressData,
                                    )));
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                _removeAddress();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/delete.png',
                                    width: 18, height: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${CustomerName}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(
                              "${widget.addressData["AddressHouseNo"]}" +
                                  " - " +
                                  "${widget.addressData["AddressAppartmentName"]}",
                              //"44 , Rambaug Society",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(
                              "${widget.addressData["AddressStreet"]}" +
                                  " - " +
                                  "${widget.addressData["AddressLandmark"]}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(
                              "${widget.addressData["AddressCityName"]}" +
                                  " - " +
                                  "${widget.addressData["AddressPincode"]}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          Text("${Customerphone}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isremoveaddLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      appPrimaryMaterialColor),
                ),
              )
            : Container(),
      ],
    );
  }

  _removeAddress() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isremoveaddLoading = true;
        });
        FormData body = FormData.fromMap(
            {"AddressId": "${widget.addressData["AddressId"]}"});
        Services.postForSave(apiname: '/deleteAddress', body: body).then(
            (responseremove) async {
          if (responseremove.IsSuccess == true && responseremove.Data == "1") {
            widget.onremove();
            setState(() {
              isremoveaddLoading = false;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove(AddressSession.AddressId);
            prefs.remove(AddressSession.AddressHouseNo);
            prefs.remove(AddressSession.AddressAppartmentName);
            prefs.remove(AddressSession.AddressArea);
            prefs.remove(AddressSession.AddressLandmark);
            prefs.remove(AddressSession.AddressStreet);
            prefs.remove(AddressSession.AddressType);
            prefs.remove(AddressSession.AddressPincode);
            prefs.remove(AddressSession.City);
            prefs.remove(AddressSession.AddressName);
            Fluttertoast.showToast(
                msg: "Address Removed Successfully",
                gravity: ToastGravity.BOTTOM);
          }
        }, onError: (e) {
          setState(() {
            isremoveaddLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
//      showMsg("No Internet Connection.");
    }
  }
}
