import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationAnswerDialog extends StatefulWidget {
  var data;

  NotificationAnswerDialog(this.data);

  @override
  _NotificationAnswerDialogState createState() =>
      _NotificationAnswerDialogState();
}

class _NotificationAnswerDialogState extends State<NotificationAnswerDialog> {
  List NoticeData = new List();
  bool isLoading = false;
  String SocietyId;

  @override
  void initState() {
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.data["data"]["Message"] == "APPROVED"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('images/success.png',
                        height: 50, width: 50),
                  )
                : widget.data["data"]["Message"] == 'DENY'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/error.png',
                            height: 50, width: 50),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                        child: Image.asset('images/leaveatgate.png',
                            height: 70, width: 70),
                      ),
            widget.data["data"]["Message"] == "APPROVED"
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: <Widget>[
                        Text("APPROVED BY",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text('${widget.data["data"]["Name"]}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                              '${widget.data["data"]["WingName"]}'
                              '-'
                              '${widget.data["data"]["FlatNo"]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                : widget.data["data"]["Message"] == 'DENY'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text("DENY BY",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('${widget.data["data"]["Name"]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                  '${widget.data["data"]["WingName"]}'
                                  '-'
                                  '${widget.data["data"]["FlatNo"]}',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text("Leave My Parcel \n At Gate",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('${widget.data["data"]["Name"]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                  '${widget.data["data"]["WingName"]}'
                                  '-'
                                  '${widget.data["data"]["FlatNo"]}',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.grey[200],
                onPressed: () {
                  Get.back();
                },
                child: Text("OK",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
