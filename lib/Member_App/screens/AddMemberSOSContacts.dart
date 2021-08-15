import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/DigitalComponent/ImagePickerHandlerComponent.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

import 'ContactList.dart';

class AddMemberSOSContacts extends StatefulWidget {
  String name, mobileNo;
  Function newMemberAdded;

  AddMemberSOSContacts({this.newMemberAdded, this.name, this.mobileNo});

  @override
  _AddMemberSOSContactsState createState() => _AddMemberSOSContactsState();
}

class _AddMemberSOSContactsState extends State<AddMemberSOSContacts> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtNumber = new TextEditingController();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  bool isLoading = false;

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup>permissions = <PermissionGroup>[
      PermissionGroup.contacts
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);
    PermissionStatus _permissionStatus = PermissionStatus.unknown;

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
      // Navigator.pushNamed(context, "/ContactList");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactList(
            fromSos: true,
            onAddFromContactList: widget.newMemberAdded,
          ),
        ),
      );
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

  bool isFilled = false;

  @override
  void initState() {
    if (widget.mobileNo != null) {
      setState(() {
        isFilled = true;
        txtName.text = widget.name;
        txtNumber.text = widget.mobileNo;
      });
      addMemberSOSContact();
    }
    // requestPermission(PermissionGroup.contacts);
  }

  addMemberSOSContact() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.Member_Id);
        var data = {
          "memberId": memberId,
          "contactNo": txtNumber.text,
          "contactPerson": txtName.text,
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
            Navigator.of(context).pop();;
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
                Navigator.of(context).pop();;
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  _onChange(value, CustomContact c, List<Item> list) {
    if (list.length >= 1 &&
        list[0]?.value != null &&
        c.contact.displayName != "") {
      print("list");
      print(list);
      String mobile = list[0].value.toString();
      String name = c.contact.displayName.toString();
      mobile = mobile.replaceAll(" ", "");
      mobile = mobile.replaceAll("-", "");
      mobile = mobile.replaceAll("+91", "");
      mobile = mobile.replaceAll("091", "");
      mobile = mobile.replaceAll("+091", "");
      mobile = mobile.replaceAll(RegExp("^0"), "");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => AddGuest(name:name,mobileNo:mobile.toString()),
      //   ),
      // );
      setState(() {
        txtName.text = name.toString();
      });
      print("mobile" + mobile);
      if (value) {
        if (mobile.length == 10) {
          setState(() {
            c.isChecked = value;
          });
        } else
          Fluttertoast.showToast(
              msg: "Mobile Number Is Not Valid",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          c.isChecked = value;
        });
        // for (int i = 0; i < _selectedContact.length; i++) {
        //   if (_selectedContact[i]["ContactNo"].toString() == mobile)
        //     _selectedContact.removeAt(i);
        // }
      }
      // print(_selectedContact);
    } else {
      Fluttertoast.showToast(
          msg: "Contact Is Not Valid",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: (c.contact.avatar != null && c.contact.avatar.length > 0)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
        child: Text(
          c.contact.displayName.toUpperCase().substring(0, 1) ?? "",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            _onChange(value, c, list);
          }),
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
                child: TextFormField(
                  maxLength: 10,
                  controller: txtNumber,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.description),
                      hintText: "Number",
                      counterText: ""),
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
                  onPressed: () {
                    addMemberSOSContact();
                  },
                  child: isFilled
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.white),
                        strokeWidth: 5,
                      ),
                    ),
                  )
                      : Text(
                    "Save Contact",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                /*RaisedButton(
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
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.6,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: appprimarycolors[400],
                  onPressed: () {
                    requestPermission(PermissionGroup.contacts);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.contact_phone,
                        color: Colors.white,
                        size: 17,
                      ),
                      Text(
                        "Choose From Contact List",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
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
