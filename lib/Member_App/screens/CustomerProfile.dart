import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/DigitalComponent/LoadinComponent.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/CustomWidgets/LoadingComponent.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/Mall/Components/DailyResourseComponent.dart';
import 'package:smart_society_new/Member_App/Mall/Components/FamilyMemberComponent.dart';
import 'package:smart_society_new/Member_App/Mall/Components/MyResidenceComponent.dart';
import 'package:smart_society_new/Member_App/Mall/Components/MyVehicleComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/component/masktext.dart';
import 'package:smart_society_new/Member_App/screens/AddDailyResource.dart';
import 'package:smart_society_new/Member_App/screens/AddFamilyMember.dart';
import 'package:smart_society_new/Member_App/screens/AddMyResidents.dart';
import 'package:smart_society_new/Member_App/screens/EmergencyContactScreen.dart';
import 'package:smart_society_new/Member_App/screens/PreferenceScreen.dart';
import 'package:smart_society_new/Member_App/screens/UpdateProfileScreen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:share/share.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerProfile extends StatefulWidget {
  bool isAdmin = false;

  CustomerProfile({this.isAdmin});

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  String Name, MobileNo, Profile;
  List FmemberData = new List();
  List DailyResourceData = new List();
  List MyResidentsData = [];
  bool isLoading = true;
  List VehicleData = new List();
  String SocietyId, MemberId, ParentId, FlatId, WingId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shareMyJINIAppDetails();
    _handleSendNotification();
    initPlatformState();
    profile();
    GetMyResidents();
    GetFamilyDetail();
    // GetDailyResourceDetail();
    GetMyvehicleData();
    GetDailyResourceDetail();
    getLocaldata();
  }

  String memId;
  var shareMyJINIAppDetailsContent;

  shareMyJINIAppDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {};
        Services.responseHandler(apiName: "admin/shareMyJiniApp", body: body)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              shareMyJINIAppDetailsContent = data.Data;
            });
            print("shareMyJINIAppDetailsContent");
            print(shareMyJINIAppDetailsContent);
          }
        }, onError: (e) {
              print("this is the error");
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memId = prefs.getString(constant.Session.Member_Id);
    });
  }

  _DeleteMemberVehicle(String VehicleNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {"memberId": MemberId, "vehicleNo": VehicleNo};
        Services.responseHandler(
                apiName: "member/deleteMemberVehicles", body: data)
            .then((data) async {
          if (data.Data.toString() == "1") {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Vehicle Deleted Successfully!!!",
                toastLength: Toast.LENGTH_LONG,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red);
            GetMyvehicleData();
          } else {
            isLoading = false;
            // showHHMsg("Vehicle Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Name = prefs.getString(constant.Session.Name);
      MobileNo = prefs.getString(constant.Session.session_login);
      // Profile = prefs.getString(constant.Session.Profile);
      SocietyId = prefs.getString(constant.Session.SocietyId);
      MemberId = prefs.getString(constant.Session.Member_Id);
      FlatId = prefs.getString(constant.Session.FlatId);
      WingId = prefs.getString(constant.Session.WingId);
      if (prefs.getString(constant.Session.ParentId) == "null" ||
          prefs.getString(constant.Session.ParentId) == "")
        ParentId = "0";
      else
        ParentId = prefs.getString(constant.Session.ParentId);
    });
    getMemberRole(MemberId, SocietyId);
    // GetMyResidents();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Exit?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                ;
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                ;
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  var playerId;

  void _handleSendNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    playerId = status.subscriptionStatus.userId;
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

  String uniqueId = "Unknown";

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformImei =
    //   await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    //   List<String> multiImei = await ImeiPlugin.getImeiMulti();
    //   print(multiImei);
    //   idunique = await ImeiPlugin.getId();
    // } on PlatformException {
    //   platformImei = 'Failed to get platform version.';
    // }
    String identifier = await UniqueIdentifier.serial;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      uniqueId = identifier;
    });
  }

  _logout() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"memberId": memId, "playerId": playerId, "IMEI": uniqueId};
        print("data");
        print(data);
        Services.responseHandler(apiName: "member/logout", body: data).then(
            (data) async {
          if (data.Data != null && data.Data.toString() == "1") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushReplacementNamed(context, "/LoginScreen");
          } else {
            // setState(() {});
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {});
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {});
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {});
    }
  }

  //get vehicle data
  GetMyvehicleData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {"memberId": MemberId.toString()};
        Services.responseHandler(
                apiName: "member/getMemberVehicles", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              VehicleData = data.Data[0]["Vehicles"];
            });
          } else {
            setState(() {
              // VehicleData = data.Data[0]["Vehicles"];
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

//add vehicle
  AddVehicale() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Addvehicale_dialogue(
              onAdd: () {
                setState(() {
                  GetMyvehicleData();
                });
              },
            ));
  }

  //get My Residents api
  GetMyResidents() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(constant.Session.Member_Id);
        setState(() {
          isLoading = true;
        });
        var data = {
          "memberId": memberId,
        };
        Services.responseHandler(
                apiName: "member/getMemberProperties", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              MyResidentsData = data.Data;
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

  //get family api
  GetFamilyDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {"societyId": SocietyId, "wingId": WingId, "flatId": FlatId};
        Services.responseHandler(apiName: "member/getFamilyMembers", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              FmemberData = data.Data;
              for (int i = 0; i < FmemberData.length; i++) {
                if (FmemberData[i]["_id"].toString() == MemberId) {
                  FmemberData.remove(FmemberData[i]);
                  break;
                }
              }
            });
            print("FmemberData");
            print(FmemberData);
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

  GetDailyResourceDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {"societyId": SocietyId, "wingId": WingId, "flatId": FlatId};
        Services.responseHandler(
                apiName: "member/getMemberResources", body: data)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              DailyResourceData = data.Data;
            });
            print('============================${DailyResourceData}');
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
                Navigator.of(context).pop();
                ;
              },
            ),
          ],
        );
      },
    );
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
              print("data.Data");
              print(data.Data);
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
          showHHMsg("Something Went Wrong.\nPlease Try Again", "");
          setState(() {
            isLoading = false;
          });
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
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Icon(Icons.arrow_back_ios),
        // ),
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
      body: isLoading == true
          ? LoadingComponent()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // for profile
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 17.0, left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pushReplacement(
                        //     context, SlideLeftRoute(page: UpdateProfile()));
                        Navigator.pushNamed(context, '/UpdateProfile');
                      },
                      child: Container(
                        color: Colors.grey[100],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: CircleAvatar(
                                backgroundImage:
                                    //  AssetImage('assets/assets/profile.png'),
                                    '$Profile' == "null" || '$Profile' == ""
                                        ? AssetImage(
                                            'assets/assets/profile.png')
                                        : NetworkImage(
                                            constant.Image_Url + '$Profile'),
                                backgroundColor: appPrimaryMaterialColor,
                                radius: 35,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(Name != null ? Name : "Name",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          MobileNo != null
                                              ? MobileNo
                                              : "MobileNo",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700])),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //for my residence
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 10, top: 20),
                    child: Row(
                      children: [
                        Icon(Icons.home_work_outlined),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "My Residents",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                SlideLeftRoute(
                                    page: AddMyResidents(
                                  onAddMyResidents: GetMyResidents,
                                )));
                          },
                          child: Container(
                            //color: Colors.orange[300],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15,
                                  ),
                                  Text("Add  ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      //bottom: 10,
                    ),
                    child: Container(
                      height: 90,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: MyResidentsData.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index > MyResidentsData.length - 1) {
                              return Container(
                                width: 150,
                                decoration: DottedDecoration(
                                  shape: Shape.box,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FlatButton(
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: appPrimaryMaterialColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        SlideLeftRoute(
                                            page: AddMyResidents(
                                          onAddMyResidents: GetMyResidents,
                                        )));
                                  },
                                ),
                              );
                            } else {
                              return MyResidenceComponent(
                                onDeleteProperty: GetMyResidents,
                                resData: MyResidentsData[index],
                                index: index,
                              );
                            }
                          }),
                    ),
                  ),

                  //for Family Member
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 10, top: 25),
                    child: Row(
                      children: [
                        Container(
                            height: 30,
                            width: 30,
                            child: Image.asset('images/familymember.png')),
                        // Icon(Icons.family_restroom),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Family Member",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                SlideLeftRoute(page: AddFamilyMember(
                              onAddFamily: () {
                                setState(() {
                                  GetFamilyDetail();
                                });
                              },
                            )));
                          },
                          child: Container(
                            //color: Colors.orange[300],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15,
                                  ),
                                  Text("Add  ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      //bottom: 10,
                    ),
                    child: Container(
                      height: 190,
                      child: isLoading == true
                          ? LoadingComponent()
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: FmemberData.length + 1,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                if (index > FmemberData.length - 1) {
                                  return Container(
                                    width: 100,
                                    decoration: DottedDecoration(
                                      shape: Shape.box,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: FlatButton(
                                      child: Icon(
                                        Icons.add,
                                        size: 30,
                                        color: appPrimaryMaterialColor,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, SlideLeftRoute(
                                            page: AddFamilyMember(
                                          onAddFamily: () {
                                            setState(() {
                                              GetFamilyDetail();
                                            });
                                          },
                                        )));
                                      },
                                    ),
                                  );
                                } else {
                                  return FamilyMemberComponent(
                                    memberName: Name,
                                    familyData: FmemberData[index],
                                    onDelete: GetFamilyDetail,
                                    onUpdate: () {
                                      setState(() {
                                        GetFamilyDetail();
                                      });
                                    },
                                  );
                                }
                              }),
                    ),
                  ),
                  //for Daily Resourse
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 10, top: 25),
                    child: Row(
                      children: [
                        Container(
                            height: 30,
                            width: 30,
                            child: Image.asset('images/dailyresource.png')),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Daily Resources",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                SlideLeftRoute(page: AddDailyResource(
                              onAddDailyResource: () {
                                setState(() {
                                  GetDailyResourceDetail();
                                });
                              },
                            )));
                          },
                          child: Container(
                            //color: Colors.orange[300],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15,
                                  ),
                                  Text("Add  ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      //bottom: 10,
                    ),
                    child: Container(
                      height: 190,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: DailyResourceData.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index > DailyResourceData.length - 1) {
                              return Container(
                                width: 100,
                                decoration: DottedDecoration(
                                  shape: Shape.box,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FlatButton(
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: appPrimaryMaterialColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        SlideLeftRoute(page: AddDailyResource(
                                      onAddDailyResource: () {
                                        setState(() {
                                          GetDailyResourceDetail();
                                        });
                                      },
                                    )));
                                  },
                                ),
                              );
                            } else {
                              return DailyResourseComponent(
                                dailyResourceData: DailyResourceData[index],
                                isAdmin: widget.isAdmin,
                                onDelete: () {
                                  setState(() {
                                    DailyResourceData.removeAt(index);
                                  });
                                },
                                onUpdate: () {
                                  setState(() {
                                    GetDailyResourceDetail();
                                  });
                                },
                              );
                            }
                          }),
                    ),
                  ),
                  //for my vehicle
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 10, top: 20),
                    child: Row(
                      children: [
                        Icon(Icons.home_work_outlined),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "My Vehicle",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            AddVehicale();
                          },
                          child: Container(
                            //color: Colors.orange[300],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15,
                                  ),
                                  Text("Add  ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      //bottom: 10,
                    ),
                    child: Container(
                      height: 90,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: VehicleData.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index > VehicleData.length - 1) {
                              return Container(
                                width: 150,
                                decoration: DottedDecoration(
                                  shape: Shape.box,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FlatButton(
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: appPrimaryMaterialColor,
                                  ),
                                  onPressed: () {
                                    AddVehicale();
                                  },
                                ),
                              );
                            } else {
                              return MyVehicleComponent(
                                vehicleData: VehicleData[index],
                                onDelete: () {
                                  _DeleteMemberVehicle(
                                      VehicleData[index]["vehicleNo"]);
                                },
                              );
                            }
                          }),
                    ),
                  ),
                  Column(
                    children: [
                      Divider(),
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              SlideLeftRoute(page: PreferenceScreen()));
                        },
                        leading: Icon(
                          Icons.settings_outlined,
                          size: 25,
                          color: Colors.black54,
                        ),
                        title: Text(
                          "Preferences",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              SlideLeftRoute(page: EmergencyContactScreen()));
                        },
                        leading: Icon(
                          Icons.add_ic_call_outlined,
                          size: 25,
                          color: Colors.black54,
                        ),
                        title: Text(
                          "SOS Contacts",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Share.share(shareMyJINIAppDetailsContent);
                        },
                        leading: Icon(
                          Icons.share,
                          size: 25,
                          color: Colors.black54,
                        ),
                        title: Text(
                          "Tell a friend about MYJINI",
                          style: TextStyle(fontSize: 16),
                        ),
                        // trailing: Icon(
                        //   Icons.arrow_forward_ios,
                        //   size: 20,
                        //   color: Colors.black,
                        // ),
                      ),
                      ListTile(
                        onTap: () {
                          _showConfirmDialog();
                        },
                        leading: Icon(
                          Icons.logout,
                          size: 25,
                          color: Colors.black54,
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 16),
                        ),
                        // trailing: Icon(
                        //   Icons.arrow_forward_ios,
                        //   size: 20,
                        //   color: Colors.black,
                        // ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

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
  Function onAdd;

  Addvehicale_dialogue({this.onAdd});

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
              "vehiclesNoList": [
                {
                  "vehicleType": VehicleName,
                  "vehicleNo": vehicleNumber.text.trim()
                }
              ]
            };
            // pr.show();
            Services.responseHandler(
                    apiName: "member/addMemberVehicles", body: data)
                .then((data) async {
              // pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                //Navigator.pushReplacementNamed(context, "/MyProfile");
                // Navigator.pushReplacement(
                //     context, SlideLeftRoute(page: CustomerProfile()));
                widget.onAdd();
                Navigator.pop(context);
              } else {
                showHHMsg("Mobile Number Already Exist !", "");
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
                Navigator.of(context).pop();
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
                    borderRadius: BorderRadius.circular(5)),
                color: constant.appPrimaryMaterialColor[500],
                textColor: Colors.white,
                splashColor: Colors.white,
                child: Text("Save Data",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
