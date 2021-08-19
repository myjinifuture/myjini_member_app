import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'dart:io';

class Parcel extends StatefulWidget {
  @override
  _ParcelState createState() => _ParcelState();
}

class _ParcelState extends State<Parcel> {
  TextEditingController _txtDelivervPername = TextEditingController();
  TextEditingController _txtMobileno = TextEditingController();
  TextEditingController _txtGroupName = TextEditingController();
  bool isbottomBar = false;
  bool isSecurity = false;
  int _value = 1;
  DateTime _datetime1 = DateTime.now();
  var id;

  String _currentparcel;
  List companyList = [];
  List parcelAddList = [];

  var companyId;
  var Personname;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParcelData();
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
              },
            ),
          ],
        );
      },
    );
  }

  getaddParcelData(String id,personName,mobileNo,date,security) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "companyName": id,
          "deliveryPersonName": _txtDelivervPername.text,
          "contactNo": _txtMobileno.text,
          "estimatedArrivalDate": DateFormat('dd/MM/yyyy').format(_datetime1),
          "isSecurity" : isSecurity
        };
        print(data);
        Services.responseHandler(apiName:"member/addParcelDetail",body: data).then(
                (data) async {
              if (data.Data.length > 0) {
                setState(() {
                  parcelAddList = data.Data;
                  print(data.Data);
                });
              }
            }, onError: (e) {
          print(e);
          showMsg("Something Went Wrong.\nPlease Try Again");// direct aa message print kare 6
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getParcelData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {};
        Services.responseHandler(apiName: "member/getParcelCompanyDetail", body: data)
            .then((data) async {
          print("data");
          print(data.Data);
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              companyList = data.Data;
              print(data.Data);
            });
            }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  /*getParcelData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {};
        print(data);
        Services.responseHandler(apiName:"member/getParcelCompanyDetail",body: data).then(
                (data) async {
                  if (data.Data.length > 0) {
                    setState(() {
                      companyList = data.Data;
                      print(data.Data);
                    });
                  }

            }, onError: (e) {
                  print(e);
          showMsg("Something Went Wrong.\nPlease Try Again");// direct aa message print kare 6
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(
            "Parcel",
            style: TextStyle(fontSize: 18, fontFamily: "OpenSans"),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                stops: [0.1, 7.0],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.0),
                                    topLeft: Radius.circular(25.0)),
                              ),
                              child: Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 20.0)),
                                  Text(
                                    "Parcel",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "OpenSans"),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 235.0)),
                                  isbottomBar
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isbottomBar = !isbottomBar;
                                            });
                                          })
                                      : IconButton(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isbottomBar = !isbottomBar;
                                            });
                                          })
                                ],
                              ),
                            ),
                            bottomBar(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bottomBar() {
    return Visibility(
      visible: isbottomBar,
      child: Container(
        height: MediaQuery.of(context).size.height / 1.8,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Company Name",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _currentparcel,
                        iconSize: 30,
                        dropdownColor: Colors.deepPurple[50],
                        icon: (null),
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        hint: Text('Select Company'),
                        onChanged: (String newValue){
                         setState(() {
                           _currentparcel = newValue;
                           print(_currentparcel);
                         });
                        },
                        items: companyList?.map((itemState) {
                          return DropdownMenuItem(
                            child: Text(itemState['companyName']),
                            value:itemState['_id'].toString(),
                          );
                        })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Row(
                  children: [
                    Text(
                      "Delivery Person Name",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Text(
                      "(optional)",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontFamily: "OpenSans"),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  child: TextFormField(
                    controller: _txtDelivervPername,
                    decoration: InputDecoration(
                      labelText: "Deliver Person Name",
                      isDense: true,
                      hintText: "Enter Deliver Person Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Row(
                  children: [
                    Text(
                      "Mobile Number",
                      style: TextStyle(fontFamily: "OpenSans"),
                    ),
                    Text(
                      "(optional)",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontFamily: "OpenSans"),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  child: TextFormField(
                    controller: _txtMobileno,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      isDense: true,
                      hintText: "Enter Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Text(
                  "Estimated Arival Date",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Container(
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_datetime1 == null
                              ? 'No date Select!'
                              : '${DateFormat('dd/MM/yyyy').format(_datetime1)}'),
                          Padding(padding: EdgeInsets.only(left: 195)),
                          InkWell(
                            child: Icon(
                              Icons.arrow_right,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2001),
                                      lastDate: DateTime(2022))
                                  .then((date) {
                                setState(() {
                                  _datetime1 = date;
                                });
                              });
                            },
                          )
                        ],
                      ),
                    )),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text(
                      "Leave parcel at the Security \nGate0",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "OpenSans"),
                    ),
                    Padding(padding: EdgeInsets.only(left: 70)),
                  Checkbox(
                    checkColor: Colors.white,
                    value: isSecurity,
                    onChanged: (bool value) {
                      setState(() {
                        isSecurity = value;
                      });
                    },
                  ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        getaddParcelData(id,_txtDelivervPername.text,_txtMobileno.text,_datetime1,isSecurity);
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: Colors.deepPurple,
                    child: Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 100.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
