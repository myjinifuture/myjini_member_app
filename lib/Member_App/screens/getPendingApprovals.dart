import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import '../common/Services1.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class getPendingApprovals extends StatefulWidget {
  @override
  _getPendingApprovalsState createState() => _getPendingApprovalsState();
}

class _getPendingApprovalsState extends State<getPendingApprovals> {

  TextEditingController _txtMobilePendingSearch = TextEditingController();
  TextEditingController _txtMobileApprovalsSearch = TextEditingController();
  List pendingApprovals = [];
  List pendingFilteredList = [];

  List approvedList = [];
  List approvedFilteredList = [];

  @override
  void initState() {
   setState(() {
     getLocaldata();
     _getVisitor("");
     _getMemberApprovedData("");
   });
  }

  filteredSearch(String value) {
    setState(() {
      pendingFilteredList = pendingApprovals
          .where(
              (name) => name["ContactNo"].toString().contains(value.toString()))
          .toList();
      approvedFilteredList = approvedList
          .where(
              (name) => name["ContactNo"].toString().contains(value.toString()))
          .toList();
    });
  }

  String societyId, memberId, wingId, flatId;
  bool isLoading = true;

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
      memberId = prefs.getString(Session.Member_Id);
      wingId = prefs.getString(Session.WingId);
      flatId = prefs.getString(Session.FlatId);
    });
  }

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);
              },
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
          "societyId": societyId,
          "wingId": wingId,
          // "societyId" : "60630c2c86c69d00229fe13d"
        };
        if (done != "done") {
          setState(() {
            isLoading = true;
          });
        }
        Services.responseHandler(
                apiName: "admin/getMemberApprovalList_v1", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              pendingApprovals = data.Data;
              print(pendingApprovals);
              pendingFilteredList = pendingApprovals;
              print(pendingFilteredList);
              if (done != "done") {
                isLoading = false;
              }
            });
          } else {
            setState(() {
              pendingApprovals = data.Data;
              if (done != "done") {
                isLoading = false;
              }
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          if (done != "done") {
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

  _memberApproval(
      bool isverified, String memberid, String wing, String flat) async {
    print("Mebber Pending +++++++++++++++++++");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "memberId": memberid,
          "societyId": societyId,
          "isVerify": isverified,
          "deviceType": Platform.isAndroid ? "Android" : "IOS",
          "adminId": memberId,
          "wingId": wing,
          "flatId": flat
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/memberApproval_v1", body: data)
            .then((data) async {
          if (data.Data.toString() == "1") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Approved!!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
              _getVisitor("done");
            });
          } else if (data.Data.toString() == "0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Rejected!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
              _getVisitor("done");
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

  _getMemberApprovedData(String done) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": societyId,
        };
        print("print Data....");
        print(data);
        Services.responseHandler(
                apiName: "admin/getMemberApprovedList", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              print("print approvedList...");
              print(approvedList.length);
              approvedList = data.Data;
              approvedFilteredList = approvedList;
              if (done != "done") {
                isLoading = false;
              }
            });
          } else {
            print("Somthing went Wrong Please Try Again");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          if (done != "done") {
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

  _memberApprovalsReject(
      bool isverified, String memberid, String wing, String flat) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "memberId": memberid,
          "societyId": societyId,
          "isVerify": isverified,
          "deviceType": Platform.isAndroid ? "Android" : "IOS",
          "adminId": memberId,
          "wingId": wing,
          "flatId": flat
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/memberApproval", body: data)
            .then((data) async {
          if (data.Data.toString() == "1") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Approved!!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
              _getMemberApprovedData("done");
            });
            //setState(() {
            //  _getMemberApprovedData("done");
           // });
          } else if (data.Data.toString() == "0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Member Rejected!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              isLoading = false;
            });
            setState(() {
              _getMemberApprovedData("done");
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Pending"),
              Tab(
                text: "Approved",
              ),
            ],
          ),
          title: Text("Pending Approvals"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);
              }),
        ),
        body: TabBarView(
          children: [Pending(), Approved()],
        ),
      ),
    );
  }

  Pending() {
    //_getVisitor("done");
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 18,
                    child: TextField(
                      controller:_txtMobilePendingSearch,
                      cursorColor: Colors.deepPurple,
                      onChanged: filteredSearch,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Search By Phone...",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pendingFilteredList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10.0, right: 10, top: 5),
                            child: new Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  "${pendingFilteredList[index]["Name"]}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700])),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      "${pendingFilteredList[index]["WingData"][0]["wingName"]}" +
                                                          " - "),
                                                  Text(
                                                      "${pendingFilteredList[index]["FlatData"][0]["flatNo"]}"),
                                                  SizedBox(
                                                    width: 60,
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Approve',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    onPressed: () =>
                                                        _memberApproval(
                                                      true,
                                                      pendingFilteredList[index]
                                                          ["_id"],
                                                      pendingFilteredList[index]
                                                          ["society"]["wingId"],
                                                      pendingFilteredList[index]
                                                          ["society"]["flatId"],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Reject',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    onPressed: () =>
                                                        _memberApproval(
                                                      false,
                                                      pendingFilteredList[index]
                                                          ["_id"],
                                                      pendingFilteredList[index]
                                                          ["society"]["wingId"],
                                                      pendingFilteredList[index]
                                                          ["society"]["flatId"],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${pendingFilteredList[index]["ContactNo"]}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple),
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
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
  }

  Approved() {
   // _getMemberApprovedData("done");
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 18,
                    child: TextField(
                      controller: _txtMobileApprovalsSearch,
                      cursorColor: Colors.deepPurple,
                      onChanged: filteredSearch,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Search By Phone...",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: approvedFilteredList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            child: new Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  "${approvedFilteredList[index]["Name"]}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700])),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      "${approvedFilteredList[index]["WingData"][0]["wingName"]}" +
                                                          " - "),
                                                  Text(
                                                      "${approvedFilteredList[index]["FlatData"][0]["flatNo"]}"),
                                                  SizedBox(
                                                    width: 160,
                                                  ),
                                                  RaisedButton(
                                                    elevation: 8,
                                                    splashColor:
                                                        Colors.deepPurple,
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Reject',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    onPressed: () =>
                                                        _memberApprovalsReject(
                                                      false,
                                                          approvedFilteredList[index]
                                                          ["_id"],
                                                          approvedFilteredList[index]
                                                          ["society"]["wingId"],
                                                          approvedFilteredList[index]
                                                          ["society"]["flatId"],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${approvedFilteredList[index]["ContactNo"]}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple),
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
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
  }
}
