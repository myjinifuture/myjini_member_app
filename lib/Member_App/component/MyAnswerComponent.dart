import 'package:flutter/material.dart';



class MyAnswerComponent extends StatefulWidget {
  var PollingData;
  int index;

  MyAnswerComponent(this.PollingData,this.index);
  @override
  _MyAnswerComponentState createState() => _MyAnswerComponentState();
}

class _MyAnswerComponentState extends State<MyAnswerComponent> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:8.0,top: 5.0,bottom: 8.0,right:6.0),
          child: Container(
            decoration:  BoxDecoration(
                color: Colors.grey[100],
                borderRadius:
                BorderRadius.all(Radius.circular(6.0))),
            child:Padding(
              padding: const EdgeInsets.only(left:15.0,top: 12,bottom: 12),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'images/success.png',
                    width: 20,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "${widget.PollingData["PollOptions"][widget.index]["pollOption"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
