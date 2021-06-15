import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Services.dart' as S;
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Component/StaffComponentBywing.dart';
import 'package:smart_society_new/Admin_App/Component/SocietyStaffComponent.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/AddStaff.dart';

class StaffInOut extends StatefulWidget {
  @override
  _StaffInOutState createState() => _StaffInOutState();
}

class _StaffInOutState extends State<StaffInOut> with TickerProviderStateMixin {
  bool isLoading = false, isStaffLoading = false,isSocietyStaffLoading = false;
  List _StaffData = [];
  List societyStaffData = [];
  List _wingList = [];

  String month = "", selectedWing = "";
  String _format = 'yyyy-MMMM-dd';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  DateTime _fromDate;
  DateTime _toDate;

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);

    _fromDate = DateTime.now();
    _toDate = DateTime.now();
    _getLocaldata();

    getSocietyStaff();
  }

  String SocietyId;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(Session.SocietyId);
    _getWing(SocietyId);
  }

  _getWing(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": societyId};

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(
                apiName: "admin/getAllWingOfSociety", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(data.Data[i]["totalFloor"].toString()!="0"){
                  _wingList.add(data.Data[i]);
                }
              }
              // _wingList = data.Data;
              isLoading = false;
              selectedWing = _wingList[0]["_id"].toString();
            });

            // S.Services.getStaffData(DateTime.now().toString(), DateTime.now().toString(),
            //     data[0]["Id"].toString());
          } else {
            setState(() {
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

  _getotherListing(String societyId, String fromdate, String todate) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": SocietyId,
          // "fromDate": fromdate,
          // "toDate": todate
        };

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getStaffDetails", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _StaffData = data.Data;
              isLoading = false;
            });
            for (int i = 0; i < _StaffData.length; i++) {
              if (_StaffData[i]["isForSociety"].toString() == "true") {
                setState(() {
                  societyStaffData.add(_StaffData[i]);
                });
              }
            }
          } else {
            setState(() {
              isLoading = false;
              _StaffData = data.Data;
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

  getSocietyStaff() async {
    _getotherListing(SocietyId, _fromDate.toString(), _toDate.toString());
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": SocietyId,
        };
        setState(() {
          isSocietyStaffLoading = true;
        });
        Services.responseHandler(apiName: "member/getSocietyStaff_v1", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              societyStaffData = data.Data;
              isSocietyStaffLoading = false;
            });
          } else {
            setState(() {
              isSocietyStaffLoading = false;
              societyStaffData = data.Data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isSocietyStaffLoading = false;
          });
        });
      } else {
        showMsg("Something went worng!!!");
        setState(() {
          isSocietyStaffLoading = false;
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _showFromDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _fromDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _fromDate = dateTime;
        });
      },
    );
  }

  void _showToDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _toDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _toDate = dateTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_tabController.index);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Staffs",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
              children: <Widget>[
                TabBar(
                  unselectedLabelColor: Colors.grey[500],
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        "Society Staffs",
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Flat Staffs",
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      isSocietyStaffLoading
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : societyStaffData.length > 0
                              ? Container(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: societyStaffData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SocietyStaffComponent(
                                          visitorData:
                                              societyStaffData[index],
                                          index: index,
                                          onMap: getSocietyStaff,
                                          onUnMap: getSocietyStaff,
                                          onDelete: getSocietyStaff,
                                          // onDelete: () {
                                          //   setState(() {
                                          //     _getotherListing(
                                          //         SocietyId,
                                          //         _fromDate.toString(),
                                          //         _toDate.toString());
                                          //                                           });
                                          // },
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text('No Data Found'),
                                ),
                      isStaffLoading
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _StaffData.length > 0
                              ? Container(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: _StaffData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return StaffComponentBywing(
                                          visitorData: _StaffData[index],
                                          index: index,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text('No Data Found'),
                                ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStaff(onAddStaff: getSocietyStaff,),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: cnst.appPrimaryMaterialColor,
      ),
    );
  }
}
