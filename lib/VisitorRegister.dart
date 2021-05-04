import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/component/FlatNumberComponent.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/VisitorOtpScreen.dart';

import 'Member_App/common/Services.dart';

class VisitorRegister extends StatefulWidget {
  var societyId;

  VisitorRegister(this.societyId);

  @override
  _VisitorRegisterState createState() => _VisitorRegisterState();
}

class _VisitorRegisterState extends State<VisitorRegister> {
  ProgressDialog pr;
  bool isLoading = true;
  int _currentindex;
  String flatno;
  String societyName;
  List list = [];
  List societyNamelist = [];
  String wingId, societyID;

  String qrData;

  List<winglistClass> winglistClassList = [];
  winglistClass _winglistClass;

  bool winglistLoading = false;
  String _winglistDropdownError;

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtVehicleNumber = new TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // print("kk=> " + widget.list.toString());
    print("kk=> " + widget.societyId.toString());
    // _getdata();
    _getSocietyName();
    _getWingsBySocietyId();
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

/*  _getdata() async {
    societyName = widget.list[0]["Name"].toString();
    print("hh-> " + widget.list[0]["Name"].toString());
    print("hh-> " + widget.societyId.toString());
    print("hh-> " + widget.list.toString());

    societyID = widget.societyId.toString();

*/ /*    setState(() {
      qrData = (societyID != null ? societyID  : '');
    });*/ /*


  }*/

  _getFlatNumber(wingid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetFlatNumber(widget.societyId, wingid);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list = data;
              isLoading = false;
            });
            print("GetSocietyName => " + list.toString());
          } else {
            setState(() {
              list = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetSocietyName Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getWingsBySocietyId() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          winglistLoading = true;
        });
        Future res = Services.GetWingsBySocietyId(widget.societyId.toString());
        res.then((data) async {
          setState(() {
            winglistLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              winglistClassList = data;
            });
            print("servicelisttt=> " + winglistClassList.toString());
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            winglistLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        winglistLoading = false;
      });
    }
  }

  _getSocietyName() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //  String id = societyId.toString();
        Future res = Services.GetSocietyName(widget.societyId.toString());
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              societyNamelist = data;
              isLoading = false;
            });
            print("GetSocietyName => " + list.toString());
          } else {
            setState(() {
              societyNamelist = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetSocietyName Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
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
            new FlatButton(
              child: new Text("OK"),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushReplacementNamed(context, "/HomeScreen");
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          'Visitor Entry',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim() == "") {
                          return 'Please Enter Valid Name';
                        }
                        return null;
                      },
                      controller: txtName,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Enter Name",
                          hintStyle: TextStyle(fontSize: 13)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      "Mobile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim() == "" || value.length < 10) {
                          return 'Please Enter 10 Digit Mobile Number';
                        }
                        return null;
                      },
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: txtMobile,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          counterText: "",
                          fillColor: Colors.grey[200],
                          contentPadding:
                              EdgeInsets.only(top: 5, left: 10, bottom: 5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 0, color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 0, color: Colors.black)),
                          hintText: 'Enter Mobile No',
                          labelText: "Mobile",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      "Vehicle Number",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      /*validator: (value) {
                        if (value.trim() == "") {
                          return 'Please Enter Valid Vehicle Number';
                        }
                        return null;
                      },*/
                      controller: txtVehicleNumber,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Enter Vehicle Number",
                          hintStyle: TextStyle(fontSize: 13)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      "Society Name",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: societyNamelist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: societyNamelist[index]["Name"] == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            " Society Name",
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 16),
                                          ),
                                        )
                                      : Text(
                                          "  ${societyNamelist[index]["Name"]}")),
                            ],
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      "Wing",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<winglistClass>(
                      isExpanded: true,
                      hint: winglistClassList.length > 0
                          ? Text(
                              ' Select Wing',
                              style: TextStyle(fontSize: 15),
                            )
                          : Text(
                              " Wing Not Found",
                              style: TextStyle(fontSize: 15),
                            ),
                      value: _winglistClass,
                      onChanged: (newValue) {
                        setState(() {
                          _winglistClass = newValue;
                          _winglistDropdownError = null;
                        });
                        print("WingID=>" + newValue.id);
                        _getFlatNumber(newValue.id);
                      },
                      items: winglistClassList.map((winglistClass value) {
                        return DropdownMenuItem<winglistClass>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(" " + value.WingName),
                          ),
                        );
                      }).toList(),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      "Flat",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        list.length > 0
                            ? SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: StaggeredGridView.countBuilder(
                                      shrinkWrap: true,
                                      crossAxisCount: 4,
                                      itemCount: list.length,
                                      staggeredTileBuilder: (_) =>
                                          StaggeredTile.fit(1),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _currentindex = index;
                                              });
                                              print("jj--> " +
                                                  _currentindex.toString());
                                              print("jj--> " +
                                                  list[_currentindex]["FlatNo"]
                                                      .toString());
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 30,
                                              child: Card(
                                                color: _currentindex == index
                                                    ? cnst
                                                        .appPrimaryMaterialColor
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    side: _currentindex == index
                                                        ? BorderSide(
                                                            color: Colors
                                                                .blue[900])
                                                        : BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                borderOnForeground: true,
                                                child: Center(
                                                  child: Text(
                                                    "${list[index]["FlatNo"]}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: _currentindex ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Center(
                                child: Text(
                                "No Flats Found",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: cnst.appPrimaryMaterialColor,
                          textColor: Colors.white,
                          splashColor: Colors.white,
                          child: Text("Register",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              //_addVisitorEntry();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisitorOtpScreen(
                                          txtName.text,
                                          txtMobile.text,
                                          txtVehicleNumber.text,
                                          _winglistClass.id,
                                          list[_currentindex]["FlatNo"]
                                              .toString(),
                                          widget.societyId)));
                              //Navigator.pop(context);
                            }

                            /*Navigator.pushReplacementNamed(
                                context, "/OTPVerification");*/
                          }),
                    ),
                  ),
                ],
              ),
            )

            /*     Container(
            child: new Wrap(
              children: <Widget>[
                Center(
                  child: QrImage(
                    data: "${qrData}",
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
                Center(
                    child: Text(
                      "Scan QR",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: Center(
                      child: Text(
                        "ASHIRWAD PARK",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ),*/
            ),
      ),
    );
  }
}
