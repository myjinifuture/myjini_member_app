import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/ExtensionMethods.dart';
import 'package:smart_society_new/Member_App/component/masktext.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  AddVehicale() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Addvehicale_dialogue());
  }

  String SocietyId,
      Name,
      Wing,
      ResidanceType,
      FlatNo,
      MobileNumber,
      BusinessJob,
      Description,
      CompanyName,
      BloodGroup,
      Gender,
      Address,
      DOB,
      MemberId,
      Profile;

  String _isPrivate;
  List NoticeData = new List();
  bool isLoading = false;

  // String setDate(String date) {
  //   String final_date = "";
  //   var tempDate;
  //   if (date != "" || date != null) {
  //     tempDate = date.toString().split("-");
  //     if (tempDate[2].toString().length == 1) {
  //       tempDate[2] = "0" + tempDate[2].toString();
  //     }
  //     if (tempDate[1].toString().length == 1) {
  //       tempDate[1] = "0" + tempDate[1].toString();
  //     }
  //     final_date = date == "" || date == null
  //         ? ""
  //         : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
  //             .toString();
  //   }
  //
  //   return final_date;
  // }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("prefs.getString(constant.Session.ResidenceType).toString()");
    print(prefs.getString(constant.Session.ResidenceType).toString());
    setState(() {
      if( prefs.getString(constant.Session.ResidenceType).toString()=="0"){
        ResidanceType = "Owner";
      }
      else if( prefs.getString(constant.Session.ResidenceType).toString()=="1"){
        ResidanceType = "Closed";
      }
      else if( prefs.getString(constant.Session.ResidenceType).toString()=="2"){
        ResidanceType = "Rent";
      }
      else{
        ResidanceType = "Dead";
      }
      SocietyId = prefs.getString(constant.Session.SocietyId);
      Name = prefs.getString(constant.Session.Name);
      Wing = prefs.getString(constant.Session.Wing);
      FlatNo = prefs.getString(constant.Session.FlatNo);
      MobileNumber = prefs.getString(constant.Session.session_login);
      BusinessJob = prefs.getString(constant.Session.Designation);
      Description = prefs.getString(constant.Session.BusinessDescription);
      CompanyName = prefs.getString(constant.Session.CompanyName);
      BloodGroup = prefs.getString(constant.Session.BloodGroup);
      Gender = prefs.getString(constant.Session.Gender);
      Address = prefs.getString(constant.Session.Address);
      DOB = prefs.getString(constant.Session.DOB);
      DOB.replaceAll('00:00:00.000', '');
      _isPrivate = prefs.getString(constant.Session.isPrivate);
      MemberId = prefs.getString(constant.Session.Member_Id);
      // Profile = prefs.getString(constant.Session.Profile);
      getMemberRole(MemberId,SocietyId);
    });

    print("profile" + CompanyName);
    print("date of birth");
    print(DOB);
  }

  @override
  void initState() {
    _getLocaldata();
    GetVehicleData();
  }

  getMemberRole(String memberId, String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"memberId": memberId, "societyId": societyId};
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getMemberRole", body: data)
            .then((data) async {
          print("data");
          print(data);
          if (data.Data[0]["society"]["isAdmin"].toString() == "1") {
            setState(() {
              Profile = data.Data[0]["Image"];
              isLoading = false;
            });
          } else {
            setState(() {
              Profile = data.Data[0]["Image"];
              isLoading = false;
              // _advertisementData = data;
            });
          }
        }, onError: (e) {
          showHHMsg("Something Went Wrong.\nPlease Try Again","");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","");
    }
  }

  GetVehicleData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "memberId" : MemberId
        };
        Services.responseHandler(apiName: "member/getMemberVehicles",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              NoticeData = data.Data[0]["Vehicles"];
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

  Widget _Vehicalelist(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Container(
          child: Wrap(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black54),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: NoticeData[index]["vehicleType"] == "Car"
                        ? Image.asset(
                            "images/automobile.png",
                            width: 40,
                          )
                        : Image.asset("images/bike.png", width: 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "${NoticeData[index]["vehicleNo"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  //Icon(Icons.delete_outline,color: Colors.red,)
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Colors.grey[200],
          height: 1,
          width: MediaQuery.of(context).size.width / 1.1,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(
            context, '/HomeScreen', (route) => false);      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/HomeScreen', (route) => false);              }),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/UpdateProfile");
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.edit, size: 18),
                      Text(
                        "Update",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
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
                        AddVehicale();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text("Add Parking Detail",
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
                        Navigator.pushNamed(context, "/AddFamily");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: constant.appPrimaryMaterialColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text("Add Family Member",
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
          child: Column(
            children: <Widget>[
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.pushNamed(context, "/RegistrationDC");
              //     Navigator.pushNamed(context, "/DashBoard1");
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(top: 15, right: 15),
              //     padding: EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //         color: constant.appPrimaryMaterialColor,
              //         borderRadius: BorderRadius.all(Radius.circular(5))),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: <Widget>[
              //         Icon(
              //           Icons.person,
              //           size: 15,
              //           color: Colors.white,
              //         ),
              //         SizedBox(
              //           width: 5,
              //         ),
              //         Text(
              //           "My Digital Card",
              //           style: TextStyle(fontSize: 12, color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ).alignAtEnd(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: Profile != "null" && Profile != ""
                          ? FadeInImage.assetNetwork(
                              placeholder:  "images/man.png",
                              image: constant.Image_Url + '$Profile',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "images/man.png",
                              width: 100,
                              height: 100,
                            ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     _isPrivate == "false"
              //         ? Row(
              //             children: <Widget>[
              //               Icon(Icons.remove_red_eye,
              //                   size: 16, color: Colors.red),
              //               Text("Visible",
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.w700,
              //                       fontStyle: FontStyle.italic,
              //                       fontSize: 14))
              //             ],
              //           )
              //         : Row(
              //             children: <Widget>[
              //               Icon(Icons.verified_user,
              //                   size: 16, color: Colors.green),
              //               Text(
              //                 "Private",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.w700,
              //                     fontStyle: FontStyle.italic,
              //                     fontSize: 14),
              //               )
              //             ],
              //           )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "$Name",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Text("Wing-" + "$Wing",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
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
                        Text("$ResidanceType",
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
                        FlatNo != 'null' && FlatNo != ''
                          ?Text("$FlatNo",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )): Text(''),
                        Text("Flat Number",
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
                title: MobileNumber != 'null' && MobileNumber != ''
                    ? Text('$MobileNumber')
                    : Text(''),
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
                  title: BusinessJob != 'null' && BusinessJob != ''
                      ? Text('$BusinessJob')
                      : Text('')),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              ListTile(
                  leading: Icon(Icons.description,
                      color: Colors.grey[500], size: 22),
                  subtitle: Text("Business / Job Description"),
                  title: Description != 'null' && Description != ''
                      ? Text('$Description')
                      : Text('')),
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
                title: CompanyName != 'null' && CompanyName != ''
                    ? Text('$CompanyName')
                    : Text(''),
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
                title: BloodGroup != 'null' && BloodGroup != ''
                    ? Text('$BloodGroup')
                    : Text(''),
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
                title: Gender != 'null' && Gender != ''
                    ? Text('$Gender')
                    : Text(''),
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/GetMyVehicle");
                },
                child: ListTile(
                  leading: Image.asset('images/bike.png',
                      width: 20, height: 20, color: Colors.grey[400]),
                  title: Text("My Parking Detail"),
                  subtitle: Text("click to view"),
                  trailing: Icon(Icons.arrow_right),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/FamilyMemberDetail");
                },
                child: ListTile(
                  leading: Image.asset('images/family.png',
                      width: 20, height: 20, color: Colors.grey[400]),
                  title: Text("My Family Member"),
                  subtitle: Text("click to view"),
                  trailing: Icon(Icons.arrow_right),
                ),
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
                title:
                    Text(DOB != "null" && DOB != null ? "${(DOB.replaceAll("00:00:00.000", ""))}" : ""),
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

// Add Vehicle bottomSheet

class VehicleModel {
  bool isSelected;
  final String Vehicle;
  final String path;

  VehicleModel(this.isSelected, this.Vehicle, this.path);
}

class VehicleRadio extends StatelessWidget {
  final VehicleModel _vehiclelistData;

  VehicleRadio(this._vehiclelistData);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            Image.asset(
              "images/" + _vehiclelistData.path,
              height: 55,
              width: 55,
              color:
                  _vehiclelistData.isSelected ? Colors.green[400] : Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(_vehiclelistData.Vehicle),
            )
          ],
        ),
      ),
    );
  }
}

class Addvehicale_dialogue extends StatefulWidget {
  @override
  _Addvehicale_dialogueState createState() => _Addvehicale_dialogueState();
}

class _Addvehicale_dialogueState extends State<Addvehicale_dialogue> {
  List<VehicleModel> vehiclelist = new List<VehicleModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocaldata();
    vehiclelist.add(new VehicleModel(false, "Bike", "bike.png"));
    vehiclelist.add(new VehicleModel(false, "Car", "automobile.png"));
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  String MemberId, VehicleName;

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MemberId = prefs.getString(constant.Session.Member_Id);
    });
  }

  TextEditingController CodeControler = new TextEditingController();
  TextEditingController vehicleNumber = new TextEditingController();
  ProgressDialog pr;

  _AddvehicleDetail() async {
    if (vehicleNumber.text != "") {
      if (vehiclelist != null) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            var data = {
              'memberId': MemberId,
              'vehiclesNoList':[
                {
                  "vehicleType" : "${VehicleName}",
                  "vehicleNo" : "${vehicleNumber.text.trim()}"
                },
              ]
            };
            print(data);
            // pr.show();
            Services.responseHandler(apiName: "member/addMemberVehicles",body: data).then((data) async {
              // pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                Fluttertoast.showToast(
                    msg: "Vehicle Added Successfully!!!",
                    textColor: Colors.green,
                    gravity: ToastGravity.TOP);
                Navigator.pushReplacementNamed(context, "/MyProfile");
              } else {
                showHHMsg("Vehicle Number Already Exist !", "");
                // pr.hide();
              }
            }, onError: (e) {
              // pr.hide();
              showHHMsg("Try Again.", "");
            });
          } else {
            // pr.hide();
            showHHMsg("No Internet Connection.", "");
          }
        } on SocketException catch (_) {
          showHHMsg("No Internet Connection.", "");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please Select Resident Type", toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all Fields", toastLength: Toast.LENGTH_LONG);
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
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("- Add Your Vehicle -",
                style: TextStyle(
                    color: constant.appPrimaryMaterialColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 19)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              "Select Your Vehicle",
              style: TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 3),
                ),
                itemCount: vehiclelist.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: VehicleRadio(vehiclelist[index]),
                    onTap: () {
                      setState(() {
                        vehiclelist
                            .forEach((eleemnt) => eleemnt.isSelected = false);
                        vehiclelist[index].isSelected = true;
                        VehicleName = vehiclelist[index].Vehicle;
                      });
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                inputFormatters: [
                  MaskedTextInputFormatter(
                    mask: 'xx-xx-xx-xxxx',
                    separator: '-',
                  ),
                ],
                controller: vehicleNumber,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    counterText: "",
                    labelText: "Enter Vehicle Number",
                    hintText: "XX-00-XX-0000",
                    hasFloatingPlaceholder: true,
                    labelStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 18.0, left: 8, right: 8, bottom: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                ),
                color: constant.appPrimaryMaterialColor[500],
                textColor: Colors.white,
                splashColor: Colors.white,
                child: Text(
                    "Save Data",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                        ),
                ),
                onPressed: () {
                  _AddvehicleDetail();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
