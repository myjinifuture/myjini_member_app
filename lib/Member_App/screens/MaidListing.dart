import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/component/MaidComponent.dart';

class MaidListing extends StatefulWidget {
  @override
  _MaidListingState createState() => _MaidListingState();
}

class _MaidListingState extends State<MaidListing> {
  bool isLoading = true;
  List maidList = [];
  String initialDate;


  @override
  void initState() {
    super.initState();
    initialDate = DateTime.now().toString().split(" ")[0].split("-")[2] + "/" +
        DateTime.now().toString().split(" ")[0].split("-")[1] +
        "/"+ DateTime.now().toString().split(" ")[0].split("-")[0];
    getLocalData();
    _getMaidListing(initialDate); // Tell monil to give Maid service - 2 number ------Completed at 1:57 PM 2nd april 2021
  }

  String societyId = "";
  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
    });
  }

  _getMaidListing(String date) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": societyId,
          "toDate": date
        };
        setState(() {
          isLoading = true;
        });
        maidList.clear();
        Services.responseHandler(apiName: "admin/getStaffEntry",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              // maidList = data.Data;
              // isLoading = false;
              // maidList = data.Data;
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["StaffData"][0]["staffCategory"].toString()=="Maid"){
                  maidList.add(data.Data[i]);
                }
              }
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              maidList = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
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
    return isLoading
        ? Center(child: CircularProgressIndicator())
        :  Stack(
      children: [
    maidList.length > 0
    ?ListView.builder(
            itemCount: maidList.length,
            itemBuilder: (BuildContext context, int index) {
              print(maidList);
              // ignore: missing_return
              // if(maidList[index]["StaffData"].length > 0 &&
              //     maidList[index]["StaffData"][0]["staffCategory"].toString()=="Maid") {
                return MaidComponent(maidList[index]);
              // };
            }):Container(
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
