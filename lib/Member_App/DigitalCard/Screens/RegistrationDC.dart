import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class RegistrationDC extends StatefulWidget {
  @override
  _RegistrationDCState createState() => _RegistrationDCState();
}

class _RegistrationDCState extends State<RegistrationDC> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtCompany = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtRegCode = new TextEditingController();

  bool isLoading = false;

  MemberSignUp() async {
    if (txtName.text != '' &&
        txtMobile.text != '' &&
        txtCompany.text != '' &&
        txtEmail.text != '') {
      setState(() {
        isLoading = true;
      });

      String referCode =
          txtName.text.substring(0, 3).toUpperCase() + GetRandomNo(5);

      var data = {
        'type': 'signup',
        'name': txtName.text,
        'mobile': txtMobile.text,
        'company': txtCompany.text,
        'email': txtEmail.text,
        'imagecode': "",
        'myreferCode': referCode,
        'regreferCode': txtRegCode.text
      };

      Future res = Services.MemberSignUp(data);
      res.then((data) async {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
          Fluttertoast.showToast(
            msg: "Data Saved",
            backgroundColor: Colors.green,
            gravity: ToastGravity.TOP,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //Navigator.pushNamed(context, "/MobileLogin");
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Something Went Wrong",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  String GetRandomNo(int length) {
    String UniqueNo = "";
    var rng = new Random();
    for (var i = 0; i < length; i++) {
      UniqueNo += rng.nextInt(10).toString();
    }
    return UniqueNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Your Digital Card"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: txtName,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: "Name"),
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: txtMobile,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.phone_android),
                            counterText: "",
                            hintText: "Mobile"),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: txtCompany,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.business_center),
                            hintText: "Company"),
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: txtEmail,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.local_post_office),
                            hintText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: txtRegCode,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.device_hub),
                            hintText: "Referral Code"),
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: constant.appPrimaryMaterialColor,
                            textColor: Colors.white,
                            child: Text("Submit",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              MemberSignUp();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
