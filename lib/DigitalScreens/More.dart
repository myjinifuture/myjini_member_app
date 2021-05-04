import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/DigitalCommon/Constants.dart';
import 'package:smart_society_new/DigitalComponent/HeaderComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:unique_identifier/unique_identifier.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  String MemberId = "";

  @override
  void initState() {
    super.initState();
    _getLocalData();
    initPlatformState();
    _handleSendNotification();
    GetProfileData();
  }

  var playerId;
  void _handleSendNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    playerId = status.subscriptionStatus.userId;
    print("playerid while logout");
    print(playerId);
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
    String  identifier =await UniqueIdentifier.serial;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      uniqueId = identifier;
    });
    print("uniqueid");
    print(identifier);
  }

  String societyId, memberId;

  _getLocalData() async {
    print("local data called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      societyId = prefs.getString(cnst.Session.SocietyId);
      memberId = prefs.getString(cnst.Session.Member_Id);
    });
  }
  GetProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.digital_Id);
    setState(() {
      MemberId = memberId;
    });
  }

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
                Navigator.of(context).pop();;
              },
            ),
          ],
        );
      },
    );
  }

  _logoutFunction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "memberId" : memberId,
          "playerId" : playerId,
          "IMEI" : uniqueId
        };
        print("data");
        print(data);
        Services.responseHandler(apiName: "member/logout", body: data)
            .then((data) async {
          if (data.Data != null && data.Data.toString() == "1") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushReplacementNamed(context, "/Login");
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

  _logout() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Are you want to Logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: appMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();;
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: appMaterialColor),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                _logoutFunction();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/MobileLogin', (Route<dynamic> route) => false);
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            HeaderComponent(
              title: "More Options",
              image: "images/moreheader.jpg",
              boxheight: 110,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 170,
              margin: EdgeInsets.only(top: 120),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/InviteFriends");
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/refer.png",
                                  height: 50, width: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Refer & Earn",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),*/
                    GestureDetector(
                      onTap: () async {
                        /*SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove(Session.digital_Id);
                        prefs.remove(cnst.Session.Name);
                        prefs.remove(cnst.Session.Mobile);
                        prefs.remove(cnst.Session.Company);
                        Navigator.pushReplacementNamed(context, "/MobileLogin");*/
                        /*String withrefercode = cnst.inviteFriMsg
                                  .replaceAll("#refercode", ReferCode);*/
                        /*String withappurl = cnst.inviteFriMsg.replaceAll(
                            "#appurl", cnst.playstoreUrl);
                        */ /*String withmemberid =
                              cnst.inviteFriMsg.replaceAll("#id", MemberId);*/ /*
                        */ /*String withrefercode = cnst.inviteFriMsg
                                  .replaceAll("#refercode", ReferCode);*/

                        String withappurl =
                            inviteFriMsg.replaceAll("#appurl", playstoreUrl);
                        String withmemberid =
                            withappurl.replaceAll("#id", MemberId);
                        Share.share(withmemberid);
                        Share.share(withappurl);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/logo1.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Invite a Friend",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/ShareHistory"),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/refer.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Share History",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/AddCard"),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/logo1.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Make New Card",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/ChangeTheme"),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/logo1.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Theme",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        _logout();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.power_settings_new, size: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Logout",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
