import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class EventDetail extends StatefulWidget {
  Map EventsData={};
  Function onEventResponse;
  EventDetail({this.EventsData,this.onEventResponse});
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  String dropdownValue,MemberId="";
  ProgressDialog pr;
  bool memberResponse;

  @override
  void initState() {
    _getLocaldata();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    super.initState();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MemberId = prefs.getString(constant.Session.Member_Id);
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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  _RegisterForEvent() async {
    print("dropdownValue");
    print(dropdownValue);
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            // pr.show();
            var data = {
              "eventId" : widget.EventsData["_id"],
              "memberId" : MemberId,
              "noOfPerson" : memberResponse==false?"0":dropdownValue.toString(),
              "response":memberResponse==true?true:false,
            };
            Services.responseHandler(apiName: "admin/eventRegistration",body: data).then((data) async {
              // pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                Fluttertoast.showToast(
                    msg: "Data Added Successfully!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.green,
                    textColor: Colors.white);
                // Navigator.pushReplacementNamed(context, "/Events");
                Navigator.pop(context);
                widget.onEventResponse();
              } else {
                showHHMsg("${data.Message}", "");
                // pr.hide();
              }
            }, onError: (e) {
              // pr.hide();
              showHHMsg("Try Again.", "");
            });
          } else {
            // pr.hide();
            showHHMsg("No Internet Connection.", "");
          }
        } on SocketException catch (_) {
          showHHMsg("No Internet Connection.", "");
        }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Events Detail',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              "${widget.EventsData["Title"]}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: constant.appPrimaryMaterialColor,
              ),
              textAlign: TextAlign.center,
            ),
            leading: Icon(
              Icons.title,
              size: 20,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "${widget.EventsData["date"]}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Icon(
              Icons.date_range,
              size: 20,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "All are Requested To Give Confirmation For Coming OR Not",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            leading: Icon(
              Icons.info,
              size: 20,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15,top: 10,bottom: 5),
            child: Text(
              "Number Of Member attending the event:",
              style: TextStyle(
                color: appPrimaryMaterialColor,
                fontSize: 15
                  ,fontWeight: FontWeight.w500
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15),
            child: Container(
              height: 38,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: appPrimaryMaterialColor)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: dropdownValue == null
                      ? Text(
                          "Select Number of Members",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      : Text(dropdownValue),
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: appPrimaryMaterialColor,
                  ),
                  isExpanded: true,
                  value: dropdownValue,
                  items: ["1", "2", "3", "4","5","6","7","8","9","10"]

                      .map((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text( value),
                        ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                    "Are You Going ?",
                    style: TextStyle(
                        color: constant.appPrimaryMaterialColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        onPressed: () {
                          if(dropdownValue==null){
                            Fluttertoast.showToast(
                                msg: "Please select Number of Members",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          }
                          else{
                            setState(() {
                              memberResponse=true;
                              _RegisterForEvent();
                            });
                          }
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 16,
                          ),
                        ),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        onPressed: () {
                          setState(() {
                            memberResponse=false;
                            // dropdownValue = "0";
                            _RegisterForEvent();
                          });
                          // _RegisterForEvent();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
