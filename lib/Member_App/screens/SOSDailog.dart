import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class SOSDailog extends StatefulWidget {
  @override
  _SOSDailogState createState() => _SOSDailogState();
}

class _SOSDailogState extends State<SOSDailog> {
  String _selected = "Member";
  String phoneNumber1;

  TextEditingController txtMsg = new TextEditingController();
  List FmemberData = new List();
  List WatchmenData = new List();
  bool isLoading = false;
  String SocietyId, MemberId, ParentId,wingId,flatId;
  ProgressDialog pr;
  FormData formData;

  @override
  void initState() {
    isSelectedWatchmen.clear();
    WatchmenData.clear();
    FmemberData.clear();
    isSelectedFamilyMember.clear();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    GetFamilyDetail();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    MemberId = prefs.getString(constant.Session.Member_Id);
    wingId = prefs.getString(constant.Session.WingId);
    flatId = prefs.getString(constant.Session.FlatId);
    if (prefs.getString(constant.Session.ParentId) == "null" ||
        prefs.getString(constant.Session.ParentId) == "")
      ParentId = "0";
    else
      ParentId = prefs.getString(constant.Session.ParentId);
  }

  GetFamilyDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var data = {
          "societyId": SocietyId,
          "wingId": wingId,
          "flatId": flatId
        };
        Services.responseHandler(apiName: "member/getFamilyMembers",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              FmemberData = data.Data;
              //phoneNumber1 = data[0]["ContactNo"];
            });
            // for(int i=0;i<FmemberData.length;i++){
            //   if(FmemberData[i]["_id"].toString() == MemberId){
            //     FmemberData.remove(FmemberData[i]);
            //   }
            // }
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

  GetWatchmenDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyId": SocietyId
        };
        Services.responseHandler(apiName: "member/getAllWatchman",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              WatchmenData = data.Data;
              //phoneNumber1 = data[0]["ContactNo"];
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

  List alltickedMemberIdList = [];
  List alltickedWatchmenIdList = [];
  SendsosData(bool type) async {
    try {
      String fcmtoken = "", titles = "";
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (type == false) {
          for (int i = 0; i < WatchmenData.length; i++) {
            if (i == WatchmenData.length - 1 && isSelectedWatchmen[i]) {
              // fcmtoken += WatchmenData[i]["DeviceToken"];
              alltickedWatchmenIdList.add(WatchmenData[i]["_id"]);
            } else if (isSelectedWatchmen[i] && i != WatchmenData.length - 1) {
              // fcmtoken += WatchmenData[i]["DeviceToken"] + ",";
              alltickedWatchmenIdList.add(WatchmenData[i]["_id"]);
            }
          }
          if (!isSelectedWatchmen.contains(true)) {
            Fluttertoast.showToast(
              msg: "Please select atleast one field",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP,
            );
          } else {
            setState(() {
              isLoading = true;
            });
            print("WatchmenData");
            print(WatchmenData);
            // for (int i = 0; i < WatchmenData.length; i++) {
            //   if (isSelectedWatchmen[i] && i != WatchmenData.length - 1) {
            //     titles += WatchmenData[i]["Name"] + ",";
            //   } else if (isSelectedWatchmen[i] &&
            //       i == WatchmenData.length - 1) {
            //     titles += WatchmenData[i]["Name"];
            //   }
            // }
          }
        } else {
          print("isSelectedFamilyMember");
          print(isSelectedFamilyMember);
          for (int i = 0; i < FmemberData.length; i++) {
            if (i != FmemberData.length - 1 && isSelectedFamilyMember[i]) {
              alltickedMemberIdList.add(FmemberData[i]["_id"]);
            } else if (isSelectedFamilyMember[i] &&
                i == FmemberData.length - 1) {
              alltickedMemberIdList.add(FmemberData[i]["_id"]);
            }
          }
          if (!isSelectedFamilyMember.contains(true)) {
            Fluttertoast.showToast(
              msg: "Please select atleast one field",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP,
            );
          } else {
            setState(() {
              isLoading = true;
            });
            for (int i = 0; i < isSelectedFamilyMember.length; i++) {
              if (isSelectedFamilyMember[i] &&
                  i != isSelectedFamilyMember.length - 1) {
                titles += FmemberData[i]["Name"] + ",";
              } else if (isSelectedFamilyMember[i] &&
                  i == isSelectedFamilyMember.length - 1) {
                titles += FmemberData[i]["Name"];
              }
            }
          }
        }
        print("alltickedMemberIdList");
        print(alltickedMemberIdList);
        var data;
        type ==true ?
        data = {
          "senderId" : MemberId,
          "receiverIds" : alltickedMemberIdList,
          "message" : txtMsg.text,
          "isForMember" : type,
          "deviceType" : Platform.isAndroid ? "Android" : "IOS"
        }:data = {
          "senderId" : MemberId,
          "receiverIds" : alltickedWatchmenIdList,
          "message" : txtMsg.text,
          "isForMember" : type,
          "deviceType" : Platform.isAndroid ? "Android" : "IOS"
        };
        print("data on pressing sos");
        print(data);
        if (isSelectedFamilyMember.contains(true) ||
            isSelectedWatchmen.contains(true)) {
          Services.responseHandler(apiName: "member/sendSOS",body: data).then((data) async {
            setState(() {
              isLoading = false;
            });
            if (data.IsSuccess == "true") {
              print("success");
              setState(() {
                Fluttertoast.showToast(
                  msg: "Notification sent successfully!!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                );
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);              });
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  showMsg(String title, String msg) {
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
                Navigator.pushReplacementNamed(context, "/LoginScreen");
              },
            ),
          ],
        );
      },
    );
  }

  List<bool> isSelectedFamilyMember = [];

  Widget _FamilyMember(BuildContext context, int index) {
    for (int i = 0; i < FmemberData.length; i++) {
      isSelectedFamilyMember.add(false);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${FmemberData[index]["Name"]}",
                style: TextStyle(
                    fontSize: 13,
                    color: constant.appPrimaryMaterialColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${FmemberData[index]["ContactNo"]}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.call,
              color: Colors.green[700],
            ),
            onPressed: () {
              launch(('tel:// ${FmemberData[index]["ContactNo"]}'));
            }),
        Checkbox(
          value: isSelectedFamilyMember[index],
          checkColor: Colors.white,
          activeColor: Colors.green,
          // inactiveColor: Colors.purple,
          // disabledColor: Colors.grey,
          onChanged: (val) => this.setState(() {
            isSelectedFamilyMember[index] = val;
          }),
        ),
      ],
    );
  }

  List<bool> isSelectedWatchmen = [];

  Widget _Watchmen(BuildContext context, int index) {
    print(WatchmenData.length);
    for (int i = 0; i < WatchmenData.length; i++) {
      isSelectedWatchmen.add(false);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${WatchmenData[index]["Name"]}",
                style: TextStyle(
                    fontSize: 13,
                    color: constant.appPrimaryMaterialColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${WatchmenData[index]["ContactNo1"]}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.call,
              color: Colors.green[700],
            ),
            onPressed: () {
              launch(('tel:// ${WatchmenData[index]["ContactNo1"]}'));
            }),
        Checkbox(
          value: isSelectedWatchmen[index],
          checkColor: Colors.white,
          activeColor: Colors.green,
          // inactiveColor: Colors.purple,
          // disabledColor: Colors.grey,
          onChanged: (val) => this.setState(() {
            isSelectedWatchmen[index] = val;
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(MemberId);
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 0),
      contentPadding: EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10),
      title: SingleChildScrollView(
        child: Container(
          color: constant.appPrimaryMaterialColor,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            "Emergency SOS",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Radio(
                  value: 'Watchman',
                  groupValue: _selected,
                  onChanged: (value) {
                    FmemberData.clear();
                    txtMsg.clear();
                    isSelectedFamilyMember.clear();
                    isSelectedWatchmen.clear();
                    GetWatchmenDetail();
                    setState(() {
                      _selected = value;
                    });
                  },
                ),
                Text(
                  "Watchman",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Radio(
                  value: 'Member',
                  groupValue: _selected,
                  onChanged: (value) {
                    txtMsg.clear();
                    WatchmenData.clear();
                    isSelectedFamilyMember.clear();
                    isSelectedWatchmen.clear();
                    GetFamilyDetail();
                    setState(() {
                      _selected = value;
                    });
                  },
                ),
                Text(
                  "Family Member",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : FmemberData.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height:
                              50 * double.parse(FmemberData.length.toString()),
                          child: ListView.builder(
                            itemBuilder: _FamilyMember,
                            itemCount: FmemberData.length,
                            shrinkWrap: true,
                          ),
                        ),
                      )
                    : WatchmenData.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 52 *
                                  double.parse(WatchmenData.length.toString()),
                              child: ListView.builder(
                                itemBuilder: _Watchmen,
                                itemCount: WatchmenData.length,
                                shrinkWrap: true,
                              ),
                            ),
                          )
                        : Container(
                            child: Center(child: Text("No FamilyMember Added")),
                          ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  controller: txtMsg,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: constant.appPrimaryMaterialColor[600])),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "Any Message",
                    hintStyle: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: SizedBox(
                width: 200,
                height: 40,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: constant.appPrimaryMaterialColor[600],
                  textColor: Colors.white,
                  splashColor: Colors.white,
                  child: Text(
                      "Send",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    if (txtMsg.text == "") {
                      Fluttertoast.showToast(
                        msg: "Please enter message",
                        backgroundColor: Colors.green,
                        gravity: ToastGravity.TOP,
                      );
                    } else {
                      if (WatchmenData.isNotEmpty) {
                        SendsosData(false);
                      } else {
                        SendsosData(true);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
