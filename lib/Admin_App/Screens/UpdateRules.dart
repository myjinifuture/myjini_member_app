import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';

class UpdateRules extends StatefulWidget {
  var rulesData;
  Function onUpdate;

  UpdateRules({this.rulesData, this.onUpdate});

  @override
  _UpdateRulesState createState() => _UpdateRulesState();
}

class _UpdateRulesState extends State<UpdateRules> {
  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDescription = new TextEditingController();
  File _imageNotice;
  String societyId = "0";

  @override
  void initState() {
    txtTitle.text = widget.rulesData["Title"];
    txtDescription.text = widget.rulesData["Description"];
    _getLocalData();
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
    });
  }

  bool isLoading = false;

  String _fileName;
  String _path;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.any;

  void _imagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null)
                        setState(() {
                          _path = '';
                          _fileName = '';
                          _imageNotice = image;
                        });
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null)
                        setState(() {
                          _path = '';
                          _fileName = '';
                          _imageNotice = image;
                        });
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(
          type: _pickingType,
        );
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _imageNotice = null;
        _fileName = _path != null ? _path.split('/').last : '';
      });
    }
  }

  updateRule() async {
    if (txtTitle.text != null &&
        txtTitle.text != '' &&
        txtDescription.text != null &&
        txtDescription.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // pr.show();

          String filename = "";
          String filePath = "";
          File compressedFile;

          if (_imageNotice != null) {
            ImageProperties properties =
                await FlutterNativeImage.getImageProperties(_imageNotice.path);

            compressedFile = await FlutterNativeImage.compressImage(
              _imageNotice.path,
              quality: 80,
              targetWidth: 600,
              targetHeight:
                  (properties.height * 600 / properties.width).round(),
            );

            filename = _imageNotice.path.split('/').last;
            filePath = compressedFile.path;
          } else if (_path != null && _path != '') {
            filePath = _path;
            filename = _fileName;
          }

          FormData formData = new FormData.fromMap({
            "ruleId": widget.rulesData["_id"],
            "Title": txtTitle.text,
            "Description": txtDescription.text,
            "FileAttachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                    filename: filename.toString())
                : null,
          });

          Services.responseHandler(
                  apiName: "admin/updateSocietyRules", body: formData)
              .then((data) async {
            // pr.hide();
            if (data.Data != "0" && data.IsSuccess == true) {
              Fluttertoast.showToast(
                  msg: "Rule Updated Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP);
              Navigator.pop(context);
              widget.onUpdate();
            } else {
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            // pr.hide();
            showMsg("Try Again.");
          });
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
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
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
    print("widget.rulesData");
    print(widget.rulesData);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Rules",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, '/RulesAndRegulations');
        //   },
        // ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  controller: txtDescription,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.description,
                        //color: cnst.appPrimaryMaterialColor,
                      ),
                      hintText: "Rule Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
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
                        _imagePopup(context);
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
                            Icons.camera_alt,
                            size: 25,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Upload Image",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
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
                            size: 25,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Upload File",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _imageNotice != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Image.file(
                        File(_imageNotice.path),
                        height: 150,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : _fileName != null && _fileName != ''
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
                padding: EdgeInsets.only(top: 15),
                child: RaisedButton(
                  onPressed: () {
                    updateRule();
                  },
                  color: appPrimaryMaterialColor[700],
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Update Rule",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
