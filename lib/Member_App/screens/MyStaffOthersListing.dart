import 'package:flutter/material.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class MyStaffOthersListing extends StatefulWidget {
  const MyStaffOthersListing({Key key}) : super(key: key);

  @override
  _MyStaffOthersListingState createState() => _MyStaffOthersListingState();
}

class _MyStaffOthersListingState extends State<MyStaffOthersListing> {
  bool isLoading = false;
  List othersList = [];
  String initialDate;
  String selectedDate = "";
  String flatId;
  String societyId;
  String wingId;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    _getMaidListing();
    initialDate = DateTime.now().toString().split(" ")[0].split("-")[2] +
        "/" +
        DateTime.now().toString().split(" ")[0].split("-")[1] +
        "/" +
        DateTime.now().toString().split(" ")[0].split("-")[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        initialDate = pickedDate.toString().split(" ")[0].split("-")[2] +
            "/" +
            pickedDate.toString().split(" ")[0].split("-")[1] +
            "/" +
            pickedDate.toString().split(" ")[0].split("-")[0];
      });
      _getMaidListing(date: initialDate);
    }
  }

  _getMaidListing({String date}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        flatId = prefs.getString(cnst.Session.FlatId);
        societyId = prefs.getString(cnst.Session.SocietyId);
        wingId = prefs.getString(cnst.Session.WingId);
        var data = {
          "flatId": flatId,
          "societyId": societyId,
          "wingId": wingId,
          "isMaid": false,
          "fromDate" : date,
          "toDate" : date
        };
        setState(() {
          isLoading = true;
        });
        othersList.clear();
        Services.responseHandler(apiName: "member/getMemberStaffEntry", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              othersList=data.Data;
              // for (int i = 0; i < data.Data.length; i++) {
              //   if (data.Data[i]["StaffData"][0]["staffCategory"].toString() ==
              //       "Maid") {
              //     othersList.add(data.Data[i]);
              //   }
              // }
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Stack(
      children: [
        othersList.length > 0
            ? ListView.builder(
            itemCount: othersList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          othersList[index]["staffImage"] != null &&
                              othersList[index]["staffImage"] != ""
                              ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                  child: /*widget._staffInSideList["Image"] == null && widget._staffInSideList["Image"] == '' ?*/
                                  FadeInImage.assetNetwork(
                                      placeholder: 'images/user.png',
                                      image:
                                      "${cnst.Image_Url}${othersList[index]["staffImage"]}",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fill)))
                              : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                  child: Image.asset(
                                    'images/user.png',
                                    width: 50,
                                    height: 50,
                                  ))),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.63,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${othersList[index]["Name"]}".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  children: <Widget>[
                                    Text("${othersList[index]["staffCategory"]}",
                                        style: TextStyle(color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 4.0, top: 4.0),
                                      child: othersList.length > 0
                                          ? othersList[index]['EntryData']["outDateTime"].length == 0
                                          ? Container(
                                        height: 20,
                                        width: 60,
                                        child: Center(
                                            child: Text('Inside',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontSize: 12))),
                                        decoration: BoxDecoration(
                                            color: Colors.green[500],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0))),
                                      )
                                          : Container(
                                        height: 20,
                                        width: 60,
                                        child: Center(
                                            child: Text('OutSide',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontSize: 12))),
                                        decoration: BoxDecoration(
                                            color: Colors.red[500],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0))),
                                      )
                                          : Container(),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_downward,
                                      color: Colors.green,
                                    ),
                                    Text("${othersList[index]['EntryData']["inDateTime"][1]}"),
                                    othersList[index]['EntryData']["outDateTime"].length == 0
                                        ? Container()
                                        : Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                    othersList[index]['EntryData']["outDateTime"].length == 0
                                        ? Container()
                                        : Text("${othersList[index]['EntryData']["outDateTime"][1]}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 9, right: 7),
                            child: GestureDetector(
                                onTap: () {
                                  launch("tel:${othersList[index]["ContactNo1"]}");
                                },
                                child: Icon(Icons.phone, color: Colors.green, size: 25)),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 8.0),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // launch("tel:${othersList["EmergencyContactNo"]}");
                          //     },
                          //     child: Image.asset("images/emergancycall.png",
                          //         color: Colors.red, height: 25, width: 25),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            })
            : Container(
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
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      )))),
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }
}
