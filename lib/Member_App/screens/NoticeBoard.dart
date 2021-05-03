import 'package:flutter/material.dart';

class NoticeBoard extends StatefulWidget {

  var message;

  NoticeBoard({this.message});

  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  Widget build(BuildContext context) {
    print("message");
    print(widget.message);
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
          Center(
            child: AlertDialog(
              title: widget.message["notificationType"] == "StaffEntry" || widget.message["notificationType"] == "StaffLeave"
     ? Text("${widget.message["Message"]}" + " ${widget.message["Name"]}"):Text("${widget.message["notification"]["title"]}"),
              content: widget.message["notificationType"] == "StaffEntry" || widget.message["notificationType"] == "StaffLeave"
                  ? Text("") : Text("${widget.message["notification"]["body"]}"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/HomeScreen');
                  },
                  child: Text("okay"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
