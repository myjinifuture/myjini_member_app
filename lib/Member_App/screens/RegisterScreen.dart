import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart' as cnst;
import 'package:smart_society_new/Mall_App/Common/services.dart' as serv;
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/LoginScreen.dart';

import 'HomeScreen.dart';
import 'OTP.dart';

class RegisterScreen extends StatefulWidget {

  String Name,mobileNo,societyCode,societyId,societyNameAndSocietyAddress,type;

  RegisterScreen({this.Name,this.mobileNo,this.societyCode,this.societyId,this.societyNameAndSocietyAddress,this.type});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> _residentTypeList = ["Rented", "Owner", "Owned"];

  bool isPersonAdmin = false;
  int selected_Index;
  bool isLoading = false, verify = false, valid = false;
  String SocietyId = "";
  String selFlatHolderType = 'Select Residence Type';
  String selYourSociety;
  bool _WingLoading = false;

  List wingList = [],flatList = [],copyOfFlatList = [];
  String selectedWing,selectedFlat;

  List flatholdertypes=[],winglistClassList = [];

  ProgressDialog pr;

  String Gender = "";

  TextEditingController CodeControler = new TextEditingController();
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtFlatNo = new TextEditingController();
  TextEditingController txtMySociety = new TextEditingController();

  final FocusNode _Name = FocusNode();
  final FocusNode _Mobile = FocusNode();

  String codeValue = "";
  bool isFCMtokenLoading = false;
  String fcmToken;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool buttonPressed = false;
  bool isFlatSelected = false;

