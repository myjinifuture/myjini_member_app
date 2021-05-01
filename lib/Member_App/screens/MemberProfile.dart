import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/ExtensionMethods.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/DirectoryProfileFamily.dart';
import 'package:smart_society_new/Member_App/screens/DirectoryProfileVehicle.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class MemberProfile extends StatefulWidget {
  var MemberData;

  MemberProfile(this.MemberData);

  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
              .toString();
    }
    final_date = date == "" || date == null
        ? ""
        : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
            .toString();

    return final_date;
  }

  List VehicleData = new List();
  List FmemberData = new List();
  bool isLoading = false;
  String SocietyId, MemberId, ParentId;
  String SocietyIdF, MemberIdF, ParentIdF;

  @override
  void initState() {
    GetMyvehicleData();
    _getLocaldata();
    GetFamilyDetail();
    _getLocaldata1();
  }

  _getLocaldata() async {
    print(widget.MemberData["Id"].toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = widget.MemberData["SocietyId"].toString();
    setState(() {
      MemberId = widget.MemberData["Id"].toString();
    });
  }

  GetMyvehicleData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetVehicleData(MemberId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              VehicleData = data;
              print("======================================");
              print(VehicleData.length.toString());
            });
          } else {
            setState(() {
              VehicleData = data;
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
              },
            ),
          ],
        );
      },
    );
  }

  _getLocaldata1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      SocietyIdF = widget.MemberData["SocietyId"].toString();
      MemberIdF = widget.MemberData["Id"].toString();
    });

    if (widget.MemberData["ParentId"].toString() == "null" ||
        widget.MemberData["ParentId"].toString() == "")
      setState(() {
        ParentIdF = "0";
      });
    else
      setState(() {
        ParentIdF = widget.MemberData["ParentId"].toString();
      });
  }

  GetFamilyDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetFamilyMember(ParentIdF, MemberIdF).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              FmemberData = data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[300], width: 1))),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // AddVehicale();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DirectoryProfileVehicle(
                                    vehicleData:
                                        widget.MemberData["Id"].toString(),
                                  )));
                      // Navigator.pushNamed(context, "/DirectoryProfileVehicle");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                                "Vehicles :  " + VehicleData.length.toString(),
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, "/AddFamily");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DirectoryProfileFamily(
                                    familyData: widget.MemberData,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: constant.appPrimaryMaterialColor,
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                                "Members :  " + FmemberData.length.toString(),
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: widget.MemberData["Image"] == null ||
                                      widget.MemberData["Image"] == ""
                                  ? AssetImage("images/man.png")
                                  : NetworkImage(Image_Url +
                                      '${widget.MemberData["Image"]}'),
                              fit: BoxFit.cover),
                          borderRadius:
                              BorderRadius.all(new Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 8)
                          ]),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    '${widget.MemberData["IsPrivate"]}' == "null"
                        ? Row(
                            children: <Widget>[
                              Icon(Icons.remove_red_eye,
                                  size: 16, color: Colors.red),
                              Text("Visible",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14))
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Icon(Icons.verified_user,
                                  size: 16, color: Colors.green),
                              Text(
                                "Private",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14),
                              )
                            ],
                          )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${widget.MemberData["Name"]}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Text("Wing-" + '${widget.MemberData["Wing"]}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('${widget.MemberData["ResidenceType"]}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        Text("Resident Type",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 9.0, left: 8.0, right: 8.0),
                    child: Container(
                      color: Colors.grey[300],
                      width: 1,
                      height: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('${widget.MemberData["FlatNo"]}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        Text("Flat  Number",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              ListTile(
                leading: Image.asset('images/phone.png',
                    width: 22, height: 22, color: Colors.grey[500]),
                title: widget.MemberData["IsPrivate"] == null
                    ? Text('${widget.MemberData["ContactNo"]}')
                    : Text("******" +
                        '${widget.MemberData["ContactNo"]}'.substring(6, 10)),
                subtitle: Text("Mobile No"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading: Icon(Icons.business_center,
                    color: Colors.grey[500], size: 22),
                subtitle: Text("Business / Job"),
                title:
                    Text('${widget.MemberData["Designation"]}'.checkForNull()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.description, color: Colors.grey[500], size: 22),
                subtitle: Text("Business / Job Description"),
                title: Text('${widget.MemberData["BusinessDescription"]}'
                    .checkForNull()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_balance,
                  color: Colors.grey[500],
                  size: 22,
                ),
                title:
                    Text('${widget.MemberData["CompanyName"]}'.checkForNull()),
                subtitle: Text("Company Name"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading: Image.asset('images/Blood.png',
                    width: 22, height: 22, color: Colors.grey[500]),
                title:
                    Text('${widget.MemberData["BloodGroup"]}'.checkForNull()),
                subtitle: Text("Blood Group"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading: Image.asset('images/gender.png',
                    width: 22, height: 22, color: Colors.grey[500]),
                title: Text('${widget.MemberData["Gender"]}'.checkForNull()),
                subtitle: Text("Gender"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.location_on, size: 22, color: Colors.grey[500]),
                title: Text('${widget.MemberData["Address"]}'.checkForNull()),
                subtitle: Text("Address"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                leading: Image.asset('images/Cake.png',
                    width: 22, height: 22, color: Colors.grey[500]),
                title: Text('${widget.MemberData["DOB"]}' != "null" &&
                        '${widget.MemberData["DOB"]}' != null
                    ? "${setDate(widget.MemberData["DOB"])}"
                    : ""),
                subtitle: Text("DOB"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
