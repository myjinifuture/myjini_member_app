import 'package:flutter/material.dart';

class WaitingForVideoCall extends StatefulWidget {
  @override
  _WaitingForVideoCallState createState() => _WaitingForVideoCallState();
}

class _WaitingForVideoCallState extends State<WaitingForVideoCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text("Ringing......",
          style: TextStyle(
            color: Colors.white,
          ),
          ),
        ],
      ),
    );
  }
}
