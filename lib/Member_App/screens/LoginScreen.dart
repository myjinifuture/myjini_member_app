import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart' as cnst;
import 'package:smart_society_new/Mall_App/Common/services.dart' as serv;
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/HomeScreen.dart';
import 'package:smart_society_new/Member_App/screens/OtpScreen.dart';
import '../common/Services.dart';
import 'OTP.dart';

class LoginScreen extends StatefulWidget {
  String playerId ;
  String PlayId;
  GlobalKey<NavigatorState> navigatorKey;
  LoginScreen({this.playerId,this.navigatorKey,this.PlayId});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //var player_Id = widget.playerId;
  TextEditingController _MobileNumber = new TextEditingController();
  bool isLoading = false;
  ProgressDialog pr;
  List logindata = [];
  List mallLoginList = [];

  bool isFCMtokenLoading = false;
  bool isMemberRegistered = false;
  String fcmToken;
  bool isButtonPressed = false;

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    print("playerId at login screen=======");
    print(widget.PlayId);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    // getOTPStatus();
    initPlatformState();
    // _firebaseMessaging.getToken().then((token) {
    //   setState(() {
    //     fcmToken = token;
    //   });
    //   print('----------->' + '${token}');
    // });

    getPermissionStatus();
  }

  String _platformImei = 'Unknown';
  String uniqueId = "";
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
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
    print("_platformImei");
    print(_platformImei);
  }

  void getPermissionStatus() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera);
    if (permission == PermissionStatus.granted) {
    } // ideally you should specify another condition if permissions is denied
    else if (permission == PermissionStatus.denied  ||
        permission == PermissionStatus.restricted) {
      // await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      // getPermissionStatus();
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  mallLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        cnst.Session.customerId, mallLoginList[0]["CustomerId"].toString());
    await prefs.setString(
        cnst.Session.CustomerName, mallLoginList[0]["CustomerName"]);
    await prefs.setString(
        cnst.Session.CustomerEmailId, mallLoginList[0]["CustomerEmailId"]);
    await prefs.setString(
        cnst.Session.CustomerPhoneNo, mallLoginList[0]["CustomerPhoneNo"]);
  }

  localdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        constant.Session.session_login, logindata[0]["ContactNo"].toString());
    await prefs.setString(
        constant.Session.Member_Id, logindata[0]["_id"].toString());
    await prefs.setString(
        constant.Session.SocietyId, logindata[0]["society"]["societyId"].toString());
    await prefs.setString(
        constant.Session.IsVerified, logindata[0]["isVerify"].toString());
    // await prefs.setString(
    //     constant.Session.Profile, logindata[0]["Image"].toString());
    await prefs.setString(constant.Session.ResidenceType,
        logindata[0]["society"]["ResidenceType"].toString());
    await prefs.setString(
        constant.Session.FlatNo, logindata[0]["FlatNo"].toString());
    await prefs.setString(
        constant.Session.Name, logindata[0]["Name"].toString());
    await prefs.setString(
        constant.Session.CompanyName, logindata[0]["CompanyName"].toString());
    await prefs.setString(
        constant.Session.Designation, logindata[0]["Designation"].toString());
    await prefs.setString(constant.Session.BusinessDescription,
        logindata[0]["BusinessDescription"].toString());
    await prefs.setString(
        constant.Session.BloodGroup, logindata[0]["BloodGroup"].toString());
    await prefs.setString(
        constant.Session.Gender, logindata[0]["Gender"].toString());
    await prefs.setString(constant.Session.DOB, logindata[0]["DOB"].toString());
    await prefs.setString(constant.Session.societyName, logindata[0]["SocietyData"][0]["Name"].toString());
    await prefs.setString(
        constant.Session.Address, logindata[0]["SocietyData"][0]["Address"].toString());
    await prefs.setString(
        constant.Session.Wing, logindata[0]["WingData"][0]["wingName"].toString());
    await prefs.setString(
       constant.Session.FlatNo,logindata[0]["FlatData"][0]["flatNo"].toString());

    await prefs.setString(
        constant.Session.isPrivate, logindata[0]["IsPrivate"].toString());
