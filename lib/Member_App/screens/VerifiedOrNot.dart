import 'package:flutter/material.dart';

class VerifiedOrNot extends StatefulWidget {

  Map message = {};

  VerifiedOrNot({this.message});

  @override
  _VerifiedOrNotState createState() => _VerifiedOrNotState();
}

class _VerifiedOrNotState extends State<VerifiedOrNot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Image.asset(
            'images/myginitext.png',
            height: 60,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.33,
          ),
          Center(child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${widget.message["data"]["Message"]}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
          ))
        ],
      ),
    );
  }
}
