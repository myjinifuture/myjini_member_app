import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffComponentBywing extends StatefulWidget {
  Function onDelete;
  var visitorData;
  int index;

  StaffComponentBywing({this.visitorData, this.index, this.onDelete});

  @override
  _StaffComponentBywingState createState() => _StaffComponentBywingState();
}

class _StaffComponentBywingState extends State<StaffComponentBywing> {
  // setTime(String datetime) {
  //   String hour = "";
  //   var time = datetime.split(" ");
  //   var t = time[1].split(":");
  //   if (int.parse(t[0]) > 12) {
  //     hour = (int.parse(t[0]) - 12).toString();
  //     return "${hour}:${t[1]} PM";
  //   } else {
  //     hour = int.parse(t[0]).toString();
  //     return "${hour}:${t[1]} AM";
  //   }
  // }
  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Delete this Staff?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                deleteStaff(widget.visitorData['_id'].toString());
                Navigator.of(context).pop();
                // widget.onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  deleteStaff(String staffId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // String SocietyId = preferences.getString(Session.SocietyId);
        // for (int i = 0; i < wingsList.length; i++) {
        //   if (selectedWing == wingsList[i]["wingName"]) {
        //     selectedWingId = wingsList[i]["_id"];
        //   }
        // }
        var data = {"staffId": staffId};
        Services.responseHandler(apiName: "admin/deleteStaff", body: data).then(
            (data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            print("data.Data");
            print(data.Data);
            Fluttertoast.showToast(
                msg: "Staff deleted Successfully!!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("data:");
    print(widget.visitorData);
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 450),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: EdgeInsets.only(top: 4, right: 8, left: 8, bottom: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.only(right: 10, top: 7, left: 7, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                      child: widget.visitorData["staffImage"] != null &&
                              widget.visitorData["staffImage"] != ""
                          ? FadeInImage.assetNetwork(
                              placeholder: '',
                              image: Image_Url +
                                  "${widget.visitorData["staffImage"]}",
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill)
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: cnst.appPrimaryMaterialColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: Text(
                                  "${widget.visitorData["Name"].toString().substring(0, 1).toUpperCase()}",
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.white),
                                ),
                              ),
                            )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '${widget.visitorData["Name"]}'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              widget.visitorData["staffCategory"] != null
                                  ? Text(
                                      '${widget.visitorData["staffCategory"]}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15))
                                  : Text('Watchman'.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "Wing-" '${widget.visitorData["WingData"][0]["wingName"]}'
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Text(
                                '${widget.visitorData["FlatData"][0]["flatNo"]}'
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                    onPressed: () {
                      _showConfirmDialog();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