/*    await prefs.setString(
        constant.Session.Wing, logindata[0]["Wing"].toString());*/
    await prefs.setString(
        constant.Session.WingId, logindata[0]["society"]["wingId"].toString());
    await prefs.setString(
       constant.Session.FlatId, logindata[0]["society"]["flatId"].toString());
    await prefs.setString(
        constant.Session.SocietyCode, logindata[0]["SocietyData"][0]["societyCode"].toString());
    await prefs.setString(
        constant.Session.mapLink, logindata[0]["SocietyData"][0]["Location"]["mapLink"].toString());

/*    await prefs.setString(
        constant.Session.ParentId, logindata[0]["ParentId"].toString());*/

  }

  _checkLogin({bool isMemberRegistered}) async {
    print("value of multiple society");
    print(multipleSociety);
    if (_MobileNumber.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
          pr.style(message: 'Signing In...');
          // pr.show();
          var data;
          multipleSociety == true ?
          data = {
            "MobileNo" : _MobileNumber.text,
            // "fcmToken" : fcmToken,
            "DeviceType" : Platform.isAndroid ? "Android" : "IOS",
            "playerId" : widget.playerId.toString(),
            "IMEI" : uniqueId,
            "societyId" : selectedSocietyId,
          }:data = {
            "MobileNo" : _MobileNumber.text,
            // "fcmToken" : fcmToken,
            "playerId" : widget.PlayId.toString(),
            "IMEI" : uniqueId,
            "DeviceType" : Platform.isAndroid ? "Android" : "IOS",
          };

          print("print Data ............................");
          print(data);
          Services.responseHandler(apiName: "member/login",body: data).then((data) async {
            // pr.hide();
            print(data.Message);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (data.Data != null && data.Data.length > 0) {
              setState(() {
                logindata = data.Data;
                print("logindata+++++++++++++++++");
                print(logindata);
              });
              for(int i=0;i<logindata.length;i++){
                if(logindata[i]["society"]["isVerify"].toString() == "true") {
                  print("isMemberRegistered");
                  print(isMemberRegistered);
                  if(isMemberRegistered!=null){
                    _getMemberSociety(_MobileNumber.text);
                  }
                  else {
                    await localdata();
                    Navigator.pushAndRemoveUntil(context,
                        SlideLeftRoute(page: HomeScreen(isAppOpenedAfterNotification: false,)), (route) => false);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (
                    //           context) =>
                    //           OTP(
                    //             mobileNo: _MobileNumber
                    //                 .text
                    //                 .toString(),
                    //             onSuccess: () async {
                    //               await localdata();
                    //               Navigator.pushAndRemoveUntil(context,
                    //                   SlideLeftRoute(page: HomeScreen(isAppOpenedAfterNotification: false,)), (route) => false);                                },
                    //           ),
                    //     ));
                  }
                  // _MallLoginApi();
                }
                else{
                  setState(() {
                    isMemberRegistered = false;
                  });
                  Fluttertoast.showToast(
                      msg: "Please wait for admin approval for society ${logindata[i]["SocietyData"][0]["Name"]}",
                      toastLength: Toast.LENGTH_LONG,
                      textColor: Colors.white,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.red);
                }
              }
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/HomeScreen', (Route<dynamic> route) => false);
            } else {
              setState(() {
                isMemberRegistered = false;
              });
              Fluttertoast.showToast(
                  msg: "${data.Message}",
                  toastLength: Toast.LENGTH_LONG,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.red);
            }
          }, onError: (e) {
            // pr.hide();
            showHHMsg("Try Again.", "");
          });
        } else {
          setState(() {
            isLoading = false;
            // pr.hide();
          });
          showHHMsg("No Internet Connection.", "");
        }
      } on SocketException catch (_) {
        // pr.hide();
        showHHMsg("No Internet Connection.", "");
      }
    } else
      Fluttertoast.showToast(
          msg: "Enter Your Mobile Number",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
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

  _MallLoginApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();

        FormData body = FormData.fromMap({
          "CustomerPhoneNo": _MobileNumber.text,
          "CutomerFCMToken": "${fcmToken}"
        });
        serv.Services.postforlist(apiname: 'signIn', body: body).then(
                (responseList) async {
              if (responseList.length > 0) {
                setState(() {
                  mallLoginList = responseList;
                  mallLocalData();
                });
                // mallLocalData();
              } else {
                setState(() {
                  isLoading = false;
                });
                Fluttertoast.showToast(msg: "Data Not Found");
                //show "data not found" in dialog
              }
            }, onError: (e) {
          // setState(() {
          //   isLoading = false;
          // });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  shareprefrenceData() async {

  }

  String selSociety,societyId,selectedSocietyId="";
  List societyNames = [];
  List societyData = [];
  bool mobileNumberRegistered = false;
  bool multipleSociety = false;

  bool isMobileNumberRegistered = true;
  _getMemberSociety(String mobileNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
        pr.style(message: 'Checking Mobile Number...');
        // pr.show();
        var data = {
          "MobileNo" : mobileNo
        };
        setState(() {
          isLoading = true;
        });
        Services.responseHandler(apiName: "member/getMemberSociety",body: data).then((data) async {
          // pr.hide();
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              print("data.data");
              print(data.Data);
              isMobileNumberRegistered = true;
              mobileNumberRegistered = true;
              data.Data.toSet().toList();
              for(int i=0;i<data.Data.length;i++){
                for(int j=0;j<data.Data[i]["SocietyData"].length;j++) {
                  if(!societyNames.contains(data.Data[i]["SocietyData"][j]["Name"])) {
                    societyNames.add(data.Data[i]["SocietyData"][j]["Name"]);
                    societyData.add(data.Data[i]["SocietyData"][j]);
                  }
                }
              }
              societyNames.toSet().toList();
              societyData.toSet().toList();
              isLoading = false;
              print("societyNames");
              print(societyNames.length);
              print("societyData");
              print(societyData.length);
            });
            if(data.Data.length > 1){
              setState(() {
                multipleSociety = true;
                isLoading = false;
              });
            }
            else if(data.Data.length == 1){
              setState(() {
                isLoading = false;
                isMemberRegistered = true;
                isButtonPressed = true;
              });
              _checkLogin();
            }
          } else {
            setState(() {
              isMemberRegistered = false;
              isLoading = false;
              isMobileNumberRegistered = false;
              Fluttertoast.showToast(
                msg: "This mobile number is not registered",
                backgroundColor: Colors.red,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
              );
            },
            );
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

  var playerId;
  void _handleSendNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    playerId = status.subscriptionStatus.userId;
    print("playerid");
    print(playerId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height*0.26,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('images/applogo.png',
                                        width: 90, height: 90),
                                  ],
                                ),
                              ),
                              Text("Welcome User",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: constant.appPrimaryMaterialColor)),
                              Text("Login with Mobile Number to Continue",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: constant.appPrimaryMaterialColor)),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
