import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Screens/getAmenitiesScreen.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';

class UpdateAmenity extends StatefulWidget {
  var amenityData;
  Function onUpdate;

  UpdateAmenity({this.amenityData, this.onUpdate});

  @override
  _UpdateAmenityState createState() => _UpdateAmenityState();
}

class _UpdateAmenityState extends State<UpdateAmenity> {
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtDesc = TextEditingController();
  TextEditingController txtTime1 = TextEditingController();
  TextEditingController txtTime2 = TextEditingController();
  TextEditingController freePaid = TextEditingController();
  TextEditingController amount = TextEditingController();
  File _image;
  String _fileName;
  String _path, lat, long, completeAddress;
  File _Image;
  List<Asset> images = List<Asset>();
  bool isFree;
  bool isPaid;

  String _error = 'No Error Dectected';

  Widget buildGridView() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: cnst.appPrimaryMaterialColor[400], width: 1),
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        // boxShadow: [
        //   BoxShadow(
        //       color: cnst.appPrimaryMaterialColor.withOpacity(0.2),
        //       blurRadius: 2.0,
        //       spreadRadius: 2.0,
        //       offset: Offset(3.0, 5.0))
        // ]
      ),
      child: images.length == 0
          ? Center(
              child: Text(
                "Select Images",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(images.length, (index) {
                Asset asset = images[index];
                return AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                );
              }),
            ),
    );
  }

  @override
  void initState() {
    txtTitle.text = widget.amenityData["amenityName"];
    txtDesc.text = widget.amenityData["description"];
    amount.text = widget.amenityData["Amount"].toString();
    txtTime1.text = widget.amenityData["fromTime"];
    txtTime2.text = widget.amenityData["toTime"];
    lat = widget.amenityData["location"]["lat"].toString();
    long = widget.amenityData["location"]["long"].toString();
    completeAddress =
        widget.amenityData["location"]["completeAddress"].toString();
    print("=============");
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    print(images);
    getLocaldata();
    isFree = widget.amenityData["isPaid"] == true ? false : true;
    isPaid = widget.amenityData["isPaid"] == true ? true : false;
  }

  String societyId;

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(Session.SocietyId);
    });
  }

  bool isLoading = false;

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

  String pickedImages = "";
  ProgressDialog pr;

  updateAmenity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
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
        var data = {
          "images": imagesList,
          "amenityId": widget.amenityData["_id"],
          "amenityName": txtTitle.text,
          "wingId": "",
          "flatId": "",
          "lat": lat,
          "long": long,
          "completeAddress": completeAddress,
          "societyId": societyId,
          "description": txtDesc.text,
          "isPaid": amount.text == "0" ? false : true,
          "Amount": amount.text == "0" ? "0" : amount.text,
          "fromTime": txtTime1.text,
          "toTime": txtTime2.text,
        };
        print("data");
        print({
          "amenityId": widget.amenityData["_id"],
          "amenityName": txtTitle.text,
          "wingId": "",
          "flatId": "",
          "lat": lat,
          "long": long,
          "completeAddress": completeAddress,
          "societyId": societyId,
          "description": txtDesc.text,
          "isPaid": amount.text == "0" ? false : true,
          "Amount": amount.text == "0" ? "0" : amount.text,
          "fromTime": txtTime1.text,
          "toTime": txtTime2.text,
          "images": imagesList,
        });

        Services.responseHandler(
                apiName: "admin/updateSocietyAmenity", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.IsSuccess && data.Data.toString()=='1') {
            // pr.hide();
            setState(() {
              Fluttertoast.showToast(
                  msg: "Amenities Updated Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              Navigator.pop(context);
              widget.onUpdate();
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
      _error = error;
    });
  }

  Future getFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _Image = image;
      });
    }
  }

  Future getFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _Image = image;
      });
    }
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15, bottom: 10),
                      child: Text(
                        "Add Photo",
                        style: TextStyle(
                          fontSize: 22,
                          color: cnst.appPrimaryMaterialColor,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getFromCamera();
                        Navigator.of(context).pop();;
                      },
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 15),
                          child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                "assets/camera.png",
                                color: cnst.appPrimaryMaterialColor,
                              )),
                        ),
                        title: Text(
                          "Take Photo",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(),
                    ),
                    GestureDetector(
                      onTap: () {
                        getFromGallery();
                        Navigator.of(context).pop();;
                      },
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 15),
                          child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                "assets/gallery.png",
                                color: cnst.appPrimaryMaterialColor,
                              )),
                        ),
                        title: Text(
                          "Choose from Gallery",
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0, bottom: 5),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();;
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 18,
                              color: cnst.appPrimaryMaterialColor,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
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
    print("widget.amenityData");
    print(widget.amenityData);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Amenities"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
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
                        //color: cnst.cnst.appPrimaryMaterialColor,
                      ),
                      hintText: "Title"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: txtDesc,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.description,
                      ),
                      hintText: "Description"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: TextFormField(
              //     controller: freePaid,
              //     scrollPadding: EdgeInsets.all(0),
              //     decoration: InputDecoration(
              //         border: new OutlineInputBorder(
              //             borderSide: new BorderSide(color: Colors.black),
              //             borderRadius:
              //                 BorderRadius.all(Radius.circular(10))),
              //         prefixIcon: Icon(
              //           Icons.data_usage,
              //         ),
              //         hintText: "Free or Paid"),
              //     keyboardType: TextInputType.text,
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: isFree == false
                            ? null
                            : cnst.appPrimaryMaterialColor,
                      ),
                      child: FlatButton(
                        child: Text(
                          'Free',
                          style: isFree == false
                              ? null
                              : TextStyle(
                                  color: Colors.white,
                                ),
                        ),
                        onPressed: () {
                          setState(() {
                            isFree = !isFree;
                            if (isFree == true) {
                              setState(() {
                                amount.text = "0";
                                isPaid = false;
                              });
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: isPaid == false
                            ? null
                            : cnst.appPrimaryMaterialColor,
                      ),
                      child: FlatButton(
                        child: Text(
                          'Paid',
                          style: isPaid == false
                              ? null
                              : TextStyle(
                                  color: Colors.white,
                                ),
                        ),
                        onPressed: () {
                          setState(() {
                            isPaid = !isPaid;
                            if (isPaid == true) {
                              setState(() {
                                isFree = false;
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              isFree == true
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: amount,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(
                              Icons.money,
                            ),
                            hintText: "Amount"),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: txtTime1,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.timer_sharp,
                      ),
                      hintText: "From time - To time"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: txtTime2,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.timer_sharp,
                      ),
                      hintText: "From time - To time"),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 25.0),
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.17,
              //     width: MediaQuery.of(context).size.height * 0.17,
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(
              //             color: cnst.appPrimaryMaterialColor[400], width: 1),
              //         borderRadius: BorderRadius.all(Radius.circular(16.0)),
              //         boxShadow: [
              //           BoxShadow(
              //               color:
              //                   cnst.appPrimaryMaterialColor.withOpacity(0.2),
              //               blurRadius: 2.0,
              //               spreadRadius: 2.0,
              //               offset: Offset(3.0, 5.0))
              //         ]),
              //     child: _Image != null
              //         ? Image.file(_Image)
              //         : Center(child: Text("Select Image")),
              //   ),
              // ),
              // buildGridView(),
              SizedBox(
                height: MediaQuery.of(context).padding.top + 5,
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(top: 25.0, left: 25, right: 25),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 40,
              //     child: RaisedButton(
              //         color: cnst.appPrimaryMaterialColor[700],
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         onPressed: () {
              //           _settingModalBottomSheet();
              //         },
              //         child: Text("Upload Image",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 17))),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 10),
              //   child: RaisedButton(
              //     onPressed:
              //         // _settingModalBottomSheet();
              //         loadAssets,
              //     color: cnst.appPrimaryMaterialColor[700],
              //     textColor: Colors.white,
              //     shape: StadiumBorder(),
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         // Icon(
              //         //   Icons.save,
              //         //   size: 30,
              //         // ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 10),
              //           child: Text(
              //             "Upload Image",
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
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
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: RaisedButton(
                  onPressed: () {
                    updateAmenity();
                  },
                  color: cnst.appPrimaryMaterialColor[700],
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
                          "Update Amenities",
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
