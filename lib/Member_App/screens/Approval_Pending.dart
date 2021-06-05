import 'package:flutter/material.dart';

class Approval_admin extends StatefulWidget {
  @override
  _Approval_adminState createState() => _Approval_adminState();
}

class _Approval_adminState extends State<Approval_admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child:
                    Image.asset("images/waiting.png", height: 100, width: 100),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Waiting For Approval",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Center(
                    child: Text(
              "Your Account is Waiting \n      for admin Approval",
              style: TextStyle(fontSize: 20),
            ))),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Please check back later",
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
