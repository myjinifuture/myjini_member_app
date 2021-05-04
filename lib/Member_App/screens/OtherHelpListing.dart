import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/component/OtherHelpComponent.dart';

class OtherHelpListing extends StatefulWidget {
  @override
  _OtherHelpListingState createState() => _OtherHelpListingState();
}

class _OtherHelpListingState extends State<OtherHelpListing> {
  bool isLoading = true;
  List otherList = [];
  String SocietyId;
  String initialDate;

  @override
  void initState() {
    super.initState();
    initialDate = DateTime.now().toString().split(" ")[0].split("-")[2] + "/" +
        DateTime.now().toString().split(" ")[0].split("-")[1] +
        "/"+ DateTime.now().toString().split(" ")[0].split("-")[0];
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(Session.SocietyId);
    _getMaidListing(initialDate);
  }

  _getMaidListing(String date) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": SocietyId,
          "toDate": date
        };
        setState(() {
          isLoading = true;
        });
        otherList.clear();
        Services.responseHandler(apiName: "admin/getStaffEntry",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              // otherList = data.Data;
              isLoading = false;
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["StaffData"][0]["staffCategory"]!="Maid"){
                  otherList.add(data.Data[i]);
                }
              }
            });
          } else {
            setState(() {
              isLoading = false;
              otherList = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
        });
      } else {
        showMsg("Something went worng!!!");
        setState(() {
          isLoading = false;
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
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  String selectedDate = "";
  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        initialDate = pickedDate.toString().split(" ")[0].split("-")[2] + "/" +
            pickedDate.toString().split(" ")[0].split("-")[1] +
            "/"+ pickedDate.toString().split(" ")[0].split("-")[0];
      });
      _getMaidListing(initialDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(otherList.length);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        :  Stack(
      children: [
        otherList.length > 0
            ? ListView.builder(
            itemCount: otherList.length,
            itemBuilder: (BuildContext context, int index) {
              // if(otherList[index]["StaffData"].length > 0 && otherList[index]["StaffData"][0]["staffCategory"]=="Maid") {
                return OtherHelpComponent(otherList[index]);
              // };
            }): Container(
    child: Center(child: Text("No Data Found")),
    ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                "Date Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      )
                  )
              )
          ),
        ),
      ],
            );

  }
}
