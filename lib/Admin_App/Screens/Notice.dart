import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoticeComponent.dart';
import 'package:smart_society_new/Admin_App/Screens/AddNotice.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  bool isLoading = true;
  List noticeData = new List();
  String SocietyId;

  @override
  void initState() {
    getNotice();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(Session.SocietyId);
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

  getNotice() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : SocietyId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getSocietyNotice",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              noticeData = data.Data;
              isLoading = false;
            });
          } else {
            setState(() {
              noticeData = data.Data;
              isLoading = false;
            });
            //showMsg("Data Not Found");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Notices',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Navigator.pushNamed(context, "/AddNotice");
            Navigator.pushReplacementNamed(context, '/AddNotice');
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: cnst.appPrimaryMaterialColor,
        ),
        body: Container(
          color: Colors.grey[200],
          child: isLoading
              ? LoadingComponent()
              : noticeData.length > 0
                  ? AnimationLimiter(
                      child: ListView.builder(
                      itemCount: noticeData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NoticeComponent(noticeData[index], index,
                            (type) {
                          if (type == "false")
                            setState(() {
                              getNotice();
                            });
                          else if (type == "loading")
                            setState(() {
                              isLoading = true;
                            });
                        });
                      },
                    ))
                  : NoDataComponent(),
        ),
      ),
    );
  }
}
