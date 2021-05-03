import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/DigitalCommon/Constants.dart';
import 'package:smart_society_new/DigitalCommon/Services.dart';
import 'package:smart_society_new/DigitalComponent/ImagePickerHandlerComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;

import 'package:shared_preferences/shared_preferences.dart';

class AddOffer extends StatefulWidget {
  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer>
    with TickerProviderStateMixin, ImagePickerListener {
  bool isLoading = false;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDate = new TextEditingController();
  TextEditingController txtDesc = new TextEditingController();

  DateTime date = new DateTime.now();
  String MemberId = "";

  @override
  void initState() {
    super.initState();
    GetLocalData();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    txtDate.text = date.year.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.day.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.digital_Id);

    if (memberId != null && memberId != "")
      setState(() {
        MemberId = memberId;
      });
  }

  SaveOffer() async {
    if (txtTitle.text != '' && txtDate.text != '' && txtDesc.text != '') {
      setState(() {
        isLoading = true;
      });

      String img = '';
      if (_image != null) {
        List<int> imageBytes = await _image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
      }

      print('base64 Img : $img');

      var data = {
        'type': 'offer',
        'title': txtTitle.text,
        'desc': txtDesc.text,
        'imagecode': img,
        'validtilldate': txtDate.text,
        'memberid': MemberId.toString(),
      };

      var data1 = {
        'type': 'offer',
        'title': txtTitle.text,
        'imagecode': img,
      };

      print(data1);
      Future res = Services.SaveGallery(data1);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP);
          Navigator.pushReplacementNamed(context, '/Dashboard');
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Offer'),
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
                    controller: txtTitle,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title), hintText: "Title"),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                  //height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            dateFormat: 'dd-mmm-yyyy',
                            initialDateTime: DateTime.now(),
                            locale: _locale,
                            onCancel: () => print('onCancel'),
                            onChange: (dateTime, List<int> index) {},
                            onConfirm: (dateTime, List<int> index) {
                              setState(() {
                                txtDate.text = dateTime.year.toString() +
                                    '-' +
                                    dateTime.year.toString() +
                                    '-' +
                                    date.toString();
                              });
                            },
                          );
                          // DatePicker.showDatePicker(
                          //   context,
                          //   showTitleActions: true,
                          //   locale: 'en',
                          //   minYear: 1970,
                          //   maxYear: 2020,
                          //   initialYear: DateTime.now().year,
                          //   initialMonth: DateTime.now().month,
                          //   initialDate: DateTime.now().day,
                          //   cancel: Text('cancel'),
                          //   confirm: Text('confirm'),
                          //   dateFormat: 'dd-mmm-yyyy',
                          //   onChanged: (year, month, date) {},
                          //   onConfirm: (year, month, date) {
                          //     txtDate.text = year.toString() +
                          //         '-' +
                          //         month.toString() +
                          //         '-' +
                          //         date.toString();
                          //   },
                          // );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtDate,
                            enabled: false,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                hintText: "Date"),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 80,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      GestureDetector(
                          onTap: () {
                            txtDate.text = "";
                          },
                          child: Icon(Icons.close)),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      border: new Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    maxLines: 5,
                    controller: txtDesc,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        hintText: "Description"),
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: Colors.black),
                  ),
                  //height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () => imagePicker.showDialog(context),
                    child: new Center(
                      child: _image == null
                          ? Image.asset(
                              "images/logo.png",
                              height: MediaQuery.of(context).size.width - 100,
                              width: MediaQuery.of(context).size.width - 100,
                            )
                          : new Container(
                              height: MediaQuery.of(context).size.width - 100,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: new BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: new DecorationImage(
                                  image: new ExactAssetImage(_image.path),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                    color: buttoncolor, width: 2.0),
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(60.0)),
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  child: MaterialButton(
                    color: buttoncolor,
                    minWidth: MediaQuery.of(context).size.width - 20,
                    onPressed: () {
                      if (isLoading == false) this.SaveOffer();
                    },
                    child: setUpButtonChild(),
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
        ));
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }

  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Add Offer",
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}
