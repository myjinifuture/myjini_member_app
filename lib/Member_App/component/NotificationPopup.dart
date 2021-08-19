import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/join.dart';
import 'package:smart_society_new/Member_App/screens/fromMemberScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:smart_society_new/Member_App/screens/ViewVisitorPopUpImage.dart';

class NotificationPopup extends StatefulWidget {
  var data;
  String sound;
  bool unknownEntry;

  NotificationPopup(this.data, {this.sound,this.unknownEntry});

  @override
  _NotificationPopupState createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  List NoticeData = new List();
  bool isLoading = false;

  String SocietyId;
  final List<String> _notifcationReplylist = ["APPROVED", "DENY"];

  int selected_Index;
  var mydata;

  @override
  void initState() {
    // print(widget.data);
    Vibration.cancel();
    AgoraentryId();
    print("widget.data");
    print(widget.data);
    getLocalData();
  }

  String Member_id;

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // SocietyId = prefs.getString(constant.Session.SocietyId);
      Member_id = prefs.getString(constant.Session.Member_Id);
    });
  }

  AgoraentryId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('data', widget.data["EntryId"]);
    print("smit member1 ${widget.data["EntryId"]}");
  }

  NotificationReply(String value) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // setState(() {
        //   isLoading = true;
        // });
        var data = {
          "entryId": widget.data["EntryId"],
          "entryNo": widget.data["EntryNo"],
          "response": value.toString(),
          // "deviceType": Platform.isAndroid ? "Android" : "IOS",
          "memberId": Member_id,
        };
        print("data");
        print(data);
        Services.responseHandler(
                apiName: "member/responseToVisitorEntry", body: data)
            .then((data) async {
          log("=============Notification${data.Message}");
          if (data.Data == "1" && data.IsSuccess == true) {
            print("data.Data");
            print(data.Data);
            // SharedPreferences preferences =
            //     await SharedPreferences.getInstance();
            // await preferences.setString('data', data.Data);

            Fluttertoast.showToast(
                msg: "Success !",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);

            log("=============Notification${data.Message}");
          } else {
            // setState(() {
            //   isLoading = false;
            // });
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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);              },
            ),
          ],
        );
      },
    );
  }

  // memberToMemberCalling(bool isVideoCall) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //
  //       var data = {
  //         "societyId" : prefs.getString(Session.SocietyId),
  //         "callerMemberId" : prefs.getString(Session.Member_Id),
  //         "callerWingId" : prefs.getString(Session.WingId),
  //         "callerFlatId" : prefs.getString(Session.FlatId),
  //         "receiverMemberId" : widget.MemberData["_id"].toString(),
  //         "receiverWingId" : widget.MemberData["WingData"][0]["_id"].toString(),
  //         "receiverFlatId" : widget.MemberData["FlatData"][0]["_id"].toString(), // tell monil to give wathmen number and recieverwingid
  //         "contactNo" : widget.MemberData["ContactNo"].toString(),
  //         "AddedBy" : "Member",
  //         "isVideoCall" : isVideoCall,
  //         "deviceType" : Platform.isAndroid ? "Android" : "IOS",
  //         "callFor" : 0
  //       };
  //
  //       print("memberToMemberCalling Data = ${data}");
  //       Services.responseHandler(apiName: "member/memberCalling",body: data).then((data) async {
  //         if (data.Data.length > 0 && data.IsSuccess == true) {
  //           SharedPreferences preferences =
  //           await SharedPreferences.getInstance();
  //           // await preferences.setString('data', data.Data);
  //           // await for camera and mic permissions before pushing video page
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => FromMemberScreen(fromMemberData: widget.data,isVideoCall:isVideoCall.toString()),
  //             ),
  //           );
  //           /*Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => JoinPage(),
  //                   ),
  //                 );*/
  //         } else {
  //
  //         }
  //       }, onError: (e) {
  //         showHHMsg("Try Again.","MyJini");
  //       });
  //     } else
  //       showHHMsg("No Internet Connection.","MyJini");
  //   } on SocketException catch (_) {
  //     showHHMsg("No Internet Connection.","MyJini");
  //   }
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //     advancedPlayer.stop();
  // }

  @override
  Widget build(BuildContext context) {
    // print(constant.Image_Url + widget.data["data"]["guestImage"]);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: contentBox(context),
              ),
              Image.asset(
                'images/myginitext.png',
                height: 60,
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // Get.back();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/HomeScreen', (route) => false);                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  var recieverWingId = "";
  memberToMemberCalling(bool isVideoCall) async {
    try {
      print("tapped");
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var ReceiverWingID = prefs.getString(Session.ReceiverWingId);
      print("abc");
      print( prefs.getString(Session.WingId));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        if(widget.data["watchmanWingId"].length > 0){
          recieverWingId = widget.data["watchmanWingId"][0];
        }
        else{
          recieverWingId = widget.data["watchmanWingId"];
        }

        var data = {
          "societyId": prefs.getString(Session.SocietyId),
          "callerMemberId": prefs.getString(Session.Member_Id),
          "callerWingId": prefs.getString(Session.WingId),
          "callerFlatId": prefs.getString(Session.FlatId),
          "watchmanId": widget.data["watchmanId"].toString(),
          "receiverWingId": widget.data["watchmanWingId"],
          // "receiverFlatId" : widget.MemberData["FlatData"][0]["_id"].toString(),
          "contactNo": widget.data["watchmanContact"].toString(),
          "AddedBy": "Member",
          "isVideoCall": isVideoCall,
          "callFor": 1,
          "deviceType": Platform.isAndroid ? "Android" : "IOS",
          "entryId": widget.data["EntryId"]
        };

        print("memberToMemberCalling Data = ${data}");
        Services.responseHandler(apiName: "member/memberCalling", body: data)
            .then((data) async {
          if (data.Data.length > 0 && data.IsSuccess == true) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            // await preferences.setString('data', data.Data);
            // await for camera and mic permissions before pushing video page
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => FromMemberScreen(fromMemberData: widget.data,isVideoCall:isVideoCall.toString()),
            //   ),
            // );
            if (isVideoCall) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinPage(
                    againPreviousScreen : true,
                      fromMemberData: widget.data,
                      unknownEntry : widget.unknownEntry,
                      entryIdWhileGuestEntry: widget.data["EntryId"],
                      videoCall: isVideoCall.toString()),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinPage(
                      againPreviousScreen : true,
                      fromMemberData: widget.data,
                      unknownEntry : widget.unknownEntry,
                      entryIdWhileGuestEntry: data.Data[0]["_id"],
                      videoCall: isVideoCall.toString()),
                ),
              );
            }
          } else {}
        }, onError: (e) {
          showHHMsg("Try Again.", "MyJini");
        });
      } else
        showHHMsg("No Internet Connection.", "MyJini");
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "MyJini");
    }
  }

  contentBox(context) {
    print("notification data :");
    print(widget.data);
    return widget.data["notificationType"] == "SendComplainToAdmin"
        ? Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
                margin: EdgeInsets.only(top: 65),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 5),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          "Complain From : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("${widget.data["MemberName"]}".toUpperCase()),
                      ],
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text(
                              "${widget.data["MemberWing"]} - ${widget.data["MemberFlat"]}"),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Regarding : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("${widget.data["ComplainCategory"]}"),
                      ],
                    ),
                    // Text(
                    //   "Complain From ${widget.data["MemberName"]} "
                    //       "\n ${widget.data["MemberWing"]} - ${widget.data["MemberFlat"]}"
                    //       " \n Regarding \n ${widget.data["ComplainCategory"]}", // told monil to send me complaint type
                    //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    // ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      child: RaisedButton(
                        //     disabledColor: Colors.red,
                        // disabledTextColor: Colors.black,
                        padding: const EdgeInsets.all(10),
                        textColor: Colors.white,
                        color: Colors.purple,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/AllComplaints');
                        },
                        child: Text('Go to Complain'),
                      ),
                    ),
                  ],
                ),
              ),
              widget.data["guestImage"] == null ||
                      widget.data["guestImage"] == ""
                  ? Positioned(
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(65),
                              ),
                              child: Image.asset(
                                "images/user.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      left: 20,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 65,
                        // backgroundImage: NetworkImage(
                        //   constant.Image_Url + widget.data["guestImage"],
                        // ),
                        child: FadeInImage.assetNetwork(
                          width: MediaQuery.of(context).size.width,
                          height: 220,
                          fit: BoxFit.fill,
                          placeholder: "images/Ad1.jpg",
                          image:
                              "${constant.Image_Url} +${widget.data["guestImage"]}",
                        ),
                      ),
                    ),
              //company image
            ],
          )
        : Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
                margin: EdgeInsets.only(top: 65),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 5),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Visitor is waiting At Gate",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    widget.data["Name"] != null
                        ? Container(
                            //width: 130,
                            child: Flexible(
                              child: Text(
                                "${widget.data["Name"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.grey[800]),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // launch("tel:" + widget.data["VisitorContactNo"]);
                            memberToMemberCalling(false);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset('images/telephone.png',
                                  width: 40, height: 40),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        GestureDetector(
                          onTap: () {
                            memberToMemberCalling(true);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => JoinPage(fromMemberData: widget.data,entryIdWhileGuestEntry:widget.data["EntryNo"]),
                            //   ),
                            // );
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset('images/video_call.png',
                                  width: 40, height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              widget.data["guestImage"] == null ||
                      widget.data["guestImage"] == ""
                  ? Positioned(
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(65),
                              ),
                              child: Image.asset(
                                "images/user.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      left: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewVisitorPopUpImage(
                                data: "${constant.Image_Url}" +
                                    widget.data["guestImage"],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 65,
                          // backgroundImage: NetworkImage(
                          //   "http://13.127.1.141/uploads/visitor/guestImage_1618259990893.jp
                          // ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(65),
                            ),
                            child: FadeInImage.assetNetwork(
                                width: 130,
                                height: 220,
                                fit: BoxFit.fill,
                                placeholder: "images/Ad1.jpg",
                                image: "${constant.Image_Url}" +
                                    widget.data["guestImage"]),
                          ),
                        ),
                      ),
                    ),
              //company image
              Positioned(
                top: 80,
                left: 20,
                right: -180,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  // maxRadius: 30,
                  radius: 30,
                  child: Container(
                    // height: 60,
                    // width: 60,
                    child: Image.network(
                      constant.Image_Url + '${widget.data["CompanyImage"]}',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -45,
                left: 20,
                right: -180,
                child: GestureDetector(
                  onTap: () {
                    log("//=================#${_notifcationReplylist[0]}");
                    NotificationReply("1");
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/HomeScreen', (route) => false);                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(65)),
                            child: Image.asset("images/success.png")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "APPROVE",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: -45,
              //   left: 20,
              //   right: 20,
              //   child: GestureDetector(
              //     onTap: () {
              //       NotificationReply("3"); // ask monil about leave at gate
              //       Get.back();
              //       advancedPlayer.stop();
              //     },
              //     child: Column(
              //       children: [
              //         CircleAvatar(
              //           backgroundColor: Colors.transparent,
              //           radius: 25,
              //           child: ClipRRect(
              //               borderRadius: BorderRadius.all(Radius.circular(65)),
              //               child: Image.asset("images/user.png")),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         // Text(
              //         //   "LEAVE AT GATE",
              //         //   style: TextStyle(
              //         //       fontWeight: FontWeight.w600,
              //         //       fontSize: 12,
              //         //       color: Colors.white),
              //         // )
              //       ],
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: -45,
                left: -180,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    NotificationReply("2");
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/HomeScreen', (route) => false);                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(65)),
                            child: Image.asset("images/deny.png")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "DENY",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

}
