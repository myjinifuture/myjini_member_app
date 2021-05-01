import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/component/LoadingComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

import 'Member_App/common/Services.dart';

class VisitorOtpScreen extends StatefulWidget {
  String Name, MobileNo, VehicleNumber, WingId, FlatNo, societyId;

  VisitorOtpScreen(this.Name, this.MobileNo, this.VehicleNumber, this.FlatNo,
      this.WingId, this.societyId);

  @override
  _VisitorOtpScreenState createState() => _VisitorOtpScreenState();
}

class _VisitorOtpScreenState extends State<VisitorOtpScreen> {
  TextEditingController controller = new TextEditingController();
  TextEditingController txtupdatemobile = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ProgressDialog pr;
  var rndnumber = "";
  bool isLoading = false;

  String updatemobile;

  bool flag = false;

  @override
  void initState() {
    _getLocaldata();
  }

  _getLocaldata() async {
    _sendVerificationCode(widget.MobileNo);
    txtupdatemobile.text = widget.MobileNo;
  }

  _addVisitorEntry() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": 0,
          "Name": widget.Name,
          "ContactNo": flag == true ? txtupdatemobile.text : widget.MobileNo,
          "WingId": widget.WingId,
          "FlatNo": widget.FlatNo,
          "SocietyId": widget.societyId
        };

        print("Add Scanned Data = ${data}");
        Services.AddVisitorEntry(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            /*  Fluttertoast.showToast(
                msg: "Visitor Added Successfully",
                textColor: Colors.black,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_LONG);*/

            Navigator.pushReplacementNamed(context, "/VisitorSuccess");

            /*  Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);*/
          } else {
            showMsgg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsgg("Try Again.");
        });
      } else
        showMsgg("No Internet Connection.");
    } on SocketException catch (_) {
      // pr.hide();
      showMsgg("No Internet Connection.");
    }
  }

  _sendVerificationCode(String Mobile) async {
    try {
      var rnd = new Random();
      setState(() {
        rndnumber = "";
      });
      for (var i = 0; i < 4; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      print(rndnumber);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.SendVerficationCode(Mobile, rndnumber).then((data) async {
          if (data.Data == "ok" && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showMsgg("Try Again.");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on otp $e");
          showMsgg("Try Again.");
          setState(() {});
        });
      } else {
        showMsgg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsgg("No Internet Connection.");
    }
  }

  showMsgg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingComponent()
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Image.asset('images/verify.png', width: 100),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Verifying Your Number !",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600))),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                  flag == true
                                      ? "We Have Sent an OTP on +91${updatemobile}"
                                      : "We Have Sent an OTP on +91${widget.MobileNo}",
                                  style: TextStyle(fontSize: 15))),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                builder: (context) => AlertDialog(
                                  content: SingleChildScrollView(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0, top: 10.0),
                                        child: Text(
                                          "Mobile Number",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.trim() == "" ||
                                                value.length < 10) {
                                              return 'Please Enter 10 Digit Mobile Number';
                                            }
                                            return null;
                                          },
                                          maxLength: 10,
                                          keyboardType: TextInputType.number,
                                          controller: txtupdatemobile,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              fillColor: Colors.grey[200],
                                              contentPadding: EdgeInsets.only(
                                                  top: 5, left: 10, bottom: 5),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.black)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.black)),
                                              hintText: 'Enter Mobile No',
                                              labelText: "Mobile",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0,
                                            left: 8,
                                            right: 8,
                                            bottom: 8.0),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              color: constant
                                                  .appPrimaryMaterialColor,
                                              textColor: Colors.white,
                                              splashColor: Colors.white,
                                              child: Text("SUBMIT",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              onPressed: () {
                                                setState(() {
                                                  flag = true;
                                                });
                                                updatemobile =
                                                    txtupdatemobile.text;
                                                _sendVerificationCode(
                                                    updatemobile);
                                                Navigator.pop(context);

                                                // Navigator.pop(context);
                                              }),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                          child: Padding(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.justify,
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ), context: context);
                          },
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("wrong number ?",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue))),
                        ),
                      ],
                    ),
/*
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: PinCodeTextField(
                        autofocus: false,
                        controller: controller,
                        highlight: true,
                        highlightColor: constant.appPrimaryMaterialColor[500],
                        defaultBorderColor: Colors.grey,
                        hasTextBorderColor:
                            constant.appPrimaryMaterialColor[500],
                        maxLength: 4,
                        onDone: (text) {
                          setState(() {
                            controller.text = text;
                          });
                          print("DONE ${controller.text}");
                        },
                        wrapAlignment: WrapAlignment.center,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 30.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 100),
                      ),
                    ),
*/
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "If you didn't receive a code ?",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              flag == true
                                  ? _sendVerificationCode(txtupdatemobile.text)
                                  : _sendVerificationCode(widget.MobileNo);
                            },
                            child: Text(" Resend",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: constant.appPrimaryMaterialColor)),
                          ),
                        ],
                      ),
                    ),
//              Padding(
//                padding: const EdgeInsets.only(top: 20.0,bottom: 10),
//                child: SizedBox(
//                  width: MediaQuery.of(context).size.width/2,
//                  height: 50,
//                  child: RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(5)),
//                    color: constant.appPrimaryMaterialColor[500],
//                    textColor: Colors.white,
//                    child: Text("Verify",
//                        style: TextStyle(
//                            fontSize: 18, fontWeight: FontWeight.w600)),
//                    onPressed: () {
//
//                      Navigator.pushReplacementNamed(context, '/HomeScreen');
//
//                    },
//                  ),
//                ),
//              ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          if (controller.text == rndnumber) {
                            // Navigator.pushNamed(context, "/VisitorSuccess");
                            _addVisitorEntry();
                          } else
                            Fluttertoast.showToast(
                                msg: "Wrong OTP..",
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red);
                        },
                        child: Container(
                          child: Center(
                            child: Text("Verify",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                              color: constant.appPrimaryMaterialColor[700],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
