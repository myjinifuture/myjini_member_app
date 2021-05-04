import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNumber extends StatefulWidget {
  @override
  _EmergencyNumberState createState() => _EmergencyNumberState();
}

class _EmergencyNumberState extends State<EmergencyNumber> {
  List EmergencyNumberData = new List();
  bool isLoading = false;
  // String SocietyId;

  @override
  void initState() {
    GetEmergencyNumber();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  GetEmergencyNumber() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId=prefs.getString(constant.Session.SocietyId);
        var data={
          "societyId":societyId,
        };

        Services.responseHandler(apiName: "member/getSocietyEmergencyContacts",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              EmergencyNumberData = data.Data;
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

  Widget _NumberCard(BuildContext context, int index) {
    print("Image_Url");
    print(Image_Url + EmergencyNumberData[index]["image"]);
    return Card(
      elevation: 1,
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Image.network(
                Image_Url + EmergencyNumberData[index]["image"],
                width: MediaQuery.of(context).size.width*0.08,
                height: MediaQuery.of(context).size.height*0.08,
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "${EmergencyNumberData[index]["Name"].toString().trim()}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(
                      "${EmergencyNumberData[index]["ContactNo"].toString().trim()}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80.0))),
                    child: InkWell(
                      onTap: () {
                        launch(
                            "tel:${EmergencyNumberData[index]["ContactNo"]}");
                      },
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: <Widget>[
                                Image.asset('images/call.png',
                                    width: 22, height: 22, color: Colors.green),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("EmergencyNumberData");
    print(EmergencyNumberData);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pushReplacementNamed(context, "/HomeScreen");
        //     }),
        centerTitle: true,
        title: Text(
          'Emergency Number',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 2, right: 2),
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : EmergencyNumberData.length > 0
                ? ListView.builder(
                    itemBuilder: _NumberCard,
                    itemCount: EmergencyNumberData.length,
                  )
                : Container(
                    child: Center(
                      child: Text("No Emergency Number Added"),
                    ),
                  ),
      ),
    );
  }
}
