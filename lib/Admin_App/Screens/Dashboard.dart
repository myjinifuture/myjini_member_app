import 'dart:async';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Screens/MemberProfile.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/SetupWings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

ProgressDialog pr;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String memberType = "";
  String barcode = "";
  bool isLoading = false;

  Widget appBarTitle = new Text("MYJINI");

  List searchMemberData = new List();
  List memberData = [];
  bool _isSearching = false;
  DateTime currentBackPressTime;

  // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";

  TextEditingController _controller = TextEditingController();
  TextEditingController broadcastMessageController = TextEditingController();

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  var _AdminMenuList = [
    {
      "image": "images/notice_dashboard.png",
      "count": "0",
      "title": "Notice",
      "screen": "AllNotice"
    },
    {
      "image": "images/document_dashboard.png",
      "count": "0",
      "title": "Document",
      "screen": "Document"
    },
    {
      "image": "images/directory_dashboard.png",
      "count": "0",
      "title": "Directory",
      "screen": "DirectoryMember"
    },
    {
      "image": "images/visitor_icon.png",
      "count": "0",
      "title": "Visitors",
      "screen": "Visitor"
    },
    {
      "image": "images/Staff.png",
      "count": "0",
      "title": "Staffs",
      "screen": "Staff"
    },
    {
      "image": "images/complaint_icon.png",
      "count": "0",
      "title": "Complaints",
      "screen": "AllComplaints"
    },
    {
      "image": "images/rules_icon.png",
      "count": "0",
      "title": "Rules & Regulations",
      "screen": "RulesAndRegulations"
    },
    {
      "image": "images/event.png",
      "count": "0",
      "title": "Events",
      "screen": "EventsAdmin"
    },
    {
      "image": "images/gallary_admin.png",
      "count": "0",
      "title": "Gallery",
      "screen": "Gallary"
    },
    // {
    //   "image": "images/income.png",
    //   "count": "0",
    //   "title": "Income",
    //   "screen": "Income"
    // },
    // {
    //   "image": "images/expense.png",
    //   "count": "0",
    //   "title": "Expense",
    //   "screen": "Expense"
    // },
    // {
    //   "image": "images/balance_sheet.png",
    //   "count": "0",
    //   "title": "Balance Sheet",
    //   "screen": "BalanceSheet"
    // },
    {
      "image": "images/admin_polling.png",
      "count": "0",
      "title": "Polling",
      "screen": "AllPolling"
    },
    // {
    //   "image": "images/amc_icon.png",
    //   "count": "0",
    //   "title": "AMCs",
    //   "screen": "amcList"
    // },
    {
      "image": "images/amenities.png",
      "count": "0",
      "title": "Amenities",
      "screen": "getAmenitiesScreen"
    },
    {
      "image": "images/pendingapproval.png",
      "count": "0",
      "title": "Pending Approvals",
      "screen": "getPendingApprovals"
    },
    // {
    //   "image": "images/editsocietydetails.png",
    //   "count": "0",
    //   "title": "Edit Wing Details",
    //   "screen": "getPendingApprovals"
    // },
    {
      "image": "images/adminemergencynumbers.png",
      "count": "0",
      "title": "Emergency Numbers",
      "screen": "getEmergencyNumberSocietyWise"
    },
    {
      "image": "images/vendor.png",
      "count": "0",
      "title": "All Vendors",
      "screen": "VendorsAdminScreen"
    },
    /*  {
      "image": "images/Vendors.png",
      "count": "0",
      "title": "Vendors",
      "screen": "Vendors"
    },
    {
      "image": "images/Vendors.png",
      "count": "0",
      "title": "Service Requests",
      "screen": "MyServiceRequests"
    },*/
    /*  {
      "image": "images/Vendors.png",
      "count": "0",
      "title": "Advertisement",
      "screen": "AdvertisementList"
    }*/
  ];

  @override
  void initState() {
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
    _getLocalData();
    // _getMembers();

    // if (Platform.isIOS) {
    //   iosSubscription =
    //       _firebaseMessaging.onIosSettingsRegistered.listen((data) {
    //     print("FFFFFFFF" + data.toString());
    //     saveDeviceToken();
    //   });
    //   _firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // } else {
    //   saveDeviceToken();
    // }
  }

  List wingsList = [];
  List wingsNameList = [];
  List selectedWingList = [];
  List selectedWingIdList = [];
  bool wingsLoading = false;

  getWingsId() async {
    try {
      print("getWingsId called");
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          wingsLoading = true;
        });
        var body = {"societyId": societyId};
        Services.responseHandler(
                apiName: "admin/getAllWingOfSociety", body: body)
            .then((data) async {
          if (data.Data != null) {
            setState(() {
              // wingsList = data.Data;
              for (int i = 0; i < data.Data.length; i++) {
                if (data.Data[i]["totalFloor"].toString() != "0") {
                  wingsList.add(data.Data[i]);
                }
              }
              for (int i = 0; i < wingsList.length; i++) {
                wingsNameList.add({
                  "Name" : wingsList[i]["wingName"],
                  "Id" : wingsList[i]["_id"],
                });
              }
              wingsLoading = false;
            });
            getMobileNoAndSocietyCode();
          }
        }, onError: (e) {
          setState(() {
            wingsLoading = false;
            showMsg("$e");
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  sendSocietyBroadcastMessage() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String societyId = prefs.getString(cnst.Session.SocietyId);
      String adminId = prefs.getString(Session.Member_Id);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "societyId": societyId,
          "adminId": adminId,
          "wingIdList": selectedWingIdList,
          "message": broadcastMessageController.text,
        };
        Services.responseHandler(apiName: "admin/societyBroadcast", body: body)
            .then((data) async {
          if (data.Data.toString() == "1" && data.IsSuccess == true) {
            Fluttertoast.showToast(
              msg: "Broadcast message sent successfully!!",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            broadcastMessageController.clear();
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

  String mobileNo, societyCode;

  getMobileNoAndSocietyCode() async {
    try {
      print("getMobileNoAndSocietyCode data called");
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {"memberId": memberId, "societyId": societyId};
        Services.responseHandler(
                apiName: "member/getMemberInformation", body: body)
            .then((data) async {
          if (data.Data.length > 0) {
            mobileNo = data.Data[0]["ContactNo"];
            societyCode = data.Data[0]["SocietyData"][0]["societyCode"];
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

  saveDeviceToken() async {
    // _firebaseMessaging.getToken().then((String token) {
    //   print("Original Token:$token");
    //   var tokendata = token.split(':');
    //   setState(() {
    //     fcmToken = token;
    //     sendFCMTokan(token);
    //   });
    //   print("FCM Token : $fcmToken");
    // });
  }

  // sendFCMTokan(var FcmToken) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       Future res = Services.SendTokanToServer(FcmToken);
  //       res.then((data) async {}, onError: (e) {
  //         print("Error : on Login Call");
  //       });
  //     }
  //   } on SocketException catch (_) {}
  // }

  String societyId, memberId,wingId;

  _getLocalData() async {
    print("local data called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberType = prefs.getString(cnst.Session.Role);
      societyId = prefs.getString(cnst.Session.SocietyId);
      memberId = prefs.getString(Session.Member_Id);
      wingId = prefs.getString(Session.WingId);
    });
    _getDashboardCount(
        societyId,wingId); // ask monil to make dashboardcount api service 16 - number
  }

  _getDashboardCount(String societyId,String wingId) async {
    try {
      print("dashoard called");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": societyId,
        "wingId" : wingId
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "admin/getDashboardCount_v1", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setDashboardData(data.Data);
            setState(() {
              isLoading = false;
            });
            getWingsId();
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  setDashboardData(data) {
    for (int i = 0; i < _AdminMenuList.length; i++) {
      if (_AdminMenuList[i]["title"] == "Notice")
        setState(() {
          _AdminMenuList[i]["count"] = data["NoticeBoard"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Document")
        setState(() {
          _AdminMenuList[i]["count"] = data["Docs"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Directory")
        setState(() {
          _AdminMenuList[i]["count"] = data["Members"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Visitors")
        setState(() {
          _AdminMenuList[i]["count"] = data["Visitor"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Staffs")
        setState(() {
          _AdminMenuList[i]["count"] = data["TotalStaff"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Edit Wing Details")
        setState(() {
          _AdminMenuList[i]["count"] = data["Wing"].toString();
        });
      if (_AdminMenuList[i]["title"] == "All Vendors")
        setState(() {
          _AdminMenuList[i]["count"] = data["Vendor"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Emergency Numbers")
        setState(() {
          _AdminMenuList[i]["count"] =
              data["SocietyEmergencyContact"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Amenities")
        setState(() {
          _AdminMenuList[i]["count"] = data["Amenities"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Events")
        setState(() {
          _AdminMenuList[i]["count"] = data["Event"].toString();
        });

      //
      if (_AdminMenuList[i]["title"] == "Complaints")
        setState(() {
          _AdminMenuList[i]["count"] = data["Complain"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Rules & Regulations")
        setState(() {
          _AdminMenuList[i]["count"] = data["Rule"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Gallery")
        setState(() {
          _AdminMenuList[i]["count"] = data["Gallery"].toString();
        });

      if (_AdminMenuList[i]["title"] == "Pending Approvals")
        setState(() {
          _AdminMenuList[i]["count"] = data["PendingApprovalMember"].toString();
        });
      if (_AdminMenuList[i]["title"] == "Income") {
        if (data["Income"].toString() != "null" &&
            data["Income"].toString() != "") {
          setState(() {
            _AdminMenuList[i]["count"] = double.parse(data["Income"].toString())
                .toStringAsFixed(2)
                .toString();
          });
        }
      }
      if (_AdminMenuList[i]["title"] == "Expense") {
        if (data["ExpenseTotal"].toString() != "null" &&
            data["ExpenseTotal"].toString() != "") {
          setState(() {
            _AdminMenuList[i]["count"] =
                double.parse(data[0]["ExpenseTotal"].toString())
                    .toStringAsFixed(2)
                    .toString();
          });
        }
      }
      if (_AdminMenuList[i]["title"] == "Balance Sheet")
        setState(() {
          _AdminMenuList[i]["count"] =
              double.parse(data["BalanceSheet"].toString())
                  .toStringAsFixed(2)
                  .toString();
        });
      if (_AdminMenuList[i]["title"] == "Polling")
        setState(() {
          _AdminMenuList[i]["count"] = data["Polling"].toString();
        });
    }
  }

  // Future scan() async {
  //   try {
  //     String barcode = await BarcodeScanner.scan();
  //     print(barcode);
  //     if (barcode != null) {
  //       _addVisitor(barcode);
  //     } else
  //       showMsg("Try Again..");
  //   } on PlatformException catch (e) {
  //     if (e.code == BarcodeScanner.CameraAccessDenied) {
  //       setState(() {
  //         this.barcode = 'The user did not grant the camera permission!';
  //       });
  //     } else {
  //       setState(() => this.barcode = 'Unknown error: $e');
  //     }
  //   } on FormatException {
  //     setState(() => this.barcode =
  //         'null (User returned using the "back"-button before scanning anything. Result)');
  //   } catch (e) {
  //     setState(() => this.barcode = 'Unknown error: $e');
  //   }
  // }

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
                ;
              },
            ),
          ],
        );
      },
    );
  }

  // _addVisitor(String barcode) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       // pr.show();
  //       Services.AddVisitorByScan(barcode).then((data) async {
  //         if (data.Data == "1") {
  //           // pr.hide();
  //           showMsg("Visitor Verified Successfully");
  //         } else {
  //           // pr.hide();
  //           showMsg("Visitor Is Not Verified");
  //         }
  //       }, onError: (e) {
  //         // pr.hide();
  //         print("Error : on Delete Notice $e");
  //         showMsg("Something Went Wrong Please Try Again");
  //         // pr.hide();
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     showMsg("Something Went Wrong");
  //   }
  // }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MYJINI"),
          content: new Text("Are You Sure You Want To Logout ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                ;
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
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

  _openWhatsapp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        /*   if (_isSearching)
          _handleSearchEnd();
        else {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Double Tap To Exit App");
            return Future.value(false);
          }
          return Future.value(true);
        }*/
        //return Future.value(true);
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: _isSearching
            ? ListView.builder(
                itemCount: searchMemberData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 1.0, top: 1, bottom: 1),
                                child: searchMemberData[index]["Image"] != '' &&
                                        searchMemberData[index]["Image"] != null
                                    ? FadeInImage.assetNetwork(
                                        placeholder: '',
                                        image: Image_Url +
                                            "${searchMemberData[index]["Image"]}",
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fill)
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${searchMemberData[index]["Name"].toString().substring(0, 1).toUpperCase()}",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${searchMemberData[index]["Name"]}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700])),
                                      Row(
                                        children: <Widget>[
                                          Text("Flat No:"),
                                          Text(
                                              "${searchMemberData[index]["FlatData"][0]["flatNo"]}")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset("images/whatsapp_icon.png",
                                    width: 30, height: 30),
                                onPressed: () {
                                  _openWhatsapp(
                                      searchMemberData[index]["ContactNo"]);
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons.call, color: Colors.brown),
                                  onPressed: () {
                                    launch("tel:" +
                                        searchMemberData[index]["ContactNo"]);
                                  }),
                              IconButton(
                                  icon: Icon(Icons.remove_red_eye,
                                      color: cnst.appPrimaryMaterialColor),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MemberProfile(
                                                  memberData:
                                                      searchMemberData[index],
                                                )));
                                  }),
                              IconButton(
                                  icon: Icon(Icons.share), onPressed: () {}),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            : isLoading
                ? LoadingComponent()
                : Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: AnimationLimiter(
                      child: GridView.builder(
                          itemCount: _AdminMenuList.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              4.2),
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_AdminMenuList[index]["title"] ==
                                          "Edit Wing Details") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        SetupWings(
                                                            wingData: wingsList
                                                                .length
                                                                .toString(),
                                                            societyId: societyId
                                                                .toString(),
                                                            mobileNo: mobileNo,
                                                            societyCode:
                                                                societyCode,
                                                            isEdit: true)));
                                      } else if (_AdminMenuList[index]
                                              ["title"] ==
                                          "AMCs") {
                                        Fluttertoast.showToast(
                                            msg: "Coming Soon!!!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else if (_AdminMenuList[index]
                                              ["title"] ==
                                          "Expense") {
                                        Fluttertoast.showToast(
                                            msg: "Coming Soon!!!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else if (_AdminMenuList[index]
                                              ["title"] ==
                                          "Income") {
                                        Fluttertoast.showToast(
                                            msg: "Coming Soon!!!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else if (_AdminMenuList[index]
                                              ["title"] ==
                                          "Balance Sheet") {
                                        Fluttertoast.showToast(
                                            msg: "Coming Soon!!!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        Navigator.pushNamed(context,
                                            "/${_AdminMenuList[index]["screen"]}");
                                      }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(6),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 7)),
                                            Image.asset(
                                                "${_AdminMenuList[index]["image"]}",
                                                width: 37,
                                                height: 37,
                                                fit: BoxFit.fill),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10)),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "${_AdminMenuList[index]["count"]}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${_AdminMenuList[index]["title"]}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[600]),
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
                                ),
                              ),
                            );
                          }),
                    )),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      title: appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.outgoing_mail,
            // color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Center(child: Text("MYJINI")),
                  content: SingleChildScrollView(
                    child: wingsLoading == false
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Broadcast Message",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 45,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 13.0),
                                      child:
                                          Image.asset("images/loudspeaker.png"),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: DottedDecoration(
                                  shape: Shape.box,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  controller: broadcastMessageController,
                                  keyboardType: TextInputType.text,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Start typing here ...",
                                    contentPadding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // MultiSelectDialogField(
                              //
                              //   items: wingsList
                              //       .map((e) => MultiSelectItem(e, e["wingName"]))
                              //       .toList(),
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   onConfirm: (values) {
                              //     selectedWingList.clear();
                              //     selectedWingIdList.clear();
                              //     selectedWingList = values;
                              //     for (int i = 0; i < selectedWingList.length; i++) {
                              //       selectedWingIdList
                              //           .add(selectedWingList[i]["_id"]);
                              //     }
                              //     print(selectedWingIdList);
                              //   },
                              //   buttonIcon: Icon(
                              //     Icons.arrow_drop_down,
                              //     color: cnst.appPrimaryMaterialColor,
                              //   ),
                              //   buttonText: Text("Select Wing"),
                              // ),
                              MultiSelectFormField(
                                autovalidate: false,
                                title: Text('Select Wing'),
                                validator: (value) {
                                  if (value == null || value.length == 0) {
                                    return 'Please select one or more options';
                                  }
                                },border: InputBorder.none,
                                dataSource: wingsNameList,
                                textField: 'Name',
                                valueField: 'Name',
                                okButtonLabel: 'OK',
                                cancelButtonLabel: 'CANCEL',
                                hintWidget: Text('No Wing Selected'),
                                change: () => selectedWingList,
                                onSaved: (value) {
                                  selectedWingList.clear();
                                  setState(() {
                                    selectedWingList = value;
                                  });
                                  print("selectedWingList");
                                  print(selectedWingList);
                                  selectedWingIdList.clear();
                                  for (int i = 0; i < selectedWingList.length; i++) {
                                    for(int j=0;j<wingsNameList.length;j++){
                                      if(selectedWingList[i].toString() == wingsNameList[j]["Name"].toString()){
                                        selectedWingIdList.add(wingsNameList[j]["Id"].toString());
                                      }
                                    }
                                  }
                                  print("selectedWingIdList");
                                  print(selectedWingIdList);
                                },
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                          ),
                  ),
                  actions: [
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                        broadcastMessageController.clear();
                      },
                    ),
                    FlatButton(
                      child: Text('Send'),
                      onPressed: () {
                        Navigator.pop(context);
                        sendSocietyBroadcastMessage();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: icon,
          onPressed: () {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          },
        ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      setState(() {});
      this.appBarTitle = Text("MYJINI");
      _isSearching = false;
      searchMemberData.clear();
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchMemberData.clear();
    if (_isSearching != null) {
      if (searchText != "") {
        for (int i = 0; i < memberData.length; i++) {
          String name = memberData[i]["Name"];
          String flat = memberData[i]["FlatNo"].toString();
          if (name.toLowerCase().contains(searchText.toLowerCase()) ||
              flat.toLowerCase().contains(searchText.toLowerCase())) {
            searchMemberData.add(memberData[i]);
          }
        }
      } else
        searchMemberData.clear();
    }
    setState(() {});
  }
}
