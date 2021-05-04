import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class PreferenceScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool isEmailSwitched = false;
  bool isContactSwitched = false;
  bool isDOBSwitched = false;
  bool isAnniversarySwitched = false;
  bool isMuteNotificationsSwitched = false;
  bool isLoading=false;
  String fcmToken;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    // _firebaseMessaging.getToken().then((token) {
    //   setState(() {
    //     fcmToken = token;
    //     getMemberPreferences();
    //   });
    //   print("Preference Screen");
    //   print('FCM----------->' + '${token}');
    // });
  }

  void toggleEmailSwitch(bool value) {
    if (isEmailSwitched == false) {
      setState(() {
        isEmailSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isEmailSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void toggleContactSwitch(bool value) {
    if (isContactSwitched == false) {
      setState(() {
        isContactSwitched = true;
      });
      print('Switch Button is ON');
      setMemberPreferences();
    } else {
      setState(() {
        isContactSwitched = false;
      });
      print('Switch Button is OFF');
      setMemberPreferences();
    }
  }

  void toggleDOBSwitch(bool value) {
    if (isDOBSwitched == false) {
      setState(() {
        isDOBSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isDOBSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void toggleAnniversarySwitch(bool value) {
    if (isAnniversarySwitched == false) {
      setState(() {
        isAnniversarySwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isAnniversarySwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void toggleMuteNotificationSwitch(bool value) {
    if (isMuteNotificationsSwitched == false) {
      setState(() {
        isMuteNotificationsSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isMuteNotificationsSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  getMemberPreferences() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId=prefs.getString(constant.Session.Member_Id);
        var data = {
          "memberId": memberId,
          "fcmToken": fcmToken
        };
        Services.responseHandler(apiName: "member/getMemberPreferences",body: data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != null && data.Data.length  > 0) {
            setState(() {
              isEmailSwitched = data.Data[0]["Private"]["EmailId"];
              isContactSwitched = data.Data[0]["Private"]["ContactNo"];
              isDOBSwitched = data.Data[0]["Private"]["DOB"];
              isAnniversarySwitched = data.Data[0]["Private"]["AnniversaryDate"];
              isMuteNotificationsSwitched = data.Data[0]["MemberTokens"][0]["muteNotificationAudio"];
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

  setMemberPreferences() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // setState(() {
        //   isLoading = true;
        // });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId=prefs.getString(constant.Session.Member_Id);
        var data = {
          "memberId": memberId,
          "muteNotificationAudio": isMuteNotificationsSwitched,
          "fcmToken": fcmToken,
        "Email": isEmailSwitched,
          "Contact": isContactSwitched,
          "DateOfBirth": isDOBSwitched,
          "AnniversaryDate": isAnniversarySwitched
        };
        Services.responseHandler(apiName: "member/setMemberPreferences",body: data).then((data) async {
          // setState(() {
          //   isLoading = false;
          // });
          if (data.Data != null && data.Data==1) {
            // showHHMsg("Data Updated", "");
          } else {
            // setState(() {
            //   isLoading = false;
            // });
          }
        }, onError: (e) {
          // setState(() {
          //   isLoading = false;
          // });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          'Preference',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: isLoading==false?SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
          child: Column(
            children: [
              /*Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                              //fontWeight: FontWeight.bold
                              ),
                        ),
                        Text(
                          "Choose to Show Email",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                      scale: 1.3,
                      child: Switch(
                        onChanged: toggleEmailSwitch,
                        value: isEmailSwitched,

                        activeColor: appPrimaryMaterialColor,
                        activeTrackColor: appPrimaryMaterialColor[200],

                        // inactiveThumbColor: Colors.redAccent,
                        // inactiveTrackColor: Colors.orange,
                      )),
                ],
              ),*/
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Hide Contact Details",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleContactSwitch,
                          value: isContactSwitched,

                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],

                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        )),
                  ],
                ),
              ),
/*              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of Birth",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Show Date of Birth",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleDOBSwitch,
                          value: isDOBSwitched,

                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],

                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Anniversary",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Show Anniversary",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleAnniversarySwitch,
                          value: isAnniversarySwitched,

                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],

                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Mute Notifications",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleMuteNotificationSwitch,
                          value: isMuteNotificationsSwitched,
                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],
                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        ),
                    ),
                  ],
                ),
              ),*/
              SizedBox(height: 10,),
              // RaisedButton(
              //   child: Text(
              //     'Update',
              //     style: TextStyle(
              //       color: Colors.white,
              //     ),
              //   ),
              //   color: appPrimaryMaterialColor,
              //   onPressed: (){
              //     print('Update Preferences Clicked');
              //     setMemberPreferences();
              //   },
              // ),
            ],
          ),
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
