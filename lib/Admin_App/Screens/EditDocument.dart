import 'dart:io';
import 'package:dio/dio.dart';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';


class EditDocument extends StatefulWidget {
  var documentData;
  EditDocument({this.documentData});
  @override
  _EditDocumentState createState() => _EditDocumentState();
}

class _EditDocumentState extends State<EditDocument> {
  TextEditingController txtTitle = new TextEditingController();
  FileType _pickingType = FileType.any;
  String _path;
  String _fileName;
  bool disableSaveDocument;


  @override
  void initState() {
    disableSaveDocument=false;
    txtTitle.text=widget.documentData["Title"];
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom) {
      try {
        _path = await FilePicker.getFilePath(
          type: _pickingType,
        );
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _fileName = _path != null ? _path.split('/').last : '';
      });
    }
  }

  updateDocument() async {
    if (txtTitle.text != null &&
        txtTitle.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String filePath = _path;
          String filename = _fileName;
          String societyId=prefs.getString(Session.SocietyId);

          FormData formData = new FormData.fromMap({
            "Title": txtTitle.text,
            "societyId": societyId,
            "FileAttachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                filename: filename.toString())
                : null,
            "documentId":widget.documentData['_id'],
          });
          Services.responseHandler(apiName: "admin/updateSocietyDoc",body: formData).then((data) async {
            if (data.IsSuccess == true && data.Data.toString() == "1") {
              setState(() {
                disableSaveDocument=true;
              });
              Fluttertoast.showToast(
                  msg: "Document Updated Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP);
              Navigator.pushReplacementNamed(context, '/Document');
            } else {
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
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
            // usually buttons at the bottom of the dialog
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



  @override
  Widget build(BuildContext context) {
    print("widget.documentData");
    print(widget.documentData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Document'),
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
                      ),
                      hintText: "Title"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        _openFileExplorer();
                      },
                      color: appPrimaryMaterialColor[700],
                      textColor: Colors.white,
                      shape: StadiumBorder(),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.file_upload,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Upload File",
                              style: TextStyle(
                                fontSize: 18,
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
              _fileName != null && _fileName != ''
                  ? Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "${_fileName}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: disableSaveDocument==false?() {
                    updateDocument();
                  }:null,
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
                          "Update Document",
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
