import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';

class PinCodePopup extends StatefulWidget {
  @override
  _PinCodePopupState createState() => _PinCodePopupState();
}

class _PinCodePopupState extends State<PinCodePopup> {
  TextEditingController pincode = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Enter Pincode",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
/*
          Padding(
            padding: const jEdgeInsets.only(top: 10.0, bottom: 15.0),
            child: PinCodeTextField(
              controller: pincode,
              wrapAlignment: WrapAlignment.center,
              autofocus: false,
              pinBoxRadius: 6,
              highlight: true,
              pinBoxHeight: 35,
              pinBoxWidth: 35,
              highlightColor: appPrimaryMaterialColor,
              defaultBorderColor: Colors.grey,
              hasTextBorderColor: appPrimaryMaterialColor,
              maxLength: 6,
              pinBoxDecoration:
                  ProvidedPinBoxDecoration.defaultPinBoxDecoration,
              pinTextStyle: TextStyle(fontSize: 14.0),
              pinTextAnimatedSwitcherTransition:
                  ProvidedPinBoxTextAnimation.scalingTransition,
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
            ),
          ),
*/
/*
          PinCodeTextField(
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            length: 6,
            keyboardType: TextInputType.number,
            obscureText: false,
            // obscuringCharacter: '*',
            animationType: AnimationType.fade,
            onCompleted: (pin){
              // code=pin;
              print("completed");
            },
          ),
*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
                color: appPrimaryMaterialColor,
                onPressed: () {
                  Navigator.of(context).pop();;
                },
                child: Text("OK", style: TextStyle(color: Colors.white))),
          )
        ],
      ),
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
                responseremove.Data == "1") {
              setState(() {
                isLoading = false;
              });
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
    } else {
      Fluttertoast.showToast(msg: "Please Enter PinCode");
    }
  }
}
