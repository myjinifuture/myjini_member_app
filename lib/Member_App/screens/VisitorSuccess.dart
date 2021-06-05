import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

class VisitorSuccess extends StatefulWidget {
  @override
  _VisitorSuccessState createState() => _VisitorSuccessState();
}

class _VisitorSuccessState extends State<VisitorSuccess> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/LoginScreen", (Route<dynamic> route) => false);
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          color: cnst.appPrimaryMaterialColor),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 70.0),
                          child: Text(
                            "THANK YOU !",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Container(
                        // height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 3.5,
                        //  height: MediaQuery.of(context).size.height / 2.4,
                        //  width: MediaQuery.of(context).size.width / 1.2,
                        child: Card(
                          elevation: 7,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Image.asset(
                                  "images/correctsign.png",
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, top: 30.0),
                                child: Text(
                                  "REGISTRATION COMPLETED !",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.only(top: 30),
                      height: 50,
                      width:
                      MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        color: cnst.appPrimaryMaterialColor,
                      ),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(9.0)),
                        onPressed: () {
                          /*   Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        "/OTPVerification",
                                        (Route<dynamic> route) => false);*/
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/LoginScreen", (Route<dynamic> route) => false);
                          // _photographerLogin();
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
