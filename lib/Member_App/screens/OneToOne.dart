import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as i;
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneToOne extends StatefulWidget {
  @override
  _OneToOneState createState() => _OneToOneState();
}

double h = 0, w = 0, xPos = 0, yPos = 0;
List<String> _locations = ['A', 'B', 'C', 'D'];
String header = 'Members to Invite';

class _OneToOneState extends State<OneToOne> {
  DateTime selectedDate = DateTime.now();

  TextEditingController _txtPlaceOfMeeting = TextEditingController();
  TextEditingController _txtAgenda = TextEditingController();

  GlobalKey actionKey = LabeledGlobalKey('Member to Invite:');
  List memberData = [];
  bool isDropped = false;
  i.File imageFile;
 // OverlayEntry floatingDropdown;
  bool isSelected = false;

  String _selectedReferralTypeTo;

  @override
  void initState() {
    super.initState();
    _getDirectoryListing();
  }

  addOneToOne(selectPlace, agenda, selectedDate,) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var memberId = prefs.getString(Session.Member_Id);
      print(memberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String onetoName;
        String oneToPath;
        String oneToCompresFile;
        if (imageFile != null) {
          ImageProperties oneToProperties =
              await FlutterNativeImage.getImageProperties(imageFile.path);
        /*  oneToCompresFile = await FlutterNativeImage.compressImage(
              imageFile.path,
              quality: 90);*/
          onetoName = imageFile.path.split("/").last;
          oneToPath = imageFile.path;
        }
        var body = {
          "oneToOneFrom": memberId,
          "oneToOneTo": _selectedReferralTypeTo,
          "dateTime": DateFormat('dd/MM/yyyy').format(selectedDate),
          "comments": agenda,
          "place": selectPlace,
          "oneToOneImage": (imageFile.path != null && imageFile.path != '') ?
              await MultipartFile.fromFile(oneToPath,
                      filename:  onetoName.toString()) : null
        };
        FormData formData = new FormData.fromMap(body);
        print("print body......................");
        print(body);
        Services.responseHandler(apiName: "member/addOneToOne", body: formData)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              print(data.Data);
              Fluttertoast.showToast(
                  msg: "Add One To One Successfully..!!",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
              Navigator.pop(context);
            });
          } else if (data.Data.toString() == "0") {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Add One To One Rejected!!!",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
            });
          } else {
            print("Somthing went Wrong");
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2099));
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  void findDropdownSize() {
    RenderBox renderBox =
        actionKey.currentContext.findRenderObject() as RenderBox;
    h = renderBox.size.height;
    w = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPos = offset.dx;
    yPos = offset.dy;
  }



  _getDirectoryListing() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var SocietyId = prefs.getString(Session.SocietyId);
      var memberId = prefs.getString(Session.Member_Id);
      print("print member ID+++++++++++++++");
      print(memberId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": SocietyId};
        Services.responseHandler(apiName: "admin/directoryListing", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            if(mounted){setState(() {
              memberData = data.Data;
            });
            print("memberData print..................");
            print(memberData);
          } }else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          showHHMsg("Something Went Wrong Please Try Again", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  /*OverlayEntry createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPos,
        width: w,
        top: yPos + h,
        height: (h * _locations.length) + 81,
        child: Container(
          height: (h * _locations.length) + 20,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(children: [
              Container(
                  height: h * 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _createItems(),
                    ),
                  )),
            ]),
          ),
        ),
      );
    });
  }*/

  void _openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _setImageView() {
    if (imageFile != null) {
      isSelected = true;
      setState(() {});
      return Stack(
        children: [
          Image.file(
            (imageFile),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.75,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50)),
                    color: Colors.purple),
              ),
            ),
          ),
          Positioned(
            bottom: 3,
            right: 3,
            child: Opacity(
                opacity: 0.75,
                child: InkWell(
                  onTap: () {
                    _showSelectionDialog(context);
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                )),
          ),
        ],
      );
    } else {
      return Center(
        child: DottedBorder(
          borderType: BorderType.Circle,
          color: Colors.grey,
          strokeWidth: 2.0,
          dashPattern: [3],
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: InkWell(
                onTap: () {
                  _showSelectionDialog(context);
                },
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: Colors.grey,
                )),
          ),
        ),
      );
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  /*_createItems() {
    return new List<Widget>.generate(_locations.length, (int index) {
      return InkWell(
        onTap: () {
          header = _locations[index].toString();
          floatingDropdown.remove();
          isDropped = false;
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade200,
            border: Border.all(color: Colors.deepPurple.shade600),
            borderRadius: (index == 0)
                ? BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7))
                : (index == (_locations.length - 1))
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7))
                    : BorderRadius.circular(0),
          ),
          height: h,
          width: w,
          child: Text(_locations[index].toString()),
        ),
      );
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        title: Text(
          'One-To-One Slip',
          style: TextStyle(
              color: Colors.white, fontFamily: "OpenSans", fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            /*TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search_sharp,
                      size: 25,
                      color: Colors.deepPurple,
                    ),
                    hintText: 'Met With:',
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(7))),
                  ),
                ),*/
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey)),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text('Met With'),
                    value: _selectedReferralTypeTo,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedReferralTypeTo = newValue;
                        print("<divyan sondagar");
                        print(_selectedReferralTypeTo);
                        //storedataincontroler(_selectedReferralTypeTo);
                        //  _selectedReferralTypeMySelf(_selectedReferralTypeTo);
                      });
                    },
                    items: memberData.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location["Name"]),
                        value: location["_id"].toString(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            /*SizedBox(
                  height: 10,
                ),
                InkWell(
                  key: actionKey,
                  onTap: () {
                    findDropdownSize();
                    if (isDropped == false) {
                    floatingDropdown =
                        createFloatingDropdown();
                      Overlay.of(context).insert(floatingDropdown);
                    }
                    if(isDropped==true)
                     {
                        floatingDropdown.remove();
                     }
                    isDropped = !isDropped;
                    setState(() {});
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade600,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              header,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            )
                          ])),
                ),*/
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _txtPlaceOfMeeting,
              decoration: InputDecoration(
                hintText: 'Place of meeting:',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Image.asset("assets/image/calender.png"),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 190.0),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(selectedDate),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            /* TextField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: dateFormatter(DateTime.now()),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(7))),
                  ),
                ),*/
            Padding(padding: EdgeInsets.only(top: 10),),
            Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _setImageView(),
                )),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              controller: _txtAgenda,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Agenda',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
                Center(
                  child: InkWell(
                    onTap: (){
                                if (_txtPlaceOfMeeting.text == "" ||
                                _txtAgenda.text == "" )
                                 {
                                      Fluttertoast.showToast(
                                      msg: "Fields can't be empty",
                                      gravity: ToastGravity.TOP,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      );
                                  } else {
                                  addOneToOne(
                                      _txtPlaceOfMeeting.text, _txtAgenda.text,
                                      selectedDate);
                                }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                        gradient: LinearGradient(
                            colors: <Color>[
                              Colors.deepPurple,
                              Colors.purple,
                            ]
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: 70.0, right: 70, top: 10, bottom: 10),
                      child: Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "OpenSans"),
                      ),
                    ),
                  ),
                ),
          ]),
        ),
      ),
    );
  }

 /* String dateFormatter(DateTime date) {
    dynamic dayData =
        '{ "1" : "Monday", "2" : "Tuesday", "3" : "Wednesday", "4" : "Thursday", "5" : "Friday", "6" : "Saturday", "7" : "Sunday" }';

    dynamic monthData =
        '{ "1" : "January", "2" : "February", "3" : "March", "4" : "April", "5" : "May", "6" : "June", "7" :'
        ' "July", "8" : "August", "9" : "September", "10" : "October", "11" : "November", "12" : "December" }';

    return json.decode(dayData)['${date.weekday}'] +
        " " +
        json.decode(monthData)['${date.month}'] +
        ", " +
        date.day.toString() +
        ", " +
        date.year.toString();
  }*/
}
/*
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}*/
