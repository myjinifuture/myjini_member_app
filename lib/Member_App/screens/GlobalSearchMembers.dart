import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/Services/ServiceList.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/component/GlobalMemberComponent.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import '../screens/AddFamilyMember.dart';
import 'package:smart_society_new/Member_App/Services/SubServicesScreen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:get/get.dart';
import 'package:smart_society_new/Member_App/screens/Events.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:smart_society_new/Member_App/screens/DocumentScreen.dart';
import 'package:smart_society_new/Member_App/screens/BroadcastMessagePopUp.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:smart_society_new/Admin_App/Screens/Gallary.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:smart_society_new/Member_App/component/NotificationPopup.dart';
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';
import 'package:smart_society_new/Member_App/screens/GalleryScreen.dart';
import 'package:smart_society_new/Member_App/screens/getPendingApprovals.dart';
import 'package:smart_society_new/screens/bottom_navigation_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Screens/HomeScreen.dart' as home;
import 'package:smart_society_new/Mall_App/transitions/fade_route.dart';
import 'package:smart_society_new/Member_App/Model/ModelClass.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/join.dart';
import 'package:smart_society_new/Member_App/screens/BannerScreen.dart';
import 'package:smart_society_new/Member_App/screens/SOSDailog.dart';
import 'package:vibration/vibration.dart';
import '../screens/SOSpage.dart';
import '../screens/AdDetailPage.dart';
import 'DirectoryScreen.dart';
import 'LoginScreen.dart';
import 'NoticeBoard.dart';
import 'Reminders.dart';
import 'Ringing.dart';
import 'SOS.dart';
import 'VerifiedOrNot.dart';
import 'fromMemberScreen.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:smart_society_new/Member_App/Services/ServicesScreen.dart';
class GlobalSearchMembers extends StatefulWidget {
  String searchText;

  GlobalSearchMembers({this.searchText});

  @override
  _GlobalSearchMembersState createState() => _GlobalSearchMembersState();
}

class _GlobalSearchMembersState extends State<GlobalSearchMembers> {
  bool _isSearching = false, isfirst = false;
  TextEditingController _searchcontroller = new TextEditingController();
  String SocietyId, WingId = "0";
  bool isLoading = false;

  List searchMemberData = [];
  List serviceData = [];

  @override
  void initState() {
    if (widget.searchText != "" && widget.searchText != null) {
      setState(() {
        _searchcontroller.text = widget.searchText;
      });
      getSearchData(widget.searchText);
    }
    initSpeechRecognizer();
    _getLocaldata();
    getVendorCategory();
  }

  List vendorsDataList = [];

  getVendorCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {};
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(
            apiName: "admin/getAllVendorCategory", body: body)
            .then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              isLoading = false;
              vendorsDataList = data.Data;
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
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  String Name;
  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(Session.SocietyId);
    Name = prefs.getString(constant.Session.Name);
    _getDirectoryListing(SocietyId);
    getSocietyVendors(SocietyId);
  }

  List societyVendorDetails = [];

  getSocietyVendors(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId": id,
        };
        Services.responseHandler(apiName: "member/getVendors", body: data).then(
                (data) async {
              print("data");
              print(data.Data);
              if (data.Data != null && data.Data.length > 0) {
                setState(() {
                  societyVendorDetails = data.Data;
                });
              } else {}
            }, onError: (e) {
        });
      }
    } on SocketException catch (_) {
    }
  }

  initSpeechRecognizer() {
    _speechRecognitionName.setRecognitionResultHandler(
          (String speech) => setState(() => _searchcontroller.text = speech),
    );
  }

  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.microphone
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
     /* setState(() {
        _searchcontroller.text = "";
      });*/
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

  List memberData = [];

  _getDirectoryListing(String SocietyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"societyId": SocietyId};
        // setState(() {
        //   isLoading = true;
        // });
        Services.responseHandler(apiName: "admin/directoryListing", body: data)
            .then((data) async {
          memberData.clear();
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              memberData = data.Data;
              // for(int i=0;i<data.Data.length;i++){
              //   if(data.Data[i]["society"]["wingId"] == selectedWing){
              //     memberData.add(data.Data[i]);
              //   }
              // }
              // isLoading = false;
            });
            print("memberData");
            print(memberData);
          } else {
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

  getSearchData(String _text) async {
    bool isDirectoryScreen = false;
    bool isSocietyVendor = false;
    bool isOtherVendor = false;
    bool isVideoCall = false;
    print(_text.replaceAll(" ", "").toUpperCase());
    var vendorName, vendorId;
    if (_text
        .replaceAll(" ", "")
        .toUpperCase()
        .contains("ADDFAMILYMEMBER")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddFamilyMember(),
        ),
      );
    }
    // else if (_BirthDate != null &&
    //     (_text.replaceAll(" ", "").contains("birthdate") ||
    //         _text.replaceAll(" ", "").contains("birthday"))) {
    //   setState(() {
    //     _isListening = false;
    //   });
    //   speak("Your birthdate is" +
    //       DateFormat("yMMMMd").format(_BirthDate).split(" ")[1] +
    //       DateFormat("yMMMMd").format(_BirthDate).split(" ")[0] +
    //       DateFormat("yMMMMd").format(_BirthDate).split(" ")[2]);
    // }
    else if (_text
        .replaceAll(" ", "")
        .toUpperCase()
        .contains("VIDEOCALL") ||
        _text
            .replaceAll(" ", "")
            .toUpperCase()
            .contains("AUDIOCALL") ||
        _text.replaceAll(" ", "").toUpperCase().contains("CALL")) {
      print("video call entered");

    } else {
      for (int i = 0; i < societyVendorDetails.length; i++) {
        societyVendorDetails[i]["ServiceNameFull"] =
            societyVendorDetails[i]["ServiceName"] + "ian";
        if (societyVendorDetails[i]["ServiceName"]
            .toString()
            .toUpperCase()
            .contains(_text.toUpperCase())) {
          isSocietyVendor = true;
        }
      }
      print(_text);
      print("isSocietyVendor");
      print(isSocietyVendor);
      if (isSocietyVendor) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServicesScreen(
                    search: _text.toUpperCase(), initialIndex: 0)));

      } else {
        print(_text.toUpperCase());
        for (int i = 0; i < vendorsDataList.length; i++) {
          if (vendorsDataList[i]["vendorCategoryName"]
              .toString()
              .trim()
              .toUpperCase()
              .contains(_text.toUpperCase())) {
            isOtherVendor = true;
            vendorName = vendorsDataList[i]["vendorCategoryName"];
            vendorId = vendorsDataList[i]["_id"];
          }
        }
        print("isOtherVendor");
        print(isOtherVendor);
        if (isOtherVendor) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubServicesScreen(
                vendorName.toString(),
                vendorId.toString(),
              ),
            ),
          );
        } else {
          for (int i = 0; i < memberData.length; i++) {
            print((memberData[i]["WingData"][0]["wingName"] +
                memberData[i]["FlatData"][0]["flatNo"])
                .toString()
                .toUpperCase()
                .replaceAll("-", ""));
            print(_text.toUpperCase().trim().replaceAll(" ", ""));
            if (memberData[i]["Name"]
                .toString()
                .split(" ")[0]
                .toUpperCase()
                .contains(
                _text.split(" ")[0].toUpperCase().trim()) ||
                memberData[i]["ContactNo"]
                    .toString()
                    .toUpperCase()
                    .contains(_text
                    .toUpperCase()
                    .trim()
                    .replaceAll(" ", "")) ||
                memberData[i]["Vehicles"]
                    .toString()
                    .toUpperCase()
                    .replaceAll("-", "")
                    .contains(_text
                    .toUpperCase()
                    .trim()
                    .replaceAll(" ", "").replaceAll("-", "")) ||
                memberData[i]["BloodGroup"]
                    .toString()
                    .toUpperCase()
                    .replaceAll("-", "")
                    .contains(_text
                    .toUpperCase()
                    .trim()
                    .replaceAll(" ", "")) ||
                (memberData[i]["WingData"][0]["wingName"] +
                    memberData[i]["FlatData"][0]["flatNo"])
                    .toString()
                    .toUpperCase()
                    .replaceAll("-", "")
                    .contains(
                    _text.toUpperCase().trim().replaceAll(" ", ""))) {
              print("found true");
              isDirectoryScreen = true;
            }
          }
          if (isDirectoryScreen) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DirecotryScreen(
                    searchMemberName: _text.toUpperCase().trim()),
              ),
            );
          } else {

          }
        }

      }
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

  SpeechRecognition _speechRecognitionName = new SpeechRecognition();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              controller: _searchcontroller,
              keyboardType: TextInputType.text,
              cursorRadius: Radius.circular(3),
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      getSearchData(_searchcontroller.text);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                      child: Icon(
                        Icons.search,
                        color: constant.appPrimaryMaterialColor,
                        size: 23,
                      ),
                    ),
                  ),
                  /*suffixIcon: IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      requestPermission(PermissionGroup.microphone);
                      _speechRecognitionName
                          .listen(locale: "en_US")
                          .then((result) => print('####-$result'));
                    },
                  ),*/
                  border: InputBorder.none,
                  hintText: "Search Here",
                  hintStyle: TextStyle(
                      fontSize: 13, color: Color.fromRGBO(255, 255, 255, 0.5))),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  searchMemberData.length > 0
                      ? Card(
                          child: Container(
                            height: serviceData.length > 0
                                ? MediaQuery.of(context).size.height / 2.2
                                : MediaQuery.of(context).size.height,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  color: Colors.grey,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Member Matches",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: searchMemberData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GlobalMemberComponent(
                                          searchMemberData[index]);
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  // serviceData.length > 0
                  //     ? Card(
                  //         child: Container(
                  //           height: searchMemberData.length > 0
                  //               ? MediaQuery.of(context).size.height / 2.2
                  //               : MediaQuery.of(context).size.height,
                  //           child: Column(
                  //             children: <Widget>[
                  //               Container(
                  //                 padding: EdgeInsets.only(
                  //                     top: 5, left: 5, bottom: 5),
                  //                 color: Colors.grey,
                  //                 width: MediaQuery.of(context).size.width,
                  //                 child: Text(
                  //                   "Services Matches",
                  //                   style: TextStyle(
                  //                       fontSize: 13,
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.w600),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: ListView.separated(
                  //                   physics: BouncingScrollPhysics(),
                  //                   itemCount: serviceData.length,
                  //                   itemBuilder:
                  //                       (BuildContext context, int index) {
                  //                     return GestureDetector(
                  //                       onTap: () {
                  //                         Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                             builder: (context) => ServiceList(
                  //                               serviceData[index],"",""
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                       child: Container(
                  //                         child: Row(
                  //                           children: <Widget>[
                  //                             FadeInImage.assetNetwork(
                  //                               placeholder: "",
                  //                               image: constant.Image_Url +
                  //                                   serviceData[index]
                  //                                       ["BannerImage"],
                  //                               width: 70,
                  //                               height: 70,
                  //                             ),
                  //                             Padding(
                  //                                 padding: EdgeInsets.only(
                  //                                     left: 12)),
                  //                             Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: <Widget>[
                  //                                 Text(
                  //                                   "${serviceData[index]["Title"]}",
                  //                                   style: TextStyle(
                  //                                       fontWeight:
                  //                                           FontWeight.w600,
                  //                                       color: constant
                  //                                           .appPrimaryMaterialColor),
                  //                                 ),
                  //                                 Text(
                  //                                   "${serviceData[index]["Description"]}",
                  //                                   style: TextStyle(
                  //                                       fontSize: 13,
                  //                                       color: Colors.grey),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                   separatorBuilder:
                  //                       (BuildContext context, int index) {
                  //                     return Divider();
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
            ),
    );
  }
}
