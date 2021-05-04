import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/Providers/CartProvider.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/RegistrationScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/TearmsLogin.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';

import 'VerificationScreen.dart';

class LoginScreen extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
LoginScreen({this.navigatorKey});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _loginController = new TextEditingController();
  final _formkey = new GlobalKey<FormState>();

  bool isLoading = false;
  bool ischeckloading = false;
  bool isFCMtokenLoading = false;
  String fcmToken;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String OTPstatus = "1";

  @override
  void initState() {
    // _firebaseMessaging.getToken().then((token) {
    //   setState(() {
    //     fcmToken = token;
    //   });
    //   print("loginscreen");
    //   print('FCM----------->' + '${token}');
    // });
  }

  saveDataToSession(var data) async {
    log("$data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.customerId, data["CustomerId"].toString());
    await prefs.setString(Session.CustomerName, data["CustomerName"]);
    await prefs.setString(Session.CustomerEmailId, data["CustomerEmailId"]);
    await prefs.setString(Session.CustomerPhoneNo, data["CustomerPhoneNo"]);
    Navigator.pushAndRemoveUntil(
        context, SlideLeftRoute(page: HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).size.height / 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SIGN IN / SIGN UP",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      children: <Widget>[
                        Text("Welcome to",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Surti Basket",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: appPrimaryMaterialColor,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Enter Your Mobile Number to Continue",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 12, right: 12),
                child: TextFormField(
                  controller: _loginController,
                  validator: (phone) {
                    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (phone.length == 0) {
                      return 'Please enter mobile number';
                    } else if (!regExp.hasMatch(phone)) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 15),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: const EdgeInsets.all(15),
                    hintText: '10 Digits Mobile Number',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 45,
                        decoration: BoxDecoration(
                            border: Border(
                                right:
                                    BorderSide(width: 2, color: Colors.grey))),
                        child: Icon(
                          Icons.call,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
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
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "By continuing i accept the",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TearmsLogin(
                                  tearmsData: provider.settingList[0]
                                      ["SettingTermsConditionURL"],
                                )),
                      );
                      //Navigator.of(context).pushNamed('/TearmsConditionScreen');
                    },
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 13.0, right: 13, bottom: 20, top: 50),
              height: 45,
              child: RaisedButton(
                color: appPrimaryMaterialColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () {
                  if (isLoading == false) {
                    // _login();
                  }
                },
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _login() async {
    if (_formkey.currentState.validate()) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          FormData body = FormData.fromMap({
            "CustomerPhoneNo": _loginController.text,
            "CutomerFCMToken": "${fcmToken}"
          });
          Services.postforlist(apiname: 'signIn', body: body).then(
              (responselist) async {
            setState(() {
              isLoading = false;
            });
            if (responselist.length > 0) {
              if (Platform.isIOS) {
                if (OTPstatus == "0") {
                  saveDataToSession(responselist[0]);
                } else {
                /*  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => new VerificationScreen(
                            mobile: _loginController.text,
                            logindata: responselist[0],
                            onLoginSuccess: () {
                              saveDataToSession(responselist[0]);
                            },
                          )));*/
                }
              } else {
               /* Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => new VerificationScreen(
                          mobile: _loginController.text,
                          logindata: responselist[0],
                          onLoginSuccess: () {
                            saveDataToSession(responselist[0]);
                          },
                        )));*/
              }
            } else {
              if (Platform.isIOS) {
                if (OTPstatus == "0") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => new RegistrationScreen(
                            Mobile: _loginController.text,
                          )));
                } else {
                /*  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => new VerificationScreen(
                            mobile: _loginController.text,
                            onLoginSuccess: () {
                              saveDataToSession(responselist[0]);
                            },
                          )));*/
                }
              } else {
               /* Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => new VerificationScreen(
                          mobile: _loginController.text,
                          onLoginSuccess: () {
                            saveDataToSession(responselist[0]);
                          },
                        )));*/
              }
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
      Fluttertoast.showToast(msg: "Please fill mobile number");
    }
  }

  /*_updateFCMtoken() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isFCMtokenLoading = true;
        });
        var body = {
          "CustomerPhoneNo": "${_loginController}",
          "CutomerFCMToken": "${fcmToken}"
        };

        Services.postForSave(apiname: 'signIn', body: body).then(
            (response) async {
          if (response.IsSuccess == true && response.Data == "1") {
            setState(() {
              isFCMtokenLoading = false;
            });
            log("----------------------------------->response");
            // widget.onLoginSuccess();
          } else {
            Fluttertoast.showToast(msg: "something went wrong");
          }
        }, onError: (e) {
          setState(() {
            isFCMtokenLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }*/

  /*_OTPStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ischeckloading = true;
        });
        Services.postForSave(apiname: 'getAPIIos').then((responseList) async {
          setState(() {
            ischeckloading = false;
          });

          if (responseList.IsSuccess == true) {
            setState(() {
              OTPstatus = responseList.Data.toString();
            });
            print(OTPstatus);
          }
        }, onError: (e) {
          setState(() {
            ischeckloading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }*/
}
