 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List NoticeData = new List();
  bool isLoading = false;
  String SocietyId;

  @override
  void initState() {
    GetNoticeDetail();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
              .toString();
    }
    return final_date;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  GetNoticeDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyId" : SocietyId
        };
        Services.responseHandler(apiName: "admin/getSocietyNotice",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              NoticeData = data.Data;
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _NoticeCard(BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 100,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 6.0, right: 6.0),
            child: Card(
              elevation: 2,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("${NoticeData[index]["Title"]}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: constant.appPrimaryMaterialColor)),
                  ),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    child: Center(
                      child: Text(NoticeData[index]["dateTime"][0],
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                          ),
                      ),
                    ),
                  ),
//            Row(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.only(left: 15.0, top: 8),
//                  child: Text("Dear Members",
//                      style: TextStyle(
//                          fontWeight: FontWeight.w600,
//                          fontSize: 16,
//                          color: Colors.grey[800])),
//                )
//              ],
//            ),
                  Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 12.0, right: 12.0, bottom: 8.0),
                        child: Text(
                          "${NoticeData[index]["Description"]}",
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: NoticeData[index]["FileAttachment"] != ""
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                _launchURL(Image_Url +
                                    "${NoticeData[index]["FileAttachment"]}");
                              },
                              child: Container(
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        new Radius.circular(75.0)),
                                  ),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.remove_red_eye,
                                          size: 20,
                                          color:
                                              constant.appPrimaryMaterialColor),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: Text("View Document",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: constant
                                                    .appPrimaryMaterialColor)),
                                      ),
                                    ],
                                  ))),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/HomeScreen");
              }),
          centerTitle: true,
          title: Text('Notice', style: TextStyle(fontSize: 18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          child: isLoading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : NoticeData.length > 0
                  ? AnimationLimiter(
                      child: ListView.builder(
                        itemBuilder: _NoticeCard,
                        itemCount: NoticeData.length,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("images/no_data.png",
                              width: 50, height: 50, color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("No Notice Found",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
