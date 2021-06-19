import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Component/DocumentComponent.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class Document extends StatefulWidget {
  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  bool isLoading = false;
  List _documentData = [];

  @override
  void initState() {
    _getDocument();
    getLocalData();
  }

  String societyId,wingId;

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(Session.SocietyId);
    wingId = prefs.getString(Session.WingId);
  }

  _getDocument() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : societyId,
          "wingId" : wingId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getSocietyDocs",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _documentData = data.Data;
              isLoading = false;
            });
          } else {
            setState(() {
              _documentData = data.Data;
              isLoading = false;
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Document",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, "/Dashboard");
        //   },
        // ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: isLoading
            ? LoadingComponent()
            : _documentData.length > 0
                ? AnimationLimiter(
                    child: ListView.builder(
                    itemCount: _documentData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DocumentComponent(_documentData[index], index,
                          (type) {
                        if (type == "false")
                          setState(() {
                            _getDocument();
                          });
                        else if (type == "loading")
                          setState(() {
                            isLoading = true;
                          });
                      });
                    },
                  ))
                : Center(child: Text('No Data Found'),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/AddDocument');
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: cnst.appPrimaryMaterialColor,
      ),
    );
  }
}
