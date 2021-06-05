import 'package:barcode_scan/barcode_scan.dart';
// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:share/share.dart';


class DailyResourseComponent extends StatefulWidget {
  var dailyResourceData;
  Function onDelete;
  Function onUpdate;
  bool isAdmin;

  DailyResourseComponent({this.dailyResourceData, this.onDelete,this.onUpdate,this.isAdmin});

  @override
  _DailyResourseComponentState createState() => _DailyResourseComponentState();
}

class _DailyResourseComponentState extends State<DailyResourseComponent> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  String SocietyId,name;
  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      name = prefs.getString(constant.Session.Name);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet();
                          },
                          child: widget.dailyResourceData['staffImage']==''?Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                              width: 80,
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Image.asset("images/family.png",
                                    width: 40, color: Colors.grey[400]),
                              ),):ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                                child: FadeInImage.assetNetwork(
                                placeholder: '',
                                image: constant.Image_Url +
                                    "${widget.dailyResourceData['staffImage']}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill),
                              ),
                        ),
                        Text(
                          "${widget.dailyResourceData['Name']}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${widget.dailyResourceData['staffCategory']}",
                          style: TextStyle(
                            fontSize: 12,
                            color: appPrimaryMaterialColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap:(){
                        launch("tel:" +
                            widget.dailyResourceData["ContactNo1"].toString());
                      },
                      child: Icon(
                        Icons.call_sharp,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                        color: Colors.grey,
                        width: 1,
                        height: 25,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share(
                            "${name}+ is sharing with you the details of staff ${widget.dailyResourceData["Name"]}\n"
                                "Contact no - ${widget.dailyResourceData["ContactNo1"]}\nMYJINI MANAGEMENT PVT LTD\nwww.myjini.in\nDownload MyJini App now to manage your society security, maintenance, staffing\nhttp://tinyurl.com/wz2aeao");
                         // Share.text(
                         //    "",`
                         //    '${name}+ is sharing with you the details of staff ${widget.dailyResourceData["Name"]}'
                         //        'Contact no - ${widget.dailyResourceData["ContactNo1"]}',"");
                      },
                      child: Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDelete(
          deleteId: Id,
          onDelete: () {
            widget.onDelete();
          },
        );
      },
    );
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

  showMsg(String msg, {String title = 'MYJINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }


  _addStaffDetails(String staffId, String entryNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        var data = {
          "staffId": staffId,
          "entryNo": "STAFF-"+entryNo,
          "societyId": SocietyId,
          "type" : "0"
        };
        Services.responseHandler(
            apiName: "watchman/addStaffEntryNo", body: data)
            .then((data) async {
          print(data.Message);
          // pr.hide();
          if (data.Data != null && data.Data == 1) {
            Fluttertoast.showToast(
                msg: "Staff Mapped Successfully!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
            // ignore: unnecessary_statements
            // widget.staffAdded();
            widget.onUpdate();
          } else {
            //showMsg("Data Not Found");
            Fluttertoast.showToast(
                msg: "Already Mapped!!",
                backgroundColor: Colors.red,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
          }
        }, onError: (e) {
          // pr.hide();
          showMsg("Something Went Wrong Please Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  _unMapStaff(String staffId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        var data = {
          "staffIdList": [staffId]
        };
        Services.responseHandler(
            apiName: "watchman/unMappedStaff", body: data)
            .then((data) async {
          print(data.Message);
          // pr.hide();
          if (data.Data != null && data.Data.toString() == '1') {
            Fluttertoast.showToast(
                msg: "Staff UnMapped Successfully!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
            widget.onUpdate();
          } else {
            //showMsg("Data Not Found");
            Fluttertoast.showToast(
                msg: "Already Mapped!!",
                backgroundColor: Colors.red,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
          }
        }, onError: (e) {
          // pr.hide();
          showMsg("Something Went Wrong Please Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      // pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  Future scan(String staffId,bool isMapped) async {
    String defaultType = "Staff";
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      var data = barcode.split(",");
      print("data in qrcode");
      print(data);
      if (barcode != null) {
        if(isMapped){
          _unMapStaff(staffId);
        }
        else {
          _addStaffDetails(staffId, data[0].toString());
        }
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

  void _showConfirmDialogForUnmap(String staffId,bool isMapped) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Unmap this staff ?"),
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
                Navigator.of(context).pop();;
                _unMapStaff(staffId);
              },
            ),
          ],
        );
      },
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return new Container(
              height: 240.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Daily Resources",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                            //fontWeight: FontWeight.bold
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, right: 15, left: 25, bottom: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/assets/profile.png'),
                            backgroundColor: appPrimaryMaterialColor,
                            radius: 45,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.dailyResourceData["Name"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "${widget.dailyResourceData["staffCategory"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: appPrimaryMaterialColor,
                                    ),
                                  ),
                                  Text(
                                    "${widget.dailyResourceData["ContactNo1"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${widget.dailyResourceData["entryNo"].toString().split("-")[1]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: widget.dailyResourceData["isMapped"]  ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                  ) : Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.green[700],
                                  ),
                                  onPressed: () {
                                    if(widget.isAdmin && widget.dailyResourceData["isMapped"] == false ) {
                                      scan(widget.dailyResourceData["_id"],widget.dailyResourceData["isMapped"]);
                                    }
                                    else if(widget.isAdmin && widget.dailyResourceData["isMapped"] == true){
                                      _showConfirmDialogForUnmap(
                                          widget.dailyResourceData["_id"],widget.dailyResourceData["isMapped"]);
                                    }
                                    else if(!widget.isAdmin&& widget.dailyResourceData["isMapped"] == false){
                                      scan(widget.dailyResourceData["_id"],widget.dailyResourceData["isMapped"]);
                                    }
                                    else if(!widget.isAdmin && widget.dailyResourceData["isMapped"] == true ){
                                      Fluttertoast.showToast(
                                          msg: "Unmapping Not Permitted",
                                          backgroundColor: Colors.red,
                                          gravity: ToastGravity.TOP,
                                          textColor: Colors.white);
                                    }
                                  }),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  print(
                                      '${widget.dailyResourceData["_id"].toString()}');
                                  _showConfirmDialog(widget
                                      .dailyResourceData["_id"]
                                      .toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              color: appPrimaryMaterialColor,
                              width: MediaQuery.of(context).size.width,
                              child: FlatButton(
                                  onPressed: () {
                                    launch(
                                        ('tel:// ${widget.dailyResourceData["ContactNo1"]}'));
                                  },
                                  child: Center(
                                    child: Text(
                                      "Call Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 0.0, top: 2),
                          //   child: Container(
                          //     color: appPrimaryMaterialColor,
                          //     width: MediaQuery.of(context).size.width / 2,
                          //     child: FlatButton(
                          //         onPressed: () {
                          //           Share.share(widget.familyData["ContactNo"],
                          //               subject:
                          //               'Name : ${widget.familyData["Name"]}');
                          //         },
                          //         child: Center(
                          //           child: Text(
                          //             "Invite to MyJini",
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         )),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class AlertDelete extends StatefulWidget {
  var deleteId;
  Function onDelete;

  AlertDelete({this.deleteId, this.onDelete});

  @override
  _AlertDeleteState createState() => _AlertDeleteState();
}

class _AlertDeleteState extends State<AlertDelete> {
  String SocietyId, FlatId, WingId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile();
  }

  profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      FlatId = prefs.getString(constant.Session.FlatNo);
      WingId = prefs.getString(constant.Session.WingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("MYJINI"),
      content: new Text("Are You Sure You Want To Delete this Member ?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text("No",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.of(context).pop();;
          },
        ),
        new FlatButton(
          child: new Text("Yes",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            deleteDailyResource(widget.deleteId);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  deleteDailyResource(String staffId) async {
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
                showHHMsg(data.Message,  "Error");
              }
            }, onError: (e) {
          showHHMsg("Try Again.","");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","");
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }
}
