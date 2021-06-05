import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Screens/AddEvent.dart';
import 'package:smart_society_new/Admin_App/Screens/EventDetailAdmin.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/EventDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List EventsData = new List();
  List filteredEventsData = [];
  List registeredMemberData = [];
  bool isLoading = false;
  String SocietyId, MemberId, ParentId,Wing;
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    GetEventDetails();
    _getLocaldata();
  }

  String wingId = "";
  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    wingId = prefs.getString(constant.Session.WingId);
    MemberId = prefs.getString(constant.Session.Member_Id);
    if (prefs.getString(constant.Session.ParentId) == "null" ||
        prefs.getString(constant.Session.ParentId) == "")
      ParentId = "0";
    else
      ParentId = prefs.getString(constant.Session.ParentId);
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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  GetEventDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Wing = prefs.getString(constant.Session.Wing);
        var data = {"societyId": SocietyId,
        "wingId" : wingId
        };
        Services.responseHandler(apiName: "admin/getSocietyEvent_v2", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              EventsData = data.Data;
              for(int i=0;i<EventsData.length;i++){
               if(Wing==EventsData[i]["WingData"][0]["wingName"]){
                 filteredEventsData.add(EventsData[i]);
               }
              }
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

  registeredMemberDetails(
      {String eventId, var eventData, var onEventResponse}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "memberId": MemberId,
          "eventId": eventId,
        };
        print("member/getMemberRegisterEvents data:");
        print({
          "memberId": MemberId,
          "eventId": eventId,
        });
        Services.responseHandler(
                apiName: "member/getMemberRegisterEvents", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              Fluttertoast.showToast(
                  msg: "You have already Registered once!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP);
              registeredMemberData = data.Data;
              print("registeredMemberData response data:");
              print(registeredMemberData);
            });
          } else if (data.Data.length == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetail(
                  EventsData: eventData,
                  onEventResponse: onEventResponse,
                ),
              ),
            );
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

  // GetEventDetails() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //
  //       Services.getEventsData(SocietyId).then((data) async {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             EventsData = data;
  //           });
  //         } else {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         }
  //       }, onError: (e) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         showHHMsg("Try Again.", "");
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     showHHMsg("No Internet Connection.", "");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("EventsData");
    print(EventsData);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: isLoading == false
          ? EventsData.length>0?ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    registeredMemberDetails(
                        eventId: EventsData[index]["_id"].toString(),
                        eventData: EventsData[index],
                        onEventResponse: GetEventDetails);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${EventsData[index]["Title"]}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${EventsData[index]["Description"]}\nAll are Requested To Give Confirmation For Comming OR Not",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "${EventsData[index]["date"]}",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                EventsData[index]["Registration"].length != 0
                                    ? Text(
                                        "Total : ${EventsData[index]["Registration"][0]["noOfPerson"]}",
                                        style: TextStyle(
                                          color:
                                              constant.appPrimaryMaterialColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            (EventsData[index]["Registration"].length==0)?Container():EventsData[index]["Registration"][0]["response"] ==
                                    true
                                ? Text(
                                    "Coming",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Text(
                                    'Not Coming',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: EventsData.length,
            ):Center(child: Text('No Data Found'),)
          : Center(
              child: CircularProgressIndicator(),
            ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: constant.appPrimaryMaterialColor,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => AddEvent()),
      //         (Route<dynamic> route) => false);
      //     // Navigator.pushReplacementNamed(context, '/AddEvent');
      //   },
      // ),
    );
  }
}
