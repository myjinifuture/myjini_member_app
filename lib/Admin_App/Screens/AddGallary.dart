import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import '../Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/constant.dart'as cnst;
import 'dart:convert';

class AddGallary extends StatefulWidget {
  @override
  _AddGallaryState createState() => _AddGallaryState();
}

class _AddGallaryState extends State<AddGallary> {
  TextEditingController txtTitle = new TextEditingController();
  File _imageEvent;
  String societyId = "0";

  DateTime _dateTime;
  bool selectSingleImage = false;

  String _fileName;
  String _path;
  ProgressDialog pr;

  @override
  void initState() {
    _dateTime = DateTime.now();
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
  }

  String MemberId;
  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MemberId = prefs.getString(cnst.Session.Member_Id);
      print("MemberId");
      print(MemberId);
    getWingsId(prefs.getString(cnst.Session.SocietyId));
  }

  String _format = 'yyyy-MMMM-dd';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  bool isLoading = false;

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

  List<Asset> images = List<Asset>();

  _addEvent() async {
    if (txtTitle.text != "" && images != null && images.length > 0) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String SocietyId = preferences.getString(Session.SocietyId);
          selectedWingId.clear();
          for (int i = 0; i < selectedWing.length; i++) {
            for(int j=0;j<wingsNameData.length;j++){
              if(selectedWing[i].toString() == wingsNameData[j]["Name"].toString()){
                selectedWingId.add(wingsNameData[j]["Id"].toString());
              }
            }
          }
          // pr.show();
          String files = "";
          String base64Image;
          for (int i = 0; i < images.length; i++) {
            ByteData byteData = await images[i].getByteData();
            List<int> imageData = byteData.buffer.asUint8List();
             base64Image = base64Encode(imageData);
              if(i==images.length-1){
                files+=(base64Image);
              }
              else{
                files+=(base64Image + ",");
              }
          }
          var jsonMap = {
            "societyId": SocietyId,
            "title": txtTitle.text,
            "adminId" : MemberId,
            "deviceType" : Platform.isAndroid ? "Android" : "IOS",
            "image" : files,
            "wingIds": selectedWingId.toString().replaceAll("[","").toString().replaceAll("]", "").replaceAll(" ", "")
          };
            print("data");
            print(jsonMap);
            Services.responseHandler(apiName: "admin/addGalleryImage",body:jsonMap).then((data) async {
              print("responsedata");
              print(data);
              if (data.Data.length > 0) {
                // setState(() {
                //   isLoading = false;
                // });
                // pr.hide();
                Fluttertoast.showToast(
                    msg: "Gallery Added Successfully",
                    backgroundColor: Colors.green,
                    gravity: ToastGravity.TOP,
                    textColor: Colors.white);
                Navigator.pushReplacementNamed(context, "/Gallary");
              } else {
                setState(() {
                  isLoading = false;
                });
                showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
              setState(() {
                isLoading = false;
              });
              showMsg("Try Again.");
            });
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Enter Title",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
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

  String _platformMessage = 'No Error';

  initMultiPickUp() async {
    setState(() {
      _platformMessage = 'No Error';
    });
    List resultList;
    String error;
    try {
      resultList = await FlutterMultipleImagePicker.pickMultiImages(
          50, false);
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    var file = File(resultList[0]);
    print("file");
    print(file.path);
     setState(() {
      images = resultList;
      if (error == null) _platformMessage = 'No Error Dectected';
    });

    print("image collection:" + images.toString());
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      error = error;
    });
  }

  bool buttonPressed = false;

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
          "Add Gallery",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/Gallary');
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/Gallary');
        },
        child: isLoading
            ? LoadingComponent()
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                controller: txtTitle,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.title,
                                      //color: cnst.appPrimaryMaterialColor,
                                    ),
                                    hintText: "Title"),
                                keyboardType: TextInputType.text,
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
                              children: <Widget>[
                                GestureDetector(
                                  onTap:  loadAssets,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50,
                                      padding:
                                          EdgeInsets.only(left: 7, right: 7),
                                      decoration: BoxDecoration(
                                        color: appPrimaryMaterialColor[700],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            Icons.camera_alt,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Select Gallery Photos",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: List.generate(images.length, (index) {
                                  Asset asset = images[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AssetThumb(
                                      asset: asset,
                                      width: 300,
                                      height: 300,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: RaisedButton(
                                onPressed:!buttonPressed ? ()  {
                                  _addEvent();
                                  setState(() {
                                    buttonPressed = true;
                                  });
                                }:null,
                                color: appPrimaryMaterialColor[700],
                                textColor: Colors.white,
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
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
                                        "Save Gallary",
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
                          _imageEvent = image;
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
                          _imageEvent = image;
                        });
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }
}
