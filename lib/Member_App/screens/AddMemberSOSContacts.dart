import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/DigitalComponent/ImagePickerHandlerComponent.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class AddMemberSOSContacts extends StatefulWidget {

  Function newMemberAdded;

  AddMemberSOSContacts({this.newMemberAdded});

  @override
  _AddMemberSOSContactsState createState() => _AddMemberSOSContactsState();
}

class _AddMemberSOSContactsState extends State<AddMemberSOSContacts> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtNumber = new TextEditingController();
  bool isLoading=false;

  addMemberSOSContact() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.Member_Id);
        var data = {
          "memberId": memberId,
          "contactNo":txtNumber.text,
          "contactPerson":txtName.text,
        };
        Services.responseHandler(
            apiName: "member/addMemberSOSContacts", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            widget.newMemberAdded();
            Fluttertoast.showToast(
                msg: "SOS Contact Added Successfully!!!",
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_LONG);
            Navigator.of(context).pop();
          } else {}
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
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
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Emergency Contact'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        //margin: EdgeInsets.only(top: 110),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    border: new Border.all(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextFormField(
                  controller: txtName,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title), hintText: "Name"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
                //height: 40,
                width: MediaQuery.of(context).size.width - 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    border: new Border.all(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextFormField(maxLength: 10,
                  controller: txtNumber,
                  decoration: InputDecoration(border: InputBorder.none,
                      prefixIcon: Icon(Icons.description),
                      hintText: "Number",counterText: ""),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                ),
                //height: 40,
                width: MediaQuery.of(context).size.width - 40,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  color: buttoncolor,
                  minWidth: MediaQuery.of(context).size.width - 20,
                  onPressed: (){
                      addMemberSOSContact();
                  },
                  child: Text(
                    "Save Contact",
                    style: TextStyle(
                        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ) /*RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 5,
                        textColor: Colors.white,
                        color: cnst.buttoncolor,
                        child: Text("Add Offer",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/Dashboard");
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)))*/
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
