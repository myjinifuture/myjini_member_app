import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

class RegistrationScreen extends StatefulWidget {
  var Mobile;

  RegistrationScreen({this.Mobile});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  var _fullnameController = new TextEditingController();
  var _emailController = new TextEditingController();
  var _phonenumberController = new TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  bool isFCMtokenLoading = false;
  String fcmToken;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLoading = false;

  @override
  void initState() {
    // _firebaseMessaging.getToken().then((token) {
      setState(() {
        _phonenumberController.text = widget.Mobile;
        // fcmToken = token;
        // print('fcm in registration----------->' + '${token}');
      // });
    });

    print(_phonenumberController.text);
    super.initState();
  }
  //  _firebaseMessaging.getToken().then((token) {
  //       setState(() {
  //         fcmToken = token;
  //       });
  //       print('----------->' + '${token}');
  //     });

  saveDataToSession(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.customerId, data["CustomerId"].toString());
    await prefs.setString(Session.CustomerName, data["CustomerName"]);
    await prefs.setString(Session.CustomerEmailId, data["CustomerEmailId"]);
    await prefs.setString(Session.CustomerPhoneNo, data["CustomerPhoneNo"]);
    Navigator.pushAndRemoveUntil(
        context, SlideLeftRoute(page: HomeScreen()), (route) => false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).size.height / 13,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text("Let's Complete's Signup Process",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        controller: _fullnameController,
                        validator: (name) {
                          if (name.length == 0) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 15),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Enter Your Name',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 43,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 2, color: Colors.grey))),
                              child: Icon(
                                Icons.perm_identity,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (email) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          print(email);
                          if (email.isEmpty) {
                            return 'Please enter email';
                          } else {
                            if (!regex.hasMatch(email))
                              return 'Enter valid Email Address';
                            else
                              return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Enter your Email',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 43,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 2, color: Colors.grey))),
                              child: Icon(
                                Icons.email,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        readOnly: true,
                        controller: _phonenumberController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 15),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 43,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 2, color: Colors.grey))),
                              child: Icon(
                                Icons.call,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0, right: 13, top: 50),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: RaisedButton(
                    color: appPrimaryMaterialColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      if (isLoading == false) _registration();
                    },
                    child: isLoading == true
                        ? CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _registration() async {
    if (_formkey.currentState.validate()) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          FormData body = FormData.fromMap({
            "CustomerName": _fullnameController.text,
            "CustomerEmailId": _emailController.text,
            "CustomerPhoneNo": _phonenumberController.text.toString(),
            "CutomerFCMToken": "${fcmToken}"
          });
          Services.postforlist(apiname: 'addCustomer', body: body).then(
              (responselist) async {
            if (responselist.length > 0) {
              saveDataToSession(responselist[0]);
            } else {
              Fluttertoast.showToast(msg: " Registration fail");
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
    } else
      Fluttertoast.showToast(msg: "Please fill all the fields");
  }
}
