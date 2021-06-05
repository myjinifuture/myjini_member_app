import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/component/MyAnswerComponent.dart';
import 'package:smart_society_new/Member_App/component/PollingQuestionCard.dart';

class PollingScreen extends StatefulWidget {
  @override
  _PollingScreenState createState() => _PollingScreenState();
}

class _PollingScreenState extends State<PollingScreen> {
  List PollingData = new List();
  bool isLoading = false;
  String SocietyId, MemberId,wingId;
  ProgressDialog pr;

  @override
  void initState() {
    _getLocaldata();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      MemberId = prefs.getString(constant.Session.Member_Id);
      wingId = prefs.getString(constant.Session.WingId);
    });
    GetPollingData();
  }

  GetPollingData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyId": SocietyId,
          "memberId": MemberId,
          "wingId" : wingId
        };
        Services.responseHandler(
                apiName: "admin/getAllPollingQuestion_v1", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              PollingData = data.Data;
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //     icon: Icon(Icons.arrow_back),
            //     onPressed: () {
            //       Navigator.pushReplacementNamed(context, "/HomeScreen");
            //     }),
            centerTitle: true,
            title: Text(
              'Polling',
              style: TextStyle(fontSize: 18),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          body: isLoading == false
              ? PollingData.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return AnswerList(PollingData[index], index + 1,
                            () {
                          GetPollingData();
                        });
                      },
                      itemCount: PollingData.length,
                    )
                  : Container(
                      child: Center(
                        child: Text("No Polling Added"),
                      ),
                    )
              : Container()),
        isLoading == true
            ? Opacity(
            opacity: 0.5,
            child: Container(
              color: Colors.black,
            ))
            : Container(),
        isLoading == true
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,),
          ),
        )
            : Container(),]
    );
  }
}
