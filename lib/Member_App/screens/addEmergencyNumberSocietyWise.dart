import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Screens/UpdateSocietyEmergencyNumber.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AddEmergencySocietyWise.dart';

class getEmergencyNumberSocietyWise extends StatefulWidget {
  @override
  getEmergencyNumberSocietyWiseState createState() =>
      getEmergencyNumberSocietyWiseState();
}

class getEmergencyNumberSocietyWiseState
    extends State<getEmergencyNumberSocietyWise> {
  @override
  void initState() {
    _getEmergencyContacts();
    getLocalData();
  }

  String societyId;
  String contactId;
  List emergencyData = [];

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(Session.SocietyId);
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  _getEmergencyContacts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": societyId,
        };
        Services.responseHandler(
                apiName: "member/getSocietyEmergencyContacts", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              emergencyData = data.Data;
            });
          } else {
            setState(() {
              emergencyData = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  deleteEmergencyContact() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "contactId": contactId,
        };
        Services.responseHandler(
                apiName: "admin/deleteSocietyEmergencyContact", body: data)
            .then((data) async {
          if (data.IsSuccess == true && data.Data.toString() == "1") {
            Fluttertoast.showToast(
                msg: "Emergency Contact Deleted Successfully !!!",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP);
            setState(() {
              _getEmergencyContacts();
            });
          } else {
            setState(() {
              emergencyData = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text("MyJINI"),
          content: new Text("Are You Sure You Want To Delete This ?"),
          actions: <Widget>[
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
                deleteEmergencyContact();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emergency Numbers",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: emergencyData.length > 0
            ? AnimationLimiter(
                child: ListView.builder(
                    itemCount: emergencyData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 15, right: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                FadeInImage.assetNetwork(
                                    placeholder: '',
                                    image: Image_Url +
                                        "${emergencyData[index]["image"]}",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          emergencyData[index]["Name"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          emergencyData[index]["ContactNo"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: appPrimaryMaterialColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    launch(
                                        ('tel:// ${emergencyData[index]["ContactNo"]}'));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.call,
                                      size: 30,
                                      color: appPrimaryMaterialColor,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateSocietyEmergencyNumber(
                                              emergencyContactData:
                                                  emergencyData[index],
                                              onUpdate: _getEmergencyContacts,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.asset("images/edit_icon.png",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        contactId = '';
                                        contactId = emergencyData[index]["_id"]
                                            .toString();
                                        _showConfirmDialog();
                                      },
                                      child: Image.asset(
                                          "images/delete_icon.png",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.fill),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }))
            : NoDataComponent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmergencySocietyWise(
                onAddSocietyEmergencyContact: _getEmergencyContacts,
              ),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: appPrimaryMaterialColor,
      ),
    );
  }
}
