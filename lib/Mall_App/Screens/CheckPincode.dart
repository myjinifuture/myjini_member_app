import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';

class CheckPincode extends StatefulWidget {
  Function PlaceOrder;
  CheckPincode({this.PlaceOrder});
  @override
  _CheckPincodeState createState() => _CheckPincodeState();
}

class _CheckPincodeState extends State<CheckPincode> {
  TextEditingController pincode = new TextEditingController();
  bool isLoading = false;
  final _formkey = new GlobalKey<FormState>();
  String responseMessage = "";
  bool isPincodeValid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isPincodeValid == true) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${responseMessage}",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.black54,
              ),
              Text(
                "Enter Pincode",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
        Form(
          key: _formkey,
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: pincode,
                    validator: (phone) {
                      if (phone.length != 6) {
                        return 'Please enter Valid Pincode';
                      }
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 15),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      counterText: "",
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Enter Delivery Pincode',
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              isLoading == true
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 43,
                        child: FlatButton(
                            color: appPrimaryMaterialColor,
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                _checkPinCode();
                              }
                            },
                            child: Text("Check".toUpperCase(),
                                style: TextStyle(color: Colors.white))),
                      ),
                    )
            ],
          ),
        )
      ],
    );
  }

  _checkPinCode() async {
    if (pincode.text != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          FormData body = FormData.fromMap({"PincodeNo": pincode.text});
          Services.postForSave(apiname: 'checkPincode', body: body).then(
              (responseremove) async {
            if (responseremove.IsSuccess == true &&
                responseremove.Data != "0") {
              setState(() {
                isLoading = false;
                isPincodeValid = false;
              });
              Navigator.pop(context);
              widget.PlaceOrder();
            } else {
              setState(() {
                isPincodeValid = true;
                responseMessage = responseremove.Message;
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
    } else {
      Fluttertoast.showToast(msg: "Please Enter PinCode");
    }
  }
}
