import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class AddEvent extends StatefulWidget {
  Function onAddEvent;
  AddEvent({this.onAddEvent});
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtDesc = TextEditingController();
  TextEditingController txtAmount = TextEditingController();

  DateTime _dateTime = DateTime.now();
  bool isLoading = false;
  String SocietyId, MemberId, ParentId;
  ProgressDialog pr;

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _format = 'yyyy-MMMM-dd';

  List selectedWing = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    MemberId = prefs.getString(constant.Session.Member_Id);
    if (prefs.getString(constant.Session.ParentId) == "null" ||
        prefs.getString(constant.Session.ParentId) == "")
      ParentId = "0";
    else
      ParentId = prefs.getString(constant.Session.ParentId);
    getWingsId(SocietyId);
  }

  void _showDatePicker() {
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
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  showMsg(String title, String msg) {
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
              },
            ),
          ],
        );
      },
    );
  }

  List selectedWingId = [];

  sendWingDetails(List selectedWingId,String eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "eventId": eventId.toString(),
          "wingIdList": selectedWingId.toString()
        };
        print("data inside sending wings");
        print(data);
        Services.responseHandler(apiName: "admin/addEventWings",body: data)
            .then((data) async {
          if (data.Data == "1") {
            print("send wings successfully");
          } else {
            // showMsg("Complaint Is Not Added To Solved","");
          }
        }, onError: (e) {
          // showMsg("Something Went Wrong Please Try Again","");
        });
      }
    } on SocketException catch (_) {
      // showMsg("Something Went Wrong","");
    }
  }

  AddEventDetails() async {
    print(selectedWing);
    print(wingsNameData);
    try {
      selectedWingId.clear();
      for (int i = 0; i < selectedWing.length; i++) {
        for(int j=0;j<wingsNameData.length;j++){
          if(selectedWing[i].toString() == wingsNameData[j]["Name"].toString()){
            selectedWingId.add(wingsNameData[j]["Id"].toString());
          }
        }
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        setState(() {
          isLoading = true;
        });
        var data = {
          "societyId": SocietyId,
          "Title": txtTitle.text,
          "Description" : txtDesc.text,
          "date": _dateTime.toString().substring(8, 10) + "/" + _dateTime.toString().substring(5, 7) + "/" + _dateTime.toString().substring(0, 4),
          "wingIdList": selectedWingId,
          "organisedBy" : "",
          "venue" : "",
          // "EventType": options[tag],
          "EventType": "Free",
          "adminId" : MemberId,

        };
        // FormData formdata = FormData.fromMap(data);
        print("data");
        print(data);
        Services.responseHandler(apiName: "admin/addEvent",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          // sendWingDetails(selectedWingId,data.Data[0]["_id"]); monil told he did in one api at 10:38 am
          // pr.hide();
          if (data.IsSuccess && data.Data.length > 0) {
            setState(() {
              Fluttertoast.showToast(
                  msg: "${data.Message}",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.green,
                  textColor: Colors.white);
              // Navigator.pushReplacementNamed(context, '/HomeScreen');
              Navigator.pop(context);
              widget.onAddEvent();
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "${data.Message}",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                textColor: Colors.white);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.", "");
    }
  }

  int tag = -1;
  List<String> options = [
    'Free',
    'Paid',
  ];


  List wingsNameData = [];
  getWingsId(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "societyId" : societyId
        };
        Services.responseHandler(apiName: "admin/getAllWingOfSociety",body: body).then((data) async {
          if (data !=null) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                wingsNameData.add({
                  "Name" : data.Data[i]["wingName"],
                  "Id" : data.Data[i]["_id"],
                });
              }
              tag = 0;
            });

          }
        }, onError: (e) {
          showMsg("$e","MYJINI");
        });
      } else {
        showMsg("No Internet Connection.","MYJINI");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong","MYJINI");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pushNamedAndRemoveUntil(
        //           '/HomeScreen', (Route<dynamic> route) => false);              }),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: txtTitle,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.title,
                        //color: cnst.appPrimaryMaterialColor,
                      ),
                      hintText: "Title"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: txtDesc,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.description,
                      ),
                      hintText: "Description"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MultiSelectFormField(
                  autovalidate: false,
                  title: Text('Select Wing'),
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more options';
                    }
                  },
                  dataSource: wingsNameData,
                  textField: 'Name',
                  valueField: 'Name',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('No Wing Selected'),
                  change: () => selectedWing,
                  onSaved: (value) {
                    setState(() {
                      selectedWing = value;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "${_dateTime.toString().substring(8, 10)}-${_dateTime.toString().substring(5, 7)}-${_dateTime.toString().substring(0, 4)}",
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // ChipsChoice<int>.single(
              //   value: tag,
              //   onChanged: (val) {
              //     setState(() => tag = val);
              //     print(tag);
              //   },
              //   choiceItems: C2Choice.listFrom<int, String>(
              //     source: options,
              //     value: (i, v) => i,
              //     label: (i, v) => v,
              //   ),
              // ),
              tag == 1
                  ? Container(
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
                              Icons.description,
                            ),
                            hintText: "Enter Amount"),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: () {
                    if (tag == -1) {
                      Fluttertoast.showToast(
                          msg: "Please select event type",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    } else if (txtTitle == "" ||
                        txtAmount == "" ||
                        selectedWing.length == 0) {
                      Fluttertoast.showToast(
                          msg: "Please Fill All the Details",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    } else {
                      AddEventDetails();
                    }
                  },
                  color: appPrimaryMaterialColor[700],
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.save,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Save Event",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
