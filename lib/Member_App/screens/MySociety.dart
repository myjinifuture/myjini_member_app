import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/BankDetails.dart';
import 'package:smart_society_new/Member_App/screens/BuildingInfo.dart';

class MySociety extends StatefulWidget {
  @override
  _MySocietyState createState() => _MySocietyState();
}

class _MySocietyState extends State<MySociety> {
  @override
  void initState() {
    GetSocietyData();
    _getLocaldata();
  }

  String societyCode;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyCode = prefs.getString(constant.Session.SocietyCode);
  }

  var menuList = [
    {
      "image": "images/info.png",
      "title": "Building Info",
      "screen": "BuildingInfo",
    },
    // {
    //   "image": "images/Rules.png",
    //   "title": "Rules",
    //   "screen": "Rules",
    // },
    {
      "image": "images/document.png",
      "title": "Documents",
      "screen": "Documents",
    },
    // {
    //   "image": "images/Helpdesk.png",
    //   "title": "Committee Member",
    //   "screen": "Committee",
    // },
    // {
    //   "image": "images/bank.png",
    //   "title": "Bank",
    //   "screen": "BankDetails",
    // },
    // {
    //   "image": "images/statistics.png",
    //   "title": "Statistics",
    //   "screen": "Statistics",
    // },
  ];

  Map _societyData = {};
  bool isLoading = false;

  GetSocietyData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "societyCode": societyCode
        };
        Services.responseHandler(apiName: "member/getSocietyDetails",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _societyData = data.Data;
            });
            print("_societyData");
            print(_societyData);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          // showHHMsg("Try Again.", "");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/HomeScreen");
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/HomeScreen");
              }),
          centerTitle: true,
          title: Text('My Society', style: TextStyle(fontSize: 18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: menuList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (menuList[index]["screen"] == "BuildingInfo") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuildingInfo(
                              societyData: _societyData,
                            ),
                          ),
                        );
                      } else if (menuList[index]["screen"] == "BankDetails") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BankDetails(
                              bankData: _societyData,
                            ),
                          ),
                        );
                      } else
                        Navigator.pushNamed(
                            context, "/${menuList[index]["screen"]}");
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              menuList[index]["image"],
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              menuList[index]["title"],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              ),
      ),
    );
  }
}
