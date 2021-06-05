import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/ComplaintComponent.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/ComplaintScreen.dart';

class Complaints extends StatefulWidget {
  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  List _complaintData = [];
  bool isLoading = false;

  @override
  void initState() {
    _getLocaldata();
  }

  String MemberId;
  String societyId;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MemberId = prefs.getString(Session.Member_Id);
    societyId = prefs.getString(Session.SocietyId);
    _getComplaints();
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

  _getComplaints() async {
    try {
      _complaintData.clear();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyId": societyId
        };
        Services.responseHandler(apiName: "admin/getAllComplain",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              // _complaintData = data.Data;
              for(int i=data.Data.length-1;i>=0;i--){
                _complaintData.add(data.Data[i]);
              }
            });
            // _complaintData.reversed;
          } else {
            setState(() {
              isLoading = false;
              _complaintData = data.Data;
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

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complaints",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, "/Dashboard");
        //   },
        // ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: isLoading
            ? LoadingComponent()
            : _complaintData.length > 0
                ? AnimationLimiter(
                    child: ListView.builder(
                      itemCount: _complaintData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ComplaintComponent(
                            _complaintData[index], index, (type) {
                          if (type == "false")
                            _getComplaints();
                          else if (type == "loading")
                            setState(() {
                              isLoading = true;
                            });
                        });
                      },
                    ),
                  )
                : Center(child: Text('No Data Found'),),
      ),

    );
  }
}
