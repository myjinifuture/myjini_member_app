import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';

import 'OTP.dart';

class AddFamilyMember extends StatefulWidget {
  Function onAddFamily;
  AddFamilyMember({this.onAddFamily});
  @override
  AddFamilyMemberState createState() => AddFamilyMemberState();
}

class AddFamilyMemberState extends State<AddFamilyMember> {
  //

  String Gender;
  String Relation;
  ProgressDialog pr;
  String MemberId, WingId, WingName, flatId, Address, Residenttype, SocietyId;

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(constant.Session.Member_Id);
      WingId = prefs.getString(constant.Session.WingId);
      WingName = prefs.getString(constant.Session.Wing);
      flatId = prefs.getString(constant.Session.FlatId);
      Address = prefs.getString(constant.Session.Address);
      Residenttype = prefs.getString(constant.Session.ResidenceType);
      SocietyId = prefs.getString(constant.Session.SocietyId);
    });
  }

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    getLocaldata();
  }

  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();

  _SaveFamilymember() async {
    if (txtname.text != "" && txtmobile.text != "" && txtmobile.text.length==10) {
      if (Relation != null) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            var data = {
              'Name': txtname.text.trim(),
              'ContactNo': txtmobile.text.trim(),
              'Gender': Gender.toLowerCase(),
              'Relation': Relation,
              'societyId': SocietyId,
              'wingId': WingId,
              // 'Wing': WingName,
              'flatId': flatId,
              'Address': Address,
              // 'ResidenceType': Residenttype,
              'parentId': MemberId,
            };
            // pr.show();
            Services.responseHandler(apiName: "member/addFamilyMember",body: data).then((data) async {
              // pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                showHHMsg("Member Added Successfully", "");

              } else {
                showHHMsg("Mobile Number Already Exist !", "");
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
      } else {
        Fluttertoast.showToast(
            msg: "Please Select Relation", toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all Fields", toastLength: Toast.LENGTH_LONG);
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
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                widget.onAddFamily();
                //widget.onAddFamily();

                // Navigator.pushReplacement(
                //     context, SlideLeftRoute(page: CustomerProfile()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            "Add Family Member",
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
                        width: 80,
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Image.asset("images/family.png",
                              width: 40, color: Colors.grey[400]),
                        )),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0, top: 10),
                    child: Text(
                      "  Name *",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: txtname,
                        decoration: InputDecoration(
                            counter: Text(""),
                            hintText: "Enter Your Member Name",
                            hintStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0, top: 1),
                    child: Text(
                      "  Mobile Number",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        maxLength: 10,
                        controller: txtmobile,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            counter: Text(""),
                            hintText: " Your Mobile Number",
                            hintStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 11.0),
                          child: Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 'Male',
                            groupValue: Gender,
                            onChanged: (value) {
                              setState(() {
                                Gender = value;
                                print(Gender);
                              });
                            }),
                        Text("Male", style: TextStyle(fontSize: 13)),
                        Radio(
                            value: 'Female',
                            groupValue: Gender,
                            onChanged: (value) {
                              setState(() {
                                Gender = value;
                                print(Gender);
                              });
                            }),
                        Text("Female", style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1,
                        child: DropdownButton<String>(
                          value: Relation,
                          isExpanded: true,
                          iconSize: 24,
                          hint: Text("- -Select Relation- -"),
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                          onChanged: (String newValue) {
                            setState(() {
                              Relation = newValue;
                              print(Relation);
                            });
                          },
                          items: <String>[
                            'Daughter',
                            'Son',
                            'Wife',
                            'Brother',
                            'Sister',
                            'Father',
                            'Mother',
                            'Husband',
                            'Grand Father',
                            'Grandson',
                            'Uncle',
                            'Nephew',
                            'Cousin',
                            'Niece',
                            'Aunt',
                            'Grand Daughter',
                            'Grand Mother',
                            'Wife'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 8, right: 8, bottom: 18.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: constant.appPrimaryMaterialColor[500],
                    textColor: Colors.white,
                    splashColor: Colors.white,
                    child: Text("Save",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTP(
                              mobileNo: txtmobile.text.toString(),
                              onSuccess: () {
                                _SaveFamilymember();
                              },
                            ),
                          ));
                    },
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