//                  Text(
//                    "Welcome to,\nMy Genie",
//                    style: TextStyle(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 24,
//                        color: Color.fromRGBO(81, 92, 111, 1)),
//                  ),
                              SizedBox(height: MediaQuery.of(context).size.height*0.3,),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4.0, right: 8.0, ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 50,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: TextFormField(
                                                textInputAction:
                                                TextInputAction.done,
                                                controller: _MobileNumber,
                                                maxLength: 10,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: constant.appPrimaryMaterialColor[600],
                                                    ),
                                                  ),
                                                  border: new OutlineInputBorder(
                                                    borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                    borderSide: new BorderSide(),
                                                  ),
                                                  hintText: "Your Mobile Number",
                                                  hintStyle: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                onChanged: (String val){
                                                  if(val.length==10){
                                                    societyNames.clear();
                                                    selSociety = null;
                                                    _handleSendNotification();
                                                    // _getMemberSociety(_MobileNumber.text);
                                                    _checkLogin(isMemberRegistered:isMemberRegistered);
                                                  }
                                                  else{
                                                    setState(() {
                                                      multipleSociety = false;
                                                      isButtonPressed = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          multipleSociety ? Padding(
                                            padding: const EdgeInsets.only(top: 8.0, right: 2,left: 10),
                                            child: SizedBox(
                                              height: 50,
                                              child: DropdownButton(
                                                hint: Text('Select Your Society'),
                                                value: selSociety,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                onChanged: (newValue) async{
                                                  SharedPreferences  prefs = await SharedPreferences.getInstance(); 
                                                  print("soceityename");
                                                  print(societyNames);
                                                  print(newValue);
                                                  print("societyData");
                                                  print(societyData);
                                                  prefs.setString(constant.Session.SocietyCommunityCode,societyData[0]["societyCode"]); 
                                                  print("print socitey....Community++++");
                                                  
                                                  print(prefs.getString(constant.Session.SocietyCommunityCode));
                                                  print("societyNames");
                                                  print(societyNames);

                                                  for(int i=0;i<societyData.length;i++){
                                                    // for(int j=0;j<societyNames.length;j++) {
                                                    if (societyData[i]["Name"].toString() ==
                                                        newValue.toString()) {
                                                      selectedSocietyId =
                                                          societyData[i]["_id"]
                                                              .toString();
                                                    }
                                                    // }
                                                  }
                                                  print("selectedSocietyId");
                                                  print(selectedSocietyId);
                                                  setState(() {
                                                    selSociety = newValue;
                                                    isMemberRegistered = true;
                                                    isButtonPressed = true;
                                                  });
                                                  _checkLogin();
                                                },
                                                isExpanded: true,
                                                items: societyNames.map((val) {
                                                  print(societyNames);
                                                  if(societyNames.length==1){
                                                    setState(() {
                                                      selSociety = societyNames[0];
                                                    });
                                                  }
                                                  return DropdownMenuItem(
                                                    child: Text(val),
                                                    value: val,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ):Container(),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   height: 45,
                                    //   // child: RaisedButton(
                                    //   //   shape: RoundedRectangleBorder(
                                    //   //       borderRadius:
                                    //   //       BorderRadius.circular(5)),
                                    //   //   color: constant.appPrimaryMaterialColor[500],
                                    //   //   textColor: Colors.white,
                                    //   //   splashColor: Colors.white,
                                    //   //   child: isButtonPressed ?
                                    //   //   Center(
                                    //   //     child: Padding(
                                    //   //       padding: const EdgeInsets.all(3.0),
                                    //   //       child: CircularProgressIndicator(
                                    //   //         valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                    //   //         strokeWidth: 5,
                                    //   //       ),
                                    //   //     ),
                                    //   //   ):
                                    //   //   Text(
                                    //   //       "Login",
                                    //   //       style: TextStyle(
                                    //   //           fontSize: 18,
                                    //   //           fontWeight: FontWeight.w600,
                                    //   //       ),
                                    //   //   ),
                                    //   //   onPressed: isMemberRegistered ? () {
                                    //   //     setState(() {
                                    //   //       isButtonPressed = true;
                                    //   //     });
                                    //   //       if (isMobileNumberRegistered) {
                                    //   //         if (selSociety == null &&
                                    //   //             multipleSociety ==
                                    //   //                 true) {
                                    //   //           Fluttertoast.showToast(
                                    //   //               msg: "Please Select Society",
                                    //   //               backgroundColor: Colors
                                    //   //                   .red,
                                    //   //               gravity: ToastGravity
                                    //   //                   .BOTTOM,
                                    //   //               textColor: Colors
                                    //   //                   .white);
                                    //   //         }
                                    //   //         else if (
                                    //   //         _MobileNumber.text !=
                                    //   //             '' && isMemberRegistered) {
                                    //   //           print("called");
                                    //   //           // _checkLogin();
                                    //   //           // Navigator.push(
                                    //   //           //     context,
                                    //   //           //     MaterialPageRoute(
                                    //   //           //       builder: (
                                    //   //           //           context) =>
                                    //   //           //           OTP(
                                    //   //           //             mobileNo: _MobileNumber
                                    //   //           //                 .text
                                    //   //           //                 .toString(),
                                    //   //           //             onSuccess: () {
                                    //   //           //               _checkLogin();
                                    //   //           //             },
                                    //   //           //           ),
                                    //   //           //     ));
                                    //   //         }
                                    //   //         else {
                                    //   //           Fluttertoast.showToast(
                                    //   //             msg: "Please Enter Mobile Number",
                                    //   //             backgroundColor: Colors
                                    //   //                 .red,
                                    //   //             gravity: ToastGravity
                                    //   //                 .BOTTOM,
                                    //   //             textColor: Colors
                                    //   //                 .white,
                                    //   //           );
                                    //   //         }
                                    //   //       }
                                    //   //   }:null,
                                    //   // ),
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Don't Have an Account?"),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/RegisterScreen');
                                      },
                                      child: Text("Register",
                                        style: TextStyle(
                                          color: constant
                                              .appPrimaryMaterialColor[700],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}