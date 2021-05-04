import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  TextEditingController _Title = new TextEditingController();
  TextEditingController _Description = new TextEditingController();
  DateTime _dateTime;
  String dropdownValue;
  bool isLoading = false;
  String SocietyId, Member_id;
  ProgressDialog pr;
  File _image;
  String _fileName;
  String _path;

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

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      Member_id = prefs.getString(constant.Session.Member_Id);
    });
  }

  setData() {
    setState(() {
      _Title.text = "";
      _Description.text = "";
    });
  }

  @override
  void initState() {
    pr = new ProgressDialog(context);
    _dateTime = DateTime.now();
    setData();
    getLocalData();
    GetComplaintsCategory();
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

  List complaintsName=[];
  GetComplaintsCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.responseHandler(apiName:"admin/getAllComplainCategory",body: {}).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              complaintsName = data.Data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  String selectedComplaintId = "";
  SaveComplain() async {
    if (_Title.text != null &&
        _Title.text != '' &&
        _Description.text != null &&
        _Description.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // pr.show();

          String filename = "";
          String filePath = "";
          File compressedFile;

          if (_image != null) {
            ImageProperties properties =
                await FlutterNativeImage.getImageProperties(_image.path);

            compressedFile = await FlutterNativeImage.compressImage(
              _image.path,
              quality: 80,
              targetWidth: 600,
              targetHeight:
                  (properties.height * 600 / properties.width).round(),
            );

            filename = _image.path.split('/').last;
            filePath = compressedFile.path;
          } else if (_path != null && _path != '') {
            filePath = _path;
            filename = _fileName;
          }

          for(int i=0;i<complaintsName.length;i++){
            if(dropdownValue==complaintsName[i]["complainName"]){
              selectedComplaintId = complaintsName[i]["_id"];
            }
          }
          FormData formData = new FormData.fromMap({
            "title": _Title.text,
            "complainCategory"  :selectedComplaintId,
            "description": _Description.text,
            "attachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                    filename: filename.toString())
                : null,
            "memberId": Member_id,
            // "Date": _dateTime.toString(),
            "societyId": SocietyId,
            "deviceType" : Platform.isAndroid ? "Android" : "IOS"
          });

          Services.responseHandler(apiName: "member/addComplain",body: formData).then((data) async {
            // pr.hide();

            if (data.Data != "0") {
              Navigator.pushReplacementNamed(context, '/Complaints');
              showMsg("Complaint Sent to Admin", title: "Success");
            } else {
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            // pr.hide();
            showMsg("Try Again.");
          });
        } else {
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        // pr.hide();
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Fill All Data.", title: "Alert !");
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
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();;
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
        Navigator.pushReplacementNamed(context, '/Complaints');
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Complaints');
              }),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Add Complaint',
              style: TextStyle(fontSize: 18),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Image.asset('images/Complain.png',
                              width: 30, height: 30)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Complaint to Secretary",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 16))
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 8.0, left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text("Complaint Title",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                  child: Container(
                    height: 55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: _Title,
                            decoration: InputDecoration(
                              hintText: "Title",
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: constant.appPrimaryMaterialColor),
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 8.0, left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text("Description",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: constant.appPrimaryMaterialColor),
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 6.0, bottom: 4.0),
                    child: TextFormField(
                      controller: _Description,
                      maxLines: 3,
                      maxLength: 100,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Something",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey[400])),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: constant.appPrimaryMaterialColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        hint: dropdownValue == null
                            ? Text(
                          "  Select Complaint Category",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                            : Text(dropdownValue),
                        dropdownColor: Colors.white,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 40,
                          color: Colors.grey,
                        ),
                        isExpanded: true,
                        value: dropdownValue,
                        items: complaintsName.map((value) {
                          return DropdownMenuItem<dynamic>(
                              value: value["complainName"],
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(value["complainName"]),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Capture Complaint Image",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
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
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: constant.appPrimaryMaterialColor,
                      textColor: Colors.white,
                      child: Text("Send Complaint",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      onPressed: () {
                        SaveComplain();
                      },
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
