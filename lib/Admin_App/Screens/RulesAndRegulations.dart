import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Component/RulesComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class RulesAndRegulations extends StatefulWidget {
  @override
  _RulesAndRegulationsState createState() => _RulesAndRegulationsState();
}

class _RulesAndRegulationsState extends State<RulesAndRegulations> {
  bool isLoading = false;
  List _rulesData = [];

  @override
  void initState() {
    _getRules();
    _getLocalData();
  }

  String societyId;

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(cnst.Session.SocietyId);
    });
  }

  _getRules() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _rulesData.clear();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId = prefs.getString(constant.Session.SocietyId);
        var data = {
          "societyId": societyId,
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getSocietyRules", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _rulesData = data.Data;
              isLoading = false;
            });
            print("_rulesData");
            print(_rulesData);
          } else {
            setState(() {
              isLoading = false;
            });
            // showMsg("Data Not Found");
          }
        }, onError: (e) {
          print("Error : rules data Call $e");
          setState(() {
            isLoading = false;
          });
          showMsg("Something Went Wrong Please Try Again");
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rules & Regulations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: isLoading
            ? LoadingComponent()
            : _rulesData.length > 0
                ? AnimationLimiter(
                    child: ListView.builder(
                    itemCount: _rulesData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RulesComponent(
                        index: index,
                        rulesData: _rulesData[index],
                        // onChange: (type) {
                        //   if (type == "false")
                        //     setState(() {
                        //       _getRules();
                        //     });
                        //   else if (type == "loading")
                        //     setState(() {
                        //       isLoading = true;
                        //     });
                        // },
                        onUpdate: _getRules,
                        onDelete: _getRules,
                      );
                    },
                  ))
                : Center(
                    child: Text('No Data Found'),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/AddRules');
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: cnst.appPrimaryMaterialColor,
      ),
    );
  }
}
