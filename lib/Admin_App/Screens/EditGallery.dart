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
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import '../Common/Constants.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'dart:convert';

class EditGallery extends StatefulWidget {
  var galleryData;
  Function onEdit;

  EditGallery({this.galleryData,this.onEdit});

  @override
  _EditGalleryState createState() => _EditGalleryState();
}

class _EditGalleryState extends State<EditGallery> {
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
    txtTitle.text = widget.galleryData["title"].toString();
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

  updateGallery() async {
    if (txtTitle.text != "" ) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          String files = "";
          String base64Image;
          for (int i = 0; i < images.length; i++) {
            ByteData byteData = await images[i].getByteData();
            List<int> imageData = byteData.buffer.asUint8List();
            base64Image = base64Encode(imageData);
            if (i == images.length - 1) {
              files += (base64Image);
            } else {
              files += (base64Image + ",");
            }
          }
          List imagesList = [];
          imagesList.add(files);
          var jsonMap = {
            "galleryId": widget.galleryData["_id"].toString(),
            "title": txtTitle.text,
            "adminId": MemberId,
            "description": "",
            "image": imagesList,
          };
          print("data");
          print(jsonMap);
          Services.responseHandlerForBase64(
                  apiName: "admin/editGallery", body: jsonMap)
              .then((data) async {
            print("responsedata");
            print(data);
            if (data.Data.length > 0) {
              // setState(() {
              //   isLoading = false;
              // });
              // pr.hide();
              Fluttertoast.showToast(
                  msg: "Gallery Photo Updated Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              Navigator.pop(context);
              widget.onEdit();
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
                Navigator.of(context).pop();
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
      resultList = await FlutterMultipleImagePicker.pickMultiImages(50, false);
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

  @override
  Widget build(BuildContext context) {
    print("widget.galleryData");
    print(widget.galleryData);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Gallery Photo",
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
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "${_dateTime.toString().substring(8, 10)}-${_dateTime.toString().substring(5, 7)}-${_dateTime.toString().substring(0, 4)}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: loadAssets,
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
                                // Padding(padding: EdgeInsets.only(left: 20)),
                                // _imageEvent != null
                                //     ? Padding(
                                //         padding: EdgeInsets.only(top: 10),
                                //         child: Image.file(
                                //           File(_imageEvent.path),
                                //           height: 160,
                                //           width: 130,
                                //           fit: BoxFit.fill,
                                //         ),
                                //       )
                                //     : Container(),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            // images != null
                            //     ? SizedBox(
                            //   height: 300.0,
                            //   width: 400.0,
                            //   child: new ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemBuilder: (BuildContext context, int index) =>
                            //     new Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: new Image.file(
                            //         new File(images[index].toString()),
                            //       ),
                            //     ),
                            //     itemCount: images.length,
                            //   ),
                            // )
                            //     : Container(),
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
                                onPressed: !buttonPressed
                                    ? () {
                                        updateGallery();
                                        setState(() {
                                          buttonPressed = true;
                                        });
                                      }
                                    : null,
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
                                        "Update Gallery Photo",
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
