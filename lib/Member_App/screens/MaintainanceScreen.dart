import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class Maintainance extends StatefulWidget {
  @override
  _MaintainanceState createState() => _MaintainanceState();
}

class _MaintainanceState extends State<Maintainance> {
  List MaintainanceData = new List();
  bool isLoading = false;
  String Member_Id;

  @override
  void initState() {
    //GetMaintainanceData();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Member_Id = prefs.getString(constant.Session.Member_Id);
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}\n${setMonth(DateTime.parse(date))}"
              .toString();
    }
    return final_date;
  }

  setMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
        break;
      case 2:
        return "Feb";
        break;
      case 3:
        return "Mar";
        break;
      case 4:
        return "Apr";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "Jun";
        break;
      case 7:
        return "Jul";
        break;
      case 8:
        return "Aug";
        break;
      case 9:
        return "Sep";
        break;
      case 10:
        return "Oct";
        break;
      case 11:
        return "Nov";
        break;
      case 12:
        return "Dec";
        break;
    }
  }

  GetMaintainanceData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetEmergency().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              MaintainanceData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _CardPayment(BuildContext context, int index) {
    return Card(
      child: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
                  child: Text(
                    "Paid Date",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    "13\n2019",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "PaymentMode: ",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        "Cheque",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Ref No: ",
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            "056895364",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    child: Text(
                  "₹ 2000/- ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/HomeScreen");
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/HomeScreen");
                }),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            title: Text(
              "Maintainence",
              style: TextStyle(fontSize: 17),
            ),
          ),
          body: Container(
            child: Center(
              child: Text('Work In Progress'),
            ),
          )
          /*   Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,top: 6.0),
              child: Text("Transaction History",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black54),),
            ),
            Expanded(child: ListView.builder(itemBuilder: _CardPayment,itemCount: 10,shrinkWrap: true))
          ],
        )*/
          ),
    );
  }
}
