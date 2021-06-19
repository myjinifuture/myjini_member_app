import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/screens/DailyServicesStaffListing.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class DailyServicesScreen extends StatefulWidget {
  const DailyServicesScreen({Key key}) : super(key: key);

  @override
  _DailyServicesScreenState createState() => _DailyServicesScreenState();
}

class _DailyServicesScreenState extends State<DailyServicesScreen> {
  bool isLoading = false;
  List staffData = [];

  @override
  void initState() {
    getDailyServicesStaff();
  }

  getDailyServicesStaff() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String societyId = prefs.getString(constant.Session.SocietyId);
        var data = {
          "societyId": societyId,
        };
        Services.responseHandler(
                apiName: "member/getStaffCategorywise", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            print("api called successfully");
            setState(() {
              isLoading = false;
              staffData = data.Data;
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
    print("staffData");
    print(staffData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Services'),
        centerTitle: true,
      ),
      body: isLoading == false
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: staffData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          staffData[index]["staffCategoryName"] != 'Watchmen'
                              ? ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        staffData[index]["staffCategoryName"],
                                        style: TextStyle(fontFamily: 'OpenSans',
                                          // fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        staffData[index]["StaffCount"]
                                            .toString(),
                                        style: TextStyle(fontFamily: 'OpenSans',
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DailyServicesStaffListing(
                                          staffData: staffData[index],
                                          title: staffData[index]
                                              ["staffCategoryName"],

                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          staffData[index]["staffCategoryName"] != 'Watchmen'
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey,
                                  height: 1,
                                )
                              : Container(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
