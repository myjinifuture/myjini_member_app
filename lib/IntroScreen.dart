import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/VisitorRegister.dart';

import 'Member_App/common/Services.dart';


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String barcode = "";
  DateTime currentBackPressTime;
  ProgressDialog pr;
  bool isLoading = true;
  List list = [];
  String societyId;


  @override
  void initState() {
   // _getSocietyName();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      print("QR Text: ${barcode}");
      //&& qrtext.length > 2

      if (qrtext != null) {
        setState(() {
          societyId = qrtext[0].toString();
          this.barcode = barcode;
        });
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
           // _advertiseScan();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VisitorRegister(societyId)));

          }
        } on SocketException catch (_) {

          showMsg("No Internet Connection.");
        }
        setState(() => this.barcode = barcode);
      } else {
        showMsg("Try Again.");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

/*  _getSocietyName() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //  String id = societyId.toString();
        Future res = Services.GetSocietyName(societyId);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list = data;
              isLoading = false;
            });
            print("GetSocietyName => " + list.toString());
          } else {
            setState(() {
              list = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetSocietyName Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }*/

  showMsg(String msg, {String title = 'MYJINI'}) {
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
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                /*Image.asset("images/Logo.png",
                    width: MediaQuery.of(context).size.width, fit: BoxFit.fill),*/
                Padding(
                  padding: const EdgeInsets.only(top:16.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.22,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('images/applogo.png',
                                  width: 90, height: 90),
                            ],
                          ),
                        ),
                        Text("Welcome User",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: cnst.appPrimaryMaterialColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                "MYJINI App is the online technology for housing & commercial societies which provides a unique experience in Community.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Continue as",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 1.2,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/LoginScreen");
                },
                child: Text(
                  "Member",
                  style: TextStyle(color: Colors.white,fontSize: 17),
                ),
                color: cnst.appPrimaryMaterialColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 1.2,
              child: RaisedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, "/VisitorRegister");
                  scan();
                },
                child: Text("Visitor", style: TextStyle(color: Colors.white,fontSize: 17)),
                color: cnst.appPrimaryMaterialColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
            ),
          ],
        ),
      ),
    );
  }
}
