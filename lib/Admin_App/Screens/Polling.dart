import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Component/PollingComponent.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import '../../Member_App/./common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as admin;

class Polling extends StatefulWidget {
  @override
  _PollingState createState() => _PollingState();
}

class _PollingState extends State<Polling> {
  List _pollingList = [];
  bool isLoading = false;
  String totalMembersInSociety;

  @override
  void initState() {
    getLocaldata();
  }

  String societyId,memberId,wingId;
  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(admin.Session.SocietyId);
    memberId = prefs.getString(Session.Member_Id);
    wingId = prefs.getString(Session.WingId);
    _getPollingData();
  }

  _getPollingData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : societyId,
          "wingId" : wingId
          // "memberId" : memberId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getAllPollingQuestion_v1",body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length-1;i++){
                if(data.Data[i]["PollOptions"].length > 0) {
                  _pollingList.add(data.Data[i]);
                }
              }
              print("_pollingList ar starting");
              print(_pollingList);
              totalMembersInSociety = data.Data[data.Data.length-1]["MemberCount"].toString();
              isLoading = false;
            });
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

  List responseToPolling = [];
  _getResponseOfPolling(String pollingQuestionId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "pollQuestionId" : pollingQuestionId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getResponseOfPoll",body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              responseToPolling = data.Data;
              isLoading = false;
            });
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(_pollingList.length);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Polling",
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
      body: isLoading
          ? LoadingComponent()
          : _pollingList.length > 0
              ? AnimationLimiter(
                  child: ListView.builder(
                    itemCount: _pollingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("_pollingList123");
                      print(_pollingList[index]["PollOptions"]);
                      // _getResponseOfPolling(_pollingList[index]["_id"]);
                      return PollingComponent(_pollingList, index,totalMembersInSociety);
                    },
                  ),
                )
              : Center(child: Text('No Data Found'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/AddPolling');
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: cnst.appPrimaryMaterialColor,
      ),
    );
  }
}
