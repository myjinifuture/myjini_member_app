import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;


ProgressDialog pr;

class AddDocument extends StatefulWidget {
  @override
  _AddDocumentState createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDate = new TextEditingController();
  String societyId = "0";

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  String _format = 'yyyy-MMMM-dd';

  DateTime _dateTime;

  String _fileName;
  String _path;
  FileType _pickingType = FileType.any;
  bool disableSaveDocument;

  @override
  void initState() {
    super.initState();
    disableSaveDocument=false;
    getLocalData();
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
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
    });
    getWingsId(societyId);
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

  addDocument() async {
    if (txtTitle.text != null &&
        txtTitle.text != '' &&
        _path != null &&
        _path != '') {
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String filePath = _path;
          String filename = _fileName;
          String adminId = prefs.getString(cnst.Session.Member_Id);;

          FormData formData = new FormData.fromMap({
            "Title": txtTitle.text,
            "societyId": societyId,
            "FileAttachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                    filename: filename.toString())
                : null,
            "adminId":adminId,
            "wingIds" : selectedWingId.toString().replaceAll("[","").toString().replaceAll("]", "").replaceAll(" ", "")
          });
          print('selectedWingId.toString().replaceAll("[","").toString().replaceAll("]", "")');
          print({
            "Title": txtTitle.text,
            "societyId": societyId,
            "FileAttachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                filename: filename.toString())
                : null,
            "adminId":adminId,
            "wingIds" : selectedWingId.toString().replaceAll("[","").toString().replaceAll("]", "").replaceAll(" ", "")
          });
          Services.responseHandler(apiName: "admin/addSocietyDocs",body: formData).then((data) async {
            // pr.hide();
            if (data.Data != null && data.IsSuccess == true) {

              Fluttertoast.showToast(
                  msg: "Document Added Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP);
              Navigator.pushReplacementNamed(context, '/Document');
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

  List wingsNameData = [];
  List selectedWingId = [];
  List wingsList = [];
  List selectedWing = [];

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
                if(data.Data[i]["totalFloor"].toString()!="0"){
                  wingsList.add(data.Data[i]);
                }
              }
              for(int i=0;i<wingsList.length;i++){
                wingsNameData.add({
                  "Name" : wingsList[i]["wingName"],
                  "Id" : wingsList[i]["_id"],
                });
              }
            });

          }
        }, onError: (e) {
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_dateTime.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Document",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/Document');
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/Document');
        },
        child: Container(
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
/*
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
                        _dateTime != null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "${_dateTime.toString().substring(8, 10)}-${_dateTime.toString().substring(5, 7)}-${_dateTime.toString().substring(0, 4)}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
*/
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
                      setState(() {
                        disableSaveDocument=true;
                      });
                      addDocument();
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
                            "Save Document",
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
      ),
    );
  }
}
