import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/common/Services.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController txtRefNo = new TextEditingController();
  TextEditingController txtNotes = new TextEditingController();
  TextEditingController txtAmount = new TextEditingController();
  TextEditingController txtExpenseSource = new TextEditingController();

  List _expenseSourceList = [];
  bool isLoading = false;

  String _expenseSource;

  List<String> _paymentTypeList = ["Online","Offline"];
  String _paymentType;
  String currentMode = "";

  @override
  void initState() {
    _getLocaldata();
  }


  String SocietyId;
  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(Session.SocietyId);
    _getExpenseSource();
  }

  _getExpenseSource() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": SocietyId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getTransactionSources",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _expenseSourceList = data.Data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _expenseSourceList = data.Data;
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _onSourceSelect(val) {
    setState(() {
      print(val);
      _expenseSource = val;
      currentMode = val;
    });
  }

  String expenseSourceId;

  _addExpense() async {
    if (txtNotes.text != "" && txtAmount.text != "") {
      if (_expenseSource != null && _paymentType != null) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            SharedPreferences preferences =
            await SharedPreferences.getInstance();
            String SocietyId = preferences.getString(Session.SocietyId);

            setState(() {
              isLoading = true;
            });

            for(int i=0;i<_expenseSourceList.length;i++){
              if(_expenseSourceList[i]["sourceName"] == _expenseSource){
                expenseSourceId = _expenseSourceList[i]["_id"];
                break;
              }
            }
            var data = {
              "sourceId": expenseSourceId,
              "societyId": SocietyId,
              "paymentType": _paymentType,
              "type": "Expense",
              "refNo": txtRefNo==null ? "" : txtRefNo.text,
              "description": txtNotes.text,
              "amount": txtAmount.text
            };
            print("data");
            print(data);
            Services.responseHandler(apiName: "admin/addTransaction",body: data).then((data) async {
              if (data.Data != "0" && data.IsSuccess == true) {
                setState(() {
                  isLoading = false;
                });
                Fluttertoast.showToast(
                    msg: "Expense Added Successfully",
                    backgroundColor: Colors.green,
                    gravity: ToastGravity.TOP,
                    textColor: Colors.white);
                Navigator.pushReplacementNamed(context, "/Expense");
              } else {
                setState(() {
                  isLoading = false;
                });
                showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
              setState(() {
                isLoading = false;
              });
              showMsg("Try Again.");
            });
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else
        Fluttertoast.showToast(
            msg: "Please Select All Fields",
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All Details",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  void _showExpenseSourceDailog() {
    setState(() {
      txtExpenseSource.text = "";
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add Expense Source"),
          content: TextFormField(
            controller: txtExpenseSource,
            scrollPadding: EdgeInsets.all(0),
            decoration: InputDecoration(hintText: "Expense Source Name"),
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Add",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _addExpenseSource();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content:
              new Text("Are You Sure You Want To Delete this Expense Source ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteExpenseSource(id);
              },
            ),
          ],
        );
      },
    );
  }

  _addExpenseSource() async {
    if (txtExpenseSource.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String SocietyId = preferences.getString(Session.SocietyId);

          setState(() {
            isLoading = true;
          });
          var data = {
            "sourceName": txtExpenseSource.text,
            "societyId": SocietyId
          };
          Services.responseHandler(apiName: "admin/addTransactionSource",body: data).then((data) async {
            if (data.Data.length > 0 && data.IsSuccess == true) {
              setState(() {
                isLoading = false;
              });
              Fluttertoast.showToast(
                  msg: "Expense Source Added Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              _getExpenseSource();
            } else {
              setState(() {
                isLoading = false;
              });
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Enter Expense Source Name",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  _deleteExpenseSource(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "sourceId": id
        };
        Services.responseHandler(apiName: "admin/deleteTransactionSource",body: data).then((data) async {
          if (data.Data == "1" && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
            });
            _getExpenseSource();
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Income Source Is Not Delete");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  _onPaymentModeSelect(val) {
    setState(() {
      print(val);
      _paymentType = val;
    });
  }

  _checkValidation() async {
    if (txtNotes.text != "" && txtAmount.text != "") {
      if (_expenseSource != null && _paymentType != null) {
        if (_paymentType.toLowerCase() == "offline") {
          _addExpense();
        } else if (txtRefNo.text != "")
          _addExpense();
        else
          Fluttertoast.showToast(
              msg: "Please Enter Reference Number",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              textColor: Colors.white);
      } else
        Fluttertoast.showToast(
            msg: "Please Select All Fields",
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All Details",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Expense");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Expense",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Expense");
            },
          ),
        ),
        body: isLoading
            ? LoadingComponent()
            : Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _expenseSourceList.length > 0
                                ? SizedBox(
                                    height: 60,
                                    child: InputDecorator(
                                      decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10),
                                            //borderSide: new BorderSide(),
                                          )),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<dynamic>(
                                        hint: _expenseSourceList != null &&
                                                _expenseSourceList != "" &&
                                                _expenseSourceList.length > 0
                                            ? Text("Select Expense Type")
                                            : Text(
                                                "Expense Source Not Found",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                        value: _expenseSource,
                                        onChanged: (val) {
                                          _onSourceSelect(val);
                                        },
                                        items: _expenseSourceList
                                            .map((dynamic Source) {
                                              print("_expenseSourceList");
                                              print(_expenseSourceList);
                                          return new DropdownMenuItem<
                                              dynamic>(
                                            value: Source["sourceName"],
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  Source["sourceName"],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                currentMode != Source["sourceName"]
                                                    ? IconButton(
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.grey,
                                                          size: 22,
                                                        ),
                                                        onPressed: () {
                                                          _showConfirmDialog(
                                                              Source.id);
                                                        })
                                                    : Container()
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      )),
                                    ),
                                  )
                                : Container(),
                          ),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _showExpenseSourceDailog();
                              })
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        height: 60,
                        child: InputDecorator(
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10),
                                //borderSide: new BorderSide(),
                              )),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            hint: _paymentTypeList != null &&
                                    _paymentTypeList != "" &&
                                    _paymentTypeList.length > 0
                                ? Text("Select Income Type")
                                : Text(
                                    "Income Type Not Found",
                                    style: TextStyle(fontSize: 14),
                                  ),
                            value: _paymentType,
                            onChanged: (val) {
                              _onPaymentModeSelect(val);
                            },
                            items:
                                _paymentTypeList.map((String Source) {
                              return new DropdownMenuItem<String>(
                                value: Source,
                                child: Text(
                                  Source,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          )),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      _paymentType == null
                          ? Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                controller: txtRefNo,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.info,
                                    ),
                                    counterText: "",
                                    hintText: "Reference Number"),
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : _paymentType.toLowerCase() != "offline"
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    controller: txtRefNo,
                                    scrollPadding: EdgeInsets.all(0),
                                    decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        prefixIcon: Icon(
                                          Icons.info,
                                        ),
                                        counterText: "",
                                        hintText: "Reference Number"),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : Container(),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: txtNotes,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.sms_failed,
                              ),
                              hintText: "Description"),
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: txtAmount,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.attach_money,
                              ),
                              hintText: "Amount"),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 20,
                          onPressed: () {
                            _checkValidation();
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
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
