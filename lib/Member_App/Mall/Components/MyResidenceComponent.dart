import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyResidenceComponent extends StatefulWidget {
  var resData;
  int index;
  Function onDeleteProperty;

  MyResidenceComponent({this.resData, this.index,this.onDeleteProperty});

  @override
  _MyResidenceComponentState createState() => _MyResidenceComponentState();
}

class _MyResidenceComponentState extends State<MyResidenceComponent> {
  String flat;
  String wing;
  bool isLoading = false;

  @override
  void initState() {
    getFlatAndWingDetails();
  }

  getFlatAndWingDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      flat = preferences.getString(cnst.Session.FlatNo);
      wing = preferences.getString(cnst.Session.Wing);
    });
  }

  removeFromProperty() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(cnst.Session.Member_Id);
        setState(() {
          isLoading = true;
        });
        var data = {
          "memberId": memberId,
          "societyId": widget.resData["Property"][0]["SocietyData"][0]["_id"],
          "wingId": widget.resData["Property"][0]["WingData"][0]["_id"],
          "flatId": widget.resData["Property"][0]["_id"],
        };
        Services.responseHandler(
                apiName: "member/removeFromProperty", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data.toString()=='1'&&data.IsSuccess==true) {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Property deleted Successfully!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              widget.onDeleteProperty();
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("flat and wing ${wing}-${flat}");
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("MYJINI"),
              content:
                  new Text("Are you sure to delete this record permanently ?"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    removeFromProperty();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          decoration: BoxDecoration(
            color: appPrimaryMaterialColor[50],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_work,
                  size: 40,
                  color: appPrimaryMaterialColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.resData["Property"][0]['SocietyData'][0]['Name']}",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.resData["Property"][0]["WingData"][0]['wingName']}-${widget.resData["Property"][0]['flatNo']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          (widget.resData["Property"][0]['flatNo'] == flat &&
                                  widget.resData["Property"][0]["WingData"][0]
                                          ['wingName'] ==
                                      wing)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "ACTIVE",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
