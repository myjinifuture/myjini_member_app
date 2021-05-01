import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/DigitalCommon/ClassList.dart';
import 'package:smart_society_new/DigitalCommon/Constants.dart';
import 'package:smart_society_new/DigitalCommon/Services.dart';
import 'package:smart_society_new/DigitalComponent/ImagePickerHandlerComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;


class EditOffer extends StatefulWidget {
  final OfferClass offerClass;

  const EditOffer({Key key, this.offerClass}) : super(key: key);

  @override
  _EditOfferState createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer>
    with TickerProviderStateMixin, ImagePickerListener {
  bool isLoading = false;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDate = new TextEditingController();
  TextEditingController txtDesc = new TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

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
    SetData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SetData() {
    txtTitle.text = widget.offerClass.Title;
    txtDesc.text = widget.offerClass.Descri;
    txtDate.text = widget.offerClass.Date;
    var date = widget.offerClass.Date;
    DateFormat format = new DateFormat("dd MMM yyyy");
    date = format.parse(date).toString();
    txtDate.text = date.substring(0, 10);
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
        'id': widget.offerClass.Id,
        'title': txtTitle.text,
        'desc': txtDesc.text,
        'imagecode': img,
        'validtilldate': txtDate.text,
      };

      Future res = Services.UpdateOffer(data);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
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
        title: Text('Edit Offer'),
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

                        //===========
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
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            border: new Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
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
                        ? widget.offerClass.Image != null
                        ? FadeInImage.assetNetwork(
                        placeholder: "images/logo.png",
                        image: widget.offerClass.Image,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover)
                        : Image.asset(
                      "images/logo.png",
                      height: 200.0,
                      width: 200.0,
                    )
                        : Image.file(File(_image.path),
                        height: 200, width: 200, fit: BoxFit.cover),
                  ), //end Center
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
      ),
    );
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
        "Update Offer",
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
