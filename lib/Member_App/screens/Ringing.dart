import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/join.dart';
import 'dart:io';
import 'dart:async';

import 'package:vibration/vibration.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import '../screens/HomeScreen.dart';

class Ringing extends StatefulWidget {
  Map fromMemberData = {};
  bool isVideoCallingInBackground = false;
  bool isButtonPressed,isAudioCall = false;

  Ringing(
      {this.fromMemberData,
        this.isVideoCallingInBackground,
        this.isButtonPressed,this.isAudioCall});

  @override
  _RingingState createState() => _RingingState();
}

class _RingingState extends State<Ringing> {
  @override
  void initState() {
    print("widget.isbuttonPressed");
    print(widget.isButtonPressed);
    // TODO: implement initState
    print("fromMemberData");
    print(widget.fromMemberData);
    Vibration.cancel();
    getLocalData();
    super.initState();
  }

  var memberId = "", societyId = "",flatId="";

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberId = prefs.getString(Session.Member_Id);
    societyId = prefs.getString(Session.SocietyId);
    flatId = prefs.getString(Session.FlatId);
  }

/*
  onRejection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.GetWingData(SocietyId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              WingData = data;
              selectedWing = data[0]["Id"].toString();
            });
            GetMemberData(data[0]["Id"].toString());
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
*/

  Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        // setState(() {
        //   _start++;
        // });
      },
    );
  }

  sendVideoCallStatus(String callingId, int response,
      {bool acceptPressed}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "callingId": callingId,
          "response": response,
          "deviceType": Platform.isAndroid ? "Android" : "IOS",
          "playerId" : prefs.getString('playerId'),
          "receiverId" : prefs.getString(Session.Member_Id),
          "receiverType": 0
        };
        print("success");
        print(callingId);
        print(response);
        Services.responseHandler(apiName: "member/responseToCall_v1", body: data)
            .then((data) async {
          if (acceptPressed != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JoinPage(
                    againPreviousScreen: false,
                    unknownEntry: false, fromMemberData: widget.fromMemberData),
              ),
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, '/HomeScreen', (route) => false);
          }
        }, onError: (e) {
          // showMsg("$e");
          // setState(() {
          //   isLoading = false;
          // });
        });
      } else {
        // showMsg("No Internet Connection.");
        // setState(() {
        //   isLoading = false;
        // });
      }
    } on SocketException catch (_) {
      // showMsg("No Internet Connection.");
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  onRejectCall() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "callingId": widget.fromMemberData["CallingId"],
          "rejectBy": false
        };
        Services.responseHandler(apiName: "member/rejectCall", body: data).then(
                (data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('commonId', widget.fromMemberData["CallingId"]);
              if (data.Data.toString() == '1') {
                print('call declined successfully');
                Navigator.pushAndRemoveUntil(
                    context, SlideLeftRoute(page: HomeScreen()), (route) => false);
              } else {
                // setState(() {
                //   isLoading = false;
                // });
                Navigator.pushAndRemoveUntil(
                    context, SlideLeftRoute(page: HomeScreen()), (route) => false);
              }
            }, onError: (e) {
          showHHMsg("Something Went Wrong Please Try Again", "");
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  AcceptOrRejectForUnknownVisitor(bool Accepted) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "entryId": widget.fromMemberData["EntryId"],
          "memberId": memberId,
          "societyId": societyId,
          "response": Accepted,
          "flatId" : flatId,
          "playerId" : prefs.getString('playerId')
        };
        print("success");
        print("data");
        print(data);
        Services.responseHandler(apiName: "member/responseToUnknownVisitorEntry_v1",body: data).then((data) async {
          print("data.Data");
          print(data.Data);
          if(Accepted) {
            // if(acceptPressed!=null) {
            print("data.Data");
            print(data.Data);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JoinPage(
                      unknownEntry: false,
                      againPreviousScreen: false,
                      fromMemberData: widget.fromMemberData,
                      unknownVisitorEntryId: data.Data["EntryId"],),
              ),
            );
          }else{
            Navigator.pushNamedAndRemoveUntil(
                context, '/HomeScreen', (route) => false);
          }
        }, onError: (e) {
          // showMsg("$e");
          // setState(() {
          //   isLoading = false;
          // });
        });
      } else {
        // showMsg("No Internet Connection.");
        // setState(() {
        //   isLoading = false;
        // });
      }
    } on SocketException catch (_) {
      // showMsg("No Internet Connection.");
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  bool acceptPressed = false;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    print("widget.fromMemberData");
    print(widget.fromMemberData);
    return WillPopScope(
      // onWillPop: () async => false,

      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: new Center(
                child: SingleChildScrollView(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('images/applogo.png', width: 90, height: 90),
                      Text(
                        "MYJINI",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      widget.fromMemberData["notificationType"] == "UnknownVisitor"
                          ? Text(
                        "Video Calling....",
                        style: TextStyle(fontSize: 20),
                      )
                          : widget.fromMemberData["NotificationType"] != "VideoCalling"
                          ? Text(
                        "Audio Calling....",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                          : Text(
                        "Video Calling....",
                        style: TextStyle(fontSize: 20),
                      ),
                      widget.fromMemberData["notificationType"] == "UnknownVisitor" ||
                          widget.fromMemberData["WatchmanWingName"] != null
                          ? Container(
                          child: Image.asset('images/WatchmanCall.png',
                              width: 90, height: 90),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            // image: new DecorationImage(
                            //     fit: BoxFit.fill,
                            //     image: new NetworkImage(
                            //         "https://i.imgur.com/BoN9kdC.png")
                            // )
                          ))
                          : new Container(
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(Image_Url +
                                "${widget.fromMemberData["CallerImage"]}"),
                            backgroundColor: Colors.transparent,
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            // image: new DecorationImage(
                            //     fit: BoxFit.fill,
                            //     image: new NetworkImage(
                            //         "https://i.imgur.com/BoN9kdC.png")
                            // )
                          )),
                      // new Text(
                      //   "Watchmen",
                      //   textScaleFactor: 1.5,
                      // ),
                      widget.fromMemberData["notificationType"] == "UnknownVisitor"
                          ? Text(
                        "Watchman".toUpperCase(),
                        textScaleFactor: 1.5,
                      )
                          : widget.fromMemberData["CallerName"] == null
                          ? Text(
                        "Watchman".toUpperCase(),
                        textScaleFactor: 1.5,
                      )
                          : new Text(
                        "${widget.fromMemberData["CallerName"]}"
                            .toUpperCase(),
                        textScaleFactor: 1.5,
                      ),
                      widget.fromMemberData["notificationType"] == "UnknownVisitor"
                          ? Container()
                          : Row(
                        // tell monil to send me flatno and wing name also 18 number
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.fromMemberData["CallerWingName"] == null
                              ? new Text(
                            widget.fromMemberData["WatchmanName"],
                            textScaleFactor: 1.5,
                          )
                              : Text(
                            widget.fromMemberData["CallerWingName"],
                            textScaleFactor: 1.5,
                          ),
                          widget.fromMemberData["CallerFlatNo"] == null
                              ? Container()
                              : new Text(
                            "-",
                            textScaleFactor: 1.5,
                          ),
                          widget.fromMemberData["CallerFlatNo"] == null
                              ? Container()
                              : new Text(
                            widget.fromMemberData["CallerFlatNo"],
                            textScaleFactor: 1.5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.15,
                      ),
                      // acceptPressed ?  Text(_printDuration(Duration(seconds: _start)) + " sec",
                      // style: TextStyle(
                      //   fontSize: 20,
                      //   color: Colors.purple,
                      // ),
                      // ) : Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.15,
                      ),
                      !acceptPressed
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   acceptPressed = true;
                                    // });
                                    if (widget.fromMemberData["notificationType"] ==
                                        "UnknownVisitor") {
                                      AcceptOrRejectForUnknownVisitor(true);
                                    } else {
                                      sendVideoCallStatus(
                                          widget.fromMemberData["CallingId"], 1,
                                          acceptPressed: acceptPressed);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            18.0,
                                          ),
                                          child: Icon(
                                            Icons.call_end,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Text("Accept"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // if (widget.fromMemberData["notificationType"] ==
                                  //     "UnknownVisitor") {
                                  //   // AcceptOrRejectForUnknownVisitor(false);
                                  //   onRejectCall();
                                  // } else {
                                  //   sendVideoCallStatus(
                                  //       widget.fromMemberData["CallingId"], 2);
                                  // }
                                  if (widget.fromMemberData["notificationType"] ==
              "UnknownVisitor") {
      AcceptOrRejectForUnknownVisitor(false);
      } else {
                                    onRejectCall();
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          18.0,
                                        ),
                                        child: Icon(
                                          Icons.call_end,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 7.0),
                                child: Text("Reject"),
                              ),
                            ],
                          ),
                        ],
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _timer.cancel();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/HomeScreen', (route) => false);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            18.0,
                                          ),
                                          child: Icon(
                                            Icons.call_end,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Text("End Call"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          )
/*
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 400,
              ),
              new RaisedButton(
                onPressed: () => sendVideoCallStatus("Accepted",
                    widget.fromMemberData["EntryId"],
                    widget.fromMemberData["SocietyId"],
                    widget.fromMemberData["EntryId"],
                    widget.fromMemberData["EntryId"],
                    "Accepted"),
                  */
/*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinPage(),
                    ),
                  );*/ /*

                child: new Text("Accept"),
              ),
              new RaisedButton(

                onPressed: () => sendVideoCallStatus("Rejected",
                  widget.fromMemberData["EntryId"],
                  widget.fromMemberData["SocietyId"],
                  widget.fromMemberData["EntryId"],
                  widget.fromMemberData["EntryId"],
                  "Rejected"),
                child: new Text("Reject"),
              ),
            ],
          ),
        ),
*/
      ),
    );
  }
}
