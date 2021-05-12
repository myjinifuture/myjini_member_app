import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class getPendingApprovals extends StatefulWidget {
  @override
  _getPendingApprovalsState createState() => _getPendingApprovalsState();
}

class _getPendingApprovalsState extends State<getPendingApprovals> {

  List pendingApprovals = [];

  @override
  void initState() {
    getLocaldata();
    _getVisitor("");
  }

  String societyId,memberId;
  bool isLoading = true;
  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
      memberId = prefs.getString(Session.Member_Id);
    });
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);              },
            ),
          ],
        );
      },
    );
  }

  _getVisitor(String done) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : societyId
          // "societyId" : "60630c2c86c69d00229fe13d"
        };
       if(done != "done") {
         setState(() {
           isLoading = true;
         });
       }
        Services.responseHandler(apiName : "admin/getMemberApprovalList", body :data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              pendingApprovals = data.Data;
              if(done != "done") {
                isLoading = false;
              }
            });
          } else {
            setState(() {
              pendingApprovals = data.Data;
              if(done != "done") {
                isLoading = false;
              }
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          if(done !="done") {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _memberApproval(bool isverified,String memberid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "memberId" : memberid,
          "societyId" : societyId,
          "isVerify" : isverified,
          "deviceType" : Platform.isAndroid ? "Android" : "IOS",
          "adminId" : memberId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName : "admin/memberApproval", body :data).then((data) async {
          if (data.Data.toString()=="1") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Approved!!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
            });
            _getVisitor("done");
          }else if (data.Data.toString()=="0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Rejected!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
            });
            _getVisitor("done");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Approvals"),
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pushReplacementNamed(context, "/HomeScreen");
        //     }),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
          itemCount: pendingApprovals.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
              child: new Container(
                color: Colors.white,
                child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 6.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${pendingApprovals[index]["Name"]}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700])),
                                      Row(
                                        children: <Widget>[
                                          Text("Flat No:"),
                                          Text("${pendingApprovals[index]["FlatData"][0]["flatNo"]}"),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          RaisedButton(
                                            color: Colors.white,
                                            child:  Text('Approve',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                              ),
                                            ),
                                            onPressed: () => _memberApproval(true,pendingApprovals[index]["_id"]),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          RaisedButton(
                                            color: Colors.white,
                                            child:  Text('Reject',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                              ),
                                            ),
                                            onPressed: () => _memberApproval(false,pendingApprovals[index]["_id"]),
                                          ),
                                        ],
                                      ),
                                      Text("${pendingApprovals[index]["ContactNo"]}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                    ),
              ),
            );
          }),

    );
  }
}
