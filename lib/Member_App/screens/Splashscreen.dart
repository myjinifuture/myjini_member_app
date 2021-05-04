import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/HomeScreen.dart';
import 'package:smart_society_new/Member_App/screens/LoginScreen.dart';

class Splashscreen extends StatefulWidget {
  bool isAppOpenedAfterNotification;
  GlobalKey<NavigatorState> navigatorKey;

  Splashscreen({this.isAppOpenedAfterNotification,this.navigatorKey});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    debugPrint("splashscreen called");
    debugPrint(widget.isAppOpenedAfterNotification.toString());
    Timer(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(constant.Session.ProfileUpdateFlag, "true");
      String MemberId = prefs.getString(constant.Session.Member_Id);
      String Verified = prefs.getString(constant.Session.IsVerified);
      FirebaseFirestore.instance.collection("DYNAMIC-URL-MYJINI-MEMBER-APP-TEST")
          .get()
          .then((value) {
        // constant.NODE_API = "https://myjini.herokuapp.com/";
        constant.NODE_API = "${value.docs[0]["DYNAMIC-URL-MYJINI-MEMBER-APP-TEST"]}";
        print("constant.NODE_API");
        print(constant.NODE_API);
        if (MemberId != null && MemberId != ""){
          Navigator.pushReplacementNamed(context, '/HomeScreen');
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomeScreen(navigatorKey: widget.navigatorKey,isAppOpenedAfterNotification:widget.isAppOpenedAfterNotification)));
        }
        else {
          Navigator.pushReplacementNamed(context, '/LoginScreen');
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => LoginScreen(navigatorKey: widget.navigatorKey)));
          // Navigator.pushReplacementNamed(context, '/LoginScreen');
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'images/background.png',
                fit: BoxFit.fill,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, right: 40, left: 60),
                child: Image.asset(
                  'images/gini.png',
                  height: MediaQuery.of(context).size.height / 1.6,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/myginitext.png',
                  height: 100,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
