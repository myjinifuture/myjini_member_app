import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

ProgressDialog pr;

class AddNotice extends StatefulWidget {
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDescription = new TextEditingController();
  File _imageNotice;
  String societyId = "0";
  String memberId;

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  String _format = 'yyyy-MMMM-dd';
  TextEditingController _formatCtrl = TextEditingController();

  DateTime _dateTime;
  bool isLoading = false;
  bool disableSaveNotice;

  String _fileName;
  String _path;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.any;

  @override
  void initState() {
    super.initState();
    disableSaveNotice=false;
    getLocalData();
    setData();
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
    _dateTime = DateTime.now();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
      memberId = prefs.getString(cnst.Session.Member_Id);
    });
    getWingsId(societyId);
  }

  setData() {
    setState(() {
      txtTitle.text = "";
      txtDescription.text = "";
    });
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
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        _path = await FilePicker.getFilePath(
          type: _pickingType,
        );
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _imageNotice = null;
        _fileName = _path != null ? _path.split('/').last : '';
      });
    }
  }

  addNotice() async {
    if (txtTitle.text != null &&
        txtTitle.text != '' &&
        txtDescription.text != null &&
        txtDescription.text != '' &&
        _dateTime != null &&
        _dateTime != '') {
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
            "Title": txtTitle.text,
            "Description": txtDescription.text,
            "societyId": societyId,
            "FileAttachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                    filename: filename.toString())
                : null,
            "adminId" : memberId,
            "deviceType" : Platform.isAndroid ? "Android" : "IOS",
            "wingIds": selectedWingId.toString().replaceAll("[","").toString().replaceAll("]", "").replaceAll(" ", "")
          });
          print({
            "Title": txtTitle.text,
            "Description": txtDescription.text,
            "societyId": societyId,
            "FileAttachment": (filePath != null && filePath != '')
                ? await MultipartFile.fromFile(filePath,
                filename: filename.toString())
                : null,
            "adminId" : memberId,
            "deviceType" : Platform.isAndroid ? "Android" : "IOS",
            "wingIds": selectedWingId.toString().replaceAll("[","").toString().replaceAll("]", "").replaceAll(" ", "")
          });
          Services.responseHandler(apiName: "admin/addNotice",body: formData).then((data) async {
            // pr.hide();
            if (data.Data.length > 0 && data.IsSuccess == true) {
              print(data.Message);

Fluttertoast.showToast(
                  msg: "Notice Saved Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP);
              Navigator.pushReplacementNamed(context, "/AllNotice");
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
      showMsg("Please Fill All The Data.", title: "Alert !");
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Notice',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/AllNotice');
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/AllNotice');
        },
        child: Container(
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
                    controller: txtDescription,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.description,
                          //color: cnst.appPrimaryMaterialColor,
                        ),
                        hintText: "Description"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
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
                            ),
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
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    onPressed: disableSaveNotice==false?() {
                      setState(() {
                        disableSaveNotice=true;
                      });
                      addNotice();
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
                            "Save Notice",
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
}