  @override
  void initState() {
    print("widget.societyId");
    print(widget.societyId);
    getAllSocieties();
    flatholdertypes.clear();
    if(widget.mobileNo!=null){
      isPersonAdmin = true;
      txtname.text = widget.Name;
      txtmobile.text = widget.mobileNo;
      selYourSociety = widget.societyNameAndSocietyAddress;
      print(widget.Name);
    }
    getFlatType();

    // FocusScope.of(context)
    //     .requestFocus(FocusNode());
    _CodeVerification(widget.societyCode);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  getFlatType() async {
    flatholdertypes.clear();
    flatholdertypes.add("Owner");
    flatholdertypes.add("Closed");
    flatholdertypes.add("Rent");
    flatholdertypes.add("Dead");
    flatholdertypes.add("Shop");
    print("flatholdertypes");
    print(flatholdertypes);
  }

  _CodeVerification(String code) async {
      try {
        setState(() {
          CodeControler.text = code;
        });
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          var data = {
            "societyCode": code
          };
          Services.responseHandler(apiName: "member/getSocietyDetails",body: data).then((data) async {
            setState(() {
              isLoading = false;
            });
            if (data.IsSuccess == true && data.Data.length > 0) {
              setState(() {
                verify = true;
                SocietyId = data.Data["Society"][0]["_id"];
                valid = true;
                for(int i=0;i<data.Data["Wings"].length;i++){
                  wingList.add(data.Data["Wings"][i]);
                }
              });
              print("wingList");
              print(wingList);
            } else {
              setState(() {
                valid = false;
              });
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showHHMsg("Something Went Wrong", "Error");
          });
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
  }

  List<DropdownMenuItem> allSocieties = [];
  List societyData = [];

  getAllSocieties() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {};
        setState(() {
          isLoading = true;
        });
        print("this functon called");
        allSocieties.clear();
        Services.responseHandler(apiName: "masterAdmin/getSocietyList",body: data).then((data) async {
          print(data.Data);
          if (data.Data.length > 0) {
            setState(() {
              for(int i=0;i<data.Data.length;i++){
                if(!allSocieties.contains(DropdownMenuItem(
                  child: Column(
                    children: [
                      Text(data.Data[i]["Name"]+" ,"+data.Data[i]["Address"]),
                      Padding(
                        padding: const EdgeInsets.only(top:12.0),
                        child: Container(
                          color: Colors.black,
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                  value: data.Data[i]["Name"]+" ,"+data.Data[i]["Address"],
                ))) {
                  allSocieties.add(DropdownMenuItem(
                    child: Column(
                      children: [
                        Text(data.Data[i]["Name"] + " ," +
                            data.Data[i]["Address"]),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            color: Colors.black,
                            height: 0.5,
                          ),
                        ),
                      ],
                    ),
                    value: data.Data[i]["Name"] + " ," +
                        data.Data[i]["Address"],
                  ));
                }
                // allSocieties.add(data.Data[i]["Address"]);
              }
              isLoading = false;
              societyData = data.Data;
            });
          } else {
            print("else called");
            Fluttertoast.showToast(
              msg: "No Society Found",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              textColor: Colors.white,
            );
            // setState(() {
            //   isLoading = false;
            //   // allSocieties = data.Data;
            // });
          }
        }, onError: (e) {
          // showHHMsg("Something Went Wrong.\nPlease Try Again","");
          Fluttertoast.showToast(
            msg: "No Society Found",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            textColor: Colors.white,
          );
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.","");
    }
  }

/*
  _checkNumber(String mobileNo,String societyId) async {
    if (CodeControler.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // pr.show();
          var data = {
            "MobileNo": txtmobile.text,
          };
          Services.responseHandler(apiName: "member/addMember",body: data).then((data) async {
            setState(() {
              isLoading = false;
            });
            // pr.hide();
            if (data.Data.length == 0) {
              print("old number");
              setState(() {
                Fluttertoast.showToast(
                    msg: "Mobile Number Already Exist Please Login",
                    toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white,
                );
              });
            } else {
              print("new number");
              _Registration();
              */
/*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTP(
                      mobileNo: txtmobile.text.toString(),
                      onSuccess: () => _Registration(),
                    ),
                  ),
              );*//*
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showHHMsg("Something Went Wrong", "Error");
          });
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
    }
  }
*/

  getFlats(String SocietyId,String wingId) async {
    if (CodeControler.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // pr.show();
          var data = {
            "societyId" : SocietyId,
            "wingId" : wingId
          };
          copyOfFlatList.clear();
          Services.responseHandler(apiName: "admin/getFlatsOfSociety_v1",body: data).then((data) async {
            setState(() {
              isLoading = false;
            });
            // pr.hide();
            if (data.Data.length == 0) {
              setState(() {
                Fluttertoast.showToast(
                  msg: "No Flats Available",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white,
                );
              });
            } else {
              setState(() {
                // for(int i=0;i<data.Data.length;i++){
                //   if(!flatList.contains(data.Data[i])) {
                //   }
                // }
                for(int i=0;i<data.Data.length;i++){
                  if(!copyOfFlatList.contains(data.Data[i]["flatNo"])) {
                    copyOfFlatList.add(data.Data[i]["flatNo"]);
                    flatList.add(data.Data[i]);
                  }
                }

              });
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showHHMsg("Something Went Wrong", "Error");
          });
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
    }
  }

/*
  _WingListData(String SocietyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "societyId" : SocietyId
        };
        setState(() {
          _WingLoading = true;
        });
        Services.responseHandler(apiName: "admin/getAllWingOfSociety",body: data).then((data) async {
          if (data.Data != null && data.Data.length > 0) {
            setState(() {
              _WingLoading = false;
              _winglist = data.Data;
            });
          } else {
            setState(() {
              _WingLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _WingLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _WingLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }
*/

/*
  _OnWingSelect(val) {
    setState(() {
      print(val.WingName);
      _wingClass = val;
    });
    print("_wingClass");
    print(_wingClass.WingId);
  }
*/

  String selectedWingId,selectedFlatId;
  String residenceType;
  _Registration({bool isPersonAdmin}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        String gen = Gender;
        if (Gender == "") {
          gen = "Male";
        }
        for(int i=0;i<wingList.length;i++){
          if(selectedWing==wingList[i]["wingName"]){
            selectedWingId = wingList[i]["_id"];
          }
        }
        for(int i=0;i<flatList.length;i++){
          if(selectedFlat==flatList[i]["flatNo"]){
            selectedFlatId = flatList[i]["_id"];
          }
        }
        if(selFlatHolderType=="Owner"){
          residenceType = "0";
        }
        if(selFlatHolderType=="Closed"){
          residenceType = "1";
        }
        if(selFlatHolderType=="Rent"){
          residenceType = "2";
        }
        if(selFlatHolderType=="Dead"){
          residenceType = "3";
        }

        if(selFlatHolderType=="Shop"){
          residenceType = "4";
        }
        print("societyid inside registration");
        print(SocietyId);

        print(fcmToken);

        var data;
         data = {
          'Name': txtname.text.trim(),
          'MobileNo': txtmobile.text.trim(),
          'ResidenceType': residenceType,
          'Gender': gen.toLowerCase(),
          "deviceType" : Platform.isAndroid ? "Android" : "IOS",
          'societyCode': CodeControler.text,
          'wingId': selectedWingId,
          'flatId': selectedFlatId,
          "fcmToken" : fcmToken,
        };
        print(data);
        Services.responseHandler(apiName: "member/addMember",body: data).then((data) async {
          // pr.hide();
          if(data.Data.length > 0 ) {
            prefs.setString(constant.Session.selFlatHolderType, selFlatHolderType);
            // showHHMsg("Registration Successfully", "");
            Fluttertoast.showToast(
                msg: "Registration Successfully",
                toastLength: Toast.LENGTH_LONG,
            );
            // _Mallregistration();
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/LoginScreen', (route) => false);
            _checkLogin(widget.mobileNo,isPersonAdmin: isPersonAdmin);
          } else {
            showHHMsg("Mobile Number Already Exist !", "");
            // pr.hide();
          }
        }, onError: (e) {
          // pr.hide();
          showHHMsg("Try Again.", "");
        });
      }
      //===========================
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  //by rinki for registration for mall app

  saveDataToSession(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        cnst.Session.customerId, data["CustomerId"].toString());
    await prefs.setString(cnst.Session.CustomerName, data["CustomerName"]);
    await prefs.setString(
        cnst.Session.CustomerEmailId, data["CustomerEmailId"]);
    await prefs.setString(
        cnst.Session.CustomerPhoneNo, data["CustomerPhoneNo"]);
  }

  _Mallregistration() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        FormData body = FormData.fromMap({
          "CustomerName": txtname.text,
          "CustomerEmailId": "",
          "CustomerPhoneNo": txtmobile.text.toString(),
          "CutomerFCMToken": "${fcmToken}"
        });
        serv.Services.postforlist(apiname: 'addCustomer', body: body).then(
                (responselist) async {
              if (responselist.length > 0) {
                saveDataToSession(responselist[0]);
              } else {
                Fluttertoast.showToast(msg: " Registration fail");
              }
            }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
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
                Navigator.pushReplacementNamed(context, "/LoginScreen");
              },
            ),
          ],
        );
      },
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // _getWingsBySocietyId() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty && CodeControler.text!="") {
  //       Future res = Services.GetWingsBySocietyId(CodeControler.text.toString());
  //       res.then((data) async {
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             winglistClassList = data;
  //           });
  //           for(int i=0;i<winglistClassList.length;i++){
  //           }
  //           print("servicelisttt=> " + winglistClassList.toString());
  //         }
  //       }, onError: (e) {
  //         showHHMsg("$e","");
  //         // setState(() {
  //         //   winglistLoading = false;
  //         // });
  //       });
  //     } else {
  //       showHHMsg("No Internet Connection.","");
  //     }
  //   } on SocketException catch (_) {
  //     showHHMsg("Something Went Wrong","");
  //     // setState(() {
  //     //   winglistLoading = false;
  //     // });
  //   }
  // }

  List logindata = [];
  List mallLoginList = [];
  String sendOTP;

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
        constant.Session.IsVerified, logindata[0]["society"]["isVerify"].toString());
    await prefs.setString(constant.Session.ResidenceType,
        logindata[0]["society"]["ResidenceType"].toString());
    prefs.getString(constant.Session.SocietyCommunityCode) == "COMMUNITY-461540" ? "": prefs.setString(
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
    await prefs.setString(
        constant.Session.Address, logindata[0]["SocietyData"][0]["Address"].toString());
    await prefs.setString(
        constant.Session.Wing, logindata[0]["WingData"][0]["wingName"].toString());
    await prefs.setString(
        constant.Session.FlatNo, logindata[0]["FlatData"][0]["flatNo"].toString());

    await prefs.setString(
        constant.Session.isPrivate, logindata[0]["isPrivate"].toString());
/*    await prefs.setString(
        constant.Session.Wing, logindata[0]["Wing"].toString());*/
    await prefs.setString(
        constant.Session.WingId, logindata[0]["society"]["wingId"].toString());
    await prefs.setString(
        constant.Session.FlatId, logindata[0]["society"]["flatId"].toString());
    await prefs.setString(
        constant.Session.SocietyCode, logindata[0]["SocietyData"][0]["societyCode"].toString());

/*    await prefs.setString(
        constant.Session.ParentId, logindata[0]["ParentId"].toString());*/

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
          "CustomerPhoneNo": txtmobile.text,
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
                // setState(() {
                //   isLoading = false;
                // });
                // Fluttertoast.showToast(msg: "Data Not Found");
                //show "data not found" in dialog
              }
            }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  bool mobileNoExist = false;
  String dropdownValue;
  bool isContains = false;

  _checkLogin(String mobileNo,{bool isPersonAdmin}) async {
    if (mobileNo != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
          pr.style(message: 'Joining...');
          // pr.show();
          var data;
          data = {
            "MobileNo" : mobileNo,
            "DeviceType" : Platform.isAndroid ? "Android" : "IOS",
            "societyId" : SocietyId
          };
          Services.responseHandler(apiName: "member/login",body: data).then((data) async {
            // pr.hide();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (data.Data != null && data.Data.length > 0) {
              setState(() {
                logindata = data.Data;
              });
              // updateMemberDetails(
              //   logindata[0]["SocietyId"].toString(),
              //   logindata[0]["Name"],Fcom.itfuturz.mygenie_member
              //   _MobileNumber.text,
              //   logindata[0]["FlatNo"],
              //   logindata[0]["WingId"].toString(),
              //   prefs.getString(constant.Session.selFlatHolderType),
              //   logindata[0]["Id"].toString(),
              //   fcmToken
              // );
              if(logindata[0]["society"]["isVerify"].toString() == "true") {
                await localdata();
                // await mallLocalData();
                Navigator.pushAndRemoveUntil(context,
                    SlideLeftRoute(page: HomeScreen()), (route) => false);
                // _MallLoginApi();
              }
              else{
                Fluttertoast.showToast(
                    msg: "${data.Message}",
                    toastLength: Toast.LENGTH_LONG,
                    textColor: Colors.white,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red);
              }
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/HomeScreen', (Route<dynamic> route) => false);
              }
            else {
              Fluttertoast.showToast(
                  msg: "Wait for admin approval",
                  toastLength: Toast.LENGTH_LONG,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.red);
              Navigator.pushReplacementNamed(context, "/LoginScreen");

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

  @override
  Widget build(BuildContext context) {
    print(widget.mobileNo);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/LoginScreen");
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/applogo.png', width: 80, height: 80),
                    Text(
                      "Register Now",
                      style: TextStyle(
                          color: constant.appPrimaryMaterialColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0, top: 10),
                          child: Text(
                            "  Name *",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                focusNode: _Name,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (term) {
                                  _fieldFocusChange(context, _Name, _Mobile);
                                },
                                controller: txtname,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Your Full Name",
                                    hintStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0, top: 15),
                          child: Text(
                            "  Mobile Number *",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                maxLength: 10,
                                textInputAction: TextInputAction.done,
                                focusNode: _Mobile,
                                controller: txtmobile,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Your Mobile Number",
                                    hintStyle: TextStyle(fontSize: 13)),
                                onChanged: (val){
                                  if(widget.mobileNo!=null){
                                    if(val.length < 10) {
                                      setState(() {
                                        widget.mobileNo = null;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0, top: 10),
                          child: Text(
                            "  Gender",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Row(
                        children: <Widget>[
                          Radio(
                              value: 'Male',
                              groupValue: Gender,
                              onChanged: (value) {
                                setState(() {
                                  Gender = value;
                                  print(Gender);
                                });
                              }),
                          Text("Male", style: TextStyle(fontSize: 13)),
                          Radio(
                              value: 'Female',
                              groupValue: Gender,
                              onChanged: (value) {
                                setState(() {
                                  Gender = value;
                                  print(Gender);
                                });
                              }),
                          Text("Female", style: TextStyle(fontSize: 13))
                        ],
                      ),
                    ),
/*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 10,
                        children:
                            List.generate(_residentTypeList.length, (index) {
                          return ChoiceChip(
                            backgroundColor: Colors.grey[200],
                            label: Text(_residentTypeList[index]),
                            selected: selected_Index == index,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selected_Index = index;
                                  print(_residentTypeList[index]);
                                });
                              }
                            },
                          );
                        }),
                      ),
                    ),
*/
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0, top: 10,bottom: 7),
                          child: Text(
                            "  Select Residence Type *",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:16.0,right: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 8.0, top: 6.0),
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                              //isDense: true,
                              hint: new Text(
                                selFlatHolderType,
                                style: TextStyle(fontSize: 14),
                              ),
                              // value: _memberClass,
                              onChanged: (val) {
                                print(val);
                                setState(() {
                                  selFlatHolderType = val;
                                });
                              },
                              //value: selCity,
                              items: flatholdertypes.map<DropdownMenuItem<String>>(
                                      (dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(
                                        value,
                                        style: new TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.type == "Industrial" ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchableDropdown.single(
                        items: allSocieties,
                        value: selYourSociety,
                        hint: "Select Your Industry",
                        searchHint: "Select one",
                        onClear: (){
                          print('hi');
                          print(selYourSociety);
                          if(selYourSociety==null){
                            setState(() {
                              verify = false;
                              wingList.length = 0;
                              CodeControler.text = "";
                              selectedFlat = null;
                            });
                          }
                        },
                        onChanged: (value) {
                          print(value);
                          print(societyData);
                          for(int i=0;i<societyData.length;i++){
                            if(societyData[i]["Name"]+" ,"+societyData[i]["Address"].toString() == value){
                              print("true");
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
                              _CodeVerification(societyData[i]["societyCode"]);
                              break;
                            }
                          }
                          setState(() {
                            selYourSociety = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ) :
                    widget.type == "Commercial" ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchableDropdown.single(
                        items: allSocieties,
                        value: selYourSociety,
                        hint: "Select Your Commercial Area",
                        searchHint: "Select one",
                        onClear: (){
                          print('hi');
                          print(selYourSociety);
                          if(selYourSociety==null){
                            setState(() {
                              verify = false;
                              wingList.length = 0;
                              CodeControler.text = "";
                              selectedFlat = null;
                            });
                          }
                        },
                        onChanged: (value) {
                          print(value);
                          print(societyData);
                          for(int i=0;i<societyData.length;i++){
                            if(societyData[i]["Name"]+" ,"+societyData[i]["Address"].toString() == value){
                              print("true");
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
                              _CodeVerification(societyData[i]["societyCode"]);
                              break;
                            }
                          }
                          setState(() {
                            selYourSociety = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchableDropdown.single(
                        items: allSocieties,
                        value: selYourSociety,
                        hint: "Select Your Society",
                        searchHint: "Select one",
                        onClear: (){
                          print('hi');
                          print(selYourSociety);
                          if(selYourSociety==null){
                            setState(() {
                              verify = false;
                              wingList.length = 0;
                              CodeControler.text = "";
                              selectedFlat = null;
                            });
                          }
                        },
                        onChanged: (value) {
                          print(value);
                          print(societyData);
                          for(int i=0;i<societyData.length;i++){
                            if(societyData[i]["Name"]+" ,"+societyData[i]["Address"].toString() == value){
                              print("true");
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
                              _CodeVerification(societyData[i]["societyCode"]);
                              break;
                            }
                          }
                          setState(() {
                            selYourSociety = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    _WingLoading
                        ? CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                        : wingList.length > 0
                        ? Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 9.0, top: 15),
                              child: Text(
                                " Select Wing *",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, top: 8),
                                child: SizedBox(
                                  width: (MediaQuery.of(context)
                                      .size
                                      .width) /
                                      2,
                                  height: 40,
                                  child: InputDecorator(
                                    decoration: new InputDecoration(
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                          new BorderRadius.circular(
                                              10),
                                          //borderSide: new BorderSide(),
                                        )),
                                    child: DropdownButtonHideUnderline(
                                        child:
                                        DropdownButton<dynamic>(
                                          hint: wingList != null &&
                                              wingList != "" &&
                                              wingList.length > 0
                                              ? Text("Select Wing",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.w600))
                                              : Text(
                                            "Wing Not Found",
                                            style: TextStyle(
                                                fontSize: 14),
                                          ),
                                          value: selectedWing,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedWing = val;
                                            });
                                            for(int i=0;i<wingList.length;i++){
                                              if(selectedWing==wingList[i]["wingName"]){
                                                selectedWingId = wingList[i]["_id"];
                                              }
                                            }
                                            getFlats(SocietyId,selectedWingId);
                                          },
                                          items: wingList
                                              .map((dynamic value) {
                                            return new DropdownMenuItem<
                                                dynamic>(
                                              value: value["wingName"],
                                              child: Text(
                                                value["wingName"],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        )),
                                  ),
                                )),
                          ],
                        )
                      ],
                    )
                        : Container(),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0, top: 15),
                          child: Text(
                            "  Flat No *",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, top: 8),
                            child: SizedBox(
                              width: (MediaQuery.of(context)
                                  .size
                                  .width) /
                                  2,
                              height: 40,
                              child: InputDecorator(
                                decoration: new InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5),
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(
                                          10),
                                      //borderSide: new BorderSide(),
                                    )),
                                child: DropdownButtonHideUnderline(
                                    child:
                                    DropdownButton<dynamic>(
                                      hint: copyOfFlatList != null &&
                                          copyOfFlatList != "" &&
                                          copyOfFlatList.length > 0
                                          ? Text("Select Flat No",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight.w600))
                                          : Text(
                                        "Flat Not Found",
                                        style: TextStyle(
                                            fontSize: 14),
                                      ),
                                      value: selectedFlat,
                                      onChanged: (val) {
                                        setState(() {
                                          isFlatSelected = true;
                                          selectedFlat = val;
                                        });
                                      },
                                      items: copyOfFlatList
                                          .map((dynamic value) {
                                        return new DropdownMenuItem<
                                            dynamic>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                              ),
                            )),
                      ],
                    ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: SizedBox(
                    //           height: 50,
                    //           child: TextFormField(
                    //             controller: txtFlatNo,
                    //             keyboardType: TextInputType.number,
                    //             textCapitalization: TextCapitalization.characters,
                    //             decoration: InputDecoration(
                    //                 border: new OutlineInputBorder(
                    //                   borderRadius:
                    //                       new BorderRadius.circular(5.0),
                    //                   borderSide: new BorderSide(),
                    //                 ),
                    //                 hintText: "Your Flat Number",
                    //                 hintStyle: TextStyle(fontSize: 13)),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    /* Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, left: 8, right: 8, bottom: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: constant.appPrimaryMaterialColor[700],
                          textColor: Colors.white,
                          splashColor: Colors.white,
                          child: Text("Join Your Society",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          onPressed: valid
                              ? () {

//                                Navigator.pushReplacementNamed(
//                                    context, '/LoginScreen');
                                  _Registration();
                                }
                              : null,
                        ),
                      ),
                    ),*/
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: constant.appPrimaryMaterialColor[500],
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            child: buttonPressed ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 5,
                                ),
                              ),
                            ):Text(
                              "Join Your Society",
                              style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed:
                               isFlatSelected ?  () {
                              setState(() {
                                buttonPressed = true;
                              });
                              print(txtname.text);
                              print(txtmobile.text);
                              print(selectedFlat);
                              print(selectedWing);
                              if(txtname.text == "" ||
                                  txtmobile.text == "" ||Gender==''||
                                  selectedFlat == null || selectedWing == null){
                                Fluttertoast.showToast(
                                    msg: "Fields Can't be empty",
                                    backgroundColor: Colors.red,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.white);
                              }
                              else if (!isPersonAdmin){
                                _Registration(isPersonAdmin: isPersonAdmin);
                              }
                              else if (widget.mobileNo != null)
                              {
                                _Registration();
                              }
                              else{
                                _Registration();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //     builder: (context) => OTP(
                                //   mobileNo: txtmobile.text,
                                //   onSuccess: () {
                                //     _Registration();
                                //   },
                                // ),
                                //   ),
                                // );
                              }
//                                Navigator.pushReplacementNamed(
//                                    context, '/LoginScreen');
                            }:null
                          /* onPressed: (){
                          valid
                                ?
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTP(
                                  mobileNo: txtmobile.text,
                                  onSuccess: () {
                                    _checkLogin();
                                  },
                                ),
                              ),\
                            ):null;
                            () {
                               Navigator.pushReplacementNamed(
                                   context, '/LoginScreen');
                                _Registration();
                              }
                          }*/
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: constant.appPrimaryMaterialColor[500],
                          textColor: Colors.white,
                          splashColor: Colors.white,
                          child: Text("Create Your Society",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/CreateSociety');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Aleady Have an Account?"),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/LoginScreen');
                              },
                              child: Text("Login",
                                  style: TextStyle(
                                      color:
                                      constant.appPrimaryMaterialColor[700],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)))
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
    );
  }
}