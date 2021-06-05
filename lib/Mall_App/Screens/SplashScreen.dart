import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart';
import 'package:smart_society_new/Mall_App/Screens/LoginScreen.dart';
import 'package:smart_society_new/Mall_App/transitions/fade_route.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String phoneNumber = prefs.getString(Session.CustomerPhoneNo);
      if (phoneNumber == null) {
        Navigator.pushReplacement(context, FadeRoute(page: LoginScreen()));
      } else {
        Navigator.pushReplacement(context, FadeRoute(page: HomeScreen()));
      }
      print(phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/assets/surati_basket_logo.png'),
      ),
    );
  }
}
