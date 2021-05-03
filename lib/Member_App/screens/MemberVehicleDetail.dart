import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class GetMyvehicle extends StatefulWidget {
  @override
  _GetMyvehicleState createState() => _GetMyvehicleState();
}

class _GetMyvehicleState extends State<GetMyvehicle> {
  List VehicleData = new List();
  bool isLoading = false;
  String SocietyId, MemberId, ParentId;

  @override
  void initState() {
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    MemberId = prefs.getString(constant.Session.Member_Id);
    GetMyvehicleData();
  }

  GetMyvehicleData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "memberId" : MemberId
        };
        Services.responseHandler(apiName: "member/getMemberVehicles",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              VehicleData = data.Data[0]["Vehicles"];
            });
          } else {
            setState(() {
              VehicleData = data.Data[0]["Vehicles"];
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
              },
            ),
          ],
        );
      },
    );
  }

  _DeleteMemberVehicle(String VehicleNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "memberId" : MemberId,
          "vehicleNo" : VehicleNo
        };
        Services.responseHandler(apiName: "member/deleteMemberVehicles",body: data).then((data) async {
          if (data.Data.toString() == "1") {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Vehicle Deleted Successfully!!!",
                toastLength: Toast.LENGTH_LONG,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red);
            GetMyvehicleData();
          } else {
            isLoading = false;
            // showHHMsg("Vehicle Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  void _showConfirmDialog(String VehicleNo) {
    print(VehicleNo);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Delete this Vehicle ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _DeleteMemberVehicle(VehicleNo); // ask monil to make deletemembervehicle 12 - number
              },
            ),
          ],
        );
      },
    );
  }

  Widget _Vehicalelist(BuildContext context, int index) {
    return Card(
      child: Container(
        child: Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0))),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black54),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: VehicleData[index]["vehicleType"] == "Car"
                      ? Image.asset(
                          "images/automobile.png",
                          width: 40,
                        )
                      : Image.asset("images/bike.png", width: 40),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "${VehicleData[index]["vehicleNo"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[400]),
                    onPressed: () {
                      _showConfirmDialog(VehicleData[index]["vehicleNo"].toString());
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Parking Details"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : VehicleData.length > 0
                ? ListView.builder(
                    itemBuilder: _Vehicalelist,
                    itemCount: VehicleData.length,
                    shrinkWrap: true)
                : Container(
                    child: Center(
                      child: Text("No Vehicle Added"),
                    ),
                  ));
  }
}
