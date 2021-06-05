import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocietyStaffComponent extends StatefulWidget {
  Function onDelete;
  Function onMap;
  Function onUnMap;
  var visitorData;
  int index;

  SocietyStaffComponent(
      {this.visitorData, this.index, this.onDelete, this.onMap, this.onUnMap});

  @override
  _SocietyStaffComponentState createState() => _SocietyStaffComponentState();
}

class _SocietyStaffComponentState extends State<SocietyStaffComponent> {
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
                Navigator.of(context).pop();;
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                deleteStaff(widget.visitorData['_id'].toString());
                Navigator.of(context).pop();

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
              if (data.Data != null && data.IsSuccess == true) {
                print("data.Data");
                print(data.Data);
                Fluttertoast.showToast(
                    msg: "Staff deleted Successfully!!!",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.TOP,
                    textColor: Colors.white);
                widget.onDelete();
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

  mapSocietyStaff(String staffId, String entryNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId = prefs.getString(cnst.Session.SocietyId);

        var data = {
          "staffId": staffId,
          "entryNo": entryNo,
          "societyId": societyId,
          "type": widget.visitorData["staffCategory"].toString() == "Watchman"
              ? "1"
              : "0",
        };
        Services.responseHandler(
            apiName: "watchman/addStaffEntryNo", body: data)
            .then((data) async {
          print(data.Message);
          if (data.Data != null && data.Data == 1) {
            Fluttertoast.showToast(
                msg: "Staff Mapped Successfully!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
            widget.onMap();
          } else {}
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  unmapSocietyStaff() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List staffIdList = [];
        staffIdList.add(widget.visitorData["_id"]);
        var data = {
          "staffIdList": staffIdList,
          "type": widget.visitorData["staffCategory"].toString() == "Watchman"
              ? "1"
              : "0",
        };
        Services.responseHandler(apiName: "watchman/unMappedStaff", body: data)
            .then((data) async {
          print(data.Message);
          if (data.Data != null && data.Data == 1) {
            Fluttertoast.showToast(
                msg: "Staff Unmapped Successfully!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
            widget.onUnMap();
          } else {}
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  Future scan(String staffId) async {
    String defaultType = "Staff";
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      var data = barcode.split(",");
      print("data in qrcode");
      print(data);
      if (barcode != null) {
        mapSocietyStaff(
            widget.visitorData["_id"], "STAFF-" + data[0].toString());
      } else
        showMsg("Try Again..");
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          // this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        // setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      // setState(() => this.barcode =
      // 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      // setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  List<Widget> wingDetails = [];

  wings(){
    wingDetails.clear();
    for(int i=0;i<widget.visitorData["WingData"].length;i++){
      wingDetails.add(Text(
        "Wing-" '${widget.visitorData["WingData"][i]["wingName"]}'
            .toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    wings();
    super.initState();
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
                              widget.visitorData["staffCategory"].toString() !=
                                  'Watchman'
                                  ? Text(widget.visitorData["entryNo"].toString().split('-')[1],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                                  : Text(widget.visitorData["watchmanNo"].toString().split('-')[1],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                widget.visitorData['WingData'].length >
                                    0
                                    ?
                                SingleChildScrollView(
                                  child: Column(
                                      children: wingDetails,
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.visitorData["isMapped"] == true
                      ? IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      print('check clicked');
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //       title: new Text("MYJINI"),
                      //       content: new Text(
                      //           "Are You Sure You Want To UnMap ?"),
                      //       actions: <Widget>[
                      //         // usually buttons at the bottom of the dialog
                      //         new FlatButton(
                      //           child: new Text("No",
                      //               style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w600)),
                      //           onPressed: () {
                      //             Navigator.of(context).pop();;
                      //           },
                      //         ),
                      //         new FlatButton(
                      //           child: new Text("Yes",
                      //               style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w600)),
                      //           onPressed: () {
                      //             Navigator.of(context).pop();;
                      //             unmapSocietyStaff();
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    },
                  )
                      : IconButton(
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.green[700],
                      ),
                      onPressed: () {
                        scan(widget.visitorData['_id']);
                      }),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                    onPressed: () {
                      _showConfirmDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
