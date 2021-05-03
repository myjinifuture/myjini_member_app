import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/DigitalComponent/ImagePickerHandlerComponent.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class AddEmergencySocietyWise extends StatefulWidget {
  Function onAddSocietyEmergencyContact;
  AddEmergencySocietyWise({this.onAddSocietyEmergencyContact});

  @override
  _AddEmergencySocietyWiseState createState() =>
      _AddEmergencySocietyWiseState();
}

class _AddEmergencySocietyWiseState extends State<AddEmergencySocietyWise> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtNumber = new TextEditingController();
  ImagePickerHandler imagePicker;
  File _image;

  @override
  void initState() {
    _getLocaldata();
  }

  String societyId;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    societyId = prefs.getString(Session.SocietyId);
  }

  Widget setUpButtonChild() {
    return new Text(
      "Save Contact",
      style: TextStyle(
          color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
    );
  }

  SaveNumber() async {
    print("pressedf");
    String img = '';
    if (_image != null) {
      List<int> imageBytes = await _image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      img = base64Image;
    }

    print('base64 Img : $img');

    var data = {
      "Name": txtName.text,
      "ContactNo": txtNumber.text,
      "societyId": societyId,
      "image": img
    };

    print(data);
    Services.responseHandler(
            apiName: "admin/addSocietyEmergencyContacts", body: data)
        .then((data) {
      if (data.Data.length > 0) {
        Fluttertoast.showToast(
            msg: "Number Added Successfully!!!",
            backgroundColor: Colors.green,
            gravity: ToastGravity.TOP);
        Navigator.pop(context);
        widget.onAddSocietyEmergencyContact();
      } else {
        Fluttertoast.showToast(
            msg: data.Message,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
      }
    }, onError: (e) {
      Fluttertoast.showToast(
          msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
    });
  }

  Future cameraImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 240.0,
      maxWidth: 240.0,
    );
    setState(() {
      _image = image;
    });
  }

  Future galleryImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 240.0,
      maxWidth: 240.0,
    );
    setState(() {
      _image = image;
    });
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
                  controller: txtNumber,
                  maxLength: 10,
                  decoration: InputDecoration(
                      counterText: "",
                      prefixIcon: Icon(Icons.description),
                      hintText: "Number"),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                ),
                //height: 40,
                width: MediaQuery.of(context).size.width - 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: _image == null
                      ? Container()
                      : Container(
                          child: Image.file(File(_image.path),
                              height: 200, width: 200, fit: BoxFit.fill),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: Image.asset('images/Camera.png',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          color: Colors.grey),
                      onTap: () {
                        cameraImage();
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('images/galleryselect.png',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          color: Colors.grey),
                      onTap: () {
                        galleryImage();
                      },
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  color: buttoncolor,
                  minWidth: MediaQuery.of(context).size.width - 20,
                  onPressed: () => SaveNumber(),
                  child: Text(
                    "Save Contact",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
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
