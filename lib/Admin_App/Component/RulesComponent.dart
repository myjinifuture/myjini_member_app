import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Screens/UpdateRules.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesComponent extends StatefulWidget {
  var rulesData;

  // final Function onChange;
  Function onUpdate;
  Function onDelete;
  int index;

  RulesComponent({this.rulesData, this.index,this.onUpdate,this.onDelete});

  @override
  _RulesComponentState createState() => _RulesComponentState();
}

class _RulesComponentState extends State<RulesComponent> {
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
    }
    final_date = date == "" || date == null
        ? ""
        : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
            .toString();

    return final_date;
  }

  _deleteRules() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // widget.onChange("loading");
        var data = {"ruleId": widget.rulesData["_id"].toString(),};
        Services.responseHandler(apiName: "admin/deleteSocietyRule", body: data)
            .then((data) async {
          if (data.Data.toString() == "1" && data.IsSuccess == true) {
            // widget.onChange("false");
              widget.onDelete();
          } else {
            // widget.onChange("false");
            showMsg("Notice Is Not Delete");
          }
        }, onError: (e) {
          // widget.onChange("false");
          print("Error : on Delete Notice $e");
          showMsg("Something Went Wrong Please Try Again");
          // widget.onChange("false");
        });
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
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

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Delete this Rule ?"),
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
                _deleteRules();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 450),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 6, right: 6),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 10, left: 7, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset("images/rules_small_icon.png",
                          width: 24, height: 24, fit: BoxFit.fill),
                      Padding(padding: EdgeInsets.only(left: 4)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${widget.rulesData["Title"]}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(widget.rulesData["dateTime"][0],
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateRules(rulesData: widget.rulesData,onUpdate: widget.onUpdate,),
                            ),
                          );
                        },
                        child: Image.asset("images/edit_icon.png",
                            width: 24, height: 24, fit: BoxFit.fill),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showConfirmDialog();
                        },
                        child: Image.asset("images/delete_icon.png",
                            width: 24, height: 24, fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text("${widget.rulesData["Description"]}",
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[700])),
                  ),
                  Padding(padding: EdgeInsets.only(top: 6)),
                  widget.rulesData["FileAttachment"] != "" &&
                          widget.rulesData["FileAttachment"] != null
                      ? GestureDetector(
                          onTap: () {
                            _launchURL(Image_Url +
                                "${widget.rulesData["FileAttachment"]}");
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "View File",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                                Padding(padding: EdgeInsets.only(left: 3)),
                                Image.asset("images/attach_download.png",
                                    width: 24, height: 24, fit: BoxFit.fill)
                              ],
                            ),
                          ))
                      : Container()
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
