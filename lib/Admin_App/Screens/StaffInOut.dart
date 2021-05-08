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
              _wingList = data.Data;
              isLoading = false;
              selectedWing = data.Data[0]["_id"].toString();
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
        Services.responseHandler(apiName: "member/getSocietyStaff", body: data)
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Staffs",
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
      body: Column(
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     for (int i = 0; i < _wingList.length; i++) ...[
                //       GestureDetector(
                //         onTap: () {
                //           if (selectedWing != _wingList[i]["_id"].toString()) {
                //             setState(() {
                //               selectedWing = _wingList[i]["_id"].toString();
                //             });
                //             // setState(() {
                //             //   _StaffData = [];
                //             // });
                //             // getStaffData(
                //             //   _fromDate.toString(),
                //             //   _toDate.toString(),
                //             //   _wingList[i]["Id"].toString(),
                //             // );
                //           }
                //         },
                //         child: Container(
                //           width: selectedWing == _wingList[i]["_id"].toString()
                //               ? 60
                //               : 45,
                //           height:
                //               selectedWing == _wingList[i]["_id"].toString()
                //                   ? 60
                //                   : 45,
                //           margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                //           decoration: BoxDecoration(
                //               color: selectedWing ==
                //                       _wingList[i]["_id"].toString()
                //                   ? cnst.appPrimaryMaterialColor
                //                   : Colors.white,
                //               border: Border.all(
                //                   color: cnst.appPrimaryMaterialColor),
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(4))),
                //           alignment: Alignment.center,
                //           child: Text(
                //             "${_wingList[i]["wingName"]}",
                //             style: TextStyle(
                //                 color: selectedWing ==
                //                         _wingList[i]["_id"].toString()
                //                     ? Colors.white
                //                     : cnst.appPrimaryMaterialColor,
                //                 fontSize: 19),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Row(
                //         children: <Widget>[
                //           GestureDetector(
                //             onTap: () {
                //               _showFromDatePicker();
                //             },
                //             child: Container(
                //               height: 37,
                //               decoration: BoxDecoration(
                //                   color: Colors.grey[200],
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(5))),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Padding(padding: EdgeInsets.only(left: 5)),
                //                   Text(
                //                     "${_fromDate.toString().substring(8, 10)}-${_fromDate.toString().substring(5, 7)}-${_fromDate.toString().substring(0, 4)}",
                //                     style: TextStyle(fontSize: 13),
                //                   ),
                //                   Padding(padding: EdgeInsets.only(left: 5)),
                //                   Container(
                //                     width: 50,
                //                     height: 55,
                //                     decoration: BoxDecoration(
                //                         color: cnst.appPrimaryMaterialColor,
                //                         borderRadius: BorderRadius.only(
                //                             topRight: Radius.circular(5),
                //                             bottomRight: Radius.circular(5))),
                //                     child: Icon(
                //                       Icons.date_range,
                //                       color: Colors.white,
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.only(left: 5, right: 5),
                //             child: Text("To ",
                //                 style: TextStyle(
                //                     fontSize: 13,
                //                     fontWeight: FontWeight.w600)),
                //           ),
                //           Container(
                //             height: 37,
                //             decoration: BoxDecoration(
                //                 color: Colors.grey[200],
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(5))),
                //             child: Row(
                //               mainAxisAlignment:
                //                   MainAxisAlignment.spaceBetween,
                //               children: <Widget>[
                //                 Padding(padding: EdgeInsets.only(left: 5)),
                //                 Text(
                //                   "${_toDate.toString().substring(8, 10)}-${_toDate.toString().substring(5, 7)}-${_toDate.toString().substring(0, 4)}",
                //                   style: TextStyle(fontSize: 13),
                //                 ),
                //                 Padding(padding: EdgeInsets.only(left: 5)),
                //                 GestureDetector(
                //                   onTap: () {
                //                     _showToDatePicker();
                //                   },
                //                   child: Container(
                //                     width: 50,
                //                     height: 55,
                //                     decoration: BoxDecoration(
                //                         color: cnst.appPrimaryMaterialColor,
                //                         borderRadius: BorderRadius.only(
                //                             topRight: Radius.circular(5),
                //                             bottomRight: Radius.circular(5))),
                //                     child: Icon(
                //                       Icons.date_range,
                //                       color: Colors.white,
                //                     ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //       Padding(padding: EdgeInsets.only(left: 4)),
                //       Expanded(
                //         child: RaisedButton(
                //             color: cnst.appPrimaryMaterialColor,
                //             child: Icon(
                //               Icons.search,
                //               color: Colors.white,
                //             ),
                //             onPressed: () {
                //               // getStaffData(_fromDate.toString(),
                //               //     _toDate.toString(), selectedWing
                //             }),
                //       ),
                //     ],
                //   ),
                // ),
                // Divider(),
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
