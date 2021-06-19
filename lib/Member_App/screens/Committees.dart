import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class Committees extends StatefulWidget {
  @override
  _CommitteesState createState() => _CommitteesState();
}

class _CommitteesState extends State<Committees> {
  List _committeeData = new List();
  bool isLoading = false;

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

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  Widget _committeeWidget(BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 100,
        child: FadeInAnimation(
          child: Card(
            margin: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${_committeeData[index]["Name"]} :",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _committeeData[index]["committelist"].length > 0
                      ? SizedBox(
                          height: _committeeData[index]["committelist"].length *
                              110.0,
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index2) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.4)),
                                            width: 64,
                                            height: 64,
                                          ),
                                          ClipOval(
                                            child: _committeeData[index]
                                                                ["committelist"]
                                                            [index2]["Image"] !=
                                                        "null" &&
                                                    _committeeData[index]
                                                                ["committelist"]
                                                            [index2]["Image"] !=
                                                        ""
                                                ? FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "images/user.png",
                                                    image: Image_Url +
                                                        '${_committeeData[index]["committelist"][index2]["Image"]}',
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "images/user.png",
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                          ),
                                        ],
                                        alignment: Alignment.center,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Expanded(
                                          child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "${_committeeData[index]["committelist"][index2]["Name"]}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "${_committeeData[index]["committelist"][index2]["ContactNo"]}",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.call,
                                                size: 23,
                                                color: Colors.green[700],
                                              ),
                                              onPressed: () {
                                                launch(
                                                    "tel:${_committeeData[index]["committelist"][index2]["ContactNo"]}");
                                              }),
                                          GestureDetector(
                                            onTap: () {
                                              _openWhatsapp(
                                                  _committeeData[index]
                                                          ["committelist"]
                                                      [index2]["ContactNo"]);
                                            },
                                            child: Image.asset(
                                                "images/whatsapp.png",
                                                width: 30,
                                                height: 30),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Designation ",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ": ${_committeeData[index]["committelist"][index2]["Designation"]}",
                                          style: TextStyle(
                                              color: constant
                                                  .appPrimaryMaterialColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                            itemCount:
                                _committeeData[index]["committelist"].length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                          ),
                        )
                      : Text("No Data Found"),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Committee Members', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : _committeeData.length > 0
              ? AnimationLimiter(
                  child: ListView.builder(
                    itemBuilder: _committeeWidget,
                    itemCount: _committeeData.length,
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
                        child: Text("No Data Found",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                ),
    );
  }
}
