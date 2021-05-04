/*
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/Common/services.dart';
import 'package:smart_society_new/Mall_App/Screens/RegistrationScreen.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  var mobile, logindata;
  Function onLoginSuccess;

  VerificationScreen({this.mobile, this.logindata, this.onLoginSuccess});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isLoading = false;
  bool isFCMtokenLoading = false;
  String rndnumber;
  TextEditingController txtOTP = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _verificationId;
  String fcmToken;

  @override
  void initState() {
    _onVerifyCode();
    _firebaseMessaging.getToken().then((token) {
      setState(() {
        fcmToken = token;
      });
      print('----------->' + '${token}');
    });
  }

  void _onVerifyCode() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {
          print(value.user);
          if (widget.logindata != null) {
            log("OTP sent successfully");
            // _updateFCMtoken();
            widget.onLoginSuccess();
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => RegistrationScreen(
                          Mobile: widget.mobile,
                        )),
                (route) => false);
          }
        } else {
          Fluttertoast.showToast(msg: "Error validating OTP, try again");
        }
      }).catchError((error) {
        log("->>>" + error.toString());
        Fluttertoast.showToast(msg: " $error");
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Fluttertoast.showToast(msg: authException.message);
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobile}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void _onFormSubmitted() async {
    setState(() {
      isLoading = true;
    });
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: txtOTP.text);
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then(( value) {
      setState(() {
        isLoading = false;
      });
      if (value.user != null) {
        print(value.user);
        if (widget.logindata != null) {
          widget.onLoginSuccess();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => RegistrationScreen(
                        Mobile: widget.mobile,
                      )),
              (route) => false);
        }
      } else {
        Fluttertoast.showToast(msg: "Invalid OTP");
      }
    }).catchError((error) {
      log(error.toString());
      Fluttertoast.showToast(msg: "$error Something went wrong");
    });
  }

*/
/*
  saveDataToSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        Session.customerId, widget.logindata["CustomerId"].toString());
    await prefs.setString(
        Session.CustomerName, widget.logindata["CustomerName"]);
    await prefs.setString(
        Session.CustomerEmailId, widget.logindata["CustomerEmailId"]);
    await prefs.setString(
        Session.CustomerPhoneNo, widget.logindata["CustomerPhoneNo"]);

    Navigator.pushAndRemoveUntil(
        context, SlideLeftRoute(page: HomeScreen()), (route) => false);
  }
*//*


*/
/*
  _sendOTP() async {
    var rnd = new Random();
    setState(() {
      rndnumber = "";
    });
    for (var i = 0; i < 4; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print(rndnumber);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        FormData body = FormData.fromMap({
          "PhoneNo": "${widget.mobile}",
          "OTP": "$rndnumber",
        });
        Services.postForSave(apiname: 'sendOTP', body: body).then(
            (response) async {
          if (response.IsSuccess == true && response.Data == "1") {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "OTP send successfully", gravity: ToastGravity.BOTTOM);
          } else {
            Fluttertoast.showToast(
                msg: "OTP not Send", gravity: ToastGravity.BOTTOM);
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
*//*


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 21),
            onPressed: () {
              Navigator.of(context).pop();;
            }),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top + 2,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Enter Verification Code",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text("We have sent the verification code on",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text("${widget.mobile}"),
                  ),
                ],
              ),
            ),
*/
/*
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: PinCodeTextField(
                      controller: txtOTP,
                      autofocus: false,
                      wrapAlignment: WrapAlignment.center,
                      highlight: true,
                      pinBoxHeight: 38,
                      pinBoxWidth: 38,
                      pinBoxRadius: 8,
                      highlightColor: Colors.grey,
                      defaultBorderColor: Colors.grey,
                      hasTextBorderColor: Colors.black,
                      maxLength: 6,
                      pinBoxDecoration:
                          ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      pinTextStyle: TextStyle(fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Text("Enter verification code you received on SMS",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 13.0, right: 13, top: 30),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: RaisedButton(
                        color: appPrimaryMaterialColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {
                          _onFormSubmitted();
                        },
                        child: isLoading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.5,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                "Verify",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _onVerifyCode();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Text("Resend OTP",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
*//*

          ],
        ),
      ),
    );
  }

  _updateFCMtoken() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isFCMtokenLoading = true;
        });
        var body = {"mobile": "${widget.mobile}", "fcmToken": "${fcmToken}"};

        Services.postForSave(apiname: 'signIn', body: body).then(
            (response) async {
          if (response.IsSuccess == true && response.Data == "1") {
            setState(() {
              isFCMtokenLoading = false;
            });
            log("----------------------------------->response");
            widget.onLoginSuccess();
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
  }
}
*/
