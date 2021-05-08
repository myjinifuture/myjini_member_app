import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Component/VisitorComponent.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class VisitorByWing extends StatefulWidget {
  @override
  _VisitorByWingState createState() => _VisitorByWingState();
}

class _VisitorByWingState extends State<VisitorByWing> {
  bool isLoading = false, isVisitorLoading = false;
  List _visitorData = [];
  List _wingList = [];

  String month = "";
  String selectedWing = "";
  String _format = 'yyyy-MMMM-dd';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  DateTime _fromDate;
  DateTime _toDate;

  @override
  void initState() {
    getLocaldata();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
  }

  String societyId;
  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
    });
    _getVisitorsOfSociety(societyId);
  }

  _getVisitorsOfSociety(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : societyId
        };

        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "watchman/getAllVisitorEntry",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _visitorData = data.Data;
              isLoading = false;
              // selectedWing = data.Data[0]["Id"].toString();
            });
            // getVisitorData(DateTime.now().toString(), DateTime.now().toString(),
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

  // getVisitorData(String fromDate, String toDate, wingId) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       Future res = Services.getVisitorByWing(wingId, fromDate, toDate);
  //       setState(() {
  //         isVisitorLoading = true;
  //       });
  //       res.then((data) async {
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             _visitorData = data;
  //             isVisitorLoading = false;
  //           });
  //         } else {
  //           setState(() {
  //             _visitorData = data;
  //             isVisitorLoading = false;
  //           });
  //         }
  //       }, onError: (e) {
  //         showMsg("Something Went Wrong Please Try Again");
  //         setState(() {
  //           isVisitorLoading = false;
  //         });
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     showMsg("No Internet Connection.");
  //   }
  // }

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
        print(dateTime);
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
    print("_visitorData");
    print(_visitorData);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Visitors",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
            },
          ),
        ),
        body: isLoading
            ? LoadingComponent()
            : Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < _wingList.length; i++) ...[
                        GestureDetector(
                          onTap: () {
                            if (selectedWing != _wingList[i]["_id"].toString()) {
                              setState(() {
                                selectedWing = _wingList[i]["_id"].toString();
                              });
                              setState(() {
                                _visitorData = [];
                              });
                              // getVisitorData(
                              //     _fromDate.toString(),
                              //     _toDate.toString(),
                              //     _wingList[i]["Id"].toString());
                            }
                          },
                          child: Container(
                            width: selectedWing == _wingList[i]["_id"].toString()
                                ? 60
                                : 45,
                            height:
                                selectedWing == _wingList[i]["_id"].toString()
                                    ? 60
                                    : 45,
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            decoration: BoxDecoration(
                                color: selectedWing ==
                                        _wingList[i]["_id"].toString()
                                    ? cnst.appPrimaryMaterialColor
                                    : Colors.white,
                                border: Border.all(
                                    color: cnst.appPrimaryMaterialColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            alignment: Alignment.center,
                            child: Text(
                              "${_wingList[i]["wingName"]}",
                              style: TextStyle(
                                  color: selectedWing ==
                                          _wingList[i]["_id"].toString()
                                      ? Colors.white
                                      : cnst.appPrimaryMaterialColor,
                                  fontSize: 19),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showFromDatePicker();
                              },
                              child: Container(
                                height: 37,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Text(
                                      "${_fromDate.toString().substring(8, 10)}-${_fromDate.toString().substring(5, 7)}-${_fromDate.toString().substring(0, 4)}",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Container(
                                      width: 50,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: cnst.appPrimaryMaterialColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text("To ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              height: 37,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    "${_toDate.toString().substring(8, 10)}-${_toDate.toString().substring(5, 7)}-${_toDate.toString().substring(0, 4)}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  GestureDetector(
                                    onTap: () {
                                      _showToDatePicker();
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: cnst.appPrimaryMaterialColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Expanded(
                          child: RaisedButton(
                              color: cnst.appPrimaryMaterialColor,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // getVisitorData(_fromDate.toString(),
                                //     _toDate.toString(), selectedWing);
                              }),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  isVisitorLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: _visitorData.length > 0
                              ? Container(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: _visitorData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return VisitorComponent(
                                            _visitorData[index], index);
                                      },
                                    ),
                                  ),
                                )
                              : NoDataComponent(),
                        ),
                ],
              ),
      ),
    );
  }
}
